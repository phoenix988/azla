-- Module to control the theming of the app
local os               = require("os")

local fileExistModule  = require("lua.fileExist")
local fileExist        = fileExistModule.fileExists

local loadConfigModule = require("lua.loadConfig")
local loadConfig       = loadConfigModule.load_config_theme

local home             = os.getenv("HOME")
local customConfig     = home .. "/.config/azla/conf.lua"

-- check if custom file exist
if fileExist(customConfig) then

  themeCustom = loadConfig(customConfig)
   
end

if theme ~= nil then
   themeCompare = theme 
end


local theme = {
   label_welcome        = '#84a0c6',
   label_lang           = '#89b8c2',
   label_word           = '#89b8c2',
   label_question       = '#89b8c2',
   label_correct        = '#b4be82',
   label_incorrect      = '#e27878',
   label_fg             = '#d8dee9',
   label_word_size      = '12000',
   label_lang_size      = '14000',
   label_fg_size        = '14000',
   label_welcome_size   = '20000',
   label_question_size  = '20000',
   main_image           = "/opt/azla/images/flag.jpg"
}

-- Overwrites config if you have a custom one
if themeCompare ~= nil then
  for key, value in pairs(theme) do
    if themeCompare[key] ~= nil then
        theme[key] = themeCompare[key]
     end
  end
end

return theme
