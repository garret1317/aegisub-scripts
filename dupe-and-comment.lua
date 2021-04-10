script_name="Dupe and Comment"
script_description="Copies a line and comments out the original."
script_author = "garret"
script_version = "2021-04-10"
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

function undo(subs, sel)
    for i=#sel,1,-1 do
        local edit=subs[sel[i]]
        local original=subs[sel[i]+1]
        --aegisub.log("Edit\nindex = "..i..", text = "..edit.text.."\n")
        --aegisub.log("Original\nindex = "..(i + 1)..", text = "..original.text.."\n")
        if edit.comment == false and original.comment == true then

            original.comment = false
            subs[sel[i]+1] = original
            subs.delete(sel[i])
        end
    end
    aegisub.set_undo_point("Undo "..script_name)
end

aegisub.register_macro(script_name, script_description, comment)
aegisub.register_macro(script_name.." - Undo", "Uncomments a line and restores the original", undo)
