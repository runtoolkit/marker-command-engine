package dev.runtoolkit.mce.config;

/**
 * One entry in the {@code commands[]} array of commands.json.
 *
 * @param id       Unique identifier (used for logging/events).
 * @param command  The raw command string to execute (without leading '/').
 * @param runAs    {@code "console"} or {@code "player"} (default: console).
 * @param enabled  Whether this entry is active (default: true).
 */
public record CommandEntry(
        String id,
        String command,
        String runAs,
        boolean enabled
) {
    public CommandEntry {
        if (id == null || id.isBlank()) throw new IllegalArgumentException("MCE command entry missing 'id'");
        if (command == null || command.isBlank()) throw new IllegalArgumentException("MCE command entry '" + id + "' missing 'command'");
        if (runAs == null) runAs = "console";
        // 'enabled' defaults to true if absent — handled in MceConfig parser
    }

    public boolean isConsole() {
        return "console".equalsIgnoreCase(runAs);
    }
}
