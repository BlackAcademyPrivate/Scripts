local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function teleportToGoal()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if (obj.Name:lower():find("chest") or obj.Name:lower():find("goal")) and obj:IsA("BasePart") then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                return true
            end
        end
    end
    return false
end

task.spawn(function()
    while true do
        if teleportToGoal() then
            task.wait(5)
            local event = Workspace:FindFirstChild("ClaimRiverResultsGold")
            if event then event:FireServer() end
        end
        task.wait(1)
    end
end)