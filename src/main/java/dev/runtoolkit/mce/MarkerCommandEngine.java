package dev.runtoolkit.mce;

import dev.runtoolkit.mce.command.MceCommand;
import dev.runtoolkit.mce.config.MceConfig;
import dev.runtoolkit.mce.event.MceEvent;
import dev.runtoolkit.mce.event.MceEventBus;
import dev.runtoolkit.mce.stats.MceStats;
import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.command.v2.CommandRegistrationCallback;
import net.fabricmc.fabric.api.event.lifecycle.v1.ServerLifecycleEvents;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MarkerCommandEngine implements ModInitializer {

    public static final String MOD_ID = "marker-command-engine";
    public static final Logger LOGGER = LoggerFactory.getLogger(MOD_ID);

    private static MceConfig config;
    private static MceEventBus eventBus;
    private static MceStats stats;

    @Override
    public void onInitialize() {
        LOGGER.info("[MCE] Marker Command Engine initializing...");

        eventBus = new MceEventBus();
        config   = MceConfig.load();
        stats    = new MceStats();

        // Wire stats counters via event bus so MceStats stays decoupled from CommandExecutor
        eventBus.subscribe(MceEvent.COMMAND_ALLOWED,  ctx -> stats.recordAllowed());
        eventBus.subscribe(MceEvent.COMMAND_DENIED,   ctx -> stats.recordDenied());
        eventBus.subscribe(MceEvent.COMMAND_EXECUTED, ctx -> {
            if (Boolean.TRUE.equals(ctx.success())) stats.recordExecuted();
            else                                     stats.recordFailed();
        });
        // Reset stats on reload so the counters reflect the current config session
        eventBus.subscribe(MceEvent.CONFIG_RELOADED, ctx -> stats.reset());

        // Register /marker-command-engine and /mce alias
        CommandRegistrationCallback.EVENT.register((dispatcher, registryAccess, environment) -> {
            MceCommand.register(dispatcher, config, eventBus);
        });

        // Reload config when server starts (picks up any file edits)
        ServerLifecycleEvents.SERVER_STARTED.register(server -> {
            config.reload(server);
            LOGGER.info("[MCE] Loaded {} denied prefix(es), {} commands from commands.json",
                    config.getDenylist().prefixes().size(),
                    config.getCommands().size());
        });

        LOGGER.info("[MCE] Marker Command Engine ready.");
    }

    public static MceConfig getConfig()    { return config; }
    public static MceEventBus getEventBus(){ return eventBus; }
    public static MceStats getStats()      { return stats; }
}
