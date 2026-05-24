# Private: not part of MCE public API — subject to change without notice
# Iterates mce:text_batch entries[0], dispatches by type, removes entry, recurses.
# Compatible with Minecraft 1.19.3+

execute unless data storage mce:text_batch entries[0] run scoreboard players set #text.iter.done mce.tick 1
execute if data storage mce:text_batch entries[0] run scoreboard players set #text.iter.done mce.tick 0

# Copy current entry to scratch storage for dispatch functions
execute if score #text.iter.done mce.tick matches 0 run data modify storage mce:text_dispatch entry set from storage mce:text_batch entries[0]

# Dispatch based on type
execute if score #text.iter.done mce.tick matches 0 if data storage mce:text_dispatch {entry:{type:"tellraw"}} run function mce:core/text/dispatch/tellraw
execute if score #text.iter.done mce.tick matches 0 if data storage mce:text_dispatch {entry:{type:"title"}} run function mce:core/text/dispatch/title
execute if score #text.iter.done mce.tick matches 0 if data storage mce:text_dispatch {entry:{type:"actionbar"}} run function mce:core/text/dispatch/actionbar

# Cleanup scratch and advance
execute if score #text.iter.done mce.tick matches 0 run data remove storage mce:text_dispatch entry
execute if score #text.iter.done mce.tick matches 0 run data remove storage mce:text_batch entries[0]
execute if score #text.iter.done mce.tick matches 0 run function mce:core/text/batch/iter
