local composer = require( "composer" )
local widget = require("widget")
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


    local function handleHost(event)
      -- body
      if(event.phase == "began") then
        composer.gotoScene("server", {effect="fade", time=1000})
      end
    end

    local function handleClient(event)
      -- body
      if(event.phase == "began") then
        composer.gotoScene("client",{effect="fade", time=1000})
      end
    end

    local host = widget.newButton({
      left = 50,
      top = 50,
      id = "hostButton",
      onEvent = handleHost,
      defaultFile = "host.png",
      overFile = "host.png"
    })
    host.anchorX = 0
    host.anchorY = 0
    host:scale(2,2)
    sceneGroup:insert(host)

    local guest = widget.newButton({
      left = 320,
      top = 50,
      id = "guestButton",
      onEvent = handleClient,
      defaultFile = "guest.png",
      overFile = "guest.png"
    })
    guest.anchorX = 0
    guest.anchorY = 0
    guest:scale(2,2)
    sceneGroup:insert(guest)

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