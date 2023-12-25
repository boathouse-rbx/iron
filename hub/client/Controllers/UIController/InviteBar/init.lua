local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local ForPairs = Fusion.ForPairs

local InviteIcon = require(script.InviteIcon)
local ChatIcon = require(script.ChatIcon)
local InviteFriends = require(script.InviteFriends)
local Chat = require(script.Chat)

local MAX_SQUAD_SIZE = 4

local function InviteBar(props)
    local UIController = Knit.GetController("UIController")
    local SquadController = Knit.GetController("SquadController")

    local members = Value({nil, nil, nil})

    SquadController.SquadCreated:Connect(function(squad)
        members:set(squad.Members)
    end)

    SquadController.SquadChanged:Connect(function(newSquad)
        members:set(newSquad.Members)
    end)

    SquadController.SquadDisbanded:Connect(function()
        members:set({})
    end)

    return New "Frame" {
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.95, 0.95),
        Size = UDim2.fromScale(0.25, 0.06),

        [Children] = {
            InviteFriends {},
            Chat {},

            New "Frame" {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0.75, 1),

                [Children] = {
                    New "UIGridLayout" {
                        CellPadding = UDim2.fromScale(0.015, 0),
                        CellSize = UDim2.fromScale(0.185, 1),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                    },

                    InviteIcon {
                        UserId = Knit.Player.UserId,
                        LayoutOrder = 1,
                    },

                    InviteIcon {
                        LayoutOrder = 2,
                    },

                    InviteIcon {
                        LayoutOrder = 3,
                    },

                    InviteIcon {
                        LayoutOrder = 4,
                    },

                    ChatIcon {}
                }
            }
        }
    }
end

return InviteBar