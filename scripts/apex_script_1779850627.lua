local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local PlayerCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerHumanoid = PlayerCharacter:WaitForChild("Humanoid")

local function CreatePlayerESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local highlight = Instance.new("Highlight")
                highlight.Parent = character
                highlight.Adornee = character
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- Vermelho
                highlight.OutlineThickness = 2
                highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho
                highlight.FillTransparency = 0.9

                local connection
                connection = player.CharacterRemoving:Connect(function()
                    if highlight then
                        highlight:Destroy()
                    end
                    if connection then
                        connection:Disconnect()
                    end
                end)
            end
        end
    end
end

local function UpdateESP()
    local existingHighlights = {}
    for _, instance in ipairs(Workspace:GetDescendants()) do
        if instance:IsA("Highlight") then
            table.insert(existingHighlights, instance)
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            local highlightExists = false
            for _, highlight in ipairs(existingHighlights) do
                if highlight.Adornee == character then
                    highlightExists = true
                    break
                end
            end

            if humanoid and humanoid.Health > 0 and not highlightExists then
                local highlight = Instance.new("Highlight")
                highlight.Parent = character
                highlight.Adornee = character
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineThickness = 2
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.9
            end
        end
    end

    -- Limpa highlights de jogadores que já saíram ou morreram
    for _, highlight in ipairs(existingHighlights) do
        if not highlight.Adornee or not highlight.Adornee:FindFirstChildOfClass("Humanoid") or highlight.Adornee:FindFirstChildOfClass("Humanoid").Health <= 0 then
            highlight:Destroy()
        end
    end
end

-- Cria highlights iniciais
CreatePlayerESP()

-- Loop para atualizar o ESP
task.spawn(function()
    while true do
        UpdateESP()
        task.wait(0.2)
    end
end)

-- Lida com jogadores que entram no jogo após o script rodar
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            if humanoid.Health > 0 then
                local highlight = Instance.new("Highlight")
                highlight.Parent = character
                highlight.Adornee = character
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineThickness = 2
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.9

                local connection
                connection = player.CharacterRemoving:Connect(function()
                    if highlight then
                        highlight:Destroy()
                    end
                    if connection then
                        connection:Disconnect()
                    end
                end)
            end
        end)
    end
end)