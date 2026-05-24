# MCE internal load — do not call directly
# Private: mce:core/* functions are not part of the public API

forceload add 0 0

scoreboard objectives add mce.queue dummy
scoreboard objectives add mce.tick dummy
scoreboard objectives add mce.compat dummy
scoreboard objectives add mce.cd dummy

scoreboard players set #tick mce.tick 0
scoreboard players set #queue.active mce.compat 0
scoreboard players set #sched.exists mce.compat 0
scoreboard players set #error.count mce.queue 0
data remove storage mce:error Last
data remove storage mce:error Code
data modify storage mce:error Count set value 0

# --- MCE Config (mce.*) ---
# Internal MCE settings. Do not modify unless you know what you are doing.

# mce.debug: debug output toggle (0b = off, 1b = on)
execute unless data storage mce:config {mce:{debug:1b}} run data modify storage mce:config mce.debug set value 0b

# mce.version: human-readable version string (set on every load)
data modify storage mce:config mce.version set value "2.1.1"

# mce.queue_interval: ticks between queue executions (read-only reference, hardcoded in core/queue/tick)
data modify storage mce:config mce.queue_interval set value 3

# --- API Config (api.*) ---
# Settings exposed for other packs to read and optionally override.

# api.announce_default_preset: default timing preset used by mce:api/util/announce_times
# Valid values: "fast" (5/30/5), "normal" (10/70/20), "slow" (20/100/20), "instant" (0/40/0)
execute unless data storage mce:config api.announce_default_preset run data modify storage mce:config api.announce_default_preset set value "normal"

# --- LanternLoad: advertise MCE version ---
# v2.1.1 -> 2001100
scoreboard players set #mce load.status 2001100

tellraw @a ["",{"text":"[MCE] ","color":"aqua"},{"text":"Marker Command Engine v2.1.1 loaded!","color":"white"}]
