local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local theme             = require("lua.theme.default")
local theme             = theme.load()

local css = {}

css.provider = Gtk.CssProvider()

css.button = string.format([[
          .button {
              font-size: %dpx;
              color: %s;
              border-color: %s;
              border-width: 1px;
          }
         ]], theme.label_fg_size / 1000, theme.label_word, theme.label_word)


 -- Load the CSS style rule into the CSS provider
css.provider:load_from_data(css.button, #css.button)


return css
