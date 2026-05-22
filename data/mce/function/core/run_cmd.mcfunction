# Private: not part of MCE public API — subject to change without notice
function mce:core/setup_marker

# Tag caller so debug_output can find them after schedule
execute if data storage mce:config {debug:1b} run tag @s add mce.debug_caller

# Place command block at fixed position
setblock 0 -64 0 minecraft:command_block{Command:"",auto:0b,TrackOutput:1b} replace
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 Command set from storage mce:cmd Command
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 auto set value 1b

# Debug: schedule 1t later so command block has executed by then
execute if data storage mce:config {debug:1b} run schedule function mce:core/debug_output 2t replace

schedule function mce:core/reset 3t replace
