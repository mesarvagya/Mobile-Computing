local composer = require( "composer" )
local widget = require("widget")
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 --Changing between default and custom radio button event handler
 local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
    if(switch.id == 'RadioButton1') then 
        composer.setVariable("default_setting", true)
        composer.setVariable("min_value", 0.5)
        composer.setVariable("max_value", 5)
        minValueText.text = 0.5
        maxValueText.text = 5
    end

    if(switch.id == 'RadioButton2') then
        composer.setVariable("default_setting", false)
        local last_min = composer.getVariable("last_min")
        local last_max = composer.getVariable("last_max")
        if(not last_min) then
            last_min = 0.5
        end
        if(not last_max) then
            last_max = 5
        end
        minValueText.text = last_min
        maxValueText.text = last_max
        composer.setVariable("min_value", last_min)
        composer.setVariable("max_value", last_max)
    end
end
--helper function to get min value
local function getMin(val1)
    maxVal = composer.getVariable("max_value")
    if(val1 > 0 and val1 < maxVal) then
        return val1
    else
        return 0.5
    end
end
--Helper function to get max value 
local function getMax(val1)
    minVal = composer.getVariable("min_value")
    if(val1>minVal) then
        return val1
    else
        return (minVal+5)%100
    end
end
--Min value slider event listener
local function slider_c_min_listener(event)
    local currentSetting = composer.getVariable("default_setting");
    if(not currentSetting) then
        local val1 = getMin(event.value)
        composer.setVariable("min_value", val1)
        composer.setVariable("last_min", val1)
        minValueText.text = val1
    end
    print("Slider min value")
    print(composer.getVariable("min_value"))
end
--Max slider event listerner
local function slider_c_max_listener(event)
    local currentSetting = composer.getVariable("default_setting");
    if(not currentSetting) then
        local val1 = getMax(event.value)
        composer.setVariable("max_value", val1)
        composer.setVariable("last_max", val1)
        maxValueText.text = val1
    end
    print("Slider max value")
    print(composer.getVariable("max_value"))
end

--Back button event handler
function handleButtonEvent(event)
    composer.gotoScene("gamestart")
end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local width = display.contentWidth
    local height = display.contentHeight
    --This is button for go back event
    local button1 = widget.newButton({
            label = "Go to Main Menu",
            onEvent = handleButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 150,
            height = 40,
            cornerRadius = 2,
            fillColor = { default={240/255, 243/255, 244/255}, over={1,0.1,0.7,0.4} },
        })
        button1.anchorX = 0
        button1.anchorY = 0
        button1.x = 50
        button1.y = 5

        sceneGroup:insert(button1)

        --Label displaying min value
        local minLabel = display.newText(sceneGroup, "Min Value: ",60,360,native.systemFontBold,20)
        -- minLabel:setFillColor(0,0,0)
        --Label displaying max value
        local maxLabel = display.newText(sceneGroup, "Max Value: ",60,410,native.systemFontBold,20)
        -- maxLabel:setFillColor(0,0,0)
        --Text to display update min value
        minValueText = display.newText(sceneGroup, "0.5",135,360,native.systemFontBold,20)
        -- minValueText:setFillColor(0,0,0)
        --Text to display update max value
        maxValueText = display.newText(sceneGroup, "5",135,410,native.systemFontBold,20)
        -- maxValueText:setFillColor(0,0,0)

        --Radio Group to hold default and custom speed selection
        local radioGroup = display.newGroup()
        --Default setting radio button
        local radioButton1 = widget.newSwitch(
            {
                left = 5,
                top = 50,
                style = "radio",
                id = "RadioButton1",
                initialSwitchState = composer.getVariable("default_setting"),
                onPress = onSwitchPress
            }
        )
        radioGroup:insert( radioButton1 )
         
        local defaul_text = display.newText( sceneGroup, "Default",75, 65, native.systemFontBold, 15 )
        local min_text = display.newText( sceneGroup, "Min",25, 100, native.systemFontBold, 15 )
        local max_text = display.newText( sceneGroup, "Max",25, 140, native.systemFontBold, 15 )
         
        -- Create the widget
        --Slider for showing default value
        local slider_d_min = widget.newSlider(
            {
                top = 80,
                left = 35,
                width =250 ,
                value = 0.5,  -- Start slider at 10% (optional)
            }
        )
        -- Create the widget
        --Slider for showing default max value
        local slider_d_max = widget.newSlider(
            {
                top = 120,
                left = 57,
                width =250,
                value = 50,  -- Start slider at 10% (optional)

            }
        )
        --Custom setting radio
        local radioButton2 = widget.newSwitch(
            {
                left = 5,
                top = 180,
                style = "radio",
                id = "RadioButton2",
                initialSwitchState = not composer.getVariable("default_setting"),
                onPress = onSwitchPress
            }
        )
        radioGroup:insert( radioButton2 )
        sceneGroup:insert(radioGroup)

        local custom_text = display.newText( sceneGroup, "Custom",75, 195, native.systemFontBold, 15 )
        local c_min_text = display.newText( sceneGroup, "Min",25, 240, native.systemFontBold, 15 )
        local c_max_text = display.newText( sceneGroup, "Max",25, 280, native.systemFontBold, 15 )

        -- Create the widget
        local slider_c_min = widget.newSlider(
            {
                top = 220,
                left = 35,
                width =250 ,
                value = 0,  -- Start slider at 10% (optional)
                listener = slider_c_min_listener
            }
        )

        -- Create the widget
        local slider_c_max = widget.newSlider(
            {
                top = 260,
                left = 35,
                width =250,
                value = 0,  -- Start slider at 10% (optional)
                listener = slider_c_max_listener

            }
        )
        sceneGroup:insert(slider_c_min)
        sceneGroup:insert(slider_c_max)
        sceneGroup:insert(slider_d_min)
        sceneGroup:insert(slider_d_max)
end
 
 
-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        print("In scene will")
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- local background = display.newImage("background.jpeg")
        -- background.x = display.contentCenterX
        -- background.y = display.contentCenterY
        -- sceneGroup:insert(background)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        print("in scene did")
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        print("In scene hide will")
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        print("In scene hide did") 
    end
end
 
 
-- destroy()
function scene:destroy( event )
    print("In scene destroy")
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