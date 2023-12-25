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

local function InviteFriends(props)
    local UIController = Knit.GetController("UIController")
    local SocialController = Knit.GetController("SocialController")
    local AudioController = Knit.GetController("AudioController")

    local friends = Value({})
    local isInvitePanelOpen = Value(false)
    local frameBackgroundColor = Value(UIController.Theme.colors.true_black)

    UIController.Events.ToggleInvitePanel:Connect(function(open)
        UIController.Events.ToggleChat:Fire(false)
        isInvitePanelOpen:set(open)
    end)

    SocialController:GetOnlineFriends(Player)
        :andThen(function(friendsData)
            friends:set(friendsData)
        end)
        :catch(function(err)
            Logger:Warn("[SocialController] Failed to download friends! {:?}", err)
        end)

    local function toggleHoverAnimation(toggle: boolean)
        local frameSelectedColor = ColourUtil.Lighten(UIController.Theme.colors.true_black, UIController.Theme.animation_settings.hover_colour_change_coefficient)

        AudioController:PlayUISound(UIController.Theme.sounds.hover)

        if toggle then
            frameBackgroundColor:set(frameSelectedColor)
        else
            frameBackgroundColor:set(UIController.Theme.colors.true_black)
        end
    end

    return New "Frame" {
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Tween(frameBackgroundColor, UIController.Theme.animation_settings.hover_animation_info),
        BackgroundTransparency = 0.45,
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromScale(0.25, 0.925),

        [Children] = {
            New "ImageLabel" {
                Image = UIController.Theme.icons.friends_icon,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.3, 0.5),
                Size = UDim2.fromScale(1, 0.5),

                [Children] = {
                    New "UIAspectRatioConstraint" {},
                }
            },

            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.SemiBold,
                    Enum.FontStyle.Normal
                ),

                Text = Computed(function()
                    return #friends:get()
                end),

                TextColor3 = UIController.Theme.colors.true_white,
                TextScaled = true,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.new(0.7, 0, 0.5, -3),
            },

            New "TextButton" {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",

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
            }
        }
    }
end

return InviteFriends