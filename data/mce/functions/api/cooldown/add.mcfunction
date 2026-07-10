# PUBLIC API — mce:api/cooldown/add
# MCE version: 1.1.0 (extended)
#
# Adds ticks to the executor's (@s) existing cooldown instead of overwriting it.
# Unlike cooldown/set, this stacks on top of any remaining cooldown.
# If @s has no active cooldown, this behaves like cooldown/set.
# Compatible with Minecraft 1.19.3+
#
# Input:
#   mce:cd Ticks — int, number of ticks to add (20 = 1 second)
#
# Usage:
#   data modify storage mce:cd Ticks set value 40
#   function mce:api/cooldown/add

execute unless data storage mce:cd Ticks run data modify storage mce:error Last set value "mce:cd Ticks is not set — provide a tick count before calling cooldown/add"
execute unless data storage mce:cd Ticks run data modify storage mce:error Code set value "ERR_NO_TICKS"
execute unless data storage mce:cd Ticks run function mce:core/error/raise

execute if data storage mce:cd Ticks run execute store result score #cd.add mce.cd run data get storage mce:cd Ticks
execute if data storage mce:cd Ticks run scoreboard players operation @s mce.cd += #cd.add mce.cd
execute if data storage mce:cd Ticks run data remove storage mce:cd Ticks
