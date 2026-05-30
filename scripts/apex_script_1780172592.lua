local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportEvent = ReplicatedStorage:FindFirstChild("TeleportToPortal")

-- Tente teleportar para um dos portais que você identificou no Workspace
-- O nome deve ser exatamente o que o servidor espera.
-- Tente estes nomes que são portais reais:
local portalName = "DungeonPortalsNPC" -- Ou "BossRushPortalNPC" ou "InfiniteTowerPortalNPC"

if TeleportEvent then
    TeleportEvent:FireServer(portalName)
    print("Tentativa de teleporte enviada para: " .. portalName)
else
    warn("Evento de teleporte não encontrado!")
end