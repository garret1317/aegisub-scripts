script_name = "Select comments"
script_description = "Select all commented lines"
script_author = "garret"
script_version = "1.1.0"
script_namespace = "garret.select-comments"
-- faster than doing Subtitle -> Select Lines etc (at least in terms of button-presses)

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
if haveDepCtrl then
    depctrl = DependencyControl {
        --feed="TODO",
    }
end
-- this does not need depctrl at all lol
-- just for consistency's sake really

function main(sub)
    sel = {}
    for i=1,#sub do
        line=sub[i]
        if line.comment == true then
            table.insert(sel, i)
        end
    end
    aegisub.set_undo_point(script_name)
    return sel
end

if haveDepCtrl then
    depctrl:registerMacro(main)
else
    aegisub.register_macro(script_name, script_description, main)
end
