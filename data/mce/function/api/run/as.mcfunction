# PUBLIC API — mce:api/run/as
# MCE version: 1.1.0
#
# Execute a command as one or more tagged entities.
# Does NOT require Minecraft 1.20.2+ (no macros used).
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

function mce:core/run/as_exec
