# PUBLIC API — mce:api/queue/add
# MCE version: 1.1.0 (extended)
#
# Add the command stored in mce:cmd Command to the execution queue.
# Compatible with Minecraft 1.19.3+
#
# Usage:
#   data modify storage mce:cmd Command set value "say First!"
#   function mce:api/queue/add
#   data modify storage mce:cmd Command set value "say Second!"
#   function mce:api/queue/add
#   function mce:api/queue/run

execute unless data storage mce:cmd Command run data modify storage mce:error Last set value "mce:cmd Command is not set — cannot add empty entry to queue"
execute unless data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_NO_CMD"
execute unless data storage mce:cmd Command run function mce:core/error/raise

execute if data storage mce:cmd Command run data modify storage mce:queue commands append from storage mce:cmd Command
execute if data storage mce:cmd Command run data remove storage mce:cmd Command
