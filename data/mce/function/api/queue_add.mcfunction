# Add the command stored in mce:cmd Command to the execution queue.
# Usage:
#   data modify storage mce:cmd Command set value "say First!"
#   function mce:api/queue_add
#   data modify storage mce:cmd Command set value "say Second!"
#   function mce:api/queue_add
#   function mce:api/queue_run

# Append current Command to queue list
data modify storage mce:queue commands append from storage mce:cmd Command

# Clear staging slot
data remove storage mce:cmd Command