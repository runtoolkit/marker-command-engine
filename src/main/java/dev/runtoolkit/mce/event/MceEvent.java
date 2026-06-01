package dev.runtoolkit.mce.event;

/**
 * All events fired by the MCE event bus.
 */
public enum MceEvent {
    /** A command passed denylist checks and is about to execute. */
    COMMAND_ALLOWED,
    /** A command was blocked by the denylist. Context contains the denial reason. */
    COMMAND_DENIED,
    /**
     * A command was dispatched to the server dispatcher (fired after execution,
     * regardless of outcome). Check {@link dev.runtoolkit.mce.event.MceEventContext#success()}
     * to distinguish success from failure.
     */
    COMMAND_EXECUTED,
    /** commands.json was reloaded (via {@code /mce reload}). */
    CONFIG_RELOADED
}
