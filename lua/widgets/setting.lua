local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local Gdk = require("lgi").Gdk
local widget = require("lua.widgets.box")
local list = require("lua.terminal.listFiles")

-- Import settings
local setting_default = require("lua.theme.setting").load()

-- Create empty table
local M = {}

-- Creates some empty tables for the widgets
M.theme_labels = {} -- For the theme (Color) setting menu
M.font_labels = {} -- For the font setting menu
M.setting_labels = {} -- For the general settings menu
M.theme_labels_setting = {} -- For all the labels used in the settings
M.restore_button = {} -- For all the restore buttons

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

    return color -- Resturn the color
end

-- Exports the hashtoRGBA function
M.hashToRGBA = hashToRGBA

-- Function to set some css style to widgets
function M.set_theme(widget, style)
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

    -- Create a CSS style rule
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

    return widget -- return the widget
end

-- Function to create grid layout of theme settings
function M.theme_table(theme, font)
    local button = require("lua.widgets.button")
    local update = require("lua.theme.update")

    -- Create restore button
    local restoreButton = button.reset_create()
    M.restore_button.theme = restoreButton

    -- Creates empty tables
    local theme_table = {}
    local colorTable = {}

    for key in pairs(theme) do
        table.insert(theme_table, key)
    end
    table.sort(theme_table)

    M.grid_theme_color = Gtk.Grid({ margin_top = 0 })
    M.grid_theme_color:set_row_spacing(10)
    M.grid_theme_color:set_column_spacing(10)

    -- Grabs all the color settings
    for _, key in ipairs(theme_table) do
        local value = theme[key]
        local matchColor = string.match(value, "#")

        -- Update the theme with only colors
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
        M.theme_labels_setting[key] = Gtk.Label({ margin_bottom = 50, label = labelValue })
        M.theme_labels_setting[key]:set_markup(
            "<span foreground='"
            .. theme.label_fg
            .. "'size='"
            .. font.fg_size
            .. "'>"
            .. M.theme_labels_setting[key].label
            .. "</span>"
        )

        -- Make the color buttons for the theme menu
        M.theme_labels[key] = Gtk.ColorButton({ margin_top = 50 })

        -- Sets the colors
        local defaultColor = hashToRGBA(value)
        M.theme_labels[key]:set_rgba(defaultColor)

        -- Attach the options to the grid
        M.grid_theme_color:attach(M.theme_labels[key], col, row * 2 + 1, 1, 1)
        M.grid_theme_color:attach(M.theme_labels_setting[key], col, row * 2 + 1, 1, 1)
    end

    -- Attach the widgets to the theme box
    widget.box_theme:append(M.grid_theme_color)
    widget.box_theme:append(label.theme_restore.theme)
    widget.box_theme:append(restoreButton)

    -- Add click action too the button to restore the theme to default
    function restoreButton:on_clicked()
	    --local status = write.write.config.color_scheme('color_scheme = "' .. stringValue .. '"\n', customConfig)
        update.restore("theme") -- function for restoration of theme
    end

    return widget -- Return the widget
end

-- Function to create grid layout of regular settings
function M.setting_table(theme, font)
    -- Import buttons
    local button = require("lua.widgets.button")
    local update = require("lua.theme.update")

    -- Create restore Button
    local restoreButton = button.reset_create()

    -- Restore button for setting
    M.restore_button.setting = restoreButton

    -- Creates table for all setting values
    local setting_table = {}
    for key in pairs(setting_default) do
        table.insert(setting_table, key)
    end
    table.sort(setting_table)

    -- Create grid layout for general settings
    M.grid_widgets_setting = Gtk.Grid({ margin_top = 0 })
    M.grid_widgets_setting:set_row_spacing(10)
    M.grid_widgets_setting:set_column_spacing(10)

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
        M.setting_labels[key] = Gtk.Entry({ margin_top = 50, text = value })
        M.setting_labels[key]:set_size_request(20, 10) -- Set width = 200, height = 100

        -- Sets the theme
        M.setting_labels[key] = M.set_theme(M.setting_labels[key])

        -- Make label widgets
        M.theme_labels_setting[key] = Gtk.Label({ margin_bottom = 50, label = labelValue })

        -- Add theme to the label
        M.theme_labels_setting[key]:set_markup(
            "<span foreground='"
            .. theme.label_fg
            .. "'size='"
            .. font.fg_size
            .. "'>"
            .. M.theme_labels_setting[key].label
            .. "</span>"
        )

        -- Attach the General setting widgets to the gird
        M.grid_widgets_setting:attach(M.setting_labels[key], col, row * 2 + 1, 1, 1)
        M.grid_widgets_setting:attach(M.theme_labels_setting[key], col, row * 2 + 1, 1, 1)
    end

    -- Attch the widget to the settings box
    widget.box_setting:append(M.grid_widgets_setting)
    widget.box_setting:append(label.theme_restore.setting)
    widget.box_setting:append(restoreButton)

    -- Attach the function for restore button
    function restoreButton:on_clicked()
        update.restore("setting")
    end

    return widget -- Return the widget
end

-- Create gird layout for font settings
function M.font_table(theme, font)
    -- Import functions I need
    local update = require("lua.theme.update")

    -- Create restore button for fonts
    local restoreButton = button.reset_create()
    M.restore_button.font = restoreButton

    -- Create empty table
    local fontTable = {}

    -- Create grid layout for font settings
    M.grid_theme = Gtk.Grid({ margin_top = 0 })
    M.grid_theme:set_row_spacing(10)
    M.grid_theme:set_column_spacing(10)

    -- Create table for all the font values
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

            -- Create spin button for the font size
            M.font_labels[key] = Gtk.SpinButton({
                adjustment = Gtk.Adjustment({ lower = 0, upper = 100, step_increment = 1 }),
                digits = 0,
                margin_top = 100,
                halign = Gtk.Align.CENTER,
            })

            -- Set theme for the font buttons
            M.font_labels[key] = M.set_theme(M.font_labels[key])
            M.font_labels[key]:set_value(value)
        else
            -- Set theme for the font buttons
            M.font_labels[key] = Gtk.Entry({ margin_top = 50, text = value })
            M.font_labels[key]:set_size_request(20, 10) -- Set width = 200, height = 100
            M.font_labels[key] = M.set_theme(M.font_labels[key])
        end

        -- Make label widgets
        M.theme_labels_setting[key] = Gtk.Label({ margin_bottom = 50, label = labelValue })
        M.theme_labels_setting[key]:set_markup(
            "<span foreground='"
            .. theme.label_fg
            .. "'size='"
            .. font.fg_size
            .. "'>"
            .. M.theme_labels_setting[key].label
            .. "</span>"
        )

        -- Makes entry box and set theme
        M.grid_theme:attach(M.font_labels[key], col, row * 2 + 1, 1, 1)
        M.grid_theme:attach(M.theme_labels_setting[key], col, row * 2 + 1, 1, 1)
    end

    -- Attach the font widgets to the font box
    widget.box_theme_alt:append(M.grid_theme)
    widget.box_theme_alt:append(label.theme_restore.font)
    widget.box_theme_alt:append(restoreButton)

    -- Add the click action to the font restore button
    function restoreButton:on_clicked()
        update.restore("font")
    end

    return widget -- return widget
end

return M -- Return the module
