local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local AllDroppedFruit = Workspace:WaitForChild("AllDroppedFruit")
local CollectFruit = ReplicatedStorage:FindFirstChild("CollectFruit")

AllDroppedFruit.ChildAdded:Connect(function(child)
    if child:IsA("Model") or child:IsA("Tool") then
        task.wait(0.5)
        if CollectFruit then
            CollectFruit:FireServer(child)
        end
    end
end)