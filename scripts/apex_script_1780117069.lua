local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Events = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Restaurant")
local CollectEvent = Events:WaitForChild("CollectBill")

for _, item in pairs(Workspace:GetDescendants()) do
	if item.Name == "Bill" or item:FindFirstChild("Bill") then
		CollectEvent:FireServer(item)
		task.wait(0.1)
	end
end