# Private: not part of MCE public API — subject to change without notice
execute if score #sched.size mce.tick matches 1.. run execute store result score #sched.ticks mce.tick run data get storage mce:schedule jobs[0].ticks
execute if score #sched.size mce.tick matches 1.. run scoreboard players remove #sched.ticks mce.tick 1

execute if score #sched.size mce.tick matches 1.. if score #sched.ticks mce.tick matches ..0 run function mce:core/schedule/fire_iter
execute if score #sched.size mce.tick matches 1.. if score #sched.ticks mce.tick matches 1.. run function mce:core/schedule/defer_iter

execute if score #sched.size mce.tick matches 1.. run scoreboard players remove #sched.size mce.tick 1
execute if score #sched.size mce.tick matches 1.. run function mce:core/schedule/iter
