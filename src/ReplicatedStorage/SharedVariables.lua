local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Name = "StartGame"
RemoteEvent.Parent = ReplicatedStorage

return {
    StartGame = RemoteEvent
}