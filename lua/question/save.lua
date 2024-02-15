local json = require("dkjson")
local os   = require("os")

-- Create empty table
local M = {}
local home = os.getenv("HOME")
local jsonPath = home .. "/.cache/azla/last_session.json"


-- Save settings to json file
function M.saveSession(settings)

    local jsonStr = json.encode(settings)
    
    local file = io.open(jsonPath, "w")
    file:write(jsonStr)
    file:close()

end

-- Load information from last session
function M.loadSession()

    local file = io.open(jsonPath, "r")
    local contents = file:read("*a")
    file:close()

    local settings = json.decode(contents)
    
    return settings
end


return M
