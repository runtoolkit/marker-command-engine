# PUBLIC API — mce:api/text/batch/run
# MCE version: 2.3.0
#
# Sends multiple text messages (tellraw / title / actionbar) in a single call.
# Each entry in mce:text_batch entries is dispatched based on its "type" field.
# Compatible with Minecraft 1.19.3+
#
# Entry types and required fields:
#
#   type "tellraw"
#     target — selector string (e.g. "@a", "@s")   [required]
#     msg    — message string                        [required]
#     prefix — prefix string                         [optional]
#
#   type "title"
#     target   — selector string                    [required]
#     title    — large center text                  [optional]
#     subtitle — small text below title             [optional]
#     preset   — timing preset: fast/normal/slow/instant  [optional, default: normal]
#
#   type "actionbar"
#     target — selector string                      [required]
#     msg    — message string                        [required]
#
# Usage:
#   data modify storage mce:text_batch entries set value [{type:"tellraw",target:"@a",msg:"Restart in 1 min.",prefix:"[Alert]"},{type:"title",target:"@a",title:"WARNING",subtitle:"1 min left",preset:"slow"},{type:"actionbar",target:"@a",msg:"Restart imminent"}]
#   function mce:api/text/batch/run

execute unless data storage mce:text_batch entries run data modify storage mce:error Last set value "mce:text_batch entries is not set or empty"
execute unless data storage mce:text_batch entries run data modify storage mce:error Code set value "ERR_NO_TEXT_BATCH"
execute unless data storage mce:text_batch entries run function mce:core/error/raise
execute if data storage mce:text_batch entries run function mce:core/text/batch/iter
