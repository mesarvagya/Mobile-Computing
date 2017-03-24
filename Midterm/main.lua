-----------------------------------------------------------------------------------------
-- Code for Midterm Exam
-- Sarvagya Pant
--
-----------------------------------------------------------------------------------------
 ---- Initializing required variables here
local correct_tap = 0
local incorrect_tap = 0
local missed_tap = 0
local color = { {255,0,0}, {0,255,0}, {0,0,255}, {255,255,0}, {0,255,255}, {255,0,255} }
local circle_count = 0
local square_count = 0
local rounded_rect_count = 0
local all_count = 50

---- Making labels for showing scores
local correct_label = display.newText("Correct = ",50,0,native.systemFont,15)
local correct_text = display.newText("",100,0,native.systemFont,15)
local incorrect_label = display.newText("Incorrect = ",50,15,native.systemFont,15)
local incorrect_text = display.newText("",100,15,native.systemFont,15)
local missed_label = display.newText("Missed = ",50,30,native.systemFont,15)
local missed_text = display.newText("",100,30,native.systemFont,15)


---- Handle the correct and incorrect tap based on the name assigned to the object.
local function handle_tap( event )
	event.target.is_clicked = true
	if(event.target.myName == "circle" or event.target.myName == "square") then
		incorrect_tap = incorrect_tap + 1
		incorrect_text.text = incorrect_tap
	elseif(event.target.myName == "rounded_rect") then
		correct_tap = correct_tap + 1
		correct_text.text = correct_tap
		event.target.alpha = 0
	end
end

-- randomly generate the object, set a name for the object and fill color randomly.
local function generate_object()
	local rand = math.random()
	local obj = nil
	local x = math.random(50,250)
	local rnd_color = math.random(1,6)
	local color = color[rnd_color]
	if(rand > 0 and rand < 0.3) then
		-- print("drawing the circle")
		obj = display.newCircle(x,-10, 30)
		obj.anchorX = 0
		obj.anchorY = 0
		obj.myName = "circle"
		obj:setFillColor(unpack(color))
		circle_count = circle_count + 1
	elseif(rand > 0.3 and rand < 0.6) then
		-- print("drawing the square")
		obj = display.newRect(x,-10,50,50)
		obj.anchorX = 0
		obj.anchorY = 0
		obj.myName = "square"
		obj:setFillColor(unpack(color))
		square_count = square_count + 1
	else
		-- print("drawing the rounded rect")
		obj = display.newRoundedRect(x,-10,50,50,12)
		obj.anchorX = 0
		obj.anchorY = 0
		obj.myName = "rounded_rect"
		rounded_rect_count = rounded_rect_count + 1
		obj:setFillColor(unpack(color))
	end

	obj.is_clicked = false -- A flag to make sure that object was tapped before increasing the missed count.
	obj:addEventListener("tap",handle_tap)

	transition.to( obj, { time=(math.random(1,5) * 1000), x = obj.x, y = display.contentHeight * 1.2, onComplete=function ()
		if(obj.is_clicked ~= true and obj.myName == "rounded_rect") then
			-- rounded_rect was not clicked because is_clicked is set to false. So increase the missed count.
			missed_tap = missed_tap + 1
			missed_text.text = missed_tap
		end

		all_count = all_count - 1
		if(all_count == 0) then
			-- game is over. Just show the native Alert
			local msg = "Circ: " .. circle_count .. " Rect " .. square_count .. " RndRect " .. rounded_rect_count
			msg = msg  ..'\nCorrect Tap: ' .. correct_tap .. ' Incorrect Tap: ' .. incorrect_tap .. ' Missed Tap: ' .. missed_tap
			local alert = native.showAlert( "Game Over !!!", msg , function(event)
      if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
          -- Do nothing; dialog will simply dismiss
        elseif ( i == 2 ) then
        	-- Do nothing 
        end
      end

      end )
		end
	end
	} )
end

local tm = timer.performWithDelay(500, generate_object, all_count)