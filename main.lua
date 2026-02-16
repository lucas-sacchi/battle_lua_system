local createRoster = require("data.characters")
local BattleScene = require("ui.battle_scene")
local MenuScene = require("ui.menu_scene")

local scene
local currentState = "menu"

---------------------------------------------------
-- FADE VISUAL
---------------------------------------------------

local fadeAlpha = 1
local fadeSpeed = 1.5
local fadeState = "in"
local nextState = nil

---------------------------------------------------
-- MUSIC
---------------------------------------------------

local menuMusic
local battleMusic
local currentMusic
local musicVolume = 1
local maxVolume = 1

---------------------------------------------------
-- LOAD
---------------------------------------------------

function love.load()

    math.randomseed(os.time())
    math.random()

    love.window.setTitle("One Piece Battle System")
    love.window.setMode(900, 700)

    -- Inicia no menu
    scene = MenuScene:new()

    -- Carrega músicas
    menuMusic = love.audio.newSource("assets/audio/brook_song.mp3", "stream")
    battleMusic = love.audio.newSource("assets/audio/battle_song.mp3", "stream")

    menuMusic:setLooping(true)
    battleMusic:setLooping(true)

    currentMusic = menuMusic
    currentMusic:setVolume(0)
    currentMusic:play()
end

---------------------------------------------------
-- UPDATE
---------------------------------------------------

function love.update(dt)

    if scene and scene.update then
        scene:update(dt)
    end

    ---------------------------------------------------
    -- FADE VISUAL
    ---------------------------------------------------

    if fadeState == "in" then

        fadeAlpha = fadeAlpha - fadeSpeed * dt
        if fadeAlpha <= 0 then
            fadeAlpha = 0
            fadeState = nil
        end

    elseif fadeState == "out" then

        fadeAlpha = fadeAlpha + fadeSpeed * dt

        if fadeAlpha >= 1 then
            fadeAlpha = 1

            ---------------------------------------------------
            -- TROCA DE CENA
            ---------------------------------------------------

            if nextState == "battle" then

                -- troca música
                if currentMusic then currentMusic:stop() end
                currentMusic = battleMusic
                currentMusic:setVolume(0)
                currentMusic:play()

                -- sorteio aleatório
                local roster = createRoster()

                local playerIndex = math.random(1, #roster)

                local enemyIndex
                repeat
                    enemyIndex = math.random(1, #roster)
                until enemyIndex ~= playerIndex

                local player = roster[playerIndex]
                local enemy = roster[enemyIndex]

                scene = BattleScene:new(player, enemy)
                currentState = "battle"
            end

            fadeState = "in"
            nextState = nil
        end
    end

    ---------------------------------------------------
    -- FADE SONORO
    ---------------------------------------------------

    if currentMusic then
        musicVolume = maxVolume * (1 - fadeAlpha)
        currentMusic:setVolume(musicVolume)
    end
end

---------------------------------------------------
-- DRAW
---------------------------------------------------

function love.draw()

    if scene and scene.draw then
        scene:draw()
    end

    -- camada preta do fade
    if fadeAlpha > 0 then
        love.graphics.setColor(0,0,0,fadeAlpha)
        love.graphics.rectangle(
            "fill",
            0,
            0,
            love.graphics.getWidth(),
            love.graphics.getHeight()
        )
        love.graphics.setColor(1,1,1)
    end
end

---------------------------------------------------
-- INPUT
---------------------------------------------------

function love.keypressed(key)

    if fadeState then return end

    ---------------------------------------------------
    -- MENU
    ---------------------------------------------------

    if currentState == "menu" then

        local action = scene:keypressed(key)

        if action == "Start" then
            nextState = "battle"
            fadeState = "out"

        elseif action == "Exit" then
            love.event.quit()
        end

    ---------------------------------------------------
    -- BATALHA
    ---------------------------------------------------

    elseif currentState == "battle" then

        -- Se batalha terminou
        if scene.state == "finished" then

            if key == "return" then
                nextState = "battle"
                fadeState = "out"
            elseif key == "escape" then
                love.event.quit()
            end

        else
            scene:keypressed(key)
        end
    end
end

