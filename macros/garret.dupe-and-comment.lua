script_name="Dupe and Comment"
script_description="Copies a line and comments out the original.\nbecause i like seeing the original while editing, and being able to go back to it easily"
script_author = "garret"
script_version = "3.0.0"
script_namespace = "garret.dupe-and-comment"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
if haveDepCtrl then
    depctrl = DependencyControl {
        --feed="TODO",
    }
end

local function comment(subs, sel, act)
    for i=#sel,1,-1 do
        local line=subs[sel[i]] -- grab copy of current line

        -- now use that copy for a different line
        line.comment = true -- comment out the new dupe line
        subs.insert(sel[i]+1, line) -- and put it below

        -- sort out selection
        for j=i+1,#sel do
            sel[j] = sel[j] + 1 -- bump all of sel by 1 to compensate for new line
        end -- first item isnt included because it's not affected

        if act > sel[i] then -- if we've not got to the active line yet
            act = act + 1 -- bump by 1 to compensate for new lines above
        end
    end
    aegisub.set_undo_point(script_name)
    return sel, act
end

local function undo(subs, sel, act)
    for i=#sel,1,-1 do
        local edit=subs[sel[i]]
        if not (sel[i] + 1 > #subs) then -- preventing out-of-range errors
            local original=subs[sel[i]+1]

            if edit.comment == false and original.comment == true then
                original.comment = false
                subs[sel[i]+1] = original
                subs.delete(sel[i])

                -- sort out selection. same as `do`, but the other way round.
                for j=i+1,#sel do
                    sel[j] = sel[j] - 1
                end
                if act > sel[i] then
                    act = act - 1
                end

            end
        end
    end
    aegisub.set_undo_point("Undo "..script_name)
    return sel, act
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
