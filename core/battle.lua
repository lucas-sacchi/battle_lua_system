local UI = require("ui.battle_ui")

local Battle = {}

local function waitForInput()
    print("\nPress Enter to continue...")
    io.read()
end

-- ======================
-- PLAYER TURN
-- ======================

local function playerTurn(player, enemy)

    -- Reset de bloqueio de turno
    player.skipTurn = false

    -- Status pode aplicar efeitos como Sleep ou Shock
    player:processStatus()

    UI.drawBattleScreen(player, enemy)

    -- Se estiver dormindo ou paralisado
    if player.skipTurn then
        print(player.name .. " couldn't act!")
        waitForInput()
        return
    end

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
        if selectedMove:didHit(player, enemy) then

            local damage, isCrit = selectedMove:calculateDamage(player, enemy)
            enemy:takeDamage(damage)

            print("\n" .. player.name .. " used " .. selectedMove.name .. "!")

            if isCrit then
                print("CRITICAL HIT!")
            end

            if damage > 0 then
                print("It dealt " .. damage .. " damage!")
            end

            selectedMove:applyEffect(player, enemy)

        else
            print("\nThe attack missed!")
        end
    else
        print("\nInvalid move.")
    end

    waitForInput()
end

-- ======================
-- ENEMY TURN
-- ======================

local function enemyTurn(enemy, player)

    -- Reset de bloqueio de turno
    enemy.skipTurn = false

    -- Processa status antes de agir
    enemy:processStatus()

    UI.drawBattleScreen(player, enemy)

    -- Se estiver dormindo ou paralisado
    if enemy.skipTurn then
        print(enemy.name .. " couldn't act!")
        waitForInput()
        return
    end

    local move = enemy.moves[math.random(1, #enemy.moves)]

    if move:didHit(enemy, player) then

        local damage, isCrit = move:calculateDamage(enemy, player)
        player:takeDamage(damage)

        print("\n" .. enemy.name .. " used " .. move.name .. "!")

        if isCrit then
            print("CRITICAL HIT!")
        end

        if damage > 0 then
            print("It dealt " .. damage .. " damage!")
        end

        move:applyEffect(enemy, player)

    else
        print("\n" .. enemy.name .. "'s attack missed!")
    end

    waitForInput()
end


-- ======================
-- BATTLE LOOP
-- ======================

function Battle.start(player, enemy)

    UI.drawBattleScreen(player, enemy)
    print("Battle Start!")
    waitForInput()

    while player:isAlive() and enemy:isAlive() do

        if player:getSpeed() >= enemy:getSpeed() then
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

        -- Atualiza duração no fim do round
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
