script_name = "Chapter Generator"
script_description = "Makes XML chapters for matroska."
script_author = "garret"
script_version = "2.2.0"
script_namespace = "garret.chapters"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")

if haveDepCtrl then
    depctrl = DependencyControl {
        --feed="TODO",
    }
end

local config = {language = "eng", language_ietf = "en"}

local function ms_to_human(start) -- From Significance
    local timecode=math.floor(start/1000)
    local tc1=math.floor(timecode/60)
    local tc2=timecode%60
    local tc3=start%1000
    local tc4="00"
    if tc2==60 then tc2=0 tc1=tc1+1 end
    if tc1>119 then tc1=tc1-120 tc4="02" end
    if tc1>59 then tc1=tc1-60 tc4="01" end
    if tc1<10 then tc1="0"..tc1 end
    if tc2<10 then tc2="0"..tc2 end
    if tc3<100 then tc3="0"..tc3 end
    linetime=tc4..":"..tc1..":"..tc2.."."..tc3
    if linetime=="00:00:00.00" then linetime="00:00:00.033" end
    return linetime
end

local function get_sane_path()
    script_path = aegisub.decode_path("?script")
    audio_path = aegisub.decode_path("?audio")
    video_path = aegisub.decode_path("?video")
    if script_path ~= "?script" then
        return script_path
    elseif video_path ~= "?video" then
        return video_path
    elseif audio_path ~= "?audio" then
        return audio_path
    else
        return ""
    end
end

local function get_user_path(default_dir)
    local path = aegisub.dialog.save("Save Chapter File", default_dir, "chapters.xml", "XML files|*.xml|All Files|*", false)
    return path
end

-- from arch.Util apparently
local function exact_ms_from_frame(frame)
--[[
MIT License

Copyright (c) 2022 arch1t3cht

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
  frame = frame + 1
  local ms = aegisub.ms_from_frame(frame)
  while true do
    local new_ms = ms - 1
    if new_ms < 0 or aegisub.frame_from_ms(new_ms) ~= frame then
      break
    end
    ms = new_ms
  end
  return ms - 1
end

local function main(sub)
    local times = {}
    local names = {}
    if aegisub.decode_path("?video") == "?video" then
        aegisub.log(3, "you don't have a video open, times will be limited to centiseconds (realistically this is fine)\n")
    end
    for i=1,#sub do
        local line = sub[i]
        if line.class == "dialogue" then
            local fx = line.effect
            if fx:match("[Cc]hapter") or fx:match("[Cc]hptr") or fx:match("[Cc]hap") then
                line.comment = true

                local time = line.start_time
                if aegisub.decode_path("?video") ~= "?video" then
                    -- cunning and devious scheme to get accurate milliseconds
                    time = math.max(exact_ms_from_frame(aegisub.frame_from_ms(line.start_time)), 0)
                end
                table.insert(times, time)
                table.insert(names, line.text)
                sub[i] = line
            end
        end
	end
	aegisub.set_undo_point(script_name)
    local chapters = "﻿<?xml version=\"1.0\"?>\n<!-- <!DOCTYPE Chapters SYSTEM \"matroskachapters.dtd\"> -->\n<Chapters>\n  <EditionEntry>\n"
    for j, k in ipairs(times) do
        local humantime = ms_to_human(k)
        local name = names[j]
        chapters = chapters.."    <ChapterAtom>\n      <ChapterTimeStart>"..humantime.."</ChapterTimeStart>\n      <ChapterDisplay>\n        <ChapterString>"..name.."</ChapterString>\n        <ChapLanguageIETF>"..config.language_ietf.."</ChapLanguageIETF>\n        <ChapterLanguage>"..config.language.."</ChapterLanguage>\n      </ChapterDisplay>\n    </ChapterAtom>\n"
    end
    chapters = chapters.."  </EditionEntry>\n</Chapters>"
    sane_path = get_sane_path()
    path = get_user_path(sane_path)
    if path ~= nil then
        local chapfile = io.open(path, "w")
	    chapfile:write(chapters)
        chapfile:close()
    else
        aegisub.cancel()
    end
end

if haveDepCtrl then
    depctrl:registerMacro(main)
else
    aegisub.register_macro(script_name, script_description, main)
end
