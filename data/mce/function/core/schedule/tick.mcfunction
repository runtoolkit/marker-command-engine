# Private: not part of MCE public API — subject to change without notice
execute if data storage mce:schedule jobs[0] run execute store result score #sched.size mce.tick run data get storage mce:schedule jobs
execute if data storage mce:schedule jobs[0] run function mce:core/schedule/iter
