
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local PlayerEspData = {}

-- Função para encontrar a parte principal do personagem
local function FindCharacterRootPart(character)
    for _, part in ipairs(character:GetChildren()) do
        -- Tenta encontrar partes que contenham "root" no nome (case-insensitive)
        if part:IsA("BasePart") and part.Name:lower():find("root") then
            return part
        end
    end
    return nil
end

-- Função para criar o contorno do ESP para um jogador
local function CreatePlayerEsp(player)
    -- Se o player já tem um ESP, não faz nada
    if PlayerEspData[player] then return end

    -- Verifica se o player não é o jogador local
    if player == LocalPlayer then return end

    -- Cria um Model para organizar os elementos do ESP do jogador
    local espModel = Instance.new("Model")
    espModel.Name = player.Name .. "_ESP"
    espModel.Parent = Workspace

    -- Cria a parte visual (a caixa)
    local espBox = Instance.new("Part")
    espBox.Name = "ESPBox"
    espBox.Size = Vector3.new(4, 6, 2) -- Tamanho base, pode precisar de ajuste no jogo
    espBox.Color = Color3.fromRGB(255, 0, 0) -- Cor vermelha por padrão
    espBox.Transparency = 0.7
    espBox.CanCollide = false
    espBox.Anchored = true
    espBox.CanQuery = false
    espBox.Parent = espModel

    -- Script que vai atualizar a posição da caixa
    local espTracker = Instance.new("Script")
    espTracker.Name = "ESPTracker"
    espTracker.Source = [[
        local player = ... -- Player passado como argumento
        local espModel = script.Parent
        local espBox = espModel:FindFirstChild("ESPBox")

        -- Tenta encontrar a parte principal do personagem (funciona mesmo se o nome variar)
        local FindCharacterRootPart = function(char)
            if not char or not char.Parent then return nil end
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name:lower():find("root") then
                    return part
                end
            end
            return nil
        end

        -- Garante que os objetos essenciais existem
        if not player or not espBox then
            espModel:Destroy()
            return
        end

        local character = player.Character
        if not character or not character.Parent then
            espModel:Destroy()
            return
        end

        local humanoidRootPart = FindCharacterRootPart(character)
        if not humanoidRootPart then
            espModel:Destroy()
            return
        end

        local function UpdateEsp()
            -- Verifica se tudo ainda existe antes de tentar atualizar a posição
            if not character or not character.Parent or not espBox or not espBox.Parent or not humanoidRootPart or not humanoidRootPart.Parent then
                espModel:Destroy()
                return
            end

            local hrpPosition = humanoidRootPart.Position
            -- Ajusta a posição da caixa no eixo Y para ficar no centro do jogador
            espBox.CFrame = CFrame.new(hrpPosition.X, hrpPosition.Y + 3, hrpPosition.Z)
        end

        -- Loop para manter o ESP atualizado
        while task.wait(0.1) do
            UpdateEsp()
        end
    ]]
    espTracker.Parent = espModel

    -- Armazena os dados do ESP para esse jogador
    PlayerEspData[player] = {
        Model = espModel,
        Box = espBox,
        Tracker = espTracker
    }
end

-- Função para remover o ESP de um jogador
local function RemovePlayerEsp(player)
    if PlayerEspData[player] then
        pcall(function()
            -- Destroi o Model do ESP com segurança
            PlayerEspData[player].Model:Destroy()
        end)
        PlayerEspData[player] = nil
    end
end

-- Configura o ESP para um jogador
local function SetupPlayer(player)
    -- Ignora o jogador local e jogadores que já tem ESP
    if player == LocalPlayer or PlayerEspData[player] then return end

    local characterAddedConnection

    -- Conecta o evento CharacterAdded para quando o personagem do jogador aparecer
    characterAddedConnection = player.CharacterAdded:Connect(function(character)
        -- Dá um pequeno tempo para o personagem carregar completamente
        task.wait(0.5)
        -- Cria o ESP se o jogador ainda existir e não tiver um ESP
        if player and player.Parent and not PlayerEspData[player] then
            CreatePlayerEsp(player)
        end
    end)

    -- Se o personagem do jogador já existir, cria o ESP logo de cara
    if player.Character then
        task.wait(0.5) -- Pequeno delay para garantir
        if player and player.Parent and not PlayerEspData[player] then
            CreatePlayerEsp(player)
        end
    end

    -- Guarda a conexão para poder desconectar depois
    if not PlayerEspData[player] then
        PlayerEspData[player] = {}
    end
    PlayerEspData[player].CharacterAddedConnection = characterAddedConnection
end

-- Limpa o ESP quando um jogador sai do jogo
local function CleanupPlayer(player)
    if PlayerEspData[player] then
        -- Desconecta o evento CharacterAdded para evitar erros
        if PlayerEspData[player].CharacterAddedConnection then
            PlayerEspData[player].CharacterAddedConnection:Disconnect()
        end
        RemovePlayerEsp(player)
    end
end

-- Conecta os eventos para jogadores que entram e saem
Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(CleanupPlayer)

-- Configura os ESPs para os jogadores que já estão no jogo quando o script é iniciado
for _, player in ipairs(Players:GetPlayers()) do
    SetupPlayer(player)
end

print("ESP Player Básico reconfigurado com foco no ambiente do jogo. Se ainda não funcionar, me diga!")
