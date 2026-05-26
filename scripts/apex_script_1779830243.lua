local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Character = nil
local Hum = nil

local ESPEnabled = true

local playerChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
if playerChar and playerChar:FindFirstChildOfClass("Humanoid") then
    Character = playerChar
    Hum = Character:FindFirstChildOfClass("Humanoid")
end

Players.LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Hum = Character:FindFirstChildOfClass("Humanoid")
end)

local function CreateESP(targetCharacter)
    if not targetCharacter or not targetCharacter:FindFirstChildOfClass("Humanoid") or targetCharacter.Humanoid.Health <= 0 then
        return
    end

    local targetPlayer = Players:GetPlayerFromCharacter(targetCharacter)
    if not targetPlayer or targetPlayer == LocalPlayer then
        return
    end

    local existingHighlight = targetCharacter:FindFirstChild("Highlight_ESP")
    if existingHighlight then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Parent = targetCharacter
    highlight.Name = "Highlight_ESP"
    highlight.Adornee = targetCharacter:FindFirstChild("HumanoidRootPart") -- Geralmente o HumanoidRootPart é o melhor ponto para anexar o highlight
    highlight.Enabled = true
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho para criminosos ou jogadores inimigos
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Contorno branco
    highlight.OutlineTransparency = 0.3
    highlight.Thickness = 3

    -- Tentar determinar se é um criminoso ou um jogador normal (baseado no nome do modelo/spawn)
    if targetCharacter.Name:find("Criminal") or targetCharacter.Parent.Name == "Criminals Spawn" then -- Adapte isso se os nomes forem diferentes no jogo
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho para criminosos
    else
        highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Verde para jogadores normais
    end

    local function UpdateESP()
        if not targetCharacter or not targetCharacter:IsDescendantOf(game) or not highlight or not highlight.Parent then
            if highlight then
                highlight:Destroy()
            end
            return
        end

        local targetHum = targetCharacter:FindFirstChildOfClass("Humanoid")
        if not targetHum or targetHum.Health <= 0 then
            if highlight then
                highlight:Destroy()
            end
            return
        end

        -- Atualizar o Adornee caso o HumanoidRootPart mude
        if highlight.Adornee ~= targetCharacter:FindFirstChild("HumanoidRootPart") then
            highlight.Adornee = targetCharacter:FindFirstChild("HumanoidRootPart")
        end

        -- Lógica para diferenciar criminosos e jogadores (pode precisar de ajustes)
        if targetCharacter.Name:find("Criminal") or targetCharacter.Parent.Name == "Criminals Spawn" then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
        else
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
        end

        task.wait(0.2) -- Pequeno delay para não sobrecarregar
        UpdateESP() -- Chama a si mesmo recursivamente para manter o loop
    end

    task.spawn(UpdateESP) -- Inicia o loop de atualização
end

local function CheckForNewCharacters()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character ~= Character then
            CreateESP(player.Character)
        end
    end
end

CheckForNewCharacters() -- Cria ESP para jogadores já existentes

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if ESPEnabled then
            CreateESP(char)
        end
    end)
end)

-- Loop para verificar continuamente novos personagens
task.spawn(function()
    while ESPEnabled do
        CheckForNewCharacters()
        task.wait(1) -- Verifica a cada segundo
    end
end)

-- GUI para ligar/desligar o ESP (opcional, mas recomendado)
local function CreateGUISwitch()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ESP_GUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 50)
    frame.Position = UDim2.new(0.05, 0, 0.05, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = gui

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "ESP: ON"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.FontSize = Enum.FontSize.Size24
    toggleButton.Parent = frame

    local function UpdateButtonText()
        if ESPEnabled then
            toggleButton.Text = "ESP: ON"
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        else
            toggleButton.Text = "ESP: OFF"
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
        end
    end

    toggleButton.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        UpdateButtonText()
        if not ESPEnabled then
            -- Destroi todos os highlights existentes quando desliga
            for _, character in ipairs(game.Players:GetPlayers()) do
                if character.Character and character.Character:FindFirstChild("Highlight_ESP") then
                    character.Character.Highlight_ESP:Destroy()
                end
            end
        end
    end)

    UpdateButtonText()
    return gui
end

-- Garante que a GUI apareça corretamente
local function SetupGUI()
    if not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ESP_GUI") then
        local espGui = CreateGUISwitch()
        espGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
    end
end

SetupGUI()