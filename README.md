# Marker Command Engine — Fabric Mod

Fabric port of the [Marker Command Engine](https://github.com/runtoolkit/marker-command-engine) datapack.

Adds `/marker-command-engine` (alias `/mce`) — a command execution engine with a JSON-based config, command denylist, and a lightweight event system. No command blocks, no marker entities, no mcfunction required.

---

## Requirements

- Minecraft **1.20.6**
- Fabric Loader **0.15.0+**
- Fabric API **0.100.8+1.20.6**

---

## Installation

1. Download the `.jar` from [Releases](../../releases).
2. Place it in your `mods/` folder.
3. Start the server — `config/marker-command-engine/commands.json` is created automatically.

---

## Commands

| Command | Description |
|---|---|
| `/mce run <command>` | Execute a command string through the denylist |
| `/mce run-id <id>` | Run a named command defined in `commands.json` |
| `/mce reload` | Reload `commands.json` from disk without restarting |
| `/mce list` | List all enabled commands from config |
| `/mce denylist` | Show active denylist prefixes and patterns |
| `/mce version` | Print mod version |

`/marker-command-engine` is the full command name; `/mce` is an alias for both.

Default required permission level: **op level 2** (configurable).

---

## Configuration

Config file: `config/marker-command-engine/commands.json`

```json
{
  "settings": {
    "require_op_level": 2,
    "log_executions": true,
    "allowed_datapacks": []
  },

  "denylist": {
    "prefixes": [
      "op",
      "deop",
      "ban",
      "ban-ip",
      "pardon",
      "pardon-ip",
      "stop",
      "whitelist add",
      "whitelist remove"
    ],
    "patterns": [
      ".*\\$\\{.*\\}.*"
    ]
  },

  "commands": [
    {
      "id": "announce_restart",
      "command": "say Server restarting in 5 minutes.",
      "run_as": "console",
      "enabled": true
    }
  ]
}
```

### `settings`

| Field | Type | Default | Description |
|---|---|---|---|
| `require_op_level` | int | `2` | Minimum op level to use `/mce` |
| `log_executions` | bool | `true` | Log each execution to server console |
| `allowed_datapacks` | array | `[]` | Reserved for future datapack filtering |

### `denylist`

| Field | Description |
|---|---|
| `prefixes` | Block any command starting with these strings (case-insensitive) |
| `patterns` | Block commands matching these Java regex patterns |

Prefix matching is exact prefix — `"op"` blocks `op PlayerName` but not `opportunity`.

### `commands`

Each entry in the `commands` array:

| Field | Type | Default | Description |
|---|---|---|---|
| `id` | string | required | Unique identifier, used with `/mce run-id` |
| `command` | string | required | Command to execute (without leading `/`) |
| `run_as` | string | `"console"` | `"console"` (op level 4) or `"player"` (caller's level) |
| `enabled` | bool | `true` | Disabled entries are ignored on load |

Reload with `/mce reload` — no server restart needed.

---

## Denylist

Every command passed to `/mce run` or `/mce run-id` is checked against the denylist **before execution**. Blocked commands are rejected with a feedback message and fire a `COMMAND_DENIED` event.

By default the following are blocked: `op`, `deop`, `ban`, `ban-ip`, `pardon`, `pardon-ip`, `stop`, `whitelist add`, `whitelist remove`.

---

## Event System

Other Fabric mods can listen to MCE events without any mcfunction dependency:

```java
MceEventBus bus = MarkerCommandEngine.getEventBus();

// Audit log for denied commands
bus.subscribe(MceEvent.COMMAND_DENIED, ctx -> {
    String msg = "[Audit] BLOCKED '" + ctx.command() + "' — " + ctx.reason();
    ctx.source().getServer().sendMessage(Text.literal(msg));
});

// Hook into allowed commands
bus.subscribe(MceEvent.COMMAND_ALLOWED, ctx -> {
    // ctx.source(), ctx.command() available
});

// React to config reload
bus.subscribe(MceEvent.CONFIG_RELOADED, ctx -> {
    // re-read MCE config if needed
});
```

### Events

| Event | When fired | Context fields |
|---|---|---|
| `COMMAND_ALLOWED` | Before a command executes | `source`, `command` |
| `COMMAND_DENIED` | When denylist blocks a command | `source`, `command`, `reason` |
| `CONFIG_RELOADED` | After `/mce reload` | — |

---

## Why Fabric instead of datapack?

The original MCE datapack uses a marker entity + command block tunnel to execute commands stored in NBT. This works but has hard limits:

- Cannot intercept or block specific commands before execution
- Cannot enforce a denylist — `/op` and prompt injection are impossible to stop
- Requires a forceloaded chunk and a persistent command block at a fixed coordinate
- No structured event system for other packs to hook into

The Fabric mod replaces the command block tunnel with `CommandManager.getDispatcher().execute()`, adds a denylist checked on every execution, and exposes a Java event bus — all with zero mcfunction files.

---

## Building

```bash
chmod +x gradlew
./gradlew build
# → build/libs/marker-command-engine-1.0.0.jar
```

Requires JDK 21. Do not run `gradle wrapper` — use `./gradlew` directly.

---

## License

MIT — see [LICENSE](LICENSE).
