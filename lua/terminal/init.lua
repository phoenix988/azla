local io              = require("io")
local os              = require("os")
local colors          = require("lua.terminal.colors")
local luaWordsModule  = "lua.words"
local p               = require("lua.terminal.processSwitch")
local language        = {}

local function terminal_init()
  -- Sets fzf variable
  local fzf           = "fzf"
  
  -- Sets variable that controls
  -- if you wanna keep running the script
  local run           = "yes"
  
  -- Calculates how many sessions you run
  local session       = 0
  
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
            choice = io.popen("find " .. os.getenv("PWD") .. "/lua/words -iname \"*.lua\" | awk -F \"/\" '{print $NF}' | sed -e 's/.lua//g' | fzf"):read("*line")
        else
            choice_file = files
        end
     end
        
     if wordlist == nil then
        wordlist = require(luaWordsModule .. "." .. choice )
     end

     -- Import shuffle
     local shuffle = require("lua.shuffle")
     
     -- shuffle the array to make the questions random
     shuffle(wordlist)
    
     end

     -- Function that asks you which language root you want to take
     function language_choice()
       -- Keeps running if you make incorrect choice
       local language_check = "empty"
     
       -- Keeps running if you make invalid choice
       while language_check == "empty" do
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
         end
       
       end
 
       -- Clear the screen
       os.execute("clear")
     
     end
  
 
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
  
  -- Welcome message
  welcome()
  
  -- Loops that keeps running unless you exit
  while run == "yes" do 
    
    session = session + 1

    -- Asks if you want to write in english or azerbajani
    language_choice()
  
    word_list()

    -- Language choice 
    -- If you choose azerbajani this runs 
    if language.opt == "azerbajan" then 

       local questionMainModule = require("lua.terminal.mainQuestion")
       local questionMain       = questionMainModule.question_main
       getCorrect               = questionMainModule.getCorrect
       getIncorrect             = questionMainModule.getIncorrect
       questionMain(wordlist,colors,language.opt)

       wordlist = nil
    
    -- If you choose english this runs 
    elseif language.opt == "english" then

       local questionMainModule = require("lua.terminal.mainQuestion")
       local questionMain        = questionMainModule.question_main
       getCorrect               = questionMainModule.getCorrect
       getIncorrect             = questionMainModule.getIncorrect
       questionMain(wordlist,colors,language.opt)

       wordlist = nil
    
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

  correct_answers   = getCorrect()
  incorrect_answers = getIncorrect()
  
  -- Prints the result in the end
  print("Your correct answers over " .. session .. " sessions" )
  print(colors.green .. "Correct: " .. correct_answers)
  print(colors.red ..   "İncorrect: " .. incorrect_answers)

end


return terminal_init
