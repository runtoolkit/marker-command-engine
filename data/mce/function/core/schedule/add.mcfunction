# Private: not part of MCE public API — subject to change without notice
data modify storage mce:schedule jobs append value {cmd:"",ticks:0}
data modify storage mce:schedule jobs[-1].cmd set from storage mce:cmd Command
data modify storage mce:schedule jobs[-1].ticks set from storage mce:cmd Delay
data remove storage mce:cmd Command
data remove storage mce:cmd Delay
