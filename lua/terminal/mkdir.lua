local os = require("os")

local M = {}
-- create directory
function M.mkdir(file)
   os.execute("mkdir -p " .. file)
end

function M.rmdir(file)
   os.execute("rm -rf " .. file)
end

return M
