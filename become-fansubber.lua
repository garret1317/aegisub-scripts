script_name="CR Restyler"
script_description="become a fansubber with a click of a button"
script_author = "garret"
script_version = "2021-06-15"

include("cleantags.lua")
-- Main -> Default
-- Top -> an8
-- italics -> i1
-- flashback -> default

function add_tags(line)
    local txt = line.text
    local style = line.style
    if style:match("Italics") then
        txt="{\\i1}"..txt
    end
    if style:match("Top") then
        txt="{\\an8}"..txt
    end
    line.text = cleantags(txt)
    return line
end

function change_styles(line)
    local style = line.style
    if style:match("Top") or style:match("Italics") or style:match("Main") or style:match("Flashback") then
        line.style="Default"
    end
    return line
end

function main(sub, sel)
	for h, i in ipairs(sel) do
		local line = sub[i]
        line = add_tags(line)
        line = change_styles(line)
		sub[i] = line
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, main)
