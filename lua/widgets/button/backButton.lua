
local M = {}

function M.back(currentQuestion,question,window_alt,win,import,mainWin)
        local json = require("lua.question.save")

        -- Resets the variables that keep tracks of current 
        -- question and correct answers
        question.correct = 0
        question.incorrect = 0

        question.jsonSettings.count_start = question.count_start

        -- Make these variables empty to avoid stacking
        question.label_correct = nil
        question.label_incorrect = nil
      
        window_alt.windowState    = win:is_fullscreen()
        window_alt.windowStateMax = win:is_maximized()
        
        json.saveSession(question.jsonSettings)
        
        question.jsonSettings = {}

        -- resets current question
        question.current = 0
        currentQuestion = 1  -- Start from the first question 

        import.setQuestion(currentQuestion)
        
        win:destroy()
        mainWin:activate()

end

return M
