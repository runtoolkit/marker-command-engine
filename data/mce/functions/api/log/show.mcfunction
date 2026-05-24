# PUBLIC API — mce:api/log/show
# MCE version: 2.2.0
#
# Prints all current log entries to the caller (@s) via tellraw.
# Each entry is displayed as: [#n] [LEVEL] message
# Colors: INFO = white, WARN = yellow, ERROR = red.
# If the log is empty, prints a notice instead.
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Usage:
#   function mce:api/log/show

execute store result score #log.size mce.log run data get storage mce:log entries

execute if score #log.size mce.log matches 0 run tellraw @s ["",{"text":"[MCE/log] ","color":"aqua"},{"text":"Log is empty.","color":"gray"}]
execute if score #log.size mce.log matches 0 run return 0

tellraw @s ["",{"text":"=== MCE Log (","color":"gold"},{"score":{"name":"#log.size","objective":"mce.log"}},{"text":" entries) ===","color":"gold"}]

# Copy entries to iteration workspace (preserves originals)
data modify storage mce:log_iter entries set from storage mce:log entries

function mce:core/log/show_iter
data remove storage mce:log_iter
