----------------------------------------------
-------------- [ DrawGame.lua ] --------------
----------------------------------------------

local draw_game = {}

-- Import modules
local debug_menu = require("DebugMenu")
local assets = require("Assets")
local player = require("Player")

function draw_game.draw()
    -- Set demo background
    love.graphics.clear({ 0.12, 0.16, 0.22 })
    love.graphics.setColor(1, 1, 1, 1) -- ensure default color for sprites

    assets.drawSprites()
    
    player.draw()

    -- Draw debug menu
    -- This must remain the last item to be drawn each frame
    -- so to ensure it stays on top
    debug_menu.draw()
end

return draw_game