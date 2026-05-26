local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local playerHighlights = {} -- Mapeia Player -> Highlight Instance

-- Cores e transparências para o destaque
local highlightFillColor = Color3.fromRGB(0, 255, 0) -- Verde para o preenchimento
local highlightOutlineColor = Color3.fromRGB(255, 0, 0) -- Vermelho para o contorno
local highlightFillTransparency = 0.5 -- 50% transparente
local highlightOutlineTransparency = 0 -- Totalmente opaco

local function createHighlight(player)
    if player == LocalPlayer then return end -- Não destaca o próprio jogador
    
    local character = player.Character
    -- Verifica se o personagem e o Humanoid existem
    if not character or not character:FindFirstChildOfClass("Humanoid") then
        return
    end

    -- Se já existe um highlight para este jogador, destrói o antigo primeiro
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end

    -- Cria uma nova instância de Highlight
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character -- O objeto que o highlight vai destacar
    highlight.FillColor = highlightFillColor
    highlight.OutlineColor = highlightOutlineColor
    highlight.FillTransparency = highlightFillTransparency
    highlight.OutlineTransparency = highlightOutlineTransparency
    highlight.Enabled = true -- Ativa o destaque
    highlight.Parent = character -- Adiciona o highlight ao personagem

    playerHighlights[player] = highlight
end

local function destroyHighlight(player)
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
end

-- Conecta-se a eventos para gerenciar destaques de jogadores que entram ou saem
Players.PlayerAdded:Connect(function(player)
    if player == LocalPlayer then return end

    -- Quando o personagem do jogador é adicionado (ex: respawn), cria o destaque
    player.CharacterAdded:Connect(function(character)
        createHighlight(player)
    end)
    -- Quando o personagem do jogador é removido (ex: morte), destrói o destaque
    player.CharacterRemoving:Connect(function(character)
        destroyHighlight(player)
    end)

    -- Se o personagem já existe quando o jogador entra, cria o destaque imediatamente
    if player.Character then
        createHighlight(player)
    end
end)

-- Quando um jogador sai do jogo, destrói o destaque dele
Players.PlayerRemoving:Connect(function(player)
    destroyHighlight(player)
end)

-- Varredura inicial para jogadores já existentes no servidor
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        -- Conecta os eventos de CharacterAdded/Removing para cada jogador
        player.CharacterAdded:Connect(function(character)
            createHighlight(player)
        end)
        player.CharacterRemoving:Connect(function(character)
            destroyHighlight(player)
        end)

        -- Cria o destaque se o personagem já estiver carregado
        if player.Character then
            createHighlight(player)
        end
    end
end

-- Loop de robustez: Garante que os destaques estejam sempre presentes e atualizados
-- Isso ajuda contra qualquer sistema do jogo que possa tentar remover os destaques
task.spawn(function()
    while task.wait(0.2) do -- Espera 0.2 segundos antes de cada verificação
        for _, player in ipairs(Players:GetPlayers()) do
            -- Ignora o próprio jogador
            if player == LocalPlayer then
                destroyHighlight(player) -- Garante que seu highlight seja removido se por algum bug ele aparecer
                continue
            end

            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            -- Se o personagem e o Humanoid existem e o jogador está vivo
            if character and humanoid and humanoid.Health > 0 then
                -- Se o destaque está faltando, foi desabilitado ou perdeu o Parent, recria
                if not playerHighlights[player] or not playerHighlights[player].Parent or not playerHighlights[player].Enabled then
                    createHighlight(player)
                else
                    -- Garante que o Adornee esteja correto e o highlight esteja ativado
                    playerHighlights[player].Adornee = character
                    playerHighlights[player].Enabled = true
                end
            else
                -- Se o personagem não existe, está morto, ou é o próprio jogador, destrói o destaque
                destroyHighlight(player)
            end
        end
    end
end)