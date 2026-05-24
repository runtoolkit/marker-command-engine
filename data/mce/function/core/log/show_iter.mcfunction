# Private: not part of MCE public API — subject to change without notice
# Iterates over mce:log_iter entries, printing each via tellraw (no macros).
# Branches on entries[0].lvl score: 0=INFO 1=WARN 2=ERROR
# Compatible with Minecraft 1.19.3+.

execute unless data storage mce:log_iter entries[0] run scoreboard players set #log.iter.done mce.log 1
execute if data storage mce:log_iter entries[0] run scoreboard players set #log.iter.done mce.log 0

execute if score #log.iter.done mce.log matches 0 run execute store result score #log.lvl mce.log run data get storage mce:log_iter entries[0].lvl

execute if score #log.iter.done mce.log matches 0 if score #log.lvl mce.log matches 0 run tellraw @s ["",{"text":"[","color":"dark_gray"},{"storage":"mce:log_iter","nbt":"entries[0].n","color":"dark_gray"},{"text":"] ","color":"dark_gray"},{"text":"[INFO] ","color":"white"},{"storage":"mce:log_iter","nbt":"entries[0].msg","color":"white"}]
execute if score #log.iter.done mce.log matches 0 if score #log.lvl mce.log matches 1 run tellraw @s ["",{"text":"[","color":"dark_gray"},{"storage":"mce:log_iter","nbt":"entries[0].n","color":"dark_gray"},{"text":"] ","color":"dark_gray"},{"text":"[WARN] ","color":"yellow"},{"storage":"mce:log_iter","nbt":"entries[0].msg","color":"yellow"}]
execute if score #log.iter.done mce.log matches 0 if score #log.lvl mce.log matches 2 run tellraw @s ["",{"text":"[","color":"dark_gray"},{"storage":"mce:log_iter","nbt":"entries[0].n","color":"dark_gray"},{"text":"] ","color":"dark_gray"},{"text":"[ERROR] ","color":"red"},{"storage":"mce:log_iter","nbt":"entries[0].msg","color":"red"}]

execute if score #log.iter.done mce.log matches 0 run data remove storage mce:log_iter entries[0]
execute if score #log.iter.done mce.log matches 0 run function mce:core/log/show_iter
