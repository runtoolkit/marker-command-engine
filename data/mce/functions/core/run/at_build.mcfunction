# Private: not part of MCE public API — subject to change without notice
# Places a marker at the target coordinate and runs the command from there.
# Reads AtX/AtY/AtZ from mce:cmd storage into scores, then teleports the marker.

execute store result score #at.x mce.tick run data get storage mce:cmd AtX
execute store result score #at.y mce.tick run data get storage mce:cmd AtY
execute store result score #at.z mce.tick run data get storage mce:cmd AtZ

data remove storage mce:cmd AtX
data remove storage mce:cmd AtY
data remove storage mce:cmd AtZ

function mce:core/run/setup_marker
execute as @e[type=minecraft:marker,tag=mce.cmd,limit=1] store result entity @s Pos[0] double 1 run scoreboard players get #at.x mce.tick
execute as @e[type=minecraft:marker,tag=mce.cmd,limit=1] store result entity @s Pos[1] double 1 run scoreboard players get #at.y mce.tick
execute as @e[type=minecraft:marker,tag=mce.cmd,limit=1] store result entity @s Pos[2] double 1 run scoreboard players get #at.z mce.tick

setblock 0 -64 0 minecraft:command_block replace
data modify block 0 -64 0 Command set value ""
data modify block 0 -64 0 auto set value 0b
data modify block 0 -64 0 TrackOutput set value 1b

execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 Command set from storage mce:cmd Command
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 auto set value 1b

schedule function mce:core/run/reset 3t replace
