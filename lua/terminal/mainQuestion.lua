local io = require("io")
local os = require("os")
local replace = require("lua.question.replace")
local list = require("lua.terminal.listFiles")

-- Sets questions table
local questions = {}
questions.correct = 0
questions.incorrect = 0

local function asci_art()
    local logo = [[
     .----------------.  .----------------.  .----------------.  .----------------.
    | .--------------. || .--------------. || .--------------. || .--------------. |
    | |      __      | || |   ________   | || |   _____      | || |      __      | |
    | |     /  \     | || |  |  __   _|  | || |  |_   _|     | || |     /  \     | |
    | |    / /\ \    | || |  |_/  / /    | || |    | |       | || |    / /\ \    | |
    | |   / ____ \   | || |     .'.' _   | || |    | |   _   | || |   / ____ \   | |
    | | _/ /    \ \_ | || |   _/ /__/ |  | || |   _| |__/ |  | || | _/ /    \ \_ | |
    | ||____|  |____|| || |  |________|  | || |  |________|  | || ||____|  |____|| |
    | |              | || |              | || |              | || |              | |
    | '--------------' || '--------------' || '--------------' || '--------------' |
     '----------------'  '----------------'  '----------------'  '----------------'
            ]]
    return logo
end

-- Function that lest you choose the amount of words you want
local function select_count(wordlist, colors)
    local last_number = #wordlist
    local choice = last_number + 1
    local first = true
    local words = #wordlist

    if words > 40 then
        words = 40
        last_number = 40
    end

    for i = 1, words do
        print(colors.blue .. i .. colors.reset)
    end

    while choice > last_number do
        if not first then
            os.execute("clear")
            for i = 1, words do
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
        first = false
    end

    return choice
end

-- Main function that creates the questions
function question_main(wordlist, colors, language, word_count)
    os.execute("clear")

    -- Creates neceseary values to use depending on language choice
    if language == "azerbajan" then
        -- Set which language to use
        n_1 = 1
        n_2 = 2
        language = "azerbajani"
    elseif language == "english" then
        -- Set which language to use
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
        local word = list.to_upper(word)

        -- Create ascii art to show in the terminal app
        local art = asci_art()

        -- Asks you the questions
        io.write(
            colors.blue
            .. "\n"
            .. art
            .. colors.blue
            .. "\n\n\n"
            .. colors.blue
            .. "What is "
            .. colors.green
            .. word
            .. colors.blue
            .. " in "
            .. language
            .. ": "
        )

        local choice = io.read()

        -- Sets your answer to all lowercase
        local choice = choice:lower()

        -- Sets alternative correct answer
        local altCorrect = replace.generate_word(correct)

        -- Sets variable that will be set to true if your anser matches
        -- altCorrect
        local dontRun = false

        -- Reset colors
        print(colors.reset)

        -- Calculates if your answer is correct
        if choice == correct then
            io.write(colors.green .. "Congratulations answer is correct!" .. colors.reset)
            io.read()
            os.execute("clear")
            questions.correct = questions.correct + 1

            print(colors.reset)
        else
            for key, value in pairs(altCorrect) do
                if value == choice then
                    io.write(
                        colors.green
                        .. "Great try, answer is partially correct!\nCorrect answer is: "
                        .. correct
                        .. colors.reset
                    )
                    io.read()
                    os.execute("clear")
                    questions.correct = questions.correct + 1
                    dontRun = true
                    break
                end
            end
        end

        if choice ~= correct and not dontRun then
            -- Only runs if your answer is incorrect
            local firstLetter = correct:sub(1, 1):upper()
            local restofword = correct:sub(2)
            local correct = firstLetter .. restofword

            io.write(colors.red .. "Sadly your answer is not correct")
            print("")
            io.write("Correct answer is: " .. correct .. ": \n")
            io.write("Your answer was: " .. choice .. ": " .. colors.reset)
            io.read()
            os.execute("clear")
            questions.incorrect = questions.incorrect + 1

            print(colors.reset)
        end
    end
end -- End of question_main

-- function to return questions
function get_result()
    return questions
end

-- Returns functions to be used
return { question_main = question_main, get_result = getResult, select_count = select_count }
