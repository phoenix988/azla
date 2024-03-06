-- Modules where I store variables so I can easily access.
-- Values throught the app
local os = require("os")

-- Set home variable
local home = os.getenv("HOME")

-- Create empty tables
local file = {}
file.write = {}
file.config = {}

-- sets path to conf files
file.cacheFile = home .. "/.cache/azla/conf.lua"
file.cacheDir = home .. "/.cache/azla"

-- Sets path to word files
file.wordDir = "/opt/azla/lua/words"
file.wordDir_alt = home .. "/.config/azla/words"
file.wordMod = "lua.words"
file.widgetDir = "/opt/azla/lua/widgets"

-- Sets path to customConfig
file.config.custom = home .. "/.config/azla/conf.lua"
file.config.dir = home .. "/.config/azla"

-- Import some write functions
file.write.cache = require("lua.config.cache").write_cache
file.write.config = require("lua.config.write").write_config

return file
