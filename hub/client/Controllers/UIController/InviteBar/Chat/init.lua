local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Logger = Knit.Logger

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween
local OnEvent = Fusion.OnEvent

local ChatBar = require(script.ChatBar)

local CLOSED_POSITION = UDim2.fromScale(0, 1.25)
local OPEN_POSITION = UDim2.fromScale(0, 0)

local function Chat(props)
    local UIController = Knit.GetController("UIController")

    local chatListPosition = Value(CLOSED_POSITION)

    UIController.Events.ToggleChat:Connect(function(shouldBeOpen)
        local position = if shouldBeOpen then OPEN_POSITION else CLOSED_POSITION
        chatListPosition:set(position)
    end)

    UIController.Events.ToggleInvitePanel:Connect(function(shouldBeOpen)
        if not shouldBeOpen then
            chatListPosition:set(CLOSED_POSITION)
        end
    end)

    return New "Frame" {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Position = UDim2.new(0.5, 0, 0, -1),
        Size = UDim2.fromScale(1, 4),
        ZIndex = -1,

        [Children] = {
            ChatBar {},

            New "ScrollingFrame" {
                ScrollBarThickness = 6,
                BackgroundTransparency = 1,
                Position = Tween(chatListPosition, UIController.Theme.animation_settings.window_close_info),
                Size = UDim2.fromScale(1, 0.8),
            }
        }
    }
end

return Chat