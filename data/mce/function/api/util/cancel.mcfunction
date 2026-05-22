# PUBLIC API — mce:api/util/cancel
# MCE version: 1.1.0
#
# Cancel any in-progress single command execution.
# Does NOT affect the queue — use mce:api/queue/clear for that.
# Usage: function mce:api/util/cancel

schedule clear mce:core/run/reset

execute if entity @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 auto set value 0b
execute if entity @e[type=minecraft:marker,tag=mce.cmd,limit=1] run setblock 0 -64 0 minecraft:air replace

kill @e[type=minecraft:marker,tag=mce.cmd]

data remove storage mce:cmd Command
data remove storage mce:cmd Executor
