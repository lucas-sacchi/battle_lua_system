local Character = require("core.character")
local Move = require("core.move")
local Status = require("core.status")
local Buff = require("core.buff")

local function createCharacters()

    local luffy = Character:new("Luffy", 120, 20, 15, 18)
    local zoro = Character:new("Zoro", 130, 22, 18, 15)

    -- Moves
    luffy:addMove(Move:new("Gomu Gomu no Pistol", 25, 90, 0.2))
    luffy:addMove(Move:new("Gear Second", 35, 80, 0.15))

    zoro:addMove(Move:new("Onigiri", 30, 85, 0.15))
    zoro:addMove(Move:new("Sanzen Sekai", 40, 70, 0.2))

    -- Example Status: Burn
    local burn = Status:new("Burn", 3, function(target)
        local burnDamage = math.floor(target.maxHP * 0.05)
        target:takeDamage(burnDamage)
        print(target.name .. " is burned and took " .. burnDamage .. " damage!")
    end)

    -- Example Buff: Gear Second
    local gearBuff = Buff:new("Gear Second", 3, 1.5)

    -- Apply example effects for testing
    luffy:addBuff(gearBuff)
    zoro:addStatus(burn)

    return luffy, zoro
end

return createCharacters
