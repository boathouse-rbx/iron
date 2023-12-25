--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)

local Logger = Knit.Logger
local Player = Knit.Player

local SquadController = Knit.CreateController {
    Name = "SquadController",

    SquadCreated = Signal.new(),
    SquadChanged = Signal.new(),
    SquadDisbanded = Signal.new(),
}

local MAX_SQUAD_SIZE

local squad = {}

local function fillSquad(squadMembers)
    if #squadMembers < MAX_SQUAD_SIZE then
        local emptySlots = MAX_SQUAD_SIZE - #squadMembers

        for _ = 1, emptySlots do
            table.insert(squadMembers, {})
        end
    end
end

function SquadController:CreateSquad()
    local newSquad = {
        Leader = Knit.Player,
        Members = {1, 2, 3}
    }

    squad = newSquad
    self.SquadCreated:Fire(squad)
end

function SquadController:JoinSquad(userId: number)
    table.insert(squad.Members, userId)
    self.SquadChanged:Fire(squad)
end

function SquadController:LeaveSquad(userId: number)
    for index, id in squad.Members do
        if id == userId then
            table.remove(squad.Members, index)
        end
    end

    self.SquadChanged:Fire(squad)
end

function SquadController:InSquad()
    return squad.Leader and true
end

function SquadController:GetSquad()
    return squad
end

function SquadController:DisbandSquad()
    squad = {}
    self.SquadDisbanded:Fire()
end

return SquadController