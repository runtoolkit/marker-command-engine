# Execute command from storage using marker + command block
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run setblock 0 -64 0 minecraft:command_block{Command:"",auto:0b} replace
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 Command set from storage mce:cmd Command
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 auto set value 1b

schedule function mce:core/reset 3t replace