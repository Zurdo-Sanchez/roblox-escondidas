local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local roleEvent = ReplicatedStorage:WaitForChild("RoleEvent")
local timerEvent = ReplicatedStorage:WaitForChild("TimerEvent")

local gui = Instance.new("ScreenGui")
gui.Name = "HUD"
gui.Parent = player:WaitForChild("PlayerGui")

local roleLabel = Instance.new("TextLabel")
roleLabel.Size = UDim2.new(0, 200, 0, 50)
roleLabel.Position = UDim2.new(0, 10, 0, 10)
roleLabel.Text = "Role: N/A"
roleLabel.Parent = gui

local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 200, 0, 50)
timeLabel.Position = UDim2.new(0, 10, 0, 70)
timeLabel.Text = "Time: 0"
timeLabel.Parent = gui

local healthLabel = Instance.new("TextLabel")
healthLabel.Size = UDim2.new(0, 200, 0, 50)
healthLabel.Position = UDim2.new(0, 10, 0, 130)
healthLabel.Text = "HP: 100"
healthLabel.Parent = gui

roleEvent.OnClientEvent:Connect(function(action, data)
    if action == "Role" then
        roleLabel.Text = "Role: " .. data
    elseif action == "GameOver" then
        timeLabel.Text = "Winner: " .. data
    end
end)

timerEvent.OnClientEvent:Connect(function(t)
    timeLabel.Text = string.format("Time: %d", t)
end)

local function onCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    healthLabel.Text = string.format("HP: %d", hum.Health)
    hum.HealthChanged:Connect(function(hp)
        healthLabel.Text = string.format("HP: %d", hp)
    end)
end

if player.Character then
    onCharacter(player.Character)
end
player.CharacterAdded:Connect(onCharacter)
