# Get current queue size
execute store result score #mce.size mce.queue run data get storage mce:queue commands

# If queue is empty, stop
execute if score #mce.size mce.queue matches 0 run return 0
execute unless data storage mce:queue commands[0] run return 0

# Copy first command to staging slot
data modify storage mce:cmd Command set from storage mce:queue commands[0]

# Remove first element
data remove storage mce:queue commands[0]

# Run the command
function mce:core/run_cmd

# Schedule next if more remain
execute store result score #mce.size mce.queue run data get storage mce:queue commands
execute if score #mce.size mce.queue matches 1.. run schedule function mce:core/queue_run 3t replace
