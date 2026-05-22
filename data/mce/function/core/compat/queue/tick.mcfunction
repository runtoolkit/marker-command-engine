# Private: not part of MCE public API — subject to change without notice
# 1.19.x+ compat — no return, uses scoreboard flag guard
# mce.compat scoreboard: #queue.active = 1 while processing

execute store result score #mce.size mce.queue run data get storage mce:queue commands
execute if score #mce.size mce.queue matches 0 run scoreboard players set #queue.active mce.compat 0
execute if score #mce.size mce.queue matches 0 run function mce:core/compat/queue/done

execute unless data storage mce:queue commands[0] run scoreboard players set #queue.active mce.compat 0
execute unless data storage mce:queue commands[0] run function mce:core/compat/queue/done

scoreboard players set #queue.active mce.compat 1
data modify storage mce:cmd Command set from storage mce:queue commands[0]
data remove storage mce:queue commands[0]

function mce:core/run/cmd

execute store result score #mce.size mce.queue run data get storage mce:queue commands
execute if score #mce.size mce.queue matches 1.. run schedule function mce:core/compat/queue/tick 3t replace
