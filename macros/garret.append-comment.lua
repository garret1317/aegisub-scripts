script_name = "Append Comment"
script_description = "{ts do all the work pls kthxbye}"
script_author = "garret"
script_version = "1.2.0"
script_namespace = "garret.append-comment"

local haveDepCtrl, DependencyControl, depctrl = pcall(require, "l0.DependencyControl")
if haveDepCtrl then
    depctrl = DependencyControl {
        --feed="TODO",
    }
end

local function main(sub, sel)
    dialog_config=
    {
        {
            class="label",
            x=0,y=0,width=1,height=1,
            label="Comment:"
        },
        {
            class="edit",name="msg",
            x=0,y=1,width=3,height=2,
            value=""
        }
    }
    if #sel == 1 then
        table.insert(dialog_config, {class="label",x=0,y=3,width=1,height=1,label="if you're not using this for multiple lines \nyou may as well just type it out yourself"})
    end
    button, results = aegisub.dialog.display(dialog_config)
    if button ~= false then
        for _, i in ipairs(sel) do
            local line = sub[i]
            line.text = line.text.." {"..results.msg.."}"
            sub[i] = line
        end
    else
        aegisub.cancel()
    end
end

if haveDepCtrl then
    depctrl:registerMacro(main)
else
    aegisub.register_macro(script_name, script_description, main)
end
