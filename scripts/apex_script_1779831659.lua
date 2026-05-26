local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Use getgenv() para armazenar variáveis globais acessíveis pelo executor
getgenv().ESPEnabled = false
getgenv().ActiveHighlights = getgenv().ActiveHighlights or {} -- Tabela para guardar os Highlights ativos (key: UserId do jogador)

-- Configurações visuais para o Highlight
local HighlightSettings = {
    FillColor = Color3.fromRGB(0, 255, 0), -- Cor de preenchimento (verde)
    OutlineColor = Color3.fromRGB(0, 0, 0), -- Cor do contorno (preto)
    FillTransparency = 0.5, -- Um pouco menos transparente que antes, para ver melhor
    OutlineTransparency = 0, -- Sem transparência no contorno
    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Faz o highlight aparecer através das paredes
}

-- Função para atualizar ou criar/destruir o highlight de um jogador
local function updatePlayerHighlight(player)
    if player == LocalPlayer then return end -- Ignora o jogador local

    local highlight = getgenv().ActiveHighlights[player.UserId] -- Pega highlight pela UserId
    local character = player.Character

    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- Verifica se o jogador tem um personagem e se ele está vivo
    if character and humanoid and humanoid.Health > 0 then
        -- O jogador está válido e vivo
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
            getgenv().ActiveHighlights[player.UserId] = highlight -- Armazena pela UserId
        else
            -- Garante que o Adornee e Parent estão sempre atualizados (importante em caso de respawn)
            if highlight.Adornee ~= character or highlight.Parent ~= character then
                highlight.Adornee = character
                highlight.Parent = character
            end
            highlight.Enabled = true -- Garante que o highlight esteja ativado
        end
    else
        -- Se o jogador não está válido (sem character, morto, etc.)
        if highlight then
            -- Destrói o highlight existente
            highlight:Destroy()
            getgenv().ActiveHighlights[player.UserId] = nil
        end
    end
end

-- Função para ativar/desativar o ESP
local function toggleESP()
    getgenv().ESPEnabled = not getgenv().ESPEnabled
    print("ESP Status: " .. (getgenv().ESPEnabled and "ATIVADO" or "DESATIVADO"))

    if getgenv().ESPEnabled then
        -- Se ativado, faz uma varredura inicial em todos os jogadores
        for _, player in ipairs(Players:GetPlayers()) do
            updatePlayerHighlight(player)
        end
    else
        -- Se o ESP for desativado, remove todos os highlights ativos
        for userId, highlight in pairs(getgenv().ActiveHighlights) do
            if highlight and highlight:IsA("Highlight") then
                highlight:Destroy()
            end
        end
        getgenv().ActiveHighlights = {} -- Limpa a tabela de highlights
    end
end

-- Loop principal para o ESP, rodando em uma thread separada
task.spawn(function()
    while task.wait(0.2) do -- Atualiza a cada 0.2 segundos para não sobrecarregar e ser responsivo
        if getgenv().ESPEnabled then
            local currentPlayersInGame = {}
            for _, player in ipairs(Players:GetPlayers()) do
                -- Ignora o jogador local
                if player ~= LocalPlayer then
                    currentPlayersInGame[player.UserId] = true
                    updatePlayerHighlight(player)
                end
            end

            -- Limpa highlights de jogadores que saíram do jogo ou não estão mais na lista de Players:GetPlayers()
            for userId, highlight in pairs(getgenv().ActiveHighlights) do
                if not currentPlayersInGame[userId] then
                    if highlight and highlight:IsA("Highlight") then
                        highlight:Destroy()
                    end
                    getgenv().ActiveHighlights[userId] = nil
                end
            end
        end
    end
end)

-- Limpeza inicial caso o script seja executado novamente (previne highlights duplicados se rodar várias vezes)
for userId, highlight in pairs(getgenv().ActiveHighlights) do
    if highlight and highlight:IsA("Highlight") then
        highlight:Destroy()
    end
end
getgenv().ActiveHighlights = {}
getgenv().ESPEnabled = false -- Reinicia o estado para false

-- Torna a função de toggle acessível globalmente
getgenv().toggleESP = toggleESP

print("Script de ESP para Players carregado!")
print("Para ativar/desativar o ESP, digite toggleESP() no console do executor ou na linha de comando.")