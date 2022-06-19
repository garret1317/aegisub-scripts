script_name = "Syllable Splitter"
script_description = "splits romaji into syls of their original kana. for the lazy k-timer."
script_author = "garret"
script_version = "1.0.0"
script_namespace = "garret.sylsplitter"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
local re
if haveDepCtrl then
    depctrl = DependencyControl({
        --feed="TODO",
        { "aegisub.re" },
    })
    re = depctrl:requireModules()
else
    re = require("aegisub.re")
end

local kana = re.compile("a|i|u|e|o|ya|yu|yo|ka|ki|ku|ke|ko|kya|kyu|kyo|sa|shi|su|se|so|sha|shu|sho|ta|chi|tsu|te|to|cha|chu|cho|na|ni|nu|ne|no|nya|nyu|nyo|ha|hi|fu|he|ho|hya|hyu|hyo|ma|mi|mu|me|mo|mya|myu|myo|ra|ri|ru|re|ro|rya|ryu|ryo|ga|gi|gu|ge|go|gya|gyu|gyo|za|ji|zu|ze|zo|ja|ju|jo|da|ji|zu|de|do|ja|ju|jo|ba|bi|bu|be|bo|bya|byu|byo|pa|pi|pu|pe|po|pya|pyu|pyo|wa|wo|n|-|[a-z]") -- all kana + all letters (for small っ) (probably dont need _all_ letters but whatever)

local function round(num, numDecimalPlaces) -- https://lua-users.org/wiki/SimpleRound
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function add_tag(syl)
    -- default syl duration = (line duration / line chars) * syl chars
    local syl_dur = round(((line.end_time - line.start_time) / 10) / #line.text)
    return "{\\k"..syl_dur * #syl .. "}" ..syl
end

local function main(sub,sel)
    for i = 1, #sel do
        line = sub[sel[i]] -- yes global, i know(ish) what im doing
        line.text = kana:sub(line.text, add_tag)
        sub[sel[i]] = line
    end
end

if haveDepCtrl then
    depctrl:registerMacro("Split Syllables", script_description, main)
else
    aegisub.register_macro("Split Syllables", script_description, main)
end
