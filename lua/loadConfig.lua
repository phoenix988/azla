local io      = require("io")

-- Function to load the configuration file
local function load_config(filename)
    local config = {}
    local file = io.open(filename, "r")

    if file then
        local content = file:read("*all")
        file:close()
        config = assert(load(content))() or {}
    end

    return config
end

-- Function to load the custom configuration file
local function load_config_custom(filename)
    local custom = {}
    local file = io.open(filename, "r")

    if file then
        local content = file:read("*all")
        file:close()
        custom = assert(load(content))() or {}
    end

    return custom
end

local function load_config_theme(filename)
    local theme = {}
    local file = io.open(filename, "r")

    if file then
        local content = file:read("*all")
        file:close()
        theme = assert(load(content))() or {}
    end

    return theme
end



return {
        load_config = load_config,
        load_config_custom = load_config_custom,
        load_config_theme  = load_config_theme
        }
