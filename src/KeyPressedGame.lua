----------------------------------------------
----------- [ KayPressedGame.lua ] -----------
----------------------------------------------

local keypressed_game = {}

-- Import modules
local debug_menu = require("DebugMenu")

function keypressed_game.keypressed(key)
    -- Separete key handling for the game and for the debug menu
    if love.keyboard.isDown("lalt", "ralt") then
        debug_menu.keypressed(key)
    else 
        if key == "escape" then
            love.event.quit() -- Quit the game
        end

        -- Altri tasti utili in sviluppo:
        if key == "f" then
            love.window.setFullscreen(not love.window.getFullscreen())
        end
    end
end

return keypressed_game