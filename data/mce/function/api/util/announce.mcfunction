# PUBLIC API — mce:api/util/announce
# MCE version: 2.0.0
#
# Sends title, subtitle, and/or actionbar messages to @s in a single call.
# Each key is optional — omit any key to skip that display slot.
# For custom timing call mce:api/util/announce_times before this function.
# Compatible with Minecraft 1.19.3+
#
# Input (all optional):
# mce:announce Title — string, large center title
# mce:announce Subtitle — string, small text below title
# mce:announce Actionbar — string, text above hotbar
#
# Usage:
# data modify storage mce:announce Title set value "Welcome!"
# data modify storage mce:announce Subtitle set value "Enjoy your stay."
# data modify storage mce:announce Actionbar set value "Server online"
# function mce:api/util/announce
#
# With custom timing:
# data modify storage mce:announce_times Preset set value "fast"
# function mce:api/util/announce_times
# data modify storage mce:announce Title set value "Go!"
# function mce:api/util/announce

execute if data storage mce:announce Title run title @s title {"storage":"mce:announce","nbt":"Title","interpret":false}
execute if data storage mce:announce Subtitle run title @s subtitle {"storage":"mce:announce","nbt":"Subtitle","interpret":false}
execute if data storage mce:announce Actionbar run title @s actionbar {"storage":"mce:announce","nbt":"Actionbar","interpret":false}

data remove storage mce:announce Title
data remove storage mce:announce Subtitle
data remove storage mce:announce Actionbar
