local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ColourUtil = require(ReplicatedStorage.Packages.ColourUtils)

local Logger = Knit.Logger

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween
local OnEvent = Fusion.OnEvent

local function Friend(props)
    local UIController = Knit.GetController("UIController")
    local SocialController = Knit.GetController("SocialController")
    local AudioController = Knit.GetController("AudioController")

    local image = Value("")
    local buttonBackgroundColor = Value(UIController.Theme.colors.true_black)

    local function onInvitePressed()
        SocialController:PromptInviteToSquad(props.UserId)
        AudioController:PlayUISound(UIController.Theme.sounds.select)
    end

    local function toggleHoverAnimation(hovering: boolean)
        local frameSelectedColor = ColourUtil.Lighten(UIController.Theme.colors.true_black, UIController.Theme.animation_settings.hover_colour_change_coefficient)

        AudioController:PlayUISound(UIController.Theme.sounds.hover)

        if hovering then
            buttonBackgroundColor:set(frameSelectedColor)
        else
            buttonBackgroundColor:set(UIController.Theme.colors.true_black)
        end
    end

    SocialController:GetPlayerThumbnail(props.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        :andThen(function(url)
            image:set(url)
        end)
        :catch(function(err)
            Logger:Warn("[UIController/InvitePanel/Friend] Failed to retrieve thumbnail for {:?}, {:?}", props.UserId, err)
        end)

    return New "Frame" {
        BackgroundColor3 = UIController.Theme.colors.true_black,
        BackgroundTransparency = 0.45,

        [Children] = {
            New "TextButton" {
                FontFace = Font.new(UIController.Theme.fonts.main_font),
                Text = "+",
                TextColor3 = UIController.Theme.colors.true_white,
                TextSize = 30,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 =  Tween(buttonBackgroundColor, UIController.Theme.animation_settings.hover_animation_info),
                BackgroundTransparency = 0.45,
                Position = UDim2.new(1.09, -1, 0.5, 0),
                Size = UDim2.new(0.075, 0, 1, 0),

                [OnEvent "Activated"] = function()
                    onInvitePressed()
                end,

                [OnEvent "MouseEnter"] = function()
                    toggleHoverAnimation(true)
                end,

                [OnEvent "MouseLeave"] = function()
                    toggleHoverAnimation(false)
                end,
            },

            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.Medium,
                    Enum.FontStyle.Normal
                ),

                Text = props.DisplayName,
                TextColor3 = UIController.Theme.colors.true_white,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.165, 0.35),
                Size = UDim2.fromScale(0.7, 0.35),
            },

            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.Medium,
                    Enum.FontStyle.Normal
                ),

                Text = props.LocationTip,
                TextColor3 = props.LocationTipColor,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.165, 0.7),
                Size = UDim2.fromScale(0.7, 0.3),
            },

            New "ImageLabel" {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Image = image,

                [Children] = {
                    New "UIAspectRatioConstraint" {},
                }
            }
        }
    }
end

return Friend