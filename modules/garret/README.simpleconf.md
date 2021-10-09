---
title: simpleconf.lua's Fine Manual
lang: en-GB
...

# simpleconf.lua's Fine Manual

read it
## Usage
### Loading config files

Synopsis: `config = simpleconf.get_config([config_file, defaults])`

`@config_file` (`string`)

    Path of the file to load.

`@defaults` (`table`)

    A table containing your default settings.

`config` (table)

    Contains config values.

Both values are optional.

If the file and the defaults are present, it loads the defaults, then overwrites their values with those of the file.

If the file is present, but not the defaults, it just loads the contents of the file.

If the file isn't present, but the defaults are, it just loads the defaults, and you're using it wrong.

If nothing is present, it returns an empty table.

| File | Defaults | Result |
| ---- | -------- | ------ |
| 1 | 1 | file overwrites defaults |
| 1 | 0 | just the file |
| 0 | 1 | just the defaults |
| 0 | 0 | nothing |

## Config file format

```
bool = true
number = 123
string = the quick brown fox jumps over the lazy dog
I am a comment!
```
(don't tell anyone, but it's all just a pattern nicked from Programming in Lua (page 82, 4th edition))
