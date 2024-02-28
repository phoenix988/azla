local shuffle  = require("lua.shuffle")
local dir      = "lua.words.food"

local random   = {}

random.list_1  = require(dir .. ".words_1")
random.list_2  = require(dir .. ".words_2")
random.list_2  = require(dir .. ".words_3")

shuffle(random)

-- choose a rnaodm list from basic
for key,_ in pairs(random) do
    wordlist = random[key]
end

return wordlist

