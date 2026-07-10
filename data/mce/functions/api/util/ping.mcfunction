# PUBLIC API — mce:api/util/ping
# MCE version: 2.3.0 (extended)
#
# Health-check: confirms MCE is loaded and its scoreboard objectives respond,
# and reports the current internal error count alongside the version string.
# Useful for server-side monitoring or startup verification scripts.
# Output:
#   mce:output Ping.ok      — 1b if load status score exists and is >= 1, else 0b
#   mce:output Ping.errors  — int, current value of mce:error Count
# Compatible with Minecraft 1.19.3+
#
# Usage:
#   function mce:api/util/ping
#   data get storage mce:output Ping.ok

data modify storage mce:output Ping.ok set value 0b
execute if score #mce load.status matches 1.. run data modify storage mce:output Ping.ok set value 1b

execute unless data storage mce:error Count run data modify storage mce:output Ping.errors set value 0
execute if data storage mce:error Count run data modify storage mce:output Ping.errors set from storage mce:error Count

execute if data storage mce:output {Ping:{ok:1b}} run tellraw @s ["",{"text":"[MCE/ping] ","color":"aqua"},{"text":"OK — engine loaded, ","color":"green"},{"storage":"mce:output","nbt":"Ping.errors","color":"yellow"},{"text":" error(s) logged.","color":"green"}]
execute unless data storage mce:output {Ping:{ok:1b}} run tellraw @s ["",{"text":"[MCE/ping] ","color":"aqua"},{"text":"FAIL — engine not loaded (load.status missing or 0).","color":"red"}]
