script_name = "Audio Clipper"
script_description = "Extracts audio from the selected line(s).\nNeeds ffmpeg."
script_author = "garret"
script_version = "1.1.3"

function err(msg)
    aegisub.dialog.display({{class = "label", label = msg}}, {"OK"}, {close = "OK"})
    aegisub.cancel()
end

function get_vid_dir()
    local aud_dir = aegisub.decode_path("?audio")
    local vid_dir = aegisub.decode_path("?video")
    if aud_dir ~= "?audio" then
        return aud_dir
    elseif vid_dir ~= "?video" then -- if there is not, in fact, a video
        return vid_dir
    else
        return nil
    end
end

function get_vid()
    local aud = aegisub.project_properties().audio_file -- try get the audio first, if it's loaded separately
    local vid = aegisub.project_properties().video_file
    if aud ~= "" then
        return aud
    elseif vid ~= "" then
        return vid
    else
        return nil
    end
end

function get_format(copy, format, custom)
    if copy == true then -- if we do want to copy
        if format == "" then -- format is the thing from the dropdown
            err("Need a format!")
        elseif format == "AAC" then -- these are the most common audio formats i've seen
            return "m4a"
        elseif format == "Opus" then
            return "opus"
        elseif format == "FLAC" then
            return "flac" elseif format == "Custom" then -- but I am not all-knowing, so you can put your own
            return custom
        end
    else -- if we don't want to copy (i.e. we've pressed "Just make it FLAC")
        return "flac"
    end
end

function make_out_path(out_path)
    local lfs = require "aegisub.lfs"
    if out_path == "" then
        err("Need an output path!")
    end
    lfs.mkdir(out_path)
    return out_path
end

function extract_audio(in_path, start_time, end_time, out_path, name, extension, copy)
    if copy == true then
        os.execute('ffmpeg -ss '..start_time..'ms -to '..end_time..'ms -i "'..in_path..'" -codec copy -vn "'..out_path..name..'.'..extension..'" -y')
     -- takes the video as input, copies the streams, but doesn't include video. sets it to start at the start of the selection, and end at the end of it. outputs to our chosen out path with our chosen name and extension. overwrites anything with the same name.
    elseif copy == false then
        os.execute('ffmpeg -ss '..start_time..'ms -to '..end_time..'ms -i "'..in_path..'" -vn "'..out_path..name..'.'..extension..'" -y')
     -- same as above, but doesn't copy the stream (transcodes to flac)
    end
end

function loop(subs, sel, in_path, out_path, extension, copy, delay)
    aegisub.progress.title("Extracting Audio")
    local progress = 0
    local progress_increment = 100 / #sel -- increment by this for every line, and the bar will eventually reach 100
    for x, i in ipairs(sel) do -- x is the position of the line in our selection, i is the position in the whole sub file
        if aegisub.progress.is_cancelled() then -- if you press the cancel button
            aegisub.cancel() -- it stops (mind-blowing, i know)
        end
        aegisub.progress.set(progress)
        local line = subs[i]
        local start_time = line.start_time + delay
        local end_time = line.end_time + delay
        aegisub.progress.task("Extracting line "..x)
        extract_audio(in_path, start_time, end_time, out_path, x, extension, copy)
        progress = progress + progress_increment
    end
    aegisub.progress.set(100) -- in case it didn't reach 100 on its own
end


function gui(subs, sel)
    local in_path = get_vid()
    local out_path = get_vid_dir()
    if in_path == nil or out_path == nil then -- if no video is loaded
        in_path = "No audio/video loaded. Specify a path."
        out_path = in_path -- both the same error message
    else
        out_path = out_path.."/audioclipper_output/" -- make the out path the one we actually want
    end

    local get_input={{class="label",x=0,y=0,label="Input's audio format:"},{class="dropdown",name="format",x=0,y=1,width=2,height=1,items={"AAC","Opus","FLAC","Custom"},value="Audio Format",hint="If you don't know, you should probably press \"Just make it FLAC\", or use mka."},{class="label",x=0,y=2,label="Custom Extension:"},{class="edit",name="custom",x=1,y=2,value="mka",hint="You'll probably be fine with mka, because matroska can contain pretty much anything"},{class="label",x=0,y=3,label="Delay (ms):"},{class="intedit",name="delay",x=1,y=3,value=0,hint="to prevent timing fuckery with weird raws"},{class="label",x=0,y=4,label="Input path:"},{class="edit",name="in_path",x=0,y=5,width=2,height=1,value=in_path,hint="where the audio comes from"},{class="label",x=0,y=6,label="Output path (will be created if it doesn't already exist):"},{class="edit",name="out_path",x=0,y=7,width=2,height=1,value=out_path,hint="where the audio goes"}}
    local pressed, results = aegisub.dialog.display(get_input, {"Cancel", "OK", "Just make it FLAC"})
    -- there's probably something that can detect the format automatically, but I do not know what it is.
    if pressed == "Cancel" then
        aegisub.cancel()
    elseif pressed == "OK" then
        do_copy = true
    elseif pressed == "Just make it FLAC" then
        do_copy = false
    end
    local extension = get_format(do_copy, results.format, results.custom) -- gets file extension
    local delay = results.delay
    in_path = results.in_path
    out_path = make_out_path(results.out_path)
    loop(subs, sel, in_path, out_path, extension, do_copy, delay)
end

function non_gui(subs, sel) -- no gui, so you can bind it to a hotkey
    local vid = get_vid()
    if vid == nil then
        err("Need an input!\nSpecify a path in the GUI, or load one in aegisub.")
    else
        loop(subs, sel, get_vid(), make_out_path(get_vid_dir().."/audioclipper_output/"), 'flac', false, 0)
    end
 -- sets sane defaults (takes the audio from the video file, and outputs to /the/video/dir/audioclipper_output/. transcodes to flac. no delay)
end

aegisub.register_macro(script_name, script_description, gui)
aegisub.register_macro(": Non-GUI macros :/"..script_name..": Just make it FLAC", script_description, non_gui) -- same section as unanimated's scripts
