script_name="Blur Fade"
script_description="Makes fade with blur."
script_author="garret"
script_version="2021-04-06"
include("utils.lua")

-- TODO: add proper fade as well

function l(i)
    aegisub.log(i)
    aegisub.log("\n")
end -- for debugging

function make_lines(sub, sel, i, fill, bord, shad)
    local line=sub[sel[i]]
    line.effect = ""
    local text = line.text
    local fill_layer = util.copy(line) -- copy
    local bord_layer = util.copy(line) -- the
    local shad_layer = util.copy(line) -- line
    fill_layer.layer=2 -- set
    bord_layer.layer=1 -- correct
    shad_layer.layer=0 -- layers
    fill_layer.text = fill..fill_layer.text.." {fill}" -- add
    bord_layer.text = bord..bord_layer.text.." {bord}" -- the
    shad_layer.text = shad..shad_layer.text.." {shad}" -- tags
    sub[sel[i]] = fill_layer        -- put
    sub.insert(sel[i]+1,bord_layer) -- in
    sub.insert(sel[i]+2,shad_layer) -- script
end

function main(sub, sel) -- TODO: make code less shit
    for i=#sel,1,-1 do
		local line=sub[sel[i]]
        if line.effect == "blurin" then
         -- make_lines(sub, sel, i, "in fill ", "in bord ", "in shad ")
            make_lines(sub, sel, i, "{\\blur100\\bord0\\shad0\\t(\\blur0)}", "{\\blur100\\t(\\blur0)\\1a&FF&\\3a&FF&\\shad0.01}", "{\\blur100\\shad1.5\\1aFF\\bord0\\t(\\blur0)}")
        elseif line.effect == "blurout" then
         -- make_lines(sub, sel, i, "out fill ", "out bord ", "out shad ")
            make_lines(sub, sel, i, "{\\bord0\\shad0\\t(\\blur100)}", "{\\t(\\blur100)\\1a&FF&\\3a&FF&\\shad0.01}", "{\\shad1.5\\1aFF\\bord0\\t(\\blur100)}")
        end
    end
	aegisub.set_undo_point(script_name)
end
aegisub.register_macro(script_name, script_description, main)
