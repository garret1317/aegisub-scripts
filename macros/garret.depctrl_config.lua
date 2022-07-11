script_name="DepCtrl Global Config"
script_description="the future is now"
script_author = "garret"
script_version = "1.0.0"
script_namespace = "garret.depctrl_config"

local DependencyControl = require("l0.DependencyControl")
local depctrl = DependencyControl {
    --feed="TODO",
    {"json"}
}
local json = depctrl:requireModules()

local inspect = require 'inspect'

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
    local seconds = (((seconds % 31536000) % 86400) % 3600) % 60
    --return years, days, hours, minutes, seconds
    local timestamp = ""
    if years ~= 0 then timestamp = timestamp..years.."y" end
    if days ~= 0 then timestamp = timestamp..days.."d" end
    if hours ~= 0 then timestamp = timestamp..hours.."h" end
    if minutes ~= 0 then timestamp = timestamp..minutes.."m" end
    if seconds ~= 0 then timestamp = timestamp..seconds.."s" end
    return timestamp
end

function human_to_seconds(human)
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

local defaults = {updaterEnabled = true, updateInterval = 302400, traceLevel = 3, extraFeeds = { }, tryAllFeeds = false, dumpFeeds = true, configDir = "?user/config", logMaxFiles = 200, logMaxAge = 604800, logMaxSize = 10 * (10 ^ 6), updateWaitTimeout = 60, updateOrphanTimeout = 600, logDir = "?user/log", writeLogs = true}

local function get_config(data)
    local config = data.config
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
    pressed, res = aegisub.dialog.display(dialog)
    if pressed == false then
        aegisub.cancel()
    end
    res.traceLevel = tonumber(res.traceLevel:match("^(%d)"))
    res.updateInterval = human_to_seconds(res.updateInterval)
    res.logMaxAge = human_to_seconds(res.logMaxAge)
    return res
end

local function main()
    local data_path = depctrl:getConfigFileName()
    data_path = data_path:gsub(script_namespace, "l0.DependencyControl")
    aegisub.log(4, "config file: "..data_path.."\n")

    data_file = io.open(data_path, "r+")
    data = json.decode(data_file:read())

    data.config = get_config(data)

    data_str = json.encode(data)
    data_file:write(data_str)
    data_file:close()
    aegisub.log(3, "Done. You'll need to rescan your automation directory, or restart aegisub, for the changes to take effect.")
end

depctrl:registerMacro("DependencyControl/Global Configuration", "Lets you change DepedencyControl settings.", main)
