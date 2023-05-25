local io      = require("io")

function load_config(filename)
    local config = {}
    local file = io.open(filename, "r")

    if file then
        local content = file:read("*all")
        file:close()
        config = assert(load(content))() or {}
    end

    return config
end

function load_config_custom(filename)
    local custom = {}
    local file = io.open(filename, "r")

    if file then
        local content = file:read("*all")
        file:close()
        custom = assert(load(content))() or {}
    end

    return custom
end



return {
        load_config = load_config,
        load_config_custom = load_config_custom
        }
