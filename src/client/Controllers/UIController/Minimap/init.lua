local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local ForValues = Fusion.ForValues
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Tween = Fusion.Tween

local Compass = require(script.Compass)

local function Minimap(props)
    local UIController = Knit.GetController("UIController")

    return New "Frame" {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.035, 0.965),
        Size = UDim2.fromScale(0.215, 0.215),

        [Children] = {
            New "UIAspectRatioConstraint" {},

            Compass {},

            New "Frame" {
                BackgroundColor3 = UIController.Theme.colors.true_black,
                BackgroundTransparency = 0.45,
                Size = UDim2.fromScale(1, 1),
            },
        }
    }
end

return Minimap