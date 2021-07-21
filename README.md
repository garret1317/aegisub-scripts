# garret's shitty aegisub scripts

Aegisub automation scripts I've written.
Probably only useful to me.

A few of them are dupes of already-existing scripts, or parts of them.

Likely because I didn't know the already-existing one existed, or because it had loads of ~~bloat~~ other stuff along with it (cough cough unanimated).

----

## Script List

### A-B

Makes checking pre-timing possible by putting some text in the lines (the actor name, and `a` or `b`, hence the name)

ignores lines with text in them, prepends to lines with just tags in them

### Append Comment

pops up a dialogue to put the comment in, and appends it to the selected lines.

### Audio Clipper

Extracts audio from the selected line(s), like the create audio clip button.
Unlike the create audio clip button, it can copy the audio stream.

Also, if you select multiple lines, it'll make separate clips for each, not one long one.

**Needs ffmpeg. Can be slow.**

### Blur Fade

Makes fade with blur.

Blurs out lines with the effect `blurout`, and blurs in lines with the effect `blurin`.

For fancy fade effects. (i.e, when the whole scene blurs out until it's invisible, as a transition)

### Chapter Generator

Makes .xml chapters for matroska.

Makes lines with the effect `chapter` into chapters. Start time of the line is used for the timestamp, text of the line is used for chapter name.
Language is currently hardcoded to english.

Basically a dupe of the one in Significance.

### CR Restyler

`become-fansubber.lua`

select the lines

it sets them to default style

wow amazing

### Dupe and Comment

Duplicates a line and comments out the original.

I like seeing the original line while editing, and being able to go back to it easily if my edit was crap.

### Em-dash

Appends an Em-dash (`—`) to the selected line(s).
Replaces `--` with `—`.

I do not have an em-dash key on my keyboard.

### K-Timing -> Alpha Timing

does what it says on the tin.

originally created to convert stuff that should've been alpha-timed in the first place, but also makes creating new alpha-timing easier.

### Scenebleed Detector

Finds scenebleeds in the selected lines, and marks them with an effect (`bleed`).

### Select Comments

take a guess
