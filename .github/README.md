# Marker Command Engine (MCE)

[![Minecraft](https://img.shields.io/badge/Minecraft-1.20.1+-green)](https://minecraft.net)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![LanternLoad](https://img.shields.io/badge/LanternLoad-compatible-blue)](https://github.com/LanternMC/load)

---
> A trusted command runtime/dependency framework for datapacks.  
> Not designed as a sandbox. Use only with trusted packs and operators.
---

**Marker Command Engine** is a lightweight command execution engine for Minecraft datapacks. It runs commands stored in NBT storage using a marker entity + command block technique, with full LanternLoad integration for reliable load ordering.

## Features

- Execute commands stored in `storage mce:cmd`
- No macros required — compatible with Minecraft 1.20.1+
- Low performance impact
- Clean public API (`mce:api/*`) — internal functions are private
- Batch & Queue system
- MCE-managed scheduler (replaces `/schedule`, preserves entity context)
- **LanternLoad integrated** — other packs can depend on MCE with guaranteed load order
- Versioned API (`load.status` score for dependency checks)

## Requirements

- Minecraft **1.20.1+**
- LanternLoad is **bundled** — no separate installation needed

## Installation

1. Download the latest release zip.
2. Place the `marker-command-engine` folder into your world's `datapacks/` folder.
3. Run `/reload`.
4. You should see `[MCE] Marker Command Engine v1.1.0 loaded!` in chat.

---

## Usage

### Run a Command

```mcfunction
data modify storage mce:cmd Command set value "say Hello World!"
function mce:api/run/cmd
```

### Run as Entity

```mcfunction
# Tag the target entity first
tag @a[name=Steve,limit=1] add mce.executor

# Set the command and call
data modify storage mce:cmd Command set value "say I am Steve!"
function mce:api/run/as
# mce.executor tag is removed automatically
```

### Queue

```mcfunction
data modify storage mce:cmd Command set value "say First!"
function mce:api/queue/add
data modify storage mce:cmd Command set value "say Second!"
function mce:api/queue/add
function mce:api/queue/run
```

### Batch

```mcfunction
data modify storage mce:batch commands set value ["say One","say Two","say Three"]
function mce:api/batch/run
```

### Schedule

```mcfunction
# Replaces /schedule
data modify storage mce:cmd Command set value "say Delayed!"
data modify storage mce:cmd Delay set value 40
function mce:api/schedule/run
```

### Help

```mcfunction
function mce:api/util/help
```

---

## Public API

Only `mce:api/*` functions are part of the public API. All `mce:core/*` functions are **private** and may change without notice.

### `mce:api/run/`

| Function | Description |
|---|---|
| `mce:api/run/cmd` | Execute command from `mce:cmd Command` immediately |
| `mce:api/run/as` | Execute as tagged entities (`mce.executor` tag + `mce:cmd Command`) |

### `mce:api/queue/`

| Function | Description |
|---|---|
| `mce:api/queue/add` | Add `mce:cmd Command` to queue |
| `mce:api/queue/run` | Start executing the queue (one command per 3 ticks) |
| `mce:api/queue/clear` | Clear queue without executing |

### `mce:api/schedule/`

| Function | Description |
|---|---|
| `mce:api/schedule/run` | Schedule command after `mce:cmd Delay` ticks (minimum: 1) |
| `mce:api/schedule/clear` | Cancel all pending scheduled jobs |

### `mce:api/batch/`

| Function | Description |
|---|---|
| `mce:api/batch/run` | Add `mce:batch commands` list to queue and run |
| `mce:api/batch/clear` | Clear batch staging area without queuing |

### `mce:api/util/`

| Function | Description |
|---|---|
| `mce:api/util/cancel` | Abort active command execution (does not affect queue) |
| `mce:api/util/debug_toggle` | Toggle debug output on/off |
| `mce:api/util/help` | Print usage in chat |

---

## Depending on MCE (LanternLoad)

To make your pack load after MCE, add your load function to `#load:post_load` and verify the version score:

```json
// data/yourpack/tags/function/post_load.json
{
    "values": ["yourpack:load"]
}
```

```mcfunction
# yourpack:load
# Require MCE v1.1.0+ (score format: major*1000000 + minor*1000 + patch)
execute unless score mce load.status matches 1001000.. run tellraw @a {"text":"[YourPack] ERROR: MCE v1.1.0+ required!","color":"red"}
execute unless score mce load.status matches 1001000.. run return 0

# Your init here...
```

---

## Technical Details

- **Marker tag**: `mce.cmd`
- **Command block position**: `0 -64 0`
- **Reset delay**: 3 ticks after execution
- **Queue interval**: 3 ticks between commands
- **Version score**: `mce load.status` = `1001000` (v1.1.0)

## Storage Reference

| Storage | Key | Type | Description |
|---|---|---|---|
| `mce:cmd` | `Command` | String | Command to execute |
| `mce:cmd` | `Delay` | Int | Delay in ticks for `schedule/run` (min: 1) |
| `mce:queue` | `commands` | List | Pending queue commands |
| `mce:batch` | `commands` | List | Batch staging area |
| `mce:schedule` | `jobs` | List | Scheduled job list |
| `mce:config` | `debug` | Byte | Debug mode flag (`1b` = on) |

> **Note:** `mce:cmd Executor` is no longer used. Tag your target entity with `mce.executor` before calling `mce:api/run/as`.

---

## License

MIT License — free to use, modify, and distribute.
