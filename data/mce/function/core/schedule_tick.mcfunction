# Private: not part of MCE public API — subject to change without notice
execute unless data storage mce:schedule jobs[0] run return 0

execute store result score #sched.size mce.tick run data get storage mce:schedule jobs

function mce:core/schedule_iter
