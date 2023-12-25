local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Logger = Knit.Logger

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Computed = Fusion.Computed
local ForValues = Fusion.ForValues

local Friend = require(script.Parent.Friend)

local function FriendsList(props)
    local UIController = Knit.GetController("UIController")

    return New "ScrollingFrame" {
        ScrollBarThickness = 6,
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, 0.345),
        Size = UDim2.fromScale(1, 0.655),

        [Children] = {
            New "UIGridLayout" {
                CellSize = UDim2.fromScale(0.895, 0.03),
            },

            ForValues(props.Friends, function(friend)
                return Friend {
                    UserId = friend.VisitorId,
                    DisplayName = friend.DisplayName,
                    LocationTip = friend.LocationTip,
                    LocationTipColor = friend.LocationColor,
                }
            end, Fusion.cleanup)
        }
    }
end

return FriendsList