local Move = {}
Move.__index = Move

function Move:new(name, power, accuracy, critChance)
    local self = setmetatable({}, Move)
    self.name = name
    self.power = power
    self.accuracy = accuracy
    self.critChance = critChance or 0.1
    return self
end

function Move:calculateDamage(attacker, defender)
    local attack = attacker:getAttack()
    local defense = defender:getDefense()

    local baseDamage = ((attack / defense) * self.power)
    local variation = math.random(1, 5)
    local damage = baseDamage + variation

    local isCrit = false
    if math.random() < self.critChance then
        damage = damage * 1.5
        isCrit = true
    end

    return math.floor(damage), isCrit
end

function Move:didHit()
    return math.random(1, 100) <= self.accuracy
end

return Move
