# PUBLIC API — mce:api/schedule/clear
# MCE version: 1.1.0
#
# Cancel ALL pending scheduled commands.
# Usage: function mce:api/schedule/clear

data remove storage mce:schedule jobs
tellraw @s [{"text":"[MCE] ","color":"aqua"},{"text":"All scheduled jobs cleared.","color":"red"}]
