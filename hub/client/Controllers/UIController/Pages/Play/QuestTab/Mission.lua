local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween

local function Mission(props)
    local UIController = Knit.GetController("UIController")

    return New "Frame" {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0.15),

        [Children] = {
            New "Frame" {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(0.75, 0.8),

                [Children] = {
                    New "UICorner" {
                        CornerRadius = UDim.new(1, 0),
                    },

                    New "UIAspectRatioConstraint" {},

                    New "UIStroke" {
                        Thickness = 3,
                        Transparency = 0.75,
                    },

                    New "ImageLabel" {
                        Image = "rbxassetid://13116032170",
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromScale(0.5, 0.5),
                    },
                }
            },

            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.SemiBold,
                    Enum.FontStyle.Normal
                ),

                Text = props.Title,
                TextColor3 = UIController.Theme.colors.true_white,
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.3, 0.3),
                Size = UDim2.fromScale(0.5, 0.3),
            },

            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.SemiBold,
                    Enum.FontStyle.Normal
                ),

                Text = props.Description,
                TextColor3 = UIController.Theme.colors.true_black,
                TextSize = 14,
                TextTransparency = 0.75,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.3, 0.6),
                Size = UDim2.fromScale(0.5, 0.3),
            },
        }
    }
end

return Mission