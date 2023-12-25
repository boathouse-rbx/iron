local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Shared = Knit.Shared
local Library = Knit.Library
local Global = Knit.Global
local Logger = Knit.Logger
local Player = Knit.Player

local New = Fusion.New
local Children = Fusion.Children

local UIController = Knit.CreateController({
	Name = "UIController",
	Theme = require(script.Util.theme),
	Events = require(script.Util.events)
})

local Minimap = require(script.Minimap)

function UIController:KnitStart()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

	local screenGui = New "ScreenGui" {
		Parent = Knit.Player:WaitForChild("PlayerGui", math.huge),

		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 90,
		IgnoreGuiInset = true,
		Name = "iron",

		[Children] = {
			Minimap {}
		}
	}
end

return UIController