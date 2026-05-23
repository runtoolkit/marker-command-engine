# PUBLIC API — mce:api/util/version
# MCE version: 2.0.0
#
# Writes the current MCE version to storage and prints it to the caller.
# Output: mce:output Version.string — string ("2.0.0")
#         mce:output Version.numeric — int (2000000, LanternLoad format)
#
# Usage:
#   function mce:api/util/version

data modify storage mce:output Version.string set value "2.0.0"
execute store result storage mce:output Version.numeric int 1 run scoreboard players get #mce load.status
tellraw @s ["",{"text":"[MCE] ","color":"aqua"},{"text":"Version: ","color":"white"},{"storage":"mce:output","nbt":"Version.string","color":"gold"}]
