# Private: not part of MCE public API — subject to change without notice

execute store result score #math.val mce.log run data get storage mce:lib_math Value
execute store result score #math.min mce.log run data get storage mce:lib_math Min
execute store result score #math.max mce.log run data get storage mce:lib_math Max

scoreboard players operation #math.result mce.log = #math.val mce.log
execute if score #math.result mce.log < #math.min mce.log run scoreboard players operation #math.result mce.log = #math.min mce.log
execute if score #math.result mce.log > #math.max mce.log run scoreboard players operation #math.result mce.log = #math.max mce.log

execute store result storage mce:output Math.Clamp.result int 1 run scoreboard players get #math.result mce.log
