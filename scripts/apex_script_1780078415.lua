local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerESP"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local espBoxes = {}
local espLabels = {}

local function createEspElements(targetPlayer)
    local espBox = Instance.new("Frame")
    espBox.BackgroundTransparency = 1
    espBox.BorderSizePixel = 2
    espBox.BorderColor3 = Color3.fromRGB(0, 255, 0)
    espBox.Visible = false
    espBox.Parent = screenGui

    local espLabel = Instance.new("TextLabel")
    espLabel.Size = UDim2.new(1, 0, 0, 20)
    espLabel.BackgroundTransparency = 1
    espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    espLabel.Font = Enum.Font.SourceSansBold
    espLabel.TextScaled = true
    espLabel.Parent = espBox

    return espBox, espLabel
end

local function updateEsp()
    local camera = workspace.CurrentCamera
    if not camera then return end

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") and targetPlayer.Character.Humanoid.Health > 0 then
            local character = targetPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                if not espBoxes[targetPlayer] then
                    local box, label = createEspElements(targetPlayer)
                    espBoxes[targetPlayer] = box
                    espLabels[targetPlayer] = label
                end

                local box = espBoxes[targetPlayer]
                local label = espLabels[targetPlayer]

                if box and label then
                    local torsoPosition, onScreen = camera:WorldToScreenPoint(humanoidRootPart.Position)

                    if onScreen then
                        box.Visible = true
                        local screenWidth = screenGui.AbsoluteSize.X
                        local screenHeight = screenGui.AbsoluteSize.Y

                        local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                        local scaleFactor = 100
                        local boxSizeX = math.max(10, scaleFactor / distance) * (screenWidth / 100)
                        local boxSizeY = math.max(10, scaleFactor / distance) * (screenHeight / 100)

                        box.Size = UDim2.new(0, boxSizeX, 0, boxSizeY)
                        box.Position = UDim2.new(0, torsoPosition.X - (boxSizeX / 2), 0, torsoPosition.Y - (boxSizeY * 1.2))

                        label.Text = targetPlayer.Name .. " | " .. math.floor(distance) .. "m"
                        label.Position = UDim2.new(0, 0, 1, 5)
                    else
                        box.Visible = false
                    end
                end
            end
        else
            if espBoxes[targetPlayer] then
                espBoxes[targetPlayer]:Destroy()
                espLabels[targetPlayer]:Destroy()
                espBoxes[targetPlayer] = nil
                espLabels[targetPlayer] = nil
            end
        end
    end
end

RunService.Heartbeat:Connect(updateEsp)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if espBoxes[leavingPlayer] then
        espBoxes[leavingPlayer]:Destroy()
        espLabels[leavingPlayer]:Destroy()
        espBoxes[leavingPlayer] = nil
        espLabels[leavingPlayer] = nil
    end
end)

print("ESP de Players carregado e ativo!")