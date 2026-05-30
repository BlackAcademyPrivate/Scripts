-- Script Espião de Eventos
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TaskEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted")

local oldFireServer = Instance.new("RemoteEvent").FireServer
local mt = getrawmetatable(game)
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if self == TaskEvent then
        print("--- EVENTO CAPTURADO ---")
        print("Argumentos enviados:")
        for i, v in pairs(args) do
            print("Arg " .. i .. ":", v)
            if type(v) == "table" then
                for k, val in pairs(v) do
                    print("  -> " .. k .. ":", val)
                end
            end
        end
    end
    return oldFireServer(self, ...)
end)