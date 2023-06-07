local os                = require("os")

-- Function to Shuffle the wordlist array
local function shuffle(wordlist)

    local rand = math.random
    local iterations = #wordlist

    for i = iterations, 2, -1 do
        local j = rand(i)
        wordlist[i], wordlist[j] = wordlist[j], wordlist[i]
    end
end
      
return shuffle
