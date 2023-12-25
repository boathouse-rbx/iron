--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)

local Logger = Knit.Logger
local Global = Knit.Global

local CharacterService = Knit.CreateService {
    Name = "CharacterService",
    Client = {},
}

local GROUND_SENSOR_SEARCH_DISTANCE_OFFSET = 0.5
local CLIMB_SENSOR_SEARCH_DISTANCE = 1.5

function CharacterService:ApplyPhysicsControllers(character: Model)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid and not HumanoidRootPart then return end

    humanoid.EvaluateStateMachine = false

    local ControllerManager = Instance.new("ControllerManager")
    ControllerManager.Parent = character
    ControllerManager.RootPart = HumanoidRootPart
    ControllerManager.FacingDirection = HumanoidRootPart.CFrame.LookVector

    local GroundController = Instance.new("GroundController")
    GroundController.Parent = ControllerManager
    GroundController.GroundOffset = humanoid.HipHeight

    local AirController = Instance.new("AirController")
    AirController.Parent = ControllerManager

    local ClimbController = Instance.new("ClimbController")
    ClimbController.Parent = ControllerManager

    local SwimController = Instance.new("SwimController")
    SwimController.Parent = ControllerManager

    local GroundSensor = Instance.new("ControllerPartSensor")
	GroundSensor.SensorMode = Enum.SensorMode.Floor
	GroundSensor.SearchDistance = GroundController.GroundOffset + GROUND_SENSOR_SEARCH_DISTANCE_OFFSET
	GroundSensor.Name = "GroundSensor"
    GroundSensor.Parent = HumanoidRootPart

    local ClimbSensor = Instance.new("ControllerPartSensor")
	ClimbSensor.SensorMode = Enum.SensorMode.Ladder
	ClimbSensor.SearchDistance = CLIMB_SENSOR_SEARCH_DISTANCE
	ClimbSensor.Name = "ClimbSensor"
    ClimbSensor.Parent = HumanoidRootPart

    local WaterSensor = Instance.new("BuoyancySensor")
    WaterSensor.Parent = HumanoidRootPart

    ControllerManager.ClimbSensor = ClimbSensor
    ControllerManager.GroundSensor = GroundSensor
end

function CharacterService:ApplyRig(character: Model, rig: Model)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid and humanoid.Health > 0 then return end

    for _, child in character:GetChildren() do
        if child:IsA("BasePart") then
            local rigMirroredPart = rig:FindFirstChild(child.Name)
            if not rigMirroredPart then continue end

            local clonedPart = rigMirroredPart:Clone()
            local bodyPart = Enum.BodyPartR15[child.Name]
            humanoid:ReplaceBodyPartR15(bodyPart, clonedPart)
        end
    end
end

function CharacterService:KnitStart()
    local function onPlayerAdded(player: Player)
        local function onCharacterAdded(character: Model)
            self:ApplyRig(character, ReplicatedStorage.Assets.Rigs.Male)
            self:ApplyPhysicsControllers(character)
        end

        player.CharacterAdded:Connect(onCharacterAdded)
    end

    for _, player in Players:GetPlayers() do
        onPlayerAdded(player)
    end

    Players.PlayerAdded:Connect(onPlayerAdded)
end

return CharacterService