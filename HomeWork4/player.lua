local soundTable=require("soundTable");
local physics = require("physics")

local Player = {tag="player", HP=5, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT =500};

function Player:new (o)    --constructor
  o = o or {};
  setmetatable(o, self);
  self.__index = self;
  return o;
end


function Player:spawn()
  self.shape = display.newCircle(self.xPos, self.yPos,15);
  self.shape.pp = self -- this is parent
  self.shape.tag = self.tag
  self.shape:setFillColor (1,0,0);
  physics.addBody(self.shape, "kinematic");
end

function Player:move(event)
  if event.phase == "began" then
    if(self.shape ~= nil and self ~= nil) then
      self.markX = self.shape.x
    end
  elseif event.phase == "moved" then
    if(self.shape ~= nil and self ~= nil) then
      if(self.markX == nil ) then
        print("markX was nil") 
        self.markX = self.shape.x
      end
      local x = (event.x - event.xStart) + self.markX
      if (x <= 20 + self.shape.width/2) then
        self.shape.x = 20+self.shape.width/2;
      elseif (x >= display.contentWidth-20-self.shape.width/2) then
        self.shape.x = display.contentWidth-20-self.shape.width/2;
      else
        self.shape.x = x;
      end
    end
  end
end

function Player:hit( )
  self.HP = self.HP - 1
  self.shape:setFillColor(0.3,0.4,0.5)
  if(self.HP > 0) then
    audio.play(soundTable["hitSound"])
  else
  	print("player hp < 0 . play explodeSound")
    audio.play(soundTable["explodeSound"])
    self.shape:removeSelf()
    self.shape = nil
    self = nil
  end
end

function Player:getHitPoint()
  return self.HP
end

function Player:fire(event)
  local p = display.newCircle (self.shape.x, self.shape.y-16, 5);
  p.anchorY = 1;
  p:setFillColor(0,1,0);
  physics.addBody (p, "dynamic", {radius=5} );
  p:applyForce(0, -0.4, p.x, p.y);

  audio.play( soundTable["shootSound"] );

  local function removeProjectile (event)
    if (event.phase=="began") then
      event.target:removeSelf();
      event.target=nil;

      if (event.other.tag == "enemy") then
        event.other.pp:hit();
        print("score val " .. scoreVal.text)
        scoreVal.text = scoreVal.text + 1
        print("score val " .. scoreVal.text)
      end
    end
  end

  p:addEventListener("collision", removeProjectile);
end
return Player