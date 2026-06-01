local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BridgeNet2 = ReplicatedStorage:WaitForChild("BridgeNet2")
local Remote = BridgeNet2:WaitForChild("dataRemoteEvent")

-- Variável para controlar o estado do Auto-Click
_G.AutoClick = true 

task.spawn(function()
    while _G.AutoClick do
        -- Dispara o evento de clique
        Remote:FireServer({[2] = "\028"})
        
        -- O task.wait(0.05) é rápido o suficiente para farmar muito, 
        -- mas seguro para não ser kickado por spam.
        task.wait(0.05) 
    end
end)

print("Auto-Click Iniciado!")