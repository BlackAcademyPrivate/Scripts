local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local jumpToggle = true

local function autoJump()
    while jumpToggle do
        if humanoid and humanoid.Health > 0 then
            humanoid.Jump = true
            task.wait(0.01) -- Um pequeno delay para garantir que o comando de pulo seja enviado
            humanoid.Jump = false
        end
        task.wait(0.01) -- Intervalo bem pequeno para pular o mais rápido possível
    end
end

-- Inicia a função em uma nova thread para não travar o jogo
local taskSpawnHandle = task.spawn(autoJump)

-- Garante que o pulo continue mesmo se o personagem morrer e renascer
local characterAddedConnection = player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    -- Se a função de pular estiver ativa, reinicia ela para o novo personagem
    if jumpToggle then
        if taskSpawnHandle then
            -- Se já tiver uma task rodando, pode ser que a anterior não tenha terminado completamente.
            -- Em alguns casos, reiniciar a conexão pode ser mais seguro se houver algum problema.
            -- No entanto, como estamos reiniciando a lógica aqui, só garantir que jumpToggle é true
            -- e chamar task.spawn novamente é o mais direto.
            -- Se houver algum bug de travamento, pode ser necessário ajustar o loop.
        end
        taskSpawnHandle = task.spawn(autoJump)
    end
end)

-- Limpeza quando o script é desativado ou o jogo fecha
script.Destroying:Connect(function()
    jumpToggle = false
    if characterAddedConnection then
        characterAddedConnection:Disconnect()
    end
    -- Não há uma forma direta de "matar" um task.spawn, mas setting jumpToggle = false
    -- dentro do loop garante que ele vai terminar.
end)