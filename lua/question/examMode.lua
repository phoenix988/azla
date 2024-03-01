local themeModule = require("lua.theme.default")
local font = themeModule.font.load()
local theme = themeModule.load()

local M = {}

function M.exam(wordlist, widget, last, response, replace, list)
    -- Checks if you completed all questions
    local amountComplete = 0
    for i = 1, last do
        local check = widget.entry_fields[i].text:lower()
        if string.match(check, "^%s*$") then
            local trash
        else
            amountComplete = amountComplete + 1
        end
    end

    -- Will skip the prompt if you did answer all questions
    if amountComplete == last then
        question.complete = true
    end

    for i = 1, last do
        local correct = string.lower(wordlist[i][languageNumber_1])
        local word = wordlist[i][languageNumber_2]
        local word = list.to_upper(word)

        local choice = widget.entry_fields[i].text:lower()

        -- Alternative correct answer
        local altCorrect = replace.replace_main(correct)

        -- sets dont run variable
        local dontRun = false

        -- create all the labels imported from respones.lua in this dir
        response.labels(correct, choice, word)
        local correctString = response.correctString
        local correctStringAlt = response.correctStringAlt
        local correctLabel = response.correctLabel
        local incorrectString = response.incorrectString
        local incorrectLabel = response.incorrectLabel

        -- Evaluates if answer is correct
        if choice == correct then
            -- runs the function
            question.correct = question.correct + 1
            local opt = "correct"
            correct_answers = response.main(opt, correctString, widget, i, correctLabel, choice, theme)
        else
            for key, value in pairs(altCorrect) do
                if value == choice then
                    -- runs the function
                    local opt = "correct"
                    response.main(opt, correctStringAlt, widget, i, correctLabel, choice, theme)

                    -- Wont run next statement if this runs
                    dontRun = true
                end
            end
        end -- End of if Statement

        -- Runs if answer is incorrect
        if choice ~= correct and not dontRun then
            question.incorrect = question.incorrect + 1
            -- runs the function
            local opt = "incorrect"
            response.main(opt, incorrectString, widget, i, incorrectLabel, choice, theme)
        elseif dontRun then
            question.correct = question.correct + 1
        end
    end

    return question
end

return M
