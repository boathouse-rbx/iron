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
local GamemodeSelector = require(script.GamemodeSelector)
local QuestTab = require(script.QuestTab)

local function Play(props)
    local UIController = Knit.GetController("UIController")

    return {
        New "TextLabel" {
            FontFace = Font.new(
                UIController.Theme.fonts.main_font,
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),

            Text = "PLAY",
            TextColor3 = UIController.Theme.colors.true_white,
            TextScaled = true,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.05, 0.0875),
            Size = UDim2.fromScale(0.3, 0.065),
        },

        GamemodeSelector {},
        QuestTab {},

        ContextBar {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.55, 0.95),
            Actions = {
                {
                    Icon = "rbxassetid://247422429",
                    Name = "Back",
                    Key = Enum.KeyCode.LeftControl,

                    OnActivated = function()
                        UIController.Router:go("/")
                    end
                },
            },
        }
    }
end

return Play