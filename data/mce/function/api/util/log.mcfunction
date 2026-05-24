# PUBLIC API — mce:api/util/log
# MCE version: 2.2.0
#
# DEPRECATED — use mce:api/log/write instead.
# This function is kept for backwards compatibility only.
# It will be removed in a future major version.
#
# Appends mce:cmd Command to the log as an INFO entry.
# Compatible with Minecraft 1.19.3+
#
# Usage (legacy):
#   data modify storage mce:cmd Command set value "some command"
#   function mce:api/util/log
#
# Preferred:
#   data modify storage mce:log_write msg set value "some command"
#   function mce:api/log/write

execute unless data storage mce:cmd Command run data modify storage mce:error Last set value "mce:cmd Command is not set — nothing to log"
execute unless data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_NO_CMD"
execute unless data storage mce:cmd Command run function mce:core/error/raise

execute if data storage mce:cmd Command run data modify storage mce:log_write msg set from storage mce:cmd Command
execute if data storage mce:cmd Command run data modify storage mce:log_write level set value "INFO"
execute if data storage mce:cmd Command run function mce:api/log/write
