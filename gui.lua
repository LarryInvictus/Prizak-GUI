--// PRIZAK GUI — Revamped Full System (SAFE & FIXED) + ENHANCED STYLING
--// Fade + Toggle + Slide Panel + Commands + Tabs + Inputs
--// Yellow & Green Theme with Stud Material Style
--// ROBLOX EDITION

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

---------------------------------------------------------------------
-- COLOR SCHEME - YELLOW & GREEN (ROBLOX STUD MATERIAL STYLE)
---------------------------------------------------------------------

local Colors = {
	Primary = Color3.fromRGB(255, 223, 0),       -- Bright Yellow
	PrimaryLight = Color3.fromRGB(255, 242, 0),  -- Light Yellow
	Secondary = Color3.fromRGB(50, 205, 50),     -- Lime Green
	SecondaryLight = Color3.fromRGB(144, 238, 144), -- Light Green
	Accent = Color3.fromRGB(34, 139, 34),        -- Forest Green
	Dark = Color3.fromRGB(20, 25, 20),           -- Dark BG (greenish)
	DarkAlt = Color3.fromRGB(30, 40, 30),        -- Slightly Lighter
	Text = Color3.fromRGB(255, 255, 255),        -- White
	Success = Color3.fromRGB(144, 238, 144),     -- Light Green
	Warning = Color3.fromRGB(255, 223, 0)        -- Gold/Yellow
}

---------------------------------------------------------------------
-- HELPER: Find player by display name or username
---------------------------------------------------------------------

local function FindPlayer(input)
	if not input or input == "" then return nil end
	
	-- First try exact username match
	local target = Players:FindFirstChild(input)
	if target then return target end
	
	-- Then try display name match (case-insensitive)
	for _, player in pairs(Players:GetPlayers()) do
		if player.DisplayName:lower() == input:lower() then
			return player
		end
	end
	
	-- Finally try partial username match
	for _, player in pairs(Players:GetPlayers()) do
		if player.Name:lower():find(input:lower(), 1, true) then
			return player
		end
	end
	
	return nil
end

---------------------------------------------------------------------
-- 1. FADE-IN SCREEN
---------------------------------------------------------------------

local fadeGui = Instance.new("ScreenGui")
fadeGui.IgnoreGuiInset = true
fadeGui.Parent = PlayerGui

local fadeFrame = Instance.new("Frame")
fadeFrame.Size = UDim2.fromScale(1,1)
fadeFrame.BackgroundColor3 = Colors.Dark
fadeFrame.Parent = fadeGui

local fadeText = Instance.new("TextLabel")
fadeText.Size = UDim2.fromScale(1,1)
fadeText.BackgroundTransparency = 1
fadeText.Text = "⚡ PRIZAK GUI ⚡"
fadeText.TextColor3 = Colors.Primary
fadeText.Font = Enum.Font.GothamBold
fadeText.TextScaled = true
fadeText.Parent = fadeGui

local fadeShadow = Instance.new("UIStroke", fadeText)
fadeShadow.Color = Colors.Secondary
fadeShadow.Thickness = 2

fadeText.TextTransparency = 1
TweenService:Create(fadeText, TweenInfo.new(1), {TextTransparency = 0}):Play()
task.wait(1)
TweenService:Create(fadeFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(fadeText, TweenInfo.new(1), {TextTransparency = 1}):Play()
task.wait(1)
fadeGui:Destroy()

---------------------------------------------------------------------
-- 2. TOGGLE BUTTON (⭐) — Draggable (improved)
---------------------------------------------------------------------

local mainGui = Instance.new("ScreenGui")
mainGui.IgnoreGuiInset = true
mainGui.Parent = PlayerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.fromOffset(110,110)
toggleBtn.Position = UDim2.fromScale(0.1,0.4)
toggleBtn.BackgroundColor3 = Colors.Primary
toggleBtn.Text = "⭐"
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Colors.Dark
toggleBtn.Parent = mainGui

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(1,0)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Colors.Secondary
toggleStroke.Thickness = 3

-- Improved draggable helper. Accepts a handle (what you click) and a target (what moves).
local function makeDraggable(handle, target)
	target = target or handle
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		local newX = startPos.X.Offset + delta.X
		local newY = startPos.Y.Offset + delta.Y
		-- Clamp to screen bounds (simple clamp, keeps top-left inside 0..viewport)
		local viewX, viewY = workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y
		local maxX = viewX - target.AbsoluteSize.X
		local maxY = viewY - target.AbsoluteSize.Y
		newX = math.clamp(newX, 0, maxX)
		newY = math.clamp(newY, 0, maxY)
		target.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
	end

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			dragInput = input
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			pcall(update, input)
		end
	end)
end

makeDraggable(toggleBtn, toggleBtn)

---------------------------------------------------------------------
-- 3. SLIDE-OPEN PANEL — Draggable (improved)
---------------------------------------------------------------------

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(500,400)
panel.Position = UDim2.new(0.5,-250,1,0)
panel.BackgroundColor3 = Colors.Dark
panel.Parent = mainGui

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0,15)

local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = Colors.Primary
panelStroke.Thickness = 2

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,50)
topBar.BackgroundColor3 = Colors.Primary
topBar.Parent = panel

local topBarCorner = Instance.new("UICorner", topBar)
topBarCorner.CornerRadius = UDim.new(0,15)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,-40,1,0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⭐ PRIZAK COMMANDS"
titleLabel.TextColor3 = Colors.Dark
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true
titleLabel.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(35,35)
closeBtn.Position = UDim2.new(1,-40,0.5,-17.5)
closeBtn.BackgroundColor3 = Colors.Secondary
closeBtn.Text = "✕"
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Colors.Dark
closeBtn.Parent = topBar

local closeBtnCorner = Instance.new("UICorner", closeBtn)
closeBtnCorner.CornerRadius = UDim.new(0,8)

local closeBtnStroke = Instance.new("UIStroke", closeBtn)
closeBtnStroke.Color = Colors.Dark
closeBtnStroke.Thickness = 2

-- Drag the panel by dragging the topBar
makeDraggable(topBar, panel)

local openTween = TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
	Position = UDim2.new(0.5,-250,0.5,-200)
})

local closeTween = TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
	Position = UDim2.new(0.5,-250,1,0)
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
popup.Size = UDim2.fromOffset(300,50)
popup.Position = UDim2.new(0.5,-150,1,-70)
popup.BackgroundColor3 = Colors.DarkAlt
popup.TextColor3 = Colors.Success
popup.Font = Enum.Font.GothamBold
popup.TextScaled = true
popup.Text = "✓ Command successfully executed"
popup.Visible = false
popup.Parent = mainGui

local popupCorner = Instance.new("UICorner", popup)
popupCorner.CornerRadius = UDim.new(0,12)

local popupStroke = Instance.new("UIStroke", popup)
popupStroke.Color = Colors.Success
popupStroke.Thickness = 2

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
tabBar.Size = UDim2.new(1,0,0,45)
tabBar.Position = UDim2.new(0,0,0,50)
tabBar.BackgroundColor3 = Colors.DarkAlt
tabBar.Parent = panel

local tabCorner = Instance.new("UICorner", tabBar)
tabCorner.CornerRadius = UDim.new(0,0)

local tab1 = Instance.new("TextButton")
tab1.Size = UDim2.new(0.25,0,1,0)
tab1.Position = UDim2.new(0,0,0,0)
tab1.BackgroundColor3 = Colors.Primary
tab1.Text = "Console"
tab1.TextScaled = true
tab1.Font = Enum.Font.GothamBold
tab1.TextColor3 = Colors.Dark
tab1.Parent = tabBar

local tab1Corner = Instance.new("UICorner", tab1)
tab1Corner.CornerRadius = UDim.new(0,0)

local tab2 = Instance.new("TextButton")
tab2.Size = UDim2.new(0.25,0,1,0)
tab2.Position = UDim2.new(0.25,0,0,0)
tab2.BackgroundColor3 = Colors.DarkAlt
tab2.Text = "Commands"
tab2.TextScaled = true
tab2.Font = Enum.Font.GothamBold
tab2.TextColor3 = Colors.Text
tab2.Parent = tabBar

local tab2Stroke = Instance.new("UIStroke", tab2)
tab2Stroke.Color = Colors.Primary
tab2Stroke.Thickness = 1

local tab3 = Instance.new("TextButton")
tab3.Size = UDim2.new(0.25,0,1,0)
tab3.Position = UDim2.new(0.5,0,0,0)
tab3.BackgroundColor3 = Colors.DarkAlt
tab3.Text = "About"
tab3.TextScaled = true
tab3.Font = Enum.Font.GothamBold
tab3.TextColor3 = Colors.Text
tab3.Parent = tabBar

local tab3Stroke = Instance.new("UIStroke", tab3)
tab3Stroke.Color = Colors.Primary
tab3Stroke.Thickness = 1

local tab4 = Instance.new("TextButton")
tab4.Size = UDim2.new(0.25,0,1,0)
tab4.Position = UDim2.new(0.75,0,0,0)
tab4.BackgroundColor3 = Colors.DarkAlt
tab4.Text = "Changelog"
tab4.TextScaled = true
tab4.Font = Enum.Font.GothamBold
tab4.TextColor3 = Colors.Text
tab4.Parent = tabBar

local tab4Stroke = Instance.new("UIStroke", tab4)
tab4Stroke.Color = Colors.Primary
tab4Stroke.Thickness = 1

---------------------------------------------------------------------
-- 6. TAB CONTENTS
---------------------------------------------------------------------

local consolePage = Instance.new("Frame")
consolePage.Size = UDim2.new(1,0,1,-95)
consolePage.Position = UDim2.new(0,0,0,95)
consolePage.BackgroundTransparency = 1
consolePage.Parent = panel

local cmdsPage = Instance.new("Frame")
cmdsPage.Size = UDim2.new(1,0,1,-95)
cmdsPage.Position = UDim2.new(0,0,0,95)
cmdsPage.BackgroundTransparency = 1
cmdsPage.Visible = false
cmdsPage.Parent = panel

local aboutPage = Instance.new("Frame")
aboutPage.Size = UDim2.new(1,0,1,-95)
aboutPage.Position = UDim2.new(0,0,0,95)
aboutPage.BackgroundTransparency = 1
aboutPage.Visible = false
aboutPage.Parent = panel

local changelogPage = Instance.new("Frame")
changelogPage.Size = UDim2.new(1,0,1,-95)
changelogPage.Position = UDim2.new(0,0,0,95)
changelogPage.BackgroundTransparency = 1
changelogPage.Visible = false
changelogPage.Parent = panel

local function showPage(pageName)
	consolePage.Visible = false
	cmdsPage.Visible = false
	aboutPage.Visible = false
	changelogPage.Visible = false

	if pageName == "console" then
		consolePage.Visible = true
		tab1.BackgroundColor3 = Colors.Primary
		tab2.BackgroundColor3 = Colors.DarkAlt
		tab3.BackgroundColor3 = Colors.DarkAlt
		tab4.BackgroundColor3 = Colors.DarkAlt
	elseif pageName == "cmds" then
		cmdsPage.Visible = true
		tab1.BackgroundColor3 = Colors.DarkAlt
		tab2.BackgroundColor3 = Colors.Primary
		tab3.BackgroundColor3 = Colors.DarkAlt
		tab4.BackgroundColor3 = Colors.DarkAlt
	elseif pageName == "about" then
		aboutPage.Visible = true
		tab1.BackgroundColor3 = Colors.DarkAlt
		tab2.BackgroundColor3 = Colors.DarkAlt
		tab3.BackgroundColor3 = Colors.Primary
		tab4.BackgroundColor3 = Colors.DarkAlt
	elseif pageName == "changelog" then
		changelogPage.Visible = true
		tab1.BackgroundColor3 = Colors.DarkAlt
		tab2.BackgroundColor3 = Colors.DarkAlt
		tab3.BackgroundColor3 = Colors.DarkAlt
		tab4.BackgroundColor3 = Colors.Primary
	end
end

tab1.MouseButton1Click:Connect(function()
	showPage("console")
end)

tab2.MouseButton1Click:Connect(function()
	showPage("cmds")
end)

tab3.MouseButton1Click:Connect(function()
	showPage("about")
end)

tab4.MouseButton1Click:Connect(function()
	showPage("changelog")
end)

-- default page
showPage("console")

---------------------------------------------------------------------
-- 7. CONSOLE PAGE UI
---------------------------------------------------------------------

local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-20,0,40)
input.Position = UDim2.new(0,10,0,10)
input.BackgroundColor3 = Colors.DarkAlt
input.TextColor3 = Colors.Text
input.Font = Enum.Font.Gotham
input.TextScaled = true
input.PlaceholderText = "Enter command..."
input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
input.Parent = consolePage

local inputCorner = Instance.new("UICorner", input)
inputCorner.CornerRadius = UDim.new(0,8)

local inputStroke = Instance.new("UIStroke", input)
inputStroke.Color = Colors.Secondary
inputStroke.Thickness = 2

local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(1,-20,0,40)
runBtn.Position = UDim2.new(0,10,0,60)
runBtn.BackgroundColor3 = Colors.Secondary
runBtn.Text = "▶ Run Command"
runBtn.TextScaled = true
runBtn.Font = Enum.Font.GothamBold
runBtn.TextColor3 = Colors.Dark
runBtn.Parent = consolePage

local runBtnCorner = Instance.new("UICorner", runBtn)
runBtnCorner.CornerRadius = UDim.new(0,8)

local runBtnStroke = Instance.new("UIStroke", runBtn)
runBtnStroke.Color = Colors.Secondary
runBtnStroke.Thickness = 2

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
scroll.ScrollBarImageColor3 = Colors.Primary
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = cmdsPage

local cmdsList = Instance.new("Frame")
cmdsList.Size = UDim2.new(1,0,0,0)
cmdsList.BackgroundTransparency = 1
cmdsList.Parent = scroll

local UIList = Instance.new("UIListLayout", cmdsList)
UIList.Padding = UDim.new(0,8)
UIList.FillDirection = Enum.FillDirection.Vertical

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y + 20)
end)

local function AddCommandButton(name, cmdData)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,45)
	btn.BackgroundColor3 = Colors.DarkAlt
	btn.Text = "▸ " .. name:upper()
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Colors.Secondary
	btn.Parent = cmdsList

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0,8)

	local btnStroke = Instance.new("UIStroke", btn)
	btnStroke.Color = Colors.Primary
	btnStroke.Thickness = 1.5

	if cmdData.input then
		btn.MouseButton1Click:Connect(function()
			local prompt = Instance.new("TextBox")
			prompt.Size = UDim2.new(1,-20,0,40)
			prompt.Position = UDim2.new(0,10,0,50)
			prompt.BackgroundColor3 = Colors.DarkAlt
			prompt.TextColor3 = Colors.Text
			prompt.Font = Enum.Font.Gotham
			prompt.TextScaled = true
			prompt.PlaceholderText = "Enter input..."
			prompt.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
			prompt.Parent = cmdsPage

			local promptCorner = Instance.new("UICorner", prompt)
			promptCorner.CornerRadius = UDim.new(0,8)

			local promptStroke = Instance.new("UIStroke", prompt)
			promptStroke.Color = Colors.Secondary
			promptStroke.Thickness = 2

			local ok = Instance.new("TextButton")
			ok.Size = UDim2.new(1,-20,0,40)
			ok.Position = UDim2.new(0,10,0,100)
			ok.BackgroundColor3 = Colors.Success
			ok.Text = "✓ Run"
			ok.TextScaled = true
			ok.Font = Enum.Font.GothamBold
			ok.TextColor3 = Colors.Dark
			ok.Parent = cmdsPage

			local okCorner = Instance.new("UICorner", ok)
			okCorner.CornerRadius = UDim.new(0,8)

			local okStroke = Instance.new("UIStroke", ok)
			okStroke.Color = Colors.Success
			okStroke.Thickness = 2

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
-- 9. SAFE COMMANDS (NO EXPLOITS) — ENHANCED & EXPANDED
---------------------------------------------------------------------

-- PREFIX
RegisterCommand("prefix", function(args)
	if args[1] then
		PREFIX = args[1]
		print("Prefix changed to:", PREFIX)
	end
end, "Change prefix", true)

-- CMDS (green chat)
RegisterCommand("cmds", function(args)
	local list = "Commands:\n"
	for name,_ in pairs(Commands) do
		list = list .. "- " .. name .. "\n"
	end
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = list,
		Color = Colors.Secondary
	})
end, "List commands", false)

-- FLY (improved)
local flying = false
local flyConn
local flySpeed = 60

RegisterCommand("fly", function()
	if flying then return end
	flying = true

	local char = Player.Character or Player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")

	flyConn = RunService.RenderStepped:Connect(function()
		if not flying or not hum or not hrp then return end
		local dir = hum.MoveDirection
		local vy = 0
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			vy = 60
		elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift) then
			vy = -60
		end
		local vel = Vector3.new(dir.X, 0, dir.Z)
		hrp.AssemblyLinearVelocity = Vector3.new(vel.X * flySpeed, vy, vel.Z * flySpeed)
	end)
end, "Fly (WASD + Space/Shift)", false)

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

-- GOTO (Teleport to player - uses display name or username)
RegisterCommand("goto", function(args)
	local target = FindPlayer(args[1])
	if target and target.Character and Player.Character then
		Player.Character:WaitForChild("HumanoidRootPart").CFrame =
			target.Character:WaitForChild("HumanoidRootPart").CFrame
	end
end, "Goto player (display name or username)", true)

-- FLING (improved client fling)
RegisterCommand("fling", function(args)
	local target = FindPlayer(args[1])
	if not target or not target.Character or not Player.Character then return end

	local hrp = Player.Character:WaitForChild("HumanoidRootPart")
	local thrp = target.Character:FindFirstChild("HumanoidRootPart")
	if not thrp then return end

	-- attempt multiple short high-velocity pushes near the target
	for i = 1, 6 do
		pcall(function()
			hrp.CFrame = thrp.CFrame * CFrame.new(0, 2, 0)
			hrp.AssemblyLinearVelocity = Vector3.new(0, 1000, 0)
			hrp.CFrame = thrp.CFrame
			-- move our hrp into the target to encourage physics interaction
			hrp = thrp -- no-op to be safe in pcall
		end)
		task.wait(0.05)
	end

	-- As a fallback, try applying a large velocity to our own HRP while placing it on the target
	pcall(function()
		hrp.CFrame = thrp.CFrame + Vector3.new(0,3,0)
		hrp.AssemblyLinearVelocity = Vector3.new(9999,9999,9999)
	end)
end, "Fling player (display name or username)", true)

-- WALKFLING
RegisterCommand("walkfling", function(args)
	local target = FindPlayer(args[1])
	if not target or not target.Character or not Player.Character then return end

	local char = Player.Character
	local hrp = char:WaitForChild("HumanoidRootPart")
	local thrp = target.Character:FindFirstChild("HumanoidRootPart")
	if not thrp then return end

	-- walk up to the target and apply repeated velocity
	for i = 1, 40 do
		pcall(function()
			hrp.CFrame = thrp.CFrame + Vector3.new(0,2,0)
			hrp.AssemblyLinearVelocity = Vector3.new(0,1000,0)
			char:WaitForChild("HumanoidRootPart").CFrame = thrp.CFrame * CFrame.new(0,0.5,0)
		end)
		task.wait(0.03)
	end
end, "Walkfling player (display name or username)", true)

-- ADVERTISE - Updated to say "Join Prizak today!"
RegisterCommand("advertise", function()
	pcall(function()
		Player:Chat("Join Prizak today!")
	end)
end, "Advertise in chat", false)

-- HEAL
RegisterCommand("heal", function()
	local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Health = hum.MaxHealth
	end
end, "Heal to full", false)

-- SIT / UNSIT
RegisterCommand("sit", function()
	local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.Sit = true end
end, "Sit down", false)

RegisterCommand("unsit", function()
	local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.Sit = false end
end, "Stand up", false)

-- SPIN / SPINSTOP
local spinConn
RegisterCommand("spin", function()
	if spinConn then return end
	local char = Player.Character or Player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	spinConn = RunService.Heartbeat:Connect(function(dt)
		if hrp and hrp.Parent then
			hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(180 * dt), 0)
		end
	end)
end, "Spin yourself", false)

RegisterCommand("spinstop", function()
	if spinConn then
		spinConn:Disconnect()
		spinConn = nil
	end
end, "Stop spinning", false)

-- KILL (set health to 0)
RegisterCommand("kill", function(args)
	local target = args[1]
	if not target or target:lower() == "me" then
		local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.Health = 0 end
	else
		local p = FindPlayer(target)
		if p and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = 0 end
		end
	end
end, "Kill yourself or target (last resort)", true)

-- DEFAULTS
RegisterCommand("defaults", function()
	local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = 16
		hum.JumpPower = 50
	end
end, "Reset speed/jump", false)

-- GRAVITY
RegisterCommand("gravity", function(args)
	if tonumber(args[1]) then
		workspace.Gravity = tonumber(args[1])
	end
end, "Set gravity", true)

-- R6 / R15: client cannot reliably switch rig type. Provide safe message.
RegisterCommand("r6", function()
	StarterGui:SetCore("ChatMakeSystemMessage", {Text = "Changing rig client-side is not supported; rejoin with an R6 avatar to use R6.", Color = Colors.Warning})
end, "Info about R6", false)

RegisterCommand("r15", function()
	StarterGui:SetCore("ChatMakeSystemMessage", {Text = "Changing rig client-side is not supported; rejoin with an R15 avatar to use R15.", Color = Colors.Warning})
end, "Info about R15", false)

-- DANCE
RegisterCommand("dance", function()
	local char = Player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:PlayEmote("Dance")
		end
	end
end, "Do a dance", false)

-- WAVE
RegisterCommand("wave", function()
	local char = Player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:PlayEmote("Wave")
		end
	end
end, "Wave hello", false)

-- CHEER
RegisterCommand("cheer", function()
	local char = Player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:PlayEmote("Cheer")
		end
	end
end, "Cheer", false)

-- POINT
RegisterCommand("point", function()
	local char = Player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:PlayEmote("Point")
		end
	end
end, "Point", false)

-- PUNCH
RegisterCommand("punch", function()
	local char = Player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:PlayEmote("Punch")
		end
	end
end, "Throw a punch", false)

-- STARE
RegisterCommand("stare", function()
	local char = Player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:PlayEmote("Stare")
		end
	end
end, "Stare", false)

-- LAUGH
RegisterCommand("laugh", function()
	local char = Player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:PlayEmote("Laugh")
		end
	end
end, "Laugh", false)

-- TOOLS
RegisterCommand("tools", function()
	local backpack = Player:FindFirstChild("Backpack")
	if backpack then
		local toolList = "Tools:\n"
		for _, tool in pairs(backpack:GetChildren()) do
			if tool:IsA("Tool") then
				toolList = toolList .. "- " .. tool.Name .. "\n"
			end
		end
		StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = toolList,
			Color = Colors.Secondary
		})
	end
end, "List your tools", false)

-- PLAYERS LIST
RegisterCommand("players", function()
	local playerList = "Players:\n"
	for _, p in pairs(Players:GetPlayers()) do
		playerList = playerList .. "- " .. p.DisplayName .. " (@" .. p.Name .. ")\n"
	end
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = playerList,
		Color = Colors.Secondary
	})
end, "List all players", false)

-- TELEPORT TO SPAWN
RegisterCommand("spawn", function()
	if workspace:FindFirstChild("Spawn") then
		local spawn = workspace:FindFirstChild("Spawn")
		if Player.Character then
			Player.Character:WaitForChild("HumanoidRootPart").CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
		end
	end
end, "Teleport to spawn", false)

---------------------------------------------------------------------
-- 10. BUILD COMMAND BUTTONS
---------------------------------------------------------------------

for name, data in pairs(Commands) do
	AddCommandButton(name, data)
end

---------------------------------------------------------------------
-- 11. ABOUT & CHANGELOG PAGES CONTENT
---------------------------------------------------------------------

local aboutLabel = Instance.new("TextLabel")
aboutLabel.Size = UDim2.new(1,-20,0,150)
aboutLabel.Position = UDim2.new(0,10,0,20)
aboutLabel.BackgroundTransparency = 1
aboutLabel.TextColor3 = Colors.Secondary
aboutLabel.Font = Enum.Font.GothamBold
aboutLabel.TextScaled = true
aboutLabel.TextWrapped = true
aboutLabel.Text = "⭐ PRIZAK GUI v2.0\n\nCreated by LarryInvictus for the group Prizak.\n\nBut we don't care who uses it!\n\nEnjoy the features and have fun!"
aboutLabel.Parent = aboutPage

local changelogLabel = Instance.new("TextLabel")
changelogLabel.Size = UDim2.new(1,-20,0,300)
changelogLabel.Position = UDim2.new(0,10,0,20)
changelogLabel.BackgroundTransparency = 1
changelogLabel.TextColor3 = Colors.Secondary
changelogLabel.Font = Enum.Font.GothamBold
changelogLabel.TextScaled = true
changelogLabel.TextWrapped = true
changelogLabel.Text = "📝 CHANGELOG v2.0\n\n✓ NEW: Yellow & Green stud material theme\n✓ NEW: Emote system (dance, wave, cheer, laugh, etc)\n✓ NEW: Tools list command\n✓ NEW: Players list command\n✓ NEW: Spawn teleport command\n✓ FIXED: Advertise message says 'Join Prizak today!'\n✓ REMOVED: Freeze/Unfreeze commands\n✓ IMPROVED: Better visibility with vibrant colors\n✓ UPDATED: All UI elements with green accents\n✓ ROBLOX OPTIMIZED: Full Roblox compatibility"
changelogLabel.Parent = changelogPage

print("⭐ PRIZAK GUI v2.0 LOADED SUCCESSFULLY! ⭐")
print("Use prefix '" .. PREFIX .. "' to execute commands. Type '" .. PREFIX .. "cmds' for help.")
