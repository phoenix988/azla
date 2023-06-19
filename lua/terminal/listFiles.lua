local lfs                  = require("lfs")

local list = {}

-- Modify a string to print the last column in a path
function list.modify(luaFiles)
    -- Add items to the wordfile combo box
    local luafilesFormatFirst = string.gsub(luaFiles, "lua", "")
    local luafilesFormatSecond = string.gsub(luafilesFormatFirst, ".lua", "")
    local last = string.match(luafilesFormatSecond, "[^/]+$")
    local last = string.match(last, "([^.]+).")
        
    local luaFiles = last
    
    return luaFiles 

end


-- Function to list all word files inside lua_words
 function list.dir(directory)
       local luaFiles = {}
 
       -- Loops through the directory
       for file in lfs.dir(directory) do
            local filePath = directory .. "/" .. file
            if lfs.attributes(filePath, "mode") == "file" and file:match("%.lua$") then
                table.insert(luaFiles, filePath)
            end
       end

       -- Sorts all the files
       table.sort(luaFiles)

       return luaFiles --Returns luaFiles variable to be used later
end

-- Gets the active diretory
function list.current_dir(sub)
   local currentDir = debug.getinfo(1, "S").source:sub(2)
   local currentDir = currentDir:match("(.*/)") or ""
   local currentDir = string.gsub(currentDir, sub, "")

   return currentDir
end


-- Function to check if a program is installed
-- Usage: is_program_installed(program_name)
function list.program_installed(program_name)
   local command = string.format("command -v %s >/dev/null 2>&1 && echo 'yes' || echo 'no'", program_name)
   local handle = io.popen(command)
   local result = handle:read("*a")
   handle:close()
   return result:match("yes") ~= nil
end

   
return list   
    

