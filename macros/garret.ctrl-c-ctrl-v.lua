script_name = "consistency assistant"
script_description = "ctrl-c ctrl-v"
script_version = "1.1.0"
script_author = "garret"
script_namespace = "garret.ctrl-c-ctrl-v"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
local util
if haveDepCtrl then
	depctrl = DependencyControl({
		--feed="TODO",
	})
end

local function main(sub, sel)
	local src = {}
	for i = 1, #sub do
		local line = sub[i]
		if line.class == "dialogue" then
			if line.comment ~= true then
				local copy_name = line.effect:match("ctrl%-c ?([%S]*)")
				local paste_name = line.effect:match("ctrl%-v ?([%S]*)")
				if copy_name ~= nil then
					aegisub.log(5, "ctrl-c " .. copy_name .. ": " .. line.text .. "\n")
					src[copy_name] = src[copy_name] or {}
					table.insert(src[copy_name], line)
				elseif paste_name ~= nil then
					aegisub.log(5, "ctrl-v " .. paste_name .. ": " .. line.text .. "\n")
					line.text = src[paste_name][1].text
					sub[i] = line
					table.remove(src[paste_name], 1)
				end
			end
		end
	end
end

if haveDepCtrl then
	depctrl:registerMacro(main)
else
	aegisub.register_macro(script_name, script_description, main)
end
