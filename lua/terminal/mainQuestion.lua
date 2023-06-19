local io                = require("io")
local os                = require("os")

local result           = {}
result.correct         = 0
result.incorrect       = 0

local function select_count(wordlist,colors)
      local last_number = #wordlist 
      local choice      = last_number + 1
      local first       = true
      
      for i = 1, #wordlist do
          print(colors.blue .. i .. colors.reset)
      end
      
        while choice > last_number do   
            if not first then
               os.execute("clear")
               for i = 1, #wordlist do
                   print(colors.blue .. i .. colors.reset)
               end
               print(colors.red .. "Invalid options" .. colors.reset)
            end
            
            io.write("Choose the amount of words you want: ")
            choice = io.read()
            
            choice = tonumber(choice)
            
            if choice == nil then 
               choice = last_number + 1
            end
            first  = false

        end
      
      return choice
end

-- Main function that creates the questions
function question_main(wordlist,colors,language,word_count)

    os.execute("clear")
    
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
  for i = 1, math.min(#wordlist, word_count) do
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
          result.correct   = result.correct + 1
  
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
          result.incorrect = result.incorrect + 1
  
          print(colors.reset)
        
       end
  end

end -- End of question_main


function getResult()
   return result
end
  
return {question_main = question_main, 
        getResult     = getResult,
        select_count = select_count}
