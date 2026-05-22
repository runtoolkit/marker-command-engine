# Private: not part of MCE public API — subject to change without notice
data modify storage mce:queue commands append from storage mce:batch commands[]
data remove storage mce:batch commands
function mce:api/queue/run
