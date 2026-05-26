local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- gethui() é preferível para parentar GUIs, CoreGui é um fallback.
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

local APEX_PlayerESP_GUI = Instance.new("ScreenGui")
APEX_PlayerESP_GUI.Name = "APEX_PlayerESP_GUI"
APEX_PlayerESP_GUI.ResetOnSpawn = false -- Mantém a GUI visível mesmo após o personagem morrer
APEX_PlayerESP_GUI.IgnoreGuiInset = true -- Ignora a barra superior do Roblox
APEX_PlayerESP_GUI.Parent = CoreGui

local ESP_COR = Color3.fromRGB(255, 255, 0) -- Cor amarela para o destaque e o texto

-- Tabela para armazenar os objetos ESP (Highlight, TextLabel e conexões) de cada jogador
local espObjetos = {}

local function criarESPParaJogador(jogador)
    -- Ignora o jogador local e jogadores que já possuem ESP
    if jogador == LocalPlayer then return end
    if espObjetos[jogador.UserId] then return end

    local personagem = jogador.Character or jogador.CharacterAdded:Wait()
    if not personagem then return end

    -- Cria o objeto Highlight para o personagem
    local destaque = Instance.new("Highlight")
    destaque.FillColor = ESP_COR
    destaque.OutlineColor = ESP_COR
    destaque.Adornee = personagem
    destaque.Parent = personagem -- Anexa ao personagem para que se mova com ele e seja destruído se o personagem for destruído

    -- Cria o TextLabel para o nome do jogador
    local nomeLabel = Instance.new("TextLabel")
    nomeLabel.Text = jogador.DisplayName or jogador.Name
    nomeLabel.Font = Enum.Font.SourceSansBold
    nomeLabel.TextSize = 18
    nomeLabel.TextColor3 = ESP_COR
    nomeLabel.TextStrokeTransparency = 0 -- Borda preta para melhor visibilidade
    nomeLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nomeLabel.BackgroundTransparency = 1
    nomeLabel.Size = UDim2.new(0, 150, 0, 25) -- Tamanho razoável
    nomeLabel.ZIndex = 2 -- Garante que o texto fique acima de outros elementos da GUI
    nomeLabel.Parent = APEX_PlayerESP_GUI

    -- Conexões para lidar com a mudança de personagem do jogador
    local conexoes = {}
    conexoes.CharacterAdded = jogador.CharacterAdded:Connect(function(novoPersonagem)
        -- Atualiza o Highlight para o novo personagem
        if destaque.Adornee ~= novoPersonagem then
            destaque.Adornee = novoPersonagem
            destaque.Parent = novoPersonagem
        end
    end)
    conexoes.CharacterRemoving = jogador.CharacterRemoving:Connect(function(antigoPersonagem)
        -- Se o destaque estava adornando o personagem antigo, desvincule-o
        if destaque.Adornee == antigoPersonagem then
            destaque.Adornee = nil
        end
    end)

    espObjetos[jogador.UserId] = {
        destaque = destaque,
        label = nomeLabel,
        conexoes = conexoes
    }
end

local function removerESPParaJogador(jogador)
    local dadosESP = espObjetos[jogador.UserId]
    if dadosESP then
        -- Destrói o Highlight e o TextLabel
        if dadosESP.destaque then
            dadosESP.destaque:Destroy()
        end
        if dadosESP.label then
            dadosESP.label:Destroy()
        end
        -- Desconecta todas as conexões
        for _, conn in pairs(dadosESP.conexoes) do
            conn:Disconnect()
        end
        espObjetos[jogador.UserId] = nil
    end
end

-- Loop principal para atualizar a posição dos nomes e gerenciar jogadores
task.spawn(function()
    while task.wait(0.1) do
        local jogadoresAtuais = Players:GetPlayers()
        local idsJogadoresAtivos = {}

        for _, jogador in ipairs(jogadoresAtuais) do
            if jogador == LocalPlayer then continue end

            idsJogadoresAtivos[jogador.UserId] = true

            local personagem = jogador.Character
            local cabeca = personagem and personagem:FindFirstChild("Head")
            local humanoide = personagem and personagem:FindFirstChild("Humanoid")

            -- Se o personagem estiver morto ou componentes essenciais não existirem, remove o ESP
            if not personagem or not cabeca or not humanoide or humanoide.Health <= 0 then
                if espObjetos[jogador.UserId] then
                    pcall(removerESPParaJogador, jogador)
                end
                continue
            end

            -- Garante que o ESP seja criado para este jogador ativo
            if not espObjetos[jogador.UserId] then
                pcall(criarESPParaJogador, jogador)
            end

            local dadosESP = espObjetos[jogador.UserId]
            if dadosESP and dadosESP.label and cabeca then
                local pontoTela, naTela = workspace.CurrentCamera:WorldToScreenPoint(cabeca.Position)
                if naTela then
                    -- Ajusta a posição para centralizar o nome acima da cabeça
                    dadosESP.label.Position = UDim2.new(0, pontoTela.X - dadosESP.label.Size.X.Offset / 2, 0, pontoTela.Y - dadosESP.label.Size.Y.Offset / 2)
                    dadosESP.label.Visible = true
                else
                    dadosESP.label.Visible = false -- Esconde se estiver fora da tela
                end
            end
        end

        -- Limpa o ESP de jogadores que saíram do jogo
        for userId, _ in pairs(espObjetos) do
            if not idsJogadoresAtivos[userId] then
                local jogador = Players:GetPlayerByUserId(userId)
                if jogador then
                    pcall(removerESPParaJogador, jogador)
                else
                    -- Caso o jogador já tenha saído completamente e a instância não esteja mais disponível
                    local dadosESP = espObjetos[userId]
                    if dadosESP then
                        if dadosESP.destaque then dadosESP.destaque:Destroy() end
                        if dadosESP.label then dadosESP.label:Destroy() end
                        for _, conn in pairs(dadosESP.conexoes) do conn:Disconnect() end
                        espObjetos[userId] = nil
                    end
                end
            end
        end
    end
end)

-- Configuração inicial para jogadores já presentes no jogo
for _, jogador in ipairs(Players:GetPlayers()) do
    pcall(criarESPParaJogador, jogador)
end

-- Conecta aos eventos PlayerAdded e PlayerRemoving para gerenciamento dinâmico
local conexaoJogadorAdicionado = Players.PlayerAdded:Connect(function(jogador)
    pcall(criarESPParaJogador, jogador)
end)

local conexaoJogadorRemovido = Players.PlayerRemoving:Connect(function(jogador)
    pcall(removerESPParaJogador, jogador)
end)

-- A linha abaixo pode ser usada se o script precisar ser desligado,
-- garantindo a limpeza dos objetos e conexões.
-- getfenv().script_stopped:Connect(function()
--     conexaoJogadorAdicionado:Disconnect()
--     conexaoJogadorRemovido:Disconnect()
--     for userId, dadosESP in pairs(espObjetos) do
--         if dadosESP.destaque then dadosESP.destaque:Destroy() end
--         if dadosESP.label then dadosESP.label:Destroy() end
--         for _, conn in pairs(dadosESP.conexoes) do conn:Disconnect() end
--     end
--     APEX_PlayerESP_GUI:Destroy()
-- end)