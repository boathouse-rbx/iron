local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Koute = require(ReplicatedStorage.Library.Koute)

local Route = Koute.Route
local Canvas = Koute.Canvas
local Router = Koute.Router

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

local InviteBar = require(script.InviteBar)
local InvitePanel = require(script.InvitePanel)
local MenuNavigator = require(script.MenuNavigator)

local Pages = script.Pages

local Play = require(Pages.Play)
local Multiplayer = require(Pages.Multiplayer)

function UIController:KnitStart()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

	local router = Router {
		[Children] = {
			Route "/" {
				View = function()
					return {
						InviteBar {},
						InvitePanel {},
						MenuNavigator {},
					}
				end
			},

			Route "/play" {
				View = function()
					return Play {}
				end
			},

			Route "/play/multiplayer" {
				View = function()
					return Multiplayer {}
				end
			},
		}
	}

	UIController.Router = router

	local screenGui = New "ScreenGui" {
		Parent = Knit.Player:WaitForChild("PlayerGui", math.huge),

		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 90,
		IgnoreGuiInset = true,
		Name = "iron-hub",

		[Children] = {
			Canvas {
				Source = router,
				postRender = function()
					print("test")
				end
			}
		}
	}
end

return UIController