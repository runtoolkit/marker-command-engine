# Marker Command Engine (MCE)

[![Minecraft](https://img.shields.io/badge/Minecraft-1.20.2+-green)](https://minecraft.net)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.21+-green)](https://minecraft.net)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![LanternLoad](https://img.shields.io/badge/LanternLoad-compatible-blue)](https://github.com/LanternMC/load)

---
> A trusted command runtime/dependency framework for datapacks.  
> Not designed as a sandbox. Use only with trusted packs and operators.
---

**Marker Command Engine** is a lightweight command execution engine for Minecraft datapacks. It runs commands stored in NBT storage using a marker entity + command block technique, with full LanternLoad integration for reliable load ordering.

## Features

- Execute commands stored in `storage mce:cmd`
- Low performance impact
- Clean public API (`mce:api/*`) — internal functions are private
- Batch & Queue system
- MCE-managed scheduler (replaces `/schedule`, preserves `@s` context)
- **LanternLoad integrated** — other packs can depend on MCE with guaranteed load order
- Versioned API (`load.status` score for dependency checks)

## Requirements

- Minecraft **1.20.2+** (function macros required for `mce:api/run_as`)
- LanternLoad is **bundled** — no separate installation needed

## Installation

1. Download the latest release zip.
2. Place the `marker-command-engine` folder into your world's `datapacks/` folder.
3. Run `/reload`.
4. You should see `[MCE] Marker Command Engine v1.1.0 loaded!` in chat.

## Usage

### Run a Command

```mcfunction
data modify storage mce:cmd Command set value "say Hello World!"
function mce:api/run
```

### Run as Entity

```mcfunction
data modify storage mce:cmd Command set value "say I am Steve!"
data modify storage mce:cmd Executor set value "@a[name=Steve,limit=1]"
function mce:api/run_as
```

### Queue

```mcfunction
data modify storage mce:cmd Command set value "say First!"
function mce:api/queue_add
data modify storage mce:cmd Command set value "say Second!"
function mce:api/queue_add
function mce:api/queue_run
```

### Batch

```mcfunction
data modify storage mce:batch commands set value ["say One","say Two","say Three"]
function mce:api/batch
```

### Schedule (replaces /schedule — preserves @s context)

```mcfunction
data modify storage mce:cmd Command set value "say Delayed!"
data modify storage mce:cmd Delay set value 40
function mce:api/schedule
```

### Help

```mcfunction
function mce:api/help
```

## Public API

Only `mce:api/*` functions are part of the public API. All `mce:core/*` functions are **private** and may change without notice.

| Function | Description |
|---|---|
| `mce:api/run` | Execute command from `mce:cmd Command` immediately |
| `mce:api/run_as` | Execute as entity (`mce:cmd Executor` + `Command`) |
| `mce:api/queue_add` | Add command to queue |
| `mce:api/queue_run` | Start executing the queue |
| `mce:api/queue_clear` | Clear queue without executing |
| `mce:api/batch` | Add `mce:batch commands` list to queue and run |
| `mce:api/batch_clear` | Clear batch staging area |
| `mce:api/schedule` | Schedule command after `mce:cmd Delay` ticks |
| `mce:api/schedule_clear` | Cancel all pending scheduled jobs |
| `mce:api/cancel` | Abort active command execution |
| `mce:api/debug_toggle` | Toggle debug output |
| `mce:api/help` | Print usage in chat |

## Depending on MCE (LanternLoad)

To make your pack depend on MCE, add your load function to `#load:post_load` and check the version score:

```json
// data/yourpack/tags/function/post_load.json
{
    "values": ["yourpack:load"]
}
```

```mcfunction
# yourpack:load
# Require MCE v1.1.0 or newer (score: major*1000000 + minor*1000 + patch)
execute unless score mce load.status matches 1001000.. run tellraw @a {"text":"[YourPack] ERROR: MCE v1.1.0+ required!","color":"red"}
execute unless score mce load.status matches 1001000.. run return 0

# Your actual init here...
```

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
| `mce:cmd` | `Executor` | String | Entity selector for `run_as` |
| `mce:cmd` | `Delay` | Int | Delay in ticks for `schedule` |
| `mce:queue` | `commands` | List | Pending queue commands |
| `mce:batch` | `commands` | List | Batch staging area |
| `mce:schedule` | `jobs` | List | Scheduled job list |
| `mce:config` | `debug` | Byte | Debug mode flag |

## License

MIT License — free to use, modify, and distribute.

---

**Made with ❤️ for the Minecraft Datapack Community**
