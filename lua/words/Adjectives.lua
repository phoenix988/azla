local shuffle  = require("lua.shuffle")

local random   = {}

random.list_1  = require("lua.words.adjectives.words_2")
random.list_2  = require("lua.words.adjectives.words_1")

shuffle(random)

random.all = {}
-- choose a rnaodm list from basic

for key,_ in pairs(random) do
    Wordlist = random[key]

	for i = 1, #random[key] do
		eng = random[key][i][2]
		az = random[key][i][1]
		table.insert(random.all, {az, eng})
	end
end

Wordlist.all = random.all

return Wordlist

