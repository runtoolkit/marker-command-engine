# Objectives
scoreboard objectives remove mce.queue
scoreboard objectives remove mce.log
scoreboard objectives remove loadMCE
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
scoreboard objectives add loadMCE trigger
tellraw @a ["",{"text":"[MCE] ","color":"aqua"},{"text":"Marker Command Engine v2.3.0 reseted!","color":"yellow"}]
