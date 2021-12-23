script_name = "Inverse Glow"
script_description = "glow but it goes inside the letter"
script_author = "garret"
script_version = "1.0.0"
script_namespace = "garret.inverse-glow"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
local util
if haveDepCtrl then
    depctrl = DependencyControl({
        --feed="TODO",
        { "aegisub.util" },
    })
    util = depctrl:requireModules()
else
    util = require("aegisub.util")
end

local patterns = { tags_text = "(%b{})(.*)", bord = "\\bord(%d+)", dark = "\\c(&?H*%x+&?)", light = "\\3c(&?H*%x+&?)" }

local function main(subs, sel)
    for i = #sel, 1, -1 do
        local line = subs[sel[i]]
        local tags, text = line.text:match(patterns.tags_text)
        local blur = string.match(tags, patterns.bord) -- \bord = value of \blur
        local dark = tags:match(patterns.dark) -- \c = colour of dark layer
        local light = tags:match(patterns.light) -- \3c = colour of light layer

        if tags and blur and dark and light then -- skip lines that don't have everything needed
            tags = string.gsub(tags, patterns.bord, "") -- remove \bord
            tags = string.gsub(tags, patterns.dark, "") -- and both colours
            tags = string.gsub(tags, patterns.light, "")

            -- light layer
            local light_line = util.copy(line)
            light_line.layer = line.layer + 1
            local light_tags = string.gsub(tags, "}", "\\bord0\\shad0\\c" .. light .. "}") -- } (end of tag block) --> \cLightColour}
            light_line.text = light_tags .. text
            subs[sel[i]] = light_line

            local dark_line = util.copy(line)
            dark_line.layer = line.layer + 2
            local dark_tags = string.gsub(tags, "}", "\\bord0\\shad0\\c" .. dark .. "\\blur" .. blur .. "}") -- } -> \cDarkColour\blurBord}
            dark_line.text = dark_tags .. text
            subs.insert(sel[i] + 1, dark_line)
        end
    end
    aegisub.set_undo_point(script_name)
end

if haveDepCtrl then
    depctrl:registerMacro(main)
else
    aegisub.register_macro(script_name, script_description, main)
end
