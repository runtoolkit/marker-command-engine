# Private: not part of MCE public API — subject to change without notice
execute store result storage mce:schedule jobs[0].ticks int 1 run scoreboard players get #sched.ticks mce.tick

data modify storage mce:schedule jobs append from storage mce:schedule jobs[0]
data remove storage mce:schedule jobs[0]
