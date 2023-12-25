--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)

local Logger = Knit.Logger

local ChatController = Knit.CreateController { Name = "ChatController" }

local CHANNELS = { "Squad" }

local activeChannel = CHANNELS[1]

function ChatController:SendMessage(message: string)
    print(message)
end

function ChatController:GetActiveChannel()
    return activeChannel
end

function ChatController:GetChannels()
    return CHANNELS
end

return ChatController