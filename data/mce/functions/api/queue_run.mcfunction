# Start executing all commands in the queue sequentially (one per 5 ticks).
# Call this after adding all commands with mce:api/queue_add.
# Usage:
#   function mce:api/queue_run

execute store result score #mce.size mce.queue run data get storage mce:queue commands
execute if score #mce.size mce.queue matches 1.. run function mce:core/queue_init