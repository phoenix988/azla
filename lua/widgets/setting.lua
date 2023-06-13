local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local widget            = require("lua.widgets.box")

local count = 0
local array = {}

function array.theme_table(theme,grid_widgets,theme_labels,theme_labels_setting,grid_widgets_2)
      
      local theme_table = {}
      for key in pairs(theme) do
        table.insert(theme_table, key)
      end
      table.sort(theme_table)

      -- Creates all the entry boxes for the theme settings
      for _, key in ipairs(theme_table) do
            local value = theme[key]
         
            if count <= 6 then

            grid_widgets[key] = Gtk.Grid({margin_top = 0})
            -- Makes entry widgets
            theme_labels[key] = Gtk.Entry({margin_top = 10, margin_bottom = 20,text = value})

            -- Make label widgets
            theme_labels_setting[key] = Gtk.Label({margin_top = 10,label = key})

            theme_labels_setting[key]:set_markup("<span foreground='" .. theme.label_fg .. "'size='" .. theme.label_fg_size .. "'>" .. theme_labels_setting[key].label .. "</span>")
            grid_widgets[key]:attach(theme_labels[key], 1,1,1,1,  0, 0, 0)
            grid_widgets[key]:attach(theme_labels_setting[key], 1,-10,1,1)
            widget.box_theme:append(grid_widgets[key])

         end


         if count >= 6 then

            grid_widgets_2[key] = Gtk.Grid({margin_top = 0})
            -- Makes entry widgets
            theme_labels[key] = Gtk.Entry({margin_top = 10, margin_bottom = 20,text = value})

            -- Make label widgets
            theme_labels_setting[key] = Gtk.Label({margin_top = 10,label = key})

            theme_labels_setting[key]:set_markup("<span foreground='" .. theme.label_fg .. "'size='" .. theme.label_fg_size .. "'>" .. theme_labels_setting[key].label .. "</span>")
            grid_widgets_2[key]:attach(theme_labels[key], 1,1,1,1,  0, 0, 0)
            grid_widgets_2[key]:attach(theme_labels_setting[key], 1,-10,1,1)

            widget.box_theme_alt:append(grid_widgets_2[key])

         end

         count = count + 1

      end -- end of for loop


end

function array.setting_table(theme,grid_widgets_setting,setting_labels,setting_labels_setting,setting_default)
      local setting_table = {}
      for key in pairs(setting_default) do
        table.insert(setting_table, key)
      end
      table.sort(setting_table)
     
      -- Creates all the entry boxes for some standard setting entry boxes
      for _, key in ipairs(setting_table) do
            local value = setting_default[key]

            grid_widgets_setting[key] = Gtk.Grid({margin_top = 0})
            -- Makes entry widgets
            setting_labels[key] = Gtk.Entry({margin_top = 10, margin_bottom = 20,text = value})

            -- Make label widgets
            setting_labels_setting[key] = Gtk.Label({margin_top = 10,label = key})

            setting_labels_setting[key]:set_markup("<span foreground='" .. theme.label_fg .. "'size='" .. theme.label_fg_size .. "'>" .. setting_labels_setting[key].label .. "</span>")
            grid_widgets_setting[key]:attach(setting_labels[key], 1,1,1,1,  0, 0, 0)
            grid_widgets_setting[key]:attach(setting_labels_setting[key], 1,-10,1,1)
            widget.box_setting:append(grid_widgets_setting[key])

       end
end



return array
