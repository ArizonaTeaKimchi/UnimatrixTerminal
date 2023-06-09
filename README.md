# UnimatrixTerminal
A minimal, WIP in-game cli addon for Godot 4.0 development. Designed for custom in-game debugging/tools

![A cube, spawned with an example `spawn` command at a particular position. The terminal text also displays help text output for the command](./docs/resources/unimatrix-terminal-example.png)

# Summary
The `UnimatrixProcessor` is the core of the addon, and is intended to be used as an autoload class.
All commands should be derived from nodes of type `UnimatrixCommand`, and register with the `UnimatrixProcessor.register_command()` method like so

```gdscript
extends UnimatrixCommand

_ready():
  self._register_command()
```

The `UnimatrixCommand` class exports two string variables, `command_name` and `command_help`. 
`command_name will be what will be used by `UnimatrixProcessor` to call your command once registered. `command_help` is optional, but encouraged. What keyword your command uses for help is up to you.

Open `terminal.tscn` to see an example of how to use `UnimatrixTerminal` with your project. The `UnimatrixProcessor` is decoupled from the actual terminal display, so feel free to create your own!
