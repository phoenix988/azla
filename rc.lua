#!/usr/bin/env lua
-- Imports libaries we need
local lgi            = require("lgi")
local Gtk            = lgi.require("Gtk", "4.0")
local GObject        = lgi.require("GObject", "2.0")
local GdkPixbuf      = lgi.require('GdkPixbuf')
local lfs            = require("lfs")
local io             = require("io")
local os             = require("os")

-- Sets home variable
local home           = os.getenv("HOME")

-- Imports window 1
local appModule      = require("lua/mainWindow")
local app1           = appModule.app1

-- Import file exist module
local fileExistModule = require("lua/fileExist")
local fileExist       = fileExistModule.fileExists

-- Sets terminal variable
local terminal       = false

-- Sets cachefile path
local cacheFile      = home .. "/.cache/azla.lua"

-- Create the cahce file if it doesn't exist
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
         local filename = "lua_words/" .. input .. ".lua"
         if not fileExists(filename) then
           print("File does not exist:", filename)
           os.exit(1)
         end

         -- Process the input file
         require("lua_words/" .. input)
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


  colors = {
      reset = "\27[0m", -- Reset color
      red = "\27[31m", -- Red
      green = "\27[32m", -- Green
      blue = "\27[34m", -- Blue
  }
  
  -- Sets fzf variable
  local fzf               = "fzf"
  
  -- Sets variable that controls
  -- if you wanna keep running the script
  local run               = "yes"
  
  -- Calculates how many sessions you run
  local session           = 0
  
  -- Calculates the amount of correct answers
  local correct_answers   = 0
  local incorrect_answers = 0
  
  
  -- Function to check if a program is installed
  -- Usage: is_program_installed(program_name)
  function is_program_installed(program_name)
     local command = string.format("command -v %s >/dev/null 2>&1 && echo 'yes' || echo 'no'", program_name)
     local handle = io.popen(command)
     local result = handle:read("*a")
     handle:close()
     return result:match("yes") ~= nil
  end
  
  -- Welcome message function
  function welcome()
      print("Welcome to my script that will help you practice Azerbaijani words and sentences")
      print("-Karl")
      io.read()
  end
  
  -- Function that prompts you to choose word list
  function word_list()
      
     if wordlist == nil then
        if files == nil or files == '' then
            choice = io.popen("find " .. os.getenv("PWD") .. "/lua_words -iname \"*.lua\" | awk -F \"/\" '{print $NF}' | sed -e 's/.lua//g' | fzf"):read("*line")
        else
            choice_file = files
        end
     end
        
     if wordlist == nil then
        require("lua_words/" .. choice )
     end
     
     -- Function to Shuffle the wordlist array
     local function shuffle(wordlist)
         local rand = math.random
         local iterations = #wordlist
     
         for i = iterations, 2, -1 do
             local j = rand(i)
             wordlist[i], wordlist[j] = wordlist[j], wordlist[i]
         end
     end
     
     -- shuffle the array to make the questions random
     shuffle(wordlist)
    
     end
    
  -- Function that asks you which language root you want to take
  function language()
    -- Keeps running if you make incorrect choice
    language = "empty"
  
    -- Keeps running if you make invalid choice
    while language == "empty" do
      local question = "Choose which Language you want your questions to be in ((A)zerbajan/(E)nglish/): "
      io.write(colors.blue .. question)
      print(colors.reset)
      local choice = io.read()
  
      -- Statement that sets the language variable depending on choice
      if choice == "A" or choice == "a" then
          -- Perform action for choice A
          language="azerbajan"
      elseif choice == "E" or choice == "e" then
          -- Perform action for choice E
          language="english"
      else
          -- Invalid choice
          print("Invalid choice, Try again")
      end
    
    end
 
    -- Clear the screen
    os.execute("clear")
  
  end
  
  
  -- Main function that prompt you to answer in azerbajani
  function question_main()
    -- Starts the for loop
    for i = 1, #wordlist do
         -- Sets the correct answer
         local correct = wordlist[i][1]
         local correct = string.lower(correct)
    
         -- Sets the first letter to uppercase for the value inside of word
         local word = wordlist[i][2]
         local word_firstLetter = word:sub(1, 1):upper()
         local word_restofword = word:sub(2)
         local word = word_firstLetter .. word_restofword
    
         -- asks you the questions
         io.write(colors.blue .. "What is " .. colors.green .. word .. colors.blue ..  " in Azerbajani: " )
         local choice = io.read()
         -- Sets your answer to all lowercase
         local choice = choice:lower()
         
         -- Reset colors
         print(colors.reset)
    
         -- Calculates if your answer is correct
         if choice == correct then
    
            io.write(colors.green .. "Congratulations answer is correct!")
            io.read()
            os.execute("clear")
            correct_answers = correct_answers + 1
    
            print(colors.reset)
    
         else
    
            -- Only runs if your answer is incorrect
            local firstLetter = correct:sub(1, 1):upper()
            local restofword = correct:sub(2)
            local correct = firstLetter .. restofword
    
            io.write(colors.red .. "Sadly your answer is not correct")
            print("")
            io.write("Correct answer is: " .. correct .. ": ")
            io.write("Your answer was: " .. choice .. ": ")
            io.read()
            os.execute("clear")
            incorrect_answers = incorrect_answers + 1
    
            print(colors.reset)
          
         end
    end
  
  end -- End of question_main
  
  -- Alternative function that prompt you to answer in english
  function question_alt()
    for i = 1, #wordlist do
         local correct = wordlist[i][2]
         local word = wordlist[i][1]
    
         io.write("What is " .. word ..  " in English: " )
         local choice = io.read()
         -- converts to lowercase
         local choice = string.lower(choice)
    
         if choice == correct then
    
           io.write("Congratulations answer is correct!")
           io.read()
           os.execute("clear")
           correct_answers = correct_answers + 1
    
         else
          
           -- Converts to uppercase
           local firstLetter = correct:sub(1, 1):upper()
           local restofword = correct:sub(2)
           local correct = firstLetter .. restofword
    
           io.write("Sadly your answer is not correct")
           print("")
           io.write("Correct answer is: " .. correct .. ": ")
           io.read()
           os.execute("clear")
           incorrect_answers = incorrect_answers + 1
          
         end
    
    end
  end -- end of question_alt
  
  -- Function to run the script again if you choose to
  function do_again()
      -- Makes local check function 
      -- while loop will keep running if you make incorrect answer
      local check = "false"
  
      while check == "false" do
        
         io.write("Do you want to do another round? [y/n]")
         local choice = io.read()
         
         if choice == "y" or choice == "Y" then
  
           check = "true"
           io.write("You did choose to do another round  ")
           io.read()
  
         elseif choice == "n" or choice == "N" then
  
           check = "true"
           run = "no"
  
         else 
  
           print("Invalid choice")
  
         end
  
      end
  
  end
  
  -- Calls all the function

  -- Clears the Screen
  os.execute("clear")
  
  -- Checks if FZF is installed otherwise it will exist
  if is_program_installed(fzf) then
     print("")
  else
     print(fzf .. " is not installed: leaving")
     os.exit(0)
  end
  
  -- Process the switches
  processSwitches()
  
  -- Welcome message
  welcome()
  
  -- Asks if you want to write in english or azerbajani
  language()
  
  -- Loops that keeps running unless you exit
  while run == "yes" do 
    
    session = session + 1
  
    word_list()
     
    -- Language choice 
    -- If you choose azerbajani this runs 
    if language == "azerbajan" then 
      
         question_main()
    
    -- If you choose english this runs 
    elseif language == "english" then
    
         question_alt()
    
    end
  
   
    -- Asks if you want to try again with another list
    do_again()
    
    -- Clear screen
    os.execute("clear")
   
   -- If run is empty then wordlist will be reset
   if run == "run" then
    wordlist = nil
   end
  
  end
  
  -- Prints the result in the end
  print("Your correct answers over " .. session .. " sessions" )
  print("Correct: " .. correct_answers)
  print("İncorrect: " .. incorrect_answers)

end -- End of if statement


