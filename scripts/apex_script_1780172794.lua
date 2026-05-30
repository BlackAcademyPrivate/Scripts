local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportEvent = ReplicatedStorage:WaitForChild("TeleportToPortal")

-- Lista de nomes prováveis que o servidor aceita como destino
local destinos = {"Dungeon", "BossRush", "InfiniteTower", "Jungle", "Hollow"}

for _, nome in pairs(destinos) do
    print("Tentando teleportar para: " .. nome)
    TeleportEvent:FireServer(nome)
    task.wait(1)
end