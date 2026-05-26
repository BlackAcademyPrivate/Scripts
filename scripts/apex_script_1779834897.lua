local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local DESIRED_WALKSPEED = 50 -- Você pode mudar este valor. O padrão do Roblox é 16.

local function applyWalkSpeed()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.WalkSpeed = DESIRED_WALKSPEED
    end
end

-- Este loop garante que sua velocidade se mantenha alta
-- mesmo se o jogo tentar resetar ela.
task.spawn(function()
    while task.wait(0.1) do
        if LocalPlayer and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = DESIRED_WALKSPEED
            end
        end
    end
end)

-- Conecta para aplicar a velocidade sempre que seu personagem for carregado (ex: ao spawnar)
LocalPlayer.CharacterAdded:Connect(applyWalkSpeed)

-- Aplica a velocidade imediatamente caso seu personagem já esteja carregado
applyWalkSpeed()