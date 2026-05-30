local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "ESP_Folder"

local function createESP(player)
    local highlight = Instance.new("Highlight", espFolder)
    highlight.Name = player.Name
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    
    local function update()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            highlight.Adornee = player.Character
            highlight.Enabled = true
        else
            highlight.Adornee = nil
            highlight.Enabled = false
        end
    end
    
    RunService.RenderStepped:Connect(update)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)