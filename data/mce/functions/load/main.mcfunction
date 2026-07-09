scoreboard objectives add loadMCE trigger
scoreboard players enable @a loadMCE

tellraw @s ["",{"text":"[✔ INSTALL]","color":"green","bold":true,"clickEvent":{"action":"run_command","value":"/trigger loadMCE set 1"},"hoverEvent":{"action":"show_text","contents":"Install the datapack"}},{"text":"   "},{"text":"[✖ CANCEL]","color":"red","bold":true,"clickEvent":{"action":"run_command","value":"/trigger loadMCE set 2"},"hoverEvent":{"action":"show_text","contents":"Cancel the installation"}}]
