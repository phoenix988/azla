local io = require("io")
local load_config_custom = require("lua.loadConfig").load_config_custom

-- Create empty table
local M = {}

-- Function to set the window size
function M.window_size(customConfig, setting, config, fileExist)
	-- Gets the width and height to set on the window
	-- You can configure this in a config file
	if fileExist(customConfig) then
		-- Prints error if you dont name the variable custom inside the setting file
		if setting == nil then
			print("Error in config")
			os.exit()
		end
	end

	if setting.default_height ~= nil then
		config.default_height = setting.default_height
	elseif config.default_height ~= nil then
		config.default_height = config.default_height
	else
		config.default_height = 800
	end

	if setting.default_width ~= nil then
		config.default_width = setting.default_width
	elseif config.default_width ~= nil then
		config.default_width = config.default_width
	else
		config.default_width = 600
	end

	return config
end

-- Function to update config file
-- Theme array
function M.theme(config, apply, theme, setting, font)
	local file = io.open(config, "w")

	local fileExist = require("lua.fileExist")
	local fileExist = fileExist.fileExists

	if fileExist(config) then
		local loadCustom = load_config_custom(config)
	end

	if file then
		file:write("setting = {\n")
		if setting == nil then
			local trash
		else
			for key, value in pairs(setting) do
				file:write(string.format("   %s = %q,\n", key, value))
			end
		end
		file:write("}\n")
		file:write("\n")
		file:write("theme = {\n")
		for key, value in pairs(apply) do
			if value ~= theme[key] then
				file:write(string.format("   %s = %q,\n", key, value))
			end
		end
		file:write("}\n")
		file:write("\n")
		file:write("font = {\n")
		for key, value in pairs(font) do
			file:write(string.format("   %s = %q,\n", key, value))
		end
		file:write("}\n")
		file:close()
	else
		print("Failed to open config file.")
	end
end

-- Function to update config file
-- Settings array
function M.setting(config, apply, apply_theme, font)
	local file = io.open(config, "w")

	local fileExist = require("lua.fileExist")
	local fileExist = fileExist.fileExists

	if fileExist(config) then
		local loadCustom = load_config_custom(config)
	end

	if file then
		file:write("setting = {\n")
		if setting == nil then
			local trash
		else
			for key, value in pairs(apply) do
				file:write(string.format("   %s = %q,\n", key, value))
			end
		end
		file:write("}\n")
		file:write("\n")
		file:write("theme = {\n")
		for key, value in pairs(apply_theme) do
			file:write(string.format("   %s = %q,\n", key, value))
		end
		file:write("}\n")
		file:write("\n")
		file:write("font = {\n")
		for key, value in pairs(font) do
			file:write(string.format("   %s = %q,\n", key, value))
		end
		file:write("}\n")
		file:close()
	--print("Config file updated successfully.")
	else
		print("Failed to open config file.")
	end
end

-- Update the conf file with new color_scheme
function M.color_scheme(replacement, path)
	-- creates the replace variable
	-- needed because otherwise there was a bug
	-- where you can't change color scheme after resetting to default
	local replace
	local file = io.open(path, "r")

	for line in file:lines() do
		local match = string.match(line, "color_scheme")

		if match then
			replace = line
		end
	end

	-- adds the line if it doesnt find a match
	if not replace then
		local appendFile = function()
			local file = io.open(path, "a")

			file:write('color_scheme = "' .. stringValue .. '"\n')
			file:close()
		end

		appendFile()
	else
		-- Read the file content
		local file = io.open(path, "r")
		local content = file:read("*a")
		file:close()

		-- Perform the line replacement
		local modifiedContent = content:gsub(replace, replacement)

		-- Write the modified content back to the file
		file = io.open(path, "w")
		file:write(modifiedContent)
		file:close()
	end
end

-- Returns all variables
return { write = M }
