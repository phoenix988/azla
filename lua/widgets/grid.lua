local lgi     = require("lgi")
local Gtk     = lgi.require("Gtk", "4.0")

-- make grid table
grid = {}

function grid:create()
   -- Makes grid
   grid.grid_1 = Gtk.Grid()
   grid.grid_2 = Gtk.Grid()

   return grid
end

function  grid.main_create()

    local widget = Gtk.Grid()
    widget:set_row_spacing(10)
    widget:set_column_spacing(10)

    return widget
end

return grid
      

