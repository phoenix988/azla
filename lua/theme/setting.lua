-- Import function to check if file exist
local fileExist = require("lua.fileExist").fileExists

-- Import Variables
local file = require("lua.config.init")
local var = require("lua.config.init")

local loadConfig = require("lua.loadConfig").load_config_theme

-- Sets custom config path
local customConfig = file.config.custom

local M = {}

function M.load()
	-- check if custom file exist
	if fileExist(customConfig) then
		themeCustom = loadConfig(customConfig)
	end

	if setting ~= nil then
		settingCompare = setting
	end

	-- Default values
	local setting = {
		default_width = 1200,
		default_height = 1000,
		image = "/opt/azla/images/flag.jpg",
		word_path = "/opt/azla/lua/words",
		word_path_alt = var.wordDir_alt,
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
end

return M
