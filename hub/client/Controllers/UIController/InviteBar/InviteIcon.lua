local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ColourUtil = require(ReplicatedStorage.Packages.ColourUtils)

local Logger = Knit.Logger
local Player = Knit.Player

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Tween = Fusion.Tween

local function InviteIcon(props)
    local UIController = Knit.GetController("UIController")
    local SocialController = Knit.GetController("SocialController")
    local AudioController = Knit.GetController("AudioController")

    local isPlayer = Value(
        if props.UserId ~= nil then true else false
    )

    local thumbnail = Value("")
    local friends = Value({})

    local isInvitePanelOpen = Value(false)
    local backgroundColor = Value(UIController.Theme.colors.true_black)
    local plusColor = Value(UIController.Theme.colors.mid_grey)

    SocialController:GetOnlineFriends(Player)
        :andThen(function(friendsData)
            friends:set(friendsData)
        end)
        :catch(function(err)
            Logger:Warn("[SocialController] Failed to download friends! {:?}", err)
        end)

    UIController.Events.ToggleInvitePanel:Connect(function(open)
        isInvitePanelOpen:set(open)
    end)

    if isPlayer:get() then
        SocialController:GetPlayerThumbnail(
            props.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        ):andThen(function(result)
            thumbnail:set(result)
        end):catch(function(err)
            Logger:Warn("[UIController/InviteBar/InviteIcon] An error occurred whilst downloading {:?}'s thumbnail!", props.UserId, err)
        end)
    end

    local function toggleHoverAnimation(toggle: boolean)
        if isPlayer:get() then return end

        AudioController:PlayUISound(UIController.Theme.sounds.hover)

        if toggle then
            local lightened = ColourUtil.Lighten(UIController.Theme.colors.true_black, UIController.Theme.animation_settings.hover_colour_change_coefficient)
            local darkened = ColourUtil.Darken(UIController.Theme.colors.mid_grey, UIController.Theme.animation_settings.hover_colour_change_coefficient)
            plusColor:set(darkened)
            backgroundColor:set(lightened)
        else
            plusColor:set(UIController.Theme.colors.mid_grey)
            backgroundColor:set(UIController.Theme.colors.true_black)
        end
    end

    return New "Frame" {
        BackgroundColor3 = Tween(backgroundColor, UIController.Theme.animation_settings.hover_animation_info),
        BackgroundTransparency = 0.45,
        LayoutOrder = props.LayoutOrder,

        [Children] = {
            New "TextButton" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.Light,
                    Enum.FontStyle.Normal
                ),

                Text = "+",
                TextColor3 = Tween(plusColor, UIController.Theme.animation_settings.hover_animation_info),
                TextScaled = true,
                TextTransparency = 0.3,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),

                [OnEvent "Activated"] = function()
                    local isOpen = isInvitePanelOpen:get()
                    AudioController:PlayUISound(UIController.Theme.sounds.select)
                    UIController.Events.ToggleInvitePanel:Fire(not isOpen, friends:get())
                end,

                [OnEvent "MouseEnter"] = function()
                    toggleHoverAnimation(true)
                end,
                [OnEvent "MouseLeave"] = function()
                    toggleHoverAnimation(false)
                end,

                Visible = Computed(function()
                    return not isPlayer:get()
                end),
            },

            New "ImageLabel" {
                Size = UDim2.fromScale(1, 1),
                ZIndex = 2,
                BackgroundTransparency = 1,
                Image = thumbnail,
                Visible = isPlayer
            },

            New "UIAspectRatioConstraint" {}
        }
    }
end

return InviteIcon