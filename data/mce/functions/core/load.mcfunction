# MCE internal load — do not call directly
# Private: mce:core/* functions are not part of the public API

forceload add 0 0

scoreboard objectives add mce.queue dummy
scoreboard objectives add mce.tick dummy
scoreboard players set #tick mce.tick 0

# LanternLoad: advertise MCE version
# v1.1.0 -> 1001000
scoreboard players set mce load.status 1001000

tellraw @a ["",{"text":"[MCE] ","color":"aqua"},{"text":"Marker Command Engine v1.1.0 loaded!","color":"white"}]
