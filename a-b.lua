script_name = "A-B"
script_description = "makes checking pre-timing possible.\nCAUTION: Overwrites every selected line!"
script_author = "garret"
script_version = "2021-04-03"
function main(sub, sel)
    local i = 0
    for si,li in ipairs(sel) do
        line = sub[li]
        if i == 0 then
            line.text = line.actor.." a"
            i = 1
        elseif i == 1 then
            line.text = line.actor.." b"
            i = 0
        end
        sub[li] = line
    end
    aegisub.set_undo_point(script_name)
    return sel
end
aegisub.register_macro(script_name, script_description, main)
