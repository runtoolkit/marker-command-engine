# Private: not part of MCE public API — subject to change without notice
execute store result score #mce.size mce.queue run data get storage mce:queue commands

execute if score #mce.size mce.queue matches 0 run return 0
execute unless data storage mce:queue commands[0] run return 0

data modify storage mce:cmd Command set from storage mce:queue commands[0]
data remove storage mce:queue commands[0]

function mce:core/run_cmd

execute store result score #mce.size mce.queue run data get storage mce:queue commands
execute if score #mce.size mce.queue matches 1.. run schedule function mce:core/queue_tick 3t replace
