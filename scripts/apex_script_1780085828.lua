-- Script no Servidor (ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminWeightEvent = ReplicatedStorage.Admin.AdminWeight

-- Lista de IDs de usuários autorizados (Administradores)
local ALLOWED_ADMINS = {
    [12345678] = true, -- Substituir pelo ID real do desenvolvedor
    [87654321] = true,
}

AdminWeightEvent.OnServerEvent:Connect(function(player, targetWeight)
    -- 1. Validação de Autenticidade (O jogador é realmente um administrador?)
    if not ALLOWED_ADMINS[player.UserId] then
        warn(player.Name .. " tentou executar um comando de admin sem permissão.")
        -- Opcional: Banir ou kickar o jogador por tentativa de exploit
        player:Kick("Acesso não autorizado a funções administrativas.")
        return
    end

    -- 2. Validação de Dados (O valor enviado é seguro/sanitizado?)
    if type(targetWeight) ~= "number" or targetWeight < 0 or targetWeight > 100000 then
        warn("Valor inválido enviado por " .. player.Name)
        return
    end

    -- 3. Execução segura após validação
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local weight = leaderstats:FindFirstChild("Weight")
        if weight then
            weight.Value = targetWeight
        end
    end
end)