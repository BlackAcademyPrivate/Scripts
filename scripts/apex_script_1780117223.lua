local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local events = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Restaurant")
local collectEvent = events:WaitForChild("CollectBill")

for _, item in pairs(Workspace:GetDescendants()) do
    if item:IsA("Model") and item.Name == "Bill" then
        rootPart.CFrame = item.PrimaryPart.CFrame
        collectEvent:FireServer(item)
        task.wait(0.5)
    end
end