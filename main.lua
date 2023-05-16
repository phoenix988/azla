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


-- Sets variable that controls
-- if you wanna keep running the script
run = "yes"
session = 0

-- Calculates the amount of correct answers
correct_answers = 0
incorrect_answers = 0

-- Welcome message function
function welcome()
    print("Welcome to my script that will help you practice Azerbaijani words and sentences")
    print("-Karl")
    io.read()
end


-- Function that prompts you to chooce word list
function word_list()
    if files == nil or files == '' then
        choice = io.popen("find " .. os.getenv("PWD") .. "/lua_words -iname \"*.lua\" | awk -F \"/\" '{print $NF}' | sed -e 's/.lua//g' | fzf"):read("*line")
    else
        choice_file = files
    end
    
    require("lua_words/" .. choice )

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

function language()
  -- Keeps running if you make incorrect choice
  language = "empty"

  while language == "empty" do
    local question = "Choose which Language you want your questions to be in ((A)zerbajan/(E)nglish/): "
    io.write(question)
    local choice = io.read()

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


function question_main()

for i = 1, #wordlist do
  local correct = wordlist[i][1]
  local word = wordlist[i][2]
  local correct = string.lower(correct)

    io.write("What is " .. word ..  " in Azerbajani: " )
    local choice = io.read()
    local choice = string.lower(choice)

     if choice == correct then

       io.write("Congratulations answer is correct!")
       io.read()
       os.execute("clear")
       correct_answers = correct_answers + 1

     else
  
       local correct = string.upper(correct)
       io.write("Sadly your answer is not correct")
       print("")
       io.write("Correct answer is: " .. correct .. ": ")
       io.read()
       os.execute("clear")
       incorrect_answers = incorrect_answers + 1
      
     end

 end
end

function question_alt()
for i = 1, #wordlist do
  local correct = wordlist[i][2]
  local word = wordlist[i][1]

    io.write("What is " .. word ..  " in English: " )
    local choice = io.read()

     if choice == correct then

       io.write("Congratulations answer is correct!")
       io.read()
       os.execute("clear")
       correct_answers = correct_answers + 1

     else
  
       io.write("Sadly your answer is not correct")
       print("")
       io.write("Correct answer is: " .. correct .. ": ")
       io.read()
       os.execute("clear")
       incorrect_answers = incorrect_answers + 1
      
     end

 end
end

function do_again()
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
print("Incorrect: " .. incorrect_answers)




