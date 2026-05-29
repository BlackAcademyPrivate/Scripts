-- Código do Servidor (Server Script)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RequestHit = ReplicatedStorage.CombatSystem.Remotes.RequestHit

local MAX_REACH_DISTANCE = 15 -- Distância máxima permitida para um ataque corpo a corpo
local ATTACK_COOLDOWN = 0.2 -- Tempo mínimo entre ataques

local playerCooldowns = {}

RequestHit.OnServerEvent:Connect(function(player, targetCharacter)
    -- 1. Validação de Cooldown (Anti-Spam)
    local now = os.clock()
    local lastAttack = playerCooldowns[player] or 0
    if now - lastAttack < ATTACK_COOLDOWN then
        warn(player.Name .. " está atacando rápido demais (possível exploit).")
        return
    end
    playerCooldowns[player] = now

    -- 2. Validação de Existência do Alvo
    if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then
        return
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    -- 3. Validação de Distância (Anti-KillAura/Teleporte)
    local playerPos = character.HumanoidRootPart.Position
    local targetPos = targetCharacter.HumanoidRootPart.Position
    local distance = (playerPos - targetPos).Magnitude

    if distance > MAX_REACH_DISTANCE then
        warn(player.Name .. " tentou atacar fora do alcance permitido. Distância: " .. distance)
        return
    end

    -- Se passar em todas as validações, o dano é aplicado de forma segura
    local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        humanoid:TakeDamage(10) -- Dano calculado estritamente no servidor
    end
end)