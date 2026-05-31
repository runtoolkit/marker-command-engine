package dev.runtoolkit.mce.event;

/**
 * All events fired by the MCE event bus.
 */
public enum MceEvent {
    /** A command passed denylist checks and is about to execute. */
    COMMAND_ALLOWED,
    /** A command was blocked by the denylist. Context contains the denial reason. */
    COMMAND_DENIED,
    /** commands.json was reloaded (via {@code /mce reload}). */
    CONFIG_RELOADED
}
