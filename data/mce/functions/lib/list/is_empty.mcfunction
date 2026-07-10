# PUBLIC API — mce:lib/list/is_empty
# MCE version: 2.4.0 (lib)
#
# Checks whether a list has zero elements (or the key is missing).
# No macros used. Compatible with Minecraft 1.20.1+.
# Internally reuses lib/list/length.
#
# Input:
#   mce:lib_list Values — list (required; may be empty [])
#
# Output:
#   mce:output List.IsEmpty.result — 1b if Values has 0 elements (or is missing), else 0b
#
# Usage:
#   data modify storage mce:lib_list Values set value []
#   function mce:lib/list/is_empty
#   data get storage mce:output List.IsEmpty.result

data modify storage mce:output List.Length.result set value 0
execute if data storage mce:lib_list Values store result storage mce:output List.Length.result int 1 run data get storage mce:lib_list Values

data modify storage mce:output List.IsEmpty.result set value 0b
execute if data storage mce:output{List:{Length:{result:0}}} run data modify storage mce:output List.IsEmpty.result set value 1b
