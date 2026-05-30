local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Caminhos identificados
local TaskEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted")
local Tycoon = Workspace:WaitForChild("Tycoons"):WaitForChild("Tycoon") -- Ajuste se o nome do seu tycoon for diferente
local CustomersFolder = Tycoon:WaitForChild("ClientCustomers")

while wait(2) do -- Loop a cada 2 segundos para não sobrecarregar o servidor
    for _, customer in pairs(CustomersFolder:GetChildren()) do
        -- AQUI ESTÁ O PULO DO GATO:
        -- Precisamos verificar se o cliente está "pedindo". 
        -- Geralmente eles têm um atributo ou uma pasta de status.
        -- Vamos verificar se existe um atributo chamado "State" ou similar.
        
        local isWaiting = false
        
        -- Exemplo de verificação (ajuste conforme o que aparecer no seu explorer)
        if customer:FindFirstChild("Status") and customer.Status.Value == "WaitingForOrder" then
            isWaiting = true
        end

        if isWaiting then
            local args = {
                {
                    GroupId = "12", -- Verifique se este ID muda conforme o servidor
                    Tycoon = Tycoon,
                    Name = "TakeOrder",
                    CustomerId = customer.Name -- Usamos o nome do NPC como ID
                }
            }
            TaskEvent:FireServer(unpack(args))
            print("Pedido atendido para: " .. customer.Name)
        end
    end
end