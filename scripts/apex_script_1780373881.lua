local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function farmGold()
    local claimEvent = Workspace:FindFirstChild("ClaimRiverResultsGold")
    if claimEvent and claimEvent:IsA("RemoteEvent") then
        claimEvent:FireServer()
    end
end

task.spawn(function()
    while true do
        farmGold()
        task.wait(30)
    end
end)