# PUBLIC API — mce:lib/string/is_empty
# MCE version: 2.4.0 (lib)
#
# Checks whether a string is exactly "" (empty).
# No macros used. Compatible with Minecraft 1.20.1+.
#
# Input:
#   mce:lib_string Value — string (required key; value itself may be "")
#
# Output:
#   mce:output String.IsEmpty.result — 1b if Value == "", else 0b
#   mce:output String.IsEmpty.set    — 1b if the Value key exists at all, else 0b
#
# Usage:
#   data modify storage mce:lib_string Value set value ""
#   function mce:lib/string/is_empty
#   data get storage mce:output String.IsEmpty.result

execute unless data storage mce:lib_string Value run data modify storage mce:error Last set value "mce:lib_string Value is not set — provide a (possibly empty) string before calling lib/string/is_empty"
execute unless data storage mce:lib_string Value run data modify storage mce:error Code set value "ERR_NO_VALUE"
execute unless data storage mce:lib_string Value run function mce:core/error/raise

data modify storage mce:output String.IsEmpty.set set value 0b
execute if data storage mce:lib_string Value run data modify storage mce:output String.IsEmpty.set set value 1b

data modify storage mce:output String.IsEmpty.result set value 0b
execute if data storage mce:lib_string{Value:""} run data modify storage mce:output String.IsEmpty.result set value 1b
