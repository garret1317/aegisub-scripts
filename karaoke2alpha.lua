script_name="K-Timing -> Alpha Timing"
script_description="makes doing alpha timing significantly easier by getting rid of the part where you do alpha timing."
script_author = "garret"
script_version = "1.0.1"
include("utils.lua")

-- logging stuff, for testing
--[[inspect = require 'inspect' -- luarocks install inspect
function log(level, msg)
    if type(level) ~= "number" then -- if no actual level provided
        msg = level -- set the non-level as the message
        level = 4 -- set log level - i'm using this for debugging, so 4 is relatively sane imo
    end
    if type(msg) == "table" then
        msg = inspect(msg) -- actually see what's in the table
    end
    aegisub.log(level, tostring(msg) .. "\n")
end]]
-- i should really put this stuff in a separate file or something but cba

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
    for x=#sel,1,-1 do
        local line=sub[sel[x]]
        local parsed = aegisub.parse_karaoke_data(line) -- magic function that gets all the stuff about the karaoke
        for i=1,#parsed do -- for every syl in the karaoke
            visible = get_visible(parsed, i)
            invisible = get_invisible(parsed, i)
            if invisible ~= "" then -- if there's still invisible stuff left
                text = visible.."{\\alpha&HFF&}"..invisible -- add an alpha tag and slap the invisible stuff on the end
            else -- if it's all visible
                text = visible -- don't need the alpha any more
            end
            local syl = parsed[i]
            local new = util.copy(line)
            new.text = text -- make a new line for this syl
            -- set line start time
            new.start_time = syl.start_time + line.start_time -- just the syl on its own returns the offset from the line
            -- set line end time
            if i ~= #parsed then -- if there's still invisible stuff left
                new.end_time = syl.end_time + line.start_time -- end time is the syl's
            else
                new.end_time = line.end_time -- end time is the whole line's (i don't think this actually makes a difference but may as well)
            end
            sub.insert(sel[x] + i,new) -- add new lines (+1 line for first syl, +2 for 2nd syl, etc)
        end
        line.comment = true -- don't want to see the karaoke any more
        sub[sel[x]]=line
    end
    aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, main)
