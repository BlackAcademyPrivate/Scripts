local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ESPEnabled = true

local function CreateESP()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PlayerESP"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = CoreGui

    local function CreatePlayerHighlight(player)
        if not player or not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
            return
        end

        local character = player.Character
        local highlight = Instance.new("Highlight")
        highlight.Name = player.Name .. "_Highlight"
        highlight.Parent = character
        highlight.Enabled = true
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho
        highlight.FillTransparency = 0.8
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Branco
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOn
        highlight.Adornee = character

        return highlight
    end

    local highlights = {}

    RunService.Heartbeat:Connect(function()
        if not ESPEnabled then
            for _, highlight in pairs(highlights) do
                if highlight and highlight.Parent then
                    highlight:Destroy()
                end
            end
            highlights = {}
            return
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if not highlights[player.Name] then
                    if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        highlights[player.Name] = CreatePlayerHighlight(player)
                    end
                else
                    local highlight = highlights[player.Name]
                    if not highlight or not highlight.Parent or not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
                        if highlight and highlight.Parent then
                            highlight:Destroy()
                        end
                        highlights[player.Name] = nil
                    end
                end
            end
        end

        -- Limpa highlights de jogadores que saíram ou estão mortos
        for name, highlight in pairs(highlights) do
            local playerFound = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Name == name then
                    playerFound = true
                    break
                end
            end
            if not playerFound or (Players:FindFirstChild(name) and Players:FindFirstChild(name).Character and Players:FindFirstChild(name).Character:FindFirstChild("Humanoid") and Players:FindFirstChild(name).Character.Humanoid.Health <= 0) then
                if highlight and highlight.Parent then
                    highlight:Destroy()
                end
                highlights[name] = nil
            end
        end
    end)
end

if ESPEnabled then
    CreateESP()
end