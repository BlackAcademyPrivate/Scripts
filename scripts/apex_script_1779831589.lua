local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Usamos getgenv() para armazenar variáveis globais acessíveis pelo executor
getgenv().ESPEnabled = false
getgenv().ActiveHighlights = getgenv().ActiveHighlights or {} -- Tabela para guardar os Highlights ativos

-- Configurações visuais para o Highlight
local HighlightSettings = {
    FillColor = Color3.fromRGB(0, 255, 0), -- Cor de preenchimento (verde)
    OutlineColor = Color3.fromRGB(0, 0, 0), -- Cor do contorno (preto)
    FillTransparency = 0.6, -- Transparência do preenchimento
    OutlineTransparency = 0, -- Transparência do contorno
    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Faz o highlight aparecer através das paredes
}

-- Função para atualizar ou criar o highlight de um jogador
local function updatePlayerHighlight(player)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    local highlight = getgenv().ActiveHighlights[player.Name]

    -- Verifica se o jogador tem um personagem e se ele está vivo
    if character and humanoid and humanoid.Health > 0 then
        -- Se o jogador está válido e vivo
        if not highlight then
            -- Se não existe um highlight, cria um novo
            highlight = Instance.new("Highlight")
            highlight.FillColor = HighlightSettings.FillColor
            highlight.OutlineColor = HighlightSettings.OutlineColor
            highlight.FillTransparency = HighlightSettings.FillTransparency
            highlight.OutlineTransparency = HighlightSettings.OutlineTransparency
            highlight.DepthMode = HighlightSettings.DepthMode
            highlight.Adornee = character -- O highlight "adora" o personagem
            highlight.Parent = character -- Adiciona o highlight como filho do personagem
            getgenv().ActiveHighlights[player.Name] = highlight
        end
        -- Garante que o Adornee está sempre atualizado (importante em caso de respawn)
        highlight.Adornee = character
        highlight.Enabled = true -- Garante que o highlight esteja ativado
    else
        -- Se o jogador não está válido ou está morto
        if highlight then
            -- Destrói o highlight existente
            highlight:Destroy()
            getgenv().ActiveHighlights[player.Name] = nil
        end
    end
end

-- Função para ativar/desativar o ESP
local function toggleESP()
    getgenv().ESPEnabled = not getgenv().ESPEnabled
    print("ESP Status: " .. (getgenv().ESPEnabled and "ATIVADO" or "DESATIVADO"))

    if not getgenv().ESPEnabled then
        -- Se o ESP for desativado, remove todos os highlights ativos
        for _, highlight in pairs(getgenv().ActiveHighlights) do
            if highlight and highlight:IsA("Highlight") then
                highlight:Destroy()
            end
        end
        getgenv().ActiveHighlights = {} -- Limpa a tabela de highlights
    end
end

-- Loop principal para o ESP, rodando em uma thread separada
task.spawn(function()
    while task.wait(0.2) do -- Atualiza a cada 0.2 segundos para não sobrecarregar
        if getgenv().ESPEnabled then
            local currentPlayersInGame = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then -- Ignora o jogador local
                    currentPlayersInGame[player.Name] = true
                    updatePlayerHighlight(player)
                end
            end

            -- Limpa highlights de jogadores que saíram do jogo
            for playerName, highlight in pairs(getgenv().ActiveHighlights) do
                if not currentPlayersInGame[playerName] then
                    if highlight and highlight:IsA("Highlight") then
                        highlight:Destroy()
                    end
                    getgenv().ActiveHighlights[playerName] = nil
                end
            end
        end
    end
end)

-- Limpeza inicial caso o script seja executado novamente
for _, highlight in pairs(getgenv().ActiveHighlights) do
    if highlight and highlight:IsA("Highlight") then
        highlight:Destroy()
    end
end
getgenv().ActiveHighlights = {}

-- Informa ao usuário como usar
print("Script de ESP para Players carregado!")
print("Para ativar/desativar o ESP, digite toggleESP() no console do executor ou na linha de comando.")

-- Torna a função de toggle acessível globalmente
getgenv().toggleESP = toggleESP