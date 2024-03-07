local shuffle  = require("lua.shuffle")

local random   = {}

random.list_1  = require("lua.words.fruits.words_1")

shuffle(random)

random.all = {}
-- choose a rnaodm list from basic
for key,_ in pairs(random) do
    wordlist = random[key]

	for i = 1, #random[key] do
		eng = random[key][i][2]
		az = random[key][i][1]
		table.insert(random.all, {az, eng})
	end
end

wordlist.all = random.all

return wordlist
