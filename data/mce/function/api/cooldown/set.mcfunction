# PUBLIC API — mce:api/cooldown/set
# MCE version: 1.1.0
#
# Sets a cooldown for the executor (@s).
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Input:
#   mce:cd Ticks — int, number of ticks for the cooldown (20 = 1 second)
#
# Usage:
#   data modify storage mce:cd Ticks set value 100
#   function mce:api/cooldown/set

execute store result score @s mce.cd run data get storage mce:cd Ticks
data remove storage mce:cd Ticks
