local lfs                  = require("lfs")
local io                   = require("io")

local list = {}

-- Modify a string to print the last column in a path
function list.modify(luaFiles, type)

    local file_type = type or "dir"
    -- Add items to the wordfile combo box
    local luafilesFormatFirst = string.gsub(luaFiles, "lua", "")
    local luafilesFormatSecond = string.gsub(luafilesFormatFirst, ".lua", "")
    local last = string.match(luafilesFormatSecond, "[^/]+$")
    local last = string.match(last, "([^.]+).")
        
    local luaFiles = last
    
    return luaFiles 

end


function list.modify_dir(luaFiles)
    -- Add items to the wordfile combo box
    local luafilesFormatFirst = string.gsub(luaFiles, "lua", "")
    local luafilesFormatSecond = string.gsub(luafilesFormatFirst, ".lua", "")
    local last = string.match(luafilesFormatSecond, "[^/]+$")
        
    local luaFiles = last
    
    return luaFiles 

end


-- Function to list all word files inside lua_words
 function list.dir(directory, type)
       local luaFiles = {}

       local file_type = type or "lua"
 
       -- Loops through the directory
       for file in lfs.dir(directory) do
            local filePath = directory .. "/" .. file
            if file_type == "lua" then
               if lfs.attributes(filePath, "mode") == "file" and file:match("%.lua$") then
                   table.insert(luaFiles, filePath)
               end
            elseif file_type == "dir" then
               if file ~= "." and file ~= ".." and lfs.attributes(filePath, "mode") == "directory" then
                   table.insert(luaFiles, filePath)
               end
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
    

