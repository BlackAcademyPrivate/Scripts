local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FarmGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Button = Instance.new("TextButton")
Button.Name = "CollectButton"
Button.Size = UDim2.new(0, 120, 0, 50)
Button.Position = UDim2.new(0.8, 0, 0.5, 0)
Button.Text = "COLETAR OURO"
Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Button.TextColor3 = Color3.fromRGB(255, 215, 0)
Button.BorderSizePixel = 2
Button.Parent = ScreenGui

Button.MouseButton1Click:Connect(function()
	local Chest = Workspace.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")
	local Remote = Workspace:FindFirstChild("ClaimRiverResultsGold")
	
	if Chest and Chest:FindFirstChild("Trigger") then
		local Character = Player.Character
		if Character and Character:FindFirstChild("HumanoidRootPart") then
			Character.HumanoidRootPart.CFrame = Chest.Trigger.CFrame + Vector3.new(0, 5, 0)
			
			if Remote then
				Remote:FireServer()
				Button.Text = "Enviado!"
				task.wait(2)
				Button.Text = "COLETAR OURO"
			end
		end
	else
		Button.Text = "Erro: Baú não achado"
		task.wait(2)
		Button.Text = "COLETAR OURO"
	end
end)