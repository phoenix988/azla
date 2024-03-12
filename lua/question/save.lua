local json = require("dkjson")
local os = require("os")
local file = require("lua.config.init")

-- Create empty table
local M = {}

local jsonPath = file.cacheDir

-- Save settings to json file
function M.saveSession(settings)
	local date = os.date "%H-%M-%d-%m-%Y"
	local jsonStr = json.encode(settings)
	local jsonPath = jsonPath .. "/session-" .. date .. ".json"

	local file = io.open(jsonPath, "w")
	if file then
		file:write(jsonStr)
		file:close()
	end
end

-- Load information from last session
function M.loadSession()
	local settings = require("lua.main").getSettingList()
	local jsonPath = jsonPath .. "/" .. settings.restore_list .. ".json"
	local file = io.open(jsonPath, "r")
	if file then
		contents = file:read("*a")
		file:close()
	end

	local settings = json.decode(contents)

	return settings
end

return M
