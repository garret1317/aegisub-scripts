script_name="Restyler"
script_description="become a fansubber with a click of a button"
script_author = "garret"
script_version = "2.2.0"
script_namespace = "garret.restyler"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
if haveDepCtrl then
	depctrl = DependencyControl {
		--feed="TODO",
	}
end

include("karaskel.lua")
include("cleantags.lua")

-- local config = simpleconf.get_config(aegisub.decode_path(config_dir.."/"..script_namespace..".conf"), {new_style = "Default"})

-- TODO: detect pre-existing inline tags

function add_tags(txt, italic, align) -- everything except txt is boolean. nil = don't change, !nil = change to this value

--[[not quite happy with this, it overwrites the alignment - ie line is "{\an4} blah blah" and style is an8, it just changes it to an8
realisticly this _probably_ won't be a problem, but still would like to try and stop it at some point to be safe
italics is fine, it just does {\i1\i0}, which is jank and bad but works fine so i won't worry about it too much]]
	if italic == true then
		txt="{\\i1}"..txt
	elseif italic == false then
		txt="{\\i0}"..txt
	end
	if align ~= nil then
		txt="{\\an"..align.."}"..txt
	end
	txt = cleantags(txt)
	return txt
end

function get_new(old, new)
	local i = nil
	if old ~= new then
		i = old
	end
	return i
end

function main(sub, sel)
	local _, styles = karaskel.collect_head(sub, false)
	local new_style_name = "Default"
	local new_style = styles[new_style_name]

	if new_style == nil then
		local style_names = {}
		for k, v in ipairs(styles) do
			table.insert(style_names, v.name)
		end

		local button_ok, result = aegisub.dialog.display({
			{x=0, y=0,class="label", label="You don't have a \""..new_style_name.."\" style. Select a style to change the selected lines to:"},
			{x=0, y=1, class="dropdown", items=style_names, value=style_names[1], name="style"},
		})
		if not button_ok then aegisub.cancel() end

		new_style_name = result.style
		new_style = styles[new_style_name]
	end


	for h, i in ipairs(sel) do
		-- TODO: automatically exclude styles (also configurable)
		local line = sub[i]
		local old_style = styles[line.style]
		local italic = get_new(old_style.italic, new_style.italic)
		local align = get_new(old_style.align, new_style.align)
		line.style = new_style_name
		line.text = add_tags(line.text, italic, align)
		sub[i] = line
	end
	aegisub.set_undo_point(script_name)
end

if haveDepCtrl then
	depctrl:registerMacro(main)
else
	aegisub.register_macro(script_name, script_description, main)
end
