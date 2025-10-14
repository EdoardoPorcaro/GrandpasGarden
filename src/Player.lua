----------------------------------------------
--------------- [ Player.lua ] ---------------
----------------------------------------------

local player = {
    name = "Edoardo",
    position = {
        x = 100,
        y = 100
    },
    speed = {
        walking = 100,
        running = 200
    },
    status = "walking"  -- can be: idle, locked, walking, running, talking
}

local assets = require("Assets")

-- default render size (used by DrawGame)
player.size = 12

-- Move using a direction vector (dx, dy). dx/dy typically -1..1.
-- The function normalizes diagonal movement so speed is constant in all directions.
function player.move(dt, dx, dy, isRunning)
    if (dx == 0 or dx == nil) and (dy == 0 or dy == nil) then
        return
    end

    local speed = isRunning and player.speed.running or player.speed.walking

    -- Normalize diagonal movement
    local mag = math.sqrt((dx * dx) + (dy * dy))
    if mag > 0 then
        dx = dx / mag
        dy = dy / mag
    end

    player.position.x = player.position.x + dx * speed * dt
    player.position.y = player.position.y + dy * speed * dt
end

function player.update(dt)
    player.status = "idle"
    
    --[[local player_moving = {
        up = false,
        down = false,
        left = false,
        right = false
    }]] local dx, dy = 0, 0

    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        --player_moving.up = true
        dy = dy - 1
        player.status = "walking"
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        dy = dy + 1
        player.status = "walking"
    end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        dx = dx - 1
        player.status = "walking"
    end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        dx = dx + 1
        player.status = "walking"
    end

    --local isRunning = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        player.status = "running"
        isRunning = true
    end

    -- Call the vector-based move; it will normalize diagonal movement
    player.move(dt, dx, dy, isRunning)
end

function player.draw()
    -- Draw the player as a simple circle
    local img = assets.player.sprite
    if img then
        -- Draw sprite centered on player.position and scaled to player.size
        local iw, ih = img:getDimensions()
        -- target diameter = player.size * 2
        local target = player.size * 2
        local scale = target / math.max(iw, ih)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(img, player.position.x, player.position.y, 0, scale, scale, iw/2, ih/2)
    --[[else
        love.graphics.setColor(0.9, 0.7, 0.3)
        love.graphics.circle("fill", player.position.x, player.position.y, player.size)
        -- optional outline
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.circle("line", player.position.x, player.position.y, player.size)]]
    end
end

return player