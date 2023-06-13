-- Module to control the theming of the app
local os        = require("os")

local fileExistModule = require("lua.fileExist")
local fileExist = fileExistModule.fileExists

local loadConfigModule = require("lua.loadConfig")
local loadConfig = loadConfigModule.load_config_theme

local home      = os.getenv("HOME")
local customConfig = home .. "/.config/azla.lua"

-- check if custom file exist
if fileExist(customConfig) then

  themeCustom = loadConfig(customConfig)
   
end

if setting ~= nil then
   settingCompare = setting 
end


local setting = {
     default_width = 600,
     default_height = 800,
}

-- Overwrites config if you have a custom one
if settingCompare ~= nil then
  for key, value in pairs(setting) do
    if settingCompare[key] ~= nil then
        setting[key] = settingCompare[key]
     end
  end
end

return setting
