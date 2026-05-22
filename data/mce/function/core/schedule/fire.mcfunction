# Private: not part of MCE public API — subject to change without notice
# Fires the first pending scheduled job immediately (single-shot, outside iter loop).
# Called by external callers that pop a job directly — not used by the default tick path.

data modify storage mce:cmd Command set from storage mce:schedule jobs[0].cmd
function mce:core/run/setup_marker
function mce:core/run/cmd

data remove storage mce:schedule jobs[0]