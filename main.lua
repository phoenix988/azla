#!/usr/bin/env lua

--##____  _                      _
--#|  _ \| |__   ___   ___ _ __ (_)_  __
--#| |_) | '_ \ / _ \ / _ \ '_ \| \ \/ /
--#|  __/| | | | (_) |  __/ | | | |>  <
--#|_|   |_| |_|\___/ \___|_| |_|_/_/\_\
--#
--# -*- coding: utf-8 -*-
--##############################################
--### WELCOME TO MY LANGUAGE LEARNING SCRIPT ###
--#######################################################
--###### This is gonna help me practice azerbajani ######
--#######################################################


-- This is a rewritten version in lua
-- Initially I wrote it using a shell script

-- Imports some libaries
require("os")
require("io")
lgi = require("lgi")

colors = {
    reset = "\27[0m", -- Reset color
    red = "\27[31m", -- Red
    green = "\27[32m", -- Green
    blue = "\27[34m", -- Blue
}

-- Sets fzf variable
fzf = "fzf"

-- Sets variable that controls
-- if you wanna keep running the script
run = "yes"

-- Calculates how many sessions you run
session = 0

-- Calculates the amount of correct answers
correct_answers = 0
incorrect_answers = 0


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

-- Function to check if a program is installed
-- Usage: is_program_installed(program_name)
function is_program_installed(program_name)
   local command = string.format("command -v %s >/dev/null 2>&1 && echo 'yes' || echo 'no'", program_name)
   local handle = io.popen(command)
   local result = handle:read("*a")
   handle:close()
   return result:match("yes") ~= nil
end

-- Define a function to process the switches
function processSwitches()
  local i = 1
  while i <= #arg do
    local switch = arg[i]

    if switch == "--help" or switch == "-h" then
      -- Handle help switch
      print("Help message here")
      os.exit(0)

    elseif switch == "--file" or switch == "-f" then
      -- Chose the word list you want to use 
      -- Usage: --file filename must be located in lua_words
      local input = arg[i + 1]
      -- Check if input value is provided
      -- will leave if no output is provided
      if not input then
        print("Missing input file value for switch:", switch)
        os.exit(1)
      end

       -- Will leave if the file doesn't exist
       local filename = "lua_words/" .. input .. ".lua"
       if not fileExists(filename) then
         print("File does not exist:", filename)
         os.exit(1)
       end

      -- Process the input file
      require("lua_words/" .. input)
      i = i + 1

    else
      -- Handle unrecognized switches or arguments
      print("Unrecognized switch or argument:", switch)
      os.exit(1)
    end

    i = i + 1
  end
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

  os.execute("clear")

end

-- Main function that prompt you to answer in azerbajani
function question_main()

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
    local choice = string.lower(choice)
--    local choice = choice:gsub("ü", "u")
     
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
end

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
os.execute("clear")

if is_program_installed(fzf) then
   print("")
else
   print(fzf .. " is not installed: leaving")
   os.exit(0)
end


processSwitches()

-- Welcome message
welcome()

-- Asks if you want to write in english or azerbajani
language()

while run == "yes" do 
  
  session = session + 1
 
  word_list()
   
  if language == "azerbajan" then 
    
       question_main()
  
  elseif language == "english" then
  
       question_alt()
  
  end

  -- Asks if you want to try again with another list
  do_again()

  os.execute("clear")

end

print("Your correct answers over " .. session .. " sessions" )
print("Correct: " .. correct_answers)
print("İncorrect: " .. incorrect_answers)





