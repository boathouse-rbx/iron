--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)

local Logger = Knit.Logger

local CameraController = Knit.CreateController { Name = "CameraController" }

function CameraController:KnitStart()
    print("hi")

    local m = Knit.Player:GetMouse()

    m.Button1Down:Connect(function()
        local s = Knit.GetService("FractureService")
        s:FracturePart(m.Target):await()
    end)
end

return CameraController