local os = require("os")

local file = {}
-- create directory
function file.mkdir(file)
   os.execute("mkdir " .. file)
end


return file
