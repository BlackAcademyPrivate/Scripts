local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EnemiesFolder = workspace:WaitForChild("World"):WaitForChild("Enemies")
local Remote = ReplicatedStorage:WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")
    :WaitForChild("enemies.sendAndRetreat")

-- O primeiro ID (Token) geralmente é estático por sessão ou fácil de obter.
-- Vamos usar o que você mandou como base:
local sessionToken = "d67774ae-661d-41c1-99a4-dc5c680af4a7"

-- 1. Criar uma lista para guardar os IDs dos inimigos vivos
local aliveEnemies = {}

-- 2. Varrer a pasta de inimigos e pegar o Nome (UUID) de cada um
for _, enemy in ipairs(EnemiesFolder:GetChildren()) do
    if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
        table.insert(aliveEnemies, enemy.Name) -- O nome do modelo é o ID!
    end
end

-- 3. Se houver inimigos, enviar o comando para todos eles de uma vez
if #aliveEnemies > 0 then
    -- Dispara o evento passando o Token da Sessão e a tabela com os IDs dos inimigos
    Remote:FireServer(sessionToken, aliveEnemies)
    print("Comando enviado para " .. #aliveEnemies .. " inimigos!")
else
    print("Nenhum inimigo encontrado na pasta.")
end