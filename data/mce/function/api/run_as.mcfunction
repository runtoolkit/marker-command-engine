# PUBLIC API — mce:api/run_as
# MCE version: 1.1.0
# REQUIRES: Minecraft 1.20.2+ (uses function macros)
#
# Execute a command as a specific entity.
# Usage:
#   data modify storage mce:cmd Command set value "say I am someone else!"
#   data modify storage mce:cmd Executor set value "@a[name=Steve,limit=1]"
#   function mce:api/run_as

function mce:core/run_as_exec
