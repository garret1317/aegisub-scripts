script_name="DepCtrl Global Config"
script_description="the future is now"
script_author = "garret"
script_version = "1.3.1"
script_namespace = "garret.depctrl_config"

local DependencyControl = require("l0.DependencyControl")
local depctrl = DependencyControl {}

local function get_bool(field, default) -- can't just do `field or default`, because the default might be true when field is false
    if field == nil then
        return default
    else
        return field
    end
end

local function get_log_level(num)
    if num == 0 then return "0: Fatal"
    elseif num == 1 then return "1: Error"
    elseif num == 2 then return "2: Warning"
    elseif num == 3 then return "3: Hint"
    elseif num == 4 then return "4: Debug"
    elseif num == 5 then return "5: Trace" end
    return nil
end

local function seconds_to_human(seconds)
    -- adapted from https://stackoverflow.com/a/8211778
    local years = math.floor(seconds / 31536000)
    local days = math.floor((seconds % 31536000) / 86400)
    local hours = math.floor(((seconds % 31536000) % 86400) / 3600)
    local minutes = math.floor((((seconds % 31536000) % 86400) % 3600) / 60)
    seconds = (((seconds % 31536000) % 86400) % 3600) % 60
    --return years, days, hours, minutes, seconds
    local timestamp = ""
    if years ~= 0 then timestamp = timestamp..years.."y" end
    if days ~= 0 then timestamp = timestamp..days.."d" end
    if hours ~= 0 then timestamp = timestamp..hours.."h" end
    if minutes ~= 0 then timestamp = timestamp..minutes.."m" end
    if seconds ~= 0 then timestamp = timestamp..seconds.."s" end
    return timestamp
end

local function human_to_seconds(human)
    -- im sure this is hideously inefficient
    local years = (tonumber(human:match("(%d*)y")) or 0) * 31536000
    local days = (tonumber(human:match("(%d*)d")) or 0) * 86400
    local hours = (tonumber(human:match("(%d*)h")) or 0) * 3600
    local minutes = (tonumber(human:match("(%d*)m")) or 0) * 60
    local seconds = (tonumber(human:match("(%d*)s")) or 0)
    local res = years + days + hours + minutes + seconds
    return res
end

local function get_human_filesize(bytes)
    -- TODO
    return bytes
end

local function get_config(config)
    local defaults = DependencyControl.config.defaults
    local dialog = {
        {   class="checkbox", name="updaterEnabled",
            x=0,y=0,width=2,height=1,
            label = "Enable Auto-updater",
            value=get_bool(config.updaterEnabled, defaults.updaterEnabled),
        },
        {   class="label", label="Update interval:",
            x=0,y=1,width=1,height=1,
        },
        {   class="edit", name = "updateInterval",
            x=1,y=1,width=1,height=1,
            value = seconds_to_human(config.updateInterval or defaults.updateInterval)
        },
        {   class="label", label="Log Level:",
            x=0,y=2,width=1,height=1,
        },
        {   class="dropdown", name="traceLevel",
            x=1,y=2,width=1,height=1,
            items={"0: Fatal", "1: Error", "2: Warning", "3: Hint", "4: Debug", "5: Trace"},
            value=get_log_level(config.traceLevel) or "3: Hint",
        },
        {   class="checkbox", name="dumpFeeds",
            x=0,y=3,width=2,height=1,
            label = "Dump updater feeds to your Aegsiub folder (debug)",
            value=get_bool(config.dumpFeeds, defaults.dumpFeeds)
        },
        {   class="checkbox", name="tryAllFeeds",
            x=0,y=4,width=2,height=1,
            label = "Check all available feeds for an update",
            value=get_bool(config.tryAllFeeds, defaults.tryAllFeeds)
        },
        {   class="label", label="Config directory to offer automation scripts:",
            x=0,y=5,width=1,height=1
        },
        {   class="edit", name="configDir",
            text=config.configDir or defaults.configDir,
            x=1,y=5,width=1,height=1
        },
        {   class="checkbox", name="writeLogs",
            x=0,y=6,width=1,height=1,
            label = "Write log messages to:",
            value=get_bool(config.writeLogs, true)
        },
        {   class="edit", name="logDir",
            text=config.logDir or defaults.logDir,
            x=1,y=6,width=1,height=1
        },
        {   class="label", label= "?user means " .. aegisub.decode_path("?user"),
            x=1,y=7,width=2,height=1
        },
        {   class="label", label="Purge old updater log files when:",
            x=0,y=8,width=2,height=1
        },
        {   class="label", label="File count reaches:",
            x=0,y=9,width=1,height=1
        },
        {   class="intedit", name="logMaxFiles",
            x=1,y=9,width=1,height=1,
            value = config.logMaxFiles or defaults.logMaxFiles
        },
        {   class="label", label="File age reaches:",
            x=0,y=10,width=1,height=1,
        },
        {   class="edit", name="logMaxAge",
            x=1,y=10,width=1,height=1,
            value = seconds_to_human(config.logMaxAge or defaults.logMaxAge)
        },
        {   class="label", label="Cumulative file size (in bytes) reaches:",
            x=0,y=11,width=1,height=1,
        },
        {   class="intedit", name="logMaxSize",
            x=1,y=11,width=1,height=1,
            --value = get_human_filesize(config.logMaxSize or 10*(10^6))
            value = config.logMaxSize or defaults.logMaxSize
        },
    }
    local pressed, res = aegisub.dialog.display(dialog, {"Cancel", "Reset", "OK"})
    if pressed == "Cancel" then
        aegisub.cancel()
    elseif pressed == "Reset" then
        return {}
    end
    res.traceLevel = tonumber(res.traceLevel:sub(1, 1))
    res.updateInterval = human_to_seconds(res.updateInterval)
    res.logMaxAge = human_to_seconds(res.logMaxAge)
    res.extraFeeds = config.extraFeeds
    return res
end

local function split_by_newline(list)
    local strs = {}
    for i in list:gmatch("[^\n]+") do
        table.insert(strs, i)
    end
    return strs
end

local function get_feeds(config)
    local extraFeeds = config.extraFeeds or {}

    local feed_edit_string = table.concat(extraFeeds, "\n") or ""

    local dialog = {
        {   class="label",
            x=0,y=0,width=1,height=1,
            label = "Extra Feeds:",
        },
        {   class="textbox", name = "feeds",
            x=0,y=1,width=20,height=15,
            text = feed_edit_string
        },
    }

    local pressed, res = aegisub.dialog.display(dialog)
    if not pressed then aegisub.cancel() end

    config.extraFeeds = split_by_newline(res.feeds)
    return config
end

local function write_config(new)
    for k, v in pairs(new) do
        if (v == nil) -- allow nil, so the reset to defaults button works
        or v ~= get_bool(DependencyControl.config.c[k], DependencyControl.config.defaults[k]) -- check it's not the current value anyway
        then
            -- changed, save
            DependencyControl.config.c[k] = v
        end
    end
    DependencyControl.config:write(true)
    aegisub.log(3, "Done. You'll need to rescan your automation directory or restart aegisub for the changes to take effect.")
end

local function change_config(modifier) -- i think i might be thinning out the soup a bit too much
    DependencyControl.config:load()
    local new_config = modifier(DependencyControl.config.c)
    write_config(new_config)
end

local function global_config()
    change_config(get_config)
end

local function extra_feeds()
    change_config(get_feeds)
end

depctrl:registerMacro("DependencyControl/Global Configuration", "Lets you change DependencyControl settings.", global_config)
depctrl:registerMacro("DependencyControl/Extra Feeds", "Lets you provide additional update feeds.", extra_feeds)
