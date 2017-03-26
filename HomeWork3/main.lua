local composer = require("composer")
display.setStatusBar( display.HiddenStatusBar )
composer.gotoScene("gamestart")

-----------------------------Main Game Logic--------------------
function rpcJudge(user, computer)
	if ((computer) % 3 + 1 == user) then 
		return "win" --User wins
	elseif ((user) % 3 + 1 == computer) then 
    	return "lose" --User lose
	else
    	return "draw" --Draw
    end
end

-----------------------------background--------------------------------
background_options =
{
  frames = {
     { x = 0, y = 0, width = 256, height = 192}, --bg1
     { x = 0, y = 192, width = 256, height = 192}, -- bg2
     { x = 256, y = 192, width = 256, height = 192}, -- bg3

  }
};
background_sheet = graphics.newImageSheet( "bg.png", background_options );
-- local bg = display.newImage (background_sheet, 1);
-- bg.x = display.contentWidth / 2;
-- bg.y= display.contentHeight / 2;



---------- ALEX KIDD ---------------------------------
local options =
{
	frames = {
		{ x = 1, y = 2, width = 16, height = 25}, --frame 1
		{ x = 18, y = 2, width = 16, height = 25}, --frame 2
		{ x = 35, y = 2, width = 16, height = 25}, --frame 3
		{ x = 52, y = 2, width = 16, height = 25}, --frame 4
		{ x = 1, y = 54, width = 16, height = 24}, --ready1
		{ x = 19, y = 54, width = 16, height = 24}, --ready2
		{ x = 37, y = 54, width = 29, height = 24}, -- rock
		{ x = 67, y = 54, width = 33, height = 24}, -- scissor
		{ x = 101, y = 54, width = 33, height = 24}, -- paper
		{ x = 1, y = 79, width= 32, height= 32}, -- bubblerock
		{ x = 35, y = 79, width= 32, height= 32}, -- bubblescissor
		{ x = 69, y = 79, width= 32, height= 32}, -- bubblepaper
	}
};
alex_image_sheet = graphics.newImageSheet( "alex.png", options );

-- Create animation sequence for animation 
local seqData = { 
	{name = "alex_normal", start=1 , count = 4, time = 800}, 
	{name = "alex_faster", frames={1,2,3,4}, time = 400}, 
	{name = "alex_shake", frames={5,6}, time = 500}, 
	{name = "alex_rock", frames={7}}, 
	{name = "alex_paper", frames={9}}, 
	{name = "alex_scissor", frames={8}}, 
}

alex_sequence = display.newSprite (alex_image_sheet, seqData);
alex_sequence.alpha = 0
-- alex_sequence.x = display.contentCenterX-80; 
-- alex_sequence.y = display.contentCenterY+66; 
-- alex_sequence.anchorX = 0; 
-- alex_sequence.anchorY = 1; 
-- alex_sequence:setSequence("alex_shake");
-- alex_sequence:play();


local bubbleSeqData = { 
	{name = "bubble_rock", frames={10}}, 
	{name = "bubble_scissor", frames={11}},
	{name = "bubble_paper", frames={12}},
} 

bubble_alex_sequence = display.newSprite (alex_image_sheet, bubbleSeqData);
bubble_alex_sequence.alpha = 0
-- bubble_alex_sequence.x = display.contentCenterX-90; 
-- bubble_alex_sequence.y = display.contentCenterY+15; 
-- bubble_alex_sequence.anchorX = 0; 
-- bubble_alex_sequence.anchorY = 1; 
-- bubble_alex_sequence.xScale = 1.2
-- bubble_alex_sequence.yScale = 1.2
-- bubble_alex_sequence:setSequence("bubble_paper");

bubble_enemy_sequence = display.newSprite (alex_image_sheet, bubbleSeqData); 
bubble_enemy_sequence.alpha = 0
-- bubble_enemy_sequence.x = display.contentCenterX+50; 
-- bubble_enemy_sequence.y = display.contentCenterY+15; 
-- bubble_enemy_sequence.anchorX = 0; 
-- bubble_enemy_sequence.anchorY = 1; 
-- bubble_enemy_sequence.xScale = 1.2
-- bubble_enemy_sequence.yScale = 1.2
-- bubble_enemy_sequence:setSequence("bubble_paper");




---------- JANKEN ---------------------------------
local jankenOpt =
{
	frames = {
		{x= 154, y= 13, width= 39, height= 48 }, -- 1. boss_shake1
		{x= 195, y= 13, width= 39, height= 48 }, -- 2. boss_shake2
		{x= 236, y= 13, width= 32, height= 48 }, -- 3. boss_set
		{x= 305, y= 13, width= 15, height= 48 }, -- 4. boss_rock
		{x= 270, y= 13, width= 16, height= 48 }, -- 5. boss_paper
		{x= 287, y= 13, width= 16, height= 48 }, -- 6. boss_scissor
		

		{x= 153, y= 62, width= 23, height= 31 }, -- 7. enemy1_shake1
		{x= 178, y= 62, width= 23, height= 31 }, -- 8. enemy1_shake2
		{x= 236, y= 62, width= 15, height= 31 }, -- 9. enemy1_set
		{x= 270, y= 62, width= 16, height= 31 }, -- 10. enemy1_rock
		{x= 304, y= 62, width= 16, height= 31 }, -- 11. enemy1_paper
		{x= 287, y= 62, width= 16, height= 31 }, -- 12. enemy1_scissor


		{x= 153, y= 96, width= 23, height= 31 }, -- 13. enemy2_shake1
		{x= 178, y= 96, width= 23, height= 31 }, -- 14. enemy2_shake2
		{x= 236, y= 96, width= 15, height= 31 }, -- 15. enemy2_set
		{x= 270, y= 96, width= 16, height= 31 }, -- 16. enemy2_rock
		{x= 304, y= 96, width= 16, height= 31 }, -- 17. enemy2_paper
		{x= 287, y= 96, width= 16, height= 31 }, -- 18. enemy2_scissor

	--[[
		{x= 69, y= 13, width= 41, height= 48 }, --flap1
		{x= 110, y= 13, width= 40, height= 48 }, --flap2
	  ]]
		
	}
};
jankenSheet = graphics.newImageSheet( "enemy.png", jankenOpt );

-- Create animation sequence janken
local seqDataJanken = {
	--{name = "boss_flap", frames={7,8}, time = 500},
	{name = "boss_shake", frames={1,2}, time = 500},
	{name = "boss_set", frames={3}, time = 10, loopCount=1},
	{name = "boss_rock", frames={4}, time = 10, loopCount=1},
	{name = "boss_paper", frames={5}, time = 10, loopCount=1},
	{name = "boss_scissor", frames={6}, time = 10, loopCount=1},

	--{name = "enemy1_flap", frames={7,8}, time = 500},
	{name = "enemy1_shake", frames={7,8}, time = 500},
	{name = "enemy1_set", frames={9}, time = 10, loopCount=1},
	{name = "enemy1_rock", frames={10}, time = 10, loopCount=1},
	{name = "enemy1_scissor", frames={11}, time = 10, loopCount=1},
	{name = "enemy1_paper", frames={12}, time = 10, loopCount=1},

	--{name = "enemy2_flap", frames={7,8}, time = 500},
	{name = "enemy2_shake", frames={13,14}, time = 500},
	{name = "enemy2_set", frames={15}, time = 10, loopCount=1},
	{name = "enemy2_rock", frames={16}, time = 10, loopCount=1},
	{name = "enemy2_scissor", frames={17}, time = 10, loopCount=1},
	{name = "enemy2_paper", frames={18}, time = 10, loopCount=1},
}
janken_sequence = display.newSprite (jankenSheet, seqDataJanken);
janken_sequence.alpha = 0
-- janken_sequence.x = display.contentCenterX+80;
-- janken_sequence.y = display.contentCenterY+66;
-- janken_sequence.anchorX = 1;
-- janken_sequence.anchorY = 1;
--janken_sequence:setSequence("enemy2_rock");

-- local function play ()
	
-- 		alex_sequence:setSequence ("alex_shake");
-- 		alex_sequence:play();

-- 		janken_sequence:setSequence("boss_shake");
-- 		janken_sequence:play();

	
-- end


-- local function shoot ()
-- 	print("inside the shoot")
-- 	janken_sequence:setSequence("boss_set");
-- 	hand = display.newImage (jankenSheet, 4, -- boss_rock
-- 		display.contentCenterX+41,
-- 		display.contentCenterY+42
-- 	);

-- 	alex_sequence:setSequence("alex_scissor"); -- just show rock for now
-- 	print("ended the shoot")
-- end

-- play();

--Shake for a while before revealing the hand
-- local t = timer.performWithDelay (3000, shoot, 1);








