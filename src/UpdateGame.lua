----------------------------------------------
------------- [ UpdateGame.lua ] -------------
----------------------------------------------

local update_game = {}

-- Import modules
local player = require("Player")

function update_game.update(dt)
    player.update(dt)
end

return update_game