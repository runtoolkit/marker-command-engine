execute if data storage mce:config {debug:1b} run data modify storage mce:config debug set value 0b
execute if data storage mce:config {debug:0b} run data modify storage mce:config debug set value 1b

execute if data storage mce:config {debug:1b} run tellraw @s "DEBUG: ON"
execute if data storage mce:config {debug:0b} run tellraw @s "DEBUG: OFF"
