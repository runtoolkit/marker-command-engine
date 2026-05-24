# Private: not part of MCE public API — subject to change without notice
# Dispatches an "actionbar" entry from mce:text_dispatch entry.
# Fields: target (required), msg (required)
# Compatible with Minecraft 1.19.3+

execute unless data storage mce:text_dispatch entry.msg run data modify storage mce:error Last set value "text/batch entry type=actionbar is missing field: msg"
execute unless data storage mce:text_dispatch entry.msg run data modify storage mce:error Code set value "ERR_TEXT_NO_MSG"
execute unless data storage mce:text_dispatch entry.msg run function mce:core/error/raise

execute if data storage mce:text_dispatch entry.msg run title @a actionbar {"storage":"mce:text_dispatch","nbt":"entry.msg","interpret":false}
