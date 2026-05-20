# Add all commands from mce:batch commands list to the queue in one call.
# More efficient than calling queue_add repeatedly when commands are already in a list.
#
# Usage:
#   data modify storage mce:batch commands set value ["say First!", "say Second!", "give @s minecraft:diamond 1"]
#   function mce:api/batch
#
# Note: mce:batch commands is cleared after merging.
# You can call batch multiple times before queue_run to accumulate commands.

# Merge all commands from mce:batch into the queue
data modify storage mce:queue commands append from storage mce:batch commands[]

# Run Command
function mce:api/queue_run

# Clear the batch staging area
data remove storage mce:batch commands
