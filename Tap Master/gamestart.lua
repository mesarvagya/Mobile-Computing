local composer = require( "composer" )
local widget = require("widget")

--This function takes to actual game start
local function handlePlay(event)
	if(event.phase == "ended") then
		print("now move the scene to next scene")
		local options = {effect = "fade", time = 800}
		composer.gotoScene("game", options)
		print("should have moved")
	end
end

--This function takes to settings scenece
local function showOverlayModel( event )

    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
        composer.gotoScene( "settings", options )
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
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        --Creates a background image
        local background = display.newImage("background.jpeg")
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		sceneGroup:insert(background)
		--Play button that will start the game
		local play = widget.newButton(
		{
			left = 50,
			top = 50,
			id = "playButton",
			onEvent = handlePlay,
			defaultFile = "rsz_playbutton.png",
			overFile = "rsz_playbutton.png"

		})
		--Settings button to go to the setting scene
		local settings = widget.newButton(
		{
			left = 50,
			top = 50,
			id = "settingsButton",
			onEvent = showOverlayModel,
			defaultFile = "settings.png",
			overFile = "settings.png"

		})
		play.x = display.contentCenterX
		play.y = display.contentCenterY

		settings.x = 250
		settings.y = 10
		sceneGroup:insert(play)
		sceneGroup:insert(settings)

		local sp0090 = display.newText( "Created by:\nSarvagya Pant (sp0090)\nBidhya N. Sharma (bns0028)\n", 40, 300, native.systemFontBold, 20 )
		sp0090:setFillColor( 0, 0, 0 )
		sp0090.anchorX = 0
		sp0090.anchorY = 0
		sceneGroup:insert(sp0090)
 
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