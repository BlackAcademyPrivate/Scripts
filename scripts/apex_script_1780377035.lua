local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local AllNPC = Workspace:WaitForChild("AllNPC")

for _, npc in pairs(AllNPC:GetChildren()) do
    if npc:IsA("Model") then
        local targetPart = npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart")
        if targetPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame
            task.wait(0.5)
        end
    end
end