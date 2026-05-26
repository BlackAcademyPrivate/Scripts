
local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local esp_enabled = true -- Para ligar/desligar facilmente

local function get_player_from_character(character)
    if character and character.Parent then
        return game.Players:GetPlayerFromCharacter(character.Parent)
    end
    return nil
end

local esp_elements = {} -- Armazena os elementos de ESP para cada jogador

local function create_esp_frame(target_player)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 100, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.ZIndex = 100
    frame.Visible = false
    frame.Parent = game.Players.LocalPlayer.PlayerGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, -20)
    label.Text = target_player.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.Visible = false
    label.Parent = frame

    return {frame = frame, label = label}
end

local function update_esp_for_player(player_obj, esp_data)
    if not esp_enabled or not player_obj.Character then
        esp_data.frame.Visible = false
        esp_data.label.Visible = false
        return
    end

    local character = player_obj.Character
    local head = character:FindFirstChild("Head")

    if not head then
        esp_data.frame.Visible = false
        esp_data.label.Visible = false
        return
    end

    local head_pos = head.Position
    local screen_pos, on_screen = camera:WorldToScreenPoint(head_pos)

    if on_screen then
        local distance = (camera.CFrame.Position - head_pos).Magnitude
        local scale_factor = math.max(0.5, 1 - distance / 500) -- Ajusta o tamanho com base na distância

        local head_size_approx = head.Size.Magnitude * scale_factor * 150 -- Estimativa do tamanho na tela
        esp_data.frame.Size = UDim2.new(0, head_size_approx, 0, head_size_approx * 1.2)
        esp_data.frame.Position = UDim2.new(0, screen_pos.X - esp_data.frame.Size.X.Offset / 2, 0, screen_pos.Y - esp_data.frame.Size.Y.Offset / 2)
        esp_data.frame.Visible = true
        esp_data.label.Visible = true
    else
        esp_data.frame.Visible = false
        esp_data.label.Visible = false
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    for _, player_obj in ipairs(game.Players:GetPlayers()) do
        if player_obj ~= player and player_obj.Character then
            if not esp_elements[player_obj.UserId] then
                esp_elements[player_obj.UserId] = create_esp_frame(player_obj)
                esp_elements[player_obj.UserId].character_ref = player_obj.Character -- Guarda referência do personagem
            end

            local esp_data = esp_elements[player_obj.UserId]

            -- Verifica se o personagem mudou (ex: morreu e spawnou de novo)
            if esp_data.character_ref ~= player_obj.Character then
                esp_data.character_ref = player_obj.Character
            end

            update_esp_for_player(player_obj, esp_data)
        end
    end

    -- Limpa elementos de jogadores que saíram ou não têm mais personagem
    for user_id, esp_data in pairs(esp_elements) do
        local player_obj = game.Players:GetPlayerByUserId(user_id)
        if not player_obj or not player_obj.Character then
            esp_data.frame:Destroy()
            esp_data.label:Destroy()
            esp_elements[user_id] = nil
        end
    end
end)

-- Adiciona uma forma de ligar/desligar (pode ser com um GUI no futuro)
-- Para testar, descomente a linha abaixo e execute o script. Para desligar, comente de novo e execute.
-- esp_enabled = false
