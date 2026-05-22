# PUBLIC API — mce:api/schedule
# MCE version: 1.1.0
#
# Schedule a command to run after a delay (MCE alternative to /schedule).
# Does NOT lose @s context — caller tag is stored with the job.
#
# Usage:
#   data modify storage mce:cmd Command set value "say Hello!"
#   data modify storage mce:cmd Delay set value 40
#   function mce:api/schedule
#
# Delay unit: ticks (20t = 1s)
# Multiple schedules can be pending simultaneously.
# Does NOT replace existing schedules — all jobs are independent.

function mce:core/schedule_add
