local draw_game = {}

local debug_menu = require("DebugMenu")

function draw_game.draw()
    -- Set demo background
    love.graphics.clear({ 0.12, 0.16, 0.22 })

    -- Draw debug menu
    -- This must remain the last item to be drawn each frame
    -- so to ensure it stays on top
    debug_menu.draw()
end

return draw_game