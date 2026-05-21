function mce:core/setup_marker

# Place command block at fixed position (marker entity existence is the guard, not position)
setblock 0 -64 0 minecraft:command_block{Command:"",auto:0b,TrackOutput:0b} replace
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 Command set from storage mce:cmd Command
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 auto set value 1b

execute if data storage mce:config {debug:1b} run tellraw @s {"block":"-2 -60 14","nbt":"LastOutput","interpret":true}

schedule function mce:core/reset 3t replace
