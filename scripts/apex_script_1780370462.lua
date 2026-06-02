local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function createESP(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Thickness = 1
    box.Filled = false

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
            local rootPart = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                box.Size = Vector2.new(100, 150)
                box.Position = Vector2.new(pos.X - 50, pos.Y - 75)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
            if not player.Parent then
                box:Remove()
                connection:Disconnect()
            end
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(createESP)