# PUBLIC API — mce:api/cooldown/clear
# MCE version: 1.1.0
#
# Clears the cooldown for the executor (@s) immediately.
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Usage:
#   function mce:api/cooldown/clear

scoreboard players set @s mce.cd 0
