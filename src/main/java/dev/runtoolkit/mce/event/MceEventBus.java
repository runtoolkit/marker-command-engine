package dev.runtoolkit.mce.event;

import dev.runtoolkit.mce.MarkerCommandEngine;
import net.minecraft.server.command.ServerCommandSource;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Consumer;

/**
 * Minimal event bus for MCE — zero mcfunction dependency.
 *
 * <p>Events fired by MCE:
 * <ul>
 *   <li>{@link MceEvent#COMMAND_ALLOWED}  — fired before a command executes (can be used for audit logging)</li>
 *   <li>{@link MceEvent#COMMAND_DENIED}   — fired when a command is blocked by denylist</li>
 *   <li>{@link MceEvent#CONFIG_RELOADED}  — fired after commands.json is reloaded</li>
 * </ul>
 *
 * <p>Usage (from another Fabric mod):
 * <pre>
 *   MceEventBus bus = MarkerCommandEngine.getEventBus();
 *   bus.subscribe(MceEvent.COMMAND_DENIED, ctx -> {
 *       ctx.source().sendFeedback(() -> Text.literal("[Audit] BLOCKED: " + ctx.command()), false);
 *   });
 * </pre>
 */
public class MceEventBus {

    private final Map<MceEvent, List<Consumer<MceEventContext>>> listeners = new ConcurrentHashMap<>();

    /** Subscribe a listener to an event. Listeners are called in subscription order. */
    public void subscribe(MceEvent event, Consumer<MceEventContext> listener) {
        listeners.computeIfAbsent(event, k -> Collections.synchronizedList(new ArrayList<>()))
                 .add(listener);
    }

    /** Unsubscribe a previously registered listener. */
    public void unsubscribe(MceEvent event, Consumer<MceEventContext> listener) {
        List<Consumer<MceEventContext>> list = listeners.get(event);
        if (list != null) list.remove(listener);
    }

    /**
     * Fire an event, invoking all registered listeners.
     * Exceptions in listeners are caught and logged — they never abort execution.
     */
    public void fire(MceEvent event, MceEventContext context) {
        List<Consumer<MceEventContext>> list = listeners.get(event);
        if (list == null || list.isEmpty()) return;
        for (Consumer<MceEventContext> listener : list) {
            try {
                listener.accept(context);
            } catch (Exception e) {
                MarkerCommandEngine.LOGGER.error("[MCE] Event listener error on {}: {}", event, e.getMessage());
            }
        }
    }

    // ── Convenience fire methods ───────────────────────────────────────────────

    public void fireAllowed(ServerCommandSource source, String command) {
        fire(MceEvent.COMMAND_ALLOWED, new MceEventContext(source, command, null, null));
    }

    public void fireDenied(ServerCommandSource source, String command, String reason) {
        fire(MceEvent.COMMAND_DENIED, new MceEventContext(source, command, reason, null));
    }

    /**
     * Fire {@link MceEvent#COMMAND_EXECUTED} after a dispatch attempt.
     *
     * @param success {@code true} if the dispatcher ran without exception;
     *                {@code false} if execution threw.
     */
    public void fireExecuted(ServerCommandSource source, String command, boolean success) {
        fire(MceEvent.COMMAND_EXECUTED, new MceEventContext(source, command, null, success));
    }

    public void fireConfigReloaded() {
        fire(MceEvent.CONFIG_RELOADED, new MceEventContext(null, null, null, null));
    }
}
