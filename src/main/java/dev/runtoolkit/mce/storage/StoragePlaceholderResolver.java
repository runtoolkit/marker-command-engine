package dev.runtoolkit.mce.storage;

import dev.runtoolkit.mce.MarkerCommandEngine;
import net.minecraft.nbt.NbtCompound;
import net.minecraft.nbt.NbtElement;
import net.minecraft.nbt.NbtString;
import net.minecraft.server.MinecraftServer;
import net.minecraft.util.Identifier;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class StoragePlaceholderResolver {

    private static final Pattern PLACEHOLDER = Pattern.compile(
            "%([a-z0-9_.-]+:[a-z0-9_./-]+)=\"([^\"]+)\"%"
    );

    private static final Pattern SNBT_SUFFIX = Pattern.compile("[bBsSlLfFdD]$");

    private StoragePlaceholderResolver() {}

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

    public static boolean hasPlaceholders(String command) {
        return PLACEHOLDER.matcher(command).find();
    }

    private static String readStorage(MinecraftServer server, String storageId, String nbtKey) {
        try {
            Identifier id = Identifier.tryParse(storageId);
            if (id == null) {
                MarkerCommandEngine.LOGGER.warn("[MCE] Placeholder: invalid storage id '{}'", storageId);
                return "";
            }
            NbtCompound nbt = server.getDataCommandStorage().get(id);
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

    private static String nbtToString(NbtElement el) {
        if (el == null) return "";
        if (el instanceof NbtString ns) return ns.asString();
        String snbt = el.toString();
        return SNBT_SUFFIX.matcher(snbt).replaceAll("");
    }
}