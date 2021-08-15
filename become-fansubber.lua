script_name="CR Restyler"
script_description="become a fansubber with a click of a button"
script_author = "garret"
script_version = "2.0.0-dev"

include("karaskel.lua")
include("cleantags.lua")

-- TODO: detect already existing tags
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
    local _, styles = karaskel.collect_head(sub) -- i'd like to not have it log if possible
    local new_style_name = "Default" -- the one we'll be changing stuff to - TODO: configurable
    local new_style = styles[new_style_name]
	for h, i in ipairs(sel) do
        -- maybe don't do if the style has "sign" in the name?
            -- need proper list of stuff cr uses
		local line = sub[i]
        local old_style = styles[line.style]
        local italic = get_new(old_style.italic, new_style.italic)
        local align = get_new(old_style.align, new_style.align)
        line.style = new_style_name
        line.text = add_tags(line.text, italic, align)
		sub[i] = line
	end
	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, main)
