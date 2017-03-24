local composer = require("composer")
--Variables for setting speed 
composer.setVariable("default_setting", true)
composer.setVariable("min_value", 0.5)
composer.setVariable("max_value", 5)
--Hiding status bar
display.setStatusBar(display.HiddenStatusBar)
composer.gotoScene("gamestart")
