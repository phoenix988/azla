local os = require("os")

local M = {}
-- create directory
function M.mkdir(file)
   os.execute("mkdir " .. file)
end


return M
