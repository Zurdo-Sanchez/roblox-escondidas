local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Objetos a los que puede disfrazarse
local disguises = {"Chair", "Box", "Lamp"}

-- Crear menú simple
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local list = Instance.new("Frame", gui)
list.Size = UDim2.new(0.3, 0, 0.3, 0)
list.Position = UDim2.new(0.35, 0, 0.35, 0)

for _, name in ipairs(disguises) do
	local button = Instance.new("TextButton", list)
	button.Text = name
	button.Size = UDim2.new(1, 0, 0, 30)
	button.MouseButton1Click:Connect(function()
		local new = game.ReplicatedStorage:FindFirstChild(name):Clone()
		new.CFrame = player.Character:GetPrimaryPartCFrame()
		player.Character:Destroy()
		new.Parent = workspace
	end)
end