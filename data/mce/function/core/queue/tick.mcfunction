# Private: not part of MCE public API — subject to change without notice
execute store result score #mce.size mce.queue run data get storage mce:queue commands

execute if score #mce.size mce.queue matches 1.. if data storage mce:queue commands[0] run data modify storage mce:cmd Command set from storage mce:queue commands[0]
execute if score #mce.size mce.queue matches 1.. if data storage mce:queue commands[0] run data remove storage mce:queue commands[0]
execute if score #mce.size mce.queue matches 1.. if data storage mce:cmd Command run function mce:core/run/cmd

execute if score #mce.size mce.queue matches 1.. run execute store result score #mce.size mce.queue run data get storage mce:queue commands
execute if score #mce.size mce.queue matches 1.. run schedule function mce:core/queue/tick 3t replace
