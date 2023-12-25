local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Logger = Knit.Logger

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Computed = Fusion.Computed

local BlurryFrame = require(script.Parent.Components.BlurryFrame)

local SquadCreator = require(script.SquadCreator)
local FriendsList = require(script.FriendsList)

local OPEN_POSITION = UDim2.fromScale(0.95, 0.889)
local CLOSED_POSITION = UDim2.fromScale(1.5, 0.889)

local function InvitePanel(props)
    local UIController = Knit.GetController("UIController")

    local position = Value(CLOSED_POSITION)
    local friends = Value({})

    UIController.Events.ToggleInvitePanel:Connect(function(shouldBeOpen, friendsData)
        if friendsData then
            friends:set(friendsData)
        end

        if shouldBeOpen then
            position:set(OPEN_POSITION)
        else
            position:set(CLOSED_POSITION)
        end
    end)

    return New "Frame" {
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position = position,
        Size = UDim2.fromScale(0.25, 0.85),

        [Children] = {
            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.Medium,
                    Enum.FontStyle.Normal
                ),

                Text = "SOCIAL",
                TextColor3 = UIController.Theme.colors.true_white,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0.075),
            },

            SquadCreator {},

            FriendsList {
                Friends = friends,
            }
        }
    }
end

return InvitePanel