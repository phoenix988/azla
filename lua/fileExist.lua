local io = require("io")

-- function to check if a file exist
-- Usage: fileExist(filename)
function fileExists(filename)
  local file = io.open(filename, "r")
  if file then
    io.close(file)
    return true
  else
    return false
  end
end

return {fileExists = fileExists}

