local Lighting = game:GetService("Lighting")

local NIGHT_HOUR = 20 -- Define a hora da noite (20 = 20:00 ou 8 PM)

-- Função para aplicar a hora da noite
local function applyNightTime()
    if Lighting.ClockTime ~= NIGHT_HOUR then
        Lighting.ClockTime = NIGHT_HOUR
    end
end

-- Mantém a hora da noite em um loop contínuo
task.spawn(function()
    while task.wait(0.5) do -- Verifica e aplica a cada meio segundo
        applyNightTime()
    end
end)

-- Aplica a hora da noite imediatamente ao executar o script
applyNightTime()