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
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local params = event.params
        local nextLevel = params.level
        -- Code here runs when the scene is first created but has not yet appeared on screen 
        local index = math.random(1, 2)   
        local lvlmsg = nil

        if(nextLevel == 2) then
            lvlmsg = level1_to_2[index]
        elseif(nextLevel == 3) then
            lvlmsg = level2_to_3[index]
        end

        local gotomsg = "Go to level : "..nextLevel
        local nextlevelfile = "level"..nextLevel

        levelmessage = display.newText(sceneGroup, lvlmsg, display.contentWidth/2, display.contentHeight/4, native.systemFontBold, 15)
        gotolevelmsg = display.newText(sceneGroup, gotomsg, display.contentWidth/2, display.contentHeight/3, native.systemFontBold, 20)
        gotolevelmsg:addEventListener("tap", 
            function(event)
                -- body
                print("In here to go next level")
                local options = {effect = "fade", time = 500}
                composer.gotoScene(nextlevelfile, options)
            end
         )
 
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
        levelmessage:removeSelf()
        gotolevelmsg:removeSelf()
 
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