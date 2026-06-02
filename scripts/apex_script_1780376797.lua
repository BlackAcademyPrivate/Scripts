local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local AllNPC = Workspace:WaitForChild("AllNPC")
local SkillAction = ReplicatedStorage:WaitForChild("SkillAction")

task.spawn(function()
    while true do
        local closestNPC = nil
        local shortestDistance = math.huge
        
        for _, npc in pairs(AllNPC:GetChildren()) do
            if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                if distance < 50 and distance < shortestDistance then
                    shortestDistance = distance
                    closestNPC = npc
                end
            end
        end
        
        if closestNPC then
            SkillAction:FireServer("SpinFruit", closestNPC.HumanoidRootPart.Position)
        end
        task.wait(0.5)
    end
end)