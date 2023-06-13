-- Imports libaries we need
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")
local theme             = require("lua.theme.default")

local button = {}
local home   = os.getenv("HOME")

-- Create the start button
button.start = Gtk.Button({label = "Start", width_request = 100})

-- Create the Exit button
button.exit = Gtk.Button({label = "Exit", width_request = 100, })
button.exit_alt = Gtk.Button({label = "Exit", width_request = 100, })

button.setting = Gtk.Button ({label = "Settings", margin_bottom = 20})
button.setting_back = Gtk.Button ({label = "Back", margin_top = 8})
button.setting_submit = Gtk.Button ({label = "Apply", margin_top = 8})

-- Makes result button to show your result
button.result = Gtk.Button({label = "Show Result", visible = true})

function button.click_action(widget, image2, label, theme, setting_default,theme_labels,write_theme,write_setting,setting_labels)
  -- Creates the setting button click event
  function button.setting:on_clicked()
  
      widget.box_theme_main:set_visible(true)
      widget.box_theme:set_visible(true)
      widget.box_theme_alt:set_visible(true)
      widget.box_theme_button:set_visible(true)
      widget.box_setting:set_visible(true)
      widget.box_third:set_visible(true)
      widget.box_second:set_visible(true)
      widget.box_first:set_visible(false)
      widget.box_second:set_halign(Gtk.Align.CENTER)
      widget.box_main:set_orientation(Gtk.Orientation.VERTICAL)
      image2:set_visible(true)
  
      button.setting:set_visible(false)
  
  end

      -- Creates the back button function
  function button.setting_back:on_clicked()

          widget.box_theme:set_visible(false)
          widget.box_theme_alt:set_visible(false)
          widget.box_theme_main:set_visible(false)
          widget.box_theme_button:set_visible(false)
          widget.box_theme_label:set_visible(false)
          label.theme_apply:set_visible(false)
          widget.box_third:set_visible(false)
          widget.box_second:set_visible(true)
          widget.box_first:set_visible(true)
          button.setting:set_visible(true)
          widget.box_main:set_spacing(10)
          widget.box_main:set_orientation(Gtk.Orientation.VERTICAL)
          widget.box_second:set_halign(Gtk.Align.FILL)
          image2:set_visible(false)

  end


  function button.setting_submit:on_clicked()
         local apply         = {}
         local apply_setting = {}

         for key, value in pairs(theme) do
      
            local theme_choice = theme_labels[key].text:lower()

            apply[key] = theme_choice

         end

          write_theme(home .. "/.config/azla.lua", apply, theme)

         for key, value in pairs(setting_default) do
      
            local setting_choice =  setting_labels[key].text:lower()

            apply_setting[key] = setting_choice

         end

          write_setting(home .. "/.config/azla.lua", apply_setting, apply)
          label.theme_apply:set_visible(true)

  end




end



return button
    

