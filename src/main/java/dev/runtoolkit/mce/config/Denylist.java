package dev.runtoolkit.mce.config;

import java.util.List;
import java.util.regex.Pattern;

/**
 * Immutable denylist loaded from commands.json.
 * Blocks commands matching any prefix or regex pattern.
 */
public record Denylist(List<String> prefixes, List<String> patterns) {

    private static final List<Pattern> COMPILED_CACHE_PLACEHOLDER = List.of();

    /** Compiled regex patterns — built once after construction. */
    private static List<Pattern> compiled = COMPILED_CACHE_PLACEHOLDER;

    public Denylist {
        prefixes = prefixes == null ? List.of() : List.copyOf(prefixes);
        patterns = patterns == null ? List.of() : List.copyOf(patterns);
        compiled = patterns.stream()
                .map(p -> Pattern.compile(p, Pattern.CASE_INSENSITIVE | Pattern.DOTALL))
                .toList();
    }

    /**
     * Returns {@code true} if {@code command} is blocked.
     * Strips a leading {@code /} before checking.
     */
    public boolean isDenied(String command) {
        if (command == null || command.isBlank()) return true;
        String normalized = command.startsWith("/") ? command.substring(1) : command;
        String lower = normalized.toLowerCase();

        for (String prefix : prefixes) {
            String p = prefix.toLowerCase();
            if (lower.equals(p) || lower.startsWith(p + " ")) {
                return true;
            }
        }

        for (Pattern pat : compiled) {
            if (pat.matcher(normalized).matches()) {
                return true;
            }
        }
        return false;
    }

    /** Returns the human-readable reason for denial, or {@code null} if allowed. */
    public String denialReason(String command) {
        if (command == null || command.isBlank()) return "empty command";
        String normalized = command.startsWith("/") ? command.substring(1) : command;
        String lower = normalized.toLowerCase();

        for (String prefix : prefixes) {
            String p = prefix.toLowerCase();
            if (lower.equals(p) || lower.startsWith(p + " ")) {
                return "blocked prefix: '" + prefix + "'";
            }
        }

        for (int i = 0; i < compiled.size(); i++) {
            if (compiled.get(i).matcher(normalized).matches()) {
                return "blocked pattern: '" + patterns.get(i) + "'";
            }
        }
        return null;
    }
}
