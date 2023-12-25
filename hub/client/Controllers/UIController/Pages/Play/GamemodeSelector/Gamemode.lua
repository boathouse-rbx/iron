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

local function Gamemode(props)
    local UIController = Knit.GetController("UIController")
    local AudioController = Knit.GetController("AudioController")

    local backgroundColor3 = Value(UIController.Theme.colors.true_black)
    local descriptionColor3 = Value(UIController.Theme.colors.mid_grey)

    local function toggleHoverAnimation(isHovering: boolean)
        AudioController:PlayUISound(UIController.Theme.sounds.hover)

        if isHovering then
            local darkened = ColourUtils.Darken(UIController.Theme.colors.mid_grey, UIController.Theme.animation_settings.hover_colour_change_coefficient)
            local lightened = ColourUtils.Lighten(UIController.Theme.colors.true_black, UIController.Theme.animation_settings.hover_colour_change_coefficient)
            descriptionColor3:set(darkened)
            backgroundColor3:set(lightened)
        else
            descriptionColor3:set(UIController.Theme.colors.mid_grey)
            backgroundColor3:set(UIController.Theme.colors.true_black)
        end
    end

    local function onActivation()
        AudioController:PlayUISound(UIController.Theme.sounds.select)
        UIController.Router:go(props.URL)
    end

    return New "Frame" {
        BackgroundColor3 = Tween(backgroundColor3, UIController.Theme.animation_settings.hover_animation_info),
        BackgroundTransparency = 0.45,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        Size = UDim2.fromScale(0.243, 1),

        [Children] = {
            New "TextLabel" {
                FontFace = Font.new(UIController.Theme.fonts.main_font),
                Text = props.Title,
                TextColor3 = UIController.Theme.colors.true_white,
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.825),
                Size = UDim2.fromScale(1, 0.055),
            },

            New "TextLabel" {
                FontFace = Font.new(UIController.Theme.fonts.main_font),
                Text = props.Description,
                TextColor3 = Tween(descriptionColor3, UIController.Theme.animation_settings.hover_animation_info),
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.885),
                Size = UDim2.fromScale(1, 0.035),
            },

            New "TextButton" {
                Size =  UDim2.fromScale(1, 1),
                Text = "",
                BackgroundTransparency = 1,
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
            }
        }
    }
end

return Gamemode