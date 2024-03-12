local widget = require("lua.widgets.box")
local combo = require("lua.widgets.combo")
local var = require("lua.config.init")
local list = require("lua.terminal.listFiles")
local grid = require("lua.widgets.grid")
local label = require("lua.widgets.label")
local button = require("lua.widgets.button")
local rmdir = require("lua.terminal.mkdir").rmdir

local wordItems = {
	list = list,
	path = var.wordMod,
}

combo.set = combo:new(wordItems)
combo.set:create_remove_wordlist()

local main_grid = grid.main_create()

main_grid:attach(button.remove_wordlist, 0, 3, 50, 1)
main_grid:attach(combo.remove_wordlist, 0, 2, 50, 1)
main_grid:attach(label.remove_wordlist, 0, 1, 50, 1)

widget.box_word_list_2:append(main_grid)

function button.remove_wordlist:on_clicked()
		local num = combo.remove_wordlist:get_active()
		local iter = combo.remove_wordlist:get_active_iter()
		newStr = combo.remove_wordlist_files[num + 1]

		if newStr then
			last = list.modify(newStr)
		end

		combo.remove_wordlist_model:remove(iter)
		rmdir(var.wordDir_alt .. "/" .. last .. ".lua")

		combo.remove_wordlist:set_active(0)

end



