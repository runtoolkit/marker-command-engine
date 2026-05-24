# PUBLIC API — mce:api/log/show
# MCE version: 2.2.0
#
# Prints all current log entries to the caller (@s) via tellraw.
# Each entry: [#n] [LEVEL]  message
# Colors: INFO=white  WARN=yellow  ERROR=red
# Compatible with Minecraft 1.19.3+
#
# Usage:
#   function mce:api/log/show

execute store result score #log.size mce.log run data get storage mce:log entries

execute if score #log.size mce.log matches 0 run tellraw @s ["",{"text":"[MCE/log] ","color":"aqua"},{"text":"Log is empty.","color":"gray"}]

execute if score #log.size mce.log matches 1.. run tellraw @s ["",{"text":"=== MCE Log (","color":"gold"},{"score":{"name":"#log.size","objective":"mce.log"}},{"text":" entries) ===","color":"gold"}]

# Copy to iteration scratch (preserves originals)
execute if score #log.size mce.log matches 1.. run data modify storage mce:log_iter entries set from storage mce:log entries

execute if score #log.size mce.log matches 1.. run function mce:core/log/show_iter

execute if score #log.size mce.log matches 1.. run data remove storage mce:log_iter entries
