
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local walkSpeed = 100 -- Velocidade padrão, pode ajustar pra mais ou pra menos
local isSpeedActive = false
local originalWalkSpeed = 16 -- Valor padrão do Roblox

-- Pega o Humanoid do jogador
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")

-- Atualiza o Humanoid caso o personagem respawne
local function UpdateHumanoid()
    character = LocalPlayer.Character
    humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        originalWalkSpeed = humanoid.WalkSpeed -- Guarda a velocidade original antes de mexer
    end
end

if humanoid then
    originalWalkSpeed = humanoid.WalkSpeed
end

LocalPlayer.CharacterAdded:Connect(UpdateHumanoid)

-- Função para ativar o speedhack
local function EnableSpeed()
    if humanoid then
        humanoid.WalkSpeed = walkSpeed
        isSpeedActive = true
    end
end

-- Função para desativar o speedhack e voltar ao normal
local function DisableSpeed()
    if humanoid then
        humanoid.WalkSpeed = originalWalkSpeed
        isSpeedActive = false
    end
end

-- Usa uma tecla para ligar/desligar (Ex: 'X')
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end -- Ignora se o input foi processado pelo jogo

    if input.KeyCode == Enum.KeyCode.X then -- Pode trocar 'X' pela tecla que quiser
        if not isSpeedActive then
            EnableSpeed()
            print("Speed hack ativado!")
        else
            DisableSpeed()
            print("Speed hack desativado.")
        end
    end
end)

print("Script de velocidade carregado. Aperte 'X' para ativar/desativar.")

-- Garante que o speedhack esteja ativo se o jogador já estiver no jogo
if humanoid and not isSpeedActive then
    task.spawn(EnableSpeed) -- Usa task.spawn para garantir que rode assíncrono
end
