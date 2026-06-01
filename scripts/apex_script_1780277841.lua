local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BridgeNet2 = ReplicatedStorage:WaitForChild("BridgeNet2")
local Remote = BridgeNet2:WaitForChild("dataRemoteEvent")

-- Hook no método FireServer
local oldFireServer = Remote.FireServer
Remote.FireServer = function(self, ...)
    local args = {...}
    print("--- INTERCEPTADO ---")
    for i, v in pairs(args) do
        print("Argumento " .. i .. ":", v)
    end
    return oldFireServer(self, ...)
end

print("Hook ativado! Agora clique no jogo e veja o console.")