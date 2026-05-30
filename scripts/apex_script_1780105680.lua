local Lighting = game:GetService("Lighting")

task.spawn(function()
    while task.wait(5) do
        pcall(function()
            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.FogEnd = 10000
        end)
    end
end)