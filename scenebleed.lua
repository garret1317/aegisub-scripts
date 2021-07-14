script_name="Scenebleed Detector"
script_description="marks possible scenebleeds with an effect"
script_author="garret"
script_version="2021-07-14"

function main(sub, sel)
    local thresh = aegisub.frame_from_ms(500)
    local bleedstring = "bleed"
    -- tried to make config file work, failed, so shit's hardcoded

    local keyframes = aegisub.keyframes()
    local bleed_count = 0
    for j,i in ipairs(sel) do
        line = sub[i]
        local start_frame = aegisub.frame_from_ms(line.start_time)
        local end_frame = aegisub.frame_from_ms(line.end_time)
        for index, frame in ipairs(keyframes) do
            if end_frame > frame and end_frame < frame + thresh or start_frame < frame and start_frame >= frame - thresh then
                -- off the kf, but not by more than the threshold
                if line.effect == "" then
                    line.effect = bleedstring
                else
                    line.effect = line.effect.."; "..bleedstring
                end
                bleed_count = bleed_count + 1
                sub[i] = line
            end
        end
    end
    aegisub.log(bleed_count.." scenebleeds found.")
    aegisub.set_undo_point(script_name)
    return sel
end

aegisub.register_macro(script_name, script_description, main)
