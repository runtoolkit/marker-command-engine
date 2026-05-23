# PUBLIC API — mce:api/batch/run
# MCE version: 1.1.0 (extended)
#
# Add all commands in mce:batch commands list to queue and run them.
# Usage:
#   data modify storage mce:batch commands set value ["say 1","say 2","say 3"]
#   function mce:api/batch/run

execute unless data storage mce:batch commands run data modify storage mce:error Last set value "mce:batch commands is not set or empty"
execute unless data storage mce:batch commands run data modify storage mce:error Code set value "ERR_NO_BATCH"
execute unless data storage mce:batch commands run function mce:core/error/raise
execute unless data storage mce:batch commands run return 0

function mce:core/batch/run
