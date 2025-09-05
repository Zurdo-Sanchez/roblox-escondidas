local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local Shared = require(ReplicatedStorage:WaitForChild("SharedVariables"))

local ROUND_TIME = 180 -- 3 minutos

local function assignRoles()
	for _, player in ipairs(Players:GetPlayers()) do
		player:LoadCharacter()
	end

	wait(1)

	local seeker = Players:GetPlayers()[1]
	seeker.Team = Teams:FindFirstChild("Seeker")

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= seeker then
			player.Team = Teams:FindFirstChild("Hider")
		end
	end

	print("Roles asignados. ¡Comienza la partida!")
end

local function startTimer()
	local timeLeft = ROUND_TIME
	while timeLeft > 0 do
		wait(1)
		timeLeft -= 1
		print("Tiempo restante:", timeLeft)
	end

	print("¡Tiempo agotado! Fin de la partida.")
end

Shared.StartGame.OnServerEvent:Connect(function()
	assignRoles()
	startTimer()
end)