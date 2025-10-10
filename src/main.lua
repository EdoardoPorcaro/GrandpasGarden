local load_game = require("LoadGame")
-- local update_game = require("updateGame")
local draw_game = require("DrawGame")
local debug_menu= require("DebugMenu")

-- ISTRUCTIONS UPON GAME STARTUP
function love.load() load_game.load() end

-- dt = delta time (secondi trascorsi dall'ultimo frame)
function love.update(dt)
    -- Per un MVP monocolore non serve logica, ma qui aggiorneresti:
    -- animazioni, input continui, timers, fisica, ecc.
end

-- DRAW ON EACH FRAME
function love.draw() draw_game.draw() end

-- KEYBOARD EVENTS LISTENER
function love.keypressed(key)
    if key == "escape" then
        love.event.quit() -- Quit the game
    end

    -- Listen for keys that toggle the debug menu
    debug_menu.keypressed(key)

    -- Altri tasti utili in sviluppo:
    if key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
end

-- GAME WINDOW RESIZING
function love.resize(w, h)
    screenW, screenH = w, h
    -- Qui puoi ricalcolare layout UI, dead-zone camera, ecc.
end

-- Opzionale: pausa quando si perde il focus
function love.focus(f)
    if not f then
        -- la finestra ha perso il focus: potresti mettere game paused = true
        -- paused = true
    else
        -- riprendi
        -- paused = false
    end
end

-- Opzionale: pulizie prima di uscire
function love.quit()
    -- salva lo stato se necessario
    -- es: love.filesystem.write("save.dat", serializedState)
end