local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local playerESPObjects = {}

local function updatePlayerESP(player)
    if player == LocalPlayer then return end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local head = character and character:FindFirstChild("Head")

    local espData = playerESPObjects[player]
    local highlight = espData and espData.highlight
    local nameLabel = espData and espData.nameLabel

    if character and humanoid and humanoid.Health > 0 and head then
        -- --- GERENCIAMENTO DO HIGHLIGHT ---
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Name = "APEX_PlayerHighlight_" .. player.Name
            highlight.Enabled = true
            if not espData then espData = {} end
            espData.highlight = highlight
        else
            highlight.Enabled = true
        end
        highlight.Adornee = character
        highlight.Parent = character

        -- --- GERENCIAMENTO DO NAMELABEL ---
        if not nameLabel then
            local newLabel = Instance.new("BillboardGui")
            newLabel.Size = UDim2.new(2, 0, 1, 0)
            newLabel.ExtentsOffset = Vector3.new(0, 2, 0)
            newLabel.AlwaysOnTop = true
            newLabel.ZIndex = 10
            newLabel.Name = "APEX_PlayerNameESP_" .. player.Name
            newLabel.Adornee = head
            newLabel.Parent = character

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextScaled = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.TextStrokeTransparency = 0
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.Text = player.Name
            textLabel.Parent = newLabel

            nameLabel = newLabel
            if not espData then espData = {} end
            espData.nameLabel = nameLabel
        else
            nameLabel.Adornee = head
            nameLabel.Parent = character
            nameLabel.Enabled = true
            nameLabel.TextLabel.Text = player.Name
        end
        
        playerESPObjects[player] = espData
    else
        if highlight then
            highlight.Enabled = false
        end
        if nameLabel then
            nameLabel.Enabled = false
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    local espData = playerESPObjects[player]
    if espData then
        if espData.highlight then
            espData.highlight:Destroy()
        end
        if espData.nameLabel then
            espData.nameLabel:Destroy()
        end
        playerESPObjects[player] = nil
    end
end)

task.spawn(function()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            pcall(updatePlayerESP, player)
        end
        task.wait(0.05) -- Tempo de espera reduzido para atualizações mais rápidas
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    pcall(updatePlayerESP, player)
end

Players.PlayerAdded:Connect(function(player)
    pcall(updatePlayerESP, player)
    player.CharacterAdded:Connect(function()
        pcall(updatePlayerESP, player)
    end)
end)