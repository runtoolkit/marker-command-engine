# Summon the command marker at fixed position 0 -64 0
# Marker position is irrelevant (only entity existence matters), but fixed avoids
# dependency on any executing entity's context
execute unless entity @e[type=minecraft:marker,tag=mce.cmd,limit=1] run summon minecraft:marker 0 -64 0 {Tags:["mce.cmd"]}
