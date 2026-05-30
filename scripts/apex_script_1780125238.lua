local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function disableCharacterCollision(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = false
        end
    end
end

local toggle = true
local connection

connection = RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if hrp and humanoid and humanoid.Health > 0 then
        disableCharacterCollision(character)
        
        toggle = not toggle
        if toggle then
            hrp.AssemblyLinearVelocity = Vector3.new(18000, 18000, 18000)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 18000, 0)
        else
            hrp.AssemblyLinearVelocity = Vector3.new(-18000, -18000, -18000)
            hrp.AssemblyAngularVelocity = Vector3.new(0, -18000, 0)
        end
    end
end)