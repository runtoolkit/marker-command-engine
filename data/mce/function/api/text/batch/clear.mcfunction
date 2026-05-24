# PUBLIC API — mce:api/text/batch/clear
# MCE version: 2.3.0
#
# Clears pending mce:text_batch entries without sending them.
# Compatible with Minecraft 1.19.3+
#
# Usage:
#   function mce:api/text/batch/clear

data remove storage mce:text_batch entries
