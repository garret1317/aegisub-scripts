script_name = "pos -> an"
script_description = "double click the video then snap to an \\an"
script_author = "garret"
script_version = "1"


local function escape_pattern(txt)
	local magic_chars = "%^%$%(%)%%.%[%]%*%+%-%?"
	return txt:gsub("(["..magic_chars.."])", "%%%1")
end

local function main(sub, sel)
	local vidx, vidy = aegisub.video_size()
	local left   = vidx * 0.25
	local right  = vidx - (vidx * 0.25)
	local top    = vidy * 0.32
	local bottom = vidy - (vidx * 0.35)
	-- todo: have these customisable in a gui in v2

	if not vidx then
		aegisub.log("open a video")
		aegisub.cancel()
		-- todo: might be nice to use script res for this
		-- but realistically if youre using this, youve got a video open
	end
	for _, i in ipairs(sel) do
		local line = sub[i]
		local x
		local y
		local tag
		local c = 0
		line.text = string.gsub(line.text, "\\an%d", "")
		line.text = string.gsub(line.text, "{}", "")
		for postag, posx, posy in string.gmatch(line.text, "{[^}]*(\\pos%(([^,]+), *([^)]+)%))[^}]*}") do
			if c == 0 then
				x = tonumber(posx)
				y = tonumber(posy)
				tag = escape_pattern(postag)
			end
			c = c + 1
		end
		if c == 0 then goto continue end
		-- aegi is luajit

		local s

		if y <= top then
			s = "t" elseif
			y >= bottom then s = "b"
				else s = "c" end

		if x <= left then
			s = s.."l" elseif
				x >= right then s = s.."r"
					else s = s.."c" end

		local AN_MAP = {
			tl = 7, tc = 8, tr = 9,
			cl = 4, cc = 5, cr = 6,
			bl = 1, bc = 2, br = 3,
		}

		line.text = string.gsub(line.text, tag, "\\an"..AN_MAP[s])
		sub[i] = line
		::continue::
	end
end

aegisub.register_macro(script_name, script_description, main)
