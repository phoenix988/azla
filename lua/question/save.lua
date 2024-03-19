local json = require("dkjson")
local os = require("os")
local file = require("lua.config.init")
local var = require("lua.config.init")
local list = require("lua.terminal.listFiles")
local loadConfig = require("lua.loadConfig").load_config

-- Create empty table
local M = {}

local jsonPath = file.cacheDir

-- Clear model
local function clear_model(combo)
	if combo then
		local model = combo:get_model()
		local iter = model:get_iter_first()

		while iter do
			model:remove(iter)
			iter = model:get_iter_first()
		end
	end
end

-- Save settings to json file
function M.saveSession(settings, check, delete)
	local combo = require("lua.widgets.combo")
	local button = require("lua.widgets.button")
	local label = require("lua.widgets.label")

	-- Creates a table to pass through the combo class
	local input = {
		activeWord = combo.word:get_active(),
		modelWord = combo.word_list_model,
		module = var.wordMod,
		combo = combo,
		config = config,
		custom = var.config.custom,
		fileExist = require("lua.fileExist").fileExists,
	}

	local success = pcall(function()
		check.dontSave = check.dontSave or false
	end)

	local delete = delete or 0

	if not success then
		check = {}
		check.dontSave = true
	end

	check.file = check.file or nil
	local jsonPath = file.cacheDir
	if not check.dontSave then
		pcall(function()
			date = os.date("%H-%M-%d-%m-%Y")
			jsonStr = json.encode(settings)
			jsonPath = jsonPath .. "/session-" .. settings.wordlist .. "_" .. date .. ".json"
			LastPath = jsonPath
		end)
		if delete == 1 then
			os.remove(LastPath)
		end
	else
		jsonStr = json.encode(settings)
		pcall(function()
			jsonPath = jsonPath .. "/" .. check.file .. ".json"
			LastPath = jsonPath
		end)

		if delete == 1 then
			os.remove(LastPath)
		end
	end

	if delete ~= 1 then
		local file = io.open(jsonPath, "w")
		if file then
			file:write(jsonStr)
			file:close()
		end
	end

	clear_model(combo.restore_list)
	clear_model(combo.remove_restore_list)

	-- Add the new files to the combo.restore_files table (Important)
	combo.restore_files = combo.add_files(combo.restore_list_model, var.cacheDir, "json")
	combo.remove_restore_files = combo.add_files(combo.remove_restore_list_model, var.cacheDir, "json")

	if combo.restore_list then
		-- Sets value of restore list combo box (Right now it doesn't work)
		loadConfig(var.cacheFile)
		combo.set = combo:new(input)
		combo.set:set_value(combo.restore_list, config.restore_list)
	else
		local wordItems = {
			list = list,
			path = var.wordMod,
		}
		combo.set = combo:new(wordItems)
		-- create the restore list box
		combo.set:create_restore_list()

		local settingList = require("lua.main").getSettingList
		local settings = settingList()
		settings.mainGrid:attach(label.restore_list, 0, 13, 10, 1)
		settings.mainGrid:attach(combo.restore_list, 0, 14, 10, 1)
		settings.mainGrid:attach(button.restore_mode, 0, 15, 10, 1)
	end
end

-- Load information from last session
function M.loadSession()
	local set = require("lua.main").getSettingList()
	if not set.restore_list then
		local combo = require("lua.widgets.combo")
		local n = combo.restore_list:get_active()

		-- Only get the list name
		newStr = combo.restore_files[n + 1]

		if newStr then
			last = list.modify(newStr)
		end

		set.restore_list = last
	end

	local jsonPath = jsonPath .. "/" .. set.restore_list .. ".json"
	local file = io.open(jsonPath, "r")
	if file then
		contents = file:read("*a")
		file:close()
	end

	local set = json.decode(contents)

	return set
end

return M
