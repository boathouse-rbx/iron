local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ColourUtil = require(ReplicatedStorage.Packages.ColourUtils)

local Logger = Knit.Logger

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween
local OnEvent = Fusion.OnEvent

local isInSquad = false

local function SquadCreator(props)
    local UIController = Knit.GetController("UIController")
    local SquadController = Knit.GetController("SquadController")
    local AudioController = Knit.GetController("AudioController")

    local buttonBackgroundColor = Value(UIController.Theme.colors.true_black)
    local text = Value("CREATE SQUAD")

    local function toggleHoverAnimation(hovering: boolean)
        local frameSelectedColor = ColourUtil.Lighten(UIController.Theme.colors.true_black, UIController.Theme.animation_settings.hover_colour_change_coefficient)

        AudioController:PlayUISound(UIController.Theme.sounds.hover)

        if hovering then
            buttonBackgroundColor:set(frameSelectedColor)
        else
            buttonBackgroundColor:set(UIController.Theme.colors.true_black)
        end
    end

    local function onActivation()
        isInSquad = not isInSquad

        AudioController:PlayUISound(UIController.Theme.sounds.select)

        if isInSquad then
            text:set("DISBAND SQUAD")
        else
            text:set("CREATE SQUAD")
        end
    end

    return New "Frame" {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, 0.1),
        Size = UDim2.fromScale(1, 0.3),

        [Children] = {
            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.Medium,
                    Enum.FontStyle.Normal
                ),

                Text = "Squad",
                TextColor3 = UIController.Theme.colors.true_white,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0.15),
            },

            New "TextButton" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.SemiBold,
                    Enum.FontStyle.Normal
                ),

                Text = text,
                TextColor3 = UIController.Theme.colors.true_white,
                BackgroundColor3 = buttonBackgroundColor,
                BackgroundTransparency = 0.45,
                Position = UDim2.fromScale(0, 0.325),
                Size = UDim2.fromScale(1, 0.225),

                [OnEvent "Activated"] = function()
                    onActivation()
                end,

                [OnEvent "MouseEnter"] = function()
                    toggleHoverAnimation(true)
                end,

                [OnEvent "MouseLeave"] = function()
                    toggleHoverAnimation(false)
                end,

                [Children] = {
                    New "UITextSizeConstraint" {
                        MinTextSize = 15,
                        MaxTextSize = 20,
                    }
                }
            },

            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.Medium,
                    Enum.FontStyle.Normal
                ),
                Text = "A group of 1-4 players. The leader has the ability to issue orders and call reinforcements.",
                TextColor3 = UIController.Theme.colors.lighter_grey,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTransparency = 0.2,
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 0.567),
                Size = UDim2.fromScale(1, 0.2),
            }
        }
    }
end

return SquadCreator