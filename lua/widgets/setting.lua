local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local widget            = require("lua.widgets.box")
local setting_default   = require("lua.theme.setting")

local count = 0
local array = {}

-- Creates some empty widget tables
array.theme_labels           = {}
array.theme_labels_setting   = {}
array.grid_widgets_1         = {}
array.grid_widgets_2         = {}
array.grid_widgets_setting   = {}
array.setting_labels         = {}
array.setting_labels_setting = {}

-- Function to create grid layout of theme settings
function array.theme_table(theme)
      
      local theme_table = {}
      for key in pairs(theme) do
        table.insert(theme_table, key)
      end
      table.sort(theme_table)

      -- Creates all the entry boxes for the theme settings
      for _, key in ipairs(theme_table) do
            local value = theme[key]
         
            if count <= 6 then

            array.grid_widgets_1[key] = Gtk.Grid({margin_top = 0})
            -- Makes entry widgets
            array.theme_labels[key] = Gtk.Entry({margin_top = 10, margin_bottom = 20,text = value})

            -- Make label widgets
            array.theme_labels_setting[key] = Gtk.Label({margin_top = 10,label = key})

            array.theme_labels_setting[key]:set_markup("<span foreground='" .. theme.label_fg .. "'size='" .. theme.label_fg_size .. "'>" .. array.theme_labels_setting[key].label .. "</span>")
            array.grid_widgets_1[key]:attach(array.theme_labels[key], 1,1,1,1,  0, 0, 0)
            array.grid_widgets_1[key]:attach(array.theme_labels_setting[key], 1,-10,1,1)
            widget.box_theme:append(array.grid_widgets_1[key])

         end


         if count >= 6 then

            array.grid_widgets_2[key] = Gtk.Grid({margin_top = 0})
            -- Makes entry widgets
            array.theme_labels[key] = Gtk.Entry({margin_top = 10, margin_bottom = 20,text = value})

            -- Make label widgets
            array.theme_labels_setting[key] = Gtk.Label({margin_top = 10,label = key})

            array.theme_labels_setting[key]:set_markup("<span foreground='" .. theme.label_fg .. "'size='" .. theme.label_fg_size .. "'>" .. array.theme_labels_setting[key].label .. "</span>")
            array.grid_widgets_2[key]:attach(array.theme_labels[key], 1,1,1,1,  0, 0, 0)
            array.grid_widgets_2[key]:attach(array.theme_labels_setting[key], 1,-10,1,1)

            widget.box_theme_alt:append(array.grid_widgets_2[key])

         end

         count = count + 1

      end -- end of for loop

      return widget


end

-- Function to create grid layout of regular settings
function array.setting_table(theme)
      local setting_table = {}
      for key in pairs(setting_default) do
        table.insert(setting_table, key)
      end
      table.sort(setting_table)
     
      -- Creates all the entry boxes for some standard setting entry boxes
      for _, key in ipairs(setting_table) do
            local value = setting_default[key]

            array.grid_widgets_setting[key] = Gtk.Grid({margin_top = 0})
            -- Makes entry widgets
            array.setting_labels[key] = Gtk.Entry({margin_top = 10, margin_bottom = 20,text = value})

            -- Make label widgets
            array.setting_labels_setting[key] = Gtk.Label({margin_top = 10,label = key})

            array.setting_labels_setting[key]:set_markup("<span foreground='" .. theme.label_fg .. "'size='" .. theme.label_fg_size .. "'>" .. array.setting_labels_setting[key].label .. "</span>")
            array.grid_widgets_setting[key]:attach(array.setting_labels[key], 1,1,1,1,  0, 0, 0)
            array.grid_widgets_setting[key]:attach(array.setting_labels_setting[key], 1,-10,1,1)
            widget.box_setting:append(array.grid_widgets_setting[key])

       end

       return widget
end



return array
