script_name = "Select Comments"
script_description = "Selects all commented lines"
script_author = "garret"
script_version = "1.0.1"

function main(sub, sel)
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

aegisub.register_macro(script_name, script_description, main)
