-- Module for all the keybindings for the app
local azla = require("lua.question.start")


local function lol(controller, keyval, keycode, state, win)
         local app1 = require("lua.main").app1
         local winDim = require("lua.main").getWindowDim

         -- Gets the keybinding
         local value = keyval + keyval
         print(value)
         if value == 226 then -- CTRL + Q
           app1:quit()
         elseif value == 204 then -- CTRL + F  
             local window = winDim()
             local getState = window.main:is_fullscreen()

             if getState == false then
                window.main:fullscreen()
             else   
                window.main:unfullscreen()
             end   
         elseif value == 218 then -- CTRL + M  
             local window = winDim()
             local getState = window.main:is_maximized()
             if getState == false then
                window.main:maximize()
             elseif getState == true then   
                window.main:unmaximize()
             end
         elseif value == 130586 then -- CTRL + Enter
                local appModule   = require("lua.questionMain")
                local create_app2 = appModule.create_app2
                local wordModule  = "lua.words"

                local window = winDim()
                azla.start_azla(window.main,window,create_app2,wordModule)
         end
end


local function lolQuestion(controller, keyval, keycode, state, win)
         local winDim     = require("lua.questionMain").getWinDim
         local winDimMain = require("lua.main").getWindowDim
         local window     = winDim()
         local windowMain = winDimMain()
         local app2       = require("lua.questionMain").app2
         local app1       = require("lua.main").app1
         
         -- Gets the keybinding
         local value = keyval + keyval
         print(value)
         if value == 226 then -- CTRL + Q
             window.question:destroy()
             windowMain.main:destroy()
         elseif value == 204 then -- CTRL + F  
             local window = winDim()
             local getState = window.question:is_fullscreen()

             if getState == false then
                window.question:fullscreen()
             else   
                window.question:unfullscreen()
             end   
         elseif value == 218 then -- CTRL + M  
             local window = winDim()
             local getState = window.question:is_maximized()
             if getState == false then
                window.question:maximize()
             elseif getState == true then   
                window.question:unmaximize()
             end
         end
end



return {lol = lol, lolQuestion = lolQuestion}


