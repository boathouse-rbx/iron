local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Packages.Signal)

return {
    ToggleInvitePanel = Signal.new(),
    ToggleChat = Signal.new(),

    TogglePlay = Signal.new(),
}