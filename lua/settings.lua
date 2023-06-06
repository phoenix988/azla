local io = require("io")



function setconfigReplace(word,lang,width,height)
       
       configReplace =  {
         word_set = word,
         lang_set = lang,
         default_width = width,
         default_height = height
         }

        return configReplace
end

-- Write the updated config back to the file
local function writeTo_config(cacheFile, config)
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


return {writeTo_config = writeTo_config, setconfigReplace = setconfigReplace}
