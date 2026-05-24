# PUBLIC API — mce:api/util/log_clear
# MCE version: 2.1.1
#
# Clears the command log stored in mce:log entries.
# Use when you want to reset audit history (e.g. after a session ends).
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Output:
#   mce:log entries — cleared (empty list)
#
# Usage:
#   function mce:api/util/log_clear

data remove storage mce:log entries
