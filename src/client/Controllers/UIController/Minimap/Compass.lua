local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Tween = Fusion.Tween
local Out = Fusion.Out

local DIRECTIONS = {
    "N",
    "NE",
    "E",
    "SE",
    "S",
    "SW",
    "W",
    "NW",
}

local EMPTY_UDIM = UDim2.new()
local EMPTY_VECTOR2 = Vector2.new()

local function Compass(props)
    local UIController = Knit.GetController("UIController")

    local canvasSize = Value(EMPTY_UDIM)
    local canvasPosition = Value(EMPTY_VECTOR2)
    local absoluteSize = Value(EMPTY_VECTOR2)

    return New "Frame" {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = UIController.Theme.colors.true_black,
        BackgroundTransparency = 0.45,
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromScale(1, 0.1),

        [Children] = {
            New "ScrollingFrame" {
                CanvasSize = canvasSize,
                ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.X,
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.fromScale(1, 1),

                [Out "AbsoluteSize"] = absoluteSize,

                [Children] = {
                    ForPairs(DIRECTIONS, function(index, value)
                        local currentAbsoluteSize = absoluteSize:get()
                        local xCanvasSize = currentAbsoluteSize.X * 5
                        local inclination = (xCanvasSize * (#DIRECTIONS / 2)) / 360
                        local xOffset = 45 * (index - 1) * inclination
                        local newCanvasSize = UDim2.new(0, xCanvasSize, 0, 0)

                        canvasSize:set(newCanvasSize)

                        return index, New "TextLabel" {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Size = UDim2.fromScale(0.1, 1),
                            BackgroundTransparency = 1,
                            Text = value,
                            Position = UDim2.new(0, xOffset, 0.5, 0)
                        }
                    end)
                }
            }
        }
    }
end

return Compass