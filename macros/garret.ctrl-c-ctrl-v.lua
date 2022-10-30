script_name = "Consistency Assistant"
script_description = "ctrl-c ctrl-v and now ctrl-o"
script_version = "1.2.0"
script_author = "garret"
script_namespace = "garret.ctrl-c-ctrl-v"

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

--inspect = require "inspect"

-- it looks more complicated than it is because of all the aegisub.log()s
local function main(sub, is_recursion)
	local clipboard = {}
	for i = 1, #sub do
		local line = sub[i]
		if line.class == "dialogue" then
			local op, name = line.effect:match("ctrl%-([cvo]) ?([%S]*)")
			if op == "o" and parser ~= "nil" then -- o = open. check for parser or it wont work
				clipboard["__imports"] = clipboard["__imports"] or {} -- declare field
				clipboard["__imports"][name] = import(line.text)
			elseif line.comment ~= true then
				if op == "c" then
					aegisub.log(5, 5, "ctrl-c " .. name .. ": " .. line.text .. "\n")
					clipboard[name] = clipboard[name] or {}
					table.insert(clipboard[name], line)
				elseif op == "v" and is_recursion ~= true then -- don't want to affect the imported files (useless)
				-- have to specifically check ~= true because normally it'd be sel, which is a table of numbers (not nil/false)
					local file, slash, capture = name:match("([^%s/]+)(/?)([%S]*)") -- match filename/capture
					local clippings													-- names = anything not a space or a /
					aegisub.log(5, file.."/"..capture.."\n")
					aegisub.log(5, "slash: "..slash.."\n")
					if slash ~= "" and parser ~= nil then
						clippings = clipboard["__imports"][file][capture]
						aegisub.log(5, "clippings = clipboard[\"__imports\"][\""..file.."\"][\""..capture.."\"]\n")
					else
						clippings = clipboard[file] or {line} -- error handling if the clipboard doesnt exist or parser isnt there
						aegisub.log(5, "clippings = clipboard[\""..file.."\"]\n")
					end
					aegisub.log(5, "ctrl-v " .. name .. ": " .. line.text .. "\n")
--					aegisub.log(5, inspect(clippings).."\n")
					line.text = clippings[1].text
					sub[i] = line
					table.remove(clippings, 1)
				end
			end
		end
	aegisub.progress.set(i / #sub * 100)
	end
--	aegisub.log(5, inspect(clipboard).."\n")
	return clipboard
end

function import(path)
--local function import(path)
	if parser then
		aegisub.log(5, "recursing\n")
		local f = io.open(aegisub.decode_path(path), "r")
		local sub = parser.parse_file(f).events
		f:close()
		local clipboard = main(sub, true)
		aegisub.log(5, "recursion complete\n")
		return clipboard
	else
		aegisub.log(1, "You don't appear to have myaa.ASSParser, which is required for including other files.\n")
		aegisub.log(1, "The script will continue, but any includes you've specified won't work.\n")
		return {}
	end
end

if haveDepCtrl then
	depctrl:registerMacro(main)
else
	aegisub.register_macro(script_name, script_description, main)
end
