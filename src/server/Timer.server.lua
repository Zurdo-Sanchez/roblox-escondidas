local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent used to update clients with the remaining time
local TimerEvent = ReplicatedStorage:WaitForChild("TimerEvent")

-- Expose a global function that other scripts can call to start the countdown
_G.StartTimer = function(duration, finishedCallback)
    coroutine.wrap(function()
        for i = duration, 0, -1 do
            TimerEvent:FireAllClients(i)
            task.wait(1)
        end
        if finishedCallback then
            finishedCallback()
        end
    end)()
end
