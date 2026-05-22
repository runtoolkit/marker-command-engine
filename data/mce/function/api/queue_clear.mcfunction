# PUBLIC API — mce:api/queue_clear
# MCE version: 1.1.0
#
# Clear all pending commands from the queue without executing them.

data remove storage mce:queue commands
schedule clear mce:core/queue_tick
