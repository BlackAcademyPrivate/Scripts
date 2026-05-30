local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

local ScreenGui = PlayerGui:FindFirstChild("FarmGui") or Instance.new("ScreenGui")
ScreenGui.Name = "FarmGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Button = ScreenGui:FindFirstChild("CollectButton") or Instance.new("TextButton")
Button.Name = "CollectButton"
Button.Size = UDim2.new(0, 150, 0, 60)
Button.Position = UDim2.new(0.8, 0, 0.7, 0)
Button.Text = "ATIVAR MODO FARM"
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.TextColor3 = Color3.fromRGB(255, 215, 0)
Button.BorderSizePixel = 2
Button.Parent = ScreenGui

local function DisableWaterDamage()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Water" then
            obj.CanTouch = false
            obj.CanCollide = true
        end
    end
end

Button.MouseButton1Click:Connect(function()
    local Character = Player.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if Humanoid and RootPart then
        DisableWaterDamage()
        Humanoid.WalkSpeed = 50
        
        local TargetPosition = Vector3.new(-55.7, -358.7, 9494.8)
        Humanoid:MoveTo(TargetPosition)
        
        Button.Text = "CAMINHANDO..."
        
        local connection
        connection = Humanoid.MoveToFinished:Connect(function()
            local Remote = Workspace:FindFirstChild("ClaimRiverResultsGold")
            if Remote then
                Remote:FireServer()
                Button.Text = "COLETADO!"
                task.wait(2)
                Button.Text = "ATIVAR MODO FARM"
            end
            connection:Disconnect()
        end)
    end
end)