script_name = "A-B"
script_description = "makes checking pre-timing possible."
script_author = "garret"
script_version = "2021-07-10"

function switch_number(i)
    if i == "a" then
        return "b"
    elseif i == "b" then
        return "a"
    end
end

function main(sub, sel)
    local i = "a"
    for si,li in ipairs(sel) do
        line = sub[li]
        if line.actor == "" then
            indicator = i
        else
        indicator = line.actor.." "..i
        end
        if line.text == "" then
            line.text = indicator
        elseif line.text:gsub("{[^}]-}","") == "" then
            line.text = indicator.." "..line.text
        end
        sub[li] = line
        i = switch_number(i)
    end
    aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, main)
