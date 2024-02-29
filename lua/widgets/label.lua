local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local theme = require("lua.theme.default")
local question = require("lua.question.main")

-- Create the module label
local label = {}

local font = theme.font.load()
local theme = theme.load()

-- Create array to create multiple labels in a table
local restoreList = {
  setting = "setting",
  theme = "theme",
  font = "font",
}


label.text = {
  welcome = "Welcome to AZLA",
  last_text = "You reached the last question",
  aze = "in Azerbajani ?",
  eng = "in English ?",
}

-- Some labels used on the startup window
-- Language Label
label.language = Gtk.Label({ label = "Choose Language you want to write answers in:" })

-- Word list label
label.word_list = Gtk.Label({ label = "Choose your wordlist", height_request = 50 })
label.word_count = Gtk.Label({ label = "Choose word amount", height_request = 50 })

-- Welcome label for welcome message
label.welcome = Gtk.Label({
  label = label.text.welcome,
  width_request = 200, -- Set the desired width
  height_request = 100,
  wrap = true,
})

-- Create some other labels
label.theme = Gtk.Label({ label = "Settings", margin_top = 0 })
label.setting = Gtk.Label({ label = "Standard Settings", margin_top = 0 })
label.theme_color = Gtk.Label({ label = "Colors", margin_bottom = 10 })
label.theme_apply =
    Gtk.Label({ label = "Applied new settings. Please restart the app", margin_top = 40, visible = false })
label.theme_nochange = Gtk.Label({ label = "No change made", margin_top = 40, visible = false })

label.current_color_scheme = Gtk.Label()
label.current_color_scheme:set_margin_bottom(120)

-- Create theme_restore labels
label.theme_restore = {}
for key, value in pairs(restoreList) do
  label.theme_restore[key] = question.create_label({
    {
      attributes = "foreground='" .. theme.label_fg .. "'size='" .. font.fg_size .. "' ",
      text = "Restored to default settings",
    },
  })

  label.theme_restore[key]:set_visible(false)
  label.theme_restore[key]:set_margin_top(20)
end

-- Sets size and colors of the labels
label.welcome:set_markup(
  "<span size='"
  .. font.welcome_size
  .. "' foreground='"
  .. theme.label_welcome
  .. "'>"
  .. label.welcome.label
  .. "</span>"
)
label.word_list:set_markup(
  "<span size='"
  .. font.word_size
  .. "' foreground='"
  .. theme.label_word
  .. "'>"
  .. label.word_list.label
  .. "</span>"
)
label.word_count:set_markup(
  "<span size='"
  .. font.word_size
  .. "' foreground='"
  .. theme.label_word
  .. "'>"
  .. label.word_count.label
  .. "</span>"
)
label.language:set_markup(
  "<span size='"
  .. font.lang_size
  .. "' foreground='"
  .. theme.label_lang
  .. "'>"
  .. label.language.label
  .. "</span>"
)
label.theme:set_markup(
  "<span size='" .. font.welcome_size .. "' foreground='" .. theme.label_fg .. "'>" .. label.theme.label .. "</span>"
)
label.setting:set_markup(
  "<span size='"
  .. font.welcome_size
  .. "' foreground='"
  .. theme.label_fg
  .. "'>"
  .. label.setting.label
  .. "</span>"
)
label.theme_nochange:set_markup(
  "<span size='"
  .. font.welcome_size
  .. "' foreground='"
  .. theme.label_incorrect
  .. "'>"
  .. label.theme_nochange.label
  .. "</span>"
)
label.theme_apply:set_markup(
  "<span size='"
  .. font.fg_size
  .. "' foreground='"
  .. theme.label_correct
  .. "'>"
  .. label.theme_apply.label
  .. "</span>"
)

function label.end_create()
  -- Creates some labels to show at the end
  local M = {}

  -- Make end Labels
  M.labelEnd = question.create_label({
    {
      attributes = "foreground='" .. theme.label_fg .. "'size='" .. font.fg_size .. "'",
      text = label.text.last_text,
    },
  })

  M.labelEnd:set_visible(false)
  -- Counts correct answers
  M.labelEndCorrect = Gtk.Label()
  -- Counts incorrect answers
  M.labelEndIncorrect = Gtk.Label()

  return M
end

function label.summary_create()
  label.summary = question.create_label({
    {
      attributes = "weight='bold' size='" .. font.welcome_size .. "' foreground='" .. theme.label_question .. "'",
      text = "Summary",
    },
  })
end

return label
