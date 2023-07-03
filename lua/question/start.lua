local widget = require("lua.widgets.init")

local M = {}

function M.start_azla(win,window,create_app2,luaWordsModule)

        local activeWord      = widget.combo.word:get_active()
        local activeWordCount = widget.combo.word_count:get_active()

        local choice       = widget.combo.word_list_model[activeWord][1]
        local choice_count = widget.combo.word_model[activeWordCount][1]

        wordlist = require(luaWordsModule .. "." .. choice)
        wordlist.count = choice_count
        
        -- Gets the window dimeonsions to return them later
        window.width  = win:get_allocated_width()
        window.height = win:get_allocated_height()

        -- Starts the questions
        win:hide()
        
        local app2 = create_app2()
        app2:run()

end

return M
