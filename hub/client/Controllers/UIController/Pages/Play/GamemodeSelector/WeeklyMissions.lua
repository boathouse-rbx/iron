local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ColourUtils = require(ReplicatedStorage.Packages.ColourUtils)

local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween

local function WeeklyMissions(props)
    local UIController = Knit.GetController("UIController")
    local AudioController = Knit.GetController("AudioController")

    local backgroundColor3 = Value(UIController.Theme.colors.true_black)
    local backgroundTransparency = Value(0.45)

    local function toggleHoverAnimation(isHovering: boolean)
        AudioController:PlayUISound(UIController.Theme.sounds.hover)

        if isHovering then
            backgroundColor3:set(UIController.Theme.colors.true_white)
            backgroundTransparency:set(0)
        else
            backgroundColor3:set(UIController.Theme.colors.true_black)
            backgroundTransparency:set(0.45)
        end
    end

    local function onActivation()
        AudioController:PlayUISound(UIController.Theme.sounds.select)
        UIController.Router:go("/weekly-missions")
    end

    return New "Frame" {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.fromScale(0.905, 1),

        [Children] = {
            New "Frame" {
                BackgroundColor3 = Tween(backgroundColor3, UIController.Theme.animation_settings.hover_animation_info),
                BackgroundTransparency = Tween(backgroundTransparency, UIController.Theme.animation_settings.hover_animation_info),
                Size = UDim2.fromScale(0.55, 1),

                [Children] = {
                    New "ImageButton" {
                        Image = "rbxassetid://678720451",
                        Size = UDim2.fromScale(1, 0.99),
                    },

                    New "TextButton" {
                        Text = "",
                        Size = UDim2.fromScale(1, 1),
                        ZIndex = 2,
                        BackgroundTransparency = 1,

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
                        FontFace = Font.new(UIController.Theme.fonts.main_font),
                        Text = "TIDES OF WAR",
                        TextColor3 = UIController.Theme.colors.limited_orange,
                        TextScaled = true,
                        AnchorPoint = Vector2.new(0.5, 1),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(0.5, 0.75),
                        Size = UDim2.fromScale(1, 0.035),
                    },

                    New "TextLabel" {
                        FontFace = Font.new(UIController.Theme.fonts.main_font),
                        Text = "WEEKLY MISSIONS",
                        TextColor3 = UIController.Theme.colors.true_white,
                        TextScaled = true,
                        AnchorPoint = Vector2.new(0.5, 1),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(0.5, 0.825),
                        Size = UDim2.fromScale(1, 0.055),
                    },

                    New "TextLabel" {
                        FontFace = Font.new(UIController.Theme.fonts.main_font),
                        Text = "DEC 16 - DEC 23",
                        TextColor3 = UIController.Theme.colors.mid_grey,
                        TextScaled = true,
                        AnchorPoint = Vector2.new(0.5, 1),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(0.5, 0.885),
                        Size = UDim2.fromScale(1, 0.035),
                    },
                }
            },
        }
    }
end

return WeeklyMissions