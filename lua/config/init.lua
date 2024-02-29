-- Modules where I store variables so I can easily access.
-- Values throught the app
local os = require("os")

local home = os.getenv("HOME")

local file = {}
file.write = {}
file.config = {}

-- sets path to conf files
file.cacheFile = home .. "/.cache/azla/conf.lua"
file.cacheDir = home .. "/.cache/azla"

-- Sets path to customConfig
file.config.custom = home .. "/.config/azla/conf.lua"
file.config.dir = home .. "/.config/azla"

-- Sets path to word files
file.word_dir = "/opt/azla/lua/words"
file.widget_dir = "/opt/azla/lua/widgets"

-- Import some write functions
file.write.cache = require("lua.config.cache").write_cache
file.write.config = require("lua.config.write").write

return file
