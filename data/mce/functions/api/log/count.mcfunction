# PUBLIC API — mce:api/log/count
# MCE version: 2.2.0
#
# Reads the current number of entries stored in the in-memory log.
# Output: mce:output Log.count (int, number of entries currently held; max 64)
# Macro-free. Compatible with Minecraft 1.19.3+
#
# Usage:
#   function mce:api/log/count
#   data get storage mce:output Log.count

execute store result storage mce:output Log.count int 1 run data get storage mce:log entries
