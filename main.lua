math.randomseed(os.time())

local createRoster = require("data.characters")
local Battle = require("core.battle")

local roster = createRoster()

local function chooseCharacter(prompt)
    print(prompt)

    for i, character in ipairs(roster) do
        print(i .. " - " .. character.name)
    end

    io.write("\n> ")
    local choice = tonumber(io.read())

    if choice and roster[choice] then
        return roster[choice]
    else
        print("Invalid choice.\n")
        return chooseCharacter(prompt)
    end
end

local player = chooseCharacter("Choose your character:\n")
local enemy = chooseCharacter("Choose your opponent:\n")

Battle.start(player, enemy)
