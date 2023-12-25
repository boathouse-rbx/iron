local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween

local ContextBar = require(script.Parent.Parent.Components.ContextBar)

local BigTile = require(script.BigTile)
local SmallTile = require(script.SmallTile)

local function Play(props)
    local UIController = Knit.GetController("UIController")

    return {
        New "TextLabel" {
            FontFace = Font.new(
                UIController.Theme.fonts.main_font,
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),

            Text = "MULTIPLAYER",
            TextColor3 = UIController.Theme.colors.true_white,
            TextScaled = true,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.05, 0.0875),
            Size = UDim2.fromScale(0.3, 0.065),
        },

        New "Frame" {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.05, 0.515),
            Size = UDim2.fromScale(0.9, 0.7),

            [Children] = {
                BigTile {
                    Tip = "PLAY RECOMMENDED",
                    Title = "TACTICAL CONQUEST",
                    Image = "rbxassetid://1257004287",
                    Maps = "Map A, Map B + 7",
                    URL = "/play/multiplayer/tactical-conquest"
                },

                SmallTile {
                    Tip = "PLAY RECOMMENDED",
                    Title = "STRATEGIC CONQUEST",
                    Image = "rbxassetid://1257004287",
                    Maps = "Map C, Map D + 2",
                    URL = "/play/multiplayer/strategic-conquest",

                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.fromScale(1, 0)
                },

                SmallTile {
                    Tip = "TRENDING",
                    Title = "TEAM DEATHMATCH",
                    Image = "rbxassetid://1257004287",
                    Maps = "Map E, Map F + 1",
                    URL = "/play/multiplayer/team-deathmatch",

                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.fromScale(1, 1)
                },
            }
        },

        ContextBar {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.55, 0.95),
            Actions = {
                {
                    Icon = "rbxassetid://247422429",
                    Name = "Back",
                    Key = Enum.KeyCode.LeftControl,

                    OnActivated = function()
                        UIController.Router:go("/play")
                    end
                },
            },
        }
    }
end

return Play