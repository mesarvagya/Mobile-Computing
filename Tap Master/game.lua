local composer = require( "composer" )
local widget = require("widget")
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local correct_tap = 0
local incorrect_tap = 0
local min_value = 1
local max_value = 5
local counter = 0
local positive = display.newText("",150,20,native.systemFont, 10)
local negative = display.newText("",150,40,native.systemFont, 10)
local box_table = {}

local function goToGameStart( event )
    local options = {effect = "fade", time = 800}
    composer.gotoScene("gamestart", options)
end

local function positiveCount( event )
    correct_tap = correct_tap + 1
    positive.text = correct_tap

end

local function negativeCount( event )
    incorrect_tap = incorrect_tap + 1
    negative.text = incorrect_tap
end

local function drawRect()
    print("drawing rect")
    
    local type = ""
    if(math.random() < 0.5) then
        type='red'
    else
        type='blue'
    end
    if(type == 'red') then
        local redbox = display.newRoundedRect(display.contentCenterX, display.contentCenterY, 50, 50, 12)
        redbox:setFillColor(1,0,0)
        redbox:addEventListener("tap", positiveCount)
    else
        local bluebox = display.newRoundedRect(display.contentCenterX, display.contentCenterY, 50, 50, 12)
        bluebox:setFillColor(0,0,1)
        bluebox:addEventListener("tap", negativeCount)
    end
    box_table:insert(bluebox)
    
end

local function startGame(event)
    print("game started")
    local timegot = math.random(min_value, max_value)
    print("time ", timegot)

    timer.performWithDelay(timegot * 1000, drawRect, 10)
 end

local function handleReady(event)
    print("handling the i am ready", event.phase)
    if(event.phase == "began") then
        print("starting game on 3 sec")
        event.target.alpha = 0
        timer.performWithDelay(3000, startGame)
    end 
end


 
 
 
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
        local backbtn = widget.newButton({
            left = 50,
            top = 50,
            id = "backButton",
            onEvent = goToGameStart,
            defaultFile = "back.png",
            overFile = "back.png"

        })
        backbtn.x = 40
        backbtn.y = 20
        local background = display.newImage("background_game.png")
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        sceneGroup:insert(background)

        local readyText = display.newText("I am ready!!!", 150, 50, native.systemFont, 20)
        readyText:addEventListener("touch", handleReady)
        
        sceneGroup:insert(backbtn)
        sceneGroup:insert(readyText)
 
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
    print('destroy called')
 
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