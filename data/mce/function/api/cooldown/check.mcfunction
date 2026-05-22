# PUBLIC API — mce:api/cooldown/check
# MCE version: 1.1.0
#
# Checks if the executor (@s) is NOT on cooldown.
# Returns 1 (success) if ready, 0 (fail) if still cooling down.
# Also writes result to mce:output Cooldown.ready (1b = ready, 0b = on cooldown).
#
# Requires: Minecraft 1.20.2+ (return command)
#
# Usage:
#   execute as <player> if function mce:api/cooldown/check run ...

data modify storage mce:output Cooldown.ready set value 0b
execute if score @s mce.cd matches 0 run data modify storage mce:output Cooldown.ready set value 1b
execute if score @s mce.cd matches 0 run return 1
return 0
