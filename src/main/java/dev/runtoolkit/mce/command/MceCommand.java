package dev.runtoolkit.mce.command;

import com.mojang.brigadier.CommandDispatcher;
import com.mojang.brigadier.arguments.StringArgumentType;
import com.mojang.brigadier.builder.LiteralArgumentBuilder;
import com.mojang.brigadier.context.CommandContext;
import dev.runtoolkit.mce.MarkerCommandEngine;
import dev.runtoolkit.mce.config.CommandEntry;
import dev.runtoolkit.mce.config.MceConfig;
import dev.runtoolkit.mce.event.MceEventBus;
import dev.runtoolkit.mce.stats.MceStats;
import dev.runtoolkit.mce.util.CommandExecutor;
import net.fabricmc.loader.api.FabricLoader;
import net.minecraft.server.MinecraftServer;
import net.minecraft.server.command.CommandManager;
import net.minecraft.server.command.ServerCommandSource;
import net.minecraft.text.Text;

/**
 * Registers:
 *   /marker-command-engine [subcommand]
 *   /mce                   [subcommand]   <- alias
 *
 * Subcommands:
 *   run <command>        - execute a raw command string (denylist applied; placeholders resolved)
 *   run-id <id|alias>    - execute a named command from commands.json (tab-completed; aliases accepted)
 *   reload               - reload commands.json from disk
 *   list                 - list loaded commands from commands.json
 *   denylist             - show active denylist prefixes/patterns
 *   stats                - show execution statistics for this session
 *   version              - print mod version
 */
public final class MceCommand {

    private MceCommand() {}

    public static void register(
            CommandDispatcher<ServerCommandSource> dispatcher,
            MceConfig config,
            MceEventBus eventBus
    ) {
        LiteralArgumentBuilder<ServerCommandSource> root = buildTree(config, eventBus);

        // Primary command
        dispatcher.register(root);

        // Alias /mce -> same tree
        dispatcher.register(
                CommandManager.literal("mce")
                        .requires(src -> src.hasPermissionLevel(config.getRequireOpLevel()))
                        .redirect(dispatcher.getRoot().getChild("marker-command-engine"))
        );

        MarkerCommandEngine.LOGGER.info("[MCE] Registered /marker-command-engine (/mce)");
    }

    private static LiteralArgumentBuilder<ServerCommandSource> buildTree(MceConfig config, MceEventBus eventBus) {
        return CommandManager.literal("marker-command-engine")
                .requires(src -> src.hasPermissionLevel(config.getRequireOpLevel()))

                // /mce run <command>
                .then(CommandManager.literal("run")
                        .then(CommandManager.argument("command", StringArgumentType.greedyString())
                                .executes(ctx -> executeRun(ctx, config, eventBus))))

                // /mce run-id <id|alias>  -- tab-completed from all IDs + aliases in live config
                .then(CommandManager.literal("run-id")
                        .then(CommandManager.argument("id", StringArgumentType.word())
                                .suggests((ctx, builder) -> {
                                    for (CommandEntry e : config.getCommands()) {
                                        builder.suggest(e.id());
                                        e.aliases().forEach(builder::suggest);
                                    }
                                    return builder.buildFuture();
                                })
                                .executes(ctx -> executeRunId(ctx, config, eventBus))))

                // /mce reload
                .then(CommandManager.literal("reload")
                        .executes(ctx -> executeReload(ctx, config, eventBus)))

                // /mce list
                .then(CommandManager.literal("list")
                        .executes(ctx -> executeList(ctx, config)))

                // /mce denylist
                .then(CommandManager.literal("denylist")
                        .executes(ctx -> executeDenylist(ctx, config)))

                // /mce stats
                .then(CommandManager.literal("stats")
                        .executes(ctx -> executeStats(ctx)))

                // /mce version
                .then(CommandManager.literal("version")
                        .executes(ctx -> executeVersion(ctx)));
    }

    // ── Subcommand handlers ───────────────────────────────────────────────────

    /** /mce run <command> -- run arbitrary command through denylist (placeholders resolved) */
    private static int executeRun(CommandContext<ServerCommandSource> ctx, MceConfig config, MceEventBus eventBus) {
        String command = StringArgumentType.getString(ctx, "command");
        MinecraftServer server = ctx.getSource().getServer();
        boolean ok = CommandExecutor.execute(server, ctx.getSource(), command, true, config, eventBus);
        return ok ? 1 : 0;
    }

    /**
     * /mce run-id <id|alias> -- look up by id OR alias, run all commands in sequence.
     *
     * <p>For multi-command entries, all commands execute in order. Execution stops
     * at the first failure (denylist hit or dispatcher exception).
     */
    private static int executeRunId(CommandContext<ServerCommandSource> ctx, MceConfig config, MceEventBus eventBus) {
        String id = StringArgumentType.getString(ctx, "id");
        MinecraftServer server = ctx.getSource().getServer();

        CommandEntry entry = config.getCommands().stream()
                .filter(e -> e.matchesId(id))
                .findFirst()
                .orElse(null);

        if (entry == null) {
            ctx.getSource().sendFeedback(
                    () -> Text.literal("[MCE] Unknown id or alias: '" + id + "'"),
                    false
            );
            return 0;
        }

        int ran = 0;
        for (String cmd : entry.commands()) {
            boolean ok = CommandExecutor.execute(server, ctx.getSource(), cmd, entry.isConsole(), config, eventBus);
            if (!ok) {
                // Fail fast: a denylist hit or exception in step N aborts the sequence
                final int step = ran + 1;
                ctx.getSource().sendFeedback(
                        () -> Text.literal("[MCE] Sequence aborted at step " + step
                                + " of " + entry.commands().size()),
                        false
                );
                return 0;
            }
            ran++;
        }
        return 1;
    }

    /** /mce reload -- re-parse commands.json */
    private static int executeReload(CommandContext<ServerCommandSource> ctx, MceConfig config, MceEventBus eventBus) {
        config.reload(ctx.getSource().getServer());
        eventBus.fireConfigReloaded();
        ctx.getSource().sendFeedback(
                () -> Text.literal("[MCE] commands.json reloaded. Commands: " + config.getCommands().size()),
                true
        );
        return 1;
    }

    /** /mce list -- list all enabled commands from config, showing aliases and command count */
    private static int executeList(CommandContext<ServerCommandSource> ctx, MceConfig config) {
        var commands = config.getCommands();
        if (commands.isEmpty()) {
            ctx.getSource().sendFeedback(
                    () -> Text.literal("[MCE] No commands defined in commands.json"),
                    false
            );
            return 1;
        }
        ctx.getSource().sendFeedback(
                () -> Text.literal("[MCE] Commands (" + commands.size() + "):"),
                false
        );
        for (CommandEntry e : commands) {
            String aliasStr = e.aliases().isEmpty()
                    ? ""
                    : " [aliases: " + String.join(", ", e.aliases()) + "]";
            String cmdStr = e.commands().size() == 1
                    ? ": " + e.firstCommand()
                    : " [" + e.commands().size() + " cmds]: " + e.firstCommand() + " ...";
            ctx.getSource().sendFeedback(
                    () -> Text.literal("  " + e.id() + aliasStr + " [run_as=" + e.runAs() + "]" + cmdStr),
                    false
            );
        }
        return 1;
    }

    /** /mce denylist -- show active denylist */
    private static int executeDenylist(CommandContext<ServerCommandSource> ctx, MceConfig config) {
        var dl = config.getDenylist();
        ctx.getSource().sendFeedback(
                () -> Text.literal("[MCE] Denylist prefixes (" + dl.prefixes().size() + "):"),
                false
        );
        for (String p : dl.prefixes()) {
            ctx.getSource().sendFeedback(() -> Text.literal("  - " + p), false);
        }
        ctx.getSource().sendFeedback(
                () -> Text.literal("[MCE] Denylist patterns (" + dl.patterns().size() + "):"),
                false
        );
        for (String p : dl.patterns()) {
            ctx.getSource().sendFeedback(() -> Text.literal("  ~ " + p), false);
        }
        return 1;
    }

    /**
     * /mce stats -- display in-session execution statistics.
     * Counters reset on /mce reload.
     */
    private static int executeStats(CommandContext<ServerCommandSource> ctx) {
        MceStats s = MarkerCommandEngine.getStats();
        ctx.getSource().sendFeedback(
                () -> Text.literal("[MCE] Session stats — "
                        + "allowed: "  + s.getAllowed()  + "  "
                        + "denied: "   + s.getDenied()   + "  "
                        + "executed: " + s.getExecuted() + "  "
                        + "failed: "   + s.getFailed()),
                false
        );
        return 1;
    }

    /** /mce version -- read version from fabric.mod.json at runtime */
    private static int executeVersion(CommandContext<ServerCommandSource> ctx) {
        String version = FabricLoader.getInstance()
                .getModContainer(MarkerCommandEngine.MOD_ID)
                .map(c -> c.getMetadata().getVersion().getFriendlyString())
                .orElse("unknown");
        ctx.getSource().sendFeedback(
                () -> Text.literal("[MCE] Marker Command Engine v" + version + " (Fabric, MC 1.20.6)"),
                false
        );
        return 1;
    }
}
