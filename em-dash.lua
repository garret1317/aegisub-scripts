script_name = "Em-dash"
script_description = "I do not have an em-dash key on my keyboard"
script_author = "garret"
script_version = "2.1.1"

local em = "—"

local function have_cursor_funcs()
	return aegisub.gui and aegisub.gui.get_cursor and aegisub.gui.set_cursor
end

local function insert(sub, sel, act)
	local line  = sub[act]
	local pos   = aegisub.gui.get_cursor()
	local start = string.sub(line.text, 1, pos - 1)
	local end_  = string.sub(line.text, pos)
	line.text = start .. em .. end_
	aegisub.gui.set_cursor(pos + #em)
	sub[act] = line
end

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

local function replace(sub, sel)
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
if have_cursor_funcs() then
	aegisub.register_macro(script_name.."/Insert", "Inserts an em-dash at the cursor position", insert)
end
