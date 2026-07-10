# PUBLIC API — mce:lib/list/length
# MCE version: 2.4.0 (lib)
#
# Returns the number of elements in a list. No macros used. Uses the
# well-known vanilla trick: `execute store result` on a `data get` of a
# list stores its element count (not its NBT byte size) into a score.
# Compatible with Minecraft 1.20.1+.
#
# Input:
#   mce:lib_list Values — list (required; may be empty [])
#
# Output:
#   mce:output List.Length.result — int, number of elements
#
# Usage:
#   data modify storage mce:lib_list Values set value ["a","b","c"]
#   function mce:lib/list/length
#   data get storage mce:output List.Length.result

execute unless data storage mce:lib_list Values run data modify storage mce:error Last set value "mce:lib_list Values is not set — provide a list before calling lib/list/length"
execute unless data storage mce:lib_list Values run data modify storage mce:error Code set value "ERR_NO_VALUES"
execute unless data storage mce:lib_list Values run function mce:core/error/raise

data modify storage mce:output List.Length.result set value 0
execute if data storage mce:lib_list Values store result storage mce:output List.Length.result int 1 run data get storage mce:lib_list Values
