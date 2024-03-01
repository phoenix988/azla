-- functions that replace special azerbajani letters with english in my language app

-- creates empty table
local word = {}

-- letter function
function word.letters()
    local list = {}
    list.U = { { "ü", "u" } }
    list.S = { { "ş", "s" } }
    list.C = { { "ç", "c" } }
    list.O = { { "ö", "o" } }
    list.G = { { "ğ", "g" } }
    list.I = { { "ı", "i" } }
    list.E = { { "ə", "e" } }

    return list
end

-- Function that replace the letters
-- Will be called inside the main function
function word.replace_letter(word, letters, replace)
    local catch = string.match(word, letters)

    if catch ~= nil then
        update = string.gsub(word, letters, replace)
        -- returns all to lowercase
        update = string.lower(update)
    end

    return update
end

-- Function to set special letters to lowercase
-- Which is not detected by lower method
function word.lower_case(word)
    -- Function that replace the letters
    -- Will be called inside the main function

    -- local function to replace letters
    local function replace_letter(word, letters, replace)
        local catch = string.match(word, letters)

        if catch ~= nil then
            update = string.gsub(word, letters, replace)
            -- returns all to lowercase
            update = string.lower(update)
        end

        return update
    end

    -- List of letters
    local list = {}
    list.U = { { "Ü", "ü" } }
    list.S = { { "Ş", "ş" } }
    list.C = { { "Ç", "ç" } }
    list.O = { { "Ö", "ö" } }
    list.G = { { "Ğ", "ğ" } }
    list.I = { { "I", "ı" } }
    list.E = { { "Ə", "ə" } }

    -- loops through all the letter tables
    for key, value in pairs(list) do
        for i = 1, #list[key] do
            local match = string.match(word, list[key][i][1])
            local replace = list[key][i][2]
            if match ~= nil then
                local update = replace_letter(word, match, replace)
                return update
            else
                local noChange = string.lower(word)
            end
        end
    end


end

-- main function to run in order to loop through the word
-- and replace all the letters
function word.replace_main(words)
    -- calls the word.letter function to get the list of all letters
    local letters = word.letters()

    -- update the words variable with final
    local myTable = {}
    myTable.final = words

    -- loops through all the letter tables
    for _, value in pairs(letters) do
        -- Loops through all the letters
        for i = 1, #value do
            local match = string.match(words, value[i][1])
            local replace = value[i][2]

            -- If letter match then it will go ahead and replace it
            if match ~= nil then
                local continue = occurence

                local update = word.replace_letter(words, match, replace)
                myTable.final = word.replace_letter(myTable.final, match, replace)
                myTable[match] = update
            end
        end
    end

    -- returns the result to be used
    return myTable
end

function word.count(words)
    local letter = word.letters()
    local count = 0
    local searchPosition = 1
    local myTable = {}

    for _, value in pairs(letter) do
        for i = 1, #value do
            while true do
                local foundPosition = string.find(words, value[i][1], searchPosition, true)
                if foundPosition then
                    count = count + 1
                    searchPosition = foundPosition + 1
                else
                    myTable[value[i][2]] = count
                    count = 0
                    searchPosition = 1
                    break
                end
            end
        end
    end

    return myTable
end

return word
