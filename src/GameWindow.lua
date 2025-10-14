----------------------------------------------
------------- [ GameWindow.lua ] -------------
----------------------------------------------

--- Set the characteristics of the game window
local game_window = {
    title = "Grandpa's Gaden",
    default_width = 1100,
    default_height = 600,
    flags = {
        minwidth = 400,
        minheight = 300,
        resizable = true,
        borderless = false,
        fullscreen = false,
        centered = true
    },
    fullscreen_toggle_key = 'f'
}

--- Apply the aforementioned characteristics of the game window
function game_window.set()
    love.window.setTitle(game_window.title)
    love.window.setMode(game_window.default_width, game_window.default_height, game_window.flags)
end

return game_window