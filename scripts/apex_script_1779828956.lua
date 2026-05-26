
-- Script ESP Player Básico
-- Feito para funcionar em executores como Delta, Synapse X, KRNL, Fluxus, etc.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Tabela para armazenar os elementos visuais de cada jogador
local PlayerEspData = {}

-- Função para criar o contorno de um jogador
local function CreatePlayerEsp(player)
    -- Verifica se o player já tem um ESP
    if PlayerEspData[player] then return end

    -- Cria um modelo para agrupar os elementos do ESP
    local espModel = Instance.new("Model")
    espModel.Name = player.Name .. "_ESP"
    espModel.Parent = Workspace

    -- Cria uma "Box" para o contorno
    local espBox = Instance.new("Part")
    espBox.Name = "ESPBox"
    espBox.Size = Vector3.new(4, 6, 2) -- Tamanho padrão, ajusta conforme necessário
    espBox.Color = Color3.fromRGB(255, 0, 0) -- Cor vermelha por padrão
    espBox.Transparency = 0.7 -- Um pouco transparente
    espBox.CanCollide = false
    espBox.Anchored = true
    espBox.CanQuery = false
    espBox.Parent = espModel

    -- Cria o componente de rastreamento (para seguir o jogador)
    local espTracker = Instance.new("Script")
    espTracker.Name = "ESPTracker"
    espTracker.Source = [[
        local player = game.Players:FindFirstChild(...) -- Recebe o player via arguments
        local espModel = script.Parent
        local espBox = espModel:FindFirstChild("ESPBox")

        if not player or not player.Character or not espBox then
            espModel:Destroy()
            return
        end

        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart then
            espModel:Destroy()
            return
        end

        local function UpdateEsp()
            pcall(function()
                if not character or not character.Parent or not espBox or not espBox.Parent then
                    espModel:Destroy()
                    return
                end
                local hrpPosition = humanoidRootPart.Position
                espBox.CFrame = CFrame.new(hrpPosition.X, hrpPosition.Y + 3, hrpPosition.Z) -- Ajusta a altura da caixa
            end)
        end

        -- Loop para atualizar a posição do ESP
        while task.wait(0.1) do
            UpdateEsp()
        end
    ]]
    espTracker.Parameters = {player} -- Passa o jogador como argumento para o script
    espTracker.Parent = espModel

    -- Salva os dados do ESP
    PlayerEspData[player] = {
        Model = espModel,
        Box = espBox,
        Tracker = espTracker
    }
end

-- Função para remover o ESP de um jogador
local function RemovePlayerEsp(player)
    if PlayerEspData[player] then
        PlayerEspData[player].Model:Destroy()
        PlayerEspData[player] = nil
    end
end

-- Conecta as funções para quando um jogador entra ou sai
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        -- Espera o personagem do jogador aparecer
        player.CharacterAdded:Connect(function(character)
            task.wait(0.1) -- Pequeno delay para garantir que tudo carregou
            CreatePlayerEsp(player)
        end)
        -- Se o personagem já existir quando o player for adicionado
        if player.Character then
            CreatePlayerEsp(player)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemovePlayerEsp(player)
end)

-- Cria ESPs para os jogadores que já estão no jogo
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        -- Espera o personagem do jogador aparecer
        player.CharacterAdded:Connect(function(character)
            task.wait(0.1)
            CreatePlayerEsp(player)
        end)
        -- Se o personagem já existir
        if player.Character then
            CreatePlayerEsp(player)
        end
    end
end

print("ESP Player Básico ativado!")
