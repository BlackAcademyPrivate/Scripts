local ReplicatedStorage = game:GetService("ReplicatedStorage")
local adminWeight = ReplicatedStorage:WaitForChild("Admin"):WaitForChild("AdminWeight")

-- Teste: Tentar adicionar 9999 de peso
-- Se o servidor for mal configurado, ele aceitará o pedido sem checar se você é admin.
adminWeight:FireServer(9999)