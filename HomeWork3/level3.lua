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
    alex_kid_lvl3 = nil 
    boss_level3 = nil 
    alex_bubble_lvl3 = nil
    hand = nil
    created_lvl3 = true
    current_hand = 1
    match_count = 5
    alex_score_count = 0
    selected_hand = nil
    alex_move_table = {[1] = "alex_rock", [2] ="alex_paper", [3] = "alex_scissor"};
    boss_move_table = {[1] = "boss_rock", [2] ="boss_paper", [3] = "boss_scissor"};
    alex_bubble_lvl3_table = {[1] = "bubble_rock", [2] ="bubble_paper", [3] = "bubble_scissor"};

    --Loading the background
    local bg = display.newImage (background_sheet, 3);
        bg.x = display.contentWidth / 2;
        bg.y= display.contentHeight / 2;
        bg.xScale = display.contentWidth / bg.width; 
        sceneGroup:insert(bg) 
    --Loading the alex kid image
        alex_kid_lvl3 = alex_sequence
        alex_kid_lvl3.x = display.contentCenterX-80; 
        alex_kid_lvl3.y = display.contentCenterY+63; 
        alex_kid_lvl3.anchorX = 0; 
        alex_kid_lvl3.anchorY = 1;
        alex_kid_lvl3.alpha = 1
        sceneGroup:insert(alex_kid_lvl3)
    --Loading the bubble to show select move options
        alex_bubble_lvl3 = bubble_alex_sequence
        alex_bubble_lvl3.alpha = 1
        alex_bubble_lvl3.x = display.contentCenterX-90; 
        alex_bubble_lvl3.y = display.contentCenterY+15; 
        alex_bubble_lvl3.anchorX = 0; 
        alex_bubble_lvl3.anchorY = 1; 
        alex_bubble_lvl3.xScale = 1.2
        alex_bubble_lvl3.yScale = 1.2
        sceneGroup:insert(alex_bubble_lvl3);

    --Loading the boss/enemy here
        boss_level3 = janken_sequence
        boss_level3:setSequence("boss_set")
        boss_level3:setFrame(1)
        boss_level3.alpha = 1
        boss_level3.x = display.contentCenterX+80;
        boss_level3.y = display.contentCenterY+63;
        boss_level3.anchorX = 1;
        boss_level3.anchorY = 1;
        sceneGroup:insert( boss_level3)
    ---Text to display alexkidd, enemy and level information 
    local leveltext = display.newText( sceneGroup, "Level 3", display.contentWidth/2, display.contentHeight/12, native.systemFontBold, 16)
    local alextext = display.newText( sceneGroup, "Alex Kidd:", display.contentWidth/8, display.contentHeight/12, native.systemFontBold, 16)
    local enemytext = display.newText( sceneGroup, "Enemy:", display.contentWidth/1.3, display.contentHeight/12, native.systemFontBold, 16)
    ---The actual score texts
    alex_score = display.newText( sceneGroup, "0", display.contentWidth/3.7, display.contentHeight/12, native.systemFontBold, 16)
    enemy_score = display.newText( sceneGroup, "0", display.contentWidth/1.13, display.contentHeight/12, native.systemFontBold, 16)
    --The win msg displayed after each game
    win_msg = display.newText( sceneGroup, "", display.contentWidth/2, display.contentHeight/1.2, native.systemFontBold, 30)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    --Event handler for clicking on bubble to select the move
    local function bubble_tap_handler(event)
        -- body 
        audio.play(soundTable["selectSound"])
        selected_hand = current_hand           
    end
    --The function gets called at the game play
    function shoot()
        if(selected_hand) then
        -- body
            ---Randomly generate the computer move
            local computer_move = math.random(1, 3)
            -- local computer_move = 1
            ---Get the move selected by user
            local alex_hand = selected_hand % 3 + 1
            --Chose corresponding move sprite
            local alex_move = (alex_move_table[alex_hand]);

            alex_bubble_lvl3:setSequence(alex_bubble_lvl3_table[alex_hand]);
            alex_kid_lvl3:setSequence(alex_move)

            -- boss_level3:setSequence(boss_move_table[computer_move])
            --Computer move sprite
            boss_level3:setSequence("boss_set");
            hand = display.newImage (jankenSheet, 3 + computer_move, -- boss_rock
                 display.contentCenterX+46, 
                 display.contentCenterY+38
             );
            sceneGroup:insert(hand)
            print("Match number : "..match_count)
            print("Computer move : "..computer_move.." user move : "..alex_hand)
            --This function judges who wins
            local result = rpcJudge(alex_hand, computer_move)
            print(result)
            audio.play(soundTable["resultSound"])

            if(result == "win") then
                ---If alex wins his score is updated and victory msg is displayed
                alex_score.text = alex_score.text + 1
                alex_score_count = alex_score_count + 1
                match_count = match_count - 1
                win_msg.text = "Victory!"
            elseif(result == "lose") then
                ---If enemy wins its score is updated and you lose msg is displayed
                enemy_score.text = enemy_score.text + 1
                match_count = match_count - 1
                win_msg.text = "You lose"
            else
                ---Draw message on game draw
                win_msg.text = "Draw"
            end

            if(match_count > 0) then
                --If match is still left (3 rounds) delay for 3 sec and go to next round
                local pause_timer = timer.performWithDelay(3000,
                function ()
                    -- body
                    alex_kid_lvl3:pause()
                    boss_level3:pause()
                    hand:removeSelf()
                    alex_kid_lvl3:setSequence ("alex_shake");
                    current_hand = 1
                    selected_hand = nil
                    win_msg.text = ""
                    -- alex_bubble_lvl3.isEnabled = false
                    scene:show(event) 
                end,1)
            else
                ---If match is over (3 rounds played) then goto 
                ---level break or end depending 
                ---Upon wether the alex kid wins or loses
                timer.performWithDelay(100,
                    function ()
                        alex_kid_lvl3:pause()
                        boss_level3:pause()
                        hand:removeSelf()
                        alex_kid_lvl3:setSequence ("alex_shake");
                    end, 1)
                if(alex_score_count >= 3) then
                    local msg = "You won : "..alex_score_count.." - "..(3-alex_score_count)
                    print(msg)
                    local options = {
                                    effect = "fade", 
                                    time = 400,
                                    params = {
                                            message = msg
                                        }   
                                    }
                    --Intermediate scene between each level
                    composer.gotoScene("end", options)
                else
                    --If alex kid loses go to the end
                    local msg = "You lost : "..alex_score_count.." - "..(3-alex_score_count)
                    local options = {effect = "fade", time = 1000,
                                    params = {
                                            message = msg
                                        }
                                    }
                    composer.gotoScene("end", options)
                end
            end
        else
            ---If played does not chose any action during the game time 
            ---then go to the end scene
            print("No move selected from player");
            local options = {effect = "fade", time = 1000, params = {message=""}}
            composer.gotoScene("end", options)
        end
    end

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        if(not created_lvl3) then
            print("Lvl3 Okay scene again created")
            scene:create(event)
        end
        print("lvl3 scene already exits")
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- ::play::
        ---This is timer to rotate the bubble showing different moves
        ---Create the timer and pause it
        local shake_count = 6
        moveChooseTimer = timer.performWithDelay(500, 
        function() -- This timer performs bubble change
            shake_count = shake_count - 1

            if (current_hand == 1) then
                alex_bubble_lvl3:setSequence("bubble_rock");
            elseif (current_hand == 2) then
                alex_bubble_lvl3:setSequence("bubble_paper");
            elseif (current_hand == 3) then
                alex_bubble_lvl3:setSequence("bubble_scissor");
            end
            current_hand = ((current_hand + 1) % 3) + 1

            if(shake_count == 0) then
                --After the time of 5 sec the game is played
                --During this time the player has chosen it move
                print("Time over ")
                shoot()
            end
        end, 6)
        --Pausing above timer
        timer.pause(moveChooseTimer)
        --Showing count down from 3 to 1
        --Count down performed for 3 seconds
        local count_down = display.newText( sceneGroup, "3", display.contentWidth/2, display.contentHeight/2, native.systemFontBold, 200)
        local count_down_timer = timer.performWithDelay(1000,
        function()
        -- body
            count_down.text = count_down.text - 1 
            if(count_down.text == "0") then
                count_down:removeSelf()
                -- alex_bubble_lvl3.isEnabled = true
                alex_bubble_lvl3:addEventListener("tap", bubble_tap_handler);
                alex_kid_lvl3:setSequence ("alex_shake");
                alex_kid_lvl3:play();  
                boss_level3:setSequence("boss_shake");
                boss_level3:play()
                --After the end of count down
                --Above timer is resumed
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
        ---The count and other vars are reset 
        alex_score_count = 0
        alex_score.text = "0"
        enemy_score.text = "0"
        current_hand = 1
        match_count = 5
        win_msg.text = ""
        selected_hand = nil
        created_lvl3 = false
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