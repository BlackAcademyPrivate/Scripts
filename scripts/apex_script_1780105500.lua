local Lighting = game:GetService("Lighting")

local function setNightMode()
    pcall(function()
        Lighting.ClockTime = 0
        Lighting.Ambient = Color3.fromRGB(50, 50, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(30, 30, 50)
        Lighting.FogEnd = 1000
        Lighting.FogColor = Color3.fromRGB(20, 20, 30)
    end)
end

task.spawn(function()
    while task.wait(5) do
        setNightMode()
    end
end)