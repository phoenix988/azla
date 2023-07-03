local M = {}

function M.set_config_Replace(replace)
       
       local configReplace =  {
           word_set       = replace.word,
           word_count_set = replace.word_count,
           lang_set       = replace.lang,
           default_width  = replace.width,
           default_height = replace.height
        }

       return configReplace

end

-- Write the updated config back to the file
function M.to_config(cacheFile, config)
       local file = io.open(cacheFile, "w")
       if file then
          file:write("config = {\n")
          for key, value in pairs(config) do
             file:write("   " .. key .. " = " .. tostring(value) .. ",\n")
          end
          file:write("}\n")
          file:close()
          --print("Config file updated successfully.")
       else
          print("Failed to open config file.")
       end
end


function M.config_settings(replace,combo)
       local replace = {}

       local mainWindowModule = require("lua.main")
       local getDim = mainWindowModule.getWindowDim
       local window = getDim()

       -- Gets the dimensions of the screen
       replace.width      = window.width
       replace.height     = window.height
       replace.word       = combo.word:get_active()
       replace.lang       = combo.lang:get_active()
       replace.word_count = combo.word_count:get_active()

       return replace

end

-- Main function that runs all config replacements at once
function M.config_main(cacheFile,combo)
       
       -- gets all values we need
       local replace = M.config_settings(replace,combo)
       
       -- makes the settings array
       local configReplace = M.set_config_Replace(replace)

       -- Change the name 
       local config = configReplace
    
       -- Replace the cacheFile with the new values
       M.to_config(cacheFile,config)

end

return { write_cache = M}






