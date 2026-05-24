# PUBLIC API — mce:api/log/write
# MCE version: 2.2.0
#
# Appends a structured entry to the in-memory log (mce:log entries).
# The log holds the last 64 entries; oldest is dropped when full.
# Compatible with Minecraft 1.19.3+
#
# Input:
#   mce:log_write msg — string, the log message (required)
#   mce:log_write lvl — int, severity level (optional, default: 0)
#                       0 = INFO  1 = WARN  2 = ERROR
#
# Entry format written to mce:log entries[]:
#   {n: <int>, lvl: <0|1|2>, msg: "<string>"}
#
# Convenience helpers that set lvl automatically:
#   function mce:api/log/info   (sets lvl=0 then calls write)
#   function mce:api/log/warn   (sets lvl=1 then calls write)
#   function mce:api/log/error  (sets lvl=2 then calls write)
#
# Usage:
#   data modify storage mce:log_write msg set value "Player joined the arena."
#   data modify storage mce:log_write lvl set value 1
#   function mce:api/log/write

execute unless data storage mce:log_write msg run data modify storage mce:error Last set value "mce:log_write msg is not set — provide a message before calling log/write"
execute unless data storage mce:log_write msg run data modify storage mce:error Code set value "ERR_NO_MSG"
execute unless data storage mce:log_write msg run function mce:core/error/raise

# Default lvl to 0 (INFO) if not provided
execute if data storage mce:log_write msg unless data storage mce:log_write lvl run data modify storage mce:log_write lvl set value 0

# Clamp lvl to valid range 0-2
execute if data storage mce:log_write msg run execute store result score #log.lvl mce.log run data get storage mce:log_write lvl
execute if data storage mce:log_write msg if score #log.lvl mce.log matches ..0 run scoreboard players set #log.lvl mce.log 0
execute if data storage mce:log_write msg if score #log.lvl mce.log matches 3.. run scoreboard players set #log.lvl mce.log 0

# Increment entry counter
execute if data storage mce:log_write msg run scoreboard players add #log.n mce.log 1

# Append compound entry
execute if data storage mce:log_write msg run data modify storage mce:log entries append value {n:0, lvl:0, msg:""}
execute if data storage mce:log_write msg run execute store result storage mce:log entries[-1].n int 1 run scoreboard players get #log.n mce.log
execute if data storage mce:log_write msg run execute store result storage mce:log entries[-1].lvl int 1 run scoreboard players get #log.lvl mce.log
execute if data storage mce:log_write msg run data modify storage mce:log entries[-1].msg set from storage mce:log_write msg

# Enforce 64-entry cap
execute if data storage mce:log_write msg run execute store result score #log.size mce.log run data get storage mce:log entries
execute if data storage mce:log_write msg if score #log.size mce.log matches 65.. run data remove storage mce:log entries[0]

# Cleanup input
execute if data storage mce:log_write msg run data remove storage mce:log_write msg
