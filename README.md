# Marker Command Engine (MCE)

A Fabric mod for Minecraft 1.20.6 that executes server commands on behalf of datapacks — no command blocks, no marker entities, no forceloaded chunks.

---

## Installation

Drop the `.jar` into your server's `mods/` directory.  
Requires Fabric Loader and Fabric API.

---

## commands.json

Located at `data/mce/commands.json` (inside the mod JAR; override with a datapack).

```json
{
  "settings": {
    "require_op_level": 2,
    "log_executions": true,
    "allowed_datapacks": []
  },
  "denylist": {
    "prefixes": ["op", "deop", "ban", "stop"],
    "patterns": [".*\\$\\{.*\\}.*"]
  },
  "commands": [
    {
      "id": "greet",
      "aliases": ["g", "hello"],
      "command": "say Hello %mce:vars=\"player_name\"%!",
      "run_as": "console",
      "enabled": true
    },
    {
      "id": "start_event",
      "aliases": ["event"],
      "commands": [
        "title @a title {\"text\":\"Event Start!\",\"bold\":true}",
        "playsound minecraft:ui.toast.challenge_complete master @a",
        "say The event has begun."
      ],
      "run_as": "console",
      "enabled": true
    }
  ]
}
```

### Entry fields

| Field | Type | Required | Description |
|---|---|---|---|
| `id` | string | ✓ | Unique primary identifier |
| `command` | string | ✓ (or `commands`) | Single command string |
| `commands` | string[] | ✓ (or `command`) | Ordered command sequence (v1.0.1) |
| `aliases` | string[] | — | Alternative IDs for `/mce run-id` |
| `run_as` | `"console"` \| `"player"` | — | Execution context (default: `"console"`) |
| `enabled` | boolean | — | Disabled entries are ignored on load (default: `true`) |

If both `command` and `commands` are present, `commands` takes priority.

---

## Commands

| Command | Description |
|---|---|
| `/mce run <command>` | Execute a command string through the denylist (placeholders resolved) |
| `/mce run-id <id\|alias>` | Run a named command from commands.json — **tab-completed**, aliases accepted |
| `/mce reload` | Reload `commands.json` from disk without restarting |
| `/mce list` | List all enabled commands with aliases and command count |
| `/mce denylist` | Show active denylist prefixes and patterns |
| `/mce stats` | Show execution statistics for the current session |
| `/mce version` | Print mod version |

---

## Alias System

Each command entry can declare one or more `aliases`. They are treated identically to the primary `id` in all contexts: `/mce run-id`, tab-completion, and the event bus.

```json
{
  "id": "test_command",
  "aliases": ["test", "tc"],
  "command": "say Hello!"
}
```

```
/mce run-id test_command   ✓
/mce run-id test           ✓
/mce run-id tc             ✓
```

All three names appear in tab-completion and are updated live after `/mce reload`.

---

## Multi-Command Sequences

An entry can run an ordered list of commands using the `commands` array (v1.0.1):

```json
{
  "id": "start_event",
  "commands": [
    "title @a title {\"text\":\"Event!\",\"bold\":true}",
    "playsound minecraft:ui.toast.challenge_complete master @a",
    "say The event has started."
  ],
  "run_as": "console"
}
```

Commands execute in order. If any step is denied by the denylist or throws an exception, the sequence **aborts immediately** and the caller receives an `[MCE] Sequence aborted at step N of M` message. Each command in the sequence goes through the full denylist + placeholder pipeline independently.

---

## Storage Placeholders

Command strings can embed `%namespace:path="key"%` tokens. At execution time MCE reads the value from the Minecraft command storage and substitutes it before dispatch.

### Syntax

```
%<storage-id>="<key>"%
```

- **`storage-id`** — Minecraft storage identifier (`namespace:path`), same as used in `/data ... storage <id>`  
- **`key`** — Top-level key name inside that storage's NBT compound

### Example

**From a datapack function:**
```mcfunction
data modify storage mce:vars player_name set value "Legends11"
function #mce:run_id {id: "greet_player"}
```

**In commands.json:**
```json
{
  "id": "greet_player",
  "command": "say Welcome %mce:vars=\"player_name\"%!",
  "run_as": "console"
}
```

**Executed command:**
```
say Welcome Legends11!
```

### Type conversion

| NBT type | Substituted as |
|---|---|
| `NbtString` | Raw string value (no SNBT quotes) |
| Numeric (`int`, `long`, `float`…) | Decimal string, SNBT type suffix stripped |
| `NbtCompound`, `NbtList` | SNBT representation |
| Missing key | Empty string `""` (logged as warning) |

### Security

The denylist runs **twice** per command:

1. **Before** placeholder resolution — catches statically blocked templates  
2. **After** placeholder resolution — catches values injected from storage that would form a denied command

This prevents a compromised datapack from writing `op GrieferName` into storage and having MCE execute it through an otherwise-allowed template.

---

## Event System

```java
MceEventBus bus = MarkerCommandEngine.getEventBus();

bus.subscribe(MceEvent.COMMAND_ALLOWED, ctx -> {
    System.out.println("About to run: " + ctx.command());
});

bus.subscribe(MceEvent.COMMAND_EXECUTED, ctx -> {
    boolean ok = Boolean.TRUE.equals(ctx.success());
    System.out.println("Ran: " + ctx.command() + " success=" + ok);
});
```

| Event | When fired | Context fields |
|---|---|---|
| `COMMAND_ALLOWED` | After denylist checks pass, before dispatch | `source`, `command` |
| `COMMAND_DENIED` | When denylist blocks a command | `source`, `command`, `reason` |
| `COMMAND_EXECUTED` | After every dispatch attempt (pass or fail) | `source`, `command`, `success` |
| `CONFIG_RELOADED` | After `/mce reload` | — |

`COMMAND_EXECUTED` always fires if `COMMAND_ALLOWED` fired, even on dispatcher exception.  
`ctx.success()` is `true` for a clean dispatch, `false` if the dispatcher threw.

---

## Stats

`/mce stats` shows in-session execution counters:

| Counter | Meaning |
|---|---|
| `allowed` | Commands that passed all denylist checks |
| `denied` | Commands blocked by the denylist (pre- or post-expansion) |
| `executed` | Dispatched commands that ran without exception |
| `failed` | Dispatched commands that threw during execution |

Counters reset automatically on `/mce reload`.

---

## Execution Flow

```
/mce run-id <id|alias>
        │
        ├─ Lookup by id OR any alias
        │
        └─ For each command in entry.commands():
                │
                ├─ 1. Strip leading '/'
                ├─ 2. Denylist check (raw template)
                ├─ 3. Resolve %ns:path="key"% placeholders → expanded
                ├─ 4. Denylist re-check (expanded)          ← injection guard
                ├─ 5. fireAllowed event
                ├─ 6. Dispatch via server command manager
                └─ 7. fireExecuted event (success or fail)
```

---

## Denylist

The denylist blocks commands by prefix or Java regex pattern. Both checks run on **every** execution, including post-placeholder expansion.

```json
"denylist": {
  "prefixes": ["op", "deop", "ban", "stop"],
  "patterns": [".*\\$\\{.*\\}.*"]
}
```

- **Prefix** — the command must not *start with* the prefix (case-insensitive after stripping `/`)  
- **Pattern** — the full expanded command is tested against each Java regex

---

## Changelog

### v1.0.1
- **Multi-command sequences** — `commands: [...]` array in entries; fail-fast with step reporting
- **Alias system** — `aliases: [...]` per entry; tab-completed, accepted by `/mce run-id`
- **Storage placeholders** — `%ns:path="key"%` resolved from Minecraft command storage at runtime; double denylist pass for injection safety

### v1.0.0
- **`/mce run <command>`** — execute raw command strings through the denylist
- **`/mce run-id <id>`** — execute named commands from `commands.json` with tab-completion
- **`/mce reload`** — hot-reload `commands.json` without server restart
- **Event bus** — `COMMAND_ALLOWED`, `COMMAND_DENIED`, `COMMAND_EXECUTED`, `CONFIG_RELOADED`
- **`/mce stats`** — in-session execution counters
- **Denylist** — prefix and regex pattern matching with post-expansion re-check
