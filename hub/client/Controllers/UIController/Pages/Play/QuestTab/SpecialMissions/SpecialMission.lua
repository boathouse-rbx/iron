local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ColourUtils = require(ReplicatedStorage.Packages.ColourUtils)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween
local ForValues = Fusion.ForValues
local OnEvent = Fusion.OnEvent

local function SpecialMission(props)
    local UIController = Knit.GetController("UIController")
    local AudioController = Knit.GetController("AudioController")

    local backgroundColor3 = Value(UIController.Theme.colors.true_black)
    local plusTextColor3 = Value(UIController.Theme.colors.mid_grey)

    local function toggleHoverAnimation(isHovering: boolean)
        AudioController:PlayUISound(UIController.Theme.sounds.hover)

        if isHovering then
            local darkened = ColourUtils.Darken(UIController.Theme.colors.mid_grey, UIController.Theme.animation_settings.hover_colour_change_coefficient)
            local lightened = ColourUtils.Lighten(UIController.Theme.colors.true_black, UIController.Theme.animation_settings.hover_colour_change_coefficient)
            plusTextColor3:set(darkened)
            backgroundColor3:set(lightened)
        else
            backgroundColor3:set(UIController.Theme.colors.true_black)
            plusTextColor3:set(UIController.Theme.colors.mid_grey)
        end
    end

    local function onActivation()
        AudioController:PlayUISound(UIController.Theme.sounds.select)
        UIController.Router:go("/missions")
    end

    return New "Frame" {
        BackgroundColor3 = Tween(backgroundColor3, UIController.Theme.animation_settings.hover_animation_info),
        BackgroundTransparency = 0.45,

        [Children] = {
            New "TextButton" {
                FontFace = Font.new(UIController.Theme.fonts.main_font),
                Text = "+",
                TextColor3 = plusTextColor3,
                TextSize = 35,
                TextTransparency = 0.45,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = props.Empty
            },

            New "TextButton" {
                Text = "",
                TextTransparency = 0.45,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 2,

                [OnEvent "MouseEnter"] = function()
                    toggleHoverAnimation(true)
                end,

                [OnEvent "MouseLeave"] = function()
                    toggleHoverAnimation(false)
                end,

                [OnEvent "Activated"] = function()
                    onActivation()
                end
            },

            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.SemiBold,
                    Enum.FontStyle.Normal
                ),

                Text = `{ props.MissionsCompleted } / { props.TotalMissions }`,
                TextColor3 = UIController.Theme.colors.true_white,
                TextSize = 14,
                TextYAlignment = Enum.TextYAlignment.Bottom,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0.9),
                Visible = not props.Empty
            },

            New "Frame" {
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.2),
                Size = UDim2.fromScale(0.5, 0.5),
                Visible = not props.Empty,

                [Children] = {
                    New "UIAspectRatioConstraint" {},

                    New "UICorner" {
                        CornerRadius = UDim.new(1, 0),
                    },

                    New "ImageLabel" {
                        Image = props.Icon,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromScale(0.7, 1),

                        [Children] = {
                            New "UIAspectRatioConstraint" {},
                        }
                    },

                    New "UIStroke" {
                        Color = UIController.Theme.colors.true_white,
                        Thickness = 3.9,

                        [Children] = {
                            New "UIGradient" {
                                Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                                    ColorSequenceKeypoint.new(0.804, Color3.fromRGB(255, 252, 251)),
                                    ColorSequenceKeypoint.new(0.81, Color3.fromRGB(220, 90, 46)),
                                    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 90, 46)),
                                }),

                                Rotation = -90,

                                Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0),
                                    NumberSequenceKeypoint.new(0.5, 0.75),
                                    NumberSequenceKeypoint.new(1, 0),
                                }),
                            },
                        }
                    },
                }
            },
        }
    }
end

return SpecialMission