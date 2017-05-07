local piece = { };
function piece:new (type, x, y)    --constructor
  local o = {};
  setmetatable(o, self);
  self.__index = self;
  o.type = type;
  if (type == 0) then
  	o.shape = display.newCircle (x,y, 50);
  	o.shape:setFillColor (1,0,0);
  else
  	o.shape = display.newRect (x,y, 100, 100);
  	o.shape.rotation= 45;
  	o.shape:setFillColor (0,0,1);
  end
  return o;
end
return piece;
