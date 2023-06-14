local io                = require("io")
local os                = require("os")

local correct_answers   = 0
local incorrect_answers = 0

-- Main function that creates the questions
function question_main(wordlist,colors,language)
    
    -- Creates neceseary values to use depending on language choice
    if language == "azerbajan" then
       n_1 = 1
       n_2 = 2
       language = "azerbajani"
    elseif language == "english" then
       n_1 = 2
       n_2 = 1
    end

  -- Starts the for loop
  for i = 1, #wordlist do
       -- Sets the correct answer
       local correct = wordlist[i][n_1]
       local correct = string.lower(correct)
  
       -- Sets the first letter to uppercase for the value inside of word
       local word = wordlist[i][n_2]
       local word_firstLetter = word:sub(1, 1):upper()
       local word_restofword = word:sub(2)
       local word = word_firstLetter .. word_restofword
  
       -- asks you the questions
       io.write(colors.blue .. "What is " .. colors.green .. word .. colors.blue ..  " in " .. language .. ": " )
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

function getCorrect()
    return correct_answers
end
    
function getIncorrect()
    return incorrect_answers
end
  
return {question_main = question_main, getCorrect = getCorrect, getIncorrect = getIncorrect}
