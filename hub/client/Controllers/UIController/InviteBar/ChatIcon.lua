local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ColourUtils = require(ReplicatedStorage.Packages.ColourUtils)

local Logger = Knit.Logger

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween
local OnEvent = Fusion.OnEvent

local BORDER_SIZE = 3

local function ChatIcon(props)
    local UIController = Knit.GetController("UIController")
    local AudioController = Knit.GetController("AudioController")

    local isOpen = false

    local backgroundColour = Value(UIController.Theme.colors.deep_grey)

    local function onActivation()
        isOpen = not isOpen
        AudioController:PlayUISound(UIController.Theme.sounds.select)
        UIController.Events.ToggleChat:Fire(isOpen)
    end

    local function toggleHoverAnimation(hovering: boolean)
        AudioController:PlayUISound(UIController.Theme.sounds.hover)

        if hovering then
            local lightened = ColourUtils.Lighten(UIController.Theme.colors.deep_grey, UIController.Theme.animation_settings.hover_colour_change_coefficient)
            backgroundColour:set(lightened)
        else
            backgroundColour:set(UIController.Theme.colors.deep_grey)
        end
    end

    return New "Frame" {
        BackgroundColor3 = Tween(backgroundColour, UIController.Theme.animation_settings.hover_animation_info),
        BackgroundTransparency = 0.45,
        LayoutOrder = 5,

        [Children] = {
            New "ImageButton" {
                Image = UIController.Theme.icons.chat_icon,
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.7, 0.7),

                [Children] = {
                    New "UIAspectRatioConstraint" {}
                }
            },

            New "TextButton" {
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),

                [OnEvent "Activated"] = function()
                    onActivation()
                end,

                [OnEvent "MouseEnter"] = function()
                    toggleHoverAnimation(true)
                end,

                [OnEvent "MouseLeave"] = function()
                    toggleHoverAnimation(false)
                end
            },

            New "UIAspectRatioConstraint" {}
        }
    }
end

return ChatIcon