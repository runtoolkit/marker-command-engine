# PUBLIC API — mce:api/compat/queue/run
# MCE version: 1.1.0
# 1.19.x+ compat version of mce:api/queue/run — no return statement
#
# Usage: function mce:api/compat/queue/run

execute store result score #mce.size mce.queue run data get storage mce:queue commands
execute if score #mce.size mce.queue matches 1.. run function mce:core/compat/queue/tick
