script_name="Dupe and Comment"
script_description="Copies a line and comments out the original.\nbecause i like seeing the original while editing, and being able to go back to it easily"
script_author = "garret"
script_version = "2.1.1"
script_namespace = "garret.dupe-and-comment"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
local util
if haveDepCtrl then
    depctrl = DependencyControl {
        --feed="TODO",
        {"aegisub.util"}
    }
    util = depctrl:requireModules()
else
    util = require 'aegisub.util'
end

local function comment(subs, sel)
    for i=#sel,1,-1 do
        local line=subs[sel[i]]
        local dupe = util.copy(line)
        line.comment = false -- going to edit it, so we probably want to see it on the video
        dupe.comment = true -- this is the actual original one
        subs.insert(sel[i]+1,dupe) -- putting it on the next line so i don't have to change line
    end
    aegisub.set_undo_point(script_name)
end

local function undo(subs, sel)
    for i=#sel,1,-1 do
        local edit=subs[sel[i]]
        local original=subs[sel[i]+1]
        if edit.comment == false and original.comment == true then
            original.comment = false
            subs[sel[i]+1] = original
            subs.delete(sel[i])
        end
    end
    aegisub.set_undo_point("Undo "..script_name)
end

local macros = {
    {"Do", script_description, comment},
    {"Undo","Deletes selected line and restores the original", undo}
}
if haveDepCtrl then
    depctrl:registerMacros(macros)
else
    for _,macro in ipairs(macros) do
        local name, desc, fun = unpack(macro)
        aegisub.register_macro(script_name .. '/' .. name, desc, fun)
    end
end
-- i trust what petzku from the cartel has to say on adding multiple macros with depctrl
