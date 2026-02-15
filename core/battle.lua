local UI = require("ui.battle_ui")

local Battle = {}

local function waitForInput()
    print("\nPress Enter to continue...")
    io.read()
end

local function playerTurn(player, enemy)
    UI.drawBattleScreen(player, enemy)

    print("Choose a move:\n")

    for i = 1, 4 do
        local move = player.moves[i]
        if move then
            io.write(string.format("%d - %-22s", i, move.name))
        else
            io.write(string.format("%d - %-22s", i, "----"))
        end

        if i % 2 == 0 then
            print()
        else
            io.write("   ")
        end
    end

    print()
    io.write("\n> ")
    local choice = tonumber(io.read())
    local selectedMove = player.moves[choice]

    if selectedMove then
        if selectedMove:didHit() then
            local damage, isCrit = selectedMove:calculateDamage(player, enemy)
            enemy:takeDamage(damage)

            print("\n" .. player.name .. " used " .. selectedMove.name .. "!")

            if isCrit then
                print("CRITICAL HIT!")
            end

            print("It dealt " .. damage .. " damage!")
        else
            print("\nThe attack missed!")
        end
    else
        print("\nInvalid move.")
    end

    -- Aplica status no fim do turno
    if player:isAlive() then
        player:processStatus()
    end

    waitForInput()
end

local function enemyTurn(enemy, player)

    local move = enemy.moves[math.random(1, #enemy.moves)]

    if move:didHit() then
        local damage, isCrit = move:calculateDamage(enemy, player)
        player:takeDamage(damage)

        print("\n" .. enemy.name .. " used " .. move.name .. "!")

        if isCrit then
            print("CRITICAL HIT!")
        end

        print("It dealt " .. damage .. " damage!")
    else
        print("\n" .. enemy.name .. "'s attack missed!")
    end

    -- Aplica status no fim do turno
    if enemy:isAlive() then
        enemy:processStatus()
    end

    waitForInput()
end

function Battle.start(player, enemy)

    -- Tela inicial antes de qualquer efeito
    UI.drawBattleScreen(player, enemy)
    print("Battle Start!")
    waitForInput()

    while player:isAlive() and enemy:isAlive() do

        if player.speed >= enemy.speed then
            playerTurn(player, enemy)
            if enemy:isAlive() then
                enemyTurn(enemy, player)
            end
        else
            enemyTurn(enemy, player)
            if player:isAlive() then
                playerTurn(player, enemy)
            end
        end

        player:updateStatusDuration()
        enemy:updateStatusDuration()

        player:updateBuffDuration()
        enemy:updateBuffDuration()
    end

    UI.drawBattleScreen(player, enemy)

    print("\n==============================")

    if player:isAlive() then
        print("   " .. player.name .. " WINS!")
    else
        print("   " .. enemy.name .. " WINS!")
    end

    print("==============================")

    waitForInput()
end

return Battle
