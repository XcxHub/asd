local NothingLibrary = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NOTHING/main/source.lua'))();

local MarketplaceService = game:GetService("MarketplaceService")
local placeId = game.PlaceId
local gameName = "Unknown Game" -- ค่าตั้งต้น ถ้าดึงชื่อไม่ได้

-- พยายามดึงชื่อเกม
pcall(function()
    gameName = MarketplaceService:GetProductInfo(placeId).Name
end)

local Windows = NothingLibrary.new({
	Title = gameName,
	Description = gameName .. " || Create By Xcx",
	Keybind = Enum.KeyCode.RightControl,
	Logo = 'http://www.roblox.com/asset/?id=115199137841619'
})

local TabFrame = Windows:NewTab({
	Title = "Main",
	Description = "",
	Icon = "rbxassetid://7733960981"
})
local OutherFrame = Windows:NewTab({
	Title = "Outher",
	Description = "",
	Icon = "rbxassetid://7733960981"
})

local FlySection = OutherFrame:NewSection({
	Title = "Fly",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})

FlySection:NewToggle({
	Title = "Fly",
	Default = false,
	Callback = function(tr)
		_G.FlyEnabled = tr
	end,
})

local Section = TabFrame:NewSection({
	Title = "Aimbot",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})

local EspSection = TabFrame:NewSection({
	Title = "Esp",
	Icon = "rbxassetid://7733964719",
	Position = "Right"
})

Section:NewToggle({
	Title = "Aimbot",
	Default = false,
	Callback = function(tr)
		_G.AimbotEnabled = tr
	end,
})
Section:NewDropdown({
	Title = "Aimpart",
	Data = {Head = "Head", HumanoidRootPart = "HumanoidRootPart", UpperTorso = "UpperTorso"},
	Default = "Head",
	Callback = function(a)
		_G.AimPart = a
	end,
})
Section:NewToggle({
	Title = "TeamCheck",
	Default = false,
	Callback = function(tr)
		_G.TeamCheck = tr
	end,
})
Section:NewToggle({
	Title = "Fov",
	Default = false,
	Callback = function(tr)
		_G.FOVCircleEnabled = tr
		_G.FOVCircleVisible = tr
	end,
})
Section:NewToggle({
	Title = "Kill All",
	Default = false,
	Callback = function(tr)
		local KillAll_enabled = tr
	end,
})

Section:NewButton({
	Title = "TargetKill",
	Callback = function()
		local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TargetSelector"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 220, 0, 260)
Frame.Position = UDim2.new(0.03, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Visible = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Select a target"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local Counter = Instance.new("TextLabel", Frame)
Counter.Size = UDim2.new(1, 0, 0, 20)
Counter.Position = UDim2.new(0, 0, 0, 30)
Counter.Text = "Selected target: 0"
Counter.TextColor3 = Color3.fromRGB(180, 180, 180)
Counter.BackgroundTransparency = 1
Counter.Font = Enum.Font.Gotham
Counter.TextSize = 14

local RefreshBtn = Instance.new("TextButton", Frame)
RefreshBtn.Size = UDim2.new(0.94, 0, 0, 30)
RefreshBtn.Position = UDim2.new(0.03, 0, 0, 55)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.Text = "Refresh Name"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 14
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextScaled = true
CloseButton.Parent = Frame

local CloseUICorner = Instance.new("UICorner")
CloseUICorner.CornerRadius = UDim.new(0, 6)
CloseUICorner.Parent = CloseButton

local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Position = UDim2.new(0, 0, 0, 95)
Scroll.Size = UDim2.new(1, 0, 1, -100)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local ScrollList = Instance.new("UIListLayout", Scroll)
ScrollList.Padding = UDim.new(0, 4)
ScrollList.SortOrder = Enum.SortOrder.LayoutOrder

local TargetPlayers = {}

local function updateCounter()
	local count = 0
	for _ in pairs(TargetPlayers) do count += 1 end
	Counter.Text = "Selected target: " .. count
end

local function updatePlayerList()
	for _, child in pairs(Scroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
			local btn = Instance.new("TextButton", Scroll)
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.Text = player.Name
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

			btn.MouseButton1Click:Connect(function()
				if TargetPlayers[player.Name] then
					
					TargetPlayers[player.Name] = nil
					btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

					if player.Character then
						local h = player.Character:FindFirstChild("TargetHighlight")
						if h then h:Destroy() end
					end
				else
					TargetPlayers[player.Name] = true
					btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)

					local function applyHighlight(char)
						if not char:FindFirstChild("TargetHighlight") then
							local highlight = Instance.new("Highlight")
							highlight.Name = "TargetHighlight"
							highlight.FillColor = Color3.fromRGB(255, 0, 0)
							highlight.FillTransparency = 0.5
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							highlight.OutlineTransparency = 0
							highlight.Adornee = char
							highlight.Parent = char
						end
					end

					if player.Character then
						applyHighlight(player.Character)
					end
					player.CharacterAdded:Connect(function(char)
						if TargetPlayers[player.Name] then
							task.wait(0.5)
							applyHighlight(char)
						end
					end)
				end

				updateCounter()
			end)
		end
	end

	task.wait()
	Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollList.AbsoluteContentSize.Y)
end

RefreshBtn.MouseButton1Click:Connect(updatePlayerList)
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

updatePlayerList()
updateCounter()

local isGuiVisible = true
local elementsToTween = {Frame, Title, Counter, RefreshBtn, CloseButton}

local function tweenGUI(open)
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	for _, el in pairs(elementsToTween) do
		if el:IsA("GuiObject") then
			TweenService:Create(el, tweenInfo, {
				BackgroundTransparency = open and 0 or 1
			}):Play()

			if el:IsA("TextLabel") or el:IsA("TextButton") then
				TweenService:Create(el, tweenInfo, {
					TextTransparency = open and 0 or 1
				}):Play()
			end
		end
	end
end

local function toggleGUI()
	if isGuiVisible then
		tweenGUI(false)
		task.delay(0.3, function()
			Frame.Visible = false
		end)
	else
		Frame.Visible = true
		tweenGUI(true)
	end
	isGuiVisible = not isGuiVisible
end

UserInput.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.RightShift and not gp then
		toggleGUI()
	end
end)

CloseButton.MouseButton1Click:Connect(function()
	tweenGUI(false)
	task.delay(0.3, function()
		ScreenGui:Destroy()
	end)
end)

local LastAttack = {}

RunService.RenderStepped:Connect(function()
	if LocalPlayer.Character then
		local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if tool and tool:FindFirstChild("Gun") then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and TargetPlayers[player.Name] then
					local char = player.Character
					if char and char:FindFirstChild("Head") and char:FindFirstChild("HumanoidRootPart") then
						local now = tick()
						local last = LastAttack[player.Name] or 0
						if now - last >= 0.25 then
							LastAttack[player.Name] = now
							task.spawn(function()
								pcall(function()
									getsenv(tool.Gun).DealDamage(char.Head, char.Head, "Melee")
								end)
							end)
						end
					end
				end
			end
		end
	end
end)
	
		end,
})

Section:NewSlider({
	Title = "Fov Size",
	Min = 100,
	Max = 600,
	Default = 100,
	Callback = function(a)
		_G.FOVCircleRadius = a
	end,
})

EspSection:NewTitle('Esp')
EspSection:NewToggle({
	Title = "Esp Skeleton",
	Default = false,
	Callback = function(tr)
		_G.Skeleton = tr
	end,
})
EspSection:NewToggle({
	Title = "Esp Box",
	Default = false,
	Callback = function(tr)
		_G.Box = tr
	end,
})
EspSection:NewToggle({
	Title = "Esp TeamCheck",
	Default = false,
	Callback = function(tr)
		_G.TeamCheckEsp = tr
	end,
})
EspSection:NewToggle({
	Title = "Esp Distance",
	Default = false,
	Callback = function(tr)
		_G.Distance = tr
	end,
})
EspSection:NewToggle({
	Title = "Esp Showname",
	Default = false,
	Callback = function(tr)
		_G.ShowName = tr
	end,
})
EspSection:NewToggle({
	Title = "Esp ShowHealthText",
	Default = false,
	Callback = function(tr)
		_G.ShowHealthText = tr
	end,
})
EspSection:NewToggle({
	Title = "Esp ShowTracer",
	Default = false,
	Callback = function(tr)
		_G.ShowTracer = tr
	end,
})

task.spawn(function()
	-- AimBot
	--// ⚙️ Services
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")

	--// ⚙️ Variables
	local Holding = false
	local LockedTarget = nil

	--// ⚙️ AIMBOT SETTINGS
	_G.AimbotEnabled = false
	_G.AimbotKey = Enum.UserInputType.MouseButton2
	_G.AimPart = "Head"
	_G.TeamCheck = false
	_G.UseClosestByDistance = false -- true = ระยะ 3D ใน FOV / false = ระยะเมาส์ใน FOV
	_G.Sensitivity = 0.05 -- ยิ่งน้อย ยิ่งเร็ว

	--// ⚙️ FOV SETTINGS
	_G.FOVCircleEnabled = false
	_G.FOVCircleRadius = 100
	_G.FOVCircleColor = Color3.fromRGB(255, 0, 0)
	_G.FOVCircleTransparency = 0.5
	_G.FOVCircleFilled = false
	_G.FOVCircleThickness = 1
	_G.FOVCircleVisible = false
	_G.CircleSides = 64

	--// 🎯 Drawing FOV Circle
	local FOVCircle = Drawing.new("Circle")
	FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	FOVCircle.Radius = _G.FOVCircleRadius
	FOVCircle.Color = _G.FOVCircleColor
	FOVCircle.Transparency = 1 - _G.FOVCircleTransparency
	FOVCircle.Filled = _G.FOVCircleFilled
	FOVCircle.NumSides = _G.CircleSides
	FOVCircle.Thickness = _G.FOVCircleThickness
	FOVCircle.Visible = _G.FOVCircleVisible

	--// 🧠 Function : Get Closest Player
	local function GetClosestPlayer()
		if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			return nil
		end

		local myPos = LocalPlayer.Character.HumanoidRootPart.Position
		local mousePos = UserInputService:GetMouseLocation()
		local target = nil
		local shortest = math.huge

		for _, v in ipairs(Players:GetPlayers()) do
			if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
				local humanoid = v.Character.Humanoid
				if humanoid.Health > 0 and (not _G.TeamCheck or v.Team ~= LocalPlayer.Team) then
					local root = v.Character.HumanoidRootPart
					local screenPos, onScreen = Camera:WorldToScreenPoint(root.Position)
					if onScreen then
						local distFromCursor = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

						if distFromCursor <= _G.FOVCircleRadius then
							if _G.UseClosestByDistance then
								local dist3D = (root.Position - myPos).Magnitude
								if dist3D < shortest then
									shortest = dist3D
									target = v
								end
							else
								if distFromCursor < shortest then
									shortest = distFromCursor
									target = v
								end
							end
						end
					end
				end
			end
		end

		return target
	end

	--// 🖱️ Input Events
	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == _G.AimbotKey and _G.AimbotEnabled then
			Holding = true
			LockedTarget = GetClosestPlayer()
		end
	end)

	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == _G.AimbotKey then
			Holding = false
			LockedTarget = nil
		end
	end)

	--// 🔄 Main Loop
	RunService.RenderStepped:Connect(function()
		-- Update FOV Circle
		if _G.FOVCircleEnabled then
			FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
			FOVCircle.Radius = _G.FOVCircleRadius
			FOVCircle.Color = _G.FOVCircleColor
			FOVCircle.Visible = _G.FOVCircleVisible
			FOVCircle.Filled = _G.FOVCircleFilled
			FOVCircle.Thickness = _G.FOVCircleThickness
			FOVCircle.Transparency = 1 - _G.FOVCircleTransparency
			FOVCircle.NumSides = _G.CircleSides
		else
			FOVCircle.Visible = false
		end

		-- Aimbot Tracking
		if Holding and _G.AimbotEnabled and LockedTarget then
			local char = LockedTarget.Character
			if char and char:FindFirstChild(_G.AimPart) and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
				local aimPart = char[_G.AimPart]
				local aimPos = aimPart.Position
				local newCFrame = CFrame.new(Camera.CFrame.Position, aimPos)

				-- ทำให้ลื่นขึ้นโดยใช้ pcall ป้องกัน error
				pcall(function()
					TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
						CFrame = newCFrame
					}):Play()
				end)
			else
				-- ถ้าเป้าตายหรือหายไป ไม่เปลี่ยนเป้าใหม่อัตโนมัติ
				LockedTarget = GetClosestPlayer()
			end
		end
	end)

	local players = game:GetService("Players");
	local run_service = game:GetService("RunService");

	local local_player = players.LocalPlayer;

	local KillAll_enabled = false;

	run_service.RenderStepped:Connect(function()
		if not KillAll_enabled then return end

		if (local_player.Character) then
			local get_tool = local_player.Character:FindFirstChildOfClass("Tool");
		
			if (get_tool and get_tool:FindFirstChild("Gun")) then
				for _, player in players:GetPlayers() do
					local character = player.Character;
					
					if (character) then
						local enemy_head = character.Head;
						local root_part = character.HumanoidRootPart;

						if (root_part) and KillAll_enabled then
							getsenv(get_tool.Gun).DealDamage(enemy_head, enemy_head, "Melee");
						end
					end
				end
			end
		end
	end)
	-- 🔧 Global Settings
	_G.Skeleton = false
	_G.Box = false
	_G.Distance = false
	_G.ShowName = false
	_G.ShowHealthText = false
	_G.ShowTracer = false
	_G.Color = Color3.fromRGB(255, 255, 255)
	_G.TeamCheckEsp = false
	_G.RefreshRate = 0.03

	-- 🚀 Services
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera
	local ESP = {}

	-- 🧱 Drawing Helpers
	local function newLine()
		local line = Drawing.new("Line")
		line.Thickness = 1
		line.Transparency = 1
		line.Visible = false
		line.Color = _G.Color
		return line
	end

	local function newText()
		local txt = Drawing.new("Text")
		txt.Size = 16
		txt.Center = true
		txt.Outline = true
		txt.OutlineColor = Color3.new(0, 0, 0)
		txt.Font = 2
		txt.Color = _G.Color
		txt.Visible = false
		return txt
	end

	local function newBox()
		local box = {}
		for i = 1, 4 do
			box[i] = newLine()
		end
		return box
	end

	local function toScreen(pos)
		local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
		return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
	end

	local function getBones(character)
		local isR15 = character:FindFirstChild("UpperTorso") ~= nil
		if isR15 then
			return {
				{"Head", "UpperTorso"},
				{"UpperTorso", "LowerTorso"},
				{"UpperTorso", "LeftUpperArm"},
				{"UpperTorso", "RightUpperArm"},
				{"LeftUpperArm", "LeftLowerArm"},
				{"RightUpperArm", "RightLowerArm"},
				{"LeftLowerArm", "LeftHand"},
				{"RightLowerArm", "RightHand"},
				{"LowerTorso", "LeftUpperLeg"},
				{"LowerTorso", "RightUpperLeg"},
				{"LeftUpperLeg", "LeftLowerLeg"},
				{"RightUpperLeg", "RightLowerLeg"},
				{"LeftLowerLeg", "LeftFoot"},
				{"RightLowerLeg", "RightFoot"},
			}
		else
			return {
				{"Head", "Torso"},
				{"Torso", "Left Arm"},
				{"Torso", "Right Arm"},
				{"Torso", "Left Leg"},
				{"Torso", "Right Leg"},
			}
		end
	end

	-- 🔄 Main ESP Update Loop
	local function updateESP()
		for _, player in pairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end
			if _G.TeamCheckEsp and player.Team == LocalPlayer.Team then continue end

			local char = player.Character
			if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then
				if ESP[player] then
					for _, v in pairs(ESP[player]) do
						if typeof(v) == "table" then
							for _, obj in pairs(v) do if obj then obj.Visible = false end end
						elseif typeof(v) == "Instance" then
							v.Visible = false
						end
					end
				end
				continue
			end

			local rootPart = char:FindFirstChild("HumanoidRootPart")
			local pos, onScreen, distance = toScreen(rootPart.Position)

			-- ✨ Create ESP objects if not exists
			if not ESP[player] then
				ESP[player] = {
					Skeleton = {},
					Box = newBox(),
					Distance = newText(),
					Name = newText(),
					HealthText = newText(),
					HealthBar = { Background = newLine(), Bar = newLine() },
					Tracer = newLine()
				}

				-- ล้าง ESP เมื่อ Character ถูกลบ
				player.CharacterRemoving:Connect(function()
					if ESP[player] then
						for _, v in pairs(ESP[player]) do
							if typeof(v) == "table" then
								for _, obj in pairs(v) do if obj then obj.Visible = false end end
							elseif typeof(v) == "Instance" then
								v.Visible = false
							end
						end
					end
				end)
			end

			-- 🦴 Skeleton
			if _G.Skeleton then
				local bones = getBones(char)
				if #ESP[player].Skeleton ~= #bones then
					for _, line in pairs(ESP[player].Skeleton) do if line then line:Remove() end end
					ESP[player].Skeleton = {}
					for _ = 1, #bones do table.insert(ESP[player].Skeleton, newLine()) end
				end
				for i, bone in ipairs(bones) do
					local a = char:FindFirstChild(bone[1])
					local b = char:FindFirstChild(bone[2])
					local line = ESP[player].Skeleton[i]
					if a and b then
						local aPos, aOnScreen = toScreen(a.Position)
						local bPos, bOnScreen = toScreen(b.Position)
						if aOnScreen and bOnScreen then
							line.From = aPos
							line.To = bPos
							line.Visible = true
							line.Color = _G.Color
						else
							line.Visible = false
						end
					else
						line.Visible = false
					end
				end
			else
				for _, line in pairs(ESP[player].Skeleton) do if line then line.Visible = false end end
			end

			-- 🔳 Box + HealthBar
			local head = char:FindFirstChild("Head")
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if _G.Box and head and humanoid then
				local headPos, hOnScreen = toScreen(head.Position + Vector3.new(0, 0.5, 0))
				local footPos, fOnScreen = toScreen(rootPart.Position - Vector3.new(0, 3, 0))
				local box = ESP[player].Box

				if hOnScreen and fOnScreen then
					local height = math.abs(headPos.Y - footPos.Y)
					local width = height / 2
					local topLeft = Vector2.new(headPos.X - width / 2, headPos.Y)
					local topRight = Vector2.new(headPos.X + width / 2, headPos.Y)
					local bottomLeft = Vector2.new(headPos.X - width / 2, headPos.Y + height)
					local bottomRight = Vector2.new(headPos.X + width / 2, headPos.Y + height)

					box[1].From, box[1].To = topLeft, topRight
					box[2].From, box[2].To = topRight, bottomRight
					box[3].From, box[3].To = bottomRight, bottomLeft
					box[4].From, box[4].To = bottomLeft, topLeft
					for _, line in pairs(box) do line.Visible = true line.Color = _G.Color end

					-- HealthBar
					local hpPercent = math.clamp(humanoid.Health, 0, humanoid.MaxHealth) / humanoid.MaxHealth
					local barHeight = height
					local barWidth = 2
					local x = headPos.X - width / 2 - 6
					local y = headPos.Y

					local bg = ESP[player].HealthBar.Background
					local fg = ESP[player].HealthBar.Bar

					bg.From = Vector2.new(x, y)
					bg.To = Vector2.new(x, y + barHeight)
					bg.Color = Color3.new(0, 0, 0)
					bg.Thickness = barWidth
					bg.Visible = true

					fg.From = Vector2.new(x, y + (1 - hpPercent) * barHeight)
					fg.To = Vector2.new(x, y + barHeight)
					fg.Color = Color3.fromRGB(0, 255, 0)
					fg.Thickness = barWidth
					fg.Visible = true
				else
					for _, line in pairs(box) do line.Visible = false end
					ESP[player].HealthBar.Background.Visible = false
					ESP[player].HealthBar.Bar.Visible = false
				end
			else
				for _, line in pairs(ESP[player].Box) do line.Visible = false end
				ESP[player].HealthBar.Background.Visible = false
				ESP[player].HealthBar.Bar.Visible = false
			end

			-- 📏 Distance
			if _G.Distance and onScreen then
				ESP[player].Distance.Position = Vector2.new(pos.X, pos.Y + 30)
				ESP[player].Distance.Text = string.format("[%.1fm]", distance)
				ESP[player].Distance.Color = _G.Color
				ESP[player].Distance.Visible = true
			else
				ESP[player].Distance.Visible = false
			end

			-- 🧑 Name
			if _G.ShowName and onScreen then
				ESP[player].Name.Text = player.Name
				ESP[player].Name.Position = Vector2.new(pos.X, pos.Y - 15)
				ESP[player].Name.Color = _G.Color
				ESP[player].Name.Visible = true
			else
				ESP[player].Name.Visible = false
			end

			-- ❤️ Health %
			if _G.ShowHealthText and onScreen then
				ESP[player].HealthText.Text = string.format("%.0f%%", (humanoid.Health / humanoid.MaxHealth) * 100)
				ESP[player].HealthText.Position = Vector2.new(pos.X, pos.Y + 45)
				ESP[player].HealthText.Color = _G.Color
				ESP[player].HealthText.Visible = true
			else
				ESP[player].HealthText.Visible = false
			end

			-- 📍 Tracer
			if _G.ShowTracer and onScreen then
				local tracer = ESP[player].Tracer
				tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
				tracer.To = pos
				tracer.Color = _G.Color
				tracer.Visible = true
			else
				ESP[player].Tracer.Visible = false
			end
		end
	end

	-- 🔁 Main Loop
	task.spawn(function()
		while task.wait(_G.RefreshRate) do
			local success, err = pcall(updateESP)
			if not success then warn("[ESP ERROR]:", err) end
		end
	end)

	-- 🧼 Clear ESP on player leave
	Players.PlayerRemoving:Connect(function(player)
		if ESP[player] then
			for _, line in pairs(ESP[player].Skeleton or {}) do if line then line:Remove() end end
			for _, line in pairs(ESP[player].Box or {}) do if line then line:Remove() end end
			if ESP[player].Distance then ESP[player].Distance:Remove() end
			if ESP[player].Name then ESP[player].Name:Remove() end
			if ESP[player].HealthText then ESP[player].HealthText:Remove() end
			if ESP[player].HealthBar then
				if ESP[player].HealthBar.Background then ESP[player].HealthBar.Background:Remove() end
				if ESP[player].HealthBar.Bar then ESP[player].HealthBar.Bar:Remove() end
			end
			if ESP[player].Tracer then ESP[player].Tracer:Remove() end
			ESP[player] = nil
		end
	end)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = game.Players.LocalPlayer

    _G.FlyEnabled = false -- ควบคุมการเปิด/ปิดระบบบินจากภายนอก

    local flying = false
    local flySpeed = 50

    local velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    velocity.Velocity = Vector3.new(0, 0, 0)

    local controls = {
        W = false,
        A = false,
        S = false,
        D = false,
        Space = false,
        LeftShift = false,
        RightShift = false,
    }

    local Character
    local Humanoid
    local HRP

    local function updateCharacterRefs()
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        Humanoid = Character:WaitForChild("Humanoid")
        HRP = Character:WaitForChild("HumanoidRootPart")
    end

    -- ตรวจจับการกดปุ่มควบคุม
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        local keyName = input.KeyCode.Name
        if controls[keyName] ~= nil then
            controls[keyName] = true
        end
    end

    local function onInputEnded(input)
        local keyName = input.KeyCode.Name
        if controls[keyName] ~= nil then
            controls[keyName] = false
        end
    end

    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputEnded:Connect(onInputEnded)

    RunService.RenderStepped:Connect(function()
        -- ตรวจสอบสถานะ FlyEnabled
        if _G.FlyEnabled and not flying then
            -- เริ่มบิน
            flying = true
            updateCharacterRefs()
            Humanoid.PlatformStand = true
            velocity.Parent = HRP
        elseif not _G.FlyEnabled and flying then
            -- หยุดบิน
            flying = false
            if HRP and Humanoid then
                velocity.Parent = nil
                Humanoid.PlatformStand = false
                HRP.Velocity = Vector3.new(0, 0, 0)
            end
        end

        -- ถ้ายังไม่บินไม่ต้องอัปเดต
        if not flying then return end

        local cam = workspace.CurrentCamera
        local direction = Vector3.new(0, 0, 0)

        if controls.W then
            direction += cam.CFrame.LookVector
        end
        if controls.S then
            direction -= cam.CFrame.LookVector
        end
        if controls.A then
            direction -= cam.CFrame.RightVector
        end
        if controls.D then
            direction += cam.CFrame.RightVector
        end
        if controls.Space then
            direction += Vector3.new(0, 1, 0)
        end
        if controls.LeftShift or controls.RightShift then
            direction -= Vector3.new(0, 1, 0)
        end

        if direction.Magnitude > 0 then
            velocity.Velocity = direction.Unit * flySpeed
        else
            velocity.Velocity = Vector3.new(0, 0, 0)
        end

        -- ปิดการชนกันเพื่อบินทะลุ
        if Character then
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end)
