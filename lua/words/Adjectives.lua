local shuffle  = require("lua.shuffle")

local random   = {}

random.list_1  = require("lua.words.adjectives.words_2")
random.list_2  = require("lua.words.adjectives.words_1")

shuffle(random)

-- choose a rnaodm list from basic
for key,_ in pairs(random) do
    Wordlist = random[key]
end

return Wordlist

