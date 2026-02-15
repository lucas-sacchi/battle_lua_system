local Status = require("core.status")

local StatusEffects = {}

-- 🔥 Burn
StatusEffects.Burn = function()
    return Status:new("Burn", 3, function(target)
        local damage = math.floor(target.maxHP * 0.05)
        target:takeDamage(damage)
        print(target.name .. " is burned and took " .. damage .. " damage!")
    end)
end

-- 🩸 Bleeding
StatusEffects.Bleeding = function()
    return Status:new("Bleeding", 3, function(target)
        local damage = 8
        target:takeDamage(damage)
        print(target.name .. " is bleeding and took " .. damage .. " damage!")
    end)
end

-- ⚡ Shock
StatusEffects.Shock = function()
    return Status:new("Shock", 2, function(target)
        local damage = 5
        target:takeDamage(damage)
        print(target.name .. " is shocked and took " .. damage .. " damage!")
        
        -- 30% chance de ficar paralisado
        if math.random() < 0.3 then
            target.skipTurn = true
            print(target.name .. " is paralyzed and can't move!")
        end
    end)
end

-- 💤 Sleep
StatusEffects.Sleep = function()
    return Status:new("Sleep", 2, function(target)
        target.skipTurn = true
        print(target.name .. " is asleep!")
    end)
end

return StatusEffects
