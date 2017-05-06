local composer = require( "composer" )
local socket = require("socket")
local physics = require("physics");
local piece = require("piece")
local widget = require("widget")

physics.start();  
physics.setDrawMode ("normal");
physics.setGravity (0,0);

local zone = nil
local board = {{-1,-1,-1},{-1,-1,-1},{-1,-1,-1}};
local player = 0; -- swap between 0 and 1

local server = assert(socket.bind("*", 20140));
local client = nil;
local client_receive_timer = nil;

local function mark(x,y)
    if (board[x][y] ~= -1) then  -- space not empty!
        return false;
    end

  -- mark the game board (logical)
  board[x][y] = player; 
  --place the piece on the board (visual)
  local _x, _y = 
  zone:localToContent(75+150*(x-1) - 225, 75+150*(y-1) - 225);
  piece:new(player, _x, _y);    
  -- player = (player + 1) % 2;
  return true;
end

local function mark_for_client(p,x,y)
    if (board[x][y] ~= -1) then  -- space not empty!
        return false;
    end

  -- mark the game board (logical)
  board[x][y] = p; 
  --place the piece on the board (visual)
  local _x, _y = zone:localToContent(75+150*(x-1) - 225, 75+150*(y-1) - 225);
  piece:new(p, _x, _y);    
  -- player = (player + 1) % 2;
  return true;
end


local function check_win()
    --check columns
    local winner = nil;
    for i=1, 3 do
        if (board[i][1] == board[i][2] and 
            board[i][1] == board[i][3] and 
            board[i][1] ~= -1) then
            winner = board[i][1]   
        end
    end

   --check rows
   for i=1, 3 do
    if (board[1][i] == board[2][i] and 
        board[1][i] == board[3][i] and 
        board[1][i] ~= -1) then
        winner = board[1][i]
     end
   end

   --check diagonals
   if(board[1][1] == board[2][2] and board[1][1] == board[3][3] and board[1][1] ~= -1 and board[2][2] ~= -1 and board[3][3] ~= -1) then
        winner = board[1][1]
   end
   if(board[1][3] == board[2][2] and board[1][3] == board[3][1] and board[1][3] ~= -1 and board[2][2] ~= -1 and board[3][1] ~= -1) then
        winner = board[1][3]
   end
   print("winner is player ", winner)
   if(winner ~= nil) then
        Runtime:dispatchEvent({name="won_game", winner=winner})
    end
end

local function zone_handler(event)
   local x, y = event.target:contentToLocal(event.x, event.y);
   x = x + 225;  -- conversion
   y = y + 225;  -- conversion
   x = math.ceil( x/150 );
   y = math.ceil( y/150 );

   if (mark(x,y) == false) then   --bad move
    return;
   end
   -- zone:removeEventListener("tap", zone_handler);
   Runtime:dispatchEvent({name="moved", x=x, y=y, player=player})
   check_win()
end

local function sendMove(event)
  print("Server made my move at:", event.x, event.y);
  local sent, msg =   client:send(event.player .. "," .. event.x .. "," .. event.y .."\r\n");
  print("server sent the message to client")
end

Runtime:addEventListener("moved", sendMove);


local function startListening(event)
    if(event.phase == "began") then
        print("waiting for connection from client")
        event.target.alpha = 0
        client = server:accept(); -- accept: BLOCKING call.
        print("connection is done. now running receive timer")
        client:settimeout(0);
        timer.resume(client_receive_timer)
    end
end

local function if_won_game(event)
    -- local sent, msg =   client_socket:send(player .. "," .. 0 .. "," .. 0 .."\r\n");
    print("sent winning message from server")
    zone:removeEventListener("tap", zone_handler)
end

Runtime:addEventListener("won_game", if_won_game)
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local global_display_items = {}
 
 
 
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
        local background = display.newRect(0,0,display.contentWidth, display.contentHeight)
        background.anchorX = 0
        background.anchorY = 0
        background:setFillColor(0.5,0.5,0.9)
        sceneGroup:insert(background)
        global_display_items.background = background

        zone = display.newRect (display.contentCenterX, display.contentCenterY, 450,450);
        zone.strokeWidth = 2;
        zone:setFillColor(0,0.2,0);
        physics.addBody ( zone, "static");
        zone.isSensor = true;
        sceneGroup:insert(zone)
        global_display_items.zone = zone
        zone:addEventListener("tap", zone_handler)

        local ver = display.newRect (display.contentCenterX, display.contentCenterY, 150,450);
        ver:setFillColor(0,0,0,0);
        ver.strokeWidth = 2;
        sceneGroup:insert(ver)
        global_display_items.ver = ver

        local hor = display.newRect (display.contentCenterX, display.contentCenterY, 450,150);
        hor:setFillColor(0,0,1,0);
        hor.strokeWidth = 2;
        sceneGroup:insert(hor)
        global_display_items.hor = hor

        local listening = widget.newButton({
          left = 50,
          top = 10,
          id = "listenButton",
          onEvent = startListening,
          defaultFile = "listen.png",
          overFile = "listen.png"
        })
        listening.anchorX = 0
        listening.anchorY = 0
        listening:scale(2,2)
        sceneGroup:insert(listening)
        global_display_items.listening = listening

 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local function RCV(event)
            msg, err = client:receive('*l');
            if (not err) then            
                 print("message from client is ", msg)
                 local data = split(msg, ",")
                 local client_player = tonumber(data[1])
                 local client_x = tonumber(data[2])
                 local client_y = tonumber(data[3])
                 mark_for_client(client_player, client_x, client_y)           
            end

        end
        client_receive_timer = timer.performWithDelay(100, RCV, -1)
        timer.pause(client_receive_timer)

 
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