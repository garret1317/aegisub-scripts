script_name = "Select Comments"
script_description = "Selects all commented lines"
script_author = "garret"
script_version = "1.0.0"

-- logging stuff, for testing
-- commented out because for the user it's an external dependency for no good reason
--[[inspect = require 'inspect'
function log(level, msg)
    if type(level) ~= "number" then
        level = msg
        level = 4
    end
    if type(msg) == "table" then
        msg = inspect(msg)
    end
    aegisub.log(level, tostring(msg) .. "\n")
end]]

function main(sub, sel)
    sel = {}
    for i=1,#sub do
        line=sub[i]
        if line.comment == true then
            --log(4, "comment on line "..i)
            table.insert(sel, i)
            --log(4, sel)
        end
    end
    aegisub.set_undo_point(script_name)
    return sel
end

aegisub.register_macro(script_name, script_description, main)
