local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function applyHighlight(player)
    local function onCharacterAdded(character)
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        applyHighlight(player)
    end
end

Players.PlayerAdded:Connect(applyHighlight)