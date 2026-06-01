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

public class MceConfig {

    private static final Identifier CONFIG_ID = new Identifier("mce", "commands.json");

    private int requireOpLevel = 2;
    private boolean logExecutions = true;
    private List<String> allowedDatapacks = new ArrayList<>();
    private Denylist denylist = new Denylist(List.of(), List.of());
    private List<CommandEntry> commands = new ArrayList<>();

    private MceConfig() {}

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

    public void reload(MinecraftServer server) {
        Optional<Resource> resource = server.getResourceManager().getResource(CONFIG_ID);
        if (resource.isPresent()) {
            try (InputStream in = resource.get().getInputStream()) {
                String content = new String(in.readAllBytes(), StandardCharsets.UTF_8);
                String source  = resource.get().getPack().getInfo().id();
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

    public int getRequireOpLevel()           { return requireOpLevel; }
    public boolean isLogExecutions()         { return logExecutions; }
    public List<String> getAllowedDatapacks() { return allowedDatapacks; }
    public Denylist getDenylist()            { return denylist; }
    public List<CommandEntry> getCommands()  { return commands; }

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