# MCE internal load — do not call directly
# Private: mce:core/* functions are not part of the public API

forceload add 0 0

scoreboard objectives add mce.queue dummy
scoreboard objectives add mce.tick dummy
scoreboard objectives add mce.compat dummy
scoreboard objectives add mce.cd dummy
scoreboard objectives add mce.log dummy

scoreboard players set #tick mce.tick 0
scoreboard players set #queue.active mce.compat 0
scoreboard players set #sched.exists mce.compat 0
scoreboard players set #error.count mce.queue 0
scoreboard players set #log.n mce.log 0
scoreboard players set #log.size mce.log 0
data remove storage mce:error Last
data remove storage mce:error Code
data modify storage mce:error Count set value 0

# --- List-type storage init ---
# Prevents "data get" errors on fresh worlds where these paths have never
# been written to yet. Guarded so a /reload never wipes an in-flight queue,
# schedule, log, or batch.
execute unless data storage mce:queue commands run data modify storage mce:queue commands set value []
execute unless data storage mce:schedule jobs run data modify storage mce:schedule jobs set value []
execute unless data storage mce:log entries run data modify storage mce:log entries set value []
execute unless data storage mce:text_batch entries run data modify storage mce:text_batch entries set value []
execute unless data storage mce:batch commands run data modify storage mce:batch commands set value []

# --- MCE Config (mce.*) ---
# Internal MCE settings. Do not modify unless you know what you are doing.

# mce.debug: debug output toggle (0b = off, 1b = on)
execute unless data storage mce:config {mce:{debug:1b}} run data modify storage mce:config mce.debug set value 0b

# mce.version: human-readable version string (set on every load)
data modify storage mce:config mce.version set value "2.3.0"

# mce.queue_interval: ticks between queue executions (read-only reference, hardcoded in core/queue/tick)
data modify storage mce:config mce.queue_interval set value 3

# mce.track_output: whether spawned command blocks set TrackOutput (1b = default/on,
# matches prior behavior; 0b = silent, skips the per-command output broadcast to ops
# when commandBlockOutput gamerule is on). Does not affect command execution itself.
execute unless data storage mce:config mce.track_output run data modify storage mce:config mce.track_output set value 1b

# --- API Config (api.*) ---
# Settings exposed for other packs to read and optionally override.

# api.announce_default_preset: default timing preset used by mce:api/util/announce_times
# Valid values: "fast" (5/30/5), "normal" (10/70/20), "slow" (20/100/20), "instant" (0/40/0)
execute unless data storage mce:config api.announce_default_preset run data modify storage mce:config api.announce_default_preset set value "normal"

# --- LanternLoad: advertise MCE version ---
# v2.2.0 -> 2002000
scoreboard players set #mce load.status 2003000


data modify storage mce:config global.loaded set value 1b
scoreboard objectives remove loadMCE
tellraw @a ["",{"text":"[MCE] ","color":"aqua"},{"text":"Marker Command Engine v2.3.0 loaded!","color":"yellow"}]
tellraw @a [{"text":"[MCE] ","color":"aqua"},{"text":"Click here to reset.","color":"yellow","clickEvent":{"action":"run_command","value":"/function mce:load/reset_all"}}]
