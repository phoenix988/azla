local os            = require("os")

local home          = os.getenv("HOME")

local file          = {}

-- sets path to conf files
file.cacheFile      = home .. "/.cache/azla/conf.lua"
file.cacheDir       = home .. "/.cache/azla"

-- Sets path to customConfig
file.customConfig   = home .. "/.config/azla/conf.lua"
file.confDir        = home .. "/.config/azla"

return file


