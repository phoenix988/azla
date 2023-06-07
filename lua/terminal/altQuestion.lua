local io                = require("io")
local os                = require("os")

local correct_answers   = 0
local incorrect_answers = 0

function question_alt(wordlist,colors)
  -- Alternative function that prompt you to answer in english
    for i = 1, #wordlist do
         local correct = wordlist[i][2]
         local word = wordlist[i][1]
    
         io.write(colors.blue .. "What is " .. colors.green .. word .. colors.blue ..  " in English: " )
         local choice = io.read()
         -- converts to lowercase
         local choice = string.lower(choice)
    
         if choice == correct then
    
           io.write(colors.green .. "Congratulations answer is correct!")
           io.read()
           os.execute("clear")
           correct_answers = correct_answers + 1
    
         else
          
           -- Converts to uppercase
           local firstLetter = correct:sub(1, 1):upper()
           local restofword = correct:sub(2)
           local correct = firstLetter .. restofword
    
           io.write(colors.red .. "Sadly your answer is not correct")
           print("")
           io.write("Correct answer is: " .. correct .. ": ")
           io.read()
           print(colors.reset)
           os.execute("clear")
           incorrect_answers = incorrect_answers + 1
          
         end
    
    end
 end -- end of question_alt
 

function getCorrect()
    return correct_answers
end
    
function getIncorrect()
    return incorrect_answers
end
  
return {question_alt = question_alt, getCorrect = getCorrect, getIncorrect = getIncorrect}



