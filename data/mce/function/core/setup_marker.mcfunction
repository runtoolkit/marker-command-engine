# Summon the command marker (only if not already present)
execute unless entity @e[type=minecraft:marker,tag=mce.cmd,limit=1] run summon minecraft:marker ~ ~ ~ {Tags:["mce.cmd"]}