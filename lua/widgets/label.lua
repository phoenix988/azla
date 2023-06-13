local lgi     = require("lgi")
local Gtk     = lgi.require("Gtk", "4.0")
local theme   = require("lua.theme.default")

local label = {}

    
-- Some labels used on the startup window --START
-- Language Label
label.language = Gtk.Label({ label = "Choose Language you want to write answers in:" })

-- Word list label
label.word_list  = Gtk.Label({ label = "Choose your wordlist",  height_request = 50, })
label.word_count = Gtk.Label({ label = "Choose word amount", height_request = 50})

-- Welcome label for welcome message
label.welcome =  Gtk.Label({ 
                      label = "Welcome to AZLA",
                      width_request = 200,  -- Set the desired width
                      height_request = 100,
                      wrap = true })

label.sept = Gtk.Label({label = ""})


label.theme = Gtk.Label({label = "Theme Settings", margin_top = 0})
label.setting = Gtk.Label({label = "Standard Settings", margin_top = 0})
label.theme_apply = Gtk.Label({label = "Applied new settings. Please restart the app", margin_top = 40,visible = false})
label.theme_nochange = Gtk.Label({label = "No change made", margin_top = 40,visible = false})


-- Sets size and colors of the labels
label.welcome:set_markup("<span size='" .. theme.label_welcome_size .. "' foreground='" .. theme.label_welcome .. "'>" .. label.welcome.label .. "</span>"  )
label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )
label.word_count:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_count.label .. "</span>"  )
label.language:set_markup("<span size='" .. theme.label_lang_size .. "' foreground='" .. theme.label_lang .. "'>" .. label.language.label .. "</span>"  )
label.theme:set_markup("<span size='" .. theme.label_welcome_size .. "' foreground='" .. theme.label_fg .. "'>" .. label.theme.label .. "</span>"  )
label.theme_nochange:set_markup("<span size='" .. theme.label_welcome_size .. "' foreground='" .. theme.label_incorrect .. "'>" .. label.theme_nochange.label .. "</span>"  )
label.theme_apply:set_markup("<span size='" .. theme.label_welcome_size .. "' foreground='" .. theme.label_correct .. "'>" .. label.theme_apply.label .. "</span>"  )
label.sept:set_markup("<span size='40000'>" .. label.sept.label .. "</span>"  )

-- Label --END

return label
