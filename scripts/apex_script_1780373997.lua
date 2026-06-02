local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

local function teleportToEnd()
    RootPart.CFrame = CFrame.new(-70, 20, 9500)
end

local function claimReward()
    local workspace = game:GetService("Workspace")
    local event = workspace:FindFirstChild("ClaimRiverResultsGold")
    if event then
        event:FireServer()
    end
end

task.spawn(function()
    while true do
        teleportToEnd()
        task.wait(2)
        claimReward()
        task.wait(10)
    end
end)