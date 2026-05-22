# Private: not part of MCE public API — subject to change without notice
# Macro: merges Executor + Command into a wrapped "execute as ... run ..." command
$data modify storage mce:cmd Command set value "execute as $(Executor) run $(Command)"
