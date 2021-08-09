# garret's shitty aegisub scripts

Aegisub automation scripts I've written.
 Mostly only useful to me.

Some scripts do the same things as other peoples',
 likely because I didn't know their script existed,
 or because it had loads of ~~bloat i'll never use~~ other stuff with it (cough cough unanimated).

Tested on official-ish aegi for linux,
 but _should_ work fine on any build that has automation v4 (read: all of them).

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

### Blur Fade

Makes fade with blur.

Blurs out lines with the effect `blurout`, and blurs in lines with the effect `blurin`.

For fancy fade effects. (i.e, when the whole scene blurs out until it's invisible, as a transition)

### Chapter Generator

Makes XML chapters for matroska.

Makes lines with the effect `chapter` into chapters. Start time of the line is used for the timestamp, text of the line is used for chapter name.
Language is currently hardcoded to english.

Tries to save the file in a sane location.
 in order of priority: subtitle directory, video directory, audio directory.

file is always named `chapters.xml`, **even if something is already there.**

if no sane path is found, it logs the chapters for you to deal with as you see fit.

**Done better by**: `Significance` by UA.

### CR Restyler

`become-fansubber.lua`

`Main` -> `Default`,
 `Flashback` -> `Default`,
 `Top` -> `\an8`,
 `Italics` -> `\i1`.

assumes a relatively clean cr script.
 if not, you're on your own.

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

### K-Timing -> Alpha Timing

makes doing alpha timing significantly easier
 by getting rid of the part where you do alpha timing.

originally created to convert stuff that should've been alpha timed in the first place
 but used a weird hack with `\ko` instead.

### Scenebleed Detector

Finds scenebleeds in the selected lines, and marks them with an effect (`bleed`).

Currently has a hardcoded threshold of 500ms
 as my brain is too small
 to figure out how to do
 a config file.

**Done better by**: probably some UA script

### Select Comments

have a guess
