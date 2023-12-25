local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween

local function Divider(props)
    local UIController = Knit.GetController("UIController")

    return New "TextLabel" {
        FontFace = Font.new(UIController.Theme.fonts.main_font),
        Text = props.Text,
        TextColor3 = UIController.Theme.colors.true_white,
        TextScaled = true,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.fromScale(1, 0.035),

        [Children] = {
            New "Frame" {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = UIController.Theme.colors.true_white,
                BackgroundTransparency = 0.45,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(props.LineSizeX, 0, 0, 1),
            },

            New "Frame" {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = UIController.Theme.colors.true_white,
                BackgroundTransparency = 0.45,
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.new(props.LineSizeX, 0, 0, 1),
            },
        }
    }
end

return Divider