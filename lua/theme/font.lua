-- Module to control the theming of the app
local os = require("os")

-- Import function to check if a file exist
local fileExist = require("lua.fileExist").fileExists

local loadConfig = require("lua.loadConfig").load_config_theme

-- Import Variables
local file = require("lua.config.init")

-- Import some widgets we need
local array = require("lua.widgets.setting")

-- Sets custom config path
local customConfig = file.config.custom

local M = {}

-- Sets default theme values to load so you can reset
M.font_default = {
    word_size = "16000",
    word_list_size = "16000",
    lang_size = "18000",
    fg_size = "16000",
    welcome_size = "30000",
    question_size = "22000",
    entry_size = "26000",
}

function M.load()
    -- check if custom file exist
    if fileExist(customConfig) then
        fontCustom = loadConfig(customConfig)
    end

    if font ~= nil then
        fontCompare = font
    end

    -- Sets default theme values
    local font = {
        word_size = "16000",
        word_list_size = "16000",
        lang_size = "18000",
        fg_size = "16000",
        welcome_size = "30000",
        question_size = "22000",
        entry_size = "26000",
    }

    -- Overwrites config if you have a custom one
    if fontCompare ~= nil then
        for key, value in pairs(font) do
            if fontCompare[key] ~= nil then
                font[key] = fontCompare[key]
            end
        end
    end

    return font
end

return M
