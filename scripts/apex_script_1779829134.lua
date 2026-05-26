
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Tabela para armazenar os dados do ESP de cada jogador
local PlayerEspData = {}

-- Função para encontrar a parte principal (HumanoidRootPart) de um personagem
local function FindCharacterRootPart(character)
    if not character or not character.Parent then return nil end
    -- Procura por partes que contenham "root" no nome (case-insensitive)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name:lower():find("root") then
            return part
        end
    end
    return nil
end

-- Função para verificar se um Model no Workspace é um personagem de jogador
local function IsPlayerCharacterModel(model)
    -- 1. Não pode ser um Model que a gente já criou para o ESP
    if model.Name:find("_ESP") then return false end
    -- 2. Verifica se o Model tem um Humanoid dentro (sinal de que é um personagem)
    if model:FindFirstChildOfClass("Humanoid") then return true end
    -- 3. Tenta achar o HumanoidRootPart, caso o Humanoid esteja em outro lugar do personagem
    local rootPart = FindCharacterRootPart(model)
    if rootPart and rootPart.Parent == model then return true end

    return false
end

-- Função para criar o elemento visual do ESP para um jogador
local function CreatePlayerEsp(player)
    -- Se o jogador já tem um ESP, sai fora
    if PlayerEspData[player] then return end
    -- Não cria ESP pro jogador local
    if player == LocalPlayer then return end

    -- Cria um Model para organizar os elementos do ESP desse jogador
    local espModel = Instance.new("Model")
    espModel.Name = player.Name .. "_ESP"
    espModel.Parent = Workspace

    -- Cria a parte visual (a caixa de contorno)
    local espBox = Instance.new("Part")
    espBox.Name = "ESPBox"
    espBox.Size = Vector3.new(4, 6, 2) -- Ajuste esse tamanho se necessário no jogo
    espBox.Color = Color3.fromRGB(255, 0, 0) -- Cor vermelha padrão
    espBox.Transparency = 0.7
    espBox.CanCollide = false
    espBox.Anchored = true
    espBox.CanQuery = false
    espBox.Parent = espModel

    -- Script que atualiza a posição da caixa para seguir o jogador
    local espTracker = Instance.new("Script")
    espTracker.Name = "ESPTracker"
    espTracker.Source = [[
        local player = ... -- Player passado como argumento para o script
        local espModel = script.Parent
        local espBox = espModel:FindFirstChild("ESPBox")

        -- Função interna para achar a raiz do personagem
        local function FindCharacterRootPart(character)
            if not character or not character.Parent then return nil end
            for _, part in ipairs(character:GetChildren()) do
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

        -- Função para atualizar a posição do ESP
        local function UpdateEsp()
            -- Verifica se todos os componentes ainda existem antes de atualizar
            if not character or not character.Parent or not espBox or not espBox.Parent or not humanoidRootPart or not humanoidRootPart.Parent then
                espModel:Destroy()
                return
            end

            local hrpPosition = humanoidRootPart.Position
            -- Ajusta a posição da caixa no eixo Y para que fique no centro do jogador
            espBox.CFrame = CFrame.new(hrpPosition.X, hrpPosition.Y + 3, hrpPosition.Z)
        end

        -- Loop para manter o ESP atualizado
        while task.wait(0.1) do
            UpdateEsp()
        end
    ]]
    espTracker.Parent = espModel

    -- Salva os dados do ESP para esse jogador
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

-- Função para configurar o ESP de um jogador
local function SetupPlayer(player)
    -- Se o jogador já tem ESP ou é o jogador local, ignora
    if player == LocalPlayer or PlayerEspData[player] then return end

    local characterAddedConnection

    -- Conecta o evento CharacterAdded para criar o ESP quando o personagem aparecer
    characterAddedConnection = player.CharacterAdded:Connect(function(character)
        task.wait(0.5) -- Pequeno delay para garantir que o personagem carregou
        -- Verifica se o jogador ainda existe e não tem ESP criado
        if player and player.Parent and not PlayerEspData[player] then
            CreatePlayerEsp(player)
        end
    end)

    -- Se o personagem já existir, cria o ESP imediatamente
    if player.Character then
        task.wait(0.5) -- Delay extra para garantir
        if player and player.Parent and not PlayerEspData[player] then
            CreatePlayerEsp(player)
        end
    end

    -- Armazena a conexão para poder desconectá-la depois
    if not PlayerEspData[player] then
        PlayerEspData[player] = {}
    end
    PlayerEspData[player].CharacterAddedConnection = characterAddedConnection
end

-- Função para limpar o ESP quando um jogador sai
local function CleanupPlayer(player)
    if PlayerEspData[player] then
        -- Desconecta o evento CharacterAdded para evitar vazamento de memória ou erros
        if PlayerEspData[player].CharacterAddedConnection then
            PlayerEspData[player].CharacterAddedConnection:Disconnect()
        end
        RemovePlayerEsp(player)
    end
end

-- Conecta os eventos para jogadores que entram e saem do jogo
Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(CleanupPlayer)

-- Inicializa os ESPs para os jogadores que já estão no jogo quando o script é executado
for _, player in ipairs(Players:GetPlayers()) do
    SetupPlayer(player)
end

-- Monitora o Workspace para achar novos personagens que possam não ter sido pegos pelos eventos
-- Isso é um "fallback" caso os eventos nativos falhem em algum executor ou cenário específico
local workspaceMonitor = task.spawn(function()
    while task.wait(2) do -- Checa a cada 2 segundos
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not PlayerEspData[player] then
                -- Verifica se o Model do personagem está visível no Workspace e é válido
                if player.Character and player.Character.Parent == Workspace and IsPlayerCharacterModel(player.Character) then
                    CreatePlayerEsp(player)
                end
            end
        end
    end
end)

print("ESP Player Básico aprimorado para o ambiente do jogo! Agora deve funcionar melhor!")
