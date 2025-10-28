----------------------------------------------
-------------- [ LoadGame.lua ] --------------
----------------------------------------------

local load_game = {}

-- Import modules
local game_window = require("GameWindow")
local assets = require("Assets")

function load_game.load()
    -- Set the game window
    game_window.set()

    -- Load game sprites
    assets.loadSprites()
end

return load_game
