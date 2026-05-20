# Execute a command as a specific entity.
# REQUIRES: Minecraft 1.20.2+ (uses function macros)
# NOT available on 1.19.x or 1.20.1 — mce:api/run_as does not exist in those versions.
#
# Usage:
#   data modify storage mce:cmd Command set value "say I am someone else!"
#   data modify storage mce:cmd Executor set value "@a[name=Steve,limit=1]"
#   function mce:api/run_as
#
# Wraps Command as: execute as <Executor> run <Command>
# Clears both fields after execution.

function mce:core/run_as_exec
