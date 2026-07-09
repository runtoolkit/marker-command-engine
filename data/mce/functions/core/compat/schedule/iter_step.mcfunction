# Private: not part of MCE public API — subject to change without notice
# Same recursion-depth guard as core/schedule/iter — see that file for details.
scoreboard players add #mce.sched_guard mce.tick 1

execute if score #mce.sched_guard mce.tick matches ..4000 run execute store result score #sched.ticks mce.tick run data get storage mce:schedule jobs[0].ticks
execute if score #mce.sched_guard mce.tick matches ..4000 run scoreboard players remove #sched.ticks mce.tick 1

execute if score #mce.sched_guard mce.tick matches ..4000 if score #sched.ticks mce.tick matches ..0 run function mce:core/schedule/fire_iter
execute if score #mce.sched_guard mce.tick matches ..4000 if score #sched.ticks mce.tick matches 1.. run function mce:core/schedule/defer_iter

execute if score #mce.sched_guard mce.tick matches ..4000 run scoreboard players remove #sched.size mce.tick 1
execute if score #mce.sched_guard mce.tick matches ..4000 if score #sched.size mce.tick matches 1.. run function mce:core/compat/schedule/iter_step
