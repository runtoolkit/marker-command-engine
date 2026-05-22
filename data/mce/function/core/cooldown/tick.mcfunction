# Private: not part of MCE public API — subject to change without notice
# Decrements mce.cd for all players who are on cooldown.
# Runs every tick via minecraft:tick tag.

scoreboard players remove @a[scores={mce.cd=1..}] mce.cd 1
