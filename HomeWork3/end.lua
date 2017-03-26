local composer = require( "composer") 
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
    local params = event.params
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        winmessage = display.newText(sceneGroup, params.message, display.contentWidth/2, display.contentHeight/12, native.systemFontBold, 20)
        endmsg = display.newText( sceneGroup,"Game Over", display.contentWidth/2, display.contentHeight/3, native.systemFontBold, 35);
        buttonrect = display.newRoundedRect( sceneGroup, display.contentWidth/2, display.contentHeight/2, 150, 60, 10)
        buttonrect:setFillColor(0.1, 0.2, 0.9 )
        gotoplay = display.newText(sceneGroup, "Play Again!!",display.contentWidth/2, display.contentHeight/2, native.systemFontBold, 25)
        gotoplay:addEventListener("tap", 
            function(event)
                local options = {effect = "fade", time = 400}
                composer.gotoScene("gamestart", options)
            end)
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
        endmsg:removeSelf()
        gotoplay:removeSelf()
        winmessage:removeSelf()
        buttonrect:removeSelf()
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