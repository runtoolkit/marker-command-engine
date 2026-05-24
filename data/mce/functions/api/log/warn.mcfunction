# PUBLIC API — mce:api/log/warn
# MCE version: 2.2.0
#
# Shorthand: sets lvl=1 (WARN) then calls mce:api/log/write.
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Input:
#   mce:log_write msg — string, the log message (required)
#
# Usage:
#   data modify storage mce:log_write msg set value "Something went wrong."
#   function mce:api/log/warn

data modify storage mce:log_write lvl set value 1
function mce:api/log/write
