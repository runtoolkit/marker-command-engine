package dev.runtoolkit.mce.config;

import com.google.gson.*;
import dev.runtoolkit.mce.MarkerCommandEngine;
import net.fabricmc.loader.api.FabricLoader;
import net.minecraft.server.MinecraftServer;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;

public class MceConfig {

    private static final String CONFIG_FILENAME = "commands.json";

    private Path configPath;
    private int requireOpLevel = 2;
    private boolean logExecutions = true;
    private List<String> allowedDatapacks = new ArrayList<>();
    private Denylist denylist = new Denylist(List.of(), List.of());
    private List<CommandEntry> commands = new ArrayList<>();

    private MceConfig() {}

    public static MceConfig load() {
        MceConfig cfg = new MceConfig();
        // FabricLoader guarantees the correct config dir regardless of working directory
        Path dir = FabricLoader.getInstance().getConfigDir().resolve("marker-command-engine");
        cfg.configPath = dir.resolve(CONFIG_FILENAME);

        try {
            Files.createDirectories(dir);
            if (!Files.exists(cfg.configPath)) {
                cfg.copyDefaultConfig();
            }
            cfg.parse();
        } catch (Exception e) {
            MarkerCommandEngine.LOGGER.error("[MCE] Failed to load commands.json: {}", e.getMessage());
        }
        return cfg;
    }

    public void reload(MinecraftServer server) {
        try {
            parse();
            MarkerCommandEngine.LOGGER.info("[MCE] Reloaded from {}", configPath.toAbsolutePath());
        } catch (Exception e) {
            MarkerCommandEngine.LOGGER.error("[MCE] Reload failed: {}", e.getMessage());
        }
    }

    private void copyDefaultConfig() throws IOException {
        try (InputStream in = MceConfig.class.getResourceAsStream("/data/mce/commands.json")) {
            if (in != null) {
                Files.copy(in, configPath, StandardCopyOption.REPLACE_EXISTING);
            } else {
                String defaults = """
                        {
                          "settings": { "require_op_level": 2, "log_executions": true, "allowed_datapacks": [] },
                          "denylist": {
                            "prefixes": ["op","deop","ban","ban-ip","pardon","pardon-ip","stop","whitelist add","whitelist remove"],
                            "patterns": []
                          },
                          "commands": []
                        }
                        """;
                Files.writeString(configPath, defaults, StandardCharsets.UTF_8);
            }
        }
        MarkerCommandEngine.LOGGER.info("[MCE] Created default commands.json at {}", configPath.toAbsolutePath());
    }

    private void parse() throws IOException {
        String raw = Files.readString(configPath, StandardCharsets.UTF_8);
        JsonObject root = JsonParser.parseString(raw).getAsJsonObject();

        if (root.has("settings")) {
            JsonObject settings = root.getAsJsonObject("settings");
            requireOpLevel = settings.has("require_op_level") ? settings.get("require_op_level").getAsInt() : 2;
            logExecutions  = !settings.has("log_executions") || settings.get("log_executions").getAsBoolean();
            allowedDatapacks = new ArrayList<>();
            if (settings.has("allowed_datapacks")) {
                for (JsonElement el : settings.getAsJsonArray("allowed_datapacks"))
                    allowedDatapacks.add(el.getAsString());
            }
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
                if (!obj.has("id") || !obj.has("command")) continue;
                String id      = obj.get("id").getAsString();
                String cmd     = obj.get("command").getAsString();
                String runAs   = obj.has("run_as") ? obj.get("run_as").getAsString() : "console";
                boolean enabled = !obj.has("enabled") || obj.get("enabled").getAsBoolean();
                if (enabled) commands.add(new CommandEntry(id, cmd, runAs, true));
            }
        }

        MarkerCommandEngine.LOGGER.info("[MCE] Config loaded from {}: op_level={}, denylist={}, commands={}",
                configPath.toAbsolutePath(), requireOpLevel, prefixes.size(), commands.size());
    }

    public int getRequireOpLevel()           { return requireOpLevel; }
    public boolean isLogExecutions()         { return logExecutions; }
    public List<String> getAllowedDatapacks() { return allowedDatapacks; }
    public Denylist getDenylist()            { return denylist; }
    public List<CommandEntry> getCommands()  { return commands; }
    public Path getConfigPath()              { return configPath; }
}
