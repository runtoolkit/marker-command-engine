# PUBLIC API — mce:api/run/at
# MCE version: 2.0.0 (extended)
#
# Execute the command stored in mce:cmd Command at a fixed coordinate.
# The command runs from world position (mce:cmd AtX, AtY, AtZ).
# All three coordinates must be set before calling.
# Compatible with Minecraft 1.20.1+
#
# Input:
# mce:cmd Command — string, the command to execute
# mce:cmd AtX — int, X coordinate
# mce:cmd AtY — int, Y coordinate
# mce:cmd AtZ — int, Z coordinate
#
# Usage:
# data modify storage mce:cmd Command set value "say Hi from coords!"
# data modify storage mce:cmd AtX set value 0
# data modify storage mce:cmd AtY set value 64
# data modify storage mce:cmd AtZ set value 0
# function mce:api/run/at

execute unless data storage mce:cmd Command run data modify storage mce:error Last set value "mce:cmd Command is not set"
execute unless data storage mce:cmd Command run data modify storage mce:error Code set value "ERR_NO_CMD"
execute unless data storage mce:cmd Command run function mce:core/error/raise
execute unless data storage mce:cmd Command run return 0

execute unless data storage mce:cmd AtX run data modify storage mce:error Last set value "mce:cmd AtX/AtY/AtZ coordinates are not set — all three required"
execute unless data storage mce:cmd AtX run data modify storage mce:error Code set value "ERR_NO_COORDS"
execute unless data storage mce:cmd AtX run function mce:core/error/raise
execute unless data storage mce:cmd AtX run return 0

execute unless data storage mce:cmd AtY run data modify storage mce:error Last set value "mce:cmd AtY is not set — all three coordinates (AtX/AtY/AtZ) required"
execute unless data storage mce:cmd AtY run data modify storage mce:error Code set value "ERR_NO_COORDS"
execute unless data storage mce:cmd AtY run function mce:core/error/raise
execute unless data storage mce:cmd AtY run return 0

execute unless data storage mce:cmd AtZ run data modify storage mce:error Last set value "mce:cmd AtZ is not set — all three coordinates (AtX/AtY/AtZ) required"
execute unless data storage mce:cmd AtZ run data modify storage mce:error Code set value "ERR_NO_COORDS"
execute unless data storage mce:cmd AtZ run function mce:core/error/raise
execute unless data storage mce:cmd AtZ run return 0

function mce:core/run/at_build
