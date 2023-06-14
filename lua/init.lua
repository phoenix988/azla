local import = {}

-- Imports window 1
import.appModule      = require("lua.main")
import.app1           = import.appModule.app1

-- Import file exist module
import.fileExistModule = require("lua.fileExist")
import.fileExist       = import.fileExistModule.fileExists

-- Gets current directory
import.currentDir = debug.getinfo(1, "S").source:sub(2)

return import


