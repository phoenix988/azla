local os = require("os")

local p = {}

-- Define a function to process the switches
function p.processSwitches(luaWordsPath,luaWordsModule)
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
      p.terminal = true

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

return p

