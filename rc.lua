#!/usr/bin/env lua

-- Imports libaries we need
local lfs            = require("lfs")
local io             = require("io")
local os             = require("os")

-- Gets the current directory
local currentDir = debug.getinfo(1, "S").source:sub(2)
currentDir = currentDir:match("(.*/)") or ""

-- Append the current directory to the package path
package.path = currentDir .. "?.lua;" .. package.path

-- Imports init file
local import         = require("lua.init")

-- Sets home variable
local home           = os.getenv("HOME")

local luaWordsPath      = currentDir .. "lua/words/"
local luaWordsModule    = "lua.words"

-- File exist function
local fileExist       = import.fileExists

-- Main window
local app1            = import.app1

-- Sets terminal variable
local terminal       = false

-- Sets cachefile path
local cacheFile      = home .. "/.cache/azla.lua"

local terminal_init  = require("lua.terminal.init")

-- Create the cache file if it doesn't exist
if not fileExists(cacheFile) then
      local file = io.open(cacheFile, "w")
      
      file:write("config = {\n")
      file:write("    word_set = 1,\n")
      file:write("    lang_set = 0,\n")
      file:write("    default_width = 600,\n")
      file:write("    default_height = 800,\n")
      file:write("}")
   
       -- Close the file
       file:close()

end

-- Define a function to process the switches
function processSwitches()
  local i = 1
  while i <= #arg do
    local switch = arg[i]

    if switch == "--help" or switch == "-h" then
      -- Handle help switch
      print("--help -h Print this help Message")
      print("--term -t Open the terminal version of the app")
      print("-t $ARG use a wordlist thats located in lua_words")
      os.exit(0)

    elseif switch == "--term" or switch == "-t" then  
      -- handle terminal switch
      terminal = true

      -- Check if input value is provided
      -- will leave if no output is provided
      local input = arg[i + 1]
      if not input then
         -- Wont do anything if you dont provide any argument
         local no = ""
      else
 
         -- Will leave if the file doesn't exist
         local filename = luaWordsPath .. input .. ".lua"
         if not fileExists(filename) then
           print("File does not exist:", filename)
           os.exit(1)
         end

         -- Process the input file
         wordlist = require(luaWordsModule .. "." .. input)
         i = i + 1
          
      end

    else
      -- Handle unrecognized switches or arguments
      print("Unrecognized switch or argument:", switch)
      os.exit(1)
    end

    i = i + 1
  end
end

-- Process the switches 
processSwitches()

-- Activate app1
function app1:on_activate()
  self.active_window:present()
end

-- Runs the GUI app if you dont specify --term (-t)
if terminal == false then 
  
  -- Runs the app
  app1:run()

-- Runs the terminal app
elseif terminal == true then
  -- runs terminal app
  terminal_init()

end -- End of if statement


