-- Function to show the result in my GTK app
-- This is not in use I have this code snippet in
-- QuestionMain.lua because I couldnt make it to work using this file

-- Imports libaries
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")

local correct_answers = 0
local incorrect_answers = 0

-- Get posisition of window
function getCenterPosition(window)

    local allocation = window:get_allocation()
    local x = allocation.x + allocation.width / 2
    local y = allocation.y + allocation.height / 2
    return x, y
end


-- Defines the function
local function show_result(correct_answers, incorrect_answers)
    
   local mainModule = require("lua.main")
   local getDim      = mainModule.getWindowDim
   local window      = getDim()
   
   -- Gets the posistion of the main window
   local windowX, windowY = getCenterPosition(window.main)
   
   -- Sets correct answer variables
   if correct_answers and incorrect_answers == nil then
      local dialog_empty = Gtk.MessageDialog {
         message_type = Gtk.MessageType.ERROR,
         buttons = Gtk.ButtonsType.OK,
         text = "No session run",
         }

      dialog_empty:show()

      dialog_empty.on_response = function(dialog_empty, response_id)
            if response_id == Gtk.ResponseType.OK then
                dialog_empty:close()  -- Close the dialog
            end
      end

   else

      local dialog = Gtk.MessageDialog {
        message_type = Gtk.MessageType.INFO,
        buttons = Gtk.ButtonsType.OK,
        text = "Correct answers: " .. correct_answers,
        secondary_text = "Incorrect answers: " .. incorrect_answers,
      }
     
      dialog.on_response = function(dialog, response_id)
           if response_id == Gtk.ResponseType.OK then
               dialog:close()  -- Close the dialog
           end
      end

      -- Calculate the center position of the dialog box
      local dialogX, dialogY = getCenterPosition(dialog)

      -- Move the dialog box to the new position
      dialog:set_transient_for(window.main)

      dialog:show()

   end
 
end

-- Returns all avriables we need to import
return { show_result = show_result}


