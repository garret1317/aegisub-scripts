script_name="K-Timing -> Alpha Timing"
script_description="does what it says on the tin.\noriginally to convert stuff that should've been alpha-timed in the first place, but could also make new alpha-timing easier"
script_author = "garret"
script_version = "2021-07-10"
include("utils.lua")

-- logging stuff, for testing
--[[inspect = require 'inspect'
function log(level, msg)
    if type(level) ~= "number" then
        level = msg
        level = 4
    end
    if type(msg) == "table" then
        msg = inspect(msg)
    end
    aegisub.log(level, tostring(msg) .. "\n")
end]]

function get_visible(parsed_line, index)
    local res = ""
    for i=1,index do -- for every syl up to the current one
        res = res..parsed_line[i].text -- add to the result
    end
    return res
end

function get_invisible(parsed_line, index)
    local res = ""
    for i=index+1,#parsed_line do -- for every syl from the next one to the end
        res = res..parsed_line[i].text -- add to result
    end
    return res
end

function main(sub, sel)
    for i=#sel,1,-1 do
        local line=sub[sel[i]]
        local parsed = aegisub.parse_karaoke_data(line)
        for j=1,#parsed do
            visible = get_visible(parsed, j)
            invisible = get_invisible(parsed, j)
            if invisible ~= nil then
                text = visible.."{\\alpha&HFF&}"..invisible
            else
                text = visible
            end
            local syl = parsed[j]
            local new = util.copy(line)
            new.text = text
            new.start_time = syl.start_time + line.start_time -- just the syl on its own returns the offset from the line
            if j ~= #parsed then
                new.end_time = syl.end_time + line.start_time
            else
                new.end_time = line.end_time
            end
            sub.insert(sel[i]+j,new) -- 1 line after for first syl, 2 for 2nd syl, etc
        end
        line.comment = true
        sub[sel[i]]=line
    end
    aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, main)
