package dev.runtoolkit.mce.util;

import dev.runtoolkit.mce.MarkerCommandEngine;
import dev.runtoolkit.mce.config.MceConfig;
import dev.runtoolkit.mce.event.MceEventBus;
import dev.runtoolkit.mce.storage.StoragePlaceholderResolver;
import net.minecraft.server.MinecraftServer;
import net.minecraft.server.command.ServerCommandSource;
import net.minecraft.text.Text;

/**
 * Executes a command string through the Minecraft server dispatcher after:
 * <ol>
 *   <li>Denylist check on the raw template string</li>
 *   <li>Placeholder resolution ({@code %ns:path="key"%} → storage value)</li>
 *   <li>Denylist re-check on the expanded string (injection protection)</li>
 * </ol>
 *
 * <p>This replaces the datapack command-block tunnel entirely.
 * No marker entities, no forceloaded chunks, no command blocks.
 */
public final class CommandExecutor {

    private CommandExecutor() {}

    /**
     * Run {@code command} on behalf of {@code callerSource}.
     *
     * <p>Execution context:
     * <ul>
     *   <li>If {@code runAsConsole} is true, the command runs with server op-level 4 (console).</li>
     *   <li>Otherwise it runs as {@code callerSource} (preserving the player's permission level).</li>
     * </ul>
     *
     * @param command      Raw command string (with or without leading '/').
     *                     May contain {@code %ns:path="key"%} storage placeholders.
     * @param runAsConsole If true, execute as server console source (op-level 4).
     * @return {@code true} if the command was dispatched without exception; {@code false} if denied or failed.
     */
    public static boolean execute(
            MinecraftServer server,
            ServerCommandSource callerSource,
            String command,
            boolean runAsConsole,
            MceConfig config,
            MceEventBus eventBus
    ) {
        // Strip leading slash for consistency
        String template = command.startsWith("/") ? command.substring(1) : command;

        // Phase 1 — denylist check on the raw template (catches static violations before any I/O)
        String rawDenial = config.getDenylist().denialReason(template);
        if (rawDenial != null) {
            eventBus.fireDenied(callerSource, template, rawDenial);
            callerSource.sendFeedback(
                    () -> Text.literal("[MCE] Command denied: " + rawDenial),
                    false
            );
            MarkerCommandEngine.LOGGER.warn("[MCE] DENIED '{}' for {}: {}",
                    template, callerSource.getName(), rawDenial);
            return false;
        }

        // Phase 2 — resolve %ns:path="key"% storage placeholders
        String expanded = StoragePlaceholderResolver.resolve(template, server);

        // Phase 3 — post-expansion denylist re-check (prevents storage injection attacks)
        if (!expanded.equals(template)) {
            String expandedDenial = config.getDenylist().denialReason(expanded);
            if (expandedDenial != null) {
                eventBus.fireDenied(callerSource, expanded, expandedDenial);
                callerSource.sendFeedback(
                        () -> Text.literal("[MCE] Command denied after expansion: " + expandedDenial),
                        false
                );
                MarkerCommandEngine.LOGGER.warn("[MCE] DENIED (post-expansion) '{}' → '{}' for {}: {}",
                        template, expanded, callerSource.getName(), expandedDenial);
                return false;
            }
        }

        // Select execution source
        ServerCommandSource execSource = runAsConsole
                ? server.getCommandSource()   // op-level 4, console context
                : callerSource;

        // Log if configured
        if (config.isLogExecutions()) {
            if (expanded.equals(template)) {
                MarkerCommandEngine.LOGGER.info("[MCE] EXEC '{}' by {} (runAsConsole={})",
                        expanded, callerSource.getName(), runAsConsole);
            } else {
                MarkerCommandEngine.LOGGER.info("[MCE] EXEC '{}' → '{}' by {} (runAsConsole={})",
                        template, expanded, callerSource.getName(), runAsConsole);
            }
        }

        eventBus.fireAllowed(callerSource, expanded);

        boolean dispatched = false;
        try {
            server.getCommandManager().getDispatcher().execute(expanded, execSource);
            dispatched = true;
        } catch (Exception e) {
            callerSource.sendFeedback(
                    () -> Text.literal("[MCE] Execution error: " + e.getMessage()),
                    false
            );
            MarkerCommandEngine.LOGGER.error("[MCE] Execution error for '{}': {}", expanded, e.getMessage());
        } finally {
            eventBus.fireExecuted(callerSource, expanded, dispatched);
        }
        return dispatched;
    }
}
