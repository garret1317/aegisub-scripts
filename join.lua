script_name = "Join hotkey"
script_description = ""
script_author = "garret1317"
script_version = "1"


local function main(sub, sel)
	for i=#sel,1,-1 do
		local line = sub[sel[i]]
		local prevline = sub[sel[i] -1]

		line.start_time = prevline.start_time
		line.text = prevline.text .. " ".. line.text

		sub[sel[i]] = line
		sub.delete(sel[i]-1)

		sel[i] = sel[i]-1
	end
	return sel, act
end

aegisub.register_macro(script_name, script_description, main)
