# PUBLIC API — mce:api/log/clear
# MCE version: 2.2.0
#
# Clears all log entries from mce:log entries and resets the entry counter.
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Usage:
#   function mce:api/log/clear

data remove storage mce:log entries
scoreboard players set #log.n mce.log 0
