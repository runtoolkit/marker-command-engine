package dev.runtoolkit.mce.stats;

import java.util.concurrent.atomic.AtomicLong;

/**
 * Thread-safe, in-memory execution statistics for the current server session.
 *
 * <p>Counters increment via event-bus subscriptions wired in
 * {@link dev.runtoolkit.mce.MarkerCommandEngine} and are reset when
 * {@code /mce reload} fires {@link dev.runtoolkit.mce.event.MceEvent#CONFIG_RELOADED}.
 *
 * <p>Exposed via {@code /mce stats}.
 */
public final class MceStats {

    private final AtomicLong totalAllowed   = new AtomicLong();
    private final AtomicLong totalDenied    = new AtomicLong();
    private final AtomicLong totalExecuted  = new AtomicLong();
    private final AtomicLong totalFailed    = new AtomicLong();

    /** Increment the COMMAND_ALLOWED counter (command passed denylist, about to dispatch). */
    public void recordAllowed()  { totalAllowed.incrementAndGet(); }

    /** Increment the COMMAND_DENIED counter (command blocked by denylist). */
    public void recordDenied()   { totalDenied.incrementAndGet(); }

    /** Increment the COMMAND_EXECUTED counter (dispatcher ran without exception). */
    public void recordExecuted() { totalExecuted.incrementAndGet(); }

    /** Increment the failed-execution counter (dispatcher threw an exception). */
    public void recordFailed()   { totalFailed.incrementAndGet(); }

    /**
     * Reset all counters to zero.
     * Called automatically on {@code /mce reload} so stats reflect the current session.
     */
    public void reset() {
        totalAllowed.set(0);
        totalDenied.set(0);
        totalExecuted.set(0);
        totalFailed.set(0);
    }

    public long getAllowed()  { return totalAllowed.get(); }
    public long getDenied()  { return totalDenied.get(); }
    public long getExecuted(){ return totalExecuted.get(); }
    public long getFailed()  { return totalFailed.get(); }
}
