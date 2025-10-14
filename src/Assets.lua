----------------------------------------------
--------------- [ Assets.lua ] ---------------
----------------------------------------------

local assets = {
    -- path relative to the project root (where you run `love .`), not the src folder
    assets_folder_location = "assets/",
    player = {
        path = "player.png",
        sprite = nil
    }
}

local function locate_asset(filename)
    return assets.assets_folder_location .. filename
end

-- Load images and other assets. The user should place their images under ./assets/
function assets.load()
    -- player sprite (check exists first to avoid runtime error)
    local fullpath = locate_asset(assets.player.path)
    if love.filesystem.getInfo(fullpath) then
        assets.player.sprite = love.graphics.newImage(fullpath)
    else
        assets.player.sprite = nil
        print("[Assets] Warning: player sprite not found at " .. fullpath)
    end
end

return assets
