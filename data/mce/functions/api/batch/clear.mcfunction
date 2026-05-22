# PUBLIC API — mce:api/batch/clear
# MCE version: 1.1.0
#
# Clear all pending commands from the batch staging area without queuing them.
# Usage: function mce:api/batch/clear

data remove storage mce:batch commands
