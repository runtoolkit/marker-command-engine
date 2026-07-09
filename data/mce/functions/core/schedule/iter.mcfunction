# Private: not part of MCE public API — subject to change without notice
#
# Recursion guard: this function recurses once per remaining job in
# mce:schedule jobs, all within the SAME tick. With enough queued jobs
# this can approach the engine's function-call recursion ceiling and
# silently truncate (remaining jobs stop being touched this tick — they
# are still walked next tick since #sched.size is re-derived from the
# real list length each tick, so no job is lost or double-fired, but a
# very large backlog will drain slower than one job per tick).
# #mce.sched_guard caps same-tick recursion depth; anything beyond the
# cap is picked up on the next tick automatically.
scoreboard players add #mce.sched_guard mce.tick 1

execute if score #sched.size mce.tick matches 1.. if score #mce.sched_guard mce.tick matches ..4000 run execute store result score #sched.ticks mce.tick run data get storage mce:schedule jobs[0].ticks
execute if score #sched.size mce.tick matches 1.. if score #mce.sched_guard mce.tick matches ..4000 run scoreboard players remove #sched.ticks mce.tick 1

execute if score #sched.size mce.tick matches 1.. if score #mce.sched_guard mce.tick matches ..4000 if score #sched.ticks mce.tick matches ..0 run function mce:core/schedule/fire_iter
execute if score #sched.size mce.tick matches 1.. if score #mce.sched_guard mce.tick matches ..4000 if score #sched.ticks mce.tick matches 1.. run function mce:core/schedule/defer_iter

execute if score #sched.size mce.tick matches 1.. if score #mce.sched_guard mce.tick matches ..4000 run scoreboard players remove #sched.size mce.tick 1
execute if score #sched.size mce.tick matches 1.. if score #mce.sched_guard mce.tick matches ..4000 run function mce:core/schedule/iter
