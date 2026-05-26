
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local function getPlayerFromCharacter(character)
    if character and character.Parent then
        return game.Players:GetPlayerFromCharacter(character.Parent)
    end
    return nil
end

local function createESPBox(targetPlayer)
    local espFrame = Instance.new("Frame")
    espFrame.Size = UDim2.new(0, 100, 0, 50) -- Tamanho inicial, pode ajustar
    espFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    espFrame.BackgroundTransparency = 1
    espFrame.BorderSizePixel = 2
    espFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    espFrame.ZIndex = 100 -- Pra garantir que fique por cima
    espFrame.Visible = false
    espFrame.Parent = game.Players.LocalPlayer.PlayerGui

    local espLabel = Instance.new("TextLabel")
    espLabel.Size = UDim2.new(1, 0, 0, 20)
    espLabel.Position = UDim2.new(0, 0, 0, -20) -- Acima da caixa
    espLabel.Text = targetPlayer.Name
    espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    espLabel.BackgroundTransparency = 1
    espLabel.Font = Enum.Font.SourceSansBold
    espLabel.TextSize = 18
    espLabel.Visible = false
    espLabel.Parent = espFrame

    return espFrame, espLabel
end

local espBoxes = {}

game:GetService("RunService").RenderStepped:Connect(function()
    local camera = game.Workspace.CurrentCamera

    for _, playerObject in ipairs(game.Players:GetPlayers()) do
        if playerObject ~= player and playerObject.Character then
            if not espBoxes[playerObject.UserId] then
                local espFrame, espLabel = createESPBox(playerObject)
                espBoxes[playerObject.UserId] = {frame = espFrame, label = espLabel, character = playerObject.Character}
            end

            local espData = espBoxes[playerObject.UserId]
            if espData.character ~= playerObject.Character then -- Se o personagem mudou (spawnou de novo)
                espData.character = playerObject.Character
            end

            local targetChar = espData.character
            if targetChar and targetChar.Head then
                local headPos = targetChar.Head.Position
                local screenPos, onScreen = camera:WorldToScreenPoint(headPos)

                local frame = espData.frame
                local label = espData.label

                if onScreen then
                    local headSize2D = camera.Projection * (targetChar.Head.Size.Magnitude * 2) -- Aproximação do tamanho 2D

                    frame.Size = UDim2.new(0, headSize2D * 1.5, 0, headSize2D * 2.5) -- Ajusta o tamanho da caixa
                    frame.Position = UDim2.new(0, screenPos.X - frame.Size.X.Offset / 2, 0, screenPos.Y - frame.Size.Y.Offset / 2)
                    frame.Visible = true
                    label.Visible = true
                else
                    frame.Visible = false
                    label.Visible = false
                end
            else
                frame.Visible = false
                label.Visible = false
            end
        end
    end

    -- Limpa boxes de jogadores que saíram
    for userId, espData in pairs(espBoxes) do
        local playerObject = game.Players:GetPlayerByUserId(userId)
        if not playerObject or not playerObject.Character then
            espData.frame:Destroy()
            espData.label:Destroy()
            espBoxes[userId] = nil
        end
    end
end)
