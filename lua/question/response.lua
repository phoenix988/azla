-- Function that create all labels we need for azla
local response = {}

function response.labels(correct, choice)
    response.correctString = "Congratulations, your answer is correct!"
    response.correctStringAlt = "Great Try!, your answer is partially correct!, correct: " .. correct
    response.correctLabel = "Correct: " .. correct .. ": " .. "Answer: " .. choice
    response.incorrectString = "Sorry, your answer is incorrect. Correct answer: " .. correct
    response.incorrectLabel = "Correct: " .. correct .. ": " .. "Answer: " .. choice

    return response
end


function response.main(opt, labels, w, i, answer_result, choice, theme)
      if opt == "correct" then
          color = theme.label_correct
      elseif opt == "incorrect" then
          color = theme.label_incorrect
      end
      
      w.result_labels[i].label = labels
      w.result_labels[i]:set_markup("<span foreground='" .. color .. "'>" .. w.result_labels[i].label .. "</span>")
      w.result_labels[i]:set_markup("<span size='18000'>" .. w.result_labels[i].label .. "</span>"  )
      w.submit_buttons[i]:set_visible(false)
      w.next_buttons[i]:set_visible(true)
      
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
