script_name="Dupe and Comment"
script_description="Copies a line and comments out the original.\nbecause i like seeing the original while editing, and being able to go back to it easily"
script_author = "garret"
script_version = "4.0.0"
script_namespace = "garret.dupe-and-comment"

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

            if edit.comment == false and original.comment == true then
                original.comment = false
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
