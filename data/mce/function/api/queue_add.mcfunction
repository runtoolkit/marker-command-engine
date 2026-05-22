# PUBLIC API — mce:api/queue_add
# MCE version: 1.1.0
#
# Add the command stored in mce:cmd Command to the execution queue.
# Usage:
#   data modify storage mce:cmd Command set value "say First!"
#   function mce:api/queue_add
#   data modify storage mce:cmd Command set value "say Second!"
#   function mce:api/queue_add
#   function mce:api/queue_run

data modify storage mce:queue commands append from storage mce:cmd Command

data remove storage mce:cmd Command
