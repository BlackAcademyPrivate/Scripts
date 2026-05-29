local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local GUI_ENABLED = false
local WALK_SPEED_VALUE = 50 -- Velocidade padrão quando ativado. Pode ajustar!

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedGUI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 180, 0, 80)
toggleButton.Position = UDim2.new(0.5, -90, 0.5, -40)
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Text = "ATIVAR SPEED"
toggleButton.Parent = mainFrame

local function updateSpeed()
    if GUI_ENABLED then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = WALK_SPEED_VALUE
            end
        end
    else
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= 16 then -- Valor padrão do Roblox
                humanoid.WalkSpeed = 16
            end
        end
    end
end

toggleButton.MouseButton1Click:Connect(function()
    GUI_ENABLED = not GUI_ENABLED
    if GUI_ENABLED then
        toggleButton.Text = "DESATIVAR SPEED"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        updateSpeed()
    else
        toggleButton.Text = "ATIVAR SPEED"
        toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        updateSpeed() -- Reseta a velocidade para o padrão
    end
end)

RunService.Heartbeat:Connect(updateSpeed)

print("GUI de Speed carregada!")