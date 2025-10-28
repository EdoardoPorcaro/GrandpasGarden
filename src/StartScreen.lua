-- StartScreen.lua
-- Start screen module for LÖVE (Love2D)
-- Features:
--  - background image (with simple parallax-like movement)
--  - music (streaming, with fade-in/out and mute toggle)
--  - custom font (with fallback)
--  - simple button UI (mouse + keyboard/controller navigation)
--  - responsive layout via "virtual resolution" scaling
--  - extensive comments explaining design choices

local StartScreen = {}

-- ========== CONFIGURATION ==========

-- Virtual resolution: design your UI for this size, then scale to actual screen
local VIRTUAL_WIDTH  = 1280
local VIRTUAL_HEIGHT = 720

-- Asset paths (replace with your actual files)
local ASSETS = {
    bg = "assets/images/menu_bg.png",           -- background image
    music = "assets/audio/menu_music.ogg",      -- background music (stream recommended)
    font = "assets/fonts/KiwiSoda.ttf",    -- custom font for title
    ui_font = "assets/fonts/KiwiSoda.ttf",    -- custom font for UI (optional)
    click = "assets/audio/click.wav",           -- small click sound for UI feedback
}

-- UI configuration
local TITLE_TEXT = "My Awesome Game" -- change to your title
local TITLE_SIZE  = 72
local UI_FONT_SIZE = 28
local BUTTON_SPACING = 20    -- space between buttons (virtual units)
local BUTTON_WIDTH = 420     -- virtual width of buttons
local BUTTON_HEIGHT = 60     -- virtual height of buttons

-- Music fade settings (seconds)
local MUSIC_FADE_IN  = 1.0
local MUSIC_FADE_OUT = 0.6

-- ========== INTERNAL STATE ==========

-- These will be populated in load()
local assets = {}
local fonts = {}
local music = nil
local clickSound = nil

-- Button structure sample:
-- { label = "Start", action = function() ... end, x, y, w, h, hovered = false }
local buttons = {}

-- Index of the button currently "focused" (for keyboard/controller)
local focusedIndex = 1

-- For transitions (fade alpha)
local alpha = 0         -- 0..1 (0: transparent, 1: fully visible)
local fadeState = nil   -- nil / "in" / "out"
local fadeDuration = 0
local fadeElapsed = 0

-- Virtual -> actual scaling and offset
local scaleX, scaleY, offsetX, offsetY

-- Simple parallax state for background movement
local bgOffsetX = 0

-- Save user preferences (audio mute/volume)
local prefs = {
    volume = 0.8,
    muted = false,
}
local PREFS_FILE = "menu_prefs.lua"

-- Whether this screen is currently "active" (entered)
local active = false

-- ========== UTILITIES ==========

-- Safe asset loader with fallback handlers
local function safeLoadImage(path)
    if love.filesystem.getInfo(path) then
        return love.graphics.newImage(path)
    else
        -- Return a simple 1x1 placeholder if not found
        local placeholder = love.image.newImageData(1,1)
        placeholder:mapPixel(function() return 0.2,0.2,0.2,1 end)
        return love.graphics.newImage(placeholder)
    end
end

local function safeLoadSource(path, mode)
    if love.filesystem.getInfo(path) then
        return love.audio.newSource(path, mode or "stream")
    else
        return nil
    end
end

local function safeLoadFont(path, size)
    if path and love.filesystem.getInfo(path) then
        return love.graphics.newFont(path, size)
    else
        return love.graphics.newFont(size) -- fallback default font
    end
end

-- Simple function to write preferences (keeps it tiny)
local function savePrefs()
    local contents = string.format("return { volume = %s, muted = %s }", tostring(prefs.volume), tostring(prefs.muted))
    love.filesystem.write(PREFS_FILE, contents)
end

local function loadPrefs()
    if love.filesystem.getInfo(PREFS_FILE) then
        local ok, tbl = pcall(love.filesystem.load, PREFS_FILE)
        if ok and type(tbl) == "function" then
            local data = tbl()
            if data and type(data) == "table" then
                if data.volume then prefs.volume = data.volume end
                if data.muted ~= nil then prefs.muted = data.muted end
            end
        end
    end
end

-- Rectangle hit test
local function pointInRect(px, py, x, y, w, h)
    return px >= x and px <= x + w and py >= y and py <= y + h
end

-- ========== LAYOUT & SCALING ==========

-- Compute transform values for scaling UI from virtual resolution to actual window
local function computeScale()
    local ww, hh = love.graphics.getWidth(), love.graphics.getHeight()
    scaleX = ww / VIRTUAL_WIDTH
    scaleY = hh / VIRTUAL_HEIGHT
    -- choose integer-preserving uniform scaling? here we preserve aspect ratio
    local scale = math.min(scaleX, scaleY)
    scaleX, scaleY = scale, scale
    offsetX = (ww - (VIRTUAL_WIDTH * scaleX)) / 2
    offsetY = (hh - (VIRTUAL_HEIGHT * scaleY)) / 2
end

-- Convert screen coords to virtual coords (inverse transform)
local function screenToVirtual(sx, sy)
    local vx = (sx - offsetX) / scaleX
    local vy = (sy - offsetY) / scaleY
    return vx, vy
end

-- ========== BUTTONS ==========

local function createButton(label, action)
    return {
        label = label,
        action = action,
        x = 0, y = 0, w = BUTTON_WIDTH, h = BUTTON_HEIGHT,
        hovered = false,
        pressed = false,
    }
end

local function layoutButtons()
    -- center buttons vertically below the title
    local totalH = #buttons * BUTTON_HEIGHT + (#buttons - 1) * BUTTON_SPACING
    local startY = (VIRTUAL_HEIGHT / 2) - (totalH / 2) + 120  -- shift a bit lower to make space for title
    local centerX = VIRTUAL_WIDTH / 2
    for i, b in ipairs(buttons) do
        b.w = BUTTON_WIDTH
        b.h = BUTTON_HEIGHT
        b.x = centerX - (b.w / 2)
        b.y = startY + (i - 1) * (b.h + BUTTON_SPACING)
    end
end

-- ========== TRANSITIONS ==========

local function startFadeIn(duration)
    fadeState = "in"
    fadeDuration = duration or 0.6
    fadeElapsed = 0
    alpha = 0
end

local function startFadeOut(duration, onComplete)
    fadeState = "out"
    fadeDuration = duration or 0.6
    fadeElapsed = 0
    alpha = 1
    StartScreen._onFadeOutComplete = onComplete -- store callback
end

-- ========== PUBLIC API (functions to integrate into your state machine) ==========

-- Load assets (call once at game start)
function StartScreen.load()
    -- compute initial scaling
    computeScale()

    -- load prefs
    loadPrefs()

    -- load images (safe fallback if missing)
    assets.bg = safeLoadImage(ASSETS.bg)

    -- load fonts
    fonts.title = safeLoadFont(ASSETS.font, TITLE_SIZE)
    fonts.ui = safeLoadFont(ASSETS.ui_font, UI_FONT_SIZE)

    -- load audio
    music = safeLoadSource(ASSETS.music, "stream") -- streaming recommended for long music
    if music then
        music:setLooping(true)
        music:setVolume(0) -- start muted; we'll fade-in
    end
    clickSound = safeLoadSource(ASSETS.click, "static")
    if clickSound then clickSound:setVolume(0.9) end

    -- initially empty buttons; add typical ones
    buttons = {
        createButton("Start", function()
            -- Example action: start game
            StartScreen.startGame()
        end),
        createButton("Options", function()
            -- Example: switch to options state (user to implement)
            if StartScreen.gotoOptions then StartScreen.gotoOptions() end
        end),
        createButton("Quit", function()
            love.event.quit()
        end),
    }
    layoutButtons()

    -- initialize other state
    focusedIndex = 1
    alpha = 0
    fadeState = nil
    bgOffsetX = 0

    -- mark module loaded
    StartScreen._loaded = true
end

-- Called when entering this screen (e.g. state change)
function StartScreen.enter()
    active = true
    -- start fade-in
    startFadeIn(MUSIC_FADE_IN)

    -- start music with fade-in if available and not muted
    if music then
        if not prefs.muted then
            music:play()
        end
        -- ensure volume set to 0 initially for fade-in
        music:setVolume(0)
    end
end

-- Called when leaving this screen (e.g. switching to game)
function StartScreen.exit()
    active = false
    -- stop music (we usually fade out before changing state)
    if music then
        music:stop()
    end
end

-- If user selects 'Start', external callback can be provided; default: startGame -> placeholder
function StartScreen.startGame()
    -- by default, fade out and then call a user-supplied callback 'onStart'
    startFadeOut(MUSIC_FADE_OUT, function()
        if StartScreen.onStart then
            StartScreen.onStart()
        else
            -- default behavior: just print (replace with real state change)
            print("Start requested - provide StartScreen.onStart callback to change state.")
        end
    end)
end

-- Optional hook to go to options (user may set StartScreen.gotoOptions)
-- Optional hook to be called when fade-out completes: StartScreen._onFadeOutComplete

-- ========== INPUT HANDLING ==========

-- Keyboard navigation and activate focused button
function StartScreen.keypressed(key, scancode, isrepeat)
    if not active then return end

    if key == "escape" then
        -- Example: quit from menu
        love.event.quit()
        return
    end

    if key == "up" or key == "w" then
        focusedIndex = math.max(1, focusedIndex - 1)
        if clickSound then clickSound:play() end
    elseif key == "down" or key == "s" then
        focusedIndex = math.min(#buttons, focusedIndex + 1)
        if clickSound then clickSound:play() end
    elseif key == "return" or key == "kpenter" or key == "space" then
        local b = buttons[focusedIndex]
        if b and b.action then
            if clickSound then clickSound:play() end
            b.action()
        end
    elseif key == "m" then
        -- quick mute toggle
        prefs.muted = not prefs.muted
        if prefs.muted then
            if music then music:setVolume(0) end
        else
            if music then music:setVolume(prefs.volume) end
        end
        savePrefs()
    end
end

-- Mouse movement: update hover state
function StartScreen.mousemoved(x, y, dx, dy)
    if not active then return end
    local vx, vy = screenToVirtual(x, y)
    for i, b in ipairs(buttons) do
        b.hovered = pointInRect(vx, vy, b.x, b.y, b.w, b.h)
        if b.hovered then
            focusedIndex = i
        end
    end
end

-- Mouse click: activate button under cursor
function StartScreen.mousepressed(x, y, button, istouch, presses)
    if not active then return end
    if button ~= 1 then return end -- left click only
    local vx, vy = screenToVirtual(x, y)
    for i, b in ipairs(buttons) do
        if pointInRect(vx, vy, b.x, b.y, b.w, b.h) then
            if clickSound then clickSound:play() end
            if b.action then b.action() end
            return
        end
    end
end

-- ========== UPDATE & DRAW ==========

function StartScreen.update(dt)
    if not StartScreen._loaded then return end

    -- update fade transitions
    if fadeState == "in" then
        fadeElapsed = fadeElapsed + dt
        alpha = math.min(1, fadeElapsed / fadeDuration)
        if alpha >= 1 then fadeState = nil end

        -- music fade-in
        if music and not prefs.muted then
            local vol = (fadeElapsed / fadeDuration) * prefs.volume
            music:setVolume(math.min(prefs.volume, vol))
            if not music:isPlaying() then music:play() end
        end
    elseif fadeState == "out" then
        fadeElapsed = fadeElapsed + dt
        alpha = math.max(0, 1 - (fadeElapsed / fadeDuration))
        -- music fade-out
        if music then
            local vol = (1 - (fadeElapsed / fadeDuration)) * prefs.volume
            music:setVolume(math.max(0, vol))
            if fadeElapsed >= fadeDuration then
                music:stop()
                fadeState = nil
                -- call on-complete if exists
                if StartScreen._onFadeOutComplete then
                    local cb = StartScreen._onFadeOutComplete
                    StartScreen._onFadeOutComplete = nil
                    cb()
                end
            end
        end
    end

    -- background parallax movement (very subtle)
    bgOffsetX = (bgOffsetX + dt * 10) % assets.bg:getWidth()

    -- (Optional) animate UI elements here (pulsing title, etc.)
    -- keep it light to avoid performance hits
end

function StartScreen.draw()
    if not StartScreen._loaded then return end

    -- apply virtual resolution scaling
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scaleX, scaleY)

    -- Draw background (we draw it large enough to cover)
    -- Basic parallax: shift background slightly over time, and tile if necessary
    local bg = assets.bg
    local bgW = bg:getWidth()
    local bgH = bg:getHeight()

    -- Scale background to fill virtual area while keeping aspect ratio
    local scaleBg = math.max(VIRTUAL_WIDTH / bgW, VIRTUAL_HEIGHT / bgH)
    local drawW = bgW * scaleBg
    local drawH = bgH * scaleBg

    -- center background and apply offset for parallax effect
    local bgX = -((bgOffsetX * 0.1) % (bgW)) * scaleBg
    local bgY = (VIRTUAL_HEIGHT - drawH) / 2

    -- We can draw background multiple times to cover edges (simple tiling)
    local repeatCount = 2
    for i = -1, repeatCount do
        love.graphics.draw(bg, bgX + i * drawW, bgY, 0, scaleBg, scaleBg)
    end

    -- overlay to darken background for contrast
    love.graphics.setColor(0,0,0,0.35)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1,1,1,1)

    -- Draw title
    love.graphics.setFont(fonts.title)
    local titleW = fonts.title:getWidth(TITLE_TEXT)
    local titleX = VIRTUAL_WIDTH / 2 - titleW / 2
    local titleY = VIRTUAL_HEIGHT * 0.2
    -- Optionally animate the title with a small pulsing alpha
    local pulse = 0.92 + 0.08 * math.sin(love.timer.getTime() * 2)
    love.graphics.setColor(1,1,1,pulse * alpha)
    love.graphics.printf(TITLE_TEXT, titleX, titleY, titleW, "left")
    love.graphics.setColor(1,1,1,1)

    -- Draw buttons
    love.graphics.setFont(fonts.ui)
    for i, b in ipairs(buttons) do
        -- button background
        local isFocused = (i == focusedIndex)
        local bgR, bgG, bgB = 0.12, 0.12, 0.12
        local borderCol = {0.8, 0.8, 0.8}
        if b.hovered or isFocused then
            -- hover color slightly brighter
            bgR, bgG, bgB = 0.22, 0.22, 0.22
            -- pulse border alpha
            local borderAlpha = 0.8 + 0.2 * math.sin(love.timer.getTime() * 6)
            borderCol = {1, 1, 1, borderAlpha}
        end

        love.graphics.setColor(bgR, bgG, bgB, alpha)
        love.graphics.rectangle("fill", b.x, b.y, b.w, b.h, 6, 6)

        -- border
        love.graphics.setColor(borderCol)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", b.x, b.y, b.w, b.h, 6, 6)

        -- label
        love.graphics.setColor(1,1,1,alpha)
        local labelW = fonts.ui:getWidth(b.label)
        local labelH = fonts.ui:getHeight()
        love.graphics.print(b.label, b.x + (b.w - labelW) / 2, b.y + (b.h - labelH) / 2)
    end

    -- small footer (mute state / hint)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.setColor(1,1,1,alpha * 0.8)
    local hint = "Press ←/→/Enter or Use Mouse • M to mute • ESC to quit"
    love.graphics.printf(hint, 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, "center")

    -- apply overall fade (when alpha < 1 we also draw a full-screen rectangle)
    if alpha < 1 then
        love.graphics.setColor(0,0,0,1 - alpha)
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(1,1,1,1)
    end

    love.graphics.pop()
end

-- Hook to call when window is resized (recompute scaling)
function StartScreen.resize(w, h)
    computeScale()
end

-- Hook that should be called by your main love callbacks:
-- love.load -> StartScreen.load()
-- love.resize -> StartScreen.resize(w,h)
-- when entering menu state -> StartScreen.enter()
-- in love.update(dt) -> StartScreen.update(dt)
-- in love.draw -> StartScreen.draw()
-- in love.keypressed -> StartScreen.keypressed(key,...)
-- in love.mousemoved -> StartScreen.mousemoved(...)
-- in love.mousepressed -> StartScreen.mousepressed(...)

-- ========== OPTIONAL: allow external control of music volume/preferences ==========

function StartScreen.setVolume(v)
    prefs.volume = math.max(0, math.min(1, v))
    if music and not prefs.muted then
        music:setVolume(prefs.volume)
    end
    savePrefs()
end

function StartScreen.setMuted(m)
    prefs.muted = not not m
    if music then
        music:setVolume(prefs.muted and 0 or prefs.volume)
        if prefs.muted then music:pause() else music:play() end
    end
    savePrefs()
end

-- ========== INTERNAL: handle fade-out complete callback ==========

-- This timer/handler is used to call the onStart callback after fade-out. It's already handled in update().

-- ========== EXAMPLE USAGE NOTES (to integrate in main.lua) ==========
--[[
-- In main.lua (example):

local StartScreen = require "StartScreen"

function love.load()
    StartScreen.load()
    StartScreen.onStart = function()
        -- change to your game state, e.g.
        Gamestate.switch(states.play)
    end
    StartScreen.gotoOptions = function()
        Gamestate.switch(states.options)
    end
    StartScreen.enter()
end

function love.update(dt)
    StartScreen.update(dt)
end

function love.draw()
    StartScreen.draw()
end

function love.keypressed(key, scancode, isrepeat)
    StartScreen.keypressed(key, scancode, isrepeat)
end

function love.mousemoved(x,y,dx,dy)
    StartScreen.mousemoved(x,y,dx,dy)
end

function love.mousepressed(x,y,button,istouch,presses)
    StartScreen.mousepressed(x,y,button,istouch,presses)
end

function love.resize(w,h)
    StartScreen.resize(w,h)
end
]]

-- ========== END MODULE ==========
return StartScreen