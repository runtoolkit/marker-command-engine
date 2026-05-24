# PUBLIC API — mce:api/cooldown/check
# MCE version: 1.1.0 (extended)
#
# Checks if the executor (@s) is NOT on cooldown.
# Writes result to mce:output Cooldown.ready (1b = ready, 0b = on cooldown).
# Compatible with Minecraft 1.19.3+
#
# NOTE: This function no longer supports "execute if function" syntax.
#       Check mce:output Cooldown.ready after calling instead:
#
# Usage:
#   execute as <player> run function mce:api/cooldown/check
#   execute if data storage mce:output {Cooldown:{ready:1b}} run ...

data modify storage mce:output Cooldown.ready set value 0b
execute if score @s mce.cd matches 0 run data modify storage mce:output Cooldown.ready set value 1b
