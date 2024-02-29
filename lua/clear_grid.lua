local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local widget = require("lua.widgets.box")

local clear = {}

-- Function to remove childs
function clear.grid(grid)
  local child = grid:get_last_child()
  while child do
    grid:remove(child)
    child = grid:get_last_child()
  end
end

return clear
