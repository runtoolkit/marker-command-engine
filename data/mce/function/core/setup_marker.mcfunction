# Private: not part of MCE public API — subject to change without notice
# Reset any leftover command block state before starting
data modify block 0 -64 0 auto set value 0b

# Summon the command marker at fixed position 0 -64 0
execute unless entity @e[type=minecraft:marker,tag=mce.cmd,limit=1] run summon minecraft:marker 0 -64 0 {Tags:["mce.cmd"]}
