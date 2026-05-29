local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui") -- Usar CoreGui para garantir que a ScreenGui apareça

local LocalPlayer = Players.LocalPlayer
local PlayerCharacters = {} -- Tabela para rastrear os personagens dos jogadores
local ActiveHighlights = {} -- Tabela para armazenar as instâncias de Highlight ativas

-- Configurações visuais do destaque
local OUTLINE_COLOR = Color3.fromRGB(255, 0, 0) -- Vermelho
local FILL_COLOR = Color3.fromRGB(255, 0, 0)    -- Vermelho
local FILL_TRANSPARENCY = 0.7                   -- 70% transparente

-- Função para criar a GUI de configuração (se necessário, mas o script já roda direto)
local function CreateSettingsGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ESP_Settings"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = CoreGui -- Parent para CoreGui

    -- Você pode adicionar botões aqui no futuro se quiser um toggle, mas por enquanto, o script roda direto.
end

-- Função para criar ou atualizar o destaque de um jogador
local function UpdatePlayerHighlight(player)
    if not player or player == LocalPlayer then return end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- Verifica se o jogador tem um personagem e está vivo
    if character and humanoid and humanoid.Health > 0 then
        if not PlayerCharacters[player.UserId] then
            PlayerCharacters[player.UserId] = character
        end

        local highlight = ActiveHighlights[player.UserId]

        if not highlight then
            -- Cria um novo Highlight se não existir
            highlight = Instance.new("Highlight")
            highlight.OutlineColor = OUTLINE_COLOR
            highlight.FillColor = FILL_COLOR
            highlight.FillTransparency = FILL_TRANSPARENCY
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Atravessa paredes
            highlight.Parent = character
            ActiveHighlights[player.UserId] = highlight
        else
            -- Se já existe, garante que está habilitado e parentado corretamente
            if highlight.Parent ~= character then
                highlight.Parent = character
            end
            highlight.Enabled = true
        end
    else
        -- Se o jogador não está vivo ou não tem personagem, remove o destaque
        local highlight = ActiveHighlights[player.UserId]
        if highlight then
            highlight:Destroy()
            ActiveHighlights[player.UserId] = nil
        end
        PlayerCharacters[player.UserId] = nil -- Limpa o personagem rastreado
    end
end

-- Função para remover completamente o destaque de um jogador (quando ele sai)
local function RemovePlayerHighlight(player)
    local highlight = ActiveHighlights[player.UserId]
    if highlight then
        highlight:Destroy()
        ActiveHighlights[player.UserId] = nil
    end
    PlayerCharacters[player.UserId] = nil
end

-- Conecta a eventos para lidar com jogadores entrando e saindo
Players.PlayerAdded:Connect(function(player)
    -- Espera um pouco para o personagem carregar, caso ele entre enquanto o script já está rodando
    task.spawn(function()
        player.CharacterAdded:Wait()
        UpdatePlayerHighlight(player)
    end)
end)

Players.PlayerRemoving:Connect(RemovePlayerHighlight)

-- Loop principal para verificar todos os jogadores periodicamente
task.spawn(function()
    while task.wait(0.2) do -- Intervalo de atualização
        for _, player in ipairs(Players:GetPlayers()) do
            UpdatePlayerHighlight(player)
        end
    end
end)

-- Garante que a GUI de configurações exista (mesmo que vazia por enquanto)
CreateSettingsGui()

-- Atualiza os jogadores que já estão no jogo quando o script é executado
for _, player in ipairs(Players:GetPlayers()) do
    UpdatePlayerHighlight(player)
end