local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local Gdk = require("lgi").Gdk
local widget = require("lua.widgets.box")
local list = require("lua.terminal.listFiles")

-- Import settings
local setting_default = require("lua.theme.setting").load()

-- Create empty table
local array = {}

-- Creates some empty widget tables
array.theme_labels = {}
array.theme_labels_setting = {}
array.setting_labels = {}
array.restore_button = {}


-- Function to convert hash to Gdk.RGBA color
local function hashToRGBA(hash)
    -- Remove the '#' character from the beginning of the hash
    local trimmedHash = string.sub(hash, 2)

    -- Convert the trimmed hash to individual RGB values
    local red = tonumber(string.sub(trimmedHash, 1, 2), 16) / 255
    local green = tonumber(string.sub(trimmedHash, 3, 4), 16) / 255
    local blue = tonumber(string.sub(trimmedHash, 5, 6), 16) / 255

    -- Create a Gdk.RGBA object and set the color components
    local color = Gdk.RGBA()
    color.red = red
    color.green = green
    color.blue = blue
    color.alpha = 1.0

    return color
end

-- Exports the hashtoRGBA function
array.hashToRGBA = hashToRGBA

-- Function to set some css style to widgets
function array.set_theme(widget, style)
    -- Create style table if its empty
    if style == nil then
        style = {}
    end

    -- Sets default value
    style.color = style.color or "#ffffff"

    style.border_color = style.border_color or "#8fc1c3"

    style.size = style.size or 16

    local style_context = widget:get_style_context()
    local css_provider = Gtk.CssProvider()

    for i, style in ipairs(style) do
        css = string.format(
            [[
          .style {
              font-size: %dpx;
              color: %s;
              border-color: %s;
              border-width: 1px;
          }
         ]],
            style.size,
            style.color,
            style.border_color
        )
    end

    -- If css is empty then it will create the table
    if css == nil then
        css = string.format(
            [[
          .style {
              font-size: %dpx;
              color: %s;
              border-color: %s;
              border-width: 1px;
          }
        ]],
            style.size,
            style.color,
            style.border_color
        )
    end

    -- Load the CSS style rule into the CSS provider
    css_provider:load_from_data(css, #css)

    -- Add the CSS provider to the style context of the Entry widget
    style_context:add_provider(css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

    -- Apply the CSS class to the Entry widget
    widget:get_style_context():add_class("style")

    return widget
end

-- Function to create grid layout of theme settings
function array.theme_table(theme, font)
    local button = require("lua.widgets.button")
    local update = require("lua.theme.update")
    local restoreButton = button.reset_create()
    array.restore_button.theme = restoreButton

    -- Creates empty tables
    local theme_table = {}
    local colorTable = {}

    for key in pairs(theme) do
        table.insert(theme_table, key)
    end
    table.sort(theme_table)

    array.grid_theme_color = Gtk.Grid({ margin_top = 0 })
    array.grid_theme_color:set_row_spacing(10)
    array.grid_theme_color:set_column_spacing(10)

    -- Grabs all the color settings
    for i, key in ipairs(theme_table) do
        local value = theme[key]
        local matchColor = string.match(value, "#")

        if matchColor then
            table.insert(colorTable, key)
        end
    end

    -- Creates all the boxes for color settings
    for i, key in ipairs(colorTable) do
        local value = theme[key]
        local row = math.floor((i - 1) / 5)
        local col = (i - 1) % 5

        -- Manipulates the label to make it prettier
        local labelValue = string.gsub(key, "_", " ")
        local labelValue = list.to_upper(labelValue)

        -- Make label widgets
        array.theme_labels_setting[key] = Gtk.Label({ margin_bottom = 50, label = labelValue })
        array.theme_labels_setting[key]:set_markup(
            "<span foreground='"
            .. theme.label_fg
            .. "'size='"
            .. font.fg_size
            .. "'>"
            .. array.theme_labels_setting[key].label
            .. "</span>"
        )

        array.theme_labels[key] = Gtk.ColorButton({ margin_top = 50 })

        local defaultColor = hashToRGBA(value)
        array.theme_labels[key]:set_rgba(defaultColor)
        array.grid_theme_color:attach(array.theme_labels[key], col, row * 2 + 1, 1, 1)
        array.grid_theme_color:attach(array.theme_labels_setting[key], col, row * 2 + 1, 1, 1)
    end

    widget.box_theme:append(array.grid_theme_color)
    widget.box_theme:append(label.theme_restore.theme)
    widget.box_theme:append(restoreButton)

    function restoreButton:on_clicked()
        update.restore("theme")
    end
    
    return widget
end

-- Function to create grid layout of regular settings
function array.setting_table(theme, font)
    -- Import buttons
    local button = require("lua.widgets.button")
    local update = require("lua.theme.update")
    local restoreButton = button.reset_create()
    array.restore_button.setting = restoreButton

    local setting_table = {}
    for key in pairs(setting_default) do
        table.insert(setting_table, key)
    end
    table.sort(setting_table)

    array.grid_widgets_setting = Gtk.Grid({ margin_top = 0 })
    array.grid_widgets_setting:set_row_spacing(10)
    array.grid_widgets_setting:set_column_spacing(10)

    -- Creates all the entry boxes for some standard setting entry boxes
    for i, key in ipairs(setting_table) do
        local value = setting_default[key]
        local row = math.floor((i - 1) / 4)
        local col = (i - 1) % 4

        -- Manipulates the label to make it prettier
        -- Removes the seperator and add a space instead
        local labelValue = string.gsub(key, "_", " ")
        local labelValue = string.gsub(labelValue, "default ", "")
        local labelValue = list.to_upper(labelValue)

        -- Makes entry widgets
        array.setting_labels[key] = Gtk.Entry({ margin_top = 50, text = value })
        array.setting_labels[key]:set_size_request(20, 10) -- Set width = 200, height = 100

        array.setting_labels[key] = array.set_theme(array.setting_labels[key])

        -- Make label widgets
        array.theme_labels_setting[key] = Gtk.Label({ margin_bottom = 50, label = labelValue })

        array.theme_labels_setting[key]:set_markup(
            "<span foreground='"
            .. theme.label_fg
            .. "'size='"
            .. font.fg_size
            .. "'>"
            .. array.theme_labels_setting[key].label
            .. "</span>"
        )
        array.grid_widgets_setting:attach(array.setting_labels[key], col, row * 2 + 1, 1, 1)
        array.grid_widgets_setting:attach(array.theme_labels_setting[key], col, row * 2 + 1, 1, 1)
    end

    widget.box_setting:append(array.grid_widgets_setting)
    widget.box_setting:append(label.theme_restore.setting)
    widget.box_setting:append(restoreButton)

    function restoreButton:on_clicked()
        update.restore("setting")
    end
    
    return widget
end

function array.font_table(theme, font)
    local update = require("lua.theme.update")
    local restoreButton = button.reset_create()
    array.restore_button.font = restoreButton

    local fontTable = {}

    array.grid_theme = Gtk.Grid({ margin_top = 0 })
    array.grid_theme:set_row_spacing(10)
    array.grid_theme:set_column_spacing(10)

    for key in pairs(font) do
        table.insert(fontTable, key)
    end
    table.sort(fontTable)

    -- Creates all the boxes for font settings and image setting
    for i, key in ipairs(fontTable) do
        local value = font[key]
        local row = math.floor((i - 1) / 5)
        local col = (i - 1) % 5

        -- Removes the seperator and add a space instead
        local labelValue = string.gsub(key, "_", " ")
        local labelValue = list.to_upper(labelValue)

        -- Match all the strings that contains size
        local match = string.match(key, "size")

        -- Reduce the number so its easier to modify size
        if match == "size" then
            value = value / 1000
            value = tostring(value):gsub("%.0+$", "")

            array.theme_labels[key] = Gtk.SpinButton({
                adjustment = Gtk.Adjustment({ lower = 0, upper = 100, step_increment = 1 }),
                digits = 0,
                margin_top = 50,
                halign = Gtk.Align.CENTER,
            })

            array.theme_labels[key] = array.set_theme(array.theme_labels[key])
            array.theme_labels[key]:set_value(value)
        else
            array.theme_labels[key] = Gtk.Entry({ margin_top = 50, text = value })
            array.theme_labels[key]:set_size_request(20, 10) -- Set width = 200, height = 100
            array.theme_labels[key] = array.set_theme(array.theme_labels[key])
        end

        -- Make label widgets
        array.theme_labels_setting[key] = Gtk.Label({ margin_bottom = 50, label = labelValue })
        array.theme_labels_setting[key]:set_markup(
            "<span foreground='"
            .. theme.label_fg
            .. "'size='"
            .. font.fg_size
            .. "'>"
            .. array.theme_labels_setting[key].label
            .. "</span>"
        )

        -- Makes entry box and set theme
        array.grid_theme:attach(array.theme_labels[key], col, row * 2 + 1, 1, 1)
        array.grid_theme:attach(array.theme_labels_setting[key], col, row * 2 + 1, 1, 1)
    end

    widget.box_theme_alt:append(array.grid_theme)
    widget.box_theme_alt:append(label.theme_restore.font)
    widget.box_theme_alt:append(restoreButton)

    
    function restoreButton:on_clicked()
        update.restore("font")
    end
    
    return widget
end

return array
