# Private: not part of MCE public API — subject to change without notice
# 1.19.x+ compat — no return

execute if score #sched.size mce.tick matches 1.. run function mce:core/compat/schedule/iter_step
