local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:FindFirstChild("HumanoidRootPart")

local targetItemName = "AK-47"
local targetItem = nil

for _, obj in ipairs(workspace:GetDescendants()) do
    if obj.Name == targetItemName and obj:IsA("Tool") then
        targetItem = obj
        break
    end
end

if targetItem and rootPart then
    local targetPosition = targetItem:FindFirstChild("Handle") and targetItem.Handle.CFrame or targetItem:FindFirstChildWhichIsA("BasePart") and targetItem:FindFirstChildWhichIsA("BasePart").CFrame
    
    if targetPosition then
        rootPart.CFrame = targetPosition + Vector3.new(0, 3, 0)
    end
end