
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function setWalkSpeed(character, speed)
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = speed
        print("WalkSpeed do seu personagem foi alterado para: " .. speed)
    end
end

-- Define a velocidade desejada. Pode ajustar esse valor como quiser!
local desiredSpeed = 50 -- Um valor comum é 16, então 50 é bem mais rápido!

-- Tenta aplicar a velocidade imediatamente se o player já tiver um character
if LocalPlayer.Character then
    setWalkSpeed(LocalPlayer.Character, desiredSpeed)
else
    -- Se não tiver character ainda, espera ele carregar e aí aplica
    LocalPlayer.CharacterAdded:Connect(function(character)
        setWalkSpeed(character, desiredSpeed)
    end)
end
