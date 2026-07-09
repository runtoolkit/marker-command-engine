# Objectives
scoreboard objectives add mce.queue dummy
scoreboard objectives add mce.tick dummy
scoreboard objectives add mce.compat dummy
scoreboard objectives add mce.cd dummy
scoreboard objectives add mce.log dummy
scoreboard objectives add loadMCE
scoreboard players reset #tick mce.tick
scoreboard players reset #queue.active mce.compat
scoreboard players reset #sched.exists mce.compat
scoreboard players reset #error.count mce.queue

# Storages
data remove storage mce:error Last
data remove storage mce:error Code
data remove storage mce:queue commands
data remove storage mce:schedule jobs
data remove storage mce:log entries
data remove storage mce:text_batch entries
data remove storage mce:batch commands
data remove storage mce:config mce.debug
data remove storage mce:config mce.queue_interval
data remove storage mce:config mce.track_output
data remove storage mce:config api.announce_default_preset

# Debug / Tellraw
tellraw @a ["",{"text":"[MCE] ","color":"aqua"},{"text":"Marker Command Engine v2.3.0 reseted!","color":"yellow"}]
