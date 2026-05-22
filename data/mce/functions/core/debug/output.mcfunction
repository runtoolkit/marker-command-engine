# Private: not part of MCE public API — subject to change without notice

execute as @a[tag=mce.debug_caller] run tellraw @s [{"text":"[MCE] CMD: ","color":"aqua"},{"storage":"mce:cmd","nbt":"Command","color":"yellow"}]
execute as @a[tag=mce.debug_caller] run tellraw @s [{"text":"[MCE] OUT: ","color":"aqua"},{"block":"0 -64 0","nbt":"LastOutput","interpret":true}]
tag @a remove mce.debug_caller
