local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FarmGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Button = Instance.new("TextButton")
Button.Name = "CollectButton"
Button.Size = UDim2.new(0, 150, 0, 60)
Button.Position = UDim2.new(0.8, 0, 0.5, 0)
Button.Text = "TELEPORTAR & COLETAR"
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.TextColor3 = Color3.fromRGB(255, 215, 0)
Button.Parent = ScreenGui

Button.MouseButton1Click:Connect(function()
    local Chest = Workspace.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")
    local Remote = Workspace:FindFirstChild("ClaimRiverResultsGold")
    
    if Chest and Chest:FindFirstChild("Trigger") then
        local Character = Player.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            -- 1. Desativa colisões do personagem para não morrer ao chegar
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            -- 2. Teleporte para uma posição ligeiramente acima do gatilho
            Character.HumanoidRootPart.CFrame = Chest.Trigger.CFrame + Vector3.new(0, 5, 0)
            
            -- 3. Dispara o evento de recompensa
            if Remote then
                Remote:FireServer()
            end
            
            -- 4. Reativa colisões após 1 segundo
            task.wait(1)
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            Button.Text = "Sucesso!"
            task.wait(2)
            Button.Text = "TELEPORTAR & COLETAR"
        end
    else
        Button.Text = "Erro: Baú não encontrado"
    end
end)