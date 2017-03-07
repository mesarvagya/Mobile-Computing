local composer = require( "composer" )
local widget = require("widget")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local correct_tap = 0
local incorrect_tap = 0
local min_value = composer.getVariable("min_value")
local max_value = composer.getVariable("max_value")
local counter = 0
local positive, positive_label, negative, negative_label
local timer_list = {}
local time_transition = nil

local box_table = {}

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
  local iterations = 10
  local start_time, end_time;

  local function goToGameStart( event )
    local options = {effect = "fade", time = 800}
    composer.gotoScene("gamestart", options)
  end

  local function positiveCount( event )
    correct_tap = correct_tap + 1
    positive.text = correct_tap
    return true
  end

  local function negativeCount( event )
    incorrect_tap = incorrect_tap + 1
    negative.text = incorrect_tap
    return true
  end

  local function drawRect(event)
    local timegot = event.source.params.time
    local box = nil

    local type = ""
    local rand = math.random()
    if( rand < 0.5) then
      type='red'
    else
      type='blue'
    end
    print("drwaing rect type = ", type, " random = ", rand)
    if(type == 'red') then
      box = display.newRoundedRect(display.contentCenterX, display.contentCenterY, 150, 150, 12)
      box:setFillColor(1,0,0)
      box:addEventListener("tap", negativeCount)
    else
      box = display.newRoundedRect(display.contentCenterX, display.contentCenterY, 150, 150, 12)
      box:setFillColor(0,0,1)
      box:addEventListener("tap", positiveCount)
    end
    sceneGroup:insert(box)
    local remove_timer = timer.performWithDelay(timegot * 100, function()
    box:removeSelf()
    iterations = iterations - 1
    if (iterations == 0) then
      end_time = os.time()
      local score_correct = correct_tap / ( end_time - start_time )
      local score_incorrect = incorrect_tap / ( end_time - start_time )
      local msg = "You won the game :). Avg Correct Score = " .. score_correct
      print(msg)
      local alert = native.showAlert( "You won!!", msg , function(event)
      if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
          -- Do nothing; dialog will simply dismiss
        elseif ( i == 2 ) then
          -- Open URL if "Learn More" (second button) was clicked
          -- system.openURL( "http://www.coronalabs.com" )
        end
      end

      end )
    end
    end,1)

    -- table.insert(timer_list, remove_timer)
  end

  local function startGame(event)
    print("game started")
    local timegot = math.random(min_value*10, max_value*10)
    -- time_transition = timegot
    print("time ", timegot/10)
    start_time = os.time()
    local tm = timer.performWithDelay(timegot * 100, drawRect, 10)
    tm.params = {time=timegot}
    print("tm ", tm)
    table.insert(timer_list, tm)
  end

  local function handleReady(event)
    print("handling the i am ready", event.phase)
    if(event.phase == "began") then
      print("starting game on 3 sec")
      event.target.alpha = 0
      -- timer.performWithDelay(3000, startGame)
      startGame()
    end
  end

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

    positive = display.newText("",210,0,native.systemFont, 15)
    positive_label = display.newText("Correct Tap = ",150,0,native.systemFont, 15)
    negative = display.newText("",210,15,native.systemFont, 15)
    negative_label = display.newText("Incorrect Tap = ",150,15,native.systemFont, 15)
    sceneGroup:insert(positive)
    sceneGroup:insert(positive_label)
    sceneGroup:insert(negative)
    sceneGroup:insert(negative_label)

    sceneGroup:insert(backbtn)
    sceneGroup:insert(readyText)
    print("correct_tap = ", correct_tap, " incorrect_tap = ", incorrect_tap)

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
    print("game scene is hidden")
    correct_tap = 0
    incorrect_tap = 0
    positive.text=""
    negative.text=""
    for i=1,#timer_list do
      if timer_list[i] ~= nil then timer.cancel(timer_list[i]) end
    end

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