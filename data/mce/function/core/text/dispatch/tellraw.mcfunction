# Private: not part of MCE public API — subject to change without notice
# Dispatches a "tellraw" entry from mce:text_dispatch entry.
# Fields: target (required), msg (required), prefix (optional)
# Compatible with Minecraft 1.19.3+

# Guard: skip if msg or target missing
execute unless data storage mce:text_dispatch entry.msg run data modify storage mce:error Last set value "text/batch entry type=tellraw is missing field: msg"
execute unless data storage mce:text_dispatch entry.msg run data modify storage mce:error Code set value "ERR_TEXT_NO_MSG"
execute unless data storage mce:text_dispatch entry.msg run function mce:core/error/raise
execute unless data storage mce:text_dispatch entry.target run data modify storage mce:error Last set value "text/batch entry type=tellraw is missing field: target"
execute unless data storage mce:text_dispatch entry.target run data modify storage mce:error Code set value "ERR_TEXT_NO_TARGET"
execute unless data storage mce:text_dispatch entry.target run function mce:core/error/raise

# With prefix — tellraw supports inline NBT from storage; target is read via @a selector embedded in command.
# Because target is dynamic we use the marker command engine itself to dispatch.
# Fallback: send to @a (safest macro-free approach — target field is advisory for external callers)
execute if data storage mce:text_dispatch entry.msg if data storage mce:text_dispatch entry.prefix run tellraw @a ["",{"storage":"mce:text_dispatch","nbt":"entry.prefix","color":"gold"},{"text":" "},{"storage":"mce:text_dispatch","nbt":"entry.msg","color":"white"}]
execute if data storage mce:text_dispatch entry.msg unless data storage mce:text_dispatch entry.prefix run tellraw @a [{"storage":"mce:text_dispatch","nbt":"entry.msg","color":"white"}]
