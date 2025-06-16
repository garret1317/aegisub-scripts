# garret's aegisub scripts

These are automation scripts ("plugins" basically) I've written for the subtitle editor [Aegisub](https://aegisub.org).

I do timing and editing, so these scripts mainly help with those. There's nothing ground-breaking and exciting here, just some stuff to make my life easier.

## how do i install them

You should be able to add them via the [Automation Manager](https://aegisub.org/docs/3.2/Automation/Manager/index.html), or put them in your `autoload` folder.

I'm experimenting with offering a DependencyControl feed. The feed URL is:
```
https://427738.xyz/depctrl/feed.json
```

Some of the scripts don't register themselves with DependencyControl, so they won't auto-update. Sorry about that.
~~if it's any consolation it's not like i ever update them these days anyway~~

## how do i get help

ping me in the [GJM discord server](https://discord.gg/hQewDqS) (same username) and I'll probably reply eventually. Otherwise, open a github issue.

```
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
ie, technically its not my problem if it doesnt work, burns your house down, etc 👍

fundamentally this is just stuff i wrote for myself and threw over the wall in case it could be useful to someone else as well, i will probably try to help though

----

And now, the scripts, in no particular order:

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

Thanks to [Akatsumekusa](https://github.com/Akatmks) for helping improve this script.


## Chapter Generator

Generates a chapters file that you can mux into your MKV.

Make a new line, starting at the start of your chapter. Put the chapter name in the text, then mark it with `chapter`, `chptr` or `chap` in the effect field.

For example:

```
Comment: 0,0:00:00.00,0:00:01.00,Default,,0,0,0,chap,Intro
Comment: 0,0:03:12.96,0:03:13.96,Default,,0,0,0,chap,OP
Comment: 0,0:04:43.01,0:04:44.01,Default,,0,0,0,chap,Part A
Comment: 0,0:11:43.02,0:11:44.02,Default,,0,0,0,chap,Part B
Comment: 0,0:21:09.96,0:21:10.96,Default,,0,0,0,chap,ED
Comment: 0,0:22:40.01,0:22:41.01,Default,,0,0,0,chap,Outro
```

Then run the script and save the file it gives you. You use it in the Chapters section of MKVToolNix (in the `Output` tab).

### tips/useful things to know

- The first letter of the effect can be uppercase if you want.
- The end time of the line doesn't matter, it's not used in the chapters.
- The language is hardcoded to English, but it's not _too_ difficult to edit the script to change it. Just CTRL-F for `eng` and change the two values.

### acknowledgements

Includes code by unanimated to convert from ms to `H:MM:SS.mmm` (stolen from [Significance](http://unanimated.hostfree.pw/ts/signi.lua)).

Includes [code by arch1t3cht](https://github.com/TypesettingTools/arch1t3cht-Aegisub-Scripts/blob/0b67d516c7087c308c81d6a663596615d83126a6/modules/arch/Util.moon#L26-L40) to make the timestamps frame-accurate. Used under the terms of the MIT License.


## Restyler

Changes the style of selected lines to `Default`, and converts italic+alignment (`\an`) values from the script's styles to inline tags.
This is meant for restyling crunchyroll scripts that use separate styles like `main`, `top`, `italics`, `italicstop`, etc.

On a related note, you might like [Chrolo's script](https://github.com/Chrolo/ChroloScripts_Aegisub/blob/master/chrolo.Restyler.lua) to change a line's base style without changing how it actually looks.

previously `become-fansubber.lua`


## Check Pre-timing

This script puts stuff in empty dialogue lines (the actor name, and alternating `a` or `b`).

This lets you check pre-timed subtitles without actually having a translation.
You can't check CPS of course, but you can see whether the lines are lined up properly, whether they match their actor, etc.

It also includes an undo macro, so you can clean up after yourself after making changes.

It ignores lines that already have text in them.
If the line only has tags, it puts the text after them. (that way you can see what those tags do to the text.)

Formerly known as A-B, after the alternating a-b it puts in the lines.


## K-Timing -> Alpha Timing

Makes doing [alpha timing](https://fansubbers.miraheze.org/wiki/Glossary#alpha_timing) significantly easier, by getting rid of the part where you do alpha timing.

[Time the line in karaoke mode](https://zahuczky.com/0-ktiming-guide/), with the "syllables" as the sections of the line you want to appear. Then run the script, and it'll generate some nice alpha-timed lines for you.

The original line will be commented out, so you can go back and change it easily.

Originally created to convert stuff that should've been alpha timed in the first place, but that used a hack with `\ko` instead.

## DependencyControl Global Config

This macro adds additional configuration interfaces for DependencyControl, so you don't have to edit the JSON file.

- `Global Configuration`: lets you change DependencyControl's behaviour.
- `Extra Feeds`: lets you provide additional update feeds that will be used when checking any script for updates.

Please see [the DependencyControl README](https://github.com/typesettingTools/DependencyControl#configuration) for details on the configuration options.

Time format: `[number][unit]`

- `y` for years
- `d` for days
- `h` for hours
- `m` for minutes
- `s` for seconds

so `7d` is 7 days, `3d12h` is 3 days and 12 hours, `5m30s` is 5 minutes and 30 seconds, you get the idea

### rationale

There's a line in the DependencyControl README that goes:

> DependencyControl stores its configuration as a JSON file in the _config_ subdirectory of your Aegisub folder (`l0.DependencyControl.json`). Currently you'll have to edit this file manually, in the future there will be a management macro.

That line was there for 7 years and the management macro still didn't exist, so I wrote one myself.

## faderer

Lets you as the timer do fade-in/outs without having to bother the typesetter.

Go to the frame before the fade starts, and run the script. Then go to the frame where the fade finishes, and run the script again.

Select whether the fade is to/from Black, White, or Alpha. It'll try to guess from the timings whether you want to fade in or out, and apply the fade.

Includes [code by arch1t3cht](https://github.com/TypesettingTools/arch1t3cht-Aegisub-Scripts/blob/0b67d516c7087c308c81d6a663596615d83126a6/modules/arch/Util.moon#L26-L40) to get frame-accurate times. Used under the terms of the MIT License.

## Em-dash

Lets you:
- Append an Em-dash to the selected lines
- Replace instances of `--` with an em-dash

Also, if you use [arch1t3cht's Aegisub](https://github.com/arch1t3cht/aegisub):
- Insert an Em-dash at the cursor position

because chances are you don't have an em-dash key on your keyboard :)

## Select Comments

Tiny utility script.
Easier than `Subtitle > Select Lines` etc.


## Song timer

makes song timing into a rhythm game, so you can vibe while you time

bind the script to to e.g. space, and then:

0. tap to initialise (`READY`)
1. tap to set start time (`START`)
2. tap to set end time (`END`) + move to next line (`READY`)
3. go to 1.

apparently that's what some vhs era groups did for their entire dialogue timing

it's reasonable enough for (rough pass) song timing, especially if you know the song well.
probably won't be faster, but will be much more enjoyable


## Scenebleed Detector

Finds scenebleeds in the selected lines, and marks them with an effect (`bleed`).

This is meant in the vein of unanimated's Quality Check script. It's to help spot mistakes, not as your only check.

It has a hardcoded threshold of 500ms.


## Consistency assistant

`ctrl-c-ctrl-v.lua`

i dont remember


## Shenanigans

This script makes dialogue motion-tracking shenanigans easier to manage, by splitting them off into a separate file.

First, define a shenanigan file by making a line in the dialogue file with the effect `import`, and a path to the file as the text.

Like so: `Comment: 10,0:00:00.00,0:00:00.00,Default,,0,0,0,import,shenanigans_naga02_08.ass`

Then time/edit as normal. When you see a line (or group of lines) that could use a shenanigan, mark each line with `shenan some meaningful identifier` in the effect field.

The typesetter goes through all the shenanigans, copies them to the shenanigans file, and does all the motion tracking/effects/whatever in there.

Then, at mux time, you run the script, and it replaces the marked dialogue lines with their counterparts from the shenanigans file.

It's good, because if you ever need to go back and change a line, you can do it without having to wade through 516879832 lines of frame-by-frame motion tracking.

Nowadays this can be handled with folds in [arch1t3cht's Aegisub](https://github.com/arch1t3cht/Aegisub), but they weren't invented yet when this script was written.

There are two implementations here: the python one which we actually use in the mux script, and a lua proof-of-concept.


## Syllable Splitter

Splits romaji into karaoke syls.

It tries to use the lengths that the Aegisub K-Timing mode would give if you split it manually.


## Timings copier

For when you've timed the romaji for a song and just want to copy those timings to the english thats already in the file.

Requires two consecutive equal-length blocks of lines with different styles from each other.
i.e. you have your romaji lines, and the english ones directly after, with separate romaji and english styles.

## Comment selection

Make the highlighted text into an inline comment. (encloses it in `{curly brackets}`)

Requires [arch1t3cht's Aegisub](https://github.com/arch1t3cht/aegisub).

i don't think i've ever actually used this lol


## Append Comment

pops up a text box for you to write your comment in, and appends it to the line.

i'm not sure i ever used this one either


## pos -> an

converts `\pos` positions into `\an` alignments

the idea is you click in the general area of where you want, and then the script converts that into eg `\an1 \an8 \an6` etc

but it's not really very useful because that's more effort than just typing it, especially on a numpad


**EDIT**: it is quite useful actually, if you're starting off with something that has explicit positioning
e.g. ASS converted from other caption formats (WEBVTT, ISDB, ocr'd from DVD)


## Audio Clipper

Makes audio clips of all the selected lines.
Output is either stream-copied, or encoded to a format of your choice.

Select the lines you want to clip, and run the script.

By default, makes a folder called `audioclipper_output` and dumps all the files in there.
The filename is the index of the line in your selection. (no thats not very useful)

Needs [FFMPEG](https://ffmpeg.org) in your $PATH.


## TXT Cleanup

`light-purge.lua`

Script I wrote for LightArrowsEXE to remove actors and/or linebreaks when exporting to TXT.
I think he wanted it to make doing diffs easier, idk

This is an export filter, not a macro. As such, it won't show up in the normal Automation menu- you have to use `File > Export Subtitles...` and use it from there.
