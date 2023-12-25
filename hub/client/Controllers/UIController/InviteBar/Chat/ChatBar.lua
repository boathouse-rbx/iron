local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Logger = Knit.Logger

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Tween = Fusion.Tween
local OnEvent = Fusion.OnEvent
local Ref = Fusion.Ref
local Out = Fusion.Out

local FOCUSED_BORDER_SIZE = 3 -- how large to make the border when the textbox is focused

local CLOSED_POSITION = UDim2.fromScale(0.5, 1.25)
local OPEN_POSITION = UDim2.fromScale(0.5, 1)

local UNFOCUSED_TEXTBOX_SIZE = UDim2.fromScale(0.95, 1)
local FOCUSED_TEXTBOX_SIZE = UDim2.fromScale(0.765, 1)

local PLACEHOLDER_TEXT = "PRESS \"/\" TO CHAT"

local SEND_MESSAGE_ACTION_NAME = "SEND_MESSAGE"
local CAPTURE_TEXTBOX_ACTION_NAME = "CAPTURE_TEXTBOX"

local function ChatBar(props)
    local UIController = Knit.GetController("UIController")
    local ChatController = Knit.GetController("ChatController")

    local isOpen = Value(false)
    local position = Value(CLOSED_POSITION)
    local borderSize = Value(0)
    local textbox = Value(nil)
    local textBoxSize = Value(UNFOCUSED_TEXTBOX_SIZE)
    local isChannelInfoVisible = Value(false)
    local text = Value("")
    local channel = Value("")
    local isFocused = Value(false)

    local activeChannel = ChatController:GetActiveChannel()
    channel:set(`[{ string.upper(activeChannel) }]:`)

    local function toggleFocus(isFocusing: boolean)
        local newBorderSize = if isFocusing then FOCUSED_BORDER_SIZE else 0
        local newTextBoxSize = if isFocusing then FOCUSED_TEXTBOX_SIZE else UNFOCUSED_TEXTBOX_SIZE
        borderSize:set(newBorderSize)
        textBoxSize:set(newTextBoxSize)
        isChannelInfoVisible:set(isFocusing)
        isFocused:set(isFocusing)
    end

    local function captureTextbox(actionName: string, inputState: Enum.UserInputState)
        if actionName == CAPTURE_TEXTBOX_ACTION_NAME and inputState == Enum.UserInputState.End then
            if not isOpen:get() then return Enum.ContextActionResult.Pass end

            textbox:get():CaptureFocus()
            isFocused:set(true)
            return Enum.ContextActionResult.Pass
        end
    end

    local function sendMessage(actionName: string, inputState: Enum.UserInputState)
        
    end

    UIController.Events.ToggleChat:Connect(function(shouldBeOpen)
        local newPosition = if shouldBeOpen then OPEN_POSITION else CLOSED_POSITION
        position:set(newPosition)
        isOpen:set(shouldBeOpen)
    end)

    ContextActionService:BindAction(SEND_MESSAGE_ACTION_NAME, sendMessage, false, Enum.KeyCode.Return)
    ContextActionService:BindAction(CAPTURE_TEXTBOX_ACTION_NAME, captureTextbox, false, Enum.KeyCode.Slash)

    return New "Frame" {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.45,
        BorderColor3 = UIController.Theme.colors.squad_green,
        BorderMode = Enum.BorderMode.Inset,
        BorderSizePixel = borderSize,
        Position = Tween(position, UIController.Theme.animation_settings.window_close_info),
        Size = UDim2.fromScale(1, 0.2),

        [Children] = {
            New "TextLabel" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.Bold,
                    Enum.FontStyle.Normal
                ),

                Text = channel,
                TextColor3 = UIController.Theme.colors.squad_green,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.025, 0.5),
                Size = UDim2.fromScale(1, 1),
                Visible = isChannelInfoVisible,
            },

            New "TextBox" {
                FontFace = Font.new(
                    UIController.Theme.fonts.main_font,
                    Enum.FontWeight.Bold,
                    Enum.FontStyle.Normal
                ),

                ClearTextOnFocus = false,
                PlaceholderText = PLACEHOLDER_TEXT,
                TextColor3 = UIController.Theme.colors.true_white,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1, 0.5),
                Size = textBoxSize,

                [Out "Text"] = text,
                [Ref] = textbox,

                [OnEvent "Focused"] = function()
                    toggleFocus(true)
                end,

                [OnEvent "FocusLost"] = function()
                    toggleFocus(false)
                end
            },
        }
    }
end

return ChatBar