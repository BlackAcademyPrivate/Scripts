local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local ActiveHighlights = {} -- Tabela para armazenar as instâncias de Highlight ativas, indexadas pelo jogador

-- Configurações visuais do destaque
local OUTLINE_COLOR = Color3.fromRGB(255, 0, 0) -- Cor da borda (vermelho)
local FILL_COLOR = Color3.fromRGB(255, 0, 0)    -- Cor do preenchimento (vermelho)
local FILL_TRANSPARENCY = 0.7                   -- Transparência do preenchimento (0 = opaco, 1 = invisível)

-- Função para criar ou atualizar o destaque de um jogador
local function UpdatePlayerHighlight(player)
    -- Ignora o jogador local e jogadores inválidos
    if not player or player == LocalPlayer then return end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- Verifica se o jogador tem um personagem e está vivo
    if character and humanoid and humanoid.Health > 0 then
        local highlight = ActiveHighlights[player]

        if not highlight then
            -- Cria um novo Highlight se não existir
            highlight = Instance.new("Highlight")
            highlight.OutlineColor = OUTLINE_COLOR
            highlight.FillColor = FILL_COLOR
            highlight.FillTransparency = FILL_TRANSPARENCY
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Faz o destaque aparecer através das paredes
            highlight.Parent = character -- Anexa ao personagem do jogador
            ActiveHighlights[player] = highlight
        else
            -- Se já existe, apenas garante que está habilitado e parentado corretamente
            if highlight.Parent ~= character then
                highlight.Parent = character
            end
            highlight.Enabled = true
        end
    else
        -- Se o jogador não está vivo ou não tem personagem, remove o destaque
        local highlight = ActiveHighlights[player]
        if highlight then
            highlight:Destroy()
            ActiveHighlights[player] = nil
        end
    end
end

-- Função para remover completamente o destaque de um jogador (ex: quando ele sai do jogo)
local function RemovePlayerHighlight(player)
    local highlight = ActiveHighlights[player]
    if highlight then
        highlight:Destroy()
        ActiveHighlights[player] = nil
    end
end

-- Loop principal que atualiza os destaques de todos os jogadores
task.spawn(function()
    while task.wait(0.2) do -- Espera um pouco para não sobrecarregar
        for _, player in ipairs(Players:GetPlayers()) do
            UpdatePlayerHighlight(player)
        end
    end
end)

-- Conecta a um evento para limpar destaques quando um jogador sai
Players.PlayerRemoving:Connect(RemovePlayerHighlight)

-- Atualiza os jogadores que já estão no jogo quando o script é executado
for _, player in ipairs(Players:GetPlayers()) do
    UpdatePlayerHighlight(player)
end