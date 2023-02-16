script_name="Dupe and Comment"
script_description="Copies a line and comments out the original.\nbecause i like seeing the original while editing, and being able to go back to it easily"
script_author = "garret"
script_version = "5.0.0"
script_namespace = "garret.dupe-and-comment"

script_changelog = {
    ["5.0.0"] = {"subtle BREAKING CHANGE: Undo no longer cares whether the edit is a comment or not. This means it'll work in places it didn't before.", "Undo now sets the restored line to whatever comment status the edited line was. You won't get the same result when restoring lines where the edit is a comment.", "There is now a changelog for DepCtrl. (hint: you're reading it)"},
    ["4.0.0"] = {"Use on fold boundaries now works as expected."},
    ["3.0.2"] = {"code cleanup: variable names are now informative again."},
    ["3.0.1"] = {"Fixing selected/active lines is now more efficient."},
    ["3.0.0"] = {"Selected lines and active line will now be properly set after do and undo.", "Duplicating no longer depends on aegisub.util."},
    ["2.1.3"] = {"Trying to undo the final line no longer gives an out-of-range error (it fails silently instead)."},
    ["2.1.2"] = {"code cleanup: change variable names"},
    ["2.1.1"] = {"code cleanup: use local functions"},
    ["2.1.0"] = {"Added DepCtrl compatibility."},
    ["2.0.0"] = {"version 2021-04-11", "BREAKING CHANGE: Automation menu entries have been moved to a dedicated submenu."},
    ["1.1.0"] = {"version 2021-04-10", "Added undo macro."},
    ["1.0.0"] = {"inital git commit, version 2021-04-05", "The script now works with multiple lines.", "Switched to using aegisub.util for copying lines.", "cleaned up code"},
    ["0.1.0"] = {"snapshot from 2021-04-04, earliest copy i have", "has comment function, but only works on a single line at a time"},
}

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
if haveDepCtrl then
    depctrl = DependencyControl {
        --feed="TODO",
    }
end

local function strnumtobool(i) if i == "0" then return false else return true end end

local function find_fold_boundary(line)
    local fold = line.extra["_aegi_folddata"]

    if fold then -- we are indeed at a fold boundary
        -- now work out which one
        local at_fold_end = strnumtobool(string.sub(fold, 1, 1))
        -- first char is a bool, 0 = at start, 1 = at end
        return at_fold_end
    end
end

local function comment(subs, sel, act)
    for i=#sel,1,-1 do
        local edit=subs[sel[i]] -- current line
        local original=subs[sel[i]] -- and a copy of it

        -- deal with being at the start/end of a fold
        local at_fold_end = find_fold_boundary(edit)

        if at_fold_end then
            edit.extra["_aegi_folddata"] = nil -- remove fold data from the edit
            -- but not from the dupe, so effectively the end of the fold gets moved down one
        elseif at_fold_end == false then -- if at fold start
            original.extra["_aegi_folddata"] = nil -- ditto ^, but from the original
            -- so we don't have loads of extra fold starts that might interfere later
        end

        subs[sel[i]] = edit

        -- now use that copy we made to make a different line
        original.comment = true -- comment out the new dupe line
        subs.insert(sel[i]+1, original) -- and put it below

        -- sort out sel/act
        local preceding_lines = i - 1
        local on_act = act == sel[i]

        sel[i] = sel[i] + preceding_lines
        if on_act then act = sel[i] end

    end
    aegisub.set_undo_point(script_name)
    return sel, act
end

local function undo(subs, sel, act)
    for i=#sel,1,-1 do
        local edit=subs[sel[i]]
        if not (sel[i] + 1 > #subs) then -- preventing out-of-range errors
            local original=subs[sel[i]+1]

            if original.comment == true then
                original.comment = edit.comment
                -- deal with being at the start/end of a fold

                local at_fold_end = find_fold_boundary(edit)
                if at_fold_end == false then -- that is, if we're at the start
                    original.extra["_aegi_folddata"] = edit.extra["_aegi_folddata"]
                    -- preserve the original fold boundary so the fold doesnt magically disappear
                end

                subs[sel[i]+1] = original
                subs.delete(sel[i])

                if #sel > 1 then
                -- sort out selection. same as `do`, but the other way round.
                local preceding_lines = i + 1
                local on_act = act == sel[i]

                sel[i] = sel[i] - preceding_lines
                if on_act then act = sel[i] end
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
