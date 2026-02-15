local UI = {}

local function getColorByHP(ratio)
    if ratio > 0.5 then
        return "\27[32m"
    elseif ratio > 0.2 then
        return "\27[33m"
    else
        return "\27[31m"
    end
end

function UI.drawHPBar(character)
    local barLength = 20
    local hpRatio = character.currentHP / character.maxHP
    local filled = math.floor(barLength * hpRatio)
    local empty = barLength - filled

    local color = getColorByHP(hpRatio)
    local reset = "\27[0m"

    local bar = string.rep("#", filled) .. string.rep("-", empty)

    print(character.name .. " HP: [" .. color .. bar .. reset .. "] " ..
          character.currentHP .. "/" .. character.maxHP)
end

function UI.drawBattleScreen(player, enemy)
    os.execute("cls")

    print("----------------------------------------")
    UI.drawHPBar(enemy)
    print("----------------------------------------")
    UI.drawHPBar(player)
    print("----------------------------------------\n")
end

return UI
