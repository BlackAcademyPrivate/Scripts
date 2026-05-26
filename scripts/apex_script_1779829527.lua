local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local jumpDelay = 0.01 -- Intervalo entre os comandos de pulo
local loopDelay = 0.5 -- Intervalo entre as tentativas de pular

local jumpLoop = true

local function startJumping()
    while jumpLoop and humanoid and humanoid.Health > 0 do
        humanoid.Jump = true
        task.wait(jumpDelay)
        humanoid.Jump = false
        task.wait(loopDelay)
    end
end

local jumpConnection
jumpConnection = player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    if jumpLoop then
        task.spawn(startJumping)
    end
end)

if jumpLoop then
    task.spawn(startJumping)
end

script.Destroying:Connect(function()
    jumpLoop = false
    if jumpConnection then
        jumpConnection:Disconnect()
    end
end)