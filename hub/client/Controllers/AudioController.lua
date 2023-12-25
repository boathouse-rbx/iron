--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)

local Logger = Knit.Logger

local AudioController = Knit.CreateController {
    Name = "AudioController",
    SongFinished = Signal.new()
}

local SONGS = {
    "rbxassetid://1841703949",
    "rbxassetid://1841702352",
    "rbxassetid://1837935224",
    "rbxassetid://1846439917"
}

local SOUND_TRACK_VOLUME = 0.3

local RANDOM = Random.new(os.clock())

function AudioController:PlayUISound(id: string, volume: number?)
    local sound = Instance.new("Sound")
    sound.Parent = SoundService
    sound.PlayOnRemove = true
    sound.SoundId = id
    sound.Volume = volume or 0.5
    sound:Destroy()
end

function AudioController:PlaySoundtrack(id: string)
    local sound = Instance.new("Sound")
    sound.Parent = SoundService
    sound.PlayOnRemove = true
    sound.SoundId = id
    sound.Volume = SOUND_TRACK_VOLUME

    sound.Ended:Connect(function()
        AudioController.SongFinished:Fire(id)
    end)

    sound:Destroy()
end

function AudioController:PickRandomSong()
    local index = RANDOM:NextInteger(1, #SONGS)
    local id = SONGS[index]
    return id
end

function AudioController:KnitStart()
    local function playSong()
        local song = self:PickRandomSong()
        self:PlaySoundtrack(song)

        self.SongFinished:Connect(function(id)
            if id == song then
                playSong()
            end
        end)
    end

    playSong()
end

return AudioController