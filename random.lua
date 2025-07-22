local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local userId = plr.UserId

-- Delta Detection
local function isDelta()
    local exec = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
    return tostring(exec):lower():find("delta") ~= nil
end

-- Show Delta Warning GUI
local function showDeltaWarning()
    local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
    gui.Name = "Delta_Warning"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 420, 0, 200)
    frame.Position = UDim2.new(0.5, -210, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local message = Instance.new("TextLabel", frame)
    message.Size = UDim2.new(1, -20, 1, -60)
    message.Position = UDim2.new(0, 10, 0, 10)
    message.BackgroundTransparency = 1
    message.TextWrapped = true
    message.TextYAlignment = Enum.TextYAlignment.Top
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextColor3 = Color3.new(1, 1, 1)
    message.Font = Enum.Font.Gotham
    message.TextSize = 13
    message.Text = [[Welcome to ProjectBscripts!
We're currently experiencing issues with the Delta executor.
If you're using Delta, please switch to a different executor, as Delta is falsely flagging our script.

For a smoother experience, we recommend using KRNL.
You can download it at krnl.cat!]]

    -- Close Button
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = false
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    -- Button Hover Effects
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end)

    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end)

    -- Close Button Action
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

-- ▼ Only show warning if Delta is detected ▼
if isDelta() then
    showDeltaWarning()
    return
end

-- ▼ Otherwise show Loading GUI ▼

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RandomizerGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 400, 0, 180)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Parent = Frame
AvatarImage.Position = UDim2.new(0, 10, 0, 10)
AvatarImage.Size = UDim2.new(0, 50, 0, 50)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
AvatarImage.ScaleType = Enum.ScaleType.Fit

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Position = UDim2.new(0.5, 0, 0, 10)
Title.AnchorPoint = Vector2.new(0.5, 0)
Title.Size = UDim2.new(0.8, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Randomizer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

local PercentText = Instance.new("TextLabel")
PercentText.Parent = Frame
PercentText.Position = UDim2.new(0.5, 0, 0, 45)
PercentText.AnchorPoint = Vector2.new(0.5, 0)
PercentText.Size = UDim2.new(0.8, 0, 0, 25)
PercentText.BackgroundTransparency = 1
PercentText.Text = "Loading: 0%"
PercentText.TextColor3 = Color3.fromRGB(200, 200, 200)
PercentText.Font = Enum.Font.Gotham
PercentText.TextScaled = true

local ProgressBarBG = Instance.new("Frame")
ProgressBarBG.Parent = Frame
ProgressBarBG.Position = UDim2.new(0.05, 0, 0.55, 0)
ProgressBarBG.Size = UDim2.new(0.9, 0, 0.15, 0)
ProgressBarBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ProgressBarBG.BorderSizePixel = 0

local ProgressBar = Instance.new("Frame")
ProgressBar.Parent = ProgressBarBG
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ProgressBar.BorderSizePixel = 0

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Frame
Subtitle.Position = UDim2.new(0, 0, 0.8, 0)
Subtitle.Size = UDim2.new(1, 0, 0.15, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Loading by ProjectB"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextScaled = true

-- Rainbow Subtitle
task.spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            local color = Color3.fromHSV(hue, 1, 1)
            Subtitle.TextColor3 = color
            task.wait(0.05)
        end
    end
end)

-- Animate loading bar and percent
local loadTime = 5

TweenService:Create(ProgressBar, TweenInfo.new(loadTime, Enum.EasingStyle.Linear), {
    Size = UDim2.new(1, 0, 1, 0)
}):Play()

task.spawn(function()
    local startTime = tick()
    local connection

    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local percent = math.clamp((elapsed / loadTime) * 100, 0, 100)
        PercentText.Text = ("Loading: %d%%"):format(math.floor(percent + 0.5))

        if elapsed >= loadTime then
            connection:Disconnect()
            ScreenGui:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectBScripts/Loadingv2/refs/heads/main/Lolers"))()
        end
    end)
end)
