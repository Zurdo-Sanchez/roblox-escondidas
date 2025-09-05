local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- RemoteEvent fired by the seeker client when shooting
local WeaponFire = Instance.new("RemoteEvent")
WeaponFire.Name = "WeaponFire"
WeaponFire.Parent = ReplicatedStorage

-- Simple weapon placed in ServerStorage. GameHandler gives it to the seeker.
local gun = Instance.new("Tool")
gun.Name = "SeekerGun"
gun.RequiresHandle = false
gun.Parent = ServerStorage

local DAMAGE = 25

WeaponFire.OnServerEvent:Connect(function(player, origin, direction)
    local seeker = ReplicatedStorage:WaitForChild("Seeker").Value
    if player ~= seeker then
        return
    end

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {player.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, direction * 500, params)
    if result then
        local model = result.Instance:FindFirstAncestorWhichIsA("Model")
        if model then
            local hum = model:FindFirstChildWhichIsA("Humanoid")
            if hum and model ~= player.Character then
                hum:TakeDamage(DAMAGE)
            end
        end
    end
end)
