local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Config = {
	LibraryUrl = "https://raw.githubusercontent.com/V1trixz/UILIBRARY/refs/heads/main/UILIB.lua",
	Username = "admin",
	Password = "123",
	DiscordLink = "discord.gg/example",
	ToggleKey = Enum.KeyCode.RightControl,
}

local function loadLibrary(url)
	local source = game:HttpGet(url)
	local chunk = loadstring(source)
	return chunk()
end

local UILib = loadLibrary(Config.LibraryUrl)

local hubStarted = false

local function openHub()
	if hubStarted then
		return
	end

	hubStarted = true
	local startedAt = os.clock()

	local window = UILib.CreateWindow({
		Title = "Home",
		Subtitle = "What's up?",
		SearchPlaceholder = "Search for scripts",
		Sidebar = true,
		MaxNotifications = 5,
		Theme = "Green",
		ToggleKey = Config.ToggleKey,
	})

	local homeTab = window:AddTab({
		Name = "Home",
		Title = "Home",
		Subtitle = "What's up?",
		Icon = "home",
		Selected = true,
	})

	local dashboard = window:BuildReferenceHome({
		Tab = homeTab,
		Player = player,
		ProfileName = player.DisplayName,
		ProfileHandle = "@" .. player.Name,
		Players = tostring(#Players:GetPlayers()) .. " playing",
		MaximumPlayers = tostring(Players.MaxPlayers),
		Latency = UILib.ReadPing(),
		ServerRegion = "Unknown",
		InServerFor = "0s",
		Executor = UILib.GetExecutor(),
		DiscordLink = Config.DiscordLink,

		OnServerHop = function()
			local ok = UILib.ServerHop(player)
			if not ok then
				window:Notify("Serverhop failed")
			end
		end,

		OnExecutorClick = function()
			window:Notify("Executor: " .. UILib.GetExecutor())
		end,
	})

	local aimbotTab = window:AddTab({
		Name = "Aimbot",
		Title = "Aimbot",
		Subtitle = "Aim assist and target filters",
		Icon = "target",
	})

	local aimMain = aimbotTab:CreateCard({
		Title = "Aimbot",
		Subtitle = "Core combat options",
		Position = UDim2.fromOffset(24, 130),
		Size = UDim2.fromOffset(325, 248),
		Columns = 2,
		CellHeight = 50,
		ContentTop = 70,
	})

	aimMain:AddToggle("Enabled", "Master switch", false, function(value)
		window:Notify("Aimbot: " .. tostring(value))
	end)

	aimMain:AddDropdown("Target Part", {
		"Head",
		"HumanoidRootPart",
		"UpperTorso",
		"LowerTorso",
	}, "Head", function(value)
		window:Notify("Target: " .. value)
	end)

	aimMain:AddSlider("FOV", 30, 360, 120, function(value)
		window:Notify("FOV: " .. tostring(value))
	end)

	aimMain:AddSlider("Smoothness", 1, 20, 8, function(value)
		window:Notify("Smooth: " .. tostring(value))
	end)

	aimMain:AddButton("Lock Target", "Test callback", function()
		window:Notify("Target locked")
	end)

	aimMain:AddButton("Reset Aim", "Clear current target", function()
		window:Notify("Aim reset")
	end)

	local aimSettings = aimbotTab:CreateCard({
		Title = "Filters",
		Subtitle = "Who the aimbot can target",
		Position = UDim2.fromOffset(369, 130),
		Size = UDim2.fromOffset(325, 190),
		Columns = 2,
		CellHeight = 50,
		ContentTop = 70,
	})

	aimSettings:AddToggle("Team Check", "Ignore teammates", true)
	aimSettings:AddToggle("Wall Check", "Line of sight", true)
	aimSettings:AddToggle("Alive Check", "Ignore dead players", true)
	aimSettings:AddDropdown("Priority", {
		"Closest",
		"Lowest Health",
		"Most Visible",
	}, "Closest")

	local espTab = window:AddTab({
		Name = "ESP",
		Title = "ESP",
		Subtitle = "Visual player overlays",
		Icon = "eye",
	})

	local espMain = espTab:CreateCard({
		Title = "ESP",
		Subtitle = "Drawing and highlight options",
		Position = UDim2.fromOffset(24, 130),
		Size = UDim2.fromOffset(325, 248),
		Columns = 2,
		CellHeight = 50,
		ContentTop = 70,
	})

	espMain:AddToggle("Boxes", "2D player boxes", true)
	espMain:AddToggle("Names", "Display usernames", true)
	espMain:AddToggle("Tracers", "Lines to players", false)
	espMain:AddToggle("Health", "Health bars", true)
	espMain:AddDropdown("Color Mode", {
		"Team",
		"Distance",
		"Static",
	}, "Team")
	espMain:AddSlider("Distance", 100, 5000, 1500)

	local espPreview = espTab:CreateCard({
		Title = "Preview",
		Subtitle = "Quick visual presets",
		Position = UDim2.fromOffset(369, 130),
		Size = UDim2.fromOffset(325, 190),
		Columns = 1,
		CellHeight = 42,
		ContentTop = 70,
	})

	espPreview:AddButton("Legit Preset", "Low opacity overlays", function()
		window:Notify("Legit preset applied")
	end)
	espPreview:AddButton("Rage Preset", "Full visibility overlays", function()
		window:Notify("Rage preset applied")
	end)

	local configurationTab = window:AddTab({
		Name = "Configuration",
		Title = "Configuration",
		Subtitle = "UI behavior and saved preferences",
		Icon = "configuration",
	})

	local configurationCard = configurationTab:CreateCard({
		Title = "Interface",
		Subtitle = "Window, sidebar and notification settings",
		Position = UDim2.fromOffset(24, 130),
		Size = UDim2.fromOffset(325, 275),
		Columns = 2,
		CellHeight = 50,
		ContentTop = 70,
	})

	configurationCard:AddToggle("Notifications", "Show toast messages", true)
	configurationCard:AddDropdown("Theme", {
		"Green",
		"Amber",
		"Purple",
		"Red",
		"Blue",
	}, "Green", function(value)
		window:SetTheme(value)
		window:Notify("Theme changed to " .. value)
	end)

	configurationCard:AddButton("Toggle Sidebar", "Open or close the rail", function()
		window:ToggleSidebar()
	end)

	configurationCard:AddKeybind("UI Toggle Key", "Click and press a key", Config.ToggleKey, function(key)
		Config.ToggleKey = key
		window:SetToggleKey(key)
		window:Notify("UI toggle key: " .. key.Name)
	end)

	configurationCard:AddButton("Select Home", "Go back to dashboard", function()
		window:SelectTab("Home")
	end)

	local accountCard = configurationTab:CreateCard({
		Title = "Session",
		Subtitle = "Small account actions",
		Position = UDim2.fromOffset(369, 130),
		Size = UDim2.fromOffset(325, 160),
		Columns = 1,
		CellHeight = 42,
		ContentTop = 70,
	})

	accountCard:AddButton("Test Notification", "Push a stacked toast", function()
		window:Notify("This notification stacks upward")
	end)

	accountCard:AddButton("Unload UI", "Destroy the window", function()
		window:Destroy()
	end)

	Players.PlayerAdded:Connect(function()
		dashboard.PlayersItem:SetValue(tostring(#Players:GetPlayers()) .. " playing")
	end)

	Players.PlayerRemoving:Connect(function()
		task.defer(function()
			dashboard.PlayersItem:SetValue(tostring(#Players:GetPlayers()) .. " playing")
		end)
	end)

	task.spawn(function()
		while window.Gui.Parent do
			dashboard.SessionItem:SetValue(UILib.FormatDuration(os.clock() - startedAt))
			dashboard.LatencyItem:SetValue(UILib.ReadPing())
			task.wait(1)
		end
	end)
end

UILib.CreateLoader({
	Title = "Potassium",
	Subtitle = "Login to open the hub",
	Theme = "Green",
	UsernamePlaceholder = "Username",
	PasswordPlaceholder = "Password",
	ButtonText = "Enter",
	ErrorText = "Invalid username or password",
	Username = Config.Username,
	Password = Config.Password,

	OnLogin = function(username, password, loader)
		if username == Config.Username and password == Config.Password then
			loader:SetStatus("Access granted")
			task.delay(0.18, openHub)
			return true
		end

		return false
	end,
})
