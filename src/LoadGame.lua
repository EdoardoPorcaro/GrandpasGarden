----------------------------------------------
--------------- [ loadGame.lua] --------------
----------------------------------------------
--- Defines everything that the game does  ---
--- upon startup                           ---
----------------------------------------------

local load_game = {}

-- Import modules
local game_window = require("GameWindow")
local debug_menu = require("DebugMenu")

function load_game.load()
    -- Set the game window
    game_window.set()
end

return load_game
