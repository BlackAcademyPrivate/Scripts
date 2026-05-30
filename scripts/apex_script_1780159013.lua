local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Remote = ReplicatedStorage:WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")
    :WaitForChild("enemies.sendAndRetreat")

local EnemiesFolder = Workspace:WaitForChild("World"):WaitForChild("Enemies")
local SessionToken = "36783919-4fe1-4728-a7e5-f69c0f77c331"

local function triggerRetreat()
    local enemyList = {}
    
    for _, enemy in ipairs(EnemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
            table.insert(enemyList, enemy.Name)
        end
    end
    
    if #enemyList > 0 then
        Remote:FireServer(SessionToken, enemyList)
    end
end

triggerRetreat()