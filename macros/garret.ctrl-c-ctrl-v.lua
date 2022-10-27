script_name = "consistency assistant"
script_description = "ctrl-c ctrl-v"
script_version = "1.0.0"
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
				if line.effect:match("ctrl%-c") then
					aegisub.log(5, "ctrl-c: " .. line.text .. "\n")
					table.insert(src, line)
				elseif line.effect:match("ctrl%-v") then
					aegisub.log(5, "ctrl-v: " .. line.text .. "\n")
					line.text = src[1].text
					sub[i] = line
					table.remove(src, 1)
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
