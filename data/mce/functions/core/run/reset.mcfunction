# Private: not part of MCE public API — subject to change without notice
data modify block 0 -64 0 auto set value 0b
setblock 0 -64 0 minecraft:air replace
kill @e[type=minecraft:marker,tag=mce.cmd,limit=1]
data remove storage mce:cmd Command
schedule clear mce:core/run/reset

execute if data storage mce:temp {mode:"run_as"} run tag @e remove mce.executor
execute if data storage mce:temp {mode:"run_as"} run data remove storage mce:cmd Command