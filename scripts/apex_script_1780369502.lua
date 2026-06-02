local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function createESP(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Filled = false

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Color = Color3.fromRGB(255, 255, 255)

    RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
            local rootPart = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local dist = (Camera.CFrame.Position - rootPart.Position).Magnitude
                local size = Vector2.new(1000 / pos.Z, 1200 / pos.Z)
                
                box.Size = size
                box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                box.Visible = true
                
                nameTag.Text = player.Name .. " [" .. math.floor(dist) .. "]"
                nameTag.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 20)
                nameTag.Visible = true
            else
                box.Visible = false
                nameTag.Visible = false
            end
        else
            box.Visible = false
            nameTag.Visible = false
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(createESP)