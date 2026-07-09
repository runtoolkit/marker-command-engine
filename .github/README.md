# Marker Command Engine - Macro-free Command Framework

[![Minecraft](https://img.shields.io/badge/Minecraft-1.10.1%2B-green)](https://minecraft.net)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![LanternLoad](https://img.shields.io/badge/LanternLoad-compatible-blue)](https://github.com/LanternMC/load)

---
> A trusted command runtime/dependency framework for datapacks.
> Not designed as a sandbox. Use only with trusted packs and operators.
---

**Marker Command Engine** is a lightweight command execution engine for Minecraft datapacks. It runs commands stored in NBT storage using a marker entity + command block technique, with full LanternLoad integration for reliable load ordering.

## Features

- Execute commands stored in `storage mce:cmd`
- No macros required — compatible with Minecraft 1.19.3+
- Low performance impact
- Clean public API (`mce:api/*`) — internal functions are private
- Batch & Queue system
- MCE-managed scheduler (replaces `/schedule`, preserves entity context)
- **Per-player cooldown system** — macro-free, scoreboard-based
- **Run at fixed world coordinates** — execute commands from any integer coordinate
- **Announce system** — title, subtitle, and actionbar in a single call
- **Structured log system** — write/show/clear with severity levels
- **Version query API** — check MCE version from storage at runtime
- **LanternLoad integrated** — other packs can depend on MCE with guaranteed load order
- Versioned API (`load.status` score for dependency checks)

## Requirements

- Minecraft **1.19.3+** (pack_format 10+)
- All functions compatible with **1.19.3+** (no `return` command used)
- LanternLoad is **bundled** — no separate installation needed

## Installation

1. Download the latest release zip.
2. Place the `marker-command-engine` folder into your world's `datapacks/` folder.
3. Run `/reload`.
4. You should see `[MCE] Marker Command Engine v2.2.0 loaded!` in chat.

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
data modify storage mce:cmd Command set value "execute as @a[tag=mce.executor] run say I am Steve!"
function mce:api/run/as
# mce.executor tag is removed automatically
```

### Run at Coordinates

```mcfunction
# Execute a command from a fixed world position
data modify storage mce:cmd Command set value "say Hello from coords!"
data modify storage mce:cmd AtX set value 0
data modify storage mce:cmd AtY set value 64
data modify storage mce:cmd AtZ set value 0
function mce:api/run/at
```

All three coordinates (AtX, AtY, AtZ) must be set before calling. Values are integers.

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

### Cooldown

```mcfunction
# Set a 5-second (100 tick) cooldown on @s
data modify storage mce:cd Ticks set value 100
function mce:api/cooldown/set

# Check before running a command (requires 1.20.2+)
execute as @s if function mce:api/cooldown/check run function ns:your/action

# Get remaining ticks
execute as @s run function mce:api/cooldown/get
# Result -> mce:output Cooldown.remaining

# Clear cooldown immediately
function mce:api/cooldown/clear
```

### Announce

```mcfunction
# Send title, subtitle, and/or actionbar in a single call.
# All three keys are optional — omit any to skip that slot.
data modify storage mce:announce Title set value "Welcome!"
data modify storage mce:announce Subtitle set value "Enjoy your stay."
data modify storage mce:announce Actionbar set value "Server online"
function mce:api/util/announce
```

With custom timing (call before announce):

```mcfunction
# Presets: fast (5/30/5), normal (10/70/20), slow (20/100/20), instant (0/40/0)
data modify storage mce:announce_times Preset set value "fast"
function mce:api/util/announce_times

data modify storage mce:announce Title set value "Go!"
function mce:api/util/announce
```

### Log

```mcfunction
# Write an entry using level shorthands (recommended)
data modify storage mce:log_write msg set value "Player joined the arena."
function mce:api/log/info   # severity 0 — white

data modify storage mce:log_write msg set value "Cooldown nearly expired."
function mce:api/log/warn   # severity 1 — yellow

data modify storage mce:log_write msg set value "Command failed."
function mce:api/log/error  # severity 2 — red

# Or set lvl manually and call write
data modify storage mce:log_write msg set value "Custom entry."
data modify storage mce:log_write lvl set value 1
function mce:api/log/write

# Show all entries to @s (colored by level)
function mce:api/log/show

# Clear all entries
function mce:api/log/clear
```

The log holds the last **64 entries**. Older entries are dropped automatically.
Each entry is stored as `{n: <int>, lvl: <0|1|2>, msg: "<string>"}`.

### Version

```mcfunction
# Prints version to chat and writes to storage.
function mce:api/util/version
# mce:output Version.string  -> "2.2.0"
# mce:output Version.numeric -> 2002000
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
| `mce:api/run/at` | Execute command from fixed coordinates (`mce:cmd AtX/AtY/AtZ`) |

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


### `mce:api/text/batch/`

| Function | Description |
|---|---|
| `mce:api/text/batch/run` | Send all entries in `mce:text_batch entries` (tellraw / title / actionbar) |
| `mce:api/text/batch/clear` | Clear `mce:text_batch entries` without sending |

### `mce:api/cooldown/`

| Function | Min Version | Description |
|---|---|---|
| `mce:api/cooldown/set` | 1.19.3+ | Set cooldown ticks for `@s` from `mce:cd Ticks` |
| `mce:api/cooldown/check` | 1.19.3+ | Sets `mce:output Cooldown.ready` (1b=ready, 0b=on cooldown) |
| `mce:api/cooldown/clear` | 1.19.3+ | Clear cooldown for `@s` immediately |
| `mce:api/cooldown/get` | 1.19.3+ | Write remaining ticks to `mce:output Cooldown.remaining` |

### `mce:api/log/`

| Function | Description |
|---|---|
| `mce:api/log/write` | Append entry from `mce:log_write {msg, lvl}` |
| `mce:api/log/info` | Shorthand: write with `lvl=0` (INFO) |
| `mce:api/log/warn` | Shorthand: write with `lvl=1` (WARN) |
| `mce:api/log/error` | Shorthand: write with `lvl=2` (ERROR) |
| `mce:api/log/show` | Print all entries to `@s` (colored by level) |
| `mce:api/log/clear` | Clear all entries and reset counter |

### `mce:api/util/`

| Function | Description |
|---|---|
| `mce:api/util/announce` | Send title/subtitle/actionbar from `mce:announce` storage |
| `mce:api/util/announce_times` | Set title timing preset from `mce:announce_times Preset` |
| `mce:api/util/version` | Print MCE version and write to `mce:output Version` |
| `mce:api/util/cancel` | Abort active command execution (does not affect queue) |
| `mce:api/util/debug_toggle` | Toggle debug output on/off |
| `mce:api/util/help` | Print usage in chat |
| `mce:api/util/broadcast` | Send message to all players from `mce:broadcast {Msg, Prefix}` |
| `mce:api/util/error_clear` | Reset `mce:error` state and counter |

> `mce:api/util/log` and `mce:api/util/log_clear` are deprecated — use `mce:api/log/*` instead.

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
# Require MCE v2.2.0+ (score format: major*1000000 + minor*1000 + patch)
execute unless score mce load.status matches 2003000.. run tellraw @a {"text":"[YourPack] ERROR: MCE v2.2.0+ required!","color":"red"}
execute unless score mce load.status matches 2003000.. run tellraw @a {"text":"[YourPack] Aborting: MCE v2.3.0+ required.","color":"red"}

# Your init here...
```

---

## Technical Details

- **Marker tag**: `mce.cmd`
- **Command block position**: `0 -64 0`
- **Reset delay**: 3 ticks after execution
- **Queue interval**: 3 ticks between commands
- **Version score**: `mce load.status` = `2003000` (v2.3.0)

## Storage Reference

| Storage | Key | Type | Description |
|---|---|---|---|
| `mce:cmd` | `Command` | String | Command to execute |
| `mce:cmd` | `Delay` | Int | Delay in ticks for `schedule/run` (min: 1) |
| `mce:cmd` | `AtX` | Int | X coordinate for `run/at` |
| `mce:cmd` | `AtY` | Int | Y coordinate for `run/at` |
| `mce:cmd` | `AtZ` | Int | Z coordinate for `run/at` |
| `mce:cd` | `Ticks` | Int | Cooldown duration in ticks for `cooldown/set` |
| `mce:queue` | `commands` | List | Pending queue commands |
| `mce:batch` | `commands` | List | Batch staging area |
| `mce:text_batch` | `entries` | List | Text batch entries: `{type, target, msg?, prefix?, title?, subtitle?, preset?}` |
| `mce:schedule` | `jobs` | List | Scheduled job list |
| `mce:config` | `mce.debug` | Byte | Debug mode flag (`1b` = on) |
| `mce:config` | `mce.version` | String | MCE version string |
| `mce:announce` | `Title` | String | Title text for `util/announce` |
| `mce:announce` | `Subtitle` | String | Subtitle text for `util/announce` |
| `mce:announce` | `Actionbar` | String | Actionbar text for `util/announce` |
| `mce:announce_times` | `Preset` | String | Timing preset: `fast` `normal` `slow` `instant` |
| `mce:log_write` | `msg` | String | Message to write (input for `log/write`) |
| `mce:log_write` | `lvl` | Int | Severity level: `0`=INFO `1`=WARN `2`=ERROR |
| `mce:log` | `entries` | List | Log entries: `{n, lvl, msg}` (max 64) |
| `mce:broadcast` | `Msg` | String | Message text for `util/broadcast` |
| `mce:broadcast` | `Prefix` | String | Optional prefix for `util/broadcast` |
| `mce:output` | `Cooldown.ready` | Byte | `1b` if `@s` is ready, `0b` if on cooldown — set by `cooldown/check` |
| `mce:output` | `Cooldown.remaining` | Int | Remaining cooldown ticks |
| `mce:output` | `Version.string` | String | MCE version string (e.g. `"2.2.0"`) |
| `mce:output` | `Version.numeric` | Int | MCE version as int (e.g. `2002000`) |
| `mce:error` | `Last` | String | Last error message |
| `mce:error` | `Code` | String | Last error code (e.g. `ERR_NO_CMD`) |
| `mce:error` | `Count` | Int | Total error count since load |

## Scoreboard Reference

| Objective | Description |
|---|---|
| `mce.queue` | Queue state and error counter |
| `mce.tick` | Internal tick counters |
| `mce.compat` | Compat system flags |
| `mce.cd` | Per-player cooldown (remaining ticks, 0 = ready) |
| `mce.log` | Log entry counter and size tracking |

> **Note:** `mce:cmd Executor` is no longer used. Tag your target entity with `mce.executor` before calling `mce:api/run/as`.

---

## Changelog

### v2.3.0
- **Breaking:** `mce:api/cooldown/check` no longer supports `execute if function` syntax — use `mce:output Cooldown.ready` instead
- Removed all `return` commands — fully compatible with Minecraft 1.19.3+
- Added `mce:api/text/batch/run` — send multiple tellraw/title/actionbar messages in a single call
- Added `mce:api/text/batch/clear` — clear pending text batch without sending
- Updated Requirements: all APIs now 1.19.3+ (no exceptions)


### v2.2.0
- Added `mce:api/log/write` — structured log entries `{n, lvl, msg}`, 64-entry cap
- Added `mce:api/log/info` / `log/warn` / `log/error` — level shorthands
- Added `mce:api/log/show` — level-colored tellraw output, macro-free
- Added `mce:api/log/clear` — clears entries and resets counter
- Added `mce:api/util/error_clear` — resets error state and counter
- Added missing function tags for `api/run/at`, `api/util/announce`, `announce_times`, `version`, `api/multi/run`
- Deprecated `mce:api/util/log` and `util/log_clear` (compat wrappers kept)
- Added `mce.log` scoreboard objective

### v2.1.0
- Added `mce:api/multi/run` — execute title, subtitle, actionbar, message, and commands in a single call
- Added `mce:api/util/broadcast` — send a message to all players from storage
- Added `mce:api/util/log` — append command string to in-memory audit log

### v2.0.0
- Added `mce:api/run/at` — execute commands from fixed world coordinates
- Added `mce:api/util/announce` — send title, subtitle, actionbar in one call
- Added `mce:api/util/announce_times` — configure title timing via presets
- Added `mce:api/util/version` — query MCE version at runtime
- Updated `mce:api/util/help` with all new APIs
- Bumped LanternLoad version score to `2000000`

### v1.1.0
- Initial public release

---

## License

MIT License — free to use, modify, and distribute.
