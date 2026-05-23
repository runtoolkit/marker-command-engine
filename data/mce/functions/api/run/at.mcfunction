# PUBLIC API — mce:api/run/at
# MCE version: 2.0.0
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

function mce:core/run/at_build
