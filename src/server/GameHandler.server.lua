local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Remote events shared with clients
local RoleEvent = Instance.new("RemoteEvent")
RoleEvent.Name = "RoleEvent"
RoleEvent.Parent = ReplicatedStorage

local CamouflageEvent = Instance.new("RemoteEvent")
CamouflageEvent.Name = "CamouflageEvent"
CamouflageEvent.Parent = ReplicatedStorage

local TimerEvent = Instance.new("RemoteEvent")
TimerEvent.Name = "TimerEvent"
TimerEvent.Parent = ReplicatedStorage

-- Stores the current seeker so that other scripts can read it
local SeekerValue = Instance.new("ObjectValue")
SeekerValue.Name = "Seeker"
SeekerValue.Parent = ReplicatedStorage

-- Flag indicating if a match is currently running
local GameActive = Instance.new("BoolValue")
GameActive.Name = "GameActive"
GameActive.Value = false
GameActive.Parent = ReplicatedStorage

-- Table holding all players that are hiders
local Hiders = {}

local MATCH_TIME = 180 -- 3 minute default
local PREP_TIME = 15
local preGameRunning = false
local startPreGame

local function assignRoles()
    local players = Players:GetPlayers()
    if #players < 2 then
        return
    end

    table.clear(Hiders)
    for _, plr in ipairs(players) do
        table.insert(Hiders, plr)
    end

    local seeker = Hiders[math.random(1, #Hiders)]
    SeekerValue.Value = seeker

    for _, plr in ipairs(Hiders) do
        if plr == seeker then
            RoleEvent:FireClient(plr, "Role", "Seeker")
        else
            RoleEvent:FireClient(plr, "Role", "Hider")
        end
    end

    GameActive.Value = true

    -- start the round timer
    if _G.StartTimer then
        _G.StartTimer(MATCH_TIME, function()
            if GameActive.Value then
                GameActive.Value = false
                RoleEvent:FireAllClients("GameOver", "Hiders")
                startPreGame()
            end
        end)
    end
end

startPreGame = function()
    if preGameRunning or GameActive.Value then
        return
    end
    preGameRunning = true
    if _G.StartTimer then
        _G.StartTimer(PREP_TIME, function()
            preGameRunning = false
            assignRoles()
        end)
    else
        preGameRunning = false
        assignRoles()
    end
end

local function handleCharacter(plr, char)
    local humanoid = char:WaitForChild("Humanoid")
    if plr ~= SeekerValue.Value then
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    else
        local gun = ServerStorage:FindFirstChild("SeekerGun")
        if gun then
            gun:Clone().Parent = plr.Backpack
        end
    end

    humanoid.Died:Connect(function()
        if GameActive.Value then
            local alive = 0
            for _, hider in ipairs(Hiders) do
                local hc = hider.Character
                local hhum = hc and hc:FindFirstChild("Humanoid")
                if hider ~= SeekerValue.Value and hhum and hhum.Health > 0 then
                    alive += 1
                end
            end
            if alive == 0 then
                GameActive.Value = false
                RoleEvent:FireAllClients("GameOver", "Seeker")
                startPreGame()
            end
        end
    end)
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        handleCharacter(plr, char)
    end)
end)

CamouflageEvent.OnServerEvent:Connect(function(plr, modelName)
    local folder = ServerStorage:FindFirstChild("CamouflageObjects")
    local model = folder and folder:FindFirstChild(modelName)
    if model and plr.Character then
        if plr.Character:FindFirstChild("CamouflageModel") then
            plr.Character.CamouflageModel:Destroy()
        end
        local clone = model:Clone()
        clone.Name = "CamouflageModel"
        clone.Parent = plr.Character
        for _, part in ipairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Parent ~= clone then
                part.Transparency = 1
                if part:FindFirstChild("face") then
                    part.face.Transparency = 1
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function()
    if not GameActive.Value and #Players:GetPlayers() >= 2 then
        startPreGame()
    end
end)
