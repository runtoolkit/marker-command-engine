# Private: not part of MCE public API — subject to change without notice

function mce:core/run/setup_marker

execute if data storage mce:config {mce:{debug:1b}} run tag @s add mce.debug_caller

setblock 0 -64 0 minecraft:command_block replace
data modify block 0 -64 0 Command set value ""
data modify block 0 -64 0 auto set value 0b
data modify block 0 -64 0 TrackOutput set value 1b

execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 Command set from storage mce:cmd Command
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 auto set value 1b

execute if data storage mce:config {mce:{debug:1b}} run schedule function mce:core/debug/output 2t replace

schedule function mce:core/run/reset 3t replace
