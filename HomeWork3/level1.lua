local composer = require( "composer" )
 
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

    local function bubble_tap_handler( event )
        local random_hand = math.random(1,3)
        print("random ", random_hand)
        if (random_hand == 1) then
            event.target:setSequence("bubble_rock");
        elseif (random_hand == 2) then
            event.target:setSequence("bubble_paper");
        elseif (random_hand == 3) then
            event.target:setSequence("bubble_scissor");
        end
    end
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local bg = display.newImage (background_sheet, 1);
        bg.x = display.contentWidth / 2;
        bg.y= display.contentHeight / 2;
        bg.xScale = display.contentWidth / bg.width; 
        sceneGroup:insert(bg) 

        local alex_kid = alex_sequence
        alex_kid.x = display.contentCenterX-80; 
        alex_kid.y = display.contentCenterY+66; 
        alex_kid.anchorX = 0; 
        alex_kid.anchorY = 1;
        alex_kid.alpha = 1
        sceneGroup:insert(alex_kid)

        local alex_bubble = bubble_alex_sequence
        alex_bubble.alpha = 1
        alex_bubble.x = display.contentCenterX-90; 
        alex_bubble.y = display.contentCenterY+15; 
        alex_bubble.anchorX = 0; 
        alex_bubble.anchorY = 1; 
        alex_bubble.xScale = 1.2
        alex_bubble.yScale = 1.2
        alex_bubble:addEventListener("tap", bubble_tap_handler);
        sceneGroup:insert(alex_bubble)
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