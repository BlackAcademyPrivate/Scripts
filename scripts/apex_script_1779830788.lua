local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false -- O ESP começa desativado. Use ToggleESP() para ativar.
local highlights = {} -- Tabela para armazenar as instâncias de Highlight, indexadas por Player.UserId.
local playerConnections = {} -- Tabela para armazenar conexões de eventos de jogadores.

-- Função auxiliar para criar um Highlight para um personagem
local function CreatePlayerHighlight(player)
    if not player or not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
        return nil -- Retorna nil se o jogador ou personagem não for válido
    end

    local character = player.Character
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_Highlight" -- Nome para facilitar a identificação no Explorer
    highlight.Parent = character -- Essencial: o Highlight precisa ser filho do Character
    highlight.Enabled = true
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Cor de preenchimento (vermelho)
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Cor do contorno (branco)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOn -- Para o highlight aparecer através de objetos
    highlight.Adornee = character -- O objeto que o highlight irá envolver

    return highlight
end

-- Função auxiliar para remover um Highlight de um jogador
local function RemoveHighlight(player)
    local userId = player.UserId
    if highlights[userId] then
        if highlights[userId] and highlights[userId].Parent then
            highlights[userId]:Destroy()
        end
        highlights[userId] = nil
    end
end

-- Configura ou remove o Highlight para um jogador específico
local function SetupPlayerHighlight(player)
    if player == LocalPlayer then return end -- Não destaca o jogador local

    -- Primeiro, remove qualquer highlight existente para este jogador
    RemoveHighlight(player)

    -- Se o ESP estiver ativado e o jogador for válido, cria um novo highlight
    if ESPEnabled and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
        local highlight = CreatePlayerHighlight(player)
        if highlight then
            highlights[player.UserId] = highlight
        end
    end
end

-- Evento: Personagem do jogador foi adicionado/respawnou
local function OnCharacterAdded(character)
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        SetupPlayerHighlight(player)
    end
end

-- Evento: Personagem do jogador foi removido (morreu ou saiu)
local function OnCharacterRemoving(character)
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        RemoveHighlight(player)
    end
end

-- Adiciona listeners de eventos para um jogador (CharacterAdded/Removing)
local function AddPlayerEventListeners(player)
    if player == LocalPlayer then return end

    -- Desconecta listeners antigos se existirem
    RemovePlayerEventListeners(player) 

    playerConnections[player.UserId] = {
        CharacterAddedConnection = player.CharacterAdded:Connect(OnCharacterAdded),
        CharacterRemovingConnection = player.CharacterRemoving:Connect(OnCharacterRemoving)
    }
    
    -- Se o personagem já existir, configura o highlight imediatamente
    if player.Character then
        task.spawn(function()
            task.wait() -- Pequeno delay para garantir que o character esteja pronto
            SetupPlayerHighlight(player)
        end)
    end
end

-- Remove listeners de eventos para um jogador e seu highlight
local function RemovePlayerEventListeners(player)
    local userId = player.UserId
    if playerConnections[userId] then
        playerConnections[userId].CharacterAddedConnection:Disconnect()
        playerConnections[userId].CharacterRemovingConnection:Disconnect()
        playerConnections[userId] = nil
    end
    RemoveHighlight(player) -- Garante que o highlight seja removido quando o jogador sai
end

-- Inicializa o ESP: adiciona listeners para jogadores existentes e futuros
local function InitESP()
    -- Adiciona listeners para todos os jogadores que já estão no jogo
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            AddPlayerEventListeners(player)
        end
    end

    -- Adiciona listeners para jogadores que entrarem e saírem no futuro
    Players.PlayerAdded:Connect(AddPlayerEventListeners)
    Players.PlayerRemoving:Connect(RemovePlayerEventListeners)
end

-- Referência ao loop principal do ESP, para controlá-lo
local espUpdateLoop = nil

-- Função principal para ligar/desligar o ESP
local function ToggleESP()
    ESPEnabled = not ESPEnabled

    if ESPEnabled then
        InitESP() -- Prepara todos os listeners de eventos

        -- Inicia o loop de atualização do ESP em uma nova thread
        espUpdateLoop = task.spawn(function()
            while ESPEnabled do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                            if not highlights[player.UserId] then
                                -- Se o highlight não existe, tenta criar
                                local highlight = CreatePlayerHighlight(player)
                                if highlight then
                                    highlights[player.UserId] = highlight
                                end
                            else
                                -- Se o highlight existe, garante que o Adornee e Parent estejam corretos
                                -- Isso é uma verificação de segurança, CharacterAdded/Removing deveria cuidar.
                                local highlight = highlights[player.UserId]
                                if highlight.Adornee ~= player.Character then
                                    highlight.Adornee = player.Character
                                end
                                if highlight.Parent ~= player.Character then
                                    highlight.Parent = player.Character
                                end
                            end
                        else
                            -- Jogador morto ou sem personagem, remove o highlight
                            RemoveHighlight(player)
                        end
                    end
                end

                -- Limpeza extra para highlights de jogadores que possam ter saído ou morrido
                -- (Mesmo que PlayerRemoving e CharacterRemoving já devessem tratar)
                for userId, highlight in pairs(highlights) do
                    local player = Players:GetPlayerByUserId(userId)
                    if not player or player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
                        RemoveHighlight(Players:GetPlayerByUserId(userId))
                    end
                end

                task.wait(0.2) -- Espera 0.2 segundos antes da próxima atualização
            end

            -- Quando o ESP é desativado (ESPEnabled = false), o loop termina e limpa
            for _, highlight in pairs(highlights) do
                if highlight and highlight.Parent then
                    highlight:Destroy()
                end
            end
            highlights = {} -- Limpa a tabela de highlights
            
            -- Desconecta todos os listeners de eventos dos jogadores
            for userId, connections in pairs(playerConnections) do
                if connections.CharacterAddedConnection then connections.CharacterAddedConnection:Disconnect() end
                if connections.CharacterRemovingConnection then connections.CharacterRemovingConnection:Disconnect() end
            end
            playerConnections = {}
        end)
    else
        -- Se o ESP for desativado, o loop 'while ESPEnabled do' irá terminar e fazer a limpeza.
        -- Não precisamos de task.cancel(), a própria condição do loop é suficiente.
    end
    print("ESP Toggled: " .. tostring(ESPEnabled))
end

-- Cria um ScreenGui para gerenciar o script, seguindo as regras
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "APEX_PlayerESP_Manager"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

-- Torna a função ToggleESP acessível globalmente para você chamar no seu executor
getgenv().ToggleESP = ToggleESP