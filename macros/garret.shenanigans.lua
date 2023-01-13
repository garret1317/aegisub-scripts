script_name = "Import Shenanigans"
script_description = "imports shenanigans"
script_author = "garret"
script_version = "0.1.0"
script_namespace = "garret.shenanigans"

local SHENAN_PATTERN = "shenan ([^;]*)"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
local parser
if haveDepCtrl then
	depctrl = DependencyControl({
		--feed="TODO",
		{
			{
				"myaa.ASSParser",
				version = "0.0.4", -- very sketch about this
				url = "http://github.com/TypesettingTools/Myaamori-Aegisub-Scripts",
				feed = "https://raw.githubusercontent.com/TypesettingTools/Myaamori-Aegisub-Scripts/master/DependencyControl.json",
				optional = true,
			},
		},
	})
	parser = depctrl:requireModules()
end

local function main(sub)
	local imports = {}
	local i = 1
	
	-- using a while/repeat until loop instead of a for here, so i can fuck around with the number
	-- i do this to skip past shenanigans that've already been added without deleting them

	repeat
		local line = sub[i]
		if line.class == "dialogue" then
			if line.effect == "import" then
				local f = io.open(aegisub.decode_path(line.text), "r")
				local imported_sub = parser.parse_file(f).events
				f:close()
				
				for _, imported_line in ipairs(imported_sub) do
					if imported_line.class == "dialogue" then
						local name = imported_line.effect:match(SHENAN_PATTERN)
						if name then
							imports[name] = imports[name] or {} -- declare if not present
							table.insert(imports[name], imported_line)
						end
					end
				end
			elseif line.effect ~= "" then
			aegisub.log(5, i..": has effect: "..line.effect)
				local name = line.effect:match(SHENAN_PATTERN)
				local shenans = imports[name]
				if shenans ~= "done" then
					for idx, val in ipairs(shenans) do
						sub.insert(i + idx, val)
					end
					sub.delete(sub, i)
					i = i + #shenans - 1
					imports[name] = "done"
				elseif shenans == "done" then
					aegisub.log(5, "deleting "..line.text)
					sub.delete(sub, i)
					i = i - 1 -- the next line has now moved up 1, so we need to move up 1 as well
					-- something about 2 hard problems
				end
			end
		end
 		if i >= #sub then i = #sub end -- otherwise you can get out of range errors
		i = i + 1
	until i == #sub + 1
end

if haveDepCtrl then
	depctrl:registerMacro(main)
else
	aegisub.register_macro(script_name, script_description, main)
end
