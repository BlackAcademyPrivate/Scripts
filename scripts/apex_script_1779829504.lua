local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local jumpToggle = true

local function autoJump()
    while jumpToggle do
        if humanoid.Health > 0 then
            humanoid.Jump = true
            task.wait(0.1) -- Pequeno delay para evitar que o pulo seja instantâneo
            humanoid.Jump = false
        end
        task.wait(0.5) -- Intervalo entre os pulos
    end
end

-- Inicia a função em uma nova thread
task.spawn(autoJump)

-- Para o script
script.Destroying:Connect(function()
    jumpToggle = false
end)