local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function createTracer(target)
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Thickness = 1
    line.Transparency = 1

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target ~= LocalPlayer then
            local rootPart = target.Character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(vector.X, vector.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
            if not target.Parent then
                line:Remove()
                connection:Disconnect()
            end
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createTracer(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createTracer(player)
end)