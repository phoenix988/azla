local lgi     = require("lgi")
local Gtk     = lgi.require("Gtk", "4.0")
local theme   = require("lua.theme.default")

local label = {}

    
-- Some labels used on the startup window --START
-- Language Label
label.language = Gtk.Label({ label = "Choose Language you want to write answers in:" })

     -- Word list label
label.word_list = Gtk.Label({ label = "Choose your wordlist",  height_request = 50, })

-- Welcome label for welcome message
label.welcome =  Gtk.Label({ 
                      label = "Welcome to AZLA",
                      width_request = 200,  -- Set the desired width
                      height_request = 100,
                      wrap = true })
label.sept = Gtk.Label({label = ""})

-- Sets size of the labels
label.welcome:set_markup("<span size='" .. theme.label_welcome_size .. "' foreground='" .. theme.label_welcome .. "'>" .. label.welcome.label .. "</span>"  )
label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )
label.language:set_markup("<span size='" .. theme.label_lang_size .. "' foreground='" .. theme.label_lang .. "'>" .. label.language.label .. "</span>"  )
label.sept:set_markup("<span size='40000'>" .. label.sept.label .. "</span>"  )

-- Label --END

return label
