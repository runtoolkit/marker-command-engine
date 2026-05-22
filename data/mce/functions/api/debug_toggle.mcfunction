# Mevcut değeri temp'e kopyala, ona göre yaz
data modify storage mce:temp debug set from storage mce:config debug
execute if data storage mce:temp {debug:1b} run data modify storage mce:config debug set value 0b
execute if data storage mce:temp {debug:0b} run data modify storage mce:config debug set value 1b
execute if data storage mce:config {debug:1b} run tellraw @s {"text":"DEBUG: ON"}
execute if data storage mce:config {debug:0b} run tellraw @s {"text":"DEBUG: OFF"}
data remove storage mce:temp debug
