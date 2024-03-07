-- Modules where I store variables so I can easily access.
-- Values throught the app
local os = require("os")

-- Set home variable
local home = os.getenv("HOME")

-- Function to load config file
local loadConfig = require("lua.loadConfig").load_config

-- Create empty tables
local file = {}
file.write = {}
file.config = {}

-- sets path to conf files
file.cacheFile = home .. "/.cache/azla/conf.lua"
file.cacheDir = home .. "/.cache/azla"

-- Sets path to customConfig
file.config.custom = home .. "/.config/azla/conf.lua"
file.config.dir = home .. "/.config/azla"

-- load config 
file.settings = loadConfig(file.config.custom)

-- Sets path to word files
file.wordDir = setting.word_path or "/opt/azla/lua/words"
file.wordDir_alt = setting.word_path_alt or home .. "/.config/azla/words"
file.wordMod = "lua.words"
file.widgetDir = "/opt/azla/lua/widgets"

-- Import some write functions
file.write.cache = require("lua.config.cache").write_cache
file.write.config = require("lua.config.write").write_config

return file
