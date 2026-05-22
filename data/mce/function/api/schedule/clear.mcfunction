# PUBLIC API — mce:api/schedule/clear
# MCE version: 1.1.0
#
# Cancel ALL pending scheduled commands.
# Usage: function mce:api/schedule/clear

execute if data storage mce:schedule jobs[0] run tellraw @s [{"text":"[MCE] ","color":"aqua"},{"text":"All scheduled jobs cleared.","color":"red"}]
data remove storage mce:schedule jobs
