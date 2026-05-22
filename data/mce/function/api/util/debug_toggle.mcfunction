# PUBLIC API — mce:api/util/debug_toggle
# MCE version: 1.1.0
#
# Toggle MCE debug output on/off.
# Usage: function mce:api/util/debug_toggle

data modify storage mce:temp debug set from storage mce:config debug
execute if data storage mce:temp {debug:1b} run data modify storage mce:config debug set value 0b
execute if data storage mce:temp {debug:0b} run data modify storage mce:config debug set value 1b
execute if data storage mce:config {debug:1b} run tellraw @s {"text":"[MCE] DEBUG: ON","color":"aqua"}
execute if data storage mce:config {debug:0b} run tellraw @s {"text":"[MCE] DEBUG: OFF","color":"gray"}
data remove storage mce:temp debug
