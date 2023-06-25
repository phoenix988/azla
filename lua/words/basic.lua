local shuffle  = require("lua.shuffle")

local random   = {}

random.list_1  = require("lua.words.basic.words_2")
random.list_2  = require("lua.words.basic.words_1")

shuffle(random)

-- choose a rnaodm list from basic
for key,value in pairs(random) do
    wordlist = random[key]
end

return wordlist

