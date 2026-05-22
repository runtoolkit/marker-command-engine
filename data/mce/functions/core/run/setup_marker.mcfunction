# Private: not part of MCE public API — subject to change without notice
data modify block 0 -64 0 auto set value 0b
execute unless entity @e[type=minecraft:marker,tag=mce.cmd,limit=1] run summon minecraft:marker 0 -64 0 {Tags:["mce.cmd"]}
