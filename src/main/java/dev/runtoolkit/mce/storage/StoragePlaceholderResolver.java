package dev.runtoolkit.mce.storage;

import dev.runtoolkit.mce.MarkerCommandEngine;
import net.minecraft.nbt.NbtCompound;
import net.minecraft.nbt.NbtElement;
import net.minecraft.nbt.NbtString;
import net.minecraft.server.MinecraftServer;
import net.minecraft.util.Identifier;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Resolves {@code %namespace:path="key"%} placeholders in command strings
 * by reading from the Minecraft command storage at execution time.
 *
 * <h2>Syntax</h2>
 * <pre>
 *   %&lt;namespace&gt;:&lt;path&gt;="&lt;key&gt;"%
 * </pre>
 *
 * <ul>
 *   <li>{@code namespace:path} — the storage identifier (matches the first arg
 *       of {@code /data ... storage &lt;id&gt;})</li>
 *   <li>{@code key} — top-level key name inside that storage's NbtCompound</li>
 * </ul>
 *
 * <h2>Example</h2>
 * <p>Set storage from a datapack:
 * <pre>
 *   data modify storage mce:vars message set value "Legends11"
 * </pre>
 * Then in {@code commands.json}:
 * <pre>
 *   "command": "say Welcome %mce:vars=\"message\"%!"
 * </pre>
 * Executing that entry runs: {@code say Welcome Legends11!}
 *
 * <h2>Security</h2>
 * <p>{@link dev.runtoolkit.mce.util.CommandExecutor} runs the denylist twice —
 * once on the raw template and once on the expanded command — so values injected
 * from storage cannot bypass denylist rules.
 *
 * <h2>Type conversion</h2>
 * <ul>
 *   <li>{@code NbtString} → raw string value (no SNBT quotes)</li>
 *   <li>Numeric types → decimal string without SNBT type suffix</li>
 *   <li>Other types (compound, list…) → SNBT representation</li>
 * </ul>
 */
public final class StoragePlaceholderResolver {

    /**
     * Pattern: {@code %namespace:path="key"%}
     * <ul>
     *   <li>Group 1 — storage identifier ({@code namespace:path})</li>
     *   <li>Group 2 — top-level NBT key</li>
     * </ul>
     */
    private static final Pattern PLACEHOLDER = Pattern.compile(
            "%([a-z0-9_.-]+:[a-z0-9_./-]+)=\"([^\"]+)\"%"
    );

    /** SNBT numeric suffixes produced by {@link NbtElement#toString()}. */
    private static final Pattern SNBT_SUFFIX = Pattern.compile("[bBsSlLfFdD]$");

    private StoragePlaceholderResolver() {}

    /**
     * Replace all {@code %ns:path="key"%} occurrences in {@code command}
     * with values read from command storage.
     * Returns the original string if no placeholders are present.
     */
    public static String resolve(String command, MinecraftServer server) {
        Matcher m = PLACEHOLDER.matcher(command);
        if (!m.find()) return command;

        m.reset();
        StringBuilder sb = new StringBuilder();
        while (m.find()) {
            String storageId = m.group(1);
            String nbtKey    = m.group(2);
            String value     = readStorage(server, storageId, nbtKey);
            m.appendReplacement(sb, Matcher.quoteReplacement(value));
        }
        m.appendTail(sb);
        return sb.toString();
    }

    /** Returns {@code true} if {@code command} contains at least one placeholder. */
    public static boolean hasPlaceholders(String command) {
        return PLACEHOLDER.matcher(command).find();
    }

    // ── Internal ──────────────────────────────────────────────────────────────

    private static String readStorage(MinecraftServer server, String storageId, String nbtKey) {
        try {
            Identifier id = Identifier.tryParse(storageId);
            if (id == null) {
                MarkerCommandEngine.LOGGER.warn("[MCE] Placeholder: invalid storage id '{}'", storageId);
                return "";
            }
            NbtCompound nbt = server.getCommandStorage().get(id);
            if (!nbt.contains(nbtKey)) {
                MarkerCommandEngine.LOGGER.warn("[MCE] Placeholder: storage '{}' has no key '{}'", storageId, nbtKey);
                return "";
            }
            return nbtToString(nbt.get(nbtKey));
        } catch (Exception e) {
            MarkerCommandEngine.LOGGER.error("[MCE] Placeholder read error [{}#{}]: {}", storageId, nbtKey, e.getMessage());
            return "";
        }
    }

    /**
     * Convert an {@link NbtElement} to a plain string suitable for command substitution.
     * NbtString returns the raw value; numeric types strip the SNBT suffix.
     */
    private static String nbtToString(NbtElement el) {
        if (el == null) return "";
        if (el instanceof NbtString) return el.asString();          // raw string, no SNBT quotes
        String snbt = el.toString();
        // Strip trailing type suffix: 42b → 42, 3.14f → 3.14, 100L → 100, etc.
        return SNBT_SUFFIX.matcher(snbt).replaceAll("");
    }
}
