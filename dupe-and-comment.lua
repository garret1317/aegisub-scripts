script_name="Dupe and Comment"
script_description="Copies a line and comments out the original."
script_author = "garret"
script_version = "2021-04-05"
include("utils.lua")
-- i like seeing the original while editing, and being able to go back to it easily

function comment(subs, sel)
    for i=#sel,1,-1 do
        local line=subs[sel[i]]
        local dupe = util.copy(line)
        line.comment = false -- going to edit it, so we probably want to see it on the video
        dupe.comment = true -- this is the actual original one
        subs.insert(sel[i]+1,dupe) -- putting it on the next line so i don't have to change line
    end
    aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, comment)
