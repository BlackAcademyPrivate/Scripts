local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function disableCollision(character)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function monitorPlayer(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        disableCollision(character)
        character.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end)
    end)
    if player.Character then
        disableCollision(player.Character)
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        monitorPlayer(player)
    end
end

Players.PlayerAdded:Connect(monitorPlayer)