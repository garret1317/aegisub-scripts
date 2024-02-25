# garret's aegisub scripts

Aegisub automation scripts I've written.
Nothing cool and exciting here, just little utilities that make my life easier.

You are welcome to package and distribute these scripts as a DependencyControl feed, provided you
comply with the terms of the licence. I will not be doing so myself.

----

## Dupe and Comment

Duplicates a line and comments out the original.

This lets you:

- quickly create different versions of a line
- see the differences at a glance
- easily revert to the original, even if the undo history is gone

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

## Song timer

makes song timing into a rhythm game
so you can vibe while you time

bind to e.g. space

0. tap to initialise (`READY`)
1. tap to set start (`START`)
1. tap to set end (`END`) + move to next line (`READY`)
1. go to 1.

apparently that's what some vhs era groups did for their entire dialogue timing

it's pretty good for (rough pass) song timing, especially if you know the song well.
probably won't be faster, but will be much more enjoyable

## K-Timing -> Alpha Timing

Makes doing alpha timing significantly easier by getting rid of the part where you do alpha timing.

Instead, K-Time the line, and run the script. The highlighting of the syls will become the appearance of the syls.

The original line will be commented out, so you can go back and change it easily.

Originally created to convert stuff that should've been alpha timed in the first place, but that used a hack with `\ko` instead.

## DependencyControl Global Config

There's a line in the DependencyControl README that goes:

> DependencyControl stores its configuration as a JSON file in the _config_ subdirectory of your Aegisub folder (`l0.DependencyControl.json`). Currently you'll have to edit this file manually, in the future there will be a management macro.

The management macro still doesn't exist, so i wrote one myself.

## Select Comments

Tiny utility script.
Easier than `Subtitle > Select Lines` etc

## A-B

Makes checking pre-timing possible by putting some text in the lines.
(the actor name, and `a` or `b`, hence the name)

ignores lines with text in them, prepends to lines with just tags in them

## Audio Clipper

useful sometimes (cant losslessly cut in audacity)

**Needs [FFMPEG](https://ffmpeg.org) in your PATH.**

Makes audio clips of all the selected lines.
Output is either stream-copied, or encoded to a format of your choice.

By default, makes a folder called `audioclipper_output` and dumps all the files in there.
The filename is the index of the line in your selection.

## Chapter Generator

Makes XML chapters for Matroska.

Incomplete clone of the chapter generator in [Significance](https://github.com/unanimated/luaegisub/blob/master/ua.Significance.lua).

Makes lines with the effect `[Cc]hapter`, `[Cc]hptr` or `[Cc]hap` into chapters.

Start time is the timestamp, line text is the chapter name.
Language is hardcoded to English.

## Restyler

previously `become-fansubber.lua`

Changes style of selected lines to `Default` and copies italic+alignment values from the script's styles to inline tags.
This is meant for restyling crunchyroll scripts to the fansub group's house style.

Can't help if the source script isn't sanely styled.

## Scenebleed Detector

Finds scenebleeds in the selected lines, and marks them with an effect (`bleed`).

hardcoded threshold of 500ms.
