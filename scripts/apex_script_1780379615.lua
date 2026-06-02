local function monitorarRemotes()
    for _, obj in ipairs(game:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            if not string.find(obj:GetFullName(), "RobloxReplicatedStorage") then
                if obj:IsA("RemoteEvent") then
                    obj.OnClientEvent:Connect(function(...)
                        print("Evento Recebido: " .. obj.Name, ...)
                    end)
                end
            end
        end
    end
end
monitorarRemotes()