# PUBLIC API — mce:api/queue/add
# MCE version: 1.1.0
#
# Add the command stored in mce:cmd Command to the execution queue.
# Usage:
#   data modify storage mce:cmd Command set value "say First!"
#   function mce:api/queue/add
#   data modify storage mce:cmd Command set value "say Second!"
#   function mce:api/queue/add
#   function mce:api/queue/run

data modify storage mce:queue commands append from storage mce:cmd Command
data remove storage mce:cmd Command
