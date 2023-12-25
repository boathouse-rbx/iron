local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local STAGING_GAME_ID = 0 -- todo
local DEVELOPMENT_GAME_ID = 0 -- todo

local function split(str: string): { string }
	local lines = {}

	for s in str:gmatch("[^\r\n]+") do
		table.insert(lines, s)
	end

	return lines
end

local BuildInfo = split(ReplicatedStorage.BuildInfo.Value)
local version, build = BuildInfo[1], BuildInfo[2]

local Game = {
	Environment = RunService:IsStudio() and "local"
		or (game.GameId == DEVELOPMENT_GAME_ID and "development")
		or (game.GameId == STAGING_GAME_ID and "staging")
		or "production",

	Name = "soccer-legends",
	Version = version,
	Build = build,
	ServerReadyFlag = "ServerReady",
}

return Game
