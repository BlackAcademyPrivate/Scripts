local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local bridgeNet = ReplicatedStorage:FindFirstChild("BridgeNet2")
if bridgeNet then
    local identifierStorage = bridgeNet:FindFirstChild("identifierStorage")
    if identifierStorage then
        local map = {}
        for _, child in pairs(identifierStorage:GetChildren()) do
            -- No BridgeNet2, os identificadores costumam ser armazenados em instâncias de valor
            if child:IsA("ValueBase") then
                map[child.Name] = child.Value
            else
                map[child.Name] = child.ClassName
            end
        end
        -- Converte a tabela para uma string JSON legível
        return HttpService:JSONEncode(map)
    else
        return "identifierStorage não encontrado."
    end
else
    return "BridgeNet2 não encontrado."
end