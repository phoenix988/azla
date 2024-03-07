local os = require("os")

local M = {}
-- create directory
function M.mkdir(file)
   os.execute("mkdir -p " .. file)
end


return M
