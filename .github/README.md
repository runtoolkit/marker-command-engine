# Marker Command Engine (MCE)

[![Minecraft](https://img.shields.io/badge/Minecraft-1.19+-green)](https://minecraft.net)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.20+-green)](https://minecraft.net)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.21+-green)](https://minecraft.net)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---
> A trusted command runtime/dependency framework for datapacks.
Not designed as a sandbox.
Use only with trusted packs and operators.
---
**Marker Command Engine** is a lightweight and high-performance command execution engine for Minecraft datapacks. It allows you to run commands directly from storage using a clean marker entity + command block technique.

## Features

- Execute commands stored in `storage mce:cmd`
- Very low performance impact
- Simple and clean API
- Clean marker entity method
- Supports Minecraft 1.21+ (`pack_format: 57`)
- `/` Support
- Batch & Queue system

## Installation

1. Download or clone this repository.
2. Put the `marker-command-engine` folder into your world's `datapacks` folder.
3. Run `/reload` in your Minecraft world.
4. You should see a successful load message in chat.

## Usage

### Run a Command

```mcfunction
# Store the command
data modify storage mce:cmd Command set value "say Hello World!"

# Execute it
function mce:api/run
```

### Show Help

```mcfunction
function mce:api/help
```

---

| Available Functions  |
|-----------------------|
| `mce:api/run`         |
| `mce:api/help`        |
| `mce:api/batch`        |
| `mce:api/queue_*`        |
| `mce:api/run_as`        |

## Technical Details

- **Marker**: Tagged with `Tags:["mce.cmd"]`
- **Command Block**: Temporarily placed at `0 -64 0` and removed immediately
- Reset operation runs automatically after 3 ticks

## For Developers

Storage structure:

```json
{
  "Command": "your command here"
}
```

## License

This project is licensed under the **MIT License** — you are free to use, modify, and distribute.

---

**Made with ❤️ for the Minecraft Datapack Community**
