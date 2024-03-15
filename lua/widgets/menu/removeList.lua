local widget = require("lua.widgets.box")
local combo = require("lua.widgets.combo")
local var = require("lua.config.init")
local list = require("lua.terminal.listFiles")
local grid = require("lua.widgets.grid")
local label = require("lua.widgets.label")
local button = require("lua.widgets.button")
local rmdir = require("lua.terminal.mkdir").rmdir
local update = require("lua.theme.update")

-- Table to pass on to the combo functions
local wordItems = {
	list = list,
	path = var.wordMod,
}

-- Create the combo boxes
combo.set = combo:new(wordItems)
combo.set:create_remove_wordlist()
combo.set:create_remove_restore_list()

local main_grid = grid.main_create()

-- Attach widget to the grid
main_grid:attach(button.remove_wordlist, 0, 3, 50, 1)
main_grid:attach(combo.remove_wordlist, 0, 2, 50, 1)
main_grid:attach(label.remove_wordlist, 0, 1, 50, 1)
main_grid:attach(combo.remove_restore_list, 0, 5, 50, 1)
main_grid:attach(label.remove_restore_list, 0, 4, 50, 1)
main_grid:attach(button.remove_restore_list, 0, 6, 50, 1)

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

	update.update_word_list()
end

function button.remove_restore_list:on_clicked()
	local num = combo.remove_restore_list:get_active()
	local iter = combo.remove_restore_list:get_active_iter()
	newStr = combo.restore_files[num + 1]

	if newStr then
		last = list.modify(newStr)
	end

	combo.remove_restore_list_model:remove(iter)
	rmdir(var.cacheDir .. "/" .. last .. ".json")

	combo.remove_restore_list:set_active(0)

	combo.clear_model(combo.restore_list)
	combo.clear_model(combo.remove_restore_list)
	-- Add the new files to the combo.restore_files table (Important)
	combo.restore_files = combo.add_files(combo.restore_list_model, var.cacheDir, "json")
	combo.remove_restore_files = combo.add_files(combo.remove_restore_list_model, var.cacheDir, "json")
end
