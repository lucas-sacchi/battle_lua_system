local Move = {}
Move.__index = Move

function Move:new(name, power, accuracy, critChance, effectFunction)
    local self = setmetatable({}, Move)

    self.name = name
    self.power = power or 0
    self.accuracy = accuracy or 100
    self.critChance = critChance or 0.1
    self.effectFunction = effectFunction 

    return self
end

function Move:calculateDamage(attacker, defender)
    if self.power == 0 then
        return 0, false
    end

    local attack = attacker:getAttack()
    local defense = defender:getDefense()

    local baseDamage = ((attack / defense) * self.power)
    local variation = math.random(1, 5)
    local damage = baseDamage + variation

    local finalCritChance = self.critChance

    for _, buff in ipairs(attacker.buffs) do
        if buff.modifiers.critChanceBonus then
            finalCritChance = finalCritChance + buff.modifiers.critChanceBonus
        end
    end

    local isCrit = false
    if math.random() < finalCritChance then
        damage = damage * 1.5
        isCrit = true
    end

    return math.floor(damage), isCrit
end

function Move:didHit(attacker, defender)
    local finalAccuracy = self.accuracy

    -- buffs do atacante que aumentam accuracy
    for _, buff in ipairs(attacker.buffs) do
        if buff.modifiers.accuracyBonus then
            finalAccuracy = finalAccuracy + buff.modifiers.accuracyBonus
        end
        if buff.modifiers.accuracyPenalty then
            finalAccuracy = finalAccuracy + buff.modifiers.accuracyPenalty
        end
    end

    -- debuffs no defensor que reduzem evasão
    for _, buff in ipairs(defender.buffs) do
        if buff.modifiers.evasionPenalty then
            finalAccuracy = finalAccuracy + buff.modifiers.evasionPenalty
        end
    end

    return math.random(1, 100) <= finalAccuracy
end


function Move:applyEffect(attacker, defender)
    if self.effectFunction then
        self.effectFunction(attacker, defender)
    end
end

return Move
