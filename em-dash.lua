script_name = "Em-dash"
script_description = "I do not have an em-dash key on my keyboard"
script_author = "garret"
script_version = "2.2.0"

local em = "—"

local function have_cursor_funcs()
	return aegisub.gui and aegisub.gui.get_cursor and aegisub.gui.set_cursor
end

local function insert(sub, sel, act)
	local line  = sub[act]
	local pos   = aegisub.gui.get_cursor()

	local highlight_start, highlight_end = aegisub.gui.get_selection()
	local replace_start, replace_end
	if highlight_start ~= highlight_end then
		replace_start = highlight_start -1
		replace_end = highlight_end
	else
		replace_start = pos - 1
		replace_end = pos
	end

	local start = string.sub(line.text, 1, replace_start)
	local end_  = string.sub(line.text, replace_end)
	line.text = start .. em .. end_
	cursor_pos = replace_start + #em

	aegisub.gui.set_cursor(cursor_pos)
--	aegisub.gui.set_selection(cursor_pos + 1, cursor_pos + 1)
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
