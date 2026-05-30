local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local meleeEvent = rs:FindFirstChild("meleeEvent")

-- Configuração
local ALCANCE = 15
local VELOCIDADE_ATAQUE = 0.5 -- Segundos entre ataques

task.spawn(function()
    while task.wait(VELOCIDADE_ATAQUE) do
        for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Team ~= player.Team then -- Só ataca inimigos
                local char = otherPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local dist = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= ALCANCE then
                        meleeEvent:FireServer(char)
                    end
                end
            end
        end
    end
end)