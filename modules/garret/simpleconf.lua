-- primitive config handler

local function tobool(value)
	if value == "true" then
		return true
	elseif value == "false" then
		return false
    else
        return nil
	end
end

local function cast(value)
	return tonumber(value) or tobool(value) or value
end

local function get_config(config_file, defaults)
	local conf = defaults or {}
    local ok, lines = pcall(io.lines, config_file)
    if ok then
	    for line in lines do
		    local key, value = string.match(line, "(%a+)%s*=%s*(.+)")
		    conf[key] = cast(value)
	    end
    end
	return conf
end

local simpleconf = {get_config = get_config}


local have_depctrl, depctrl = pcall(require, "l0.DependencyControl")

if have_depctrl then
    local version = depctrl{
    name = "Simple (bad) Config",
    version = "0.1.0",
    description = "primitive config handler",
    author = "garret",
    url = "http://github.com/garret1317/aegisub-scripts",
    moduleName = "garret.simpleconf"}
    simpleconf.version = version
    return version:register(simpleconf)
else
    return simpleconf
end
