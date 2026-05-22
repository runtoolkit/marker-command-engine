# PUBLIC API — mce:api/batch_clear
# MCE version: 1.1.0
#
# Clear all pending commands from the batch staging area without queuing them.
# Usage:
#   function mce:api/batch_clear

data remove storage mce:batch commands
