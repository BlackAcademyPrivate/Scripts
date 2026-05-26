
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local PlayerEspData = {}

local function CreatePlayerEsp(player)
    if PlayerEspData[player] then return end

    local espModel = Instance.new("Model")
    espModel.Name = player.Name .. "_ESP"
    espModel.Parent = Workspace

    local espBox = Instance.new("Part")
    espBox.Name = "ESPBox"
    espBox.Size = Vector3.new(4, 6, 2)
    espBox.Color = Color3.fromRGB(255, 0, 0)
    espBox.Transparency = 0.7
    espBox.CanCollide = false
    espBox.Anchored = true
    espBox.CanQuery = false
    espBox.Parent = espModel

    local espTracker = Instance.new("Script")
    espTracker.Name = "ESPTracker"
    espTracker.Source = [[
        local player = ... -- Player passado como argumento
        local espModel = script.Parent
        local espBox = espModel:FindFirstChild("ESPBox")

        if not player or not espBox then
            espModel:Destroy()
            return
        end

        local character = player.Character
        if not character or not character.Parent then
            espModel:Destroy()
            return
        end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            espModel:Destroy()
            return
        end

        local function UpdateEsp()
            -- Verifica se os objetos ainda existem antes de atualizar
            if not character or not character.Parent or not espBox or not espBox.Parent or not humanoidRootPart or not humanoidRootPart.Parent then
                espModel:Destroy()
                return
            end

            local hrpPosition = humanoidRootPart.Position
            espBox.CFrame = CFrame.new(hrpPosition.X, hrpPosition.Y + 3, hrpPosition.Z) -- Ajusta a altura da caixa
        end

        -- Loop para atualizar a posição do ESP
        while task.wait(0.1) do
            UpdateEsp()
        end
    ]]
    espTracker.Parent = espModel

    PlayerEspData[player] = {
        Model = espModel,
        Box = espBox,
        Tracker = espTracker
    }
end

local function RemovePlayerEsp(player)
    if PlayerEspData[player] then
        pcall(function()
            PlayerEspData[player].Model:Destroy()
        end)
        PlayerEspData[player] = nil
    end
end

local function SetupPlayer(player)
    if player ~= LocalPlayer then
        local characterAddedConnection
        characterAddedConnection = player.CharacterAdded:Connect(function(character)
            -- Espera um pouco mais para garantir que tudo carregou
            task.wait(0.5)
            if PlayerEspData[player] then -- Verifica se o ESP ainda não foi removido
                CreatePlayerEsp(player)
            end
        end)

        -- Se o personagem já existir, tenta criar o ESP
        if player.Character then
            task.wait(0.5) -- Dá um tempinho pra garantir
            CreatePlayerEsp(player)
        end

        -- Armazena a conexão para desconectar depois, se necessário
        if not PlayerEspData[player] then
            PlayerEspData[player] = {}
        end
        PlayerEspData[player].CharacterAddedConnection = characterAddedConnection
    end
end

local function CleanupPlayer(player)
    if PlayerEspData[player] then
        if PlayerEspData[player].CharacterAddedConnection then
            PlayerEspData[player].CharacterAddedConnection:Disconnect()
        end
        RemovePlayerEsp(player)
    end
end

Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(CleanupPlayer)

-- Configura os jogadores que já estão no jogo
for _, player in ipairs(Players:GetPlayers()) do
    SetupPlayer(player)
end

print("ESP Player Básico reconfigurado e pronto!")
