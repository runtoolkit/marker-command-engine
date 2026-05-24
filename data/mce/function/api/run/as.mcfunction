# PUBLIC API — mce:api/run/as
# MCE version: 1.1.0 (extended)
#
# Execute a command as one or more tagged entities.
# Compatible with Minecraft 1.19.3+
#
# Usage:
#   1. Tag the target entity:
#      tag <selector> add mce.executor
#   2. Set the command:
#      data modify storage mce:cmd Command set value "say I am the executor!"
#   3. Call this function:
#      function mce:api/run/as
#
# Notes:
#   - All entities tagged mce.executor will execute the command.
#   - The mce.executor tag is removed automatically after execution.
#   - The command runs at the executor entity's position (at @s).

execute unless data storage mce:cmd Command run data modify storage mce:error Last set value "mce:cmd Command is not set"
execute unless data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_NO_CMD"
execute unless data storage mce:cmd Command run function mce:core/error/raise

execute unless entity @e[tag=mce.executor,limit=1] if data storage mce:cmd Command run data modify storage mce:error Last set value "no entity tagged mce.executor — tag a target before calling mce:api/run/as"
execute unless entity @e[tag=mce.executor,limit=1] if data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_NO_EXECUTOR"
execute unless entity @e[tag=mce.executor,limit=1] if data storage mce:cmd Command run function mce:core/error/raise

execute if data storage mce:cmd Command if entity @e[tag=mce.executor,limit=1] run function mce:core/run/as_exec
