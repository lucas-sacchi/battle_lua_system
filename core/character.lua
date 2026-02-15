local Character = {}
Character.__index = Character

function Character:new(name, hp, attack, defense, speed)
    local self = setmetatable({}, Character)

    self.name = name
    self.maxHP = hp
    self.currentHP = hp
    self.baseAttack = attack
    self.baseDefense = defense
    self.speed = speed

    self.moves = {}
    self.statusEffects = {}
    self.buffs = {}

    self.skipTurn = false

    return self
end

-- ======================
-- BASIC METHODS
-- ======================

function Character:addMove(move)
    table.insert(self.moves, move)
end

function Character:isAlive()
    return self.currentHP > 0
end

function Character:takeDamage(damage)
    self.currentHP = math.max(0, self.currentHP - damage)
end

-- ======================
-- STATUS SYSTEM
-- ======================

function Character:addStatus(status)
    table.insert(self.statusEffects, status)
end

function Character:processStatus()
    for _, status in ipairs(self.statusEffects) do
        status:apply(self)
    end
end

function Character:updateStatusDuration()
    for i = #self.statusEffects, 1, -1 do
        local status = self.statusEffects[i]

        status.duration = status.duration - 1

        if status.duration <= 0 then
            print(self.name .. " is no longer affected by " .. status.name)
            table.remove(self.statusEffects, i)
        end
    end
end

-- ======================
-- BUFF SYSTEM
-- ======================

function Character:addBuff(buff)
    table.insert(self.buffs, buff)
end

function Character:getAttack()
    local attack = self.baseAttack

    for _, buff in ipairs(self.buffs) do
        if buff.modifiers.attackMultiplier then
            attack = attack * buff.modifiers.attackMultiplier
        end
    end

    return attack
end

function Character:getDefense()
    local defense = self.baseDefense

    for _, buff in ipairs(self.buffs) do
        if buff.modifiers.defenseMultiplier then
            defense = defense * buff.modifiers.defenseMultiplier
        end
    end

    return defense
end

function Character:updateBuffDuration()
    for i = #self.buffs, 1, -1 do
        local buff = self.buffs[i]

        buff.duration = buff.duration - 1

        if buff.duration <= 0 then
            print(self.name .. "'s " .. buff.name .. " wore off!")
            table.remove(self.buffs, i)
        end
    end
end

function Character:getSpeed()
    local speed = self.speed

    for _, buff in ipairs(self.buffs) do
        if buff.modifiers.speedMultiplier then
            speed = speed * buff.modifiers.speedMultiplier
        end
    end

    return speed
end

return Character



