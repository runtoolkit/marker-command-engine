# PUBLIC API — mce:api/queue/run
# MCE version: 1.1.0
#
# Start executing all commands in the queue (one per 3 ticks).
# Usage: function mce:api/queue/run

execute store result score #mce.size mce.queue run data get storage mce:queue commands
execute if score #mce.size mce.queue matches 1.. run function mce:core/queue/tick
