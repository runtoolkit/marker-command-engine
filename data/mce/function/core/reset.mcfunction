# Disable and remove the command block
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 auto set value 0b
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run setblock 0 -64 0 minecraft:air replace

# Kill the marker
kill @e[type=minecraft:marker,tag=mce.cmd,limit=1]

# Clear the command from storage
data remove storage mce:cmd Command

schedule clear mce:core/reset