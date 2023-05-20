
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")

local correct_answers = 0
local incorrect_answers = 0

local function show_result(correct_answers)

   if correct_answers == nil then
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

      dialog:show()

   end
 
end

return { show_result = show_result,
         correct_answers = correct_answers, 
         incorrect_answers = incorrect_answers }

