script_name = "faderer"
script_description = ""
script_author = "garret"
script_version = "1"

include("karaskel.lua")
include("utils.lua")


local function exact_ms_from_frame(frame)
--[[
MIT License

Copyright (c) 2022 arch1t3cht

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
  frame = frame + 1
  local ms = aegisub.ms_from_frame(frame)
  while true do
    local new_ms = ms - 1
    if new_ms < 0 or aegisub.frame_from_ms(new_ms) ~= frame then
      break
    end
    ms = new_ms
  end
  return ms - 1
end

local function start_offset(pos, start_time)
	if aegisub.decode_path("?video") ~= "?video" then
		pos = exact_ms_from_frame(pos) else pos = aegisub.ms_from_frame(pos)
	end
	return pos - start_time
end


local function main(sub, sel, act)

	local line = sub[act]
	local pos = aegisub.project_properties().video_position

	if string.find(line.effect, "t1:") then
		local but, res = aegisub.dialog.display({
			{class="dropdown", items={"Black", "White", "Alpha"}, value="Black", name="c"},
		})

		local t1
		local t2
		local c = res.c
		local c_tags_out = {
			Black = "\\c&H000000&\\3c&H000000&\\4c&H000000&",
			White = "\\c&HFFFFFF&\\3c&HFFFFFF&\\4c&HFFFFFF&",
			Alpha = "\\alpha&HFF&",
		}

		local fx_pattern = "t1:(%d+);"
		t1 = string.match(line.effect, fx_pattern)
		t2 = pos

		t1 = start_offset(t1, line.start_time)
		t2 = start_offset(t2, line.start_time)

		local line_length = line.end_time - line.start_time

		if t1 < 0 then line.start_time = line.start_time + t1; t1 = 0 end
		line_length = line.end_time - line.start_time
		if t2 > line_length then line.end_time = line.start_time + t2 end
		line_length = line.end_time - line.start_time
		local half_length = line_length / 2

		local additional_tags = ""

		if t1 == 0 or t2 < half_length then
			if not string.match(line.text, "\\t") then
				additional_tags = c_tags_out[c]
			end
			c = ""

			local meta
			local styles
			meta, styles = karaskel.collect_head(sub, false)
			local sty = styles[line.style]

			for i,v in ipairs({"1","3","4"}) do
				local style_colour = sty["color"..v]
				c = c .. "\\"; if v ~= "1" then c = c .. v end
				c = c .. "c".. util.color_from_style(style_colour)
				c = c .. "\\"; if v ~= "1" then c = c .. v end
				c = c .. "a" .. util.alpha_from_style(style_colour)
			end
		elseif t2 > half_length then
			c = c_tags_out[c]
		end

		line.effect = string.gsub(line.effect, ";?"..fx_pattern, "")
		local tags = additional_tags.."\\t("..t1..","..t2..","..c..")}"
		local old_text = line.text
		line.text = string.gsub(line.text, "}", tags, 1)
		if old_text == line.text then line.text = "{"..tags .. line.text end
	else
		if line.effect ~= "" then line.effect = line.effect .. ";" end
		line.effect = line.effect .. "t1:" .. pos .. ";"
	end
	sub[act] = line
end

aegisub.register_macro(script_name, script_description, main)
