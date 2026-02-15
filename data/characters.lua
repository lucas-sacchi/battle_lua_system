local Character = require("core.character")
local Move = require("core.move")
local StatusEffects = require("core.status_effects")

local function createRoster()

    local roster = {}

    -- ======================
    -- LUFFY
    -- ======================

    local luffy = Character:new("Luffy", 120, 20, 15, 18)

    luffy:addMove(Move:new("Gomu Gomu no Pistol", 25, 90, 0.2))
    luffy:addMove(Move:new("Red Hawk", 30, 85, 0.25, function(attacker, defender)
        defender:addStatus(StatusEffects.Burn())
        print(defender.name .. " was burned!")
    end))

    luffy:addMove(Move:new("Gear Second", 0, 100, 0, function(attacker)
        local Buff = require("core.buff")
        local buff = Buff:new("Gear Second", 3, {
            attackMultiplier = 1.5,
            speedMultiplier = 1.2
        })
        attacker:addBuff(buff)
        print(attacker.name .. " boosted his power!")
    end))
    luffy:addMove(Move:new("King Kong Gun", 40, 75, 0.3))

    table.insert(roster, luffy)

    -- ======================
    -- ZORO
    -- ======================

    local zoro = Character:new("Zoro", 130, 22, 18, 15)

    zoro:addMove(Move:new("Onigiri", 30, 85, 0.15))
    zoro:addMove(Move:new("Sanzen Sekai", 35, 80, 0.2, function(attacker, defender)
        defender:addStatus(StatusEffects.Bleeding())
        print(defender.name .. " is bleeding!")
    end))
    zoro:addMove(Move:new("Tatsumaki", 28, 90, 0.1))
    zoro:addMove(Move:new("Ashura", 0, 100, 0, function(attacker)
        local Buff = require("core.buff")
        local buff = Buff:new("Ashura", 2, {
            critChanceBonus = 0.2
        })
        attacker:addBuff(buff)
        print(attacker.name .. " increased critical chance!")
    end))


    table.insert(roster, zoro)

    -- ======================
    -- NAMI
    -- ======================

    local nami = Character:new("Nami", 100, 16, 12, 20)

    nami:addMove(Move:new("Thunderbolt Tempo", 28, 85, 0.2, function(attacker, defender)
        defender:addStatus(StatusEffects.Shock())
        print(defender.name .. " was shocked!")
    end))

    nami:addMove(Move:new("Mirage Tempo", 0, 100, 0))
    nami:addMove(Move:new("Cloud Tempo", 22, 90, 0.1))
    nami:addMove(Move:new("Storm Gust", 30, 80, 0.15))

    table.insert(roster, nami)

    -- ======================
    -- USOPP
    -- ======================

    local usopp = Character:new("Usopp", 105, 18, 12, 17)

    usopp:addMove(Move:new("Firebird Star", 26, 85, 0.2))
    usopp:addMove(Move:new("Smoke Star", 0, 100, 0, function(attacker, defender)
        local Buff = require("core.buff")
        local debuff = Buff:new("Smoked", 2, {
            accuracyPenalty = -20
        })
        defender:addBuff(debuff)
        print(defender.name .. "'s accuracy was reduced!")
    end))
    usopp:addMove(Move:new("Explosive Shot", 30, 80, 0.2))
    usopp:addMove(Move:new("Snipe Shot", 35, 75, 0.25))

    table.insert(roster, usopp)

    -- ======================
    -- SANJI
    -- ======================

    local sanji = Character:new("Sanji", 115, 21, 14, 19)

    sanji:addMove(Move:new("Concasse", 28, 90, 0.15))
    sanji:addMove(Move:new("Diable Jambe", 32, 85, 0.2))
    sanji:addMove(Move:new("Flambage Shot", 25, 90, 0.15))
    sanji:addMove(Move:new("Hell Memories", 38, 75, 0.25))

    table.insert(roster, sanji)

    -- ======================
    -- CHOPPER
    -- ======================

    local chopper = Character:new("Chopper", 110, 17, 18, 14)

    chopper:addMove(Move:new("Heavy Point", 24, 90, 0.15))
    chopper:addMove(Move:new("Guard Point", 0, 100, 0, function(attacker)
        local Buff = require("core.buff")
        local buff = Buff:new("Guard Point", 2, {
            defenseMultiplier = 1.5
        })
        attacker:addBuff(buff)
        print(attacker.name .. " increased defense!")
    end))
    chopper:addMove(Move:new("Medical Treat", 0, 100, 0, function(attacker)
        local heal = 25
        attacker.currentHP = math.min(attacker.maxHP, attacker.currentHP + heal)
        print(attacker.name .. " healed " .. heal .. " HP!")
    end))
    chopper:addMove(Move:new("Rumble Ball", 0, 100, 0))

    table.insert(roster, chopper)

    -- ======================
    -- ROBIN
    -- ======================

    local robin = Character:new("Robin", 110, 19, 15, 16)

    robin:addMove(Move:new("Cien Fleur", 27, 90, 0.15))
    robin:addMove(Move:new("Clutch", 30, 85, 0.2))
    robin:addMove(Move:new("Gigantesco Mano", 35, 75, 0.25))
    robin:addMove(Move:new("Seis Fleur", 22, 95, 0.1))

    table.insert(roster, robin)

    -- ======================
    -- FRANKY
    -- ======================

    local franky = Character:new("Franky", 140, 24, 20, 10)

    franky:addMove(Move:new("Strong Right", 30, 85, 0.15))
    franky:addMove(Move:new("Coup de Vent", 28, 85, 0.15))
    franky:addMove(Move:new("Radical Beam", 40, 70, 0.3))
    franky:addMove(Move:new("Franky Fireball", 32, 80, 0.2))

    table.insert(roster, franky)

    -- ======================
    -- BROOK
    -- ======================

    local brook = Character:new("Brook", 100, 18, 13, 22)

    brook:addMove(Move:new("Soul Solid", 28, 85, 0.2))
    brook:addMove(Move:new("Music Note", 0, 100, 0, function(attacker, defender)
        defender:addStatus(StatusEffects.Sleep())
        print(defender.name .. " fell asleep!")
    end))
    brook:addMove(Move:new("Hip Shot", 25, 90, 0.15))
    brook:addMove(Move:new("Bink's Sake", 0, 100, 0))

    table.insert(roster, brook)

    -- ======================
    -- JINBE
    -- ======================

    local jinbe = Character:new("Jinbe", 150, 23, 22, 12)

    jinbe:addMove(Move:new("Fish-Man Karate", 30, 85, 0.2))
    jinbe:addMove(Move:new("Water Shield", 0, 100, 0))
    jinbe:addMove(Move:new("Whale Shark Wave", 35, 75, 0.25))
    jinbe:addMove(Move:new("Tidal Throw", 28, 85, 0.15))

    table.insert(roster, jinbe)

    return roster
end

return createRoster
