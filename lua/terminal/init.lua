local io              = require("io")
local os              = require("os")
local colors          = require("lua.terminal.colors")
local p               = require("lua.terminal.processSwitch")


-- Import shuffle
local shuffle         = require("lua.shuffle")
local list            = require("lua.terminal.listFiles")
local word_count      = require("lua.terminal.mainQuestion").select_count

-- Gets current dir
local currentDir      = list.current_dir("/terminal")

local luaWordsModule  = "lua.words"
local filesWord       = "/opt/azla/lua/words" 

local language        = {}

local M = {}

-- Function so you can select wordlist
local function select_word(luaFiles)

     local indextable = {}
     local continue = true
     local firstRun = true
     local num = 0

     if wordlist == nil then

        luaFiles = list.dir(luaFiles)

        for index, value in ipairs(luaFiles) do
            
            table.insert(indextable, index)
            value = list.modify(value)

            if num == 0 then
              num = num + 1
              col = colors.green

            elseif num == 1 then
              col = colors.blue
              num = num + 1 

            elseif num == 2 then
              col = colors.red
              num = 0

            end
            print(col .. index .. ": " .. value)
        end
           
        while continue do
            if not firstRun then
               for index, value in ipairs(luaFiles) do
                   local value = list.modify(value)
                   print(index .. ": " .. value)
               end
            end
            io.write("\n")
            io.write(colors.reset .. "Make your selection: ")
            choice = io.read()

            for index, value in ipairs(luaFiles) do
                     value = list.modify(value)
                     choice = tonumber(choice)
                 if index == choice then
                     choice = value
                     continue = false
                     os.execute("clear")
                     break
                 end
            end

            if continue then
               os.execute("clear")
               print("Invalid choice")
            end
            
            firstRun = false
        end
     end

     return choice
end


function M.terminal_init()
  
  -- Sets variable that controls
  -- if you wanna keep running the script
  local run           = true
  
  -- Calculates how many sessions you run
  local session       = 0
  
 
  -- Welcome message function
  function welcome()
      print(colors.blue .. "Welcome to my script that will help you practice Azerbaijani words and sentences" ..
      "\nTerminal Version, Have fun!!!")
      print(colors.reset .. "\n~Karl")
      print("Enter to continue: ")
      io.read()
  end
  
  -- Function that prompts you to choose word list
  function word_list()
     
      -- Select wordlist
      local selection = select_word(filesWord)
       
      if wordlist == nil then
         wordlist = require(luaWordsModule .. "." .. selection )
      end
      
      -- shuffle the array to make the questions random
      shuffle(wordlist)
    
  end

     -- Function that asks you which language root you want to take
  function language_choice()
     -- Keeps running if you make incorrect choice
     local language_check = false
     
     -- Keeps running if you make invalid choice
     while not language_check do
       local question = "Choose which Language you want your questions to be in ((A)zerbajan/(E)nglish/): "
       io.write(colors.blue .. question)
       print(colors.reset)
       local choice = io.read()
     
       -- Statement that sets the language variable depending on choice
       if choice == "A" or choice == "a" then
           -- Perform action for choice A
           language.opt = "azerbajan"
           break
       elseif choice == "E" or choice == "e" then
           -- Perform action for choice E
           language.opt = "english"
           break
       else
           -- Invalid choice
           print("Invalid choice, Try again")
           os.execute("clear")
       end
     
     end
 
     -- Clear the screen
     os.execute("clear")
     
  end
  
 
  -- Function to run the script again if you choose to
  function do_again()
      -- Makes local check function 
      -- while loop will keep running if you make incorrect answer
      local check = false
  
      while not check do
        
         io.write("Do you want to do another round? [y/n]")
         local choice = io.read()
         
         if choice == "y" or choice == "Y" then
  
           check = true
           io.write("You did choose to do another round  ")
           io.read()
  
         elseif choice == "n" or choice == "N" then
  
           check = true
           run = false
  
         else 
  
           print("Invalid choice")
  
         end
  
      end
  
  end
  
  -- Calls all the function
  -- Clears the Screen
  os.execute("clear")
  
  -- starts the main functions
  -- Welcome message
  welcome()
  
  -- Loops that keeps running unless you exit
  while run do 
    
    -- keeps track of sessions
    session = session + 1

    -- Asks if you want to write in english or azerbajani
    language_choice()
    
    -- Choose wordlist
    word_list()
    
    -- Choose word_count
    local word_count = word_count(wordlist,colors)

    -- Imports the question_main module
    local questionMainModule  = require("lua.terminal.mainQuestion")
    local questionMain        = questionMainModule.question_main
    getResult                 = questionMainModule.getResult

    -- Language choice 
    -- If you choose azerbajani this runs 
    if language.opt == "azerbajan" then 

       -- runs questions
       questionMain(wordlist,colors,language.opt,word_count)
       
       -- Empty the wordlist so you can try again with another
       wordlist = nil
    
    -- If you choose english this runs 
    elseif language.opt == "english" then
       
       -- runs questions
       questionMain(wordlist,colors,language.opt,word_count)

       -- Empty the wordlist so you can try again with another
       wordlist = nil
    
    end
   
    -- Asks if you want to try again with another list
    do_again()
    
    -- Clear screen
    os.execute("clear")
   
   -- If run is empty then wordlist will be reset
   if run then
      wordlist = nil
   end
  
  end -- end of the main function
  
  -- Gets the result
  result = getResult()
  
  -- Prints the result in the end
  print("Your correct answers over " .. session .. " sessions" )
  print(colors.green .. "Correct: " .. result.correct)
  print(colors.red ..   "Incorrect: " .. result.incorrect)

end -- end of terminal init

return M.terminal_init
