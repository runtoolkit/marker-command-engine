# PUBLIC API — mce:api/log/write
# MCE version: 2.2.0
#
# Appends a structured entry to the in-memory log (mce:log entries).
# The log holds the last 64 entries; oldest is dropped when full.
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Input (mce:log_write storage):
#   mce:log_write msg   — string, the log message (required)
#   mce:log_write level — string, severity level (optional, default: "INFO")
#                         Valid values: "INFO", "WARN", "ERROR"
#
# Entry format written to mce:log entries[]:
#   {n: <int>, level: "<string>", msg: "<string>"}
#
# Usage:
#   data modify storage mce:log_write msg set value "Player joined the arena."
#   data modify storage mce:log_write level set value "INFO"
#   function mce:api/log/write

execute unless data storage mce:log_write msg run data modify storage mce:error Last set value "mce:log_write msg is not set — provide a message before calling log/write"
execute unless data storage mce:log_write msg run data modify storage mce:error Code set value "ERR_NO_MSG"
execute unless data storage mce:log_write msg run function mce:core/error/raise
execute unless data storage mce:log_write msg run return 0

# Default level to "INFO" if not provided
execute unless data storage mce:log_write level run data modify storage mce:log_write level set value "INFO"

# Increment entry counter
scoreboard players add #log.n mce.log 1
execute store result storage mce:log_write n int 1 run scoreboard players get #log.n mce.log

# Append entry as compound
data modify storage mce:log entries append value {n: 0, level: "INFO", msg: ""}
execute store result storage mce:log entries[-1].n int 1 run scoreboard players get #log.n mce.log
data modify storage mce:log entries[-1].level set from storage mce:log_write level
data modify storage mce:log entries[-1].msg set from storage mce:log_write msg

# Enforce 64-entry cap — drop oldest
execute store result score #log.size mce.log run data get storage mce:log entries
execute if score #log.size mce.log matches 65.. run data remove storage mce:log entries[0]

# Cleanup input
data remove storage mce:log_write msg
data remove storage mce:log_write level
data remove storage mce:log_write n
