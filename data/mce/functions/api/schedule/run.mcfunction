# PUBLIC API — mce:api/schedule/run
# MCE version: 1.1.0 (extended)
#
# Schedule a command to run after a delay (MCE alternative to /schedule).
# Does NOT lose @s context — caller tag is stored with the job.
# Compatible with Minecraft 1.19.3+
#
# Usage:
#   data modify storage mce:cmd Command set value "say Hello!"
#   data modify storage mce:cmd Delay set value 40
#   function mce:api/schedule/run
#
# Delay unit: ticks (20t = 1s)
# Multiple schedules can be pending simultaneously.

execute unless data storage mce:cmd Command run data modify storage mce:error Last set value "mce:cmd Command is not set"
execute unless data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_NO_CMD"
execute unless data storage mce:cmd Command run function mce:core/error/raise

execute unless data storage mce:cmd Delay if data storage mce:cmd Command run data modify storage mce:error Last set value "mce:cmd Delay is not set — provide tick count (e.g. set value 40)"
execute unless data storage mce:cmd Delay if data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_NO_DELAY"
execute unless data storage mce:cmd Delay if data storage mce:cmd Command run function mce:core/error/raise

execute if data storage mce:cmd Command if data storage mce:cmd Delay run execute store result score #sched.pre mce.tick run data get storage mce:cmd Delay
execute if score #sched.pre mce.tick matches ..0 if data storage mce:cmd Command run data modify storage mce:error Last set value "mce:cmd Delay must be >= 1 tick"
execute if score #sched.pre mce.tick matches ..0 if data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_DELAY_ZERO"
execute if score #sched.pre mce.tick matches ..0 if data storage mce:cmd Command run function mce:core/error/raise

execute if data storage mce:cmd Command if data storage mce:cmd Delay if score #sched.pre mce.tick matches 1.. run function mce:core/schedule/add
