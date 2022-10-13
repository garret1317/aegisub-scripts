# garret's aegisub scripts

Aegisub automation scripts I've written.
Nothing cool and exciting here, just little utilities that make my life easier.

I write and use these on [arch1t3cht's fork](https://github.com/arch1t3cht/Aegisub/) on Linux (previously aegisub mainline), but they should work perfectly fine wherever, I don't think there's anything OS or fork-specific in there.

One day I'll get round to sorting out a DependencyControl feed. If you're reading this, that day has not yet come.

----

## Dupe and Comment

Duplicates a line and comments out the original.

This lets you:

- quickly create different versions of a line
- see the differences at a glance
- easily revert to the original, even if the undo history is gone

Probably the script I use the most.

| Key | Function | Rationale |
| --- | -------- | --------- |
| D | `Dupe and Comment/Do` | Easy access. "D" for duplicate. |
| Shift-D | `Dupe and Comment/Undo` | Shift-D, like Shift-Delete for deleting files. |
| Ctrl-D | `edit/line/duplicate` | Still want to dupe without commenting occasionally. |

These hotkeys let me have everything related to duplication on one key.

## Syllable Splitter

Splits romaji into karaoke syls. For the lazy k-timer.

Tries to use the lengths that aegi would produce if you did it manually.
Does an alright enough job most of the time, but is ignorant of whitespace.

Not that it really matters, you'll be retiming it anyway.

## K-Timing -> Alpha Timing

Makes doing alpha timing significantly easier by getting rid of the part where you do alpha timing.

Instead, K-Time the line, and run the script. The highlighting of the syls will become the appearance of the syls.

The original line will be commented out, so you can go back and change it easily.

Originally created to convert stuff that should've been alpha timed in the first place, but that used a hack with `\ko` instead.

## DependencyControl Global Config

There's a line in the DependencyControl README that goes:

> DependencyControl stores its configuration as a JSON file in the _config_ subdirectory of your Aegisub folder (`l0.DependencyControl.json`). Currently you'll have to edit this file manually, in the future there will be a management macro.

That line's been there for about 7 years now.

I wanted to change some settings without wading through the JSON and typing in the right stuff myself, so I wrote this.

## Select Comments

Tiny utility script.
Easier than `Subtitle > Select Lines` etc

----

Updating this README has made me realise that I only really have 2 or 3 actually useful scripts. Here are the bad and/or useless ones. 

These scripts should be considered abandoned for the foreseeable future.

They should all work decently enough, it's just that what they do isn't useful very often, or is done better by something else.

## A-B

Makes checking pre-timing possible by putting some text in the lines.
(the actor name, and `a` or `b`, hence the name)

ignores lines with text in them, prepends to lines with just tags in them

## Audio Clipper

Old and bad, but maybe still useful sometimes.

**Needs [FFMPEG](https://ffmpeg.org) in your PATH.**

Makes audio clips of all the selected lines.
Output is either stream-copied, or encoded to a format of your choice.

By default, makes a folder called `audioclipper_output` and dumps all the files in there.
The filename is the index of the line in your selection.

**Done better by**: [Petzku's `Encode Clip`](https://github.com/petzku/Aegisub-Scripts/blob/master/macros/petzku.EncodeClip.lua), Aegisub's `Create audio clip` button.

## Chapter Generator

Makes XML chapters for Matroska.

Incomplete clone of the chapter generator in [Significance](https://github.com/unanimated/luaegisub/blob/master/ua.Significance.lua).
No proper XML handling here, just mashing strings together and hoping for the best.

Makes lines with the effect `[Cc]hapter`, `[Cc]hptr` or `[Cc]hap` into chapters.

Start time is the timestamp, line text is the chapter name.
Language is currently hardcoded to English.

**Done better by**: `Significance`, SubKt.

## Restyler

previously `become-fansubber.lua`

For dealing with CR scripts.

Changes style of selected lines to `Default` and copies italic+alignment values from the script's styles to inline tags.

Can't help if the source script isn't sanely styled.
**cannot handle inline tags!**

## Scenebleed Detector

Finds scenebleeds in the selected lines, and marks them with an effect (`bleed`).

Currently has a hardcoded threshold of 500ms, as my brain is too small to figure out how to do a config file.

**Done better by**: probably some UA script

