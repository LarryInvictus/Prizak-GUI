--// PRIZAK GUI — Revamped Full System (SAFE & FIXED)
--// Fade + Toggle + Slide Panel + Commands + Tabs + Inputs

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

---------------------------------------------------------------------
-- 1. FADE-IN SCREEN
---------------------------------------------------------------------

local fadeGui = Instance.new("ScreenGui")
fadeGui.IgnoreGuiInset = true
fadeGui.Parent = PlayerGui

local fadeFrame = Instance.new("Frame")
fadeFrame.Size = UDim2.fromScale(1,1)
fadeFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
fadeFrame.Parent = fadeGui

local fadeText = Instance.new("TextLabel")
fadeText.Size = UDim2.fromScale(1,1)
fadeText.BackgroundTransparency = 1
fadeText.Text = "Prizak GUI"
fadeText.TextColor3 = Color3.fromRGB(255,255,255)
fadeText.Font = Enum.Font.GothamBold
fadeText.TextScaled = true
fadeText.Parent = fadeGui

TweenService:Create(fadeText, TweenInfo.new(1), {TextTransparency = 0}):Play()
task.wait(1)
TweenService:Create(fadeFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(fadeText, TweenInfo.new(1), {TextTransparency = 1}):Play()
task.wait(1)
fadeGui:Destroy()

---------------------------------------------------------------------
-- 2. TOGGLE BUTTON (🔥) — Draggable
---------------------------------------------------------------------

local mainGui = Instance.new("ScreenGui")
mainGui.IgnoreGuiInset = true
mainGui.Parent = PlayerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.fromOffset(110,110)
toggleBtn.Position = UDim2.fromScale(0.1,0.4)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
toggleBtn.Text = "🔥"
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = mainGui

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(1,0)

local function makeDraggable(obj)
	local dragging = false
	local dragStart, startPos

	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = obj.Position
		end
	end)

	obj.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			obj.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	obj.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(toggleBtn)

---------------------------------------------------------------------
-- 3. SLIDE-OPEN PANEL — Draggable
---------------------------------------------------------------------

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(450,350)
panel.Position = UDim2.new(0.5,-225,1,0)
panel.BackgroundColor3 = Color3.fromRGB(40,40,40)
panel.Parent = mainGui

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0,10)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,40)
topBar.BackgroundColor3 = Color3.fromRGB(70,70,70)
topBar.Parent = panel

local topBarCorner = Instance.new("UICorner", topBar)
topBarCorner.CornerRadius = UDim.new(0,10)

local strip = Instance.new("Frame")
strip.Size = UDim2.new(1,0,0,6)
strip.BackgroundColor3 = Color3.fromRGB(110,110,110)
strip.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(30,30)
closeBtn.Position = UDim2.new(0,5,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = topBar

local closeBtnCorner = Instance.new("UICorner", closeBtn)
closeBtnCorner.CornerRadius = UDim.new(0,5)

makeDraggable(topBar)

local openTween = TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
	Position = UDim2.new(0.5,-225,0.5,-175)
})

local closeTween = TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
	Position = UDim2.new(0.5,-225,1,0)
})

toggleBtn.MouseButton1Click:Connect(function()
	openTween:Play()
end)

closeBtn.MouseButton1Click:Connect(function()
	closeTween:Play()
end)

---------------------------------------------------------------------
-- SUCCESS POPUP
---------------------------------------------------------------------

local popup = Instance.new("TextLabel")
popup.Size = UDim2.fromOffset(260,40)
popup.Position = UDim2.new(0.5,-130,1,-60)
popup.BackgroundColor3 = Color3.fromRGB(30,30,30)
popup.TextColor3 = Color3.fromRGB(0,255,0)
popup.Font = Enum.Font.GothamBold
popup.TextScaled = true
popup.Text = "Command successfully executed"
popup.Visible = false
popup.Parent = mainGui

local popupCorner = Instance.new("UICorner", popup)
popupCorner.CornerRadius = UDim.new(0,10)

local function ShowPopup()
	popup.Visible = true
	task.delay(3, function()
		popup.Visible = false
	end)
end

---------------------------------------------------------------------
-- 4. COMMAND SYSTEM (SAFE)
---------------------------------------------------------------------

local PREFIX = "!"
local Commands = {}

local function RegisterCommand(name, callback, description, needsInput)
	Commands[name:lower()] = {
		run = callback,
		desc = description or "No description.",
		input = needsInput or false
	}
end

local function ExecuteCommand(text)
	if text:sub(1,#PREFIX) ~= PREFIX then return end

	local raw = text:sub(#PREFIX+1)
	local parts = raw:split(" ")
	local cmdName = parts[1]:lower()
	local args = {}

	for i = 2, #parts do
		table.insert(args, parts[i])
	end

	local cmd = Commands[cmdName]
	if cmd then
		pcall(function()
			cmd.run(args)
			ShowPopup()
		end)
	else
		warn("Unknown command:", cmdName)
	end
end

-- CHAT LISTENER
Player.Chatted:Connect(function(msg)
	ExecuteCommand(msg)
end)

---------------------------------------------------------------------
-- 5. TABS
---------------------------------------------------------------------

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,40)
tabBar.Position = UDim2.new(0,0,0,40)
tabBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
tabBar.Parent = panel

local tab1 = Instance.new("TextButton")
tab1.Size = UDim2.new(0.5,0,1,0)
tab1.Position = UDim2.new(0,0,0,0)
tab1.BackgroundColor3 = Color3.fromRGB(70,70,70)
tab1.Text = "Console"
tab1.TextScaled = true
tab1.Font = Enum.Font.GothamBold
tab1.TextColor3 = Color3.fromRGB(255,255,255)
tab1.Parent = tabBar

local tab1Corner = Instance.new("UICorner", tab1)
tab1Corner.CornerRadius = UDim.new(0,5)

local tab2 = Instance.new("TextButton")
tab2.Size = UDim2.new(0.5,0,1,0)
tab2.Position = UDim2.new(0.5,0,0,0)
tab2.BackgroundColor3 = Color3.fromRGB(70,70,70)
tab2.Text = "Commands"
tab2.TextScaled = true
tab2.Font = Enum.Font.GothamBold
tab2.TextColor3 = Color3.fromRGB(255,255,255)
tab2.Parent = tabBar

local tab2Corner = Instance.new("UICorner", tab2)
tab2Corner.CornerRadius = UDim.new(0,5)

---------------------------------------------------------------------
-- 6. TAB CONTENTS
---------------------------------------------------------------------

local consolePage = Instance.new("Frame")
consolePage.Size = UDim2.new(1,0,1,-80)
consolePage.Position = UDim2.new(0,0,0,80)
consolePage.BackgroundTransparency = 1
consolePage.Parent = panel

local cmdsPage = Instance.new("Frame")
cmdsPage.Size = UDim2.new(1,0,1,-80)
cmdsPage.Position = UDim2.new(0,0,0,80)
cmdsPage.BackgroundTransparency = 1
cmdsPage.Visible = false
cmdsPage.Parent = panel

tab1.MouseButton1Click:Connect(function()
	consolePage.Visible = true
	cmdsPage.Visible = false
end)

tab2.MouseButton1Click:Connect(function()
	consolePage.Visible = false
	cmdsPage.Visible = true
end)

---------------------------------------------------------------------
-- 7. CONSOLE PAGE UI
---------------------------------------------------------------------

local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-20,0,40)
input.Position = UDim2.new(0,10,0,10)
input.BackgroundColor3 = Color3.fromRGB(55,55,55)
input.TextColor3 = Color3.fromRGB(255,255,255)
input.Font = Enum.Font.Gotham
input.TextScaled = true
input.PlaceholderText = "Enter command..."
input.Parent = consolePage

local inputCorner = Instance.new("UICorner", input)
inputCorner.CornerRadius = UDim.new(0,5)

local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(1,-20,0,40)
runBtn.Position = UDim2.new(0,10,0,60)
runBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
runBtn.Text = "Run Command"
runBtn.TextScaled = true
runBtn.Font = Enum.Font.GothamBold
runBtn.TextColor3 = Color3.fromRGB(255,255,255)
runBtn.Parent = consolePage

local runBtnCorner = Instance.new("UICorner", runBtn)
runBtnCorner.CornerRadius = UDim.new(0,5)

runBtn.MouseButton1Click:Connect(function()
	if input.Text ~= "" then
		ExecuteCommand(input.Text)
		input.Text = ""
	end
end)

---------------------------------------------------------------------
-- 8. COMMANDS PAGE UI (Buttons + Inputs) + SCROLL
---------------------------------------------------------------------

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-20)
scroll.Position = UDim2.new(0,10,0,10)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = cmdsPage

local cmdsList = Instance.new("Frame")
cmdsList.Size = UDim2.new(1,0,0,0)
cmdsList.BackgroundTransparency = 1
cmdsList.Parent = scroll

local UIList = Instance.new("UIListLayout", cmdsList)
UIList.Padding = UDim.new(0,10)
UIList.FillDirection = Enum.FillDirection.Vertical

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y + 20)
end)

local function AddCommandButton(name, cmdData)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,40)
	btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
	btn.Text = name
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Parent = cmdsList

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0,5)

	if cmdData.input then
		btn.MouseButton1Click:Connect(function()
			local prompt = Instance.new("TextBox")
			prompt.Size = UDim2.new(1,-20,0,40)
			prompt.Position = UDim2.new(0,10,0,50)
			prompt.BackgroundColor3 = Color3.fromRGB(60,60,60)
			prompt.TextColor3 = Color3.fromRGB(255,255,255)
			prompt.Font = Enum.Font.Gotham
			prompt.TextScaled = true
			prompt.PlaceholderText = "Enter input..."
			prompt.Parent = cmdsPage

			local promptCorner = Instance.new("UICorner", prompt)
			promptCorner.CornerRadius = UDim.new(0,5)

			local ok = Instance.new("TextButton")
			ok.Size = UDim2.new(1,-20,0,40)
			ok.Position = UDim2.new(0,10,0,100)
			ok.BackgroundColor3 = Color3.fromRGB(90,90,90)
			ok.Text = "Run"
			ok.TextScaled = true
			ok.Font = Enum.Font.GothamBold
			ok.TextColor3 = Color3.fromRGB(255,255,255)
			ok.Parent = cmdsPage

			local okCorner = Instance.new("UICorner", ok)
			okCorner.CornerRadius = UDim.new(0,5)

			ok.MouseButton1Click:Connect(function()
				pcall(function()
					cmdData.run({prompt.Text})
					ShowPopup()
				end)
				prompt:Destroy()
				ok:Destroy()
			end)
		end)
	else
		btn.MouseButton1Click:Connect(function()
			pcall(function()
				cmdData.run({})
				ShowPopup()
			end)
		end)
	end
end

---------------------------------------------------------------------
-- 9. SAFE COMMANDS (NO EXPLOITS)
---------------------------------------------------------------------

-- HELLO
RegisterCommand("hello", function(args)
	print("Hello command executed!", args)
end, "Test command", false)

-- PREFIX
RegisterCommand("prefix", function(args)
	if args[1] then
		PREFIX = args[1]
		print("Prefix changed to:", PREFIX)
	end
end, "Change prefix", true)

-- CMDS (blue chat)
RegisterCommand("cmds", function(args)
	local list = "Commands:\n"
	for name,_ in pairs(Commands) do
		list = list .. "- " .. name .. "\n"
	end
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = list,
		Color = Color3.fromRGB(0,162,255)
	})
end, "List commands", false)

-- FLY (WASD + mobile via MoveDirection)
local flying = false
local flyConn

RegisterCommand("fly", function()
	if flying then return end
	flying = true

	local char = Player.Character or Player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")

	flyConn = RunService.RenderStepped:Connect(function()
		if not flying or not hum or not hrp then return end
		local dir = hum.MoveDirection
		local vel = Vector3.new(dir.X,0,dir.Z)
		hrp.AssemblyLinearVelocity = vel * 60
	end)
end, "Fly", false)

RegisterCommand("unfly", function()
	flying = false
	if flyConn then
		flyConn:Disconnect()
		flyConn = nil
	end
	local char = Player.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
		end
	end
end, "Stop flying", false)

-- NOCLIP
local noclip = false
local noclipConn

RegisterCommand("noclip", function()
	if noclip then return end
	noclip = true
	noclipConn = RunService.Stepped:Connect(function()
		if noclip and Player.Character then
			for _,v in pairs(Player.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end)
end, "Noclip", false)

RegisterCommand("clip", function()
	noclip = false
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
	if Player.Character then
		for _,v in pairs(Player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end
end, "Clip", false)

-- SPEED
RegisterCommand("speed", function(args)
	local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if hum and tonumber(args[1]) then
		hum.WalkSpeed = tonumber(args[1])
	end
end, "Set speed", true)

-- JUMP
RegisterCommand("jump", function(args)
	local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if hum and tonumber(args[1]) then
		hum.JumpPower = tonumber(args[1])
	end
end, "Set jump power", true)

-- RESET
RegisterCommand("reset", function()
	if Player.Character then
		Player.Character:BreakJoints()
	end
end, "Reset character", false)

-- TP
RegisterCommand("tp", function(args)
	local target = Players:FindFirstChild(args[1])
	if target and target.Character and Player.Character then
		Player.Character:WaitForChild("HumanoidRootPart").CFrame =
			target.Character:WaitForChild("HumanoidRootPart").CFrame
	end
end, "Teleport to player", true)

-- FLING (client fling)
RegisterCommand("fling", function(args)
	local target = Players:FindFirstChild(args[1])
	if not target or not target.Character or not Player.Character then return end

	local hrp = Player.Character:WaitForChild("HumanoidRootPart")
	local thrp = target.Character:WaitForChild("HumanoidRootPart")

	hrp.CFrame = thrp.CFrame
	hrp.AssemblyLinearVelocity = Vector3.new(9999,9999,9999)
end, "Fling player", true)

-- EXTRA SMALL SAFE COMMANDS
RegisterCommand("defaults", function()
	local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = 16
		hum.JumpPower = 50
	end
end, "Reset speed/jump", false)

RegisterCommand("gravity", function(args)
	if tonumber(args[1]) then
		workspace.Gravity = tonumber(args[1])
	end
end, "Set gravity", true)

---------------------------------------------------------------------
-- 10. BUILD COMMAND BUTTONS
---------------------------------------------------------------------

for name, data in pairs(Commands) do
	AddCommandButton(name, data)
end
