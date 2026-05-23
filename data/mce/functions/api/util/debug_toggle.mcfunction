# PUBLIC API — mce:api/util/debug_toggle
# MCE version: 2.1.0
#
# Toggle MCE debug output on/off.
# Usage: function mce:api/util/debug_toggle

data modify storage mce:temp debug set from storage mce:config mce.debug
execute if data storage mce:temp {debug:1b} run data modify storage mce:config mce.debug set value 0b
execute if data storage mce:temp {debug:0b} run data modify storage mce:config mce.debug set value 1b
execute if data storage mce:config {mce:{debug:1b}} run tellraw @s {"text":"[MCE] DEBUG: ON","color":"aqua"}
execute if data storage mce:config {mce:{debug:0b}} run tellraw @s {"text":"[MCE] DEBUG: OFF","color":"gray"}
data remove storage mce:temp debug
