------------------------------------------------
--                  PLAYER
-- player object (cursor)
------------------------------------------------

-- imports
require('utils');
local Class = require('class');
local Vector2 = require('classes.math.vector2');
local Sprite = require('classes.graphics.sprite');

local Player = Class:derive("Player");

-- player constructor
function Player:new()
    self.position = Vector2(WIDTH/2, HEIGHT/2); -- center player at start of the room
    self.size = Vector2(16, 60);

    self.sprite_sheet = love.graphics.newImage("assets/graphics/sprite_sheets/player.png");
    self.sprite = Sprite(self.sprite_sheet, self.size.x, self.size.y, self.position.x, self.position.y, 1, 1, 0);
end

-- player update event
function Player:update(delta_time)
    -- check if on mobile or nahh
    if(OS ~= "Android" and OS ~= "iOS") then
        -- set player position to mouse position (additional calculations to make the mouse position relative to the screen size)
        self.position.x = (love.mouse.getX()* WIDTH) / love.graphics.getWidth();
        self.position.y = (love.mouse.getY() * HEIGHT) / love.graphics.getHeight();
    end
end

-- player draw event
function Player:draw()
    -- set sprite position to position of player
    self.sprite.position.x = self.position.x;
    self.sprite.position.y = self.position.y;
    
    -- draw sprite
    self.sprite:draw();
end

-- mouse pressed event
function Player:mousepressed(x, y, button, istouch, presses, level)
    --[[
        NOTE: i got an idea to use the 'presses' variable for maybe sum kinda special attack when screen is double clicked / tapped
    ]]--


    -- handle mouse press
    -- go through every entity in list of level and check if its fly 
    for i = 1, table.getn(level.entities), 1 do
        if level.entities[i]:get_type() == "Fly" then
            -- calculate position of fly and accomidate screen size
            x = level.entities[i].position.x * (love.graphics.getWidth() / WIDTH);
            y = level.entities[i].position.y * (love.graphics.getHeight() / HEIGHT);
            -- check if mouse if over fly when yes destroy fly and add score
            if get_distance(x, y, love.mouse.getX(), love.mouse.getY()) < 16 then
                CURRENT_SCORE = CURRENT_SCORE + 1; -- add 1 to current score
                -- deactivate fly
                level.entities[i]:deactivate(); -- deactivate entity
            end
        end
    end


    -- if touch move player to current press position
    if istouch then
        -- set player position to press position (additional calculations to make the mouse position relative to the screen size)
        self.position.x = (x * WIDTH) / love.graphics.getWidth();
        self.position.y = (y * HEIGHT) / love.graphics.getHeight();
    end
end

return Player;