local io = require("io")
local load_config_module = require("lua.loadConfig")
local load_config_custom = load_config_module.load_config_custom
local write = {}

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
local function write_theme(config, apply, theme)
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
local function write_setting(config, apply, apply_theme)

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

function write.config_settings(replace,comboWord,combo)

        local mainWindowModule = require("lua.main")
        local getWidth = mainWindowModule.getWindowWidth
        local getHeight = mainWindowModule.getWindowHeight
        local width = getWindowWidth()
        local height = getWindowHeight()

        -- Gets the dimensions of the screen
        replace.width  = height
        replace.height = width
        replace.word   = comboWord:get_active()
        replace.lang   = combo.lang:get_active()
        replace.word_count = combo.word_count:get_active()

        return replace

end

-- Main function that runs all config replacements at once
function write.config_main(replace,cacheFile,combo,comboWord)
       
       -- gets all values we need
       write.config_settings(replace,comboWord,combo)
       
       -- makes the settings array
       local configReplace = write.set_config_Replace(replace)

       -- Change the name 
       local config = configReplace
    
       -- Replace the cacheFile with the new values
       write.to_config(cacheFile,config)

end


-- Returns all variables
return {write_theme = write_theme, write_setting = write_setting, write = write}
