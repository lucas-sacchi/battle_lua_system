local createRoster = require("data.characters")
local BattleScene = require("ui.battle_scene")

local scene

function love.load()

    math.randomseed(os.time())
    math.random()

    love.window.setTitle("One Piece Battle System")
    love.window.setMode(900, 700)

    local roster = createRoster()

    local player = roster[1]
    local enemy = roster[2]

    scene = BattleScene:new(player, enemy)
end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    scene:draw()
end

function love.keypressed(key)
    scene:keypressed(key)
end
