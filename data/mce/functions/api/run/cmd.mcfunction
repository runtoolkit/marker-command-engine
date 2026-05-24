# PUBLIC API — mce:api/run/cmd
# MCE version: 1.1.0 (extended)
#
# Execute the command stored in mce:cmd Command immediately.
# Compatible with Minecraft 1.19.3+
#
# Usage:
#   data modify storage mce:cmd Command set value "say Hello!"
#   function mce:api/run/cmd

execute unless data storage mce:cmd Command run data modify storage mce:error Last set value "mce:cmd Command is not set"
execute unless data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_NO_CMD"
execute unless data storage mce:cmd Command run function mce:core/error/raise

execute if data storage mce:cmd Command run function mce:core/run/setup_marker
execute if data storage mce:cmd Command run function mce:core/run/cmd
