-- Universal Roblox Auto-Clicker v4 | Full-Screen Mouse Preview | Click Anywhere to Set | Tabbed Out | Toggleable
-- Paste directly into executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Settings
local Enabled = false
local ClickX, ClickY = 960, 540
local CPS = 10
local Interval = 1 / CPS

local SettingMode = false
local PreviewGui = nil
local PreviewFrame = nil

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickerV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 320)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🖱️ Auto-Clicker V4 | Click Anywhere"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleBtn

-- Set Spot Button
local SetPosBtn = Instance.new("TextButton")
SetPosBtn.Size = UDim2.new(0.9, 0, 0, 40)
SetPosBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
SetPosBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
SetPosBtn.Text = "🎯 Set Click Spot (Click Anywhere)"
SetPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SetPosBtn.TextScaled = true
SetPosBtn.Font = Enum.Font.Gotham
SetPosBtn.Parent = MainFrame

local SetPosCorner = Instance.new("UICorner")
SetPosCorner.CornerRadius = UDim.new(0, 10)
SetPosCorner.Parent = SetPosBtn

-- CPS Slider
local CPSLabel = Instance.new("TextLabel")
CPSLabel.Size = UDim2.new(1, 0, 0, 25)
CPSLabel.Position = UDim2.new(0, 0, 0.52, 0)
CPSLabel.BackgroundTransparency = 1
CPSLabel.Text = "Clicks per second: 10"
CPSLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CPSLabel.TextScaled = true
CPSLabel.Font = Enum.Font.Gotham
CPSLabel.Parent = MainFrame

local CPSSlider = Instance.new("Frame")
CPSSlider.Size = UDim2.new(0.9, 0, 0, 20)
CPSSlider.Position = UDim2.new(0.05, 0, 0.60, 0)
CPSSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CPSSlider.Parent = MainFrame

local CPSSliderCorner = Instance.new("UICorner")
CPSSliderCorner.CornerRadius = UDim.new(0, 10)
CPSSliderCorner.Parent = CPSSlider

local CPSFill = Instance.new("Frame")
CPSFill.Size = UDim2.new(0.5, 0, 1, 0)
CPSFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
CPSFill.BorderSizePixel = 0
CPSFill.Parent = CPSSlider

local CPSFillCorner = Instance.new("UICorner")
CPSFillCorner.CornerRadius = UDim.new(0, 10)
CPSFillCorner.Parent = CPSFill

local CPSKnob = Instance.new("Frame")
CPSKnob.Size = UDim2.new(0, 24, 0, 24)
CPSKnob.Position = UDim2.new(0.5, -12, 0.5, -12)
CPSKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CPSKnob.Parent = CPSSlider

local CPSKnobCorner = Instance.new("UICorner")
CPSKnobCorner.CornerRadius = UDim.new(1, 0)
CPSKnobCorner.Parent = CPSKnob

-- Current Position
local PosLabel = Instance.new("TextLabel")
PosLabel.Size = UDim2.new(1, 0, 0, 30)
PosLabel.Position = UDim2.new(0, 0, 0.78, 0)
PosLabel.BackgroundTransparency = 1
PosLabel.Text = "Click position: 960, 540"
PosLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
PosLabel.TextScaled = true
PosLabel.Font = Enum.Font.GothamBold
PosLabel.Parent = MainFrame

-- Click loop
local ClickConnection
function StartClicking()
    Interval = 1 / CPS
    if ClickConnection then ClickConnection:Disconnect() end
    ClickConnection = RunService.Heartbeat:Connect(function()
        if Enabled then
            VirtualInputManager:SendMouseButtonEvent(ClickX, ClickY, 0, true, game, 1)
            task.wait(Interval / 2)
            VirtualInputManager:SendMouseButtonEvent(ClickX, ClickY, 0, false, game, 1)
            task.wait(Interval / 2)
        end
    end)
end

function StopClicking()
    if ClickConnection then
        ClickConnection:Disconnect()
        ClickConnection = nil
    end
end

-- Toggle
ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    ToggleBtn.Text = Enabled and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    if Enabled then StartClicking() else StopClicking() end
end)

-- INSERT key toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        Enabled = not Enabled
        ToggleBtn.Text = Enabled and "ON" or "OFF"
        ToggleBtn.BackgroundColor3 = Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        if Enabled then StartClicking() else StopClicking() end
    end
end)

-- Set Spot Mode (full-screen preview)
SetPosBtn.MouseButton1Click:Connect(function()
    SettingMode = true
    SetPosBtn.Text = "🎯 CLICK ANYWHERE TO SET (INSERT to cancel)"
    SetPosBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)

    -- Full-screen preview circle
    PreviewGui = Instance.new("ScreenGui")
    PreviewGui.Name = "ClickPreview"
    PreviewGui.ResetOnSpawn = false
    PreviewGui.IgnoreGuiInset = true
    PreviewGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PreviewGui.Parent = PlayerGui

    PreviewFrame = Instance.new("Frame")
    PreviewFrame.Size = UDim2.new(0, 50, 0, 50)
    PreviewFrame.BackgroundTransparency = 1
    PreviewFrame.Parent = PreviewGui

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(1, 0, 1, 0)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Circle.BackgroundTransparency = 0.5
    Circle.BorderSizePixel = 3
    Circle.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = PreviewFrame

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local CrossV = Instance.new("Frame")
    CrossV.Size = UDim2.new(0, 2, 0, 60)
    CrossV.Position = UDim2.new(0.5, -1, 0.5, -30)
    CrossV.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CrossV.BorderSizePixel = 0
    CrossV.Parent = PreviewFrame

    local CrossH = CrossV:Clone()
    CrossH.Size = UDim2.new(0, 60, 0, 2)
    CrossH.Position = UDim2.new(0.5, -30, 0.5, -1)
    CrossH.Parent = PreviewFrame

    -- Mouse follow
    local PreviewConn = RunService.RenderStepped:Connect(function()
        local MousePos = UserInputService:GetMouseLocation()
        PreviewFrame.Position = UDim2.new(0, MousePos.X - 25, 0, MousePos.Y - 25)
    end)

    -- Click to set
    local SetConn = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and SettingMode then
            local MousePos = UserInputService:GetMouseLocation()
            ClickX, ClickY = MousePos.X, MousePos.Y
            PosLabel.Text = "Click position: " .. math.floor(ClickX) .. ", " .. math.floor(ClickY)

            SettingMode = false
            SetPosBtn.Text = "🎯 Set Click Spot ✓"
            SetPosBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

            PreviewGui:Destroy()
            PreviewConn:Disconnect()
            SetConn:Disconnect()
        elseif input.KeyCode == Enum.KeyCode.Insert and SettingMode then
            SettingMode = false
            SetPosBtn.Text = "🎯 Set Click Spot"
            SetPosBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            PreviewGui:Destroy()
            PreviewConn:Disconnect()
            SetConn:Disconnect()
        end
    end)
end)

-- CPS drag
local cpsDragging = false
CPSKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        cpsDragging = true
    end
end)
CPSKnob.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        cpsDragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if cpsDragging then
        local mouseX = UserInputService:GetMouseLocation().X
        local sliderLeft = CPSSlider.AbsolutePosition.X
        local sliderWidth = CPSSlider.AbsoluteSize.X
        
        local relative = math.clamp((mouseX - sliderLeft) / sliderWidth, 0, 1)
        CPSFill.Size = UDim2.new(relative, 0, 1, 0)
        CPSKnob.Position = UDim2.new(relative, -12, 0.5, -12)
        
        CPS = math.floor(5 + relative * 55)
        CPSLabel.Text = "Clicks per second: " .. CPS
        
        if Enabled then StartClicking() end
    end
end)

-- Initial
StopClicking()
print("Auto-Clicker V4 ready! Click 'Set Click Spot' to select position anywhere | INSERT to toggle")

-- Auto-reexec (upload script as clicker-v4.lua in your repo)
if queue_on_teleport then
    queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/rzcwy/scripts/main/clicker-v4.lua"))()')
end