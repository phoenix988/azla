#!/usr/bin/env lua

-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require('GdkPixbuf')
local lfs = require("lfs")

-- Imports show_result function so you can see how many correct answers you have
local showResultModule = require("lua/showResult")
local show_result = showResultModule.show_result
local correct_answers = showResultModule.correct_answers
local incorrect_answers = showResultModule.incorrect_answers

-- Imports window 1
local appModule = require("lua/mainWindow")
local app1 = appModule.app1

-- Imports window 2
local appModule = require("lua/questionAz")
local app2 = appModule.app2


-- Imports window 3
local app3Module = require("lua/questionEng")
local app3 = app3Module.app3


-- Imports image function so I can make image widgets
local imageModule = require("lua/createImage")
local create_image = imageModule.create_image

-- Define other variables used later in the application
local question_labels = {}
local entry_fields = {}
local submit_buttons = {}
local result_labels = {}

-- Activate app1
function app1:on_activate()
  self.active_window:present()
end

-- Activate app2
function app2:on_activate()
  self.active_window:present()
end

function app3:on_activate()
  self.active_window:present()
end

-- Run the main app
return { app1:run({}), app1 = app1 }

