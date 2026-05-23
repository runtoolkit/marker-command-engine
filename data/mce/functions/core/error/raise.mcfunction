# Private: MCE internal error handler — do not call directly from outside MCE
#
# Logs an error to mce:error storage and optionally prints to caller.
# Caller must set mce:error Last and mce:error Code before calling this.
#
# Storage written:
#   mce:error Last  — string, human-readable error message
#   mce:error Code  — string, machine-readable error code (e.g. "ERR_NO_CMD")
#   mce:error Count — int, total error count since load
#
# Debug mode (mce.debug=1b): also prints the error to @s via tellraw.

scoreboard players add #error.count mce.queue 1
execute store result storage mce:error Count int 1 run scoreboard players get #error.count mce.queue

execute if data storage mce:config {mce:{debug:1b}} run tellraw @s ["",{"text":"[MCE/error] ","color":"red"},{"storage":"mce:error","nbt":"Code","color":"yellow"},{"text":" — ","color":"red"},{"storage":"mce:error","nbt":"Last","color":"white"}]
