local print_r = require("print_r")
_W = display.contentWidth
_H = display.contentHeight
local images_table = {1,1,2,2,3,3,4,4,5,5,6,6}

function mainMenu()
  menuScreenGroup = display.newGroup()
  mmScreen = display.newImage("mmscreen.png", 0, 0,true)
  mmScreen.x = _W / 2
  mmScreen.y = _H / 2
  playBtn = display.newImage("playbtn.png")
  playBtn.anchorX = 0.5;
  playBtn.anchorY = 0.5;
  playBtn.x = _W/2;
  playBtn.y = _H/2 + 50;
  playBtn.name = "playbutton"
  menuScreenGroup:insert(mmScreen)
  menuScreenGroup:insert(playBtn)
end

function loadGame(event)
  if event.target.name == "playbutton" then
    transition.to(menuScreenGroup,{time = 0, alpha=0, onComplete = addGameScreen})
    playBtn:removeEventListener("tap", loadGame)
  end
end

local first_card, last_card;
local matching_check = false;
local last_card_selected = false

matched = 0
function whenImageClicked(event)
  if(event.phase == "began") then
    print("len of backgrounds " .. #backgrounds)
    print(matching_check, last_card_selected)
    transition.scaleBy(event.target, { xScale=0.5, yScale=0.5, time=500 })
    if (matching_check == false and last_card_selected == false) then
      matching_check = true
      last_card = event.target
      local test = event.target.number
      print("First card number " .. test)
      backgrounds[test].isVisible = false
    elseif (matching_check == true) then
      print("second card selected " .. event.target.number)
      if (last_card_selected == false) then
        backgrounds[event.target.number].isVisible = false
        print("second card should be visible")
        last_card_selected = true
        print("First card type " .. event.target.type .. " second card type " .. last_card.type)
        if (event.target.type == last_card.type) then
          timer.performWithDelay(1000, function()
          print("match found")
          matched = matched + 2
          matching_check = false
          last_card_selected = false
          event.target:removeSelf()
          last_card:removeSelf()
          backgrounds[event.target.number]:removeSelf()
          backgrounds[last_card.number]:removeSelf()
          if (matched == 12) then
            local text = display.newText("YOU WON !!!", 145, 450, native.systemFontBold, 24)
            text:setFillColor( 1, 0, 0.5 )
            timer.pause(main_timer)
          end
          end, 1);


        elseif (event.target.type ~= last_card.type) then
          timer.performWithDelay(1000, function()
          print("match not found")
          transition.scaleBy(event.target, { xScale=-0.5, yScale=-0.5, time=500 })
          transition.scaleBy(last_card, { xScale=-0.5, yScale=-0.5, time=500 })
          matching_check = false
          last_card_selected = false
          backgrounds[event.target.number].isVisible = true
          backgrounds[last_card.number].isVisible = true
          end, 1)
        end
      end
    end
  end
end

function stopWatch()
  text_count.text = text_count.text + 1

end

function addGameScreen()


  text_time = display.newText("Time", 140,400)
  text_count = display.newText("0", 140,420)
  main_timer = timer.performWithDelay(1000, stopWatch, 0)
  memory = display.newGroup()
  backgrounds = {}
  local number = 0
  for col = 1 , 4 do
    for row = 1, 3 do
      local x = row * 50 + 50 * (row - 1)
      local y = col * 50 + 50 * (col - 1)
      local temp_random = math.random(1, #images_table)
      local image = display.newImage("rocket_" .. images_table[temp_random] .. ".png")
      local background = display.newImage("background.jpg")

      number = number + 1
      image.x = x
      image.y = y
      image.number = number
      background.x = x
      background.y = y
      backgrounds[number] = background

      image.type = images_table[temp_random]
      image:addEventListener("touch", whenImageClicked)
      table.remove(images_table, temp_random)
      memory:insert(image)
    end
  end
end

mainMenu()
playBtn:addEventListener("touch", loadGame);