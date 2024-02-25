script_name = "Timings copier"
script_description = "for copying song timings"
script_version = "1.0.0"
script_author = "garret"
script_namespace = "garret.timings_copier"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
if haveDepCtrl then
    depctrl = DependencyControl {}
end

local function get_blocks(sub, sel)
    local src_style = sub[sel[1]].style
    local src_len = 1
    for i = 2, #sel do
        if sub[sel[i]].style == src_style then
            src_len = src_len + 1
        else
            break
        end
    end
    local blocks = #sel / src_len
    if blocks % 1 ~= 0 then
        aegisub.log(0, "FATAL: Block lengths are not equal!\n")
        aegisub.log(3, "HINT: Each \"block\" of lines must be the same length, e.g. you can't have less romaji than english, or vice versa. a block is a group of consecutive lines with the same style.")
        aegisub.cancel()
    else
        return src_len, blocks
    end
end

local function copy(sub, sel, offset, blocks)
    for index = 1, offset do
        line = sub[sel[index]]
        for mul = 1, blocks - 1 do
            block_line = sub[sel[offset * mul + index]]
            block_line.start_time = line.start_time
            block_line.end_time = line.end_time
            sub[sel[offset * mul + index]] = block_line
        end
    end
end

local function main(sub, sel)
    offset, blocks = get_blocks(sub, sel)
    copy(sub, sel, offset, blocks)
    aegisub.set_undo_point(script_name)
end

if haveDepCtrl then
    depctrl:registerMacro(main)
else
    aegisub.register_macro(script_name, script_description, main)
end
