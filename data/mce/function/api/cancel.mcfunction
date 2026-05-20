# Cancel any in-progress single command execution.
# Disables the command block, removes the marker, clears storage.
# Does NOT affect the queue — use mce:api/queue_clear for that.
#
# Usage:
#   function mce:api/cancel

# Abort scheduled reset (prevent double-clear)
schedule clear mce:core/reset

# Disable command block if present
execute if entity @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 auto set value 0b
execute if entity @e[type=minecraft:marker,tag=mce.cmd,limit=1] run setblock 0 -64 0 minecraft:air replace

# Kill marker
kill @e[type=minecraft:marker,tag=mce.cmd]

# Clear staging storage
data remove storage mce:cmd Command
data remove storage mce:cmd Executor
