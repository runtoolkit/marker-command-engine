# PUBLIC API — mce:api/cooldown/set
# MCE version: 1.1.0 (extended)
#
# Sets a cooldown for the executor (@s).
# Compatible with Minecraft 1.19.3+
#
# Input:
#   mce:cd Ticks — int, number of ticks for the cooldown (20 = 1 second)
#
# Usage:
#   data modify storage mce:cd Ticks set value 100
#   function mce:api/cooldown/set

execute unless data storage mce:cd Ticks run data modify storage mce:error Last set value "mce:cd Ticks is not set — provide a tick count before calling cooldown/set"
execute unless data storage mce:cd Ticks run data modify storage mce:error Code set value "ERR_NO_TICKS"
execute unless data storage mce:cd Ticks run function mce:core/error/raise

execute if data storage mce:cd Ticks run execute store result score @s mce.cd run data get storage mce:cd Ticks
execute if data storage mce:cd Ticks run data remove storage mce:cd Ticks
