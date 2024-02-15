local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")

local show = {}

function show.summary(question,grid,grid2,theme)
      -- load theme and font
      local theme = theme.load()
      local font  = require("lua.theme.font").load()

      -- Sets empty tables
      local label_correct   = {}
      local label_incorrect = {}
      local count = 0

      local scrollWindow = Gtk.ScrolledWindow({
            hscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
            vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
            margin_end = 30,
            halign = Gtk.Align.START,
      })
      
      label_correct.main = Gtk.Label()
      label_incorrect.main = Gtk.Label()
      

      label_incorrect.main:set_halign(Gtk.Align.START)
      label_correct.main:set_halign(Gtk.Align.START)

      if question.label_correct ~= nil then
        local count = 0
        for key , value in pairs(question.label_correct) do
              -- Counts how many times it runs
              count = count + 1
  
              if type(key) == "number" then
                  -- Calculate the number of rows and columns
                  local numRows = math.ceil(count / 1)
                  local numCols = 3
                  if value ~= nil then
                      label_correct[key] = Gtk.Label({ label = question.label_correct[key] .. "    "})
                      label_correct[key]:set_markup("<span foreground='".. theme.label_correct .. "' size='" .. font.fg_size .. "'>" 
                      .. label_correct[key].label .. "</span>")

                      label_correct[key]:set_halign(Gtk.Align.START)
                 
                      -- Calculate the row and column indices
                      local row = math.floor((count - 1) / numCols)
                      local col = (count - 1) % numCols
                 
                      grid:attach(label_correct[key], 1, count, 1, 1)
                  end

              end

        end
        
        label_correct.main:set_text("Correct: " .. count) 
        label_correct.main:set_markup("<span foreground='".. theme.label_fg .. "' size='" .. font.welcome_size .. "'>" 
        .. label_correct.main.label .. "</span>")
        
        grid:attach(label_correct.main, 1, -1, 1, 1)

        if count == 0 then 
           label_correct.main:set_visible(false)
        end
      
      end

      if question.label_incorrect ~= nil then
        local count = 0
        for key , value in pairs(question.label_incorrect) do
          -- Counts how many times it runs
          count = count + 1

              if type(key) == "number" then
                  -- Calculate the number of rows and columns
                  local numRows = math.ceil(count / 1)
                  local numCols = 3
                  if value ~= nil then
                      label_incorrect[key] = Gtk.Label({ label = question.label_incorrect[key] .. "    "})
                      label_incorrect[key]:set_markup("<span foreground='".. theme.label_incorrect .. "' size='" .. font.fg_size .. "'>" 
                      .. label_incorrect[key].label .. "</span>")

                      label_incorrect[key]:set_halign(Gtk.Align.START)
                  
                      -- Calculate the row and column indices
                      local row = math.floor((count - 1) / numCols)
                      local col = (count - 1) % numCols
                  
                      -- Attach the label to the grid
                      grid2:attach(label_incorrect[key], 1, count, 1, 1)
                  end

              end

        end
      
        label_incorrect.main:set_text("Incorrect: " .. count)
        label_incorrect.main:set_markup("<span foreground='".. theme.label_fg .. "' size='" .. font.welcome_size .. "'>"
        .. label_incorrect.main.label .. "</span>")

        grid2:attach(label_incorrect.main, 1, -1, 1, 1)

        if count == 0 then 
           label_incorrect.main:set_visible(false)
        end

      end
end

return show
