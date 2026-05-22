# PUBLIC API — mce:api/queue/clear
# MCE version: 1.1.0
#
# Clear all pending commands from the queue without executing them.
# Usage: function mce:api/queue/clear

data remove storage mce:queue commands
schedule clear mce:core/queue/tick
