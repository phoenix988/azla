#!/usr/bin/env lua
--##____  _                      _
--#|  _ \| |__   ___   ___ _ __ (_)_  __
--#| |_) | '_ \ / _ \ / _ \ '_ \| \ \/ /
--#|  __/| | | | (_) |  __/ | | | |>  <
--#|_|   |_| |_|\___/ \___|_| |_|_/_/\_\
--# -*- coding: utf-8 -*-
--# Azla Language learning program
--# Made By Phoenix988
--# Written entirely in Lua scripting language

-- Imports libaries we need
local lfs = require("lfs")
local io = require("io")
local os = require("os")

-- Gets the current directory
local currentDir = debug.getinfo(1, "S").source:sub(2)
local currentDir = currentDir:match("(.*/)") or ""

-- Append the current directory to the package path
package.path = currentDir .. "?.lua;" .. package.path

-- Imports init file
local terminal_init = require("lua.terminal.init")

-- Import some switches variables
local p = require("lua.terminal.processSwitch")

-- Import Variables
local var = require("lua.config.init")

-- Sets home variable
local home = os.getenv("HOME")

-- File exist function
local fileExist = require("lua.fileExist")

-- Sets terminal variable
p.terminal = false

-- Sets cachefile path
local cacheDir = var.cacheDir
local cacheFile = var.cacheFile

-- Gets word module path
local wordMod = var.wordMod

-- Import mkdir function
local mkdir = require("lua.terminal.mkdir").mkdir

-- Create the cache file if it doesn't exist
if not fileExists(cacheDir) then
	mkdir(cacheDir)
end

-- Create custom word directory if it doesnt exist
-- To avoid any errors that relies on this dir
if not fileExists(var.wordDir_alt) then
	mkdir(var.wordDir_alt)
end

if not fileExists(cacheFile) then
	local file = io.open(cacheFile, "w")

	file:write("config = {\n")
	file:write("}")

	-- Close the file
	file:close()
end

-- set luawords path
local luaWordsPath = currentDir .. "lua/words/"
local luaWordsModule = wordMod

-- Process the switches
p.processSwitches(luaWordsPath, luaWordsModule)

-- Runs the GUI app if you dont specify --term (-t)
if p.terminal == false then
	-- Imports init
	local import = require("lua.init")

	-- Main window
	local app1 = import.app1

	-- Activate app1
	function app1:on_activate()
		self.active_window:present()
	end

	-- Runs the app
	app1:run()
elseif p.terminal == true then
	-- runs terminal app
	terminal_init()
end -- End of if statement
