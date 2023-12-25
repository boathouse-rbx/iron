local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween

local function GradientOverlay(props)
    local UIController = Knit.GetController("UIController")

    return New "Frame" {
        Size = UDim2.fromScale(1, 1),

        [Children] = {
            New "UIGradient" {
                Rotation = -90,

                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, UIController.Theme.colors.deep_grey),
                    ColorSequenceKeypoint.new(0.025, UIController.Theme.colors.deep_grey),
                    ColorSequenceKeypoint.new(1, UIController.Theme.colors.true_white),
                }),

                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.00998, 0.0125),
                    NumberSequenceKeypoint.new(0.314, 0.5, 0.5),
                    NumberSequenceKeypoint.new(1, 1),
                }),
            }
        }
    }
end

return GradientOverlay