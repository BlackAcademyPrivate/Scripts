local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

print("--- Iniciando busca pelo Tycoon ---")

for _, obj in pairs(workspace:GetDescendants()) do
    -- Procura por objetos que tenham o nome do jogador ou que pareçam um Tycoon
    if obj:IsA("Folder") or obj:IsA("Model") then
        if obj.Name:lower():find(localPlayer.Name:lower()) or obj.Name:find("Tycoon") then
            -- Verifica se tem algo que parece com o que precisamos (Items, Surface)
            if obj:FindFirstChild("Items") then
                print("ENCONTRADO: " .. obj:GetFullName())
            end
        end
    end
end
print("--- Busca finalizada ---")