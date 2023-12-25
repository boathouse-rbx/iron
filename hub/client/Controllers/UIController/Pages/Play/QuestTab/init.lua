local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween

local Divider = require(script.Divider)
local Mission = require(script.Mission)
local SpecialMissions = require(script.SpecialMissions)

local function QuestTab(props)
    local UIController = Knit.GetController("UIController")

    return New "Frame" {
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.95, 0.86),
        Size = UDim2.fromScale(0.21, 0.7),

        [Children] = {
            New "UIListLayout" {
                Padding = UDim.new(0.014, 3),
                SortOrder = Enum.SortOrder.LayoutOrder,
            },

            Divider {
                Text = "TIDES OF WAR",
                LineSizeX = 0.225
            },

            Mission {
                Title = "WARMUP",
                Description = "Suck ya dah 3 times."
            },

            Divider {
                Text = "DAILY QUESTS",
                LineSizeX = 0.225
            },

            Mission {
                Title = "KAMIKAZE",
                Description = "Go to the toilet after ya dad"
            },

            Mission {
                Title = "BANZAI",
                Description = "Go to Huddersfield"
            },

            Mission {
                Title = "THOUSAND YARD STARE",
                Description = "Revive 9 people"
            },

            Divider {
                Text = "SPECIAL MISSIONS",
                LineSizeX = 0.155
            },

            SpecialMissions {}
        }
    }
end

return QuestTab