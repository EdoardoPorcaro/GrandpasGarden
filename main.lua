----------------------------------------------
---------------- [ main.lua ] ----------------
----------------------------------------------

-- Sets the proper modules path
package.path = package.path .. ";src/?.lua;src/?/init.lua"

-- Import main modules
local load_game = require("LoadGame")
local update_game = require("UpdateGame")
local draw_game = require("DrawGame")
local keypressed_game = require("KeyPressedGame")

-- ISTRUCTIONS UPON GAME STARTUP
function love.load() load_game.load() end

-- dt = delta time (secondi trascorsi dall'ultimo frame)
function love.update(dt) update_game.update(dt) end

-- DRAW ON EACH FRAME
function love.draw() draw_game.draw() end

-- KEYBOARD EVENTS LISTENER
function love.keypressed(key) keypressed_game.keypressed(key) end

-- GAME WINDOW RESIZING
function love.resize(w, h)
    screenW, screenH = w, h
    -- Qui puoi ricalcolare layout UI, dead-zone camera, ecc.
end

-- 
function love.focus(focused)
    if not focused then
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