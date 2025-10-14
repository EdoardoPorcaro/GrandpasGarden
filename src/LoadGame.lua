----------------------------------------------
-------------- [ LoadGame.lua ] --------------
----------------------------------------------

local load_game = {}

-- Import modules
local game_window = require("GameWindow")
local debug_menu = require("DebugMenu")
local assets = require("Assets")

-- expose assets table after load
load_game.assets = Assets

function load_game.load()
    -- Set the game window
    game_window.set()

    -- Load game assets
    assets.load()
end

return load_game
