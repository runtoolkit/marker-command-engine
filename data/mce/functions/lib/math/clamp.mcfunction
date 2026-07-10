# PUBLIC API — mce:lib/math/clamp
# MCE version: 2.4.0 (lib)
#
# Clamps an integer between Min and Max (inclusive) using pure scoreboard
# comparisons. No macros used. Compatible with Minecraft 1.20.1+ (and much
# earlier — scoreboard math predates macros entirely).
#
# Input:
#   mce:lib_math Value — int (required)
#   mce:lib_math Min   — int (required)
#   mce:lib_math Max   — int (required, must be >= Min)
#
# Output:
#   mce:output Math.Clamp.result — int, Value clamped into [Min, Max]
#
# Usage:
#   data modify storage mce:lib_math Value set value 150
#   data modify storage mce:lib_math Min set value 0
#   data modify storage mce:lib_math Max set value 100
#   function mce:lib/math/clamp
#   data get storage mce:output Math.Clamp.result

execute unless data storage mce:lib_math Value run data modify storage mce:error Last set value "mce:lib_math Value is not set — provide an int before calling lib/math/clamp"
execute unless data storage mce:lib_math Value run data modify storage mce:error Code set value "ERR_NO_VALUE"
execute unless data storage mce:lib_math Value run function mce:core/error/raise

execute unless data storage mce:lib_math Min run data modify storage mce:error Last set value "mce:lib_math Min is not set — provide an int before calling lib/math/clamp"
execute unless data storage mce:lib_math Min run data modify storage mce:error Code set value "ERR_NO_MIN"
execute unless data storage mce:lib_math Min run function mce:core/error/raise

execute unless data storage mce:lib_math Max run data modify storage mce:error Last set value "mce:lib_math Max is not set — provide an int before calling lib/math/clamp"
execute unless data storage mce:lib_math Max run data modify storage mce:error Code set value "ERR_NO_MAX"
execute unless data storage mce:lib_math Max run function mce:core/error/raise

execute if data storage mce:lib_math Value if data storage mce:lib_math Min if data storage mce:lib_math Max run function mce:core/lib/math/clamp_calc
