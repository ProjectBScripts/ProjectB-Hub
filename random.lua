-- Pet Randomizer by ProjectB | Alternate GUI Design

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local localPlayer = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetRandomizerGUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = localPlayer:FindFirstChildOfClass("PlayerGui")

-- Toggle Button (Minimal design with logo)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 15, 0.5, -22)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.Image = "rbxassetid://6031280882" -- Change this to your logo ID
toggleBtn.AutoButtonColor = false
toggleBtn.Draggable = true
toggleBtn.Parent = screenGui

-- Main Frame (Alternate Flat Design)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 270, 0, 210)
mainFrame.Position = UDim2.new(0.5, -135, 0.5, -105)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true

-- Title Label
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.BorderSizePixel = 0
title.Text = "Pet Randomizer"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Close Button
local closeBtn = Instance.new("TextButton", title)
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18

-- Auto Stop Button
local autoStopBtn = Instance.new("TextButton", mainFrame)
autoStopBtn.Size = UDim2.new(1, -20, 0, 40)
autoStopBtn.Position = UDim2.new(0, 10, 0, 45)
autoStopBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
autoStopBtn.TextColor3 = Color3.new(1, 1, 1)
autoStopBtn.Text = "[A] Auto Stop: OFF"
autoStopBtn.Font = Enum.Font.GothamBold
autoStopBtn.TextSize = 16

-- Manual Reroll Button
local rerollBtn = Instance.new("TextButton", mainFrame)
rerollBtn.Size = UDim2.new(1, -20, 0, 40)
rerollBtn.Position = UDim2.new(0, 10, 0, 95)
rerollBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
rerollBtn.TextColor3 = Color3.new(1, 1, 1)
rerollBtn.Text = "[B] Manual Reroll"
rerollBtn.Font = Enum.Font.GothamBold
rerollBtn.TextSize = 16

-- Cooldown Text
local cooldownText = Instance.new("TextLabel", mainFrame)
cooldownText.Size = UDim2.new(1, -20, 0, 20)
cooldownText.Position = UDim2.new(0, 10, 0, 145)
cooldownText.Text = "Cooldown: Ready"
cooldownText.Font = Enum.Font.Gotham
cooldownText.TextSize = 14
cooldownText.TextColor3 = Color3.fromRGB(200, 200, 200)
cooldownText.BackgroundTransparency = 1

-- Credit Label
local credit = Instance.new("TextLabel", mainFrame)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -20)
credit.Text = "Made by ProjectB"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = Color3.fromRGB(120, 120, 120)
credit.BackgroundTransparency = 1

-- Toggle Button Function
toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Logic
local displayedEggs = {}
local autoStop = false
local isCooldown = false

local rarePets = {
	["T-Rex"] = true, ["Red Fox"] = true, ["Queen Bee"] = true,
	["Disco Bee"] = true, ["Dragon Fly"] = true, ["Butterfly"] = true,
	["Mimic Octopus"] = true, ["Scarlet Macaw"] = true
}

local eggChances = {
	["Common Egg"] = {["Dog"] = 33, ["Bunny"] = 33, ["Golden Lab"] = 33},
	["Uncommon Egg"] = {["Black Bunny"] = 25, ["Chicken"] = 25, ["Cat"] = 25, ["Deer"] = 25},
	["Rare Egg"] = {["Orange Tabby"] = 33.33, ["Spotted Deer"] = 25, ["Pig"] = 16.67, ["Rooster"] = 16.67, ["Monkey"] = 8.33},
	["Legendary Egg"] = {["Cow"] = 42.55, ["Silver Monkey"] = 42.55, ["Sea Otter"] = 10.64, ["Turtle"] = 2.13, ["Polar Bear"] = 2.13},
	["Mythic Egg"] = {["Grey Mouse"] = 37.5, ["Brown Mouse"] = 26.79, ["Squirrel"] = 26.79, ["Red Giant Ant"] = 8.93, ["Red Fox"] = 0},
	["Bug Egg"] = {["Snail"] = 40, ["Giant Ant"] = 35, ["Caterpillar"] = 25, ["Praying Mantis"] = 0, ["Dragon Fly"] = 0},
	["Night Egg"] = {["Hedgehog"] = 47, ["Mole"] = 23.5, ["Frog"] = 21.16, ["Echo Frog"] = 8.35, ["Night Owl"] = 0, ["Raccoon"] = 0},
	["Bee Egg"] = {["Bee"] = 65, ["Honey Bee"] = 20, ["Bear Bee"] = 10, ["Petal Bee"] = 5, ["Queen Bee"] = 0},
	["Anti Bee Egg"] = {["Wasp"] = 55, ["Tarantula Hawk"] = 31, ["Moth"] = 14, ["Butterfly"] = 0, ["Disco Bee"] = 0},
	["Common Summer Egg"] = {["Starfish"] = 50, ["Seafull"] = 25, ["Crab"] = 25},
	["Rare Summer Egg"] = {["Flamingo"] = 30, ["Toucan"] = 25, ["Sea Turtle"] = 20, ["Orangutan"] = 15, ["Seal"] = 10},
	["Paradise Egg"] = {["Ostrich"] = 43, ["Peacock"] = 33, ["Capybara"] = 24, ["Scarlet Macaw"] = 3, ["Mimic Octopus"] = 1},
	["Premium Night Egg"] = {["Hedgehog"] = 50, ["Mole"] = 26, ["Frog"] = 14, ["Echo Frog"] = 10},
	["Dinosaur Egg"] = {["Raptor"] = 33, ["Triceratops"] = 33, ["T-Rex"] = 1, ["Stegosaurus"] = 33, ["Pterodactyl"] = 33, ["Brontosaurus"] = 33}
}

local function weightedRandom(options)
	local total, valid = 0, {}
	for pet, chance in pairs(options) do
		if chance > 0 then
			table.insert(valid, {pet = pet, chance = chance})
			total += chance
		end
	end
	if total == 0 then return nil end
	local roll, cumulative = math.random() * total, 0
	for _, v in ipairs(valid) do
		cumulative += v.chance
		if roll <= cumulative then return v.pet end
	end
	return valid[1].pet
end

local function createESP(egg, pet, isRare)
	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = egg:FindFirstChildWhichIsA("BasePart") or egg.PrimaryPart or egg
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.AlwaysOnTop = true
	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = isRare and Color3.fromRGB(0,255,0) or Color3.new(1,1,1)
	label.TextStrokeTransparency = 0
	label.Text = pet
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	billboard.Parent = egg
	return billboard
end

local function addEgg(egg)
	local id = egg:GetAttribute("OBJECT_UUID")
	local eggName = egg:GetAttribute("EggName")
	if not id or displayedEggs[id] then return end
	local pet = weightedRandom(eggChances[eggName] or {})
	local isRare = rarePets[pet] and autoStop
	local esp = createESP(egg, pet, isRare)
	displayedEggs[id] = {egg=egg, esp=esp, label=esp:FindFirstChild("TextLabel"), pet=pet, locked=isRare}
end

local function removeEgg(egg)
	local id = egg:GetAttribute("OBJECT_UUID")
	if displayedEggs[id] then
		displayedEggs[id].esp:Destroy()
		displayedEggs[id] = nil
	end
end

for _,egg in CollectionService:GetTagged("PetEggServer") do addEgg(egg) end
CollectionService:GetInstanceAddedSignal("PetEggServer"):Connect(addEgg)
CollectionService:GetInstanceRemovedSignal("PetEggServer"):Connect(removeEgg)

autoStopBtn.MouseButton1Click:Connect(function()
	autoStop = not autoStop
	autoStopBtn.Text = "[A] Auto Stop: " .. (autoStop and "ON" or "OFF")
	autoStopBtn.BackgroundColor3 = autoStop and Color3.fromRGB(50,255,50) or Color3.fromRGB(70,70,70)
end)

rerollBtn.MouseButton1Click:Connect(function()
	if isCooldown then return end
	isCooldown = true
	for i=3,1,-1 do cooldownText.Text="Cooldown: "..i.."s" task.wait(1) end
	cooldownText.Text="Cooldown: Ready" isCooldown=false
	for id,data in pairs(displayedEggs) do
		if data.locked then continue end
		local pet = weightedRandom(eggChances[data.egg:GetAttribute("EggName")] or {})
		data.pet = pet
		data.label.Text = pet
		if rarePets[pet] and autoStop then
			data.locked=true
			data.label.TextColor3=Color3.fromRGB(0,255,0)
		end
	end
end)
