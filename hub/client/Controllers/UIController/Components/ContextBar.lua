local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children
local ForValues = Fusion.ForValues
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Tween = Fusion.Tween

local PADDING_SPACE = 2
local PADDING = string.rep(" ", PADDING_SPACE)

local function abbreviateKeyName(name: string)
    return string.gsub(name, "Control", "Ctrl")
end

local function ContextBar(props)
    local UIController = Knit.GetController("UIController")
    local AudioController = Knit.GetController("AudioController")

    return New "Frame" {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0.035),
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        props[Cleanup],

        [Children] = {
            New "UIGridLayout" {
                CellPadding = UDim2.fromScale(0.05, 0),
                CellSize = UDim2.fromScale(0.11, 1),
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
            },

            ForValues(props.Actions, function(action)
                local backgroundTransparency = Value(1)
                local textColor3 = Value(UIController.Theme.colors.true_white)

                local text = `{ PADDING }{ action.Name } `
                local event = nil

                if action.Key then
                    local inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
                        if not gameProcessedEvent and input.KeyCode == action.Key then
                            action.OnActivated()
                        end
                    end)

                    text = text .. `[{ abbreviateKeyName(action.Key.Name) }]`
                end

                local function toggleHoverAnimation(isHovering: boolean)
                    AudioController:PlayUISound(UIController.Theme.sounds.hover)

                    if isHovering then
                        textColor3:set(UIController.Theme.colors.true_black)
                        backgroundTransparency:set(0)
                    else
                        textColor3:set(UIController.Theme.colors.true_white)
                        backgroundTransparency:set(1)
                    end
                end

                return New "Frame" {
                    BackgroundTransparency = 1,

                    [Cleanup] = { event },

                    [Children] = {
                        New "ImageButton" {
                            BackgroundColor3 = UIController.Theme.colors.true_white,
                            Size = UDim2.fromScale(1, 1),
                            Image = action.Icon,
                            ImageColor3 = UIController.Theme.colors.true_black,

                            [OnEvent "Activated"] = function()
                                AudioController:PlayUISound(UIController.Theme.sounds.select)
                                action.OnActivated()
                            end,

                            [OnEvent "MouseEnter"] = function()
                                toggleHoverAnimation(true)
                            end,

                            [OnEvent "MouseLeave"] = function()
                                toggleHoverAnimation(false)
                            end,

                            [Children] = {
                                New "UIAspectRatioConstraint" {},
                            }
                        },

                        New "TextButton" {
                            FontFace = Font.new(
                                UIController.Theme.fonts.main_font,
                                Enum.FontWeight.Bold,
                                Enum.FontStyle.Normal
                            ),

                            Text = text,
                            TextColor3 = textColor3,
                            TextSize = 16,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundTransparency = Tween(backgroundTransparency, UIController.Theme.animation_settings.hover_animation_info),
                            Position = UDim2.fromScale(0.2, 0.5),
                            Size = UDim2.fromScale(1, 1),

                            [OnEvent "MouseEnter"] = function()
                                toggleHoverAnimation(true)
                            end,

                            [OnEvent "MouseLeave"] = function()
                                toggleHoverAnimation(false)
                            end,

                            [OnEvent "Activated"] = function()
                                action.OnActivated()
                            end,
                        },
                    }
                }
            end, Fusion.cleanup),
        }
    }
end

return ContextBar