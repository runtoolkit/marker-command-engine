# Private: not part of MCE public API — subject to change without notice
# Run mce:cmd Command as all entities currently tagged mce.executor.
# The caller is responsible for tagging the target before calling mce:api/run/as.
# The mce.executor tag is removed from all entities after execution.

function mce:core/run/setup_marker

setblock 0 -64 0 minecraft:command_block replace
data modify block 0 -64 0 Command set value ""
data modify block 0 -64 0 auto set value 0b
data modify block 0 -64 0 TrackOutput set value 1b

# Write the command from storage into the command block
execute at @e[type=minecraft:marker,tag=mce.cmd,limit=1] run data modify block 0 -64 0 Command set from storage mce:cmd Command

# Trigger the block from each executor entity's position and as that entity
execute as @e[tag=mce.executor] at @s run data modify block 0 -64 0 auto set value 1b

tag @e remove mce.executor
data remove storage mce:cmd Command

schedule function mce:core/run/reset 3t replace
