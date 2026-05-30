local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Workspace = game:GetService("Workspace")

-- Função para tornar a água inofensiva
local function DisableWaterDamage()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Water" then
            obj.CanTouch = false -- Isso impede que o evento de morte dispare
            obj.CanCollide = true -- Permite que você ande sobre ela
        end
    end
end

-- Configuração da GUI (Persistente)
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = PlayerGui:FindFirstChild("FarmGui") or Instance.new("ScreenGui")
ScreenGui.Name = "FarmGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Button = ScreenGui:FindFirstChild("CollectButton") or Instance.new("TextButton")
Button.Name = "CollectButton"
Button.Size = UDim2.new(0, 150, 0, 60)
Button.Position = UDim2.new(0.8, 0, 0.5, 0)
Button.Text = "ATIVAR MODO FARM"
Button.Parent = ScreenGui

Button.MouseButton1Click:Connect(function()
    -- 1. Desativa o dano da água
    DisableWaterDamage()
    
    -- 2. Aumenta a velocidade
    Humanoid.WalkSpeed = 50
    
    -- 3. Caminha até o baú
    local TargetPosition = Vector3.new(-55.7, -358.7, 9494.8)
    Humanoid:MoveTo(TargetPosition)
    
    Button.Text = "CAMINHANDO..."
    
    -- 4. Coleta automática ao chegar
    Humanoid.MoveToFinished:Connect(function()
        local Remote = Workspace:FindFirstChild("ClaimRiverResultsGold")
        if Remote then
            Remote:FireServer()
            Button.Text = "COLETADO!"
            task.wait(2)
            Button.Text = "ATIVAR MODO FARM"
        end
    end)
end)