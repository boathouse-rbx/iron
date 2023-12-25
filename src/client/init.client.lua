local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local function startClient()
	local Knit = require(ReplicatedStorage.Packages.Knit)
	local recursive = require(ReplicatedStorage.Shared.knitLoader)(Knit)

	-- Client-side folder injection
	Knit.Modules = script.Modules

	-- Load controllers
	-- ⚠ This means that controllers will sometimes be required BEFORE the server
	--   is ready.
	recursive(script.Controllers, require)

	local loaded = Instance.new("BoolValue")
	loaded.Name = "KnitClientLoaded"
	loaded.Value = true
	loaded.Parent = ReplicatedStorage

	-- Wait for server before we start Knit.
	-- The 'math.huge' is to surpress 'Infinite yield possible' warnings.
	ReplicatedStorage:WaitForChild(Knit.Global.Game.ServerReadyFlag, math.huge)

	-- Start Knit
	Knit.Start()
		:andThen(function()
			Knit.Logger:Info(
				"[cmain] Client has started! Running version {:?} (build {}) in environment {:?}.",
				Knit.Global.Game.Version,
				Knit.Global.Game.Build,
				Knit.Global.Game.Environment
			)
		end)
		:catch(function(err)
			Knit.Logger:Warn("[cmain] A fatal error occurred while starting Knit: {:?}", err)

			-- Disconnnect client if the game won't load
			Players.LocalPlayer:Kick("A fatal error occurred while starting the game, please rejoin.")
		end)
end

startClient()
