local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ColourUtils = require(ReplicatedStorage.Packages.ColourUtils)

local Logger = Knit.Logger

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween
local ForValues = Fusion.ForValues
local OnEvent = Fusion.OnEvent

local BUTTONS = { "Play", "Loadout", "Store", "Missions", "Profile", "Settings" }

local function MenuNavigator(props)
    local UIController = Knit.GetController("UIController")
    local AudioController = Knit.GetController("AudioController")

    return New "Frame" {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.05, 0.5),
        Size = UDim2.fromScale(0.25, 0.4),

        [Children] = {
            New "UIListLayout" {
                Name = "UIListLayout",
                Padding = UDim.new(0.025, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
            },

            ForValues(BUTTONS, function(button)
                local textColor3 = Value(UIController.Theme.colors.true_white)
                local backgroundTransparency = Value(1)

                local function toggleHoverAnimation(isHovering: boolean)
                    AudioController:PlayUISound(UIController.Theme.sounds.hover)

                    if isHovering then
                        local inverted = ColourUtils.Invert(UIController.Theme.colors.true_white)
                        textColor3:set(inverted)
                        backgroundTransparency:set(0)
                    else
                        textColor3:set(UIController.Theme.colors.true_white)
                        backgroundTransparency:set(1)
                    end
                end

                local function onActivation(name: string)
                    AudioController:PlayUISound(UIController.Theme.sounds.select)

                    local lowered = string.lower(name)
                    UIController.Router:go("/" .. lowered)
                end

                return New "TextButton" {
                    FontFace = Font.new(
                        UIController.Theme.fonts.main_font,
                        Enum.FontWeight.SemiBold,
                        Enum.FontStyle.Normal
                    ),

                    Text = string.upper(button),
                    TextColor3 = textColor3,
                    TextSize = 30,
                    BackgroundColor3 = UIController.Theme.colors.true_white,
                    BackgroundTransparency = Tween(backgroundTransparency, UIController.Theme.animation_settings.hover_animation_info),
                    Size = UDim2.fromScale(0.5, 0.15),

                    [OnEvent "MouseEnter"] = function()
                        toggleHoverAnimation(true)
                    end,

                    [OnEvent "MouseLeave"] = function()
                        toggleHoverAnimation(false)
                    end,

                    [OnEvent "Activated"] = function()
                        onActivation(button)
                    end
                }
            end, Fusion.cleanup)
        }
    }
end

return MenuNavigator