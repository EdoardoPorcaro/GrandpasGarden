----------------------------------------------
--------------- [ Sprites.lua ] --------------
----------------------------------------------

-- Declare assets table
local assets = {}

-- Declare assets folders (base first, then dependent folders)
assets.base_folder = "assets/"
assets.sprites_folder = assets.base_folder .. "sprites/"

-- Import modules
local debug_menu = require("DebugMenu")

-- Declare all the sprites of the game
    ---@type table<string, { path: string, sprite: love.Image|nil, position: { x: number, y: number } }>
assets.sprites = {
    tree = { path = "tree.png", sprite = nil, position = { x = 300, y = 200 }},
    bamboozle = { path = "tree.png", sprite = nil, position = { x = 500, y = 400 }},
}

-- Load every sprite
function assets.loadSprites()
    for _, entry in pairs(assets.sprites) do
        entry.sprite = love.graphics.newImage(assets.sprites_folder .. entry.path)
    end
end

-- Draw every sprite
function assets.drawSprites()
    for _, entry in pairs(assets.sprites) do
        love.graphics.draw(entry.sprite, entry.position.x, entry.position.y, 0, 1, 1, entry.sprite:getWidth()/2, entry.sprite:getHeight()/2)
        if debug_menu.mode.value then debug_menu.drawBoundaries(entry) end
    end
end

return assets
