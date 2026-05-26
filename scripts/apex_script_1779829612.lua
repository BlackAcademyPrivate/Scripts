local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function autoJumpLoop()
    local currentCharacter
    local currentHumanoid

    -- Loop principal que fica ativo o tempo todo
    while true do
        -- Espera pelo personagem aparecer (ou reaparecer)
        repeat
            currentCharacter = player.Character
            task.wait(0.1)
        until currentCharacter and currentCharacter.Parent

        -- Espera pelo Humanoid dentro do personagem
        currentHumanoid = currentCharacter:WaitForChild("Humanoid", 5) -- Timeout de 5s caso algo dê errado
        if not currentHumanoid then
            task.wait(1) -- Se não achou o Humanoid, espera um pouco e tenta de novo
            continue
        end

        -- Enquanto o Humanoid for válido e o personagem estiver vivo, pula
        while currentHumanoid.Parent == currentCharacter and currentHumanoid.Health > 0 do
            currentHumanoid.Jump = true
            task.wait(0.15) -- Mantém o comando de pulo ativo por um tempo para garantir que registre
            currentHumanoid.Jump = false
            task.wait(0.35) -- Tempo de espera entre os pulos para dar ritmo (0.15 + 0.35 = 0.5s ciclo)
        end

        -- Se saiu do loop interno (personagem morreu, Humanoid sumiu), volta para o loop externo e espera um novo personagem
        task.wait(0.5) -- Pequeno delay antes de procurar um novo personagem
    end
end

-- Inicia o loop em uma task separada para não travar o jogo
task.spawn(autoJumpLoop)