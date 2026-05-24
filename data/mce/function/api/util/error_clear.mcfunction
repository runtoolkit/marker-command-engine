# PUBLIC API — mce:api/util/error_clear
# MCE version: 2.2.0
#
# Resets the MCE error state: clears mce:error Last, Code, and Count,
# and resets the internal error counter scoreboard.
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Use this after handling or acknowledging an error so that
# subsequent error checks start from a clean state.
#
# Storage written:
#   mce:error Last  — removed
#   mce:error Code  — removed
#   mce:error Count — reset to 0
#
# Usage:
#   function mce:api/util/error_clear

data remove storage mce:error Last
data remove storage mce:error Code
data modify storage mce:error Count set value 0
scoreboard players set #error.count mce.queue 0
