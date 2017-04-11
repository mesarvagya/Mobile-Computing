-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require("composer")
display.setStatusBar( display.HiddenStatusBar )
scoreVal = nil -- global for score value

composer:gotoScene("gamestart")
