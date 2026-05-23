# PUBLIC API — mce:api/multi/run
# MCE version: 2.1.0
#
# Executes multiple action types in a single call.
# All keys are optional — only the ones set will be executed.
# Execution order: title -> subtitle -> actionbar -> msg -> cmd
#
# Inputs (all optional):
#   mce:multi Title     — string, raw JSON text component for title
#   mce:multi Subtitle  — string, raw JSON text component for subtitle
#   mce:multi Actionbar — string, raw JSON text component for actionbar
#   mce:multi Msg       — string, raw JSON text component sent via tellraw
#   mce:multi Cmd       — string, command to execute via mce:api/run/cmd
#
# For plain text (no formatting):
#   data modify storage mce:multi Title set value '{"text":"Hello!"}'
#
# For styled text:
#   data modify storage mce:multi Title set value '{"text":"Hello!","color":"gold","bold":true}'
#
# Usage:
#   data modify storage mce:multi Title set value '{"text":"Welcome!","color":"gold"}'
#   data modify storage mce:multi Subtitle set value '{"text":"Good luck.","color":"gray"}'
#   data modify storage mce:multi Msg set value '{"text":"[Server] Game starting!","color":"aqua"}'
#   data modify storage mce:multi Cmd set value "function ns:game/start"
#   function mce:api/multi/run

execute if data storage mce:multi Title run title @s title {"storage":"mce:multi","nbt":"Title","interpret":true}
execute if data storage mce:multi Subtitle run title @s subtitle {"storage":"mce:multi","nbt":"Subtitle","interpret":true}
execute if data storage mce:multi Actionbar run title @s actionbar {"storage":"mce:multi","nbt":"Actionbar","interpret":true}
execute if data storage mce:multi Msg run tellraw @s {"storage":"mce:multi","nbt":"Msg","interpret":true}

execute if data storage mce:multi Cmd run data modify storage mce:cmd Command set from storage mce:multi Cmd
execute if data storage mce:multi Cmd run function mce:core/run/cmd

data remove storage mce:multi Title
data remove storage mce:multi Subtitle
data remove storage mce:multi Actionbar
data remove storage mce:multi Msg
data remove storage mce:multi Cmd
