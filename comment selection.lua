script_name = "Comment selection"
script_description = "comment (add {} around) highlighted text in a line"
script_author = "garret"
script_version = "0.1.0"

local function have_selection_funcs()
	return aegisub.gui and aegisub.gui.get_selection
end

local function main(sub, sel, act)
	local line = sub[act]
	local start, end_ = aegisub.gui.get_selection()
	local txt = line.text:sub(1, start -1 ).."{"..line.text:sub(start, end_-1).."}"..line.text:sub(end_, #line.text)
	line.text = txt
	sub[act] = line
	aegisub.set_undo_point(script_name)
end

if have_selection_funcs() then
	aegisub.register_macro(script_name, script_description, main)
end
