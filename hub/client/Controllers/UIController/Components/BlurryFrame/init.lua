local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children

local Neon = require(script.Neon)

local DepthOfField = Instance.new("DepthOfFieldEffect")
DepthOfField.Parent = Lighting
DepthOfField.FarIntensity = 0
DepthOfField.FocusDistance = 51.35
DepthOfField.InFocusRadius = 50
DepthOfField.NearIntensity = 1

-- TODO: make ya own optimised blurryframe component
local function BlurryFrame(props)
    local scope = nil

    local frame = New "Frame" {
        AnchorPoint = props.AnchorPoint,
        BackgroundTransparency = 1,
        Position = props.Position,
        Size = props.Size,

        [Children] = props[Children],
        [Cleanup] = function()
            Neon:UnbindFrame(scope)
        end
    }

    scope = frame

    task.defer(function()
        Neon:BindFrame(frame, {
            Transparency = 0.98,
            BrickColor = BrickColor.new("Dark grey metallic");
        })
    end)

    return frame
end

return BlurryFrame