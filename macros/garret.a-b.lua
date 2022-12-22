script_name = "A-B"
script_description = "makes checking pre-timing possible."
script_author = "garret"
script_version = "3.0.0"
script_namespace = "garret.a-b"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
if haveDepCtrl then
    depctrl = DependencyControl {
        --feed="TODO",
    }
end

local function switch_indicator(i)
    if i == "a" then
        return "b"
    elseif i == "b" then
        return "a"
    end
end

local function strip_tags(text)
    return text:gsub("{[^}]-}","")
end

local function get_indicator(letter, actor)
    local indicator
    if actor == "" then
        indicator = letter
    else
    indicator = actor.." "..letter
    end
    return indicator
end

local function main(sub, sel)
    local i = "a"
    for _,li in ipairs(sel) do
        local line = sub[li]
        local indicator = get_indicator(i, line.actor)

        if line.text == "" then
            line.text = indicator
        elseif strip_tags(line.text) == "" then
            line.text = line.text .. indicator -- apply tags
        end

        sub[li] = line
        i = switch_indicator(i)
    end
    aegisub.set_undo_point(script_name)
end

if haveDepCtrl then
    depctrl:registerMacro(main)
else
    aegisub.register_macro(script_name, script_description, main)
end
