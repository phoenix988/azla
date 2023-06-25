local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")

local show = {}

function show.summary(question,grid,theme)
      local label_correct   = {}
      local label_incorrect = {}
      
      if question.label_correct ~= nil then
        for key , value in pairs(question.label_correct) do

          if type(key) == "number" then

                  -- Calculate the number of rows and columns
                  local numRows = math.ceil(#value / 4)
                  local numCols = 4
                  if value ~= nil then
                    label_correct[key] = Gtk.Label({ label = question.label_correct[key] .. "    "})
                    label_correct[key]:set_markup("<span foreground='".. theme.label_correct .. "' size='" .. theme.label_fg_size .. "'>" .. label_correct[key].label .. "</span>")
                 
                     -- Calculate the row and column indices
                     local row = math.floor((key - 1) / numCols)
                     local col = (key - 1) % numCols
                 
                    grid:attach(label_correct[key], col, row, 1, 1)
                  end

          end

        end
      
      end

      if question.label_incorrect ~= nil then
        for key , value in pairs(question.label_incorrect) do


          if type(key) == "number" then

                  --show_result_labels[key]:set_visible(true)
                  -- Calculate the number of rows and columns
                  local numRows = math.ceil(#value / 4)
                  local numCols = 4
                  if value ~= nil then
                    label_incorrect[key] = Gtk.Label({ label = question.label_incorrect[key] .. "    "})
                    label_incorrect[key]:set_markup("<span foreground='".. theme.label_incorrect .. "' size='" .. theme.label_fg_size .. "'>" .. label_incorrect[key].label .. "</span>")
                 
                     -- Calculate the row and column indices
                     local row = math.floor((key - 1) / numCols)
                     local col = (key - 1) % numCols
                 
                    -- Attach the label to the grid
                    grid:attach(label_incorrect[key], col, row, 1, 1)
                  end

          end

        end
      
      end

end

return show
