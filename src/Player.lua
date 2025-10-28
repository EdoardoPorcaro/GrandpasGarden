----------------------------------------------
--------------- [ Player.lua ] ---------------
----------------------------------------------

local player = {
    name = "Edoardo",
    position = { x = 100, y = 100 },
    speed = { walking = 100, running = 200 },
    status = 2, -- 0 locked | 1 talking | 2 idle | 3 walking | 4 running
    sprite = love.graphics.newImage("assets/sprites/player.png")
}

local controls = {
    up = { "w", "up" },
    down = { "s", "down" },
    left = { "a", "left" },
    right = { "d", "right" },
    run = { "lshift", "rshift" }
}

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
    local dx, dy = 0, 0

    -- If the player is allowed to move and no Alt key is being pressed,
    -- listen for which key is being pressed and then move the player accordingly
    if player.status > 1 and not love.keyboard.isDown("lalt", "ralt") then
        if love.keyboard.isDown({"w", "up"}) then
            dy = dy - 1
            player.status = love.keyboard.isDown(controls.run) and 4 or 3
        end
        if love.keyboard.isDown(controls.down) then
            dy = dy + 1
            player.status = love.keyboard.isDown(controls.run) and 4 or 3
        end
        if love.keyboard.isDown(controls.left) then
            dx = dx - 1
            player.status = love.keyboard.isDown(controls.run) and 4 or 3
        end
        if love.keyboard.isDown(controls.right) then
            dx = dx + 1
            player.status = love.keyboard.isDown(controls.run) and 4 or 3
        end

        -- Call the vector-based move; it will normalize diagonal movement
        player.move(dt, dx, dy, player.status == 4)

        -- (Re)Set player status to idle if no movement occurred
        player.status = (dx == 0 and dy == 0) and 2 or player.status
    end
end

function player.draw()
    love.graphics.draw(player.sprite, player.position.x, player.position.y, 0, 1, 1, player.sprite:getWidth()/2, player.sprite:getHeight()/2)
end

return player