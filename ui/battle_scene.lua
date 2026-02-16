local BattleScene = {}
BattleScene.__index = BattleScene

function BattleScene:new(player, enemy)
    local self = setmetatable({}, BattleScene)

    self.player = player
    self.enemy = enemy

    self.background = love.graphics.newImage("assets/background.png")
    self.playerSprite = love.graphics.newImage("assets/luffy_back.png")
    self.enemySprite = love.graphics.newImage("assets/zoro_front.png")

    self.state = "player_turn"
    self.selectedMove = 1
    self.message = "Choose a move"

    return self
end

function BattleScene:update(dt)
end

---------------------------------------------------
-- INPUT
---------------------------------------------------

function BattleScene:keypressed(key)

    if key == "escape" then
        love.event.quit()
    end

    if self.state == "finished" then
        if key == "return" then
            love.event.quit()
        end
        return
    end

    if self.state == "player_turn" then

        if key == "right" then
            if self.selectedMove == 1 then self.selectedMove = 2
            elseif self.selectedMove == 3 then self.selectedMove = 4 end

        elseif key == "left" then
            if self.selectedMove == 2 then self.selectedMove = 1
            elseif self.selectedMove == 4 then self.selectedMove = 3 end

        elseif key == "down" then
            if self.selectedMove == 1 then self.selectedMove = 3
            elseif self.selectedMove == 2 then self.selectedMove = 4 end

        elseif key == "up" then
            if self.selectedMove == 3 then self.selectedMove = 1
            elseif self.selectedMove == 4 then self.selectedMove = 2 end

        elseif key == "return" then
            self:executePlayerMove()
        end

    elseif self.state == "waiting_enemy" then
        if key == "return" then
            self:executeEnemyMove()
        end

    elseif self.state == "waiting_player" then
        if key == "return" then
            self.state = "player_turn"
            self.message = "Choose a move"
        end
    end
end

---------------------------------------------------
-- PLAYER MOVE
---------------------------------------------------

function BattleScene:executePlayerMove()

    local move = self.player.moves[self.selectedMove]

    if move and move:didHit(self.player, self.enemy) then
        local damage, isCrit = move:calculateDamage(self.player, self.enemy)
        self.enemy:takeDamage(damage)

        self.message = self.player.name .. " used " .. move.name .. "!"

        if isCrit then
            self.message = self.message .. " CRITICAL HIT!"
        end
    else
        self.message = "The attack missed!"
    end

    if not self.enemy:isAlive() then
        self.state = "finished"
        self.message = self.player.name .. " wins! Press Enter to exit."
        return
    end

    self.state = "waiting_enemy"
end

---------------------------------------------------
-- ENEMY MOVE
---------------------------------------------------

function BattleScene:executeEnemyMove()

    local move = self.enemy.moves[math.random(1, #self.enemy.moves)]

    if move:didHit(self.enemy, self.player) then
        local damage, isCrit = move:calculateDamage(self.enemy, self.player)
        self.player:takeDamage(damage)

        self.message = self.enemy.name .. " used " .. move.name .. "!"

        if isCrit then
            self.message = self.message .. " CRITICAL HIT!"
        end
    else
        self.message = self.enemy.name .. "'s attack missed!"
    end

    if not self.player:isAlive() then
        self.state = "finished"
        self.message = self.enemy.name .. " wins! Press Enter to exit."
        return
    end

    self.state = "waiting_player"
end

---------------------------------------------------
-- TEXTO COM CONTORNO
---------------------------------------------------

function BattleScene:drawOutlinedText(text, x, y)

    love.graphics.setColor(0, 0, 0)

    for dx = -2, 2 do
        for dy = -2, 2 do
            if not (dx == 0 and dy == 0) then
                love.graphics.print(text, x + dx, y + dy)
            end
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(text, x, y)
end


---------------------------------------------------
-- DRAW
---------------------------------------------------

function BattleScene:draw()

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    ---------------------------------------------------
    -- BACKGROUND
    ---------------------------------------------------

    local bgW = self.background:getWidth()
    local bgH = self.background:getHeight()

    local scaleX = screenW / bgW
    local scaleY = screenH / bgH

    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.background, 0, 0, 0, scaleX, scaleY)

    love.graphics.setFont(love.graphics.newFont(18))

    ---------------------------------------------------
    -- ENEMY (ZORO)
    ---------------------------------------------------

    local enemyW = self.enemySprite:getWidth()
    local enemyH = self.enemySprite:getHeight()
    local enemyScale = (screenH * 0.30) / enemyH

    local enemyX = screenW * 0.63
    local enemyY = screenH * 0.29

    love.graphics.draw(
        self.enemySprite,
        enemyX,
        enemyY,
        0,
        enemyScale,
        enemyScale
    )

    -- HP acima do Zoro
    self:drawOutlinedText(self.enemy.name, enemyX + 40, enemyY - 60)
    self:drawHPBar(self.enemy, enemyX + 40, enemyY - 35)

    ---------------------------------------------------
    -- PLAYER (LUFFY)
    ---------------------------------------------------

    local playerW = self.playerSprite:getWidth()
    local playerH = self.playerSprite:getHeight()
    local playerScale = (screenH * 0.30) / playerH

    local playerX = screenW * 0.15
    local playerY = screenH * 0.55

    love.graphics.draw(
        self.playerSprite,
        playerX,
        playerY,
        0,
        playerScale,
        playerScale
    )

    -- HP acima do Luffy
    self:drawOutlinedText(self.player.name, playerX + 20, playerY - 50)
    self:drawHPBar(self.player, playerX + 20, playerY - 25)

    ---------------------------------------------------
    -- MENU
    ---------------------------------------------------

    local menuY = screenH - 200
    local menuHeight = 100

    love.graphics.setColor(0.05, 0.05, 0.05, 0.85)
    love.graphics.rectangle("fill", 0, menuY, screenW, menuHeight)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", 0, menuY, screenW, menuHeight)

    local startX = screenW * 0.12
    local startY = menuY + 25

    for i = 1, 4 do
        local move = self.player.moves[i]

        if move then
            local col = ((i - 1) % 2)
            local row = math.floor((i - 1) / 2)

            local x = startX + col * 350
            local y = startY + row * 35

            if i == self.selectedMove and self.state == "player_turn" then
                love.graphics.setColor(0.2, 0.3, 0.8)
                love.graphics.rectangle("fill", x - 15, y - 5, 320, 30, 6, 6)
                love.graphics.setColor(1,1,1)
            end

            love.graphics.print(move.name, x, y)
        end
    end

    ---------------------------------------------------
    -- MESSAGE BOX
    ---------------------------------------------------

    local msgY = screenH - 90
    local msgHeight = 70

    love.graphics.setColor(0.08, 0.08, 0.08, 0.95)
    love.graphics.rectangle("fill", 0, msgY, screenW, msgHeight)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", 0, msgY, screenW, msgHeight)

    love.graphics.printf(
        self.message,
        40,
        msgY + 20,
        screenW - 80
    )
end

---------------------------------------------------
-- HP BAR
---------------------------------------------------

function BattleScene:drawHPBar(character, x, y)

    local ratio = character.currentHP / character.maxHP
    local width = 220
    local height = 22

    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", x, y, width, height)

    if ratio > 0.5 then
        love.graphics.setColor(0, 0.8, 0)
    elseif ratio > 0.2 then
        love.graphics.setColor(0.9, 0.7, 0)
    else
        love.graphics.setColor(0.9, 0, 0)
    end

    love.graphics.rectangle("fill", x+2, y+2, (width-4) * ratio, height-4)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", x, y, width, height)

    love.graphics.printf(
        character.currentHP .. " / " .. character.maxHP,
        x,
        y + 2,
        width,
        "center"
    )
end

return BattleScene
