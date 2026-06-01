package dev.runtoolkit.mce.config;

import com.google.gson.*;
import dev.runtoolkit.mce.MarkerCommandEngine;
import net.minecraft.resource.Resource;
import net.minecraft.server.MinecraftServer;
import net.minecraft.util.Identifier;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Runtime configuration parsed from {@code data/mce/commands.json}.
 *
 * <h2>Loading strategy</h2>
 * <ol>
 *   <li>{@link #load()} — reads the bundled JAR classpath resource during mod init
 *       (before any server is available). Gives sensible defaults immediately.</li>
 *   <li>{@link #reload(MinecraftServer)} — re-reads via
 *       {@code server.getResourceManager()}, which resolves {@code data/mce/commands.json}
 *       across all active data packs. A data pack that provides this file at
 *       {@code data/mce/commands.json} overrides the bundled defaults.</li>
 * </ol>
 *
 * <p>The config intentionally does <em>not</em> live in {@code .minecraft/config/}.
 * It is a data-level file so server-pack authors can ship and override it without
 * touching the mod JAR.
 */
public class MceConfig {

    /** Identifier used to locate the config in the ResourceManager: data/mce/commands.json */
    private static final Identifier CONFIG_ID = Identifier.of("mce", "commands.json");

    private int requireOpLevel = 2;
    private boolean logExecutions = true;
    private List<String> allowedDatapacks = new ArrayList<>();
    private Denylist denylist = new Denylist(List.of(), List.of());
    private List<CommandEntry> commands = new ArrayList<>();

    private MceConfig() {}

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Initial load from the bundled {@code /data/mce/commands.json} classpath resource.
     * Called once during mod init before any server is available.
     * The result is replaced by {@link #reload(MinecraftServer)} on server start.
     */
    public static MceConfig load() {
        MceConfig cfg = new MceConfig();
        try (InputStream in = MceConfig.class.getResourceAsStream("/data/mce/commands.json")) {
            if (in != null) {
                cfg.parseContent(new String(in.readAllBytes(), StandardCharsets.UTF_8), "JAR classpath");
            } else {
                MarkerCommandEngine.LOGGER.warn("[MCE] /data/mce/commands.json not found in JAR — starting with empty config");
            }
        } catch (Exception e) {
            MarkerCommandEngine.LOGGER.error("[MCE] Failed to read bundled commands.json: {}", e.getMessage());
        }
        return cfg;
    }

    /**
     * Reload from the server's ResourceManager.
     *
     * <p>Resolution order (highest priority first):
     * <ol>
     *   <li>Loaded data packs that provide {@code data/mce/commands.json}</li>
     *   <li>The bundled mod JAR (Fabric registers it as a built-in data pack)</li>
     * </ol>
     *
     * <p>This is the correct call site for {@code /mce reload}: the server
     * parameter is <em>not</em> optional — it provides the ResourceManager that
     * knows which data packs are active.
     */
    public void reload(MinecraftServer server) {
        Optional<Resource> resource = server.getResourceManager().getResource(CONFIG_ID);
        if (resource.isPresent()) {
            try (InputStream in = resource.get().getInputStream()) {
                String content = new String(in.readAllBytes(), StandardCharsets.UTF_8);
                String source  = resource.get().getResourcePackName();
                parseContent(content, "resource manager [pack: " + source + "]");
            } catch (Exception e) {
                MarkerCommandEngine.LOGGER.error("[MCE] Reload failed: {}", e.getMessage());
            }
        } else {
            MarkerCommandEngine.LOGGER.warn(
                    "[MCE] data/mce/commands.json not found in resource manager. " +
                    "Add it to a data pack or ensure the mod JAR is on the pack list.");
        }
    }

    // ── Getters ───────────────────────────────────────────────────────────────

    public int getRequireOpLevel()           { return requireOpLevel; }
    public boolean isLogExecutions()         { return logExecutions; }
    public List<String> getAllowedDatapacks() { return allowedDatapacks; }
    public Denylist getDenylist()            { return denylist; }
    public List<CommandEntry> getCommands()  { return commands; }

    // ── Internal ──────────────────────────────────────────────────────────────

    private void parseContent(String raw, String source) {
        JsonObject root = JsonParser.parseString(raw).getAsJsonObject();

        if (root.has("settings")) {
            JsonObject s = root.getAsJsonObject("settings");
            requireOpLevel   = s.has("require_op_level") ? s.get("require_op_level").getAsInt() : 2;
            logExecutions    = !s.has("log_executions")  || s.get("log_executions").getAsBoolean();
            allowedDatapacks = new ArrayList<>();
            if (s.has("allowed_datapacks"))
                for (JsonElement el : s.getAsJsonArray("allowed_datapacks"))
                    allowedDatapacks.add(el.getAsString());
        }

        List<String> prefixes = new ArrayList<>();
        List<String> patterns = new ArrayList<>();
        if (root.has("denylist")) {
            JsonObject dl = root.getAsJsonObject("denylist");
            if (dl.has("prefixes"))
                for (JsonElement el : dl.getAsJsonArray("prefixes")) prefixes.add(el.getAsString());
            if (dl.has("patterns"))
                for (JsonElement el : dl.getAsJsonArray("patterns")) patterns.add(el.getAsString());
        }
        denylist = new Denylist(prefixes, patterns);

        commands = new ArrayList<>();
        if (root.has("commands")) {
            for (JsonElement el : root.getAsJsonArray("commands")) {
                JsonObject obj = el.getAsJsonObject();
                if (!obj.has("id")) continue;

                String  entryId = obj.get("id").getAsString();
                String  runAs   = obj.has("run_as") ? obj.get("run_as").getAsString() : "console";
                boolean enabled = !obj.has("enabled") || obj.get("enabled").getAsBoolean();

                // "commands" array takes priority over legacy "command" string
                List<String> cmds = new ArrayList<>();
                if (obj.has("commands") && obj.get("commands").isJsonArray()) {
                    for (JsonElement ce : obj.getAsJsonArray("commands")) {
                        String cs = ce.getAsString().trim();
                        if (!cs.isEmpty()) cmds.add(cs);
                    }
                } else if (obj.has("command")) {
                    String cs = obj.get("command").getAsString().trim();
                    if (!cs.isEmpty()) cmds.add(cs);
                }
                if (cmds.isEmpty()) {
                    MarkerCommandEngine.LOGGER.warn("[MCE] Skipping entry '{}': no command(s) defined", entryId);
                    continue;
                }

                List<String> aliases = new ArrayList<>();
                if (obj.has("aliases"))
                    for (JsonElement ae : obj.getAsJsonArray("aliases")) {
                        String alias = ae.getAsString().trim();
                        if (!alias.isBlank()) aliases.add(alias);
                    }

                if (enabled) commands.add(new CommandEntry(entryId, cmds, runAs, true, aliases));
            }
        }

        MarkerCommandEngine.LOGGER.info(
                "[MCE] Config loaded from {}: op_level={}, denylist_prefixes={}, commands={}",
                source, requireOpLevel, prefixes.size(), commands.size());
    }
}
