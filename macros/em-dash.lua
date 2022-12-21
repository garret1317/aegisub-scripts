script_name = "Em-dash"
script_description = "I do not have an em-dash key on my keyboard"
script_author = "garret"
script_version = "2.0.0"

local em = "—"

local function append(sub, sel)
	for si, li in ipairs(sel) do
		local line = sub[li]
		if string.sub(line.text, -1) == "-" then
			line.text = line.text:sub(1, #line.text - 1)
		end
			line.text = line.text..em
		sub[li] = line
	end
	aegisub.set_undo_point(script_name)
end

function replace(sub, sel)
    for si, li in ipairs(sel) do
        local line = sub[li]
        local text = sub[li].text
        text = text:gsub("%-%-",em)
    	line.text=text
        sub[li] = line
    end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name.."/Append", "Appends an Em-dash to the selected line(s)", append)
aegisub.register_macro(script_name.."/Replace", "Replaces -- with "..em, replace)
