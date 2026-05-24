# PUBLIC API — mce:api/log/error
# MCE version: 2.2.0
#
# Shorthand: sets lvl=2 (ERROR) then calls mce:api/log/write.
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Input:
#   mce:log_write msg — string, the log message (required)
#
# Usage:
#   data modify storage mce:log_write msg set value "Something went wrong."
#   function mce:api/log/error

data modify storage mce:log_write lvl set value 2
function mce:api/log/write
