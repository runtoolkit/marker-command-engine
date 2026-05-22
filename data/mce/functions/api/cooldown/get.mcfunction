# PUBLIC API — mce:api/cooldown/get
# MCE version: 1.1.0
#
# Reads the remaining cooldown ticks for @s into storage.
# Output: mce:output Cooldown.remaining (int, remaining ticks)
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Usage:
#   execute as <player> run function mce:api/cooldown/get
#   data get storage mce:output Cooldown.remaining

execute store result storage mce:output Cooldown.remaining int 1 run scoreboard players get @s mce.cd
