# Private: not part of MCE public API — subject to change without notice
# Dispatches a "title" entry from mce:text_dispatch entry.
# Fields: target (required), title (optional), subtitle (optional), preset (optional)
# Compatible with Minecraft 1.19.3+

# At least one of title or subtitle must be present
execute unless data storage mce:text_dispatch entry.title unless data storage mce:text_dispatch entry.subtitle run data modify storage mce:error Last set value "text/batch entry type=title requires at least one of: title, subtitle"
execute unless data storage mce:text_dispatch entry.title unless data storage mce:text_dispatch entry.subtitle run data modify storage mce:error Code set value "ERR_TEXT_NO_TITLE"
execute unless data storage mce:text_dispatch entry.title unless data storage mce:text_dispatch entry.subtitle run function mce:core/error/raise

# Apply timing preset (mirrors announce_times logic)
# preset defaults to "normal" if absent
execute if data storage mce:text_dispatch {entry:{preset:"fast"}} run title @a times 5 30 5
execute if data storage mce:text_dispatch {entry:{preset:"slow"}} run title @a times 20 100 20
execute if data storage mce:text_dispatch {entry:{preset:"instant"}} run title @a times 0 40 0
execute unless data storage mce:text_dispatch {entry:{preset:"fast"}} unless data storage mce:text_dispatch {entry:{preset:"slow"}} unless data storage mce:text_dispatch {entry:{preset:"instant"}} run title @a times 10 70 20

# Send title / subtitle if present
execute if data storage mce:text_dispatch entry.title run title @a title {"storage":"mce:text_dispatch","nbt":"entry.title","interpret":false}
execute if data storage mce:text_dispatch entry.subtitle run title @a subtitle {"storage":"mce:text_dispatch","nbt":"entry.subtitle","interpret":false}
