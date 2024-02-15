local themeModule = require("lua.theme.default")
local font        = themeModule.font.load()
local theme       = themeModule.load()

-- Function that create all labels we need for azla
local response = {}

function response.labels(correct, choice, word)
      response.correctString = "Congratulations, your answer is correct!"
      response.correctStringAlt = "Great Try!, \nyour answer is partially correct!, \ncorrect: " .. correct
      response.correctLabel = "Question: " .. word .. ": " .. "Answer: " .. choice
      response.incorrectString = "Sorry, your answer is incorrect.\nQuestion: " .. word .. "\nCorrect answer: " .. correct
      response.incorrectLabel = "Question: " .. word .. "\nCorrect: " .. correct .. ": " .. "\nAnswer: " .. choice .. "\n"

      return response
end


function response.main(opt, labels, w, i, answer_result, choice, theme)
      local mode = require("lua.main").getWordList()
      
      if opt == "correct" then
          color = theme.label_correct
      elseif opt == "incorrect" then
          color = theme.label_incorrect
      end

      
      w.result_labels[i].label = labels
      w.result_labels[i]:set_markup("<span foreground='" .. color .. "'>" .. w.result_labels[i].label .. "</span>")
      w.result_labels[i]:set_markup("<span size='" .. font.fg_size .. "'>" .. w.result_labels[i].label .. "</span>"  )

      if mode.mode == false then
         w.submit_buttons[i]:set_visible(false)
         w.next_buttons[i]:set_visible(true)   
      end   
      
      if opt == "correct" then
           if question.label_correct == nil then
               question.label_correct = {}
           end
           question.label_correct[i] = answer_result
      elseif opt == "incorrect" then
           if question.label_incorrect == nil then
               question.label_incorrect = {}
           end
           question.label_incorrect[i] = answer_result
      end

      

end

return response
