# Macro: merges Executor + Command into a wrapped "execute as ... run ..." command
# Must be called via: function mce:core/run_as_build with storage mce:cmd
$data modify storage mce:cmd Command set value "execute as $(Executor) run $(Command)"
