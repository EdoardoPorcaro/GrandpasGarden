----------------------------------------------
-------------- [ debugMenu.lua] --------------
----------------------------------------------
--- Defines style and toggle function of   ---
--- the debug menu                         ---
----------------------------------------------

local debug_menu = {
    show = {
        value = true, -- true visible | false hidden
        toggle_key = 'd'},
    length = {
        value = true, -- true full menu | false collapsed menu [ti amo <3]
        toggle_key = 'l'},
    mode = {
        value = false, -- true show collisions | false only menu
        toggle_key = 'm'},
    x_pos = 10,
    y_pos = 10,
    padding = 8,
    colors = {
        white = {1,1,1,1},
        grey = {0.5,0.5,0.5,1},
        green = {0,1,0,1},
        transparent = {0,0,0,0},
        background_black = {0,0,0,0.75}
    },
    active_upon_game_start = {
        show = nil,
        length = nil,
        mode = nil
    }
}

-- Import modules
local game_window = require("GameWindow")

-- To keep track of whether the debug menu was set to show up upon game startup
debug_menu.active_upon_game_start.show = debug_menu.show.value
debug_menu.active_upon_game_start.length = debug_menu.length.value
debug_menu.active_upon_game_start.mode = debug_menu.mode.value

-- The custom debug text table
local custom_debug_text = {
    -- Empty at the beginning
    -- debug_menu.addToCustomDebugText(variable, value) can add entries to this table from everywhere in the game
}

function debug_menu.addToCustomDebugText(variable, value)
    table.insert(custom_debug_text, {variable = variable, value = value})
end

function debug_menu.toggleShow()
    debug_menu.show.value = not debug_menu.show.value
end

function debug_menu.toggleLength()
    debug_menu.length.value = not debug_menu.length.value
end

function debug_menu.toggleMode()
    debug_menu.mode.value = not debug_menu.mode.value
end

-- Defines how to draw the actual debug menu
-- when it's toggled
function debug_menu.draw()
    if debug_menu.show.value then
        local window_width, window_height = love.graphics.getDimensions()
        local fps = love.timer.getFPS()
        local font = love.graphics.getFont()

        -- Debug menu text and content
        local texts = {
            {text = "[DEBUG] ", color = debug_menu.colors.green},
            {text = "Status ", color = debug_menu.colors.white},
            {text = debug_menu.show.value and "visible" or "hidden", color = debug_menu.colors.grey},
            {text = " default ", color = debug_menu.colors.white},
            {text = debug_menu.active_upon_game_start.show and "[visible]" or "[hidden]", color = debug_menu.colors.grey},
            {text = " | Menu ", color = debug_menu.colors.white},
            {text = debug_menu.length.value and "full" or "collapsed", color = debug_menu.colors.grey},
            {text = " default ", color = debug_menu.colors.white},
            {text = debug_menu.active_upon_game_start.length and "[full]" or "[collapsed]", color = debug_menu.colors.grey},
            {text = " | Mode ", color = debug_menu.colors.white},
            {text = debug_menu.mode.value and "show collisions" or "only menu", color = debug_menu.colors.grey},
            {text = " default ", color = debug_menu.colors.white},
            {text = debug_menu.active_upon_game_start.mode and "[show collisions]\n" or "[only menu]\n", color = debug_menu.colors.grey},
            --{text = " | Active upon game startup ", color = debug_menu.colors.white},
            --{text = "["..tostring(debug_menu.active_upon_game_start.show).."]", color = debug_menu.colors.grey},
            --{text = (debug_menu.active_upon_game_start.show) and " menu " or "", color = debug_menu.colors.white},
            --{text = (debug_menu.active_upon_game_start.show) and (debug_menu.active_upon_game_start.length and "[full]" or "[collapsed]") or "", color = debug_menu.colors.grey},
            --{text = (debug_menu.active_upon_game_start.show) and " mode " or "", color = debug_menu.colors.white},
            --{text = (debug_menu.active_upon_game_start.show) and (debug_menu.active_upon_game_start.mode and "[show collisions]\n" or "[menu only]\n") or "\n", color = debug_menu.colors.grey},
        }

        -- Show this line only if the length is "full menu"
        if debug_menu.length.value then
            table.insert(texts, {text = "[DEBUG] ", color = debug_menu.colors.transparent})
            table.insert(texts, {text = "Toggle key: show ", color = debug_menu.colors.white})
            table.insert(texts, {text = "[alt+"..(debug_menu.show.toggle_key):upper().."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " length ", color = debug_menu.colors.white})
            table.insert(texts, {text = "[alt+"..(debug_menu.length.toggle_key):upper().."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " mode ", color = debug_menu.colors.white})
            table.insert(texts, {text = "[alt+"..(debug_menu.mode.toggle_key):upper().."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " | Position nw corner ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(debug_menu.x_pos)..","..tostring(debug_menu.y_pos).."]", color = debug_menu.colors.grey})
            table.insert(texts, {text = " padding ", color = debug_menu.colors.white})
            table.insert(texts, {text = "["..tostring(debug_menu.padding).."]\n", color = debug_menu.colors.grey})
        end

        table.insert(texts, {text = "[WINDOW] ", color = debug_menu.colors.green})
        table.insert(texts, {text = "Dimension ", color = debug_menu.colors.white})
        table.insert(texts, {text = tostring(window_width).."x"..tostring(window_height), color = debug_menu.colors.grey})
        table.insert(texts, {text = " default ", color = debug_menu.colors.white})
        table.insert(texts, {text = "["..tostring(game_window.default_width).."x"..tostring(game_window.default_height).."]", color = debug_menu.colors.grey})
        table.insert(texts, {text = " min ", color = debug_menu.colors.white})
        table.insert(texts, {text = "["..tostring(game_window.flags.minwidth).."x"..tostring(game_window.flags.minheight).."]", color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Framerate ", color = debug_menu.colors.white})
        table.insert(texts, {text = tostring(fps), color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Resizable ", color = debug_menu.colors.white})
        table.insert(texts, {text = "["..tostring(game_window.flags.resizable).."]\n", color = debug_menu.colors.grey})

        -- Show this line only if the length is "full menu"
        if debug_menu.length.value then
            table.insert(texts, {text = "[WINDOW] ", color = debug_menu.colors.transparent})
            table.insert(texts, {text = "Centered ", color = debug_menu.colors.white})
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

        table.insert(texts, {text = "[PLAYER] ", color = debug_menu.colors.green})
        table.insert(texts, {text = "Position", color = debug_menu.colors.white})
        --table.insert(texts, {text = "("..tostring(player.x)..","..tostring(player.y)..")", color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Status ", color = debug_menu.colors.white})
        table.insert(texts, {text = "idle/locked/walking/running/talking\n", color = debug_menu.colors.grey})
            -- idle: il giocatore lo lascia fermo
            -- locked: per via di eventi esterni (storia, cutscene) il giocatore non può muoversi da solo
            -- talking: per via di un'azione voluta dall'utente (es parlare) è impedito muoversi

        table.insert(texts, {text = "[CLOSEST NPC] ", color = debug_menu.colors.green})
        table.insert(texts, {text = "Closest | Distance", color = debug_menu.colors.white})
        table.insert(texts, {text = " 123/colliding", color = debug_menu.colors.grey})
        table.insert(texts, {text = " | Activation range | In activation range", color = debug_menu.colors.white})

        -- Show this line only if the length is not "full menu"
        if debug_menu.length.value then
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

        -- Calculate the height of the background
        local total_width = window_width - 2 * debug_menu.x_pos
        local total_height = 0
        for _, t in ipairs(texts) do
            --total_width = math.max(total_width, font:getWidth(t.text))
            total_height = total_height + font:getHeight() * select(2, t.text:gsub("\n",""))
        end
        -- total_width = total_width + 2 * debug_menu.padding
        total_height = total_height + font:getHeight() + 2 * debug_menu.padding

        -- Draw the background_black rectangle as a background for the debug menu
        love.graphics.setColor(0,0,0,0.7)
        love.graphics.rectangle("fill", debug_menu.x_pos, debug_menu.y_pos, total_width, total_height)

        -- Draw the debug menu text
        local offset_x, offset_y = 0, 0
        for _, t in ipairs(texts) do
            love.graphics.setColor(unpack(t.color))
            love.graphics.print(t.text, debug_menu.x_pos + debug_menu.padding + offset_x, debug_menu.y_pos + debug_menu.padding + offset_y)

            if t.text:find("\n") then
                offset_x = 0
                offset_y = offset_y + font:getHeight()
            else
                offset_x = offset_x + font:getWidth(t.text)
            end
        end
    end
end

return debug_menu