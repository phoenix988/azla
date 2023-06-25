local shuffle  = require("lua.shuffle")
local dir      = "lua.words.verbs"

local random   = {}

random.list_1  = require(dir .. ".words_1")
random.list_2  = require(dir .. ".words_2")

shuffle(random)

-- choose a rnaodm list from basic
for key,value in pairs(random) do
    wordlist = random[key]
end

return wordlist

