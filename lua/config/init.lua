-- Modules where I store variables so I can easily access.
-- Values throught the app
local os            = require("os")

local home          = os.getenv("HOME")

local file          = {}

-- sets path to conf files
file.cacheFile      = home .. "/.cache/azla/conf.lua"
file.cacheDir       = home .. "/.cache/azla"

-- Sets path to customConfig
file.customConfig   = home .. "/.config/azla/conf.lua"
file.confDir        = home .. "/.config/azla"

-- Sets path to word files
file.word_dir       = "/opt/azla/lua/words"
file.widget_dir     = "/opt/azla/lua/widgets"

return file


