local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

RootPart.Touched:Connect(function(hit)
    local targetModel = hit.Parent
    local targetRoot = targetModel:FindFirstChild("HumanoidRootPart")

    if targetRoot and targetModel ~= Character and targetModel:FindFirstChild("Humanoid") then
        local force = Instance.new("BodyVelocity")
        force.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        force.Velocity = Vector3.new(math.random(-250, 250), 250, math.random(-250, 250))
        force.Parent = targetRoot
        
        task.wait(0.1)
        force:Destroy()
    end
end)