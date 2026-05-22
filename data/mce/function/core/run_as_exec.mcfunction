# Private: not part of MCE public API — subject to change without notice
function mce:core/run_as_build with storage mce:cmd

data remove storage mce:cmd Executor

function mce:core/setup_marker
setblock 0 -64 0 minecraft:command_block{Command:"",auto:0b,TrackOutput:0b} replace
data modify block 0 -64 0 Command set from storage mce:cmd Command
data modify block 0 -64 0 auto set value 1b

schedule function mce:core/reset 3t replace
