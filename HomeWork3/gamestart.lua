local composer = require( "composer" )
local widget = require("widget")

--This function takes to actual game start
local function handlePlay(event)
	if(event.phase == "ended") then
		local options = {effect = "fade", time = 800}
		composer.gotoScene("level1", options)
	end
end

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local w = display.contentWidth
    local h = display.contentHeight
    local background = display.newImage("background.jpeg")
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	--Play button that will start the game
	local gameNameText = display.newText( sceneGroup, "Janken", w/2, h/4, native.systemFontBold, 80 )
	gameNameText:setFillColor(0.1, 0.2, 0.9)

	local play = widget.newButton(
	{
		left = 50,
		top = 50,
		id = "playButton",
		onEvent = handlePlay,
		defaultFile = "rsz_playbutton.png",
		overFile = "rsz_playbutton.png"

	})
	play.x = display.contentCenterX
	play.y = display.contentCenterY
	sceneGroup:insert(play)

	local sp0090 = display.newText( "Created by:\nSarvagya Pant (sp0090)\nBidhya N. Sharma (bns0028)\n", 40, 300, native.systemFontBold, 20 )
	sp0090:setFillColor( 0, 0, 0 )
	sp0090.anchorX = 0
	sp0090.anchorY = 0
	sceneGroup:insert(sp0090)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        --Creates a background image
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene