#!/usr/bin/env lua

-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require('GdkPixbuf')
local lfs = require("lfs")

-- Imports window 1
local appModule = require("lua/mainWindow")
local app1 = appModule.app1

-- Activate app1
function app1:on_activate()
  self.active_window:present()
end

-- Run the main app
--return { app1:run({})}

app1:run()


