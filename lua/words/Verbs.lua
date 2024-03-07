local shuffle = require("lua.shuffle")
local dir = "lua.words.verbs"

local random = {}

random.list_1 = require(dir .. ".words_1")
random.list_2 = require(dir .. ".words_2")

shuffle(random)

random.all = {}
-- choose a rnaodm list from basic
for key, _ in pairs(random) do
    wordlist = random[key]

    for i = 1, #random[key] do
    	eng = random[key][i][2]
    	az = random[key][i][1]
    	table.insert(random.all, { az, eng })
    end
end

wordlist.all = random.all

return wordlist
