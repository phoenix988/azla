local lfs = require("lfs")
local io = require("io")
local utf8 = require("lua-utf8")

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

-- Modify dir
function list.modify_dir(luaFiles)
   -- Add items to the wordfile combo box
   local luafilesFormatFirst = string.gsub(luaFiles, "lua", "")
   local luafilesFormatSecond = string.gsub(luafilesFormatFirst, ".lua", "")
   local last = string.match(luafilesFormatSecond, "[^/]+$")

   local luaFiles = last

   return luaFiles
end

-- Function to list all word files inside lua_words
-- Usage list.dir(directory, type)
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

-- function that makes the first letter of a word uppercase
function list.to_upper(word)
   local wordFirstLetter = word:sub(1, 1):upper()
   local wordRestofWord = word:sub(2)
   local word = wordFirstLetter .. wordRestofWord

   return word
end

-- Function to set special letters to lowercase
-- Which is not detected by lower method
function list.lower_case(word, ver)
   -- Function that replace the letters
   -- Will be called inside the main function

   -- If you set ver to 2 then it will convert the first letter to uppercase
   -- Otheriwse it converts all special letters to lowercase
   ver = ver or 1

   -- List of letters to convert
   local list = {}
   list.U = { { "Ü", "ü" } }
   list.S = { { "Ş", "ş" } }
   list.C = { { "Ç", "ç" } }
   list.O = { { "Ö", "ö" } }
   list.G = { { "Ğ", "ğ" } }
   list.I = { { "I", "ı" } }
   list.E = { { "Ə", "ə" } }
   list.I2 = { { "İ", "i" } }

   -- local function to replace letters
   local function replace_letter(word, letters, replace)
      local catch = string.match(word, letters)

      if catch ~= nil then
         update = string.gsub(word, letters, replace)
         -- returns all to lowercase
         update = string.lower(update)
      end

      return update
   end

   if ver == 1 then
      -- loops through all the letter tables
      for key, value in pairs(list) do
         for i = 1, #list[key] do
            local match = string.match(word, list[key][i][1])
            local replace = list[key][i][2]
            if match ~= nil then
               local update = replace_letter(word, match, replace)
               return update
            else
               local noChange = string.lower(word)
            end
         end
      end
   else
      -- loops through all the letter tables
      for key, value in pairs(list) do
         for i = 1, #list[key] do
            local match = string.match(word, list[key][i][2])
            local firstLetter = utf8.sub(word, 1, 1)
            local replace = list[key][i][1]
            if match == firstLetter then
               local update = replace_letter(word, match, replace)
               return update
            end
         end
      end
   end
end

return list
