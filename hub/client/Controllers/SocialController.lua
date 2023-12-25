--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local Logger = Knit.Logger
local Shared = Knit.Shared
local Player = Knit.Player

local makeEnum = require(Shared.makeEnum)

local SocialController = Knit.CreateController {
    Name = "SocialController",

    OnlineTypes = makeEnum("OnlineTypes", {
        "MobileWebsite",
        "MobileInGame",
        "Webpage",
        "Studio",
        "InGame",
        "Xbox",
        "TeamCreate"
    })
}

local ONLINE_TYPE_MAPS = {
    [0] = SocialController.OnlineTypes.MobileWebsite,
    [1] = SocialController.OnlineTypes.MobileInGame,
    [2] = SocialController.OnlineTypes.Webpage,
    [3] = SocialController.OnlineTypes.Studio,
    [4] = SocialController.OnlineTypes.InGame,
    [5] = SocialController.OnlineTypes.Xbox,
    [6] = SocialController.OnlineTypes.TeamCreate
}

local ONLINE_TYPE_TIPS = {
    [SocialController.OnlineTypes.MobileWebsite] = "On app",
    [SocialController.OnlineTypes.MobileInGame] = "In game",
    [SocialController.OnlineTypes.Webpage] = "On website",
    [SocialController.OnlineTypes.Studio] = "In Studio",
    [SocialController.OnlineTypes.InGame] = "In game",
    [SocialController.OnlineTypes.Xbox] = "On Xbox",
    [SocialController.OnlineTypes.TeamCreate] = "On Team Create"
}

local PRIORITY_LIST = {
    [1] = { ONLINE_TYPE_MAPS[4], ONLINE_TYPE_MAPS[1] },
    [2] = { ONLINE_TYPE_MAPS[0], ONLINE_TYPE_MAPS[2], ONLINE_TYPE_MAPS[5] },
    [3] = { ONLINE_TYPE_MAPS[3], ONLINE_TYPE_MAPS[6] }
}

function SocialController:KnitInit()
    self.UIController = Knit.GetController("UIController")
end

function SocialController:GetPlayerThumbnail(userId: number, thumbnailType: Enum.ThumbnailType, thumbnailSize: Enum.ThumbnailSize)
    return Promise.new(function(resolve, reject)
        local success, result = pcall(function()
            return Players:GetUserThumbnailAsync(userId, thumbnailType, thumbnailSize)
        end)

        if success then
            resolve(result)
        else
            reject(result)
        end
    end)
end

function SocialController:GetOnlineFriends(player: Player)
    local ONLINE_TYPE_TIP_COLORS = {
        ["On app"] = self.UIController.Theme.colors.online_blue,
        ["In game"] = self.UIController.Theme.colors.in_game_green,
        ["On website"] = self.UIController.Theme.colors.online_blue,
        ["In Studio"] = self.UIController.Theme.colors.studio_orange,
        ["On Xbox"] = self.UIController.Theme.colors.in_game_green,
        ["On Team Create"] = self.UIController.Theme.colors.studio_orange
    }

    local function getOnlineFriends()
        return Promise.new(function(resolve, reject)
            local success, result = pcall(function()
                return player:GetFriendsOnline()
            end)

            if success then
                resolve(result)
            else
                reject(result)
            end
        end)
    end

    return Promise.new(function(resolve, reject)
        getOnlineFriends()
            :andThen(function(rawFriendsData)
                local friends = TableUtil.Copy(rawFriendsData, true)

                for _, friend in friends do
                    local locationType = ONLINE_TYPE_MAPS[friend.LocationType]
                    local locationTip = ONLINE_TYPE_TIPS[locationType]
                    local locationColor = ONLINE_TYPE_TIP_COLORS[locationTip]

                    friend.LocationId = friend.LocationType
                    friend.LocationType = locationType
                    friend.LocationTip = locationTip
                    friend.LocationColor = locationColor
                end

                table.sort(friends, function(a, b)
                    local aPriority = nil
                    local bPriority = nil

                    for aIndex, aPrioritySublist in PRIORITY_LIST do
                        if table.find(aPrioritySublist, a.LocationType) then
                            aPriority = aIndex
                        end
                    end

                    for bIndex, bPrioritySublist in PRIORITY_LIST do
                        if table.find(bPrioritySublist, b.LocationType) then
                            bPriority = bIndex
                        end
                    end

                    return aPriority < bPriority
                end)

                resolve(friends)
            end)
            :catch(function(err)
                Logger:Warn("[SocialController] Failed to download friends for {:?}: {:?}", player, err)
                reject(err)
            end)
    end)
end

function SocialController:GetNameFromUserId(userId: number)
    return Promise.new(function(resolve, reject)
        local success, result = pcall(function()
            return Players:GetNameFromUserIdAsync(userId)
        end)

        if success then
            resolve(result)
        else
            reject(result)
        end
    end)
end

function SocialController:PromptInviteToSquad(userId: number)
    local inviteOptions = Instance.new("ExperienceInviteOptions")
    inviteOptions.InviteUser = userId

    self:GetNameFromUserId(userId)
        :andThen(function(name)
            inviteOptions.PromptMessage = `Invite { name } to your squad?`
        end)
        :catch(function(err)
            inviteOptions.PromptMessage = `Are you sure?`
            Logger:Warn("[SocialController] Failed to download {:?} name, {:?}", userId, err)
        end)

    SocialService:PromptGameInvite(Player, inviteOptions)
end

return SocialController