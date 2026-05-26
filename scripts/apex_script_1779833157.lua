local Lighting = game:GetService("Lighting")

task.spawn(function()
    while true do
        Lighting.ClockTime = 20
        task.wait(0.5) -- Espera um pouco antes de aplicar novamente, para não sobrecarregar.
    end
end)