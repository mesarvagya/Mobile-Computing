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
    current_hand = 1
    match_count = 3
    selected_hand = nil
    alex_move_table = {[1] = "alex_rock", [2] ="alex_paper", [3] = "alex_scissor"};
    boss_move_table = {[1] = "enemy1_rock", [2] ="enemy1_paper", [3] = "enemy1_scissor"};
    alex_bubble_table = {[1] = "bubble_rock", [2] ="bubble_paper", [3] = "bubble_scissor"};

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    local alex_kid = nil 
    local boss_level1 = nil 
    local alex_bubble = nil

    local function bubble_tap_handler(event)
        -- body 
        selected_hand = current_hand           
    end

    function shoot()
        if(selected_hand) then
        -- body
            local computer_move = math.random(1, 3)
            local alex_hand = selected_hand % 3 + 1
            local alex_move = (alex_move_table[alex_hand]);

            alex_bubble:setSequence(alex_bubble_table[alex_hand]);
            alex_kid:setSequence(alex_move)

            -- boss_level1:setSequence(boss_move_table[computer_move])

            boss_level1:setSequence("enemy1_set");
            local hand = display.newImage (jankenSheet, 9 + computer_move, -- boss_rock
                 display.contentCenterX+60, 
                 display.contentCenterY+50
             );
            print("Computer move : "..computer_move.." user move : "..alex_hand)
            local result = rpcJudge(alex_hand, computer_move)
            print(result)
        else
            print("No move selected from player");
            alex_kid:pause()
            boss_level1:pause()
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

        alex_kid = alex_sequence
        alex_kid.x = display.contentCenterX-80; 
        alex_kid.y = display.contentCenterY+66; 
        alex_kid.anchorX = 0; 
        alex_kid.anchorY = 1;
        alex_kid.alpha = 1
        sceneGroup:insert(alex_kid)

        alex_bubble = bubble_alex_sequence
        alex_bubble.alpha = 1
        alex_bubble.x = display.contentCenterX-90; 
        alex_bubble.y = display.contentCenterY+15; 
        alex_bubble.anchorX = 0; 
        alex_bubble.anchorY = 1; 
        alex_bubble.xScale = 1.2
        alex_bubble.yScale = 1.2
        sceneGroup:insert(alex_bubble);


        boss_level1 = janken_sequence
        boss_level1:setSequence("enemy1_set")
        boss_level1:setFrame(7)
        boss_level1.alpha = 1
        boss_level1.x = display.contentCenterX+80;
        boss_level1.y = display.contentCenterY+66;
        boss_level1.anchorX = 1;
        boss_level1.anchorY = 1;
        sceneGroup:insert( boss_level1)

        -- ::play::
        local shake_count = 10
        moveChooseTimer = timer.performWithDelay(500, 
        function() -- This timer performs bubble change
            shake_count = shake_count - 1

            if (current_hand == 1) then
                alex_bubble:setSequence("bubble_rock");
            elseif (current_hand == 2) then
                alex_bubble:setSequence("bubble_paper");
            elseif (current_hand == 3) then
                alex_bubble:setSequence("bubble_scissor");
            end
            current_hand = ((current_hand + 1) % 3) + 1

            if(shake_count == 0) then
                print("Time over ")
                shoot()
            end
        end, 10)

        timer.pause(moveChooseTimer)
        local count_down = display.newText( sceneGroup, "3", display.contentWidth/2, display.contentHeight/2, native.systemFontBold, 200)
        local count_down_timer = timer.performWithDelay(1000,
        function()
        -- body
            count_down.text = count_down.text - 1 
            if(count_down.text == "0") then
                count_down:removeSelf()
                alex_bubble:addEventListener("tap", bubble_tap_handler);
                alex_kid:setSequence ("alex_shake");
                alex_kid:play();  
                boss_level1:setSequence("enemy1_shake");
                boss_level1:play()
                timer.resume(moveChooseTimer)
            end
        end,3)
    
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