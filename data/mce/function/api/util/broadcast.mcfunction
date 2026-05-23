# PUBLIC API — mce:api/util/broadcast
# MCE version: 2.0.1 (extended)
#
# Sends a chat message to ALL online players from storage.
# Macro-free. Compatible with Minecraft 1.19.3+.
#
# Input:
#   mce:broadcast Msg    — string, the message text (required)
#   mce:broadcast Prefix — string, prefix shown before message (optional)
#
# Usage:
#   data modify storage mce:broadcast Prefix set value "[Server]"
#   data modify storage mce:broadcast Msg set value "Maintenance in 5 minutes."
#   function mce:api/util/broadcast

execute unless data storage mce:broadcast Msg run data modify storage mce:error Last set value "mce:broadcast Msg is not set — provide a message before calling broadcast"
execute unless data storage mce:broadcast Msg run data modify storage mce:error Code set value "ERR_NO_MSG"
execute unless data storage mce:broadcast Msg run function mce:core/error/raise
execute unless data storage mce:broadcast Msg run return 0

execute if data storage mce:broadcast Prefix run tellraw @a ["",{"storage":"mce:broadcast","nbt":"Prefix","color":"gold"},{"text":" "},{"storage":"mce:broadcast","nbt":"Msg","color":"white"}]
execute unless data storage mce:broadcast Prefix run tellraw @a [{"storage":"mce:broadcast","nbt":"Msg","color":"white"}]

data remove storage mce:broadcast Prefix
data remove storage mce:broadcast Msg
