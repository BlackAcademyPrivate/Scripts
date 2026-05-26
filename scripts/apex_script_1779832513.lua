local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Tenta encontrar o item M9 no Workspace
local m9Item = Workspace:FindFirstChild("M9")

if not m9Item then
    -- Se o M9 não for encontrado, informa e para o script
    print("APEX: Item 'M9' não encontrado no mapa.")
    return
end

-- Espera o personagem do jogador carregar
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

if not humanoidRootPart then
    -- Se a HumanoidRootPart não for encontrada, informa e para o script
    print("APEX: HumanoidRootPart não encontrada no seu personagem.")
    return
end

local targetCFrame

-- Verifica se o M9 é uma BasePart (Part, MeshPart, etc.)
if m9Item:IsA("BasePart") then
    targetCFrame = m9Item.CFrame
-- Verifica se o M9 é um Model
elseif m9Item:IsA("Model") then
    -- Tenta usar o CFrame da PrimaryPart do modelo, se existir
    if m9Item.PrimaryPart then
        targetCFrame = m9Item.PrimaryPart.CFrame
    else
        -- Como fallback, tenta encontrar a primeira BasePart dentro do modelo
        local partInModel = m9Item:FindFirstChildOfClass("BasePart")
        if partInModel then
            targetCFrame = partInModel.CFrame
        else
            -- Se não encontrar uma PrimaryPart ou BasePart, informa e para o script
            print("APEX: O modelo 'M9' não tem uma PrimaryPart ou BasePart para teletransportar.")
            return
        end
    end
else
    -- Se o item M9 não for nem BasePart nem Model, informa e para o script
    print("APEX: O item 'M9' não é um tipo válido para teletransporte (BasePart ou Model).")
    return
end

-- Adiciona um pequeno deslocamento para cima para evitar que o personagem fique preso no chão
local offset = Vector3.new(0, 3, 0) -- Teleporta 3 studs para cima do item

-- Realiza o teletransporte
humanoidRootPart.CFrame = targetCFrame + offset
print("APEX: Teletransportado para o M9!")