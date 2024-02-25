script_name = "song timer"
script_description = "time songs while vibin"
script_author = "garret"
script_version = "1"

local function main(sub, sel, act)

	local READY = "READY"
	local START = "START"
	local END = "END"

	local pos = aegisub.project_properties()['video_position']
	local ms = aegisub.ms_from_frame(pos)
	local newline = sub[act]
	newline.effect = READY
	newline.text = ""
	local nextline = newline

	local line = sub[act]
	local endline = #sub

	if line.effect == READY then
		line.start_time = ms
		line.effect = START
		sub[act] = line
	elseif line.effect == START then
		line.end_time = ms
		line.effect = END
		sub[act] = line
		sub.append(nextline)
		return {endline+1},endline+1
	else
		sub.append(nextline)
		return {endline+1},endline+1
	end
end

aegisub.register_macro(script_name, script_description, main)
