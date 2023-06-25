local lgi     = require("lgi")
local Gtk     = lgi.require("Gtk", "4.0")

-- make grid table
grid = {}

function grid.grid_create()
   -- Makes grid
   grid.grid_1 = Gtk.Grid()
   grid.grid_2 = Gtk.Grid()

   return grid
end

return grid
      

