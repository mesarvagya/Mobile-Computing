local physics = require("physics");
local composer = require("composer")
local Enemy = require ("Enemy");
local soundTable = require("soundTable");
local player = require("player");

physics.start();
physics.setGravity(0,0);


local Pentagon = Enemy:new( {HP=3, fR=720, fT=700,
bT=700});

function Pentagon:spawn()
  self.shape = display.newPolygon (self.xPos,
  self.yPos, { 0,-37, 37,-10, 23,34, -23,34, -37,-10 });
  self.shape.pp = self;
  self.shape.tag = "enemy";
  self.shape:setFillColor ( 1,1,0);
  physics.addBody(self.shape, "dynamic");
  self:handle_collision_with_other()
end

function Pentagon:move()
  transition.to(self.shape, { time=10000, x=self.xPos, y=display.contentHeight * 1.2})
end


------------Triangle
local Triangle = Enemy:new( {HP=1, bR=360, fT=500,
bT=300});

function Triangle:spawn()
  self.shape = display.newPolygon(self.xPos, self.yPos,
  {-15,-15,15,-15,0,15});

  self.shape.pp = self;
  self.shape.tag = "enemy";
  self.shape:setFillColor ( 0, 0, 1);
  physics.addBody(self.shape, "dynamic",{shape={-15,-15,15,-15,0,15}});
  self:handle_collision_with_other()
end

function Triangle:shoot(interval)
  interval = interval or 1500;
  local function createShot( obj)
    if(obj ~= nil and obj.shape ~= nil and self.player ~= nil and self.player.shape ~= nil) then
      local p = display.newRect (obj.shape.x, obj.shape.y+50, 10,10);
      self.sceneGroup:insert(p)
      p:setFillColor(1,0,0);
      p.anchorY=0;
      physics.addBody (p, "dynamic");
      local multiplier = (1/800)
      if(p.y <= self.player.shape.y ) then
        p:applyForce((self.player.shape.x - self.shape.x) * multiplier, (self.player.shape.y - self.shape.y) * multiplier, p.x, p.y)
      else
        p:removeSelf()
        p = nil
      end
      local function shotHandler (event)
        if (event.phase == "began") then
          if(event.other.tag == "player") then
            event.other.pp:hit()
          end
          event.target:removeSelf();
          event.target = nil;
        end
      end
      if(p ~= nil) then p:addEventListener("collision", shotHandler); end
    end
  end
  self.timerRef = timer.performWithDelay(interval, function (event) createShot(self) end, -1);
end

function Triangle:move()
  print("player in Triangle:move")
  if(self ~= nil and self.player ~= nil and self.player.shape ~= nil and self.shape ~= nil) then
    transition.to(self.shape, {time = 8000, x = self.player.shape.x, y = self.player.shape.y*1.5})
  end
end

local game_scenes = {}
game_scenes.enemies = {}
local game_loop_count = 0

local scene = composer.newScene()
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
    local background = display.newImage("sky.png")
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)
    game_scenes.background = background

    local controlBar = display.newRect (display.contentCenterX, display.contentHeight-65, display.contentWidth, 70);
    controlBar:setFillColor(1,1,1, 0.7);
    sceneGroup:insert(controlBar)
    game_scenes.controlBar = controlBar

    local player = player:new({HP = 5, xPos = display.contentWidth/2, yPos = display.contentHeight/1.32})
    game_scenes.player = player
    player:spawn()
    sceneGroup:insert(player.shape)

    local outermost_wall = display.newRect(0,display.contentHeight * 1.0, display.contentWidth, display.contentHeight)
    outermost_wall.anchorX = 0
    outermost_wall.anchorY = 0
    sceneGroup:insert(outermost_wall)
    game_scenes.outermost_wall = outermost_wall
    outermost_wall.tag = "wall"
    outermost_wall.alpha = 0

    ---Score
    local scoreText = display.newEmbossedText( "Hit: ", 200, 50,native.systemFont, 40 );
    scoreText:setFillColor( 0,0.5,0 );
    local color =
    {
      highlight = {0,1,1},
      shadow = {0,1,1}
    }
    scoreText:setEmbossColor( color );
    sceneGroup:insert(scoreText)
    game_scenes.scoreText = scoreText

    scoreVal =display.newEmbossedText( "0", 270, 50,native.systemFont, 40 );
    scoreVal:setFillColor( 0,0.5,0 );
    local color =
    {
      highlight = {0,1,1},
      shadow = {0,1,1}
    }
    scoreVal:setEmbossColor( color );
    sceneGroup:insert(scoreVal)
    game_scenes.scoreVal = scoreVal



    physics.addBody(outermost_wall, "static")

    function control_bar_listener(event)
      if(player ~= nil) then player:move(event) end
    end

    function player_fire_listener(event)
      if(player ~= nil) then player:fire(event) end
    end

    game_scenes.control_bar_listener = control_bar_listener
    game_scenes.player_fire_listener = player_fire_listener

    game_scenes.controlBar:addEventListener("touch", control_bar_listener)
    game_scenes.background:addEventListener("tap", game_scenes.player_fire_listener)



  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    local game_loop_timer = timer.performWithDelay(1000, function()
    -- body
    game_loop_count = game_loop_count + 1
    if(math.random() > 0.6) then
      local tri = Triangle:new({xPos=math.random(1,275), player=game_scenes.player, sceneGroup=sceneGroup});
      tri:spawn();
      sceneGroup:insert(tri.shape)
      tri:move();
      tri:shoot(1000);
      table.insert(game_scenes.enemies, tri)
    else
      local pnt = Pentagon:new({xPos=math.random(1,275), player=game_scenes.player, sceneGroup=sceneGroup});
      pnt:spawn();
      sceneGroup:insert(pnt.shape)
      pnt:move();
      pnt:shoot(1000);
      table.insert(game_scenes.enemies, pnt)
    end

    if(game_scenes.player:getHitPoint() < 1) then
      timer.cancel(game_scenes.game_loop_timer)
      print("hp kam bho " .. game_scenes.player:getHitPoint())
      local opt = {effect = "fade",time = 500,params = {win = false}}
      composer.gotoScene("ending", opt)
    end

    if(game_loop_count == 180) then
      timer.cancel(game_scenes.game_loop_timer)
      local opt = {effect = "fade",time = 500,params = {win = true}}
      composer.gotoScene("ending", opt)
    end

    end, 60 * 3)
    game_scenes.game_loop_timer = game_loop_timer

  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)
    game_scenes.controlBar:removeEventListener("touch", control_bar_listener)
    game_scenes.background:removeEventListener("tap", game_scenes.player_fire_listener)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    local enemies = game_scenes.enemies
    for i, v in ipairs(enemies) do
      if(v ~= nil and v.shape~=nil) then
        v.shape:removeSelf()
        v.shape = nil
        v = nil
      end
    end
    scoreVal.text = 0
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
