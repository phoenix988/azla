local io                 = require("io")
local load_config_module = require("lua.loadConfig")
local load_config_custom = load_config_module.load_config_custom
local write              = {}

function write.set_config_Replace(replace)
       
       configReplace =  {
         word_set       = replace.word,
         word_count_set = replace.word_count,
         lang_set       = replace.lang,
         default_width  = replace.width,
         default_height = replace.height
         }

return configReplace

end


function write.window_size(customConfig,setting,config,fileExist)

    -- Gets the width and height to set on the window
    -- You can configure this in a config file
    if fileExist(customConfig) then
       -- Prints error if you dont name the variable custom inside the setting file
       if setting == nil then
           print("Error in config")
           os.exit()
       end
    end
       
       if setting.default_height ~= nil then
           config.default_height = setting.default_height
       elseif config.default_height ~= nil then 
           config.default_height = config.default_height
       else
           config.default_height = 800 
       end

       if setting.default_width ~= nil then
           config.default_width = setting.default_width
       elseif config.default_width ~= nil then 
           config.default_width = config.default_width
       else
           config.default_width = 600 
       end

    
    return config

end

-- Write the updated config back to the file
function write.to_config(cacheFile, config)
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

-- Function to update config file
-- Theme array
function write.theme(config, apply, theme, setting)
        local file = io.open(config, "w")

        local fileExist          = require("lua.fileExist")
        local fileExist          = fileExist.fileExists
        
        if fileExist(config) then
           local loadCustom = load_config_custom(config)
        end

        if file then
           file:write("setting = {\n")
           if setting == nil then
              local trash
           else
              for key, value in pairs(setting) do
                 file:write(string.format("   %s = %q,\n", key, value))
              end
           end
           file:write("}\n")
           file:write("\n")
           file:write("theme = {\n")
           for key, value in pairs(apply) do
              if value ~= theme[key] then
                 file:write(string.format("   %s = %q,\n", key, value))
              end 
           end
           file:write("}\n")
           file:close()
           --print("Config file updated successfully.")
        else
           print("Failed to open config file.")
        end
end

-- Function to update config file
-- Settings array
function write.setting(config, apply, apply_theme)

        local file = io.open(config, "w")

        local fileExist          = require("lua.fileExist")
        local fileExist          = fileExist.fileExists
        
        if fileExist(config) then
           local loadCustom = load_config_custom(config)
        end

        if file then
           file:write("setting = {\n")
           if setting == nil then
              local trash
           else
              for key, value in pairs(apply) do
                 file:write(string.format("   %s = %q,\n", key, value))
              end
           end
           file:write("}\n")
           file:write("\n")
           file:write("theme = {\n")
           for key, value in pairs(apply_theme) do
              file:write(string.format("   %s = %q,\n", key, value))
           end
           file:write("}\n")
           file:close()
           --print("Config file updated successfully.")
        else
           print("Failed to open config file.")
        end

end

function write.config_settings(replace,combo)
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
function write.config_main(cacheFile,combo)


       -- gets all values we need
       local replace = write.config_settings(replace,combo)

       -- makes the settings array
       local configReplace = write.set_config_Replace(replace)

       -- Change the name 
       local config = configReplace

       -- Replace the cacheFile with the new values
       write.to_config(cacheFile,config)


end



local mainWindowModule = require("lua.main")

-- Return notebook from main file
local notebook = mainWindowModule.getSettingList()

-- Returns all variables
return {write = write, notebook = notebook}
