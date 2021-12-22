script_name = "Order layers"
script_description = "puts each selected line on its own layer so they don't clash"
script_author = "garret"
script_version = "1.0.0"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
if haveDepCtrl then
    depctrl = DependencyControl {
        --feed="TODO",
    }
end

local function main(sub, sel)
    local i = 0
    local last_start, last_end
    for si,li in ipairs(sel) do
        line = sub[li]
        if line.start_time == last_start or line.end_time == last_end or si == 1 then
            line.layer = i
            i = i + 1
        end
        last_start = line.start_time
        last_end = line.end_time
        sub[li] = line
    end
    aegisub.set_undo_point(script_name)
end

if haveDepCtrl then
    depctrl:registerMacro(main)
else
    aegisub.register_macro(script_name, script_description, main)
end
