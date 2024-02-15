local shuffle  = require("lua.shuffle")

local random   = {}

random.list_1  = require("lua.words.fruits.words_1")

shuffle(random)

-- choose a rnaodm list from basic
for key,value in pairs(random) do
    wordlist = random[key]
end

return wordlist
