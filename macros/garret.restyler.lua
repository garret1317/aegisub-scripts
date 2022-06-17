script_name="Restyler"
script_description="become a fansubber with a click of a button"
script_author = "garret"
script_version = "2.1.0"
script_namespace = "garret.restyler"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
local karaskel, cleantags
if haveDepCtrl then
    depctrl = DependencyControl {
        --feed="TODO",
        {"karaskel", "cleantags"}
    }
    kara, clean = depctrl:requireModules()
else
    include("karaskel.lua")
    include("cleantags.lua")
end

-- local config = simpleconf.get_config(aegisub.decode_path(config_dir.."/"..script_namespace..".conf"), {new_style = "Default"})

-- TODO: detect pre-existing inline tags
    -- probably need some kind of ass parsing, or a hack with match()

function add_tags(txt, italic, align) -- everything except txt is boolean. nil = don't change, !nil = change to this value

--[[not quite happy with this, it overwrites the alignment - ie line is "{\an4} blah blah" and style is an8, it just changes it to an8
realisticly this _probably_ won't be a problem, but still would like to try and stop it at some point to be safe
italics is fine, it just does {\i1\i0}, which is jank and bad but works fine so i won't worry about it too much]]
    if italic == true then
        txt="{\\i1}"..txt
    elseif italics == false then
        txt="{\\i0}"..txt
    end
    if align ~= nil then
        txt="{\\an"..align.."}"..txt
    end
    txt = cleantags(txt)
    return txt
end

function get_new(old, new)
    local i = nil
    if old ~= new then
        i = old
    end
    return i
end

function main(sub, sel)
    local _, styles = karaskel.collect_head(sub, false)
    local config.new_style = "Default"
    local new_style = styles[config.new_style]
	for h, i in ipairs(sel) do
        -- TODO: automatically exclude styles (also configurable)
		local line = sub[i]
        local old_style = styles[line.style] -- reinventing the wheel a bit here, since karaskel can do this with preproc_line_size (line.styleref), but it also adds loads of other crap we don't care about for the same functionality in the end, so ¯\_(ツ)_/¯
        local italic = get_new(old_style.italic, new_style.italic)
        local align = get_new(old_style.align, new_style.align)
        line.style = config.new_style
        line.text = add_tags(line.text, italic, align)
		sub[i] = line
	end
	aegisub.set_undo_point(script_name)
end

if haveDepCtrl then
    depctrl:registerMacro(main)
else
    aegisub.register_macro(script_name, script_description, main)
end
