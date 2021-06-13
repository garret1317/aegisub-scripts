script_name = "tagstrip"
script_description = "nukes tags\n(and comments)"
script_author = "garret"
script_version = "2021-06-13"
include("cleantags.lua")

function strip(sub, sel)
	for h, i in ipairs(sel) do
        line = sub[i]
        line.text = line.text:gsub("{[^}]-}","")
        sub[i] = line
	end
	aegisub.set_undo_point(script_name)
end

function clean(sub, sel)
	for h, i in ipairs(sel) do
        line = sub[i]
        line.text = cleantags(line.text)
        sub[i] = line
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, strip)
--aegisub.register_macro("Clean Tags", script_description, clean) -- dupe of existing aegi one
