local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween

local Gamemode = require(script.Gamemode)
local WeeklyMissions = require(script.WeeklyMissions)

local function GamemodeSelector(props)
    local UIController = Knit.GetController("UIController")

    return New "Frame" {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.05, 0.86),
        Size = UDim2.fromScale(0.685, 0.7),

        [Children] = {
            WeeklyMissions {},

            Gamemode {
                Title = "Multiplayer",
                Description = "16 - 64 Players",
                Position = UDim2.fromScale(0.507, 0),
                AnchorPoint = Vector2.new(0, 0),
                URL = "/play/multiplayer"
            },

            Gamemode {
                Title = "Community",
                Description = "[COMING SOON]",
                Position = UDim2.fromScale(1, 0),
                AnchorPoint = Vector2.new(1, 0),
                URL = "/play/community"
            }
        }
    }
end

return GamemodeSelector