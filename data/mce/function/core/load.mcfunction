# MCE internal load — do not call directly, use #load:load tag to depend on MCE
# Private: mce:core/* functions are not part of the public API

forceload add 0 0

# Initialize scoreboards
scoreboard objectives add mce.queue dummy
scoreboard objectives add mce.tick dummy

# Initialize tick counter
scoreboard players set #tick mce.tick 0

# LanternLoad: advertise MCE version as load.status score
# mce.version = major*1000000 + minor*1000 + patch
# v1.1.0 -> 1001000
scoreboard players set mce load.status 1001000

tellraw @a ["",{"text":"[MCE] ","color":"aqua"},{"text":"Marker Command Engine v1.1.0 loaded!","color":"white"}]
