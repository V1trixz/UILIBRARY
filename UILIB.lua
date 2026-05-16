local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

local UILib = {}

local Window = {}
Window.__index = Window

local Card = {}
Card.__index = Card

local Tab = {}
Tab.__index = Tab

local Loader = {}
Loader.__index = Loader

local Themes = {
	Green = {
		Background = Color3.fromRGB(9, 43, 34),
		GradientA = Color3.fromRGB(28, 126, 76),
		GradientB = Color3.fromRGB(4, 13, 18),
		Stroke = Color3.fromRGB(36, 148, 97),
		TileA = Color3.fromRGB(15, 56, 43),
		TileB = Color3.fromRGB(5, 18, 22),
	},
	Amber = {
		Background = Color3.fromRGB(81, 50, 12),
		GradientA = Color3.fromRGB(190, 122, 20),
		GradientB = Color3.fromRGB(30, 17, 10),
		Stroke = Color3.fromRGB(199, 132, 31),
		TileA = Color3.fromRGB(96, 59, 18),
		TileB = Color3.fromRGB(44, 28, 15),
	},
	Purple = {
		Background = Color3.fromRGB(46, 14, 60),
		GradientA = Color3.fromRGB(116, 38, 132),
		GradientB = Color3.fromRGB(15, 11, 30),
		Stroke = Color3.fromRGB(142, 58, 162),
		TileA = Color3.fromRGB(46, 24, 55),
		TileB = Color3.fromRGB(21, 14, 30),
	},
	Red = {
		Background = Color3.fromRGB(62, 16, 22),
		GradientA = Color3.fromRGB(158, 43, 55),
		GradientB = Color3.fromRGB(18, 9, 14),
		Stroke = Color3.fromRGB(190, 61, 73),
		TileA = Color3.fromRGB(72, 24, 31),
		TileB = Color3.fromRGB(28, 13, 18),
	},
	Blue = {
		Background = Color3.fromRGB(11, 31, 58),
		GradientA = Color3.fromRGB(35, 91, 156),
		GradientB = Color3.fromRGB(5, 12, 22),
		Stroke = Color3.fromRGB(65, 132, 205),
		TileA = Color3.fromRGB(20, 44, 75),
		TileB = Color3.fromRGB(7, 16, 27),
	},
	Profile = {
		Background = Color3.fromRGB(11, 29, 38),
		GradientA = Color3.fromRGB(21, 62, 75),
		GradientB = Color3.fromRGB(3, 5, 8),
		Stroke = Color3.fromRGB(24, 68, 81),
		TileA = Color3.fromRGB(11, 29, 38),
		TileB = Color3.fromRGB(3, 5, 8),
	},
}

local Colors = {
	Window = Color3.fromRGB(4, 10, 17),
	Top = Color3.fromRGB(8, 12, 17),
	Search = Color3.fromRGB(15, 15, 16),
	Text = Color3.fromRGB(250, 251, 255),
	Muted = Color3.fromRGB(145, 151, 160),
	Soft = Color3.fromRGB(185, 190, 198),
}

local LucideIcons = {
	aimbot = { Image = "rbxassetid://16898788248", RectOffset = Vector2.new(257, 0), RectSize = Vector2.new(256, 256) },
	configuration = { Image = "rbxassetid://16898735040", RectOffset = Vector2.new(257, 257), RectSize = Vector2.new(256, 256) },
	eye = { Image = "rbxassetid://16898669897", RectOffset = Vector2.new(0, 0), RectSize = Vector2.new(256, 256) },
	home = { Image = "rbxassetid://16898673271", RectOffset = Vector2.new(257, 514), RectSize = Vector2.new(256, 256) },
	key = { Image = "rbxassetid://16898673616", RectOffset = Vector2.new(514, 257), RectSize = Vector2.new(256, 256) },
	lock = { Image = "rbxassetid://16898789451", RectOffset = Vector2.new(514, 514), RectSize = Vector2.new(256, 256) },
	login = { Image = "rbxassetid://16898674825", RectOffset = Vector2.new(514, 0), RectSize = Vector2.new(256, 256) },
	menu = { Image = "rbxassetid://16898675673", RectOffset = Vector2.new(514, 257), RectSize = Vector2.new(256, 256) },
	server = { Image = "rbxassetid://16898734421", RectOffset = Vector2.new(257, 0), RectSize = Vector2.new(256, 256) },
	settings = { Image = "rbxassetid://16898734421", RectOffset = Vector2.new(514, 0), RectSize = Vector2.new(256, 256) },
	target = { Image = "rbxassetid://16898788248", RectOffset = Vector2.new(257, 0), RectSize = Vector2.new(256, 256) },
	user = { Image = "rbxassetid://16898790259", RectOffset = Vector2.new(0, 0), RectSize = Vector2.new(256, 256) },
}

local IconAliases = {
	aim = "target",
	cog = "settings",
	config = "configuration",
	esp = "eye",
	gear = "settings",
	sliders = "configuration",
}

local function create(className, props)
	local object = Instance.new(className)
	for key, value in pairs(props or {}) do
		object[key] = value
	end
	return object
end

local function addCorner(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = object
	return corner
end

local function addStroke(object, color, transparency, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Transparency = transparency or 0.7
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = object
	return stroke
end

local function addGradient(object, first, second, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, first),
		ColorSequenceKeypoint.new(1, second),
	})
	gradient.Rotation = rotation or 0
	gradient.Parent = object
	return gradient
end

local function makeLabel(parent, props)
	local label = create("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = props.Font or Enum.Font.Gotham,
		Text = props.Text or "",
		TextColor3 = props.Color or Colors.Text,
		TextSize = props.Size or 12,
		TextTransparency = props.Transparency or 0,
		TextXAlignment = props.XAlignment or Enum.TextXAlignment.Left,
		TextYAlignment = props.YAlignment or Enum.TextYAlignment.Top,
		TextWrapped = props.Wrapped or false,
		TextTruncate = props.Truncate or Enum.TextTruncate.AtEnd,
		Position = props.Position or UDim2.fromOffset(0, 0),
		Size = props.BoxSize or UDim2.fromOffset(100, 20),
		ZIndex = props.ZIndex or 1,
		Parent = parent,
	})
	return label
end

local function makeLine(parent, x, y, width, height, color)
	local line = create("Frame", {
		BackgroundColor3 = color,
		BackgroundTransparency = 0.14,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(width, height),
		ZIndex = parent.ZIndex + 1,
		Parent = parent,
	})
	addCorner(line, math.max(1, math.floor(height / 2)))
	return line
end

local function makeHamburger(parent)
	local button = create("TextButton", {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		Position = UDim2.fromOffset(14, 15),
		Size = UDim2.fromOffset(25, 25),
		ZIndex = 8,
		Parent = parent,
	})

	for index = 0, 2 do
		makeLine(button, 5, 6 + (index * 6), 14, 2, Color3.fromRGB(154, 160, 166))
	end

	return button
end

local function resolveIcon(icon)
	if type(icon) == "table" then
		return icon
	end

	local raw = tostring(icon or "target")
	local key = string.lower(raw)
	key = IconAliases[key] or key

	if string.find(key, "rbxasset", 1, true) then
		return { Image = raw }
	end

	if tonumber(raw) then
		return { Image = "rbxassetid://" .. raw }
	end

	return LucideIcons[key]
end

local function makeSearchIcon(parent)
	local circle = create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(11, 9),
		Size = UDim2.fromOffset(9, 9),
		ZIndex = parent.ZIndex + 2,
		Parent = parent,
	})
	addCorner(circle, 9)
	addStroke(circle, Color3.fromRGB(134, 140, 148), 0.25, 1.4)

	local handle = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(134, 140, 148),
		BackgroundTransparency = 0.25,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(18, 18),
		Rotation = 45,
		Size = UDim2.fromOffset(7, 1),
		ZIndex = parent.ZIndex + 2,
		Parent = parent,
	})
	addCorner(handle, 1)
end

local function makeControlButton(parent, position, kind)
	local button = create("TextButton", {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		Position = position,
		Size = UDim2.fromOffset(26, 26),
		ZIndex = 8,
		Parent = parent,
	})

	if kind == "minimize" then
		makeLine(button, 9, 13, 8, 2, Color3.fromRGB(170, 177, 184))
	else
		local back = create("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(8, 8),
			Size = UDim2.fromOffset(8, 8),
			ZIndex = button.ZIndex + 1,
			Parent = button,
		})
		addCorner(back, 2)
		addStroke(back, Color3.fromRGB(170, 177, 184), 0.42, 1.2)

		local front = create("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(11, 5),
			Size = UDim2.fromOffset(8, 8),
			ZIndex = button.ZIndex + 2,
			Parent = button,
		})
		addCorner(front, 2)
		addStroke(front, Color3.fromRGB(170, 177, 184), 0.2, 1.2)
	end

	return button
end

local function clearChildren(parent)
	for _, child in ipairs(parent:GetChildren()) do
		if not child:IsA("UICorner") and not child:IsA("UIStroke") and not child:IsA("UIGradient") and not child:IsA("UIPadding") then
			child:Destroy()
		end
	end
end

local function iconLine(parent, x, y, width, height, color, rotation)
	local line = create("Frame", {
		BackgroundColor3 = color,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(x, y),
		Rotation = rotation or 0,
		Size = UDim2.fromOffset(width, height),
		ZIndex = parent.ZIndex + 1,
		Parent = parent,
	})
	addCorner(line, math.max(1, math.floor(height / 2)))
	return line
end

local function iconStroke(parent, x, y, width, height, color, radius, thickness)
	local frame = create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(width, height),
		ZIndex = parent.ZIndex + 1,
		Parent = parent,
	})
	addCorner(frame, radius or 4)
	addStroke(frame, color, 0, thickness or 1.4)
	return frame
end

local function drawIcon(parent, kind, color)
	clearChildren(parent)

	local asset = resolveIcon(kind)
	if asset and asset.Image then
		create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = asset.Image,
			ImageColor3 = color or Colors.Text,
			ImageRectOffset = asset.RectOffset or Vector2.new(0, 0),
			ImageRectSize = asset.RectSize or Vector2.new(0, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(22, 22),
			ZIndex = parent.ZIndex + 2,
			Parent = parent,
		})
		return
	end

	kind = string.lower(tostring(kind or "target"))
	color = color or Colors.Text

	if kind == "home" then
		iconLine(parent, 7, 10, 10, 2, color, -38)
		iconLine(parent, 15, 10, 10, 2, color, 38)
		iconStroke(parent, 9, 14, 14, 11, color, 3, 1.35)
		iconLine(parent, 14, 19, 4, 6, color, 0)
	elseif kind == "aimbot" or kind == "aim" or kind == "target" then
		iconStroke(parent, 7, 7, 18, 18, color, 18, 1.35)
		iconLine(parent, 3, 15, 9, 2, color, 0)
		iconLine(parent, 20, 15, 9, 2, color, 0)
		iconLine(parent, 15, 3, 2, 9, color, 0)
		iconLine(parent, 15, 20, 2, 9, color, 0)
		local dot = create("Frame", {
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(14, 14),
			Size = UDim2.fromOffset(4, 4),
			ZIndex = parent.ZIndex + 2,
			Parent = parent,
		})
		addCorner(dot, 4)
	elseif kind == "esp" or kind == "eye" then
		iconStroke(parent, 5, 10, 22, 13, color, 13, 1.35)
		local pupil = create("Frame", {
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(13, 13),
			Size = UDim2.fromOffset(6, 6),
			ZIndex = parent.ZIndex + 2,
			Parent = parent,
		})
		addCorner(pupil, 6)
	elseif kind == "settings" or kind == "gear" then
		iconStroke(parent, 10, 10, 12, 12, color, 12, 1.35)
		iconStroke(parent, 13, 13, 6, 6, color, 6, 1.2)
		iconLine(parent, 15, 4, 2, 6, color, 0)
		iconLine(parent, 15, 22, 2, 6, color, 0)
		iconLine(parent, 4, 15, 6, 2, color, 0)
		iconLine(parent, 22, 15, 6, 2, color, 0)
		iconLine(parent, 7, 8, 5, 2, color, 45)
		iconLine(parent, 20, 22, 5, 2, color, 45)
	elseif kind == "server" then
		iconStroke(parent, 7, 7, 18, 7, color, 3, 1.25)
		iconStroke(parent, 7, 18, 18, 7, color, 3, 1.25)
		iconLine(parent, 10, 10, 3, 2, color, 0)
		iconLine(parent, 10, 21, 3, 2, color, 0)
	else
		iconStroke(parent, 7, 7, 18, 18, color, 18, 1.35)
		iconLine(parent, 9, 16, 14, 2, color, 0)
		iconLine(parent, 16, 9, 2, 14, color, 0)
	end
end

local function makeChevron(parent, color)
	local holder = create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -24, 0, 14),
		Size = UDim2.fromOffset(16, 16),
		ZIndex = parent.ZIndex + 1,
		Parent = parent,
	})

	iconLine(holder, 3, 7, 7, 2, color, 35)
	iconLine(holder, 8, 7, 7, 2, color, -35)

	return holder
end

local function getPlayerGui()
	if LocalPlayer then
		return LocalPlayer:WaitForChild("PlayerGui")
	end
	return nil
end

local function readClipboardSetter()
	local ok, env = pcall(getfenv)
	if ok and type(env) == "table" then
		if type(env.setclipboard) == "function" then
			return env.setclipboard
		end

		if type(env.toclipboard) == "function" then
			return env.toclipboard
		end

		if type(env.syn) == "table" and type(env.syn.set_clipboard) == "function" then
			return env.syn.set_clipboard
		end

		if type(env.Clipboard) == "table" and type(env.Clipboard.set) == "function" then
			return env.Clipboard.set
		end
	end

	if type(setclipboard) == "function" then
		return setclipboard
	end

	return nil
end

local function normalizeKeyCode(key, fallback)
	if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
		return key
	end

	if type(key) == "string" then
		local clean = string.gsub(key, "%s+", "")
		local ok, result = pcall(function()
			return Enum.KeyCode[clean]
		end)

		if ok and result then
			return result
		end
	end

	return fallback
end

local function keyCodeName(key)
	if typeof(key) == "EnumItem" then
		return key.Name
	end

	return tostring(key or "None")
end

local function getExecutorName()
	local ok, env = pcall(getfenv)
	if not ok or type(env) ~= "table" then
		return game:GetService("RunService"):IsStudio() and "Roblox Studio" or "Unknown"
	end

	local detectorNames = {
		"identifyexecutor",
		"getexecutorname",
	}

	for _, name in ipairs(detectorNames) do
		local detector = env[name] or getfenv()[name]
		if type(detector) == "function" then
			local success, executor = pcall(detector)
			if success and executor and tostring(executor) ~= "" then
				return tostring(executor)
			end
		end
	end

	local markers = {
		{ Key = "syn", Name = "Synapse X" },
		{ Key = "KRNL_LOADED", Name = "KRNL" },
		{ Key = "is_sirhurt_closure", Name = "SirHurt" },
		{ Key = "secure_load", Name = "Sentinel" },
		{ Key = "fluxus", Name = "Fluxus" },
		{ Key = "isexecutorclosure", Name = "Executor" },
	}

	for _, marker in ipairs(markers) do
		if env[marker.Key] ~= nil then
			return marker.Name
		end
	end

	return game:GetService("RunService"):IsStudio() and "Roblox Studio" or "Unknown"
end

local function safeTween(object, info, goal)
	local tween = TweenService:Create(object, info, goal)
	tween:Play()
	return tween
end

local function formatDuration(seconds)
	seconds = math.max(0, math.floor(seconds))
	if seconds < 60 then
		return tostring(seconds) .. "s"
	end
	if seconds < 3600 then
		return tostring(math.floor(seconds / 60)) .. "m"
	end
	return tostring(math.floor(seconds / 3600)) .. "h " .. tostring(math.floor((seconds % 3600) / 60)) .. "m"
end

local function readPing()
	local ok, ping = pcall(function()
		local item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
		if item then
			return math.floor(item:GetValue()) .. " ms"
		end
		return "93.1015 (85VC)"
	end)

	if ok then
		return ping
	end

	return "93.1015 (85VC)"
end

local function makeDraggable(handle, target)
	local dragging = false
	local dragStart = nil
	local startPosition = nil

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = target.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart
		target.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)
end

function Window:_registerSearch(instance, text)
	table.insert(self.SearchIndex, {
		Instance = instance,
		Text = string.lower(tostring(text or "")),
	})
end

function Window:_filterSearch(query)
	query = string.lower(query or "")

	for _, item in ipairs(self.SearchIndex) do
		item.Instance.Visible = query == "" or string.find(item.Text, query, 1, true) ~= nil
	end
end

function Window:SetTitle(title, subtitle)
	if title and self.TitleLabel then
		self.TitleLabel.Text = tostring(title)
	end

	if subtitle and self.SubtitleLabel then
		self.SubtitleLabel.Text = tostring(subtitle)
	end
end

function Window:_closeDropdown()
	if self.OpenDropdown then
		self.OpenDropdown:Destroy()
		self.OpenDropdown = nil
	end

	if self.OpenDropdownChevron then
		safeTween(self.OpenDropdownChevron, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Rotation = 0,
		})
		self.OpenDropdownChevron = nil
	end
end

function Window:_showDropdown(anchor, choices, selected, callback)
	self:_closeDropdown()

	local mainPosition = self.Main.AbsolutePosition
	local anchorPosition = anchor.AbsolutePosition
	local anchorSize = anchor.AbsoluteSize
	local visibleCount = math.max(1, math.min(#choices, 6))
	local popupWidth = math.max(anchorSize.X, 174)
	local popupHeight = visibleCount * 32 + 10
	local localX = anchorPosition.X - mainPosition.X
	local localY = anchorPosition.Y - mainPosition.Y + anchorSize.Y + 7
	local opensUp = localY + popupHeight > self.Main.AbsoluteSize.Y - 18

	if opensUp then
		localY = anchorPosition.Y - mainPosition.Y - popupHeight - 7
	end

	local popup = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 12, 17),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Name = "Dropdown",
		Position = UDim2.fromOffset(localX, opensUp and localY + popupHeight or localY),
		Size = UDim2.fromOffset(popupWidth, 0),
		ZIndex = 40,
		Parent = self.Main,
	})
	addCorner(popup, 8)
	addStroke(popup, Color3.fromRGB(255, 255, 255), 0.84, 1)
	addGradient(popup, Color3.fromRGB(21, 32, 38), Color3.fromRGB(7, 9, 13), 15)

	local list = create("ScrollingFrame", {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		ScrollBarImageColor3 = Color3.fromRGB(81, 96, 106),
		ScrollBarThickness = #choices > 6 and 3 or 0,
		Position = UDim2.fromOffset(5, 5),
		Size = UDim2.new(1, -10, 1, -10),
		ZIndex = 41,
		Parent = popup,
	})

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 3)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = list

	local rows = #choices > 0 and choices or { "No options" }

	for index, choice in ipairs(rows) do
		local text = tostring(choice)
		local isSelected = text == selected
		local canClick = #choices > 0
		local option = create("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = isSelected and Color3.fromRGB(21, 65, 49) or Color3.fromRGB(14, 19, 24),
			BackgroundTransparency = isSelected and 0.04 or 0.35,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			LayoutOrder = index,
			Text = "   " .. text,
			TextColor3 = canClick and Colors.Text or Color3.fromRGB(132, 140, 149),
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 29),
			ZIndex = 42,
			Parent = list,
		})
		addCorner(option, 6)

		local marker = create("Frame", {
			BackgroundColor3 = self.ActiveTab and self.ActiveTab.Theme.Stroke or Color3.fromRGB(22, 91, 66),
			BackgroundTransparency = isSelected and 0 or 1,
			BorderSizePixel = 0,
			Position = UDim2.new(1, -19, 0, 10),
			Size = UDim2.fromOffset(8, 8),
			ZIndex = 43,
			Parent = option,
		})
		addCorner(marker, 8)

		option.MouseEnter:Connect(function()
			if canClick then
				safeTween(option, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = isSelected and 0.02 or 0.12,
				})
			end
		end)

		option.MouseLeave:Connect(function()
			if canClick then
				safeTween(option, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = isSelected and 0.04 or 0.35,
				})
			end
		end)

		if canClick then
			option.MouseButton1Click:Connect(function()
				self:_closeDropdown()
				if callback then
					callback(text)
				end
			end)
		end
	end

	safeTween(popup, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromOffset(localX, localY),
		Size = UDim2.fromOffset(popupWidth, popupHeight),
	})

	self.OpenDropdown = popup
	return popup
end

function Window:_layoutNotifications()
	local bottom = self.NotificationBottom or 84
	local gap = 9

	for index, toast in ipairs(self.Notifications) do
		if toast.Parent and not toast:GetAttribute("Closing") then
			local height = toast.Size.Y.Offset
			local target = UDim2.new(1, -18, 1, -bottom - ((index - 1) * (height + gap)))
			safeTween(toast, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = target,
			})
		end
	end
end

function Window:_dismissNotification(toast)
	if not toast or not toast.Parent or toast:GetAttribute("Closing") then
		return
	end

	toast:SetAttribute("Closing", true)

	for index, current in ipairs(self.Notifications) do
		if current == toast then
			table.remove(self.Notifications, index)
			break
		end
	end

	local tween = safeTween(toast, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 280, toast.Position.Y.Scale, toast.Position.Y.Offset),
	})

	for _, descendant in ipairs(toast:GetDescendants()) do
		if descendant:IsA("TextLabel") then
			safeTween(descendant, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				TextTransparency = 1,
			})
		elseif descendant:IsA("Frame") then
			safeTween(descendant, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				BackgroundTransparency = 1,
			})
		elseif descendant:IsA("UIStroke") then
			safeTween(descendant, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Transparency = 1,
			})
		end
	end

	self:_layoutNotifications()
	tween.Completed:Wait()

	if toast.Parent then
		toast:Destroy()
	end
end

function Window:Notify(message)
	local maxNotifications = self.MaxNotifications or 5

	while #self.Notifications >= maxNotifications do
		self:_dismissNotification(self.Notifications[1])
	end

	local toast = create("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = Color3.fromRGB(9, 14, 19),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.new(1, 280, 1, -(self.NotificationBottom or 84)),
		Size = UDim2.fromOffset(278, 46),
		ZIndex = 90,
		Parent = self.NotificationHost,
	})
	addCorner(toast, 8)
	addStroke(toast, Color3.fromRGB(255, 255, 255), 0.86, 1)
	addGradient(toast, Color3.fromRGB(15, 28, 34), Color3.fromRGB(8, 10, 14), 12)

	makeLabel(toast, {
		Text = tostring(message),
		Color = Color3.fromRGB(230, 235, 242),
		Font = Enum.Font.GothamMedium,
		Size = 12,
		Wrapped = true,
		Position = UDim2.fromOffset(13, 8),
		BoxSize = UDim2.new(1, -26, 1, -15),
		ZIndex = 92,
	})

	table.insert(self.Notifications, toast)
	self:_layoutNotifications()

	safeTween(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.04,
	})

	task.delay(self.NotificationDuration or 3, function()
		if toast.Parent then
			self:_dismissNotification(toast)
		end
	end)
end

function Window:Copy(text)
	local clipboard = readClipboardSetter()
	if clipboard then
		local ok = pcall(clipboard, tostring(text or ""))
		if ok then
			self:Notify("Copied to clipboard")
			return true
		end
	end

	self:Notify("Clipboard unavailable")
	return false
end

function Window:Destroy()
	if self.ToggleConnection then
		self.ToggleConnection:Disconnect()
		self.ToggleConnection = nil
	end

	if self.Gui then
		self.Gui:Destroy()
	end
end

function Window:Unload()
	self:Destroy()
end

function Window:SetVisible(visible)
	if not self.Gui then
		return false
	end

	self.Visible = visible == true
	self.Gui.Enabled = self.Visible
	return self.Visible
end

function Window:Toggle()
	return self:SetVisible(not self.Visible)
end

function Window:SetToggleKey(key)
	if key == false or key == nil then
		self.ToggleKey = false
		return false
	end

	local nextKey = normalizeKeyCode(key, self.ToggleKey or Enum.KeyCode.RightControl)
	self.ToggleKey = nextKey
	return nextKey
end

function Window:GetToggleKey()
	return self.ToggleKey
end

function Window:CreateSidebar(options)
	options = options or {}

	if self.Sidebar then
		return self.Sidebar
	end

	local width = options.Width or self.SidebarWidth or 64
	self.SidebarWidth = width

	local sidebar = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(7, 13, 18),
		BackgroundTransparency = 0.18,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Name = "Sidebar",
		Position = UDim2.fromOffset(14, 70),
		Size = UDim2.new(0, width, 1, -105),
		ZIndex = 5,
		Parent = self.Body,
	})
	addCorner(sidebar, 9)
	addStroke(sidebar, Color3.fromRGB(255, 255, 255), 0.92, 1)
	addGradient(sidebar, Color3.fromRGB(10, 24, 30), Color3.fromRGB(4, 7, 12), 16)

	local listTop = 16
	if options.ShowTitle then
		makeLabel(sidebar, {
			Text = options.Title or "Scripts",
			Color = Color3.fromRGB(230, 236, 242),
			Font = Enum.Font.GothamBold,
			Size = 12,
			Position = UDim2.fromOffset(12, 12),
			BoxSize = UDim2.new(1, -24, 0, 16),
			ZIndex = 7,
		})
		listTop = 40
	end

	local list = create("ScrollingFrame", {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		Name = "Tabs",
		Position = UDim2.fromOffset(8, listTop),
		ScrollBarImageColor3 = Color3.fromRGB(72, 83, 93),
		ScrollBarThickness = 0,
		Size = UDim2.new(1, -16, 1, -listTop - 10),
		ZIndex = 6,
		Parent = sidebar,
	})

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 9)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Parent = list

	if not self.PageHost then
		local pageHost = create("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Name = "Pages",
			Position = UDim2.fromOffset(width + 24, 0),
			Size = UDim2.new(1, -width - 24, 1, 0),
			ZIndex = 2,
			Parent = self.Body,
		})

		if self.TitleLabel then
			self.TitleLabel.Parent = pageHost
		end
		if self.SubtitleLabel then
			self.SubtitleLabel.Parent = pageHost
		end

		self.PageHost = pageHost
		self.ContentParent = pageHost
	end

	self.Sidebar = sidebar
	self.SidebarList = list
	self.SidebarOpen = true
	self.Tabs = self.Tabs or {}

	return sidebar
end

function Window:SetSidebarOpen(open)
	if not self.Sidebar or not self.PageHost then
		return false
	end

	self.SidebarOpen = open == true
	self.Sidebar.Visible = true

	local width = self.SidebarWidth or 64
	local sidebarPosition = self.SidebarOpen and UDim2.fromOffset(14, 70) or UDim2.fromOffset(-width - 18, 70)
	local pagePosition = self.SidebarOpen and UDim2.fromOffset(width + 24, 0) or UDim2.fromOffset(0, 0)
	local pageSize = self.SidebarOpen and UDim2.new(1, -width - 24, 1, 0) or UDim2.new(1, 0, 1, 0)

	safeTween(self.Sidebar, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		BackgroundTransparency = self.SidebarOpen and 0.18 or 0.9,
		Position = sidebarPosition,
	})

	safeTween(self.PageHost, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = pagePosition,
		Size = pageSize,
	})

	if not self.SidebarOpen then
		task.delay(0.23, function()
			if self.Sidebar and not self.SidebarOpen then
				self.Sidebar.Visible = false
			end
		end)
	end

	return true
end

function Window:ToggleSidebar()
	return self:SetSidebarOpen(not self.SidebarOpen)
end

function Window:SetTheme(themeName)
	themeName = tostring(themeName or self.DefaultThemeName or "Green")
	local theme = Themes[themeName] or Themes.Green

	if not Themes[themeName] then
		themeName = "Green"
	end

	self.DefaultThemeName = themeName
	self.CurrentTheme = theme

	if self.MainStroke then
		self.MainStroke.Color = theme.Stroke
		self.MainStroke.Transparency = 0.88
	end

	if self.WindowGradient then
		self.WindowGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 7, 12)),
			ColorSequenceKeypoint.new(0.54, Color3.fromRGB(8, 18, 25)),
			ColorSequenceKeypoint.new(1, theme.GradientB),
		})
	end

	for _, card in ipairs(self.Cards or {}) do
		if card.SetTheme then
			card:SetTheme(themeName)
		end
	end

	for _, tab in ipairs(self.Tabs or {}) do
		tab.ThemeName = themeName
		tab.Theme = theme
		if tab.Indicator then
			tab.Indicator.BackgroundColor3 = theme.Stroke
		end
		if tab.IconHolder then
			tab.IconHolder.BackgroundColor3 = theme.TileA
		end
	end

	self:_refreshTabs()
	return true
end

function Window:_refreshTabs()
	for _, tab in ipairs(self.Tabs or {}) do
		local active = tab == self.ActiveTab

		if tab.Button then
			tab.Button.BackgroundTransparency = active and 0.08 or 0.58
			safeTween(tab.Button, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = active and UDim2.fromOffset(42, 42) or UDim2.fromOffset(38, 38),
			})
		end

		if tab.IconHolder then
			tab.IconHolder.BackgroundTransparency = active and 0.05 or 0.55
			drawIcon(tab.IconHolder, tab.IconName, active and Colors.Text or Color3.fromRGB(174, 183, 192))
		end

		if tab.Indicator then
			safeTween(tab.Indicator, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = active and 0.05 or 1,
			})
		end
	end
end

function Window:SelectTab(tabOrName)
	local target = tabOrName

	if type(tabOrName) == "string" then
		for _, tab in ipairs(self.Tabs or {}) do
			if tab.Name == tabOrName then
				target = tab
				break
			end
		end
	end

	if type(target) ~= "table" or not target.Page then
		return nil
	end

	if self.ActiveTab == target then
		return target
	end

	local previous = self.ActiveTab

	self.ActiveTab = target
	self.ActivePage = target.Page
	self:_closeDropdown()

	if previous and previous.Page then
		local oldPage = previous.Page
		safeTween(oldPage, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			GroupTransparency = 1,
			Position = UDim2.fromOffset(-12, 0),
		})

		task.delay(0.15, function()
			if self.ActivePage ~= oldPage and oldPage.Parent then
				oldPage.Visible = false
			end
		end)
	end

	if self.TitleLabel then
		safeTween(self.TitleLabel, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextTransparency = 1,
		})
	end

	if self.SubtitleLabel then
		safeTween(self.SubtitleLabel, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextTransparency = 1,
		})
	end

	task.delay(0.08, function()
		self:SetTitle(target.Title, target.Subtitle)

		if self.TitleLabel then
			safeTween(self.TitleLabel, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0,
			})
		end

		if self.SubtitleLabel then
			safeTween(self.SubtitleLabel, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0.12,
			})
		end
	end)

	target.Page.Visible = true
	target.Page.Position = UDim2.fromOffset(14, 0)
	target.Page.GroupTransparency = 1
	safeTween(target.Page, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		GroupTransparency = 0,
		Position = UDim2.fromOffset(0, 0),
	})

	self:_refreshTabs()

	return target
end

function Window:AddTab(options)
	options = options or {}
	self:CreateSidebar(options.Sidebar or {})

	local name = options.Name or options.Title or ("Tab " .. tostring(#self.Tabs + 1))
	local title = options.Title or name
	local subtitle = options.Subtitle or ""
	local themeName = options.Theme or self.DefaultThemeName or "Green"
	local theme = Themes[themeName] or Themes.Green

	local page = create("CanvasGroup", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Name = name .. "Page",
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		ZIndex = 2,
		Parent = self.PageHost or self.ContentParent or self.Body,
	})

	local tab = setmetatable({
		Button = nil,
		IconHolder = nil,
		IconName = options.Icon or options.IconName or name,
		Indicator = nil,
		Name = name,
		Page = page,
		Subtitle = subtitle,
		Theme = theme,
		ThemeName = themeName,
		Title = title,
		Window = self,
	}, Tab)

	local button = create("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = Color3.fromRGB(13, 19, 24),
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		LayoutOrder = #self.Tabs + 1,
		Name = name .. "Tab",
		Size = UDim2.fromOffset(38, 38),
		Text = "",
		ZIndex = 8,
		Parent = self.SidebarList,
	})
	addCorner(button, 6)
	addGradient(button, Color3.fromRGB(15, 25, 30), Color3.fromRGB(6, 9, 13), 12)

	local indicator = create("Frame", {
		BackgroundColor3 = theme.Stroke,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(-2, 9),
		Size = UDim2.fromOffset(3, 20),
		ZIndex = 9,
		Parent = button,
	})
	addCorner(indicator, 3)

	local icon = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.TileA,
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(32, 32),
		ZIndex = 9,
		Parent = button,
	})
	addCorner(icon, 8)
	drawIcon(icon, tab.IconName, Color3.fromRGB(174, 183, 192))

	tab.Button = button
	tab.IconHolder = icon
	tab.Indicator = indicator

	button.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then
			safeTween(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.36,
				Size = UDim2.fromOffset(40, 40),
			})
		end
	end)

	button.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then
			safeTween(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.55,
				Size = UDim2.fromOffset(38, 38),
			})
		end
	end)

	button.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	table.insert(self.Tabs, tab)
	self:_registerSearch(button, name .. " " .. title .. " " .. subtitle)

	if options.Selected or #self.Tabs == 1 then
		self:SelectTab(tab)
	else
		self:_refreshTabs()
	end

	return tab
end

function Window:CreateCard(options)
	options = options or {}
	local parent = options.Parent or self.ActivePage or self.ContentParent or self.Body

	local themeName = options.Theme or self.DefaultThemeName or "Green"
	local theme = Themes[themeName] or Themes.Green
	local frame = create("Frame", {
		BackgroundColor3 = theme.Background,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Name = options.Name or ((options.Title or "Card") .. "Card"),
		Position = options.Position or UDim2.fromOffset(24, 130),
		Size = options.Size or UDim2.fromOffset(325, 160),
		ZIndex = 2,
		Parent = parent,
	})
	addCorner(frame, options.Radius or 10)
	local stroke = addStroke(frame, theme.Stroke, 0.72, 1)
	local gradient = addGradient(frame, theme.GradientA, theme.GradientB, options.GradientRotation or 16)

	makeLabel(frame, {
		Text = options.Title or "Card",
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 15,
		Position = UDim2.fromOffset(15, 13),
		BoxSize = UDim2.new(1, -30, 0, 20),
		ZIndex = 4,
	})

	if options.Subtitle and options.Subtitle ~= "" then
		makeLabel(frame, {
			Text = options.Subtitle,
			Color = Color3.fromRGB(196, 202, 210),
			Font = Enum.Font.Gotham,
			Size = 11,
			Transparency = 0.22,
			Wrapped = true,
			Position = UDim2.fromOffset(15, 34),
			BoxSize = UDim2.new(1, -30, 0, 32),
			ZIndex = 4,
		})
	end

	local contentTop = options.ContentTop or 70
	local body = create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Name = "Items",
		Position = UDim2.fromOffset(14, contentTop),
		Size = UDim2.new(1, -28, 1, -contentTop - 12),
		ZIndex = 4,
		Parent = frame,
	})

	local columns = options.Columns or 2
	local gapX = options.GapX or 10
	local gapY = options.GapY or 6

	local layout = Instance.new("UIGridLayout")
	layout.CellPadding = UDim2.fromOffset(gapX, gapY)
	layout.CellSize = UDim2.new(1 / columns, -gapX * (columns - 1) / columns, 0, options.CellHeight or 38)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.FillDirectionMaxCells = columns
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Parent = body

	local card = setmetatable({
		AccentObjects = {},
		Frame = frame,
		Body = body,
		Layout = layout,
		Stroke = stroke,
		ThemeChangedCallbacks = {},
		Gradient = gradient,
		Theme = theme,
		ThemeName = themeName,
		Tiles = {},
		Window = self,
		NextOrder = 0,
	}, Card)

	self.Cards = self.Cards or {}
	table.insert(self.Cards, card)

	return card
end

function Window:CreateProfileCard(options)
	options = options or {}
	local theme = Themes.Profile
	local parent = options.Parent or self.ActivePage or self.ContentParent or self.Body

	local frame = create("Frame", {
		BackgroundColor3 = theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Name = "ProfileCard",
		Position = options.Position or UDim2.fromOffset(24, 360),
		Size = options.Size or UDim2.fromOffset(325, 65),
		ZIndex = 2,
		Parent = parent,
	})
	addCorner(frame, 10)
	addStroke(frame, theme.Stroke, 0.8, 1)
	addGradient(frame, theme.GradientA, theme.GradientB, 12)

	local avatar = create("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(15, 22, 27),
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Image = "",
		Position = UDim2.fromOffset(18, 14),
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromOffset(38, 38),
		ZIndex = 4,
		Parent = frame,
	})
	addCorner(avatar, 19)

	local player = options.Player or LocalPlayer
	local displayName = options.DisplayName or options.Name or (player and player.DisplayName) or "sehajpreet"
	local handle = options.Handle or (player and ("@" .. player.Name)) or "@Rahim007612"
	local image = options.Avatar

	if not image and player then
		local ok, thumbnail = pcall(function()
			return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if ok then
			image = thumbnail
		end
	end

	avatar.Image = image or ""

	makeLabel(frame, {
		Text = displayName,
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 14,
		Position = UDim2.fromOffset(70, 17),
		BoxSize = UDim2.new(1, -90, 0, 18),
		ZIndex = 4,
	})

	makeLabel(frame, {
		Text = handle,
		Color = Color3.fromRGB(176, 184, 192),
		Font = Enum.Font.Gotham,
		Size = 11,
		Transparency = 0.15,
		Position = UDim2.fromOffset(70, 36),
		BoxSize = UDim2.new(1, -90, 0, 16),
		ZIndex = 4,
	})

	self:_registerSearch(frame, displayName .. " " .. handle)

	return frame
end

function Window:BuildReferenceHome(data)
	data = data or {}
	local player = data.Player or LocalPlayer
	local sessionStart = data.SessionStart or os.clock()
	local homeTab = data.Tab
	local targetParent = data.Parent or (homeTab and homeTab.Page) or self.ActivePage or self.ContentParent or self.Body

	local serverCard = self:CreateCard({
		Parent = targetParent,
		Title = "Server",
		Subtitle = "Information on the session\nyou're currently in",
		Theme = "Green",
		Position = UDim2.fromOffset(24, 130),
		Size = UDim2.fromOffset(325, 219),
		Columns = 2,
		CellHeight = 44,
		ContentTop = 70,
	})

	local playersItem = serverCard:AddInfo("Players", data.Players or tostring(#Players:GetPlayers()) .. " playing")
	local maxPlayersItem = serverCard:AddInfo("Maximum Players", data.MaximumPlayers or tostring(Players.MaxPlayers))
	local latencyItem = serverCard:AddInfo("Latency", data.Latency or readPing())
	local regionItem = serverCard:AddInfo("Server Region", data.ServerRegion or "Unknown")
	local sessionItem = serverCard:AddInfo("In server for", data.InServerFor or formatDuration(os.clock() - sessionStart))
	local joinItem = serverCard:AddInfo("Join Script", data.JoinScriptLabel or "Tap to copy", function()
		local joinScript = data.JoinScript or ("game:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. tostring(game.PlaceId) .. ", \"" .. tostring(game.JobId) .. "\", game.Players.LocalPlayer)")
		self:Copy(joinScript)
	end)

	local miscCard = self:CreateCard({
		Parent = targetParent,
		Title = "Miscellaneous",
		Subtitle = "Extra utilities and session options\nfor quick access",
		Theme = "Amber",
		Position = UDim2.fromOffset(369, 130),
		Size = UDim2.fromOffset(325, 160),
		Columns = 2,
		CellHeight = 38,
		ContentTop = 72,
	})

	miscCard:AddButton("Rejoin Server", "Tap to rejoin", data.OnRejoin or function()
		local ok = pcall(function()
			if game.JobId and game.JobId ~= "" then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
			else
				TeleportService:Teleport(game.PlaceId, LocalPlayer)
			end
		end)
		if not ok then
			self:Notify("Rejoin failed")
		end
	end)

	miscCard:AddButton("Serverhop", "Find a new server", data.OnServerHop or function()
		self:Notify("Add OnServerHop to your script")
	end)

	miscCard:AddButton("Unload UI", "Terminate script", data.OnUnload or function()
		self:Destroy()
	end)

	miscCard:AddButton("Copy Discord", "Join community", data.OnCopyDiscord or function()
		self:Copy(data.DiscordLink or data.Discord or "discord.gg/community")
	end)

	local executorCard = self:CreateCard({
		Parent = targetParent,
		Title = "Executor",
		Subtitle = "Current exploitation software",
		Theme = "Purple",
		Position = UDim2.fromOffset(369, 300),
		Size = UDim2.fromOffset(325, 126),
		Columns = 1,
		CellHeight = 40,
		ContentTop = 70,
	})

	local detectedExecutor = data.Executor or getExecutorName()
	local executorButton = executorCard:AddCenteredButton(detectedExecutor, data.OnExecutorClick or function()
		self:Notify(detectedExecutor)
	end)

	local profileCard = self:CreateProfileCard({
		Parent = targetParent,
		Player = player,
		Name = data.ProfileName,
		DisplayName = data.ProfileName,
		Handle = data.ProfileHandle,
		Avatar = data.ProfileAvatar,
		Position = UDim2.fromOffset(24, 360),
		Size = UDim2.fromOffset(325, 65),
	})

	return {
		HomeTab = homeTab,
		ServerCard = serverCard,
		MiscCard = miscCard,
		ExecutorCard = executorCard,
		ProfileCard = profileCard,
		PlayersItem = playersItem,
		MaximumPlayersItem = maxPlayersItem,
		LatencyItem = latencyItem,
		ServerRegionItem = regionItem,
		SessionItem = sessionItem,
		JoinItem = joinItem,
		ExecutorButton = executorButton,
	}
end

function Tab:CreateCard(options)
	options = options or {}
	options.Parent = self.Page
	options.Theme = options.Theme or self.ThemeName
	return self.Window:CreateCard(options)
end

function Tab:CreateProfileCard(options)
	options = options or {}
	options.Parent = self.Page
	return self.Window:CreateProfileCard(options)
end

function Tab:Select()
	return self.Window:SelectTab(self)
end

function Card:_nextLayoutOrder()
	self.NextOrder += 1
	return self.NextOrder
end

function Card:SetTheme(themeName)
	themeName = tostring(themeName or self.ThemeName or "Green")
	local theme = Themes[themeName] or Themes.Green

	if not Themes[themeName] then
		themeName = "Green"
	end

	self.ThemeName = themeName
	self.Theme = theme

	if self.Frame then
		self.Frame.BackgroundColor3 = theme.Background
	end

	if self.Stroke then
		self.Stroke.Color = theme.Stroke
	end

	if self.Gradient then
		self.Gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, theme.GradientA),
			ColorSequenceKeypoint.new(0.48, theme.Background),
			ColorSequenceKeypoint.new(1, theme.GradientB),
		})
	end

	for _, tile in ipairs(self.Tiles or {}) do
		if tile.Frame then
			tile.Frame.BackgroundColor3 = theme.TileA
		end

		if tile.Gradient then
			tile.Gradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, theme.TileA),
				ColorSequenceKeypoint.new(1, theme.TileB),
			})
		end
	end

	for _, object in ipairs(self.AccentObjects or {}) do
		if object and object.Parent then
			object.BackgroundColor3 = theme.Stroke
		end
	end

	for _, callback in ipairs(self.ThemeChangedCallbacks or {}) do
		callback()
	end
end

function Card:_makeTile(clickable, centered, callback)
	local tileClass = clickable and "TextButton" or "Frame"
	local tile = create(tileClass, {
		AutoButtonColor = clickable and false or nil,
		BackgroundColor3 = self.Theme.TileA,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = self:_nextLayoutOrder(),
		Name = clickable and "Button" or "Info",
		Text = clickable and "" or nil,
		ZIndex = 5,
		Parent = self.Body,
	})
	addCorner(tile, 5)
	local gradient = addGradient(tile, self.Theme.TileA, self.Theme.TileB, 8)

	table.insert(self.Tiles, {
		Frame = tile,
		Gradient = gradient,
	})

	if clickable then
		tile.MouseEnter:Connect(function()
			safeTween(tile, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0,
			})
		end)

		tile.MouseLeave:Connect(function()
			safeTween(tile, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.05,
			})
		end)

		tile.MouseButton1Click:Connect(function()
			if callback then
				callback()
			end
		end)
	end

	return tile
end

function Card:AddInfo(title, value, callback)
	local tile = self:_makeTile(type(callback) == "function", false, callback)

	local titleLabel = makeLabel(tile, {
		Text = tostring(title or ""),
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 11,
		Position = UDim2.fromOffset(8, 8),
		BoxSize = UDim2.new(1, -16, 0, 14),
		ZIndex = 6,
	})

	local valueLabel = makeLabel(tile, {
		Text = tostring(value or ""),
		Color = Color3.fromRGB(190, 198, 207),
		Font = Enum.Font.Gotham,
		Size = 10,
		Transparency = 0.12,
		Position = UDim2.fromOffset(8, 23),
		BoxSize = UDim2.new(1, -16, 0, 13),
		ZIndex = 6,
	})

	local item = {
		Instance = tile,
		Title = titleLabel,
		Value = valueLabel,
	}

	function item:SetTitle(text)
		self.Title.Text = tostring(text or "")
	end

	function item:SetValue(text)
		self.Value.Text = tostring(text or "")
	end

	self.Window:_registerSearch(tile, tostring(title or "") .. " " .. tostring(value or ""))
	return item
end

function Card:AddButton(title, subtitle, callback)
	local tile = self:_makeTile(true, false, callback)

	makeLabel(tile, {
		Text = tostring(title or ""),
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 11,
		Position = UDim2.fromOffset(8, 6),
		BoxSize = UDim2.new(1, -16, 0, 14),
		ZIndex = 6,
	})

	makeLabel(tile, {
		Text = tostring(subtitle or ""),
		Color = Color3.fromRGB(205, 211, 219),
		Font = Enum.Font.Gotham,
		Size = 10,
		Transparency = 0.2,
		Position = UDim2.fromOffset(8, 21),
		BoxSize = UDim2.new(1, -16, 0, 13),
		ZIndex = 6,
	})

	self.Window:_registerSearch(tile, tostring(title or "") .. " " .. tostring(subtitle or ""))
	return tile
end

function Card:AddCenteredButton(text, callback)
	local tile = self:_makeTile(true, true, callback)

	makeLabel(tile, {
		Text = tostring(text or ""),
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 14,
		XAlignment = Enum.TextXAlignment.Center,
		YAlignment = Enum.TextYAlignment.Center,
		Position = UDim2.fromOffset(0, 0),
		BoxSize = UDim2.fromScale(1, 1),
		ZIndex = 6,
	})

	self.Window:_registerSearch(tile, tostring(text or ""))
	return tile
end

function Card:AddToggle(title, subtitle, default, callback)
	local enabled = default == true
	local tile = self:_makeTile(true, false)

	makeLabel(tile, {
		Text = tostring(title or ""),
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 11,
		Position = UDim2.fromOffset(8, 7),
		BoxSize = UDim2.new(1, -62, 0, 14),
		ZIndex = 6,
	})

	makeLabel(tile, {
		Text = tostring(subtitle or ""),
		Color = Color3.fromRGB(205, 211, 219),
		Font = Enum.Font.Gotham,
		Size = 10,
		Transparency = 0.2,
		Position = UDim2.fromOffset(8, 23),
		BoxSize = UDim2.new(1, -66, 0, 13),
		ZIndex = 6,
	})

	local pill = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(25, 31, 36),
		BorderSizePixel = 0,
		Position = UDim2.new(1, -48, 0, 14),
		Size = UDim2.fromOffset(38, 18),
		ZIndex = 6,
		Parent = tile,
	})
	addCorner(pill, 9)

	local knob = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(235, 240, 246),
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.fromOffset(12, 12),
		ZIndex = 7,
		Parent = pill,
	})
	addCorner(knob, 6)

	local function render(fire)
		pill.BackgroundColor3 = enabled and self.Theme.Stroke or Color3.fromRGB(25, 31, 36)
		safeTween(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = enabled and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
		})

		if fire and callback then
			callback(enabled)
		end
	end

	tile.MouseButton1Click:Connect(function()
		enabled = not enabled
		render(true)
	end)

	table.insert(self.ThemeChangedCallbacks, function()
		render(false)
	end)

	render(false)
	self.Window:_registerSearch(tile, tostring(title or "") .. " " .. tostring(subtitle or ""))

	local item = {
		Instance = tile,
	}

	function item:GetValue()
		return enabled
	end

	function item:SetValue(value)
		enabled = value == true
		render(true)
	end

	return item
end

function Card:AddDropdown(title, choices, default, callback)
	if type(title) == "table" then
		local options = title
		title = options.Title or options.Name
		choices = options.Options or options.Choices
		default = options.Default
		callback = options.Callback
	end

	choices = choices or {}
	local normalizedChoices = {}
	for _, choice in ipairs(choices) do
		table.insert(normalizedChoices, tostring(choice))
	end

	local selected = tostring(default or normalizedChoices[1] or "")
	local tile = self:_makeTile(true, false)

	makeLabel(tile, {
		Text = tostring(title or "Dropdown"),
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 11,
		Position = UDim2.fromOffset(8, 7),
		BoxSize = UDim2.new(1, -28, 0, 14),
		ZIndex = 6,
	})

	local valueLabel = makeLabel(tile, {
		Text = selected,
		Color = Color3.fromRGB(205, 211, 219),
		Font = Enum.Font.Gotham,
		Size = 10,
		Transparency = 0.15,
		Position = UDim2.fromOffset(8, 23),
		BoxSize = UDim2.new(1, -36, 0, 13),
		ZIndex = 6,
	})

	local chevron = makeChevron(tile, Color3.fromRGB(185, 192, 200))

	local function setSelected(value, fire)
		selected = tostring(value)
		valueLabel.Text = selected

		if fire and callback then
			callback(selected)
		end
	end

	tile.MouseButton1Click:Connect(function()
		self.Window:_showDropdown(tile, normalizedChoices, selected, function(value)
			setSelected(value, true)
		end)
		self.Window.OpenDropdownChevron = chevron
		safeTween(chevron, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Rotation = 180,
		})
	end)

	self.Window:_registerSearch(tile, tostring(title or "") .. " " .. table.concat(normalizedChoices, " "))

	local item = {
		Instance = tile,
	}

	function item:GetValue()
		return selected
	end

	function item:SetValue(value)
		setSelected(value, true)
	end

	return item
end

function Card:AddKeybind(title, subtitle, default, callback)
	if type(title) == "table" then
		local options = title
		title = options.Title or options.Name
		subtitle = options.Subtitle or options.Description
		default = options.Default or options.Key
		callback = options.Callback
	end

	if type(default) == "function" and callback == nil then
		callback = default
		default = nil
	end

	local selected = normalizeKeyCode(default, Enum.KeyCode.RightControl)
	local listening = false
	local connection = nil
	local tile = self:_makeTile(true, false)

	makeLabel(tile, {
		Text = tostring(title or "Keybind"),
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 11,
		Position = UDim2.fromOffset(8, 7),
		BoxSize = UDim2.new(1, -16, 0, 14),
		ZIndex = 6,
	})

	local valueLabel = makeLabel(tile, {
		Text = keyCodeName(selected),
		Color = Color3.fromRGB(205, 211, 219),
		Font = Enum.Font.Gotham,
		Size = 10,
		Transparency = 0.15,
		Position = UDim2.fromOffset(8, 23),
		BoxSize = UDim2.new(1, -16, 0, 13),
		ZIndex = 6,
	})

	local function disconnect()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	local function setKey(key, fire)
		selected = normalizeKeyCode(key, selected)
		valueLabel.Text = keyCodeName(selected)
		listening = false
		disconnect()

		if fire and callback then
			callback(selected)
		end
	end

	tile.MouseButton1Click:Connect(function()
		if listening then
			return
		end

		listening = true
		valueLabel.Text = "Press a key..."
		disconnect()

		connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if input.KeyCode == Enum.KeyCode.Escape then
				setKey(selected, false)
				return
			end

			setKey(input.KeyCode, true)
		end)
	end)

	self.Window:_registerSearch(tile, tostring(title or "") .. " " .. tostring(subtitle or "") .. " keybind hotkey toggle")

	local item = {
		Instance = tile,
	}

	function item:GetValue()
		return selected
	end

	function item:SetValue(key)
		setKey(key, true)
	end

	return item
end

function Card:AddSlider(title, minValue, maxValue, default, callback)
	minValue = tonumber(minValue) or 0
	maxValue = tonumber(maxValue) or 100
	local value = math.clamp(tonumber(default) or minValue, minValue, maxValue)
	local dragging = false

	local tile = self:_makeTile(false, false)

	makeLabel(tile, {
		Text = tostring(title or "Slider"),
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 11,
		Position = UDim2.fromOffset(8, 7),
		BoxSize = UDim2.new(1, -54, 0, 14),
		ZIndex = 6,
	})

	local valueLabel = makeLabel(tile, {
		Text = tostring(value),
		Color = Color3.fromRGB(205, 211, 219),
		Font = Enum.Font.GothamBold,
		Size = 10,
		XAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.new(1, -47, 0, 7),
		BoxSize = UDim2.fromOffset(38, 14),
		ZIndex = 6,
	})

	local bar = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(16, 21, 26),
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(8, 31),
		Size = UDim2.new(1, -16, 0, 5),
		ZIndex = 6,
		Parent = tile,
	})
	addCorner(bar, 3)

	local fill = create("Frame", {
		BackgroundColor3 = self.Theme.Stroke,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(0, 1),
		ZIndex = 7,
		Parent = bar,
	})
	addCorner(fill, 3)
	table.insert(self.AccentObjects, fill)

	local function alphaFromValue(nextValue)
		if maxValue == minValue then
			return 0
		end

		return math.clamp((nextValue - minValue) / (maxValue - minValue), 0, 1)
	end

	local function setValue(nextValue, fire)
		value = math.clamp(nextValue, minValue, maxValue)
		value = math.floor(value + 0.5)
		valueLabel.Text = tostring(value)
		fill.Size = UDim2.fromScale(alphaFromValue(value), 1)

		if fire and callback then
			callback(value)
		end
	end

	local function setFromInput(input, fire)
		local alpha = 0
		if bar.AbsoluteSize.X > 0 then
			alpha = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		end

		setValue(minValue + (maxValue - minValue) * alpha, fire)
	end

	tile.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromInput(input, true)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			setFromInput(input, true)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	setValue(value, false)
	self.Window:_registerSearch(tile, tostring(title or ""))

	local item = {
		Instance = tile,
	}

	function item:GetValue()
		return value
	end

	function item:SetValue(nextValue)
		setValue(tonumber(nextValue) or value, true)
	end

	return item
end

function Loader:SetStatus(text, isError)
	if self.StatusLabel then
		self.StatusLabel.Text = tostring(text or "")
		self.StatusLabel.TextColor3 = isError and Color3.fromRGB(255, 118, 128) or Color3.fromRGB(164, 216, 186)
	end
end

function Loader:Destroy()
	if self.Gui then
		self.Gui:Destroy()
	end
end

function UILib.CreateLoader(config)
	config = config or {}

	local parent = config.Parent or getPlayerGui()
	assert(parent, "RobloxHomeUILib loader must be created from a LocalScript or given a Parent.")

	local themeName = config.Theme or "Green"
	local theme = Themes[themeName] or Themes.Green

	local screenGui = create("ScreenGui", {
		DisplayOrder = config.DisplayOrder or 1000,
		IgnoreGuiInset = true,
		Name = config.GuiName or "RobloxHomeLoader",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = parent,
	})

	local main = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Background,
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = config.Position or UDim2.fromScale(0.5, 0.5),
		Size = config.Size or UDim2.fromOffset(390, 286),
		ZIndex = 10,
		Parent = screenGui,
	})
	addCorner(main, 9)
	addStroke(main, theme.Stroke, 0.72, 1)
	addGradient(main, theme.GradientA, theme.GradientB, 18)

	local icon = create("Frame", {
		BackgroundColor3 = theme.TileA,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(24, 24),
		Size = UDim2.fromOffset(42, 42),
		ZIndex = 12,
		Parent = main,
	})
	addCorner(icon, 10)
	drawIcon(icon, config.Icon or "key", Colors.Text)

	makeLabel(main, {
		Text = config.Title or "Login",
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 21,
		Position = UDim2.fromOffset(80, 25),
		BoxSize = UDim2.new(1, -104, 0, 25),
		ZIndex = 12,
	})

	makeLabel(main, {
		Text = config.Subtitle or "Enter your credentials",
		Color = Color3.fromRGB(186, 195, 204),
		Font = Enum.Font.Gotham,
		Size = 12,
		Transparency = 0.08,
		Position = UDim2.fromOffset(80, 51),
		BoxSize = UDim2.new(1, -104, 0, 18),
		ZIndex = 12,
	})

	local function makeInput(name, placeholder, y, password)
		local holder = create("Frame", {
			BackgroundColor3 = theme.TileA,
			BackgroundTransparency = 0.08,
			BorderSizePixel = 0,
			Name = name,
			Position = UDim2.fromOffset(24, y),
			Size = UDim2.new(1, -48, 0, 42),
			ZIndex = 12,
			Parent = main,
		})
		addCorner(holder, 7)
		addGradient(holder, theme.TileA, theme.TileB, 8)

		local box = create("TextBox", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClearTextOnFocus = false,
			Font = Enum.Font.GothamMedium,
			PlaceholderColor3 = Color3.fromRGB(139, 148, 157),
			PlaceholderText = placeholder,
			Text = "",
			TextColor3 = Colors.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.fromOffset(14, 0),
			Size = UDim2.new(1, -28, 1, 0),
			ZIndex = 13,
			Parent = holder,
		})

		if password then
			box.TextTransparency = 0.03
		end

		return box
	end

	local usernameBox = makeInput("Username", config.UsernamePlaceholder or "Username", 92, false)
	local passwordBox = makeInput("Password", config.PasswordPlaceholder or "Password", 141, true)

	local statusLabel = makeLabel(main, {
		Text = config.StatusText or "",
		Color = Color3.fromRGB(164, 216, 186),
		Font = Enum.Font.Gotham,
		Size = 11,
		Position = UDim2.fromOffset(26, 188),
		BoxSize = UDim2.new(1, -52, 0, 16),
		ZIndex = 12,
	})

	local loginButton = create("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme.TileA,
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		Position = UDim2.fromOffset(24, 211),
		Size = UDim2.new(1, -48, 0, 45),
		Text = "",
		TextColor3 = Colors.Text,
		TextSize = 14,
		ZIndex = 12,
		Parent = main,
	})
	addCorner(loginButton, 7)
	addGradient(loginButton, theme.TileA, theme.TileB, 6)

	makeLabel(loginButton, {
		Text = config.ButtonText or "Login",
		Color = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		Size = 14,
		XAlignment = Enum.TextXAlignment.Center,
		YAlignment = Enum.TextYAlignment.Center,
		Position = UDim2.fromOffset(0, 0),
		BoxSize = UDim2.fromScale(1, 1),
		ZIndex = 14,
	})

	local loader = setmetatable({
		Gui = screenGui,
		Main = main,
		PasswordBox = passwordBox,
		StatusLabel = statusLabel,
		UsernameBox = usernameBox,
	}, Loader)

	loginButton.MouseEnter:Connect(function()
		safeTween(loginButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0,
		})
	end)

	loginButton.MouseLeave:Connect(function()
		safeTween(loginButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.02,
		})
	end)

	loginButton.MouseButton1Click:Connect(function()
		loader:SetStatus(config.CheckingText or "Checking...")

		local accepted = true
		if config.OnLogin then
			local ok, result = pcall(config.OnLogin, usernameBox.Text, passwordBox.Text, loader)
			accepted = ok and result ~= false
			if not ok then
				loader:SetStatus("Login callback error", true)
				return
			end
		elseif config.Username or config.Password then
			accepted = usernameBox.Text == tostring(config.Username or "") and passwordBox.Text == tostring(config.Password or "")
		end

		if accepted then
			loader:SetStatus(config.SuccessText or "Access granted")
			if config.DestroyOnSuccess ~= false then
				task.delay(0.22, function()
					loader:Destroy()
				end)
			end
		else
			loader:SetStatus(config.ErrorText or "Invalid username or password", true)
		end
	end)

	return loader
end

function UILib.CreateWindow(config)
	config = config or {}

	local parent = config.Parent or getPlayerGui()
	assert(parent, "RobloxHomeUILib must be required from a LocalScript or given a Parent.")
	local hasSidebar = config.Sidebar == true or type(config.Sidebar) == "table" or config.Tabs ~= nil
	local defaultSize = hasSidebar and UDim2.fromOffset(880, 520) or UDim2.fromOffset(720, 500)

	local screenGui = create("ScreenGui", {
		DisplayOrder = config.DisplayOrder or 999,
		IgnoreGuiInset = true,
		Name = config.GuiName or "RobloxHomeUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = parent,
	})

	local notificationHost = create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Name = "Notifications",
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1),
		ZIndex = 80,
		Parent = screenGui,
	})

	local main = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Colors.Window,
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Name = "Window",
		Position = config.Position or UDim2.fromScale(0.5, 0.5),
		Size = config.Size or defaultSize,
		ZIndex = 1,
		Parent = screenGui,
	})
	addCorner(main, 8)
	local mainStroke = addStroke(main, Color3.fromRGB(255, 255, 255), 0.92, 1)
	local windowGradient = addGradient(main, Color3.fromRGB(4, 7, 12), Color3.fromRGB(8, 22, 34), 20)

	local scale = Instance.new("UIScale")
	scale.Scale = config.Scale or 1
	scale.Parent = main

	local body = create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Name = "Body",
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
		Parent = main,
	})

	local topbar = create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Name = "Topbar",
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 0, 0, 58),
		ZIndex = 7,
		Parent = main,
	})

	local sidebarButton = makeHamburger(topbar)

	local search = create("Frame", {
		BackgroundColor3 = Colors.Search,
		BackgroundTransparency = 0.07,
		BorderSizePixel = 0,
		Name = "Search",
		Position = UDim2.new(1, -300, 0, 21),
		Size = UDim2.fromOffset(225, 30),
		ZIndex = 8,
		Parent = topbar,
	})
	addCorner(search, 6)
	makeSearchIcon(search)

	local searchBox = create("TextBox", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Font = Enum.Font.Gotham,
		PlaceholderColor3 = Color3.fromRGB(146, 150, 158),
		PlaceholderText = config.SearchPlaceholder or "Search for scripts",
		Text = "",
		TextColor3 = Color3.fromRGB(230, 234, 240),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.fromOffset(36, 0),
		Size = UDim2.new(1, -44, 1, 0),
		ZIndex = 10,
		Parent = search,
	})

	local minimize = makeControlButton(topbar, UDim2.new(1, -69, 0, 21), "minimize")
	local restore = makeControlButton(topbar, UDim2.new(1, -38, 0, 21), "restore")

	local bottomHandle = create("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0),
		AutoButtonColor = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = config.BottomHandleTransparency or 0.9,
		BorderSizePixel = 0,
		Name = "BottomDragHandle",
		Position = UDim2.new(0.5, 0, 1, 8),
		Size = UDim2.fromOffset(245, 16),
		Text = "",
		ZIndex = 4,
		Parent = main,
	})
	addCorner(bottomHandle, 9)
	addStroke(bottomHandle, Color3.fromRGB(255, 255, 255), 0.9, 1)
	addGradient(bottomHandle, Color3.fromRGB(255, 255, 255), Color3.fromRGB(80, 93, 106), 0)
	makeLine(bottomHandle, 86, 7, 72, 2, Color3.fromRGB(215, 224, 235))

	local title = makeLabel(body, {
		Text = config.Title or "Home",
		Color = Colors.Text,
		Font = Enum.Font.GothamBold,
		Size = 21,
		Position = UDim2.fromOffset(24, 84),
		BoxSize = UDim2.fromOffset(320, 24),
		ZIndex = 4,
	})

	local subtitle = makeLabel(body, {
		Text = config.Subtitle or "What's up?",
		Color = Color3.fromRGB(172, 179, 188),
		Font = Enum.Font.Gotham,
		Size = 12,
		Transparency = 0.12,
		Position = UDim2.fromOffset(24, 110),
		BoxSize = UDim2.fromOffset(320, 18),
		ZIndex = 4,
	})

	local self = setmetatable({
		Gui = screenGui,
		Main = main,
		MainStroke = mainStroke,
		Body = body,
		BottomHandle = bottomHandle,
		Cards = {},
		ContentParent = body,
		SidebarButton = sidebarButton,
		Topbar = topbar,
		TitleLabel = title,
		SubtitleLabel = subtitle,
		SearchBox = searchBox,
		SearchIndex = {},
		DefaultThemeName = config.Theme or "Green",
		MaxNotifications = config.MaxNotifications or 5,
		NotificationDuration = config.NotificationDuration or 3,
		NotificationHost = notificationHost,
		NotificationBottom = config.NotificationBottom or 84,
		Notifications = {},
		SidebarWidth = 64,
		Tabs = {},
		WindowGradient = windowGradient,
		OriginalSize = main.Size,
		OriginalPosition = main.Position,
		Minimized = false,
		ToggleKey = config.ToggleKey == false and false or normalizeKeyCode(config.ToggleKey, Enum.KeyCode.RightControl),
		Visible = true,
	}, Window)

	makeDraggable(topbar, main)
	makeDraggable(bottomHandle, main)

	if self.ToggleKey ~= false then
		self.ToggleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed or UserInputService:GetFocusedTextBox() then
				return
			end

			if input.KeyCode == self.ToggleKey then
				self:Toggle()
			end
		end)
	end

	sidebarButton.MouseButton1Click:Connect(function()
		self:ToggleSidebar()
	end)

	if hasSidebar then
		self:CreateSidebar(type(config.Sidebar) == "table" and config.Sidebar or {})
	end

	if config.Tabs then
		for _, tabOptions in ipairs(config.Tabs) do
			self:AddTab(tabOptions)
		end
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		self:_filterSearch(searchBox.Text)
	end)

	minimize.MouseButton1Click:Connect(function()
		self.Minimized = not self.Minimized
		body.Visible = not self.Minimized

		safeTween(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = self.Minimized and UDim2.new(self.OriginalSize.X.Scale, self.OriginalSize.X.Offset, 0, 60) or self.OriginalSize,
		})
	end)

	restore.MouseButton1Click:Connect(function()
		self.Minimized = false
		body.Visible = true
		main.Position = self.OriginalPosition
		safeTween(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = self.OriginalSize,
		})
	end)

	local function updateScale()
		if config.Scale then
			scale.Scale = config.Scale
			return
		end

		local camera = workspace.CurrentCamera
		if not camera then
			return
		end

		local viewport = camera.ViewportSize
		local baseWidth = self.OriginalSize.X.Offset > 0 and self.OriginalSize.X.Offset or 780
		local baseHeight = self.OriginalSize.Y.Offset > 0 and self.OriginalSize.Y.Offset or 560
		local fit = math.min(viewport.X / (baseWidth + 60), viewport.Y / (baseHeight + 60), 1)
		scale.Scale = math.clamp(fit, 0.64, 1)
	end

	updateScale()
	if workspace.CurrentCamera then
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
	end

	return self
end

function UILib.RejoinServer(player)
	player = player or LocalPlayer
	return pcall(function()
		if game.JobId and game.JobId ~= "" then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
		else
			TeleportService:Teleport(game.PlaceId, player)
		end
	end)
end

function UILib.ServerHop(player)
	player = player or LocalPlayer
	return pcall(function()
		TeleportService:Teleport(game.PlaceId, player)
	end)
end

UILib.new = UILib.CreateWindow
UILib.Themes = Themes
UILib.Icons = LucideIcons
UILib.FormatDuration = formatDuration
UILib.GetExecutor = getExecutorName
UILib.ReadPing = readPing

return UILib
