# PUBLIC API — mce:api/util/log
# MCE version: 2.0.1 (extended)
#
# Appends the current mce:cmd Command value to an in-memory log list
# (mce:log entries). Useful for audit trails or debug history.
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# The log holds the last 10 entries. Older entries are dropped automatically.
#
# Input:
#   mce:cmd Command — string, the command string to log (required)
#
# Output:
#   mce:log entries — list of strings (last 10 commands logged)

execute unless data storage mce:cmd Command run data modify storage mce:error Last set value "mce:cmd Command is not set — nothing to log"
execute unless data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_NO_CMD"
execute unless data storage mce:cmd Command run function mce:core/error/raise
execute unless data storage mce:cmd Command run return 0

data modify storage mce:log entries append from storage mce:cmd Command

execute store result score #log.size mce.queue run data get storage mce:log entries
execute if score #log.size mce.queue matches 11.. run data remove storage mce:log entries[0]
