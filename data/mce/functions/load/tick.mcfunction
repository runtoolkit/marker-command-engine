execute as @a[scores={loadMCE=1}] run function mce:core/load
execute as @a[scores={loadMCE=2}] run function mce:core/cancel
scoreboard players set @a[scores={loadMCE=1..}] loadMCE 0
