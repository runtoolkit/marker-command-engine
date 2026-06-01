package dev.runtoolkit.mce.config;

import java.util.List;

/**
 * One entry in the {@code commands[]} array of commands.json.
 *
 * <p>Supports:
 * <ul>
 *   <li>{@code "command": "..."} — single command string (backward-compatible)</li>
 *   <li>{@code "commands": ["...", "..."]} — ordered list; executed in sequence</li>
 *   <li>{@code "aliases": ["...", "..."]} — alternative IDs for {@code /mce run-id}</li>
 * </ul>
 *
 * @param id       Unique primary identifier.
 * @param commands Ordered list of command strings (without leading '/').
 * @param runAs    {@code "console"} or {@code "player"} (default: console).
 * @param enabled  Whether this entry is active.
 * @param aliases  Optional alternative IDs accepted by {@code /mce run-id}.
 */
public record CommandEntry(
        String id,
        List<String> commands,
        String runAs,
        boolean enabled,
        List<String> aliases
) {
    public CommandEntry {
        if (id == null || id.isBlank())
            throw new IllegalArgumentException("MCE command entry missing 'id'");
        if (commands == null || commands.isEmpty())
            throw new IllegalArgumentException("MCE command entry '" + id + "' has no command(s)");
        commands = List.copyOf(commands);
        if (runAs == null) runAs = "console";
        aliases = aliases == null ? List.of() : List.copyOf(aliases);
    }

    /** The first command string — used for single-command paths and display. */
    public String firstCommand() {
        return commands.get(0);
    }

    public boolean isConsole() {
        return "console".equalsIgnoreCase(runAs);
    }

    /**
     * Returns {@code true} if {@code name} matches the primary {@code id}
     * or any entry in {@code aliases} (case-sensitive).
     */
    public boolean matchesId(String name) {
        return id.equals(name) || aliases.contains(name);
    }
}
