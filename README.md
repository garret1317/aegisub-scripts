# garret's shitty aegisub scripts

Aegisub automation scripts I've written.
 Mostly only useful to me.

Some scripts do the same things as other peoples',
 likely because I didn't know their script existed,
 or because it had loads of ~~bloat i'll never use~~ other stuff with it (cough cough unanimated).

Tested on official-ish aegi for linux,
 but _should_ work fine on any build that has automation v4 (read: all of them).

assume garbage-in garbage-out.

----

## Script List

### A-B

Makes checking pre-timing possible
by putting some text in the lines
 (the actor name, and `a` or `b`,
 hence the name)

ignores lines with text in them,
 prepends to lines with just tags in them

### Append Comment

pops up a dialogue to put the comment in, and appends it to the selected lines.

if you're not using it for multiple lines you may as well just type the curly brackets & stuff yourself, it's probably quicker.

### Audio Clipper

Extracts audio from the selected line(s), like the create audio clip button.
Unlike the create audio clip button, it can copy the audio stream.

Also, if you select multiple lines, it'll make separate clips for each, not one long one.

By default, outputs to `?video/audioclipper_output/i.xyz`,
 where `x` is the index of the line in your selection, and `xyz` is the extension.

**Needs ffmpeg in path.**
Can be slow.

**Done better by**: Petzku's `Encode Clip` (kinda), Aegisub (kinda)

### Chapter Generator

Makes XML chapters for matroska.

Makes lines with the effect `[Cc]hapter`, `[Cc]hptr` or `[Cc]hap` (the same as UA's Significance), into chapters. Start time of the line is used for the timestamp, text of the line is used for chapter name.
Language is currently hardcoded to english.

**Done better by**: `Significance` by UA.

### Dupe and Comment

Duplicates a line and comments out the original.

I like seeing the original line while editing,
 and being able to go back to it
 easily if my edit was crap.

### Em-dash

Appends an Em-dash (`—`) to the selected line(s).
Replaces `--` with `—`.

I do not have an em-dash key on my keyboard.

**Done better by**: Ctrl-H (partially)

### Inverse Glow

For typesetting.

Glow, but it goes inside the letters.

- `\c` = dark colour
- `\3c` = light colour
- `\bord` = amount of blur on light colour

won't work if doesn't have all three

see `inverse-glow.ass` for an example

### K-Timing -> Alpha Timing

makes doing alpha timing significantly easier
 by getting rid of the part where you do alpha timing.

originally created to convert stuff that should've been alpha timed in the first place
 but used a weird hack with `\ko` instead.

### Order layers

for typesetting.

Puts each selected line on its own layer, so they don't clash.
Tries to be a bit clever and check if you actually need it
, but it's not so clever that it'll check if they actually overlap.

### Restyler

`become-fansubber.lua`

Changes style of selected lines to `Default` (for now, will be configurable in future),
 and copies italic+alignment values from the script's styles to inline tags.

Can't help if the source script isn't properly styled.
**cannot handle inline tags!**

### Scenebleed Detector

Finds scenebleeds in the selected lines, and marks them with an effect (`bleed`).

Currently has a hardcoded threshold of 500ms
 as my brain is too small
 to figure out how to do
 a config file.

**Done better by**: probably some UA script

### Select Comments

have a guess
