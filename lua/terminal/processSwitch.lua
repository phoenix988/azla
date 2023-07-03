local os    = require("os")
local color = require("lua.terminal.colors")

local M = {}

function M.help()
    print("Help Information for : Azla")
    print("\n")
    print("Options:\t")
    print(color.blue .. "--help -h \t Print this help Message")
    print(color.green .. "--term -t \t Open the terminal version of the app")
    print(color.green .. "\t\t -t $ARG use a wordlist thats located in lua_words")
end

-- Define a function to process the switches
function M.processSwitches(luaWordsPath,luaWordsModule)
  local i = 1
  while i <= #arg do
    local switch = arg[i]

    if switch == "--help" or switch == "-h" then
      -- Handle help switch
      M.help()
      os.exit(0)

    elseif switch == "--term" or switch == "-t" then  
      -- handle terminal switch
      M.terminal = true

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
      print(color.red .. "Unrecognized switch or argument:", switch)
      os.exit(1)
    end

    i = i + 1
  end

end

return M

