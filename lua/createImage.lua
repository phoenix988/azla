local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require('GdkPixbuf')

-- function to easy create image widgets to the Gtk window
local function create_image(path)
    local image = Gtk.Image()
    local pixbuf = GdkPixbuf.Pixbuf.new_from_file(path)
    image:set_from_pixbuf(pixbuf)
    return image
end

return {create_image = create_image}


