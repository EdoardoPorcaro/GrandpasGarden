----------------------------------------------
----------- [ KeyPressedGame.lua ] -----------
----------------------------------------------

local keypressed_game = {}

-- Import modules
local debug_menu = require("DebugMenu")
local game_window = require("GameWindow")

function keypressed_game.keypressed(key)
    -- Separete key handling for the game and for the debug menu
    if love.keyboard.isDown("lalt", "ralt") then
        debug_menu.keypressed(key)
    else 
        game_window.keypressed(key)
    end
end

return keypressed_game