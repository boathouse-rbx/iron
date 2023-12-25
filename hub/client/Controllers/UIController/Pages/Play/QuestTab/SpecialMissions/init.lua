local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween
local ForPairs = Fusion.ForPairs

local SpecialMission = require(script.SpecialMission)

local Missions = {
    [1] = {
        MissionsCompleted = 2,
        TotalMissions = 3,
    },

    [2] = {
        MissionsCompleted = 1,
        TotalMissions = 2,
    },

    [3] = {},
    [4] = {}
}

local function SpecialMissions(props)
    local UIController = Knit.GetController("UIController")

    return New "Frame" {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0.2, -1),

        [Children] = {
            New "UIGridLayout" {
                CellPadding = UDim2.new(0.02, -1, 0, 0),
                CellSize = UDim2.new(0.235, 1, 0.8, 0),
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
            },

            ForPairs(Missions, function(index, mission)
                local isEmpty = if mission.TotalMissions then false else true

                return index, SpecialMission {
                    MissionsCompleted = mission.MissionsCompleted or nil,
                    TotalMissions = mission.TotalMissions or nil,
                    Empty = isEmpty
                }
            end, Fusion.cleanup)
        }
    }
end

return SpecialMissions