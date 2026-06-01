package dev.runtoolkit.mce.event;

import net.minecraft.server.command.ServerCommandSource;
import org.jetbrains.annotations.Nullable;

/**
 * Immutable context passed to MCE event listeners.
 *
 * @param source  The command source that triggered the event. May be {@code null} for CONFIG_RELOADED.
 * @param command The raw command string. May be {@code null} for CONFIG_RELOADED.
 * @param reason  Denial reason for COMMAND_DENIED; {@code null} for other events.
 * @param success {@code true} if the command dispatched without exception; {@code false} if it threw;
 *                {@code null} for events where execution outcome is not applicable
 *                (COMMAND_ALLOWED, COMMAND_DENIED, CONFIG_RELOADED).
 */
public record MceEventContext(
        @Nullable ServerCommandSource source,
        @Nullable String command,
        @Nullable String reason,
        @Nullable Boolean success
) {}
