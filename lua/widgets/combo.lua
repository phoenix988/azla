-- Importing modules we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local label = require("lua.widgets.label")
local style = require("lua.widgets.setting")
local fileExist = require("lua.fileExist")
local loadConfig = require("lua.loadConfig").load_config
local theme = require("lua.theme.default").load()
local font = require("lua.theme.default").font.load()
local var = require("lua.config.init")

-- Here we are defining some combo boxes to create
-- Import some methods and functions for combo boxes
local combo = require("lua.widgets.combo.value")

-- Creates combo class
function combo:new(inp)
    local obj = {}       -- Create a new instance
    obj.app = inp        -- Set instance-specific attributes
    setmetatable(obj, self) -- Set the metatable to allow accessing class methods
    self.__index = self  -- Set the index to the class table
    return obj           -- Return the instance
end

-- Create wordlist box
function combo:create_word_list()
    local list = self.app.list

    -- Model for the second combo box
    combo.word_list_model = Gtk.ListStore.new({ GObject.Type.STRING })

    -- Calls the getluafilesdirectory function
    local directoryPath = self.app.path
    local luaFiles = list.dir(directoryPath)
    local dontAdd = {}
    if var.wordDir_alt ~= nil then
        if fileExists(var.wordDir_alt) then
            luaFiles_alt = list.dir(var.wordDir_alt)
        end
    end

    combo.word_files = luaFiles

    -- Add items to the wordfile combo box
    for _, luafiles in ipairs(combo.word_files) do
        local add = list.modify(luafiles)

        local wordDir_alt = var.wordDir_alt .. "/" .. add .. ".lua"
        if fileExists(wordDir_alt) then
            combo.word_list_model:append({ add })
        else
            combo.word_list_model:append({ add })
        end

        dontAdd[add] = add
    end

    for _, luafiles in ipairs(luaFiles_alt) do
        local add = list.modify(luafiles)
        if not dontAdd[add] then
            local success, result = pcall(function()
                test_wordlist = loadConfig(var.wordDir_alt .. "/" .. add .. ".lua")
            end)
            if #test_wordlist ~= 0 then
                combo.word_list_model:append({ add })
                table.insert(combo.word_files, luafiles)
            end
        end
    end

    -- Makes the combobox widget for wordlists
    combo.word = Gtk.ComboBox({
        model = combo.word_list_model,
        active = 0,
        cells = {
            {
                Gtk.CellRendererText(),
                { text = 1 },
                align = Gtk.Align.START,
            },
        },
    })

    combo.word = style.set_theme(
        combo.word,
        { { size = font.fg_size / 1000, color = theme.label_fg, border_color = theme.label_fg } }
    )

end

-- Create word count box
function combo:create_word_count()
    combo.word_model = Gtk.ListStore.new({ GObject.Type.STRING })

    -- Makes the combobox widgets
    combo.word_count = Gtk.ComboBox({
        model = combo.word_model,
        active = 0,
        cells = {
            {
                Gtk.CellRendererText(),
                { text = 1 },
                align = Gtk.Align.START,
            },
        },
    })

    combo.word_count = style.set_theme(
        combo.word_count,
        { { size = font.fg_size / 1000, color = theme.label_fg, border_color = theme.label_fg } }
    )
end

-- Create the language combo box
function combo:create_lang()
    -- Define language options for language combo box
    combo.lang_items = {
        "Azerbaijan",
        "English",
    }

    combo.lang_model = Gtk.ListStore.new({ GObject.Type.STRING })

    -- Add the items to the language model
    for _, name in ipairs(combo.lang_items) do
        combo.lang_model:append({ name })
    end

    combo.lang = Gtk.ComboBox({
        model = combo.lang_model,
        active = 0,
        cells = {
            {
                Gtk.CellRendererText(),
                { text = 1 },
                align = Gtk.Align.START,
            },
        },
    })

    combo.lang = style.set_theme(
        combo.lang,
        { { size = font.fg_size / 1000, color = theme.label_fg, border_color = theme.label_fg } }
    )
end

-- Create word dir combobox (Not used)
function combo:create_word_dir()
    local list = self.app.list

    -- Model for the second combo box
    combo.word_dir_model = Gtk.ListStore.new({ GObject.Type.STRING })

    -- Calls the getluafilesdirectory function
    local directoryPath = "lua/words_test"
    local luaFiles = list.dir(directoryPath, "dir")
    combo.word_dir_files = luaFiles

    -- Add items to the wordfile combo box
    for _, luafiles in ipairs(combo.word_dir_files) do
        local add = list.modify_dir(luafiles)
        combo.word_dir_model:append({ add })
    end

    -- Makes the combobox widget for wordlists
    combo.word_dir = Gtk.ComboBox({
        model = combo.word_dir_model,
        active = 0,
        cells = {
            {
                Gtk.CellRendererText(),
                { text = 1 },
                align = Gtk.Align.START,
            },
        },
    })

    return combo.word_dir
end

function combo:create_restore_list()
    local list = self.app.list
    -- Model for the second combo box
    combo.restore_list_model = Gtk.ListStore.new({ GObject.Type.STRING })

    local directoryPath = var.cacheDir
    local luaFiles = list.dir(directoryPath, "json")

    combo.restore_files = luaFiles

    for _, luafiles in ipairs(combo.restore_files) do
        local add = list.modify(luafiles)
        combo.restore_list_model:append({ add })
    end

    combo.restore_list = Gtk.ComboBox({
        model = combo.restore_list_model,
        active = 0,
        cells = {
            {
                Gtk.CellRendererText(),
                { text = 1 },
                align = Gtk.Align.START,
            },
        },
    })

    combo.restore_list = style.set_theme(
        combo.restore_list,
        { { size = font.fg_size / 1000, color = theme.label_fg, border_color = theme.label_fg } }
    )


end

function combo:create_remove_wordlist()
    local list = self.app.list
    -- Model for the second combo box
    combo.remove_wordlist_model = Gtk.ListStore.new({ GObject.Type.STRING })

    local directoryPath = var.wordDir_alt
    local luaFiles = list.dir(directoryPath)

    combo.remove_wordlist_files = luaFiles

    for _, luafiles in ipairs(combo.remove_wordlist_files) do
        local add = list.modify(luafiles)
        combo.remove_wordlist_model:append({ add })
    end

    combo.remove_wordlist = Gtk.ComboBox({
        model = combo.remove_wordlist_model,
        active = 0,
        cells = {
            {
                Gtk.CellRendererText(),
                { text = 1 },
                align = Gtk.Align.START,
            },
        },
    })

    combo.remove_wordlist = style.set_theme(
        combo.remove_wordlist,
        { { size = font.fg_size / 1000, color = theme.label_fg, border_color = theme.label_fg } }
    )

end


return combo
