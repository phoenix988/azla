local shuffle  = require("lua.shuffle")

local random   = {}

random.list_1  = require("lua.words.nouns.words_1")
random.list_2  = require("lua.words.nouns.words_2")

shuffle(random)

-- choose a rnaodm list from basic
for key,_ in pairs(random) do
    wordlist = random[key]
end

return wordlist
