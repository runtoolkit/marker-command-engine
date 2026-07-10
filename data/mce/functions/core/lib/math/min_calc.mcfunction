# Private: not part of MCE public API — subject to change without notice

execute store result score #math.a mce.log run data get storage mce:lib_math A
execute store result score #math.b mce.log run data get storage mce:lib_math B

scoreboard players operation #math.result mce.log = #math.a mce.log
execute if score #math.b mce.log < #math.result mce.log run scoreboard players operation #math.result mce.log = #math.b mce.log

execute store result storage mce:output Math.Min.result int 1 run scoreboard players get #math.result mce.log
