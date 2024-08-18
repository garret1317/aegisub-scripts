script_name = "Chapter Generator"
script_description = "Makes XML chapters for matroska."
script_author = "garret"
script_version = "2.1.0"
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

local function main(sub)
    local times = {}
    local names = {}
    for i=1,#sub do
        local line = sub[i]
        if line.class == "dialogue" then
            local fx = line.effect
            if fx:match("[Cc]hapter") or fx:match("[Cc]hptr") or fx:match("[Cc]hap") then
                line.comment = true
                table.insert(times, line.start_time)
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
