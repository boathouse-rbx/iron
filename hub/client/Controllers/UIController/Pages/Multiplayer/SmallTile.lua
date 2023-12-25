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
local OnEvent = Fusion.OnEvent

local GradientOverlay = require(script.Parent.GradientOverlay)

local function SmallTile(props)
    local UIController = Knit.GetController("UIController")
    local AudioController = Knit.GetController("AudioController")

    local frameBackgroundColor = Value(UIController.Theme.colors.true_black)
    local backgroundTransparency = Value(0.45)

    local function toggleHoverAnimation(toggle: boolean)
        AudioController:PlayUISound(UIController.Theme.sounds.hover)

        if toggle then
            local frameSelectedColor = ColourUtils.Lighten(UIController.Theme.colors.true_black, 1)
            frameBackgroundColor:set(frameSelectedColor)
            backgroundTransparency:set(0)
        else
            frameBackgroundColor:set(UIController.Theme.colors.true_black)
            backgroundTransparency:set(0.45)
        end
    end

    local function onActivation()
        AudioController:PlayUISound(UIController.Theme.sounds.select)
        UIController.Router:go(props.URL)
    end

    return {
        New "Frame" {
            AnchorPoint = props.AnchorPoint,
            BackgroundColor3 = frameBackgroundColor,
            BackgroundTransparency = backgroundTransparency,
            Position = props.Position,
            Size = UDim2.fromScale(0.495, 0.495),

            [Children] = {
                New "TextButton" {
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),

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

                New "ImageLabel" {
                    Image = props.Image,
                    BackgroundColor3 = UIController.Theme.colors.true_white,
                    Size = UDim2.fromScale(1, 0.975),
                    ScaleType = Enum.ScaleType.Crop,

                    [Children] = {
                        GradientOverlay {}
                    }
                },

                New "TextLabel" {
                    FontFace = Font.new(UIController.Theme.fonts.main_font),
                    Text = props.Tip,
                    TextColor3 = UIController.Theme.colors.true_white,
                    TextSize = 20,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.65),
                    Size = UDim2.fromScale(1, 0.075),
                },

                New "TextLabel" {
                    FontFace = Font.new(
                        UIController.Theme.fonts.main_font,
                        Enum.FontWeight.Medium,
                        Enum.FontStyle.Normal
                    ),

                    Text = props.Maps,
                    TextColor3 = UIController.Theme.colors.mid_grey,
                    TextSize = 20,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.875),
                    Size = UDim2.fromScale(1, 0.075),
                },

                New "TextLabel" {
                    FontFace = Font.new(
                        UIController.Theme.fonts.main_font,
                        Enum.FontWeight.SemiBold,
                        Enum.FontStyle.Normal
                    ),

                    Text = props.Title,
                    TextColor3 = UIController.Theme.colors.true_white,
                    TextSize = 30,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.765),
                    Size = UDim2.fromScale(1, 0.075),
                },
            }
        }
    }
end

return SmallTile