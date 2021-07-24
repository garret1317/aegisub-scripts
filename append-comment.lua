script_name = "Append Comment"
script_description = "{ts do all the work pls kthxbye}"
script_author = "garret"
script_version = "1.1.0"

inspect = require 'inspect'
function log(level, msg)
    if type(level) ~= "number" then
        msg = level
        level = 4
    end
    if type(msg) == "table" then
        msg = inspect(msg)
    end
    aegisub.log(level, tostring(msg).."\n")
end

function clean(msg)
msg = msg:gsub("\n","\\N")
end

function main(sub, sel)
    dialog_config=
    {
        {
            class="label",
            x=0,y=0,width=1,height=1,
            label="Comment:"
        },
        {
            class="edit",name="msg",
            x=0,y=1,width=1,height=2,
            value=""
        }
    }
    button, results = aegisub.dialog.display(dialog_config)
    if button ~= false then
        msg = results.msg
        for _, i in ipairs(sel) do
            local line = sub[i]
            line.text = line.text.." {"..msg.."}"
            sub[i] = line
        end
    else
        aegisub.cancel()
    end
end

aegisub.register_macro(script_name, script_description, main)
