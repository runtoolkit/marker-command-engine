# Private: not part of MCE public API — subject to change without notice
# Iterates over mce:log_iter entries, printing each via tellraw (no macros).
# Reads entries[0], branches on level, then removes it.
# Compatible with Minecraft 1.19.3+.

execute unless data storage mce:log_iter entries[0] run return 0

# Copy first entry's level to scratch for safe branch (avoid false match on entries[1+])
data modify storage mce:log_cur level set from storage mce:log_iter entries[0].level

execute if data storage mce:log_cur {level:"INFO"}  run tellraw @s ["",{"text":"[","color":"dark_gray"},{"storage":"mce:log_iter","nbt":"entries[0].n","color":"dark_gray"},{"text":"] ","color":"dark_gray"},{"text":"[INFO]  ","color":"white"},{"storage":"mce:log_iter","nbt":"entries[0].msg","color":"white"}]
execute if data storage mce:log_cur {level:"WARN"}  run tellraw @s ["",{"text":"[","color":"dark_gray"},{"storage":"mce:log_iter","nbt":"entries[0].n","color":"dark_gray"},{"text":"] ","color":"dark_gray"},{"text":"[WARN]  ","color":"yellow"},{"storage":"mce:log_iter","nbt":"entries[0].msg","color":"yellow"}]
execute if data storage mce:log_cur {level:"ERROR"} run tellraw @s ["",{"text":"[","color":"dark_gray"},{"storage":"mce:log_iter","nbt":"entries[0].n","color":"dark_gray"},{"text":"] ","color":"dark_gray"},{"text":"[ERROR] ","color":"red"},{"storage":"mce:log_iter","nbt":"entries[0].msg","color":"red"}]

data remove storage mce:log_cur
data remove storage mce:log_iter entries[0]
function mce:core/log/show_iter
