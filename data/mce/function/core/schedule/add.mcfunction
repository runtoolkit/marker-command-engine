# Private: not part of MCE public API — subject to change without notice

# Guard: require Delay >= 1
execute store result score #sched.delay mce.tick run data get storage mce:cmd Delay
execute if score #sched.delay mce.tick matches ..0 run return 1

data modify storage mce:schedule jobs append value {cmd:"",ticks:0}
data modify storage mce:schedule jobs[-1].cmd set from storage mce:cmd Command
data modify storage mce:schedule jobs[-1].ticks set from storage mce:cmd Delay
data remove storage mce:cmd Command
data remove storage mce:cmd Delay
