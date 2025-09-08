local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local CamouflageEvent = ReplicatedStorage:WaitForChild("CamouflageEvent")

-- Simple GUI with a button that cycles through possible objects
local gui = Instance.new("ScreenGui")
gui.Name = "CamouflageGui"
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 1, -60)
button.Text = "Transform"
button.Parent = gui

local objects = {"Tree", "Chair", "Box"}
local index = 1

button.MouseButton1Click:Connect(function()
    local choice = objects[index]
    CamouflageEvent:FireServer(choice)
    index += 1
    if index > #objects then
        index = 1
    end
end)
