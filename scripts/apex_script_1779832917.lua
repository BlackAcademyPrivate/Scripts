local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tabela para guardar os objetos Highlight de cada jogador.
-- Isso nos ajuda a gerenciar e reutilizar os Highlights.
local playerHighlights = {} -- Ex: { [player1] = highlightInstance1, [player2] = highlightInstance2 }

-- Função responsável por criar, atualizar ou desativar o Highlight de um jogador específico.
local function updatePlayerHighlight(player)
    -- Ignora o jogador local para não highlightar a si mesmo.
    if player == LocalPlayer then return end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- Pega o Highlight existente para este jogador, se houver.
    local highlight = playerHighlights[player]

    -- Verifica se o jogador tem um personagem e está vivo.
    if character and humanoid and humanoid.Health > 0 then
        -- Se o jogador está vivo e não tem um Highlight ainda, cria um novo.
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)       -- Cor de preenchimento verde.
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Cor do contorno branco.
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Garante que seja visível através de obstáculos.
            highlight.Name = "APEX_PlayerHighlight_" .. player.Name -- Nome único para o Highlight.
            highlight.Enabled = true                                -- Ativa o Highlight.
            playerHighlights[player] = highlight                  -- Salva na nossa tabela.
        else
            -- Se o Highlight já existe, apenas garante que está ativado.
            highlight.Enabled = true
        end

        -- Define o Adornee para o personagem do jogador. Isso faz o Highlight aparecer nele.
        -- O Parent pode ser o próprio Character, assim ele se move e é destruído com o Character.
        highlight.Adornee = character
        highlight.Parent = character
    else
        -- Se o jogador não tem personagem ou está morto, desativa o Highlight.
        if highlight then
            highlight.Enabled = false
            -- Opcional: Se quiser destruir o Highlight em vez de apenas desativar, descomente a linha abaixo.
            -- highlight:Destroy()
            -- playerHighlights[player] = nil
        end
    end
end

-- Conexão para limpar os Highlights quando um jogador sai do jogo.
Players.PlayerRemoving:Connect(function(player)
    local highlight = playerHighlights[player]
    if highlight then
        highlight:Destroy()      -- Destrói o objeto Highlight.
        playerHighlights[player] = nil -- Remove da nossa tabela.
    end
end)

-- Loop principal que roda em uma thread separada para não travar o jogo.
-- Ele verifica e atualiza os Highlights de todos os jogadores periodicamente.
task.spawn(function()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            -- Usa pcall para garantir que um erro em um Highlight não quebre todo o script.
            pcall(updatePlayerHighlight, player)
        end
        task.wait(0.2) -- Espera um pouco para não sobrecarregar.
    end
end)

-- Lida com jogadores que já estão no jogo quando o script é executado.
for _, player in ipairs(Players:GetPlayers()) do
    pcall(updatePlayerHighlight, player)
end

-- Lida com novos jogadores que entram no jogo.
Players.PlayerAdded:Connect(function(player)
    -- Chama a função de update para o novo jogador.
    pcall(updatePlayerHighlight, player)
    -- Garante que o Highlight é atualizado quando o personagem do novo jogador carrega ou respawna.
    player.CharacterAdded:Connect(function()
        pcall(updatePlayerHighlight, player)
    end)
end)