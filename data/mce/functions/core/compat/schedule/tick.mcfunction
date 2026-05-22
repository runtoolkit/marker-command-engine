# Private: not part of MCE public API — subject to change without notice
# 1.19.x+ compat — no return, scoreboard guard

execute store result score #sched.exists mce.compat run data get storage mce:schedule jobs
execute if score #sched.exists mce.compat matches 1.. run scoreboard players operation #sched.size mce.tick = #sched.exists mce.compat
execute if score #sched.exists mce.compat matches 1.. run function mce:core/compat/schedule/iter
