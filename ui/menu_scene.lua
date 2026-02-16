local MenuScene = {}
MenuScene.__index = MenuScene

function MenuScene:new()
    local self = setmetatable({}, MenuScene)

    self.background = love.graphics.newImage("assets/menu_ingame.png")

    return self
end

---------------------------------------------------
-- UPDATE
---------------------------------------------------

function MenuScene:update(dt)
end

---------------------------------------------------
-- INPUT
---------------------------------------------------

function MenuScene:keypressed(key)

    if key == "return" then
        return "Start"
    end

    if key == "escape" then
        return "Exit"
    end

end

---------------------------------------------------
-- DRAW
---------------------------------------------------

function MenuScene:draw()

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    love.graphics.setColor(1,1,1)
    love.graphics.draw(
        self.background,
        0,
        0,
        0,
        screenW / self.background:getWidth(),
        screenH / self.background:getHeight()
    )

end

return MenuScene
