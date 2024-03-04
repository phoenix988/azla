-- functions that replace special azerbajani letters with english in my language app
local utf8 = require("lua-utf8")

-- creates empty table
local word = {}

-- letter function
-- create a table with special letters
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
                local update = word.replace_letter(words, match, replace)
                myTable.final = word.replace_letter(myTable.final, match, replace)
                myTable[match] = update
            end
        end
    end

    -- returns the result to be used
    return myTable
end

-- Updated function to generate all kind of variations of letters
-- Containing special letters not in english alphabet
function word.generate_word(word)
    local special_characters = {
        ['ə'] = {'e', 'ə'},
        ['ü'] = {'u', 'ü'},
        ['ö'] = {'o', 'ö'},
        ['ı'] = {'i', 'ı'},
        ['ç'] = {'c', 'ç'},
        ['ğ'] = {'g', 'ğ'},
        ['ş'] = {'s', 'ş'}
    }

    local function replace_char_at_index(str, index, char)
        return utf8.sub(str, 1, index - 1) .. char .. utf8.sub(str, index + 1)
    end

    local variations = {word}
    for i = 1, #word do
        local char = utf8.sub(word, i, i)
        if special_characters[char] then
            local new_variations = {}
            for _, alternative in ipairs(special_characters[char]) do
                for _, variation in ipairs(variations) do
                    table.insert(new_variations, replace_char_at_index(variation, i, alternative))
                end
            end
            variations = new_variations
        end
    end

    return variations
end

return word
