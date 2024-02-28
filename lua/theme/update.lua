-- Update function to update the theme of the app
-- mainly for live update and restore default value

local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local label = require("lua.widgets.label")
local array = require("lua.widgets.setting")
local theme = require("lua.theme.default")
local setting = require("lua.theme.setting")
local var = require("lua.config.init")
local write = require("lua.config.init")
local GLib = require("lgi").GLib
local treeView = require("lua.widgets.button.treeView")

-- Imports string functions
local list = require("lua.terminal.listFiles")

local confPath = var.customConfig
local confDir = var.confDir

local M = {}

-- Function to update your theme while the app is running
function M.live(theme)
   local themeModule = require("lua.theme.default")
   local font = themeModule.font.load()
   local setting = require("lua.theme.setting").load()

   -- Update widget properties based on the new settings
   label.welcome:set_text(label.text.welcome)
   label.welcome:set_markup(
      "<span size='"
      .. font.welcome_size
      .. "' foreground='"
      .. theme.label_welcome
      .. "'>"
      .. label.welcome.label
      .. "</span>"
   )

   -- Update other widgets as needed

   --- Updating labels
   label.theme:set_text("Settings")
   label.theme:set_markup(
      "<span size='"
      .. font.welcome_size
      .. "' foreground='"
      .. theme.label_fg
      .. "'>"
      .. label.theme.label
      .. "</span>"
   )

   label.theme_apply:set_text("Applied new settings. Please restart the app")
   label.theme_apply:set_markup(
      "<span size='"
      .. font.fg_size
      .. "' foreground='"
      .. theme.label_correct
      .. "'>"
      .. label.theme_apply.label
      .. "</span>"
   )

   for key, value in pairs(label.theme_restore) do
      label.theme_restore[key]:set_text("Restored to default settings")
      label.theme_restore[key]:set_markup(
         "<span size='"
         .. font.fg_size
         .. "' foreground='"
         .. theme.label_fg
         .. "'>"
         .. label.theme_restore[key].label
         .. "</span>"
      )
   end

   label.word_list:set_text("Choose your wordlist")
   label.word_list:set_markup(
      "<span size='"
      .. font.word_size
      .. "' foreground='"
      .. theme.label_word
      .. "'>"
      .. label.word_list.label
      .. "</span>"
   )

   label.language:set_text("Choose Language you want to write answers in:")
   label.language:set_markup(
      "<span size='"
      .. font.lang_size
      .. "' foreground='"
      .. theme.label_lang
      .. "'>"
      .. label.language.label
      .. "</span>"
   )

   label.word_count:set_text("Choose word amount")
   label.word_count:set_markup(
      "<span size='"
      .. font.word_size
      .. "' foreground='"
      .. theme.label_word
      .. "'>"
      .. label.word_count.label
      .. "</span>"
   )

   -- Updates theme labels
   for key, value in pairs(theme) do
      -- Removes the seperator and add a space instead
      local labelValue = string.gsub(key, "_", " ")
      local labelValue = list.to_upper(labelValue)

      -- Updates the labels and values
      array.theme_labels_setting[key]:set_text(labelValue)
      array.theme_labels_setting[key]:set_markup(
         "<span foreground='"
         .. theme.label_fg
         .. "'size='"
         .. font.fg_size
         .. "'>"
         .. array.theme_labels_setting[key].label
         .. "</span>"
      )
   end

   -- Updates setting labels
   for key, value in pairs(setting) do
      -- Removes the seperator and add a space instead
      local labelValue = string.gsub(key, "_", " ")
      local labelValue = string.gsub(labelValue, "default ", "")
      local labelValue = list.to_upper(labelValue)

      -- Updates the labels and values
      array.theme_labels_setting[key]:set_text(labelValue)
      array.theme_labels_setting[key]:set_markup(
         "<span foreground='"
         .. theme.label_fg
         .. "'size='"
         .. font.fg_size
         .. "'>"
         .. array.theme_labels_setting[key].label
         .. "</span>"
      )
      array.setting_labels[key]:set_text(value)
   end

   for key, value in pairs(font) do
      -- Removes the seperator and add a space instead
      local labelValue = string.gsub(key, "_", " ")
      local labelValue = list.to_upper(labelValue)

      -- Updates the labels and values
      array.theme_labels_setting[key]:set_text(labelValue)
      array.theme_labels_setting[key]:set_markup(
         "<span foreground='"
         .. theme.label_fg
         .. "'size='"
         .. font.fg_size
         .. "'>"
         .. array.theme_labels_setting[key].label
         .. "</span>"
      )
      local value = value / 1000
      local value = tostring(value):gsub("%.0+$", "")
      array.theme_labels[key]:set_value(value)
   end

   -- Update treeview widget
   treeView.tree = array.set_theme(
      treeView.tree,
      { { size = font.fg_size / 1000, color = theme.label_word, border_color = theme.label_fg } }
   )

   -- Get active value of the treeview
   local selection = treeView.tree:get_selection()
   local model, iter = selection:get_selected()
   if model and iter then
      local value = model:get_value(iter, 0) -- Assuming the value is in column 0
      stringValue = value:get_string()   -- Convert value to string
   end

   -- Update color scheme label
   label.current_color_scheme:set_text("Current theme is: " .. stringValue)
   label.current_color_scheme:set_markup(
      "<span size='"
      .. font.fg_size
      .. "' foreground='"
      .. theme.label_word
      .. "'>"
      .. label.current_color_scheme.label
      .. "</span>"
   )
end

-- Restore default settings
function M.restore(arg)
   local setting_default = {
      default_width = 1200,
      default_height = 1000,
      image = "/opt/azla/images/flag.jpg",
   }

   if arg == "theme" then -- Restore to default theme
      local theme_default = theme.theme_default
      local font = theme.font.load()
      local theme = theme.load()
      local setting = require("lua.theme.setting")
      local setting = setting.load()

      write.write.config.theme(confPath, theme_default, theme, setting, font)

      label.theme_restore.theme:set_visible(true)

      local timer_id
      timer_id = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 4, function()
         label.theme_restore.theme:set_visible(false)
         return false -- Return false to stop the timer after executing once
      end)

      for key, value in pairs(theme_default) do
         local value = theme_default[key]
         local match = string.match(value, "#")

         if match then
            local defaultColor = array.hashToRGBA(value)

            array.theme_labels[key]:set_rgba(defaultColor)
         end
      end

      M.live(theme_default)
   elseif arg == "setting" then -- restore standard settings
      local setting = require("lua.theme.setting")
      local font = theme.font.load()
      local theme = theme.load()
      local setting = setting.load()

      write.write.config.setting(confPath, setting_default, theme, font)

      label.theme_restore.setting:set_visible(true)

      local timer_id
      timer_id = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 4, function()
         label.theme_restore.setting:set_visible(false)
         return false -- Return false to stop the timer after executing once
      end)

      M.live(theme)
   elseif arg == "font" then -- Restore font settings
      local font_default = theme.font.font_default
      local theme = theme.load()
      local setting = require("lua.theme.setting")
      local setting = setting.load()

      write.write.config.theme(confPath, theme, theme, setting, font_default)

      label.theme_restore.font:set_visible(true)

      local timer_id
      timer_id = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 4, function()
         label.theme_restore.font:set_visible(false)
         return false -- Return false to stop the timer after executing once
      end)

      M.live(theme)
   end
end

return M
