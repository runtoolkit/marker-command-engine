# PUBLIC API — mce:lib/math/max
# MCE version: 2.4.0 (lib)
#
# Returns the larger of A and B. No macros used. Compatible with
# Minecraft 1.20.1+.
#
# Input:
#   mce:lib_math A — int (required)
#   mce:lib_math B — int (required)
#
# Output:
#   mce:output Math.Max.result — int, max(A, B)
#
# Usage:
#   data modify storage mce:lib_math A set value 5
#   data modify storage mce:lib_math B set value 12
#   function mce:lib/math/max
#   data get storage mce:output Math.Max.result

execute unless data storage mce:lib_math A run data modify storage mce:error Last set value "mce:lib_math A is not set — provide an int before calling lib/math/max"
execute unless data storage mce:lib_math A run data modify storage mce:error Code set value "ERR_NO_A"
execute unless data storage mce:lib_math A run function mce:core/error/raise

execute unless data storage mce:lib_math B run data modify storage mce:error Last set value "mce:lib_math B is not set — provide an int before calling lib/math/max"
execute unless data storage mce:lib_math B run data modify storage mce:error Code set value "ERR_NO_B"
execute unless data storage mce:lib_math B run function mce:core/error/raise

execute if data storage mce:lib_math A if data storage mce:lib_math B run function mce:core/lib/math/max_calc
