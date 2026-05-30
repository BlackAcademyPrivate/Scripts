local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Coordenada do baú (Baseada no seu scan anterior)
local TargetPosition = Vector3.new(-55.7, -358.7, 9494.8)

local function AutoWalk()
    -- Faz o personagem andar até a posição
    Humanoid:MoveTo(TargetPosition)
    
    -- Opcional: Remove a colisão apenas do seu personagem para ele atravessar paredes
    for _, part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Botão para ativar o Auto-Walk
local ScreenGui = Player.PlayerGui:FindFirstChild("FarmGui")
if ScreenGui then
    local btn = ScreenGui:FindFirstChild("CollectButton")
    if btn then
        btn.Text = "CAMINHANDO..."
        AutoWalk()
        
        -- Quando chegar perto, dispara o evento
        Humanoid.MoveToFinished:Connect(function()
            local Remote = game:GetService("Workspace"):FindFirstChild("ClaimRiverResultsGold")
            if Remote then
                Remote:FireServer()
                btn.Text = "COLETADO!"
            end
        end)
    end
end