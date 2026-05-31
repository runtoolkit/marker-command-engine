package dev.runtoolkit.mce.util;

import dev.runtoolkit.mce.MarkerCommandEngine;
import dev.runtoolkit.mce.config.MceConfig;
import dev.runtoolkit.mce.event.MceEvent;
import dev.runtoolkit.mce.event.MceEventBus;
import net.minecraft.server.MinecraftServer;
import net.minecraft.server.command.ServerCommandSource;
import net.minecraft.text.Text;

/**
 * Executes a command string through the Minecraft server dispatcher,
 * after applying denylist checks.
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
     * @return {@code true} if the command was dispatched; {@code false} if denied or failed.
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
        String normalized = command.startsWith("/") ? command.substring(1) : command;

        // Denylist check
        String denialReason = config.getDenylist().denialReason(normalized);
        if (denialReason != null) {
            eventBus.fireDenied(callerSource, normalized, denialReason);
            callerSource.sendFeedback(
                    () -> Text.literal("[MCE] Command denied: " + denialReason),
                    false
            );
            MarkerCommandEngine.LOGGER.warn("[MCE] DENIED '{}' for {}: {}",
                    normalized,
                    callerSource.getName(),
                    denialReason);
            return false;
        }

        // Select execution source
        ServerCommandSource execSource = runAsConsole
                ? server.getCommandSource()   // op-level 4, console context
                : callerSource;

        // Log if configured
        if (config.isLogExecutions()) {
            MarkerCommandEngine.LOGGER.info("[MCE] EXEC '{}' by {} (runAsConsole={})",
                    normalized, callerSource.getName(), runAsConsole);
        }

        eventBus.fireAllowed(callerSource, normalized);

        try {
            server.getCommandManager().getDispatcher().execute(normalized, execSource);
            return true;
        } catch (Exception e) {
            callerSource.sendFeedback(
                    () -> Text.literal("[MCE] Execution error: " + e.getMessage()),
                    false
            );
            MarkerCommandEngine.LOGGER.error("[MCE] Execution error for '{}': {}", normalized, e.getMessage());
            return false;
        }
    }
}
