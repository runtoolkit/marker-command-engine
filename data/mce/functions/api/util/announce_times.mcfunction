# PUBLIC API — mce:api/util/announce_times
# MCE version: 2.0.0
#
# Sets custom title timing for subsequent title/subtitle/announce calls.
# Call this BEFORE mce:api/util/announce if you want non-default timing.
#
# Uses Minecraft's preset-compatible timings. Supported presets (fi/st/fo):
# fast : 5 / 30 / 5
# normal : 10 / 70 / 20 (Minecraft default)
# slow : 20 / 100 / 20
# instant : 0 / 40 / 0
#
# Input:
# mce:announce_times Preset — string, one of: "fast" "normal" "slow" "instant"
# Omit to use "normal".
#
# Usage:
# data modify storage mce:announce_times Preset set value "fast"
# function mce:api/util/announce_times

execute if data storage mce:announce_times {Preset:"fast"} run title @s times 5 30 5
execute if data storage mce:announce_times {Preset:"slow"} run title @s times 20 100 20
execute if data storage mce:announce_times {Preset:"instant"} run title @s times 0 40 0
execute unless data storage mce:announce_times {Preset:"fast"} unless data storage mce:announce_times {Preset:"slow"} unless data storage mce:announce_times {Preset:"instant"} run title @s times 10 70 20

data remove storage mce:announce_times Preset
