----------------------------------------------
-------------- [ DebugMenu.lua ] -------------
----------------------------------------------

local debug_menu = {
    show = {
        value = true, -- true visible | false hidden
        toggle_key = 'd'},
    verbosity = {
        value = false, -- true verbose | false quiet [ti amo <3]
        toggle_key = 'v'},
    mode = {
        value = false, -- true show boundaries | false only menu
        toggle_key = 'm'},
    position = {
        value = true, -- true top | false center
        toggle_key = 'p',
        x = 10,
        y = 10,
        top = 10,
        center = 400},
    background = {
        value = true, -- true draw background | false no background
        toggle_key = 'b',
        color = {0,0,0,0.9}},
    restart = {toggle_key = 'r'},
    padding = 8,
    colors = {
        white = {1,1,1,1},
        grey = {0.5,0.5,0.5,1},
        green = {0,1,0,1},
        transparent = {0,0,0,0},
        red = {1,0,0,1},
        blue = {0,0,1,1}},
    active_upon_game_start = {
        show = nil,
        verbosity = nil,
        mode = nil,
        position = nil,
        background = nil}
}

-- Import modules
local game_window = require("GameWindow")
local player = require("Player")

-- To keep track of whether the debug menu was set to show up upon game startup
debug_menu.active_upon_game_start.show = debug_menu.show.value
debug_menu.active_upon_game_start.verbosity = debug_menu.verbosity.value
debug_menu.active_upon_game_start.mode = debug_menu.mode.value
debug_menu.active_upon_game_start.position = debug_menu.position.value
debug_menu.active_upon_game_start.background = debug_menu.background.value

-- The custom debug text table
local custom_debug_text = {
    -- Empty at the beginning
    -- debug_menu.addToCustomDebugText(variable, value) can add entries to this table from everywhere in the game
}

-- This function handles adding entries to the custom_debug_text table
function debug_menu.addToCustomDebugText(variable, value)
    table.insert(custom_debug_text, {variable = variable, value = value})
end

-- This function draws boundaries, diagonals, central lines and info for each sprite
function debug_menu.drawBoundaries(sprite)
    love.graphics.setColor(debug_menu.colors.red)
    --[[coordinates]] love.graphics.print(sprite.path.." "..sprite.sprite:getWidth().."x"..sprite.sprite:getHeight().." at "..sprite.position.x..","..sprite.position.y, sprite.position.x - sprite.sprite:getWidth()/2, sprite.position.y - sprite.sprite:getHeight()/2 - 15)
    --[[squared [] ]] love.graphics.rectangle("line", sprite.position.x - sprite.sprite:getWidth()/2, sprite.position.y - sprite.sprite:getHeight()/2, sprite.sprite:getWidth(), sprite.sprite:getHeight())
    --[[diagonal \ ]] love.graphics.line(sprite.position.x - sprite.sprite:getWidth()/2, sprite.position.y - sprite.sprite:getHeight()/2, sprite.position.x + sprite.sprite:getWidth()/2, sprite.position.y + sprite.sprite:getHeight()/2)
    --[[diagonal / ]] love.graphics.line(sprite.position.x - sprite.sprite:getWidth()/2, sprite.position.y + sprite.sprite:getHeight()/2, sprite.position.x + sprite.sprite:getWidth()/2, sprite.position.y - sprite.sprite:getHeight()/2)
    --[[central  | ]] love.graphics.line(sprite.position.x, sprite.position.y + sprite.sprite:getHeight()/2, sprite.position.x, sprite.position.y - sprite.sprite:getHeight()/2)
    --[[central  - ]] love.graphics.line(sprite.position.x + sprite.sprite:getWidth()/2, sprite.position.y, sprite.position.x - sprite.sprite:getWidth()/2, sprite.position.y)

    -- Restore default color so subsequent draws are not tinted
    love.graphics.setColor(1, 1, 1, 1)
end

-- Defines how to draw the actual debug menu when it's toggled
function debug_menu.draw()
    if debug_menu.show.value then
        local window_width, window_height = love.graphics.getDimensions()
        local fps = love.timer.getFPS()
        local font = love.graphics.getFont()

        -- Debug menu text and content
        local texts = {}

        -- [DEBUG]
        table.insert(texts, {text = "[DEBUG] ", color = debug_menu.colors.green})
        table.insert(texts, {text = "Status ", color = debug_menu.colors.white})
        table.insert(texts, {text = debug_menu.show.value and "visible" or "hidden", color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Menu ", color = debug_menu.colors.white})
        table.insert(texts, {text = debug_menu.verbosity.value and "verbose" or "quiet", color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Mode ", color = debug_menu.colors.white})
        table.insert(texts, {text = debug_menu.mode.value and "show boundaries" or "only menu", color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Position ", color = debug_menu.colors.white})
        table.insert(texts, {text = debug_menu.position.value and "top" or "center", color = debug_menu.colors.grey})
        if debug_menu.verbosity.value then
            table.insert(texts, {text = " nw corner ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(debug_menu.position.x)..","..tostring(debug_menu.position.y).."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " padding ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(debug_menu.padding).."]", color = debug_menu.colors.grey})
        end
        table.insert(texts, {text = " | Background ", color = debug_menu.colors.white})
        table.insert(texts, {text = debug_menu.background.value and "visible\n" or "hidden\n", color = debug_menu.colors.grey})
        if debug_menu.verbosity.value then
            table.insert(texts, {text = "[DEBUG] ", color = debug_menu.colors.transparent})
            table.insert(texts, {text = "Default: show ", color = debug_menu.colors.white})
            table.insert(texts, {text = debug_menu.active_upon_game_start.show and "[visible]" or "[hidden]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " verbosity ", color = debug_menu.colors.white})
            table.insert(texts, {text = debug_menu.active_upon_game_start.verbosity and "[verbose]" or "[quiet]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " mode ", color = debug_menu.colors.white})
            table.insert(texts, {text = debug_menu.active_upon_game_start.mode and "[show boundaries]" or "[only menu]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " position ", color = debug_menu.colors.white})
            table.insert(texts, {text = debug_menu.active_upon_game_start.position and "[top]" or "[center]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " background ", color = debug_menu.colors.white})
            table.insert(texts, {text = debug_menu.active_upon_game_start.background and "[visible]\n" or "[hidden]\n", color = debug_menu.colors.grey})
            table.insert(texts, {text = "[DEBUG] ", color = debug_menu.colors.transparent})
            table.insert(texts, {text = "Toggle key: show ", color = debug_menu.colors.white})
            table.insert(texts, {text = "[alt+"..(debug_menu.show.toggle_key):upper().."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " verbosity ", color = debug_menu.colors.white})
            table.insert(texts, {text = "[alt+"..(debug_menu.verbosity.toggle_key):upper().."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " mode ", color = debug_menu.colors.white})
            table.insert(texts, {text = "[alt+"..(debug_menu.mode.toggle_key):upper().."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " position ", color = debug_menu.colors.white})
            table.insert(texts, {text = "[alt+"..(debug_menu.position.toggle_key):upper().."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " background ", color = debug_menu.colors.white})
            table.insert(texts, {text = "[alt+"..(debug_menu.background.toggle_key):upper().."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " restart ", color = debug_menu.colors.white})
            table.insert(texts, {text = "[alt+"..(debug_menu.restart.toggle_key):upper().."]\n", color = debug_menu.colors.grey})
        end

        -- [WINDOW]
        table.insert(texts, {text = "[WINDOW] ", color = debug_menu.colors.green})
        table.insert(texts, {text = "Dimension ", color = debug_menu.colors.white})
        table.insert(texts, {text = tostring(window_width).."x"..tostring(window_height), color = debug_menu.colors.grey})
        if debug_menu.verbosity.value then
            table.insert(texts, {text = " default ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(game_window.default_width).."x"..tostring(game_window.default_height).."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " min ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(game_window.flags.minwidth).."x"..tostring(game_window.flags.minheight).."]", color = debug_menu.colors.grey})
        end
        table.insert(texts, {text = " | Framerate ", color = debug_menu.colors.white})
        table.insert(texts, {text = tostring(fps), color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Title ", color = debug_menu.colors.white})
        table.insert(texts, {text = game_window.title.."\n", color = debug_menu.colors.grey})
        if debug_menu.verbosity.value then
            table.insert(texts, {text = "[WINDOW] ", color = debug_menu.colors.transparent})
            table.insert(texts, {text = "Resizable ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(game_window.flags.resizable).."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " | Centered ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(game_window.flags.centered).."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " | Borderless ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(game_window.flags.borderless).."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " | Fullscreen ", color = debug_menu.colors.white})
            table.insert(texts, {text = tostring(love.window.getFullscreen()), color = debug_menu.colors.grey})
            table.insert(texts, {text = " default ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(game_window.flags.fullscreen).."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " toggle key ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..(game_window.fullscreen_toggle_key):upper().."]\n", color = debug_menu.colors.grey})
        end

        -- [PLAYER]
        table.insert(texts, {text = "[PLAYER] ", color = debug_menu.colors.green})
        table.insert(texts, {text = "Sprite ", color = debug_menu.colors.white})
        table.insert(texts, {text = player.sprite and "loaded" or "missing", color = debug_menu.colors.grey})
        table.insert(texts, {text = " anim ", color = debug_menu.colors.white})
        table.insert(texts, {text = "0", color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Position ", color = debug_menu.colors.white})
        table.insert(texts, {text = tostring(math.floor(player.position.x + 0.5))..","..tostring(math.floor(player.position.y + 0.5)), color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Status code ", color = debug_menu.colors.white})
        table.insert(texts, {text = player.status.."\n", color = debug_menu.colors.grey})

        -- [CLOSEST NPC]
        table.insert(texts, {text = "[CLOSEST NPC] ", color = debug_menu.colors.green})
        table.insert(texts, {text = "Closest | Distance", color = debug_menu.colors.white})
        table.insert(texts, {text = " 123/colliding", color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Activation range | In activation range", color = debug_menu.colors.white})

        -- [SOUND]
        if debug_menu.verbosity.value then
            table.insert(texts, {text = "\n", color = debug_menu.colors.transparent})
            table.insert(texts, {text = "[SOUND] ", color = debug_menu.colors.green})
            table.insert(texts, {text = "Music playing ", color = debug_menu.colors.white})
            table.insert(texts, {text = "true", color = debug_menu.colors.grey})
            table.insert(texts, {text = " track name ", color = debug_menu.colors.white})
            table.insert(texts, {text = "intro.wav", color = debug_menu.colors.grey})
            table.insert(texts, {text = " | sfx playing ", color = debug_menu.colors.white})
            table.insert(texts, {text = "no", color = debug_menu.colors.grey})
        end

        -- Show this line only if there is custom_debug_text to show
        if #custom_debug_text > 0 then
            table.insert(texts, {text = #custom_debug_text > 0 and "\n" or "", color = debug_menu.colors.transparent})
            table.insert(texts, {text = "[CUSTOM] ", color = debug_menu.colors.green})
            for i, entry in ipairs(custom_debug_text) do
                if i == 1 then
                    table.insert(texts, {text = entry.variable.." ", color = debug_menu.colors.white})
                else table.insert(texts, {text = " | "..entry.variable.." ", color = debug_menu.colors.white})
                end
                table.insert(texts, {text = entry.value, color = debug_menu.colors.grey})
            end
        end

        -- Set the width of the debug menu to be the window width minus twice the x position
        -- (to have some margin on both sides)
        local total_width = window_width - 2 * debug_menu.position.x
        
        -- Calculate the height of the background
        -- so as to be dynamic and chage according to the set verbosity and presence of custom debug text
        local total_height = 0
        for _, t in ipairs(texts) do
            total_height = total_height + font:getHeight() * select(2, t.text:gsub("\n",""))
        end
        total_height = total_height + font:getHeight() + 2 * debug_menu.padding

        -- Draw a debug_menu.background.color rectangle as a background for the debug menu
        -- (if debug_menu.background.value is true)
        love.graphics.setColor(debug_menu.background.value and debug_menu.background.color or debug_menu.colors.transparent)
        debug_menu.position.y = debug_menu.position.value and debug_menu.position.top or debug_menu.position.center
        love.graphics.rectangle("fill", debug_menu.position.x, debug_menu.position.y, total_width, total_height)

        -- Draw the debug menu text
        local offset_x, offset_y = 0, 0
        for _, t in ipairs(texts) do
            love.graphics.setColor(unpack(t.color))
            love.graphics.print(t.text, debug_menu.position.x + debug_menu.padding + offset_x, debug_menu.position.y + debug_menu.padding + offset_y)
            
            -- Calculate new lines only every time there is a "\n" in the text
            -- and reset the x offset to 0
            if t.text:find("\n") then
                offset_x = 0
                offset_y = offset_y + font:getHeight()
            else
                offset_x = offset_x + font:getWidth(t.text)
            end
        end
    end
end

-- This function handles keypresses that toggle the debug menu and its features
function debug_menu.keypressed(key)
    -- The key [Alt] + [D] toggles the debug menu
    if key == debug_menu.show.toggle_key then
        debug_menu.show.value = not debug_menu.show.value
    end

    -- The key [Alt] + [V] toggles the debug menu verbosity
    -- (only if the debug menu is shown)
    if key == debug_menu.verbosity.toggle_key and debug_menu.show.value then
        debug_menu.verbosity.value = not debug_menu.verbosity.value
    end

    -- The key [Alt] + [M] switches between debug modes
    -- (only if the debug menu is shown)
    if key == debug_menu.mode.toggle_key and debug_menu.show.value then
        debug_menu.mode.value = not debug_menu.mode.value
    end

    -- The key [Alt] + [P] switches the debug menu position between top and center of the screen
    -- (only if the debug menu is shown)
    if key == debug_menu.position.toggle_key and debug_menu.show.value then
        debug_menu.position.value = not debug_menu.position.value
    end

    -- The key [Alt] + [B] toggles the debug menu background
    -- (only if the debug menu is shown)
    if key == debug_menu.background.toggle_key and debug_menu.show.value then
        debug_menu.background.value = not debug_menu.background.value
    end

    -- The key [Alt] + [R] restarts the game
    -- (only if the debug menu is shown)
    if key == debug_menu.restart.toggle_key then
        love.event.quit("restart")
    end
end

return debug_menu