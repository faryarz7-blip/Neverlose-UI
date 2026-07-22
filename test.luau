--// NeverLose UI Loader — full single-file build
--// Executor print • key gating • toasts • file logs • pcall exec • rate-limit • animations • fixed product list

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer

--============================================================ CORE
local NeverLose = {}
NeverLose.__index = NeverLose

NeverLose.AccentColor  = Color3.fromRGB(78, 127, 252)
NeverLose.ColorSuccess = Color3.fromRGB(70, 200, 120)
NeverLose.ColorError   = Color3.fromRGB(235, 75, 75)
NeverLose.ColorWarn    = Color3.fromRGB(240, 180, 70)
NeverLose.ColorBG      = Color3.fromRGB(18, 20, 26)
NeverLose.ColorPanel   = Color3.fromRGB(24, 27, 34)
NeverLose.ColorCard    = Color3.fromRGB(28, 31, 40)
NeverLose.ColorStroke  = Color3.fromRGB(45, 48, 58)
NeverLose.ColorText    = Color3.fromRGB(235, 238, 245)
NeverLose.ColorSub     = Color3.fromRGB(140, 145, 160)

local FastTween   = TweenInfo.new(0.18, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local SlowyTween  = TweenInfo.new(0.25, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local SmoothTween = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local BounceTween = TweenInfo.new(0.50, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)
local PopTween    = TweenInfo.new(0.12, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)

NeverLose.Connections = {}

function NeverLose:AddSignal(conn) table.insert(NeverLose.Connections, conn); return conn end

function NeverLose.RandomString()
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local out = ""
	for _ = 1, math.random(8, 14) do local i = math.random(1, #chars); out = out .. chars:sub(i, i) end
	return out
end

function NeverLose.PlayAnimate(object, info, props)
	local t = TweenService:Create(object, info, props); t:Play(); return t
end
local function fade(o, p) return NeverLose.PlayAnimate(o, SlowyTween, p) end

local function GetParent()
	local ok, hui = pcall(function() return gethui() end)
	if ok and hui then return hui end
	local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and cg then return cg end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local function corner(o, r) local c = Instance.new("UICorner", o); c.CornerRadius = UDim.new(0, r or 8); return c end
local function stroke(o, col, th, tr)
	local s = Instance.new("UIStroke", o)
	s.Color = col or NeverLose.ColorStroke; s.Thickness = th or 1; s.Transparency = tr or 0.4
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; return s
end

function NeverLose:CreateInput(_, Frame, Callback)
	local Button = Instance.new("ImageButton", Frame)
	Button.ZIndex = Frame.ZIndex + 10
	Button.Size = UDim2.fromScale(1, 1)
	Button.BackgroundTransparency = 1
	Button.ImageTransparency = 1
	Button.AutoButtonColor = false
	local scale = Frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", Frame)
	NeverLose:AddSignal(Button.MouseButton1Down:Connect(function()
		NeverLose.PlayAnimate(scale, PopTween, { Scale = 0.95 })
	end))
	NeverLose:AddSignal(Button.MouseButton1Up:Connect(function()
		NeverLose.PlayAnimate(scale, BounceTween, { Scale = 1 })
	end))
	if Callback then return Button.MouseButton1Click:Connect(Callback) end
	return Button
end

function NeverLose:CreateShadow(parent)
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxassetid://6014261993"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 1
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	Shadow.Size = UDim2.new(1, 60, 1, 60)
	Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.ZIndex = (parent.ZIndex or 1) - 1
	Shadow.Parent = parent
	local api = {}
	function api:Render(state)
		NeverLose.PlayAnimate(Shadow, SmoothTween, { ImageTransparency = state and 0.4 or 1 })
	end
	return api
end

--============================================================ EXECUTOR
function NeverLose:GetExecutor()
	local name, version = "Unknown", nil
	pcall(function()
		if identifyexecutor then name, version = identifyexecutor()
		elseif getexecutorname then name = getexecutorname()
		elseif syn and syn.protect_gui then name = "Synapse X" end
	end)
	return tostring(name or "Unknown"), version
end

--============================================================ LOGGER
NeverLose.LogFile = "neverlose_log.txt"
function NeverLose:Log(level, msg)
	level = tostring(level or "INFO"):upper()
	local line = ("[NeverLose][%s] %s"):format(level, tostring(msg))
	print(line)
	pcall(function()
		if not (writefile and isfile) then return end
		local stamp = ("[%s] "):format(os.date("%X"))
		if isfile(NeverLose.LogFile) and appendfile then
			appendfile(NeverLose.LogFile, stamp .. line .. "\n")
		else
			writefile(NeverLose.LogFile, stamp .. line .. "\n")
		end
	end)
end

--============================================================ TOASTS
function NeverLose:InitToasts(gui)
	local Holder = Instance.new("Frame", gui)
	Holder.Name = "Toasts"
	Holder.AnchorPoint = Vector2.new(1, 1)
	Holder.Position = UDim2.new(1, -18, 1, -18)
	Holder.Size = UDim2.new(0, 300, 1, -36)
	Holder.BackgroundTransparency = 1
	Holder.ZIndex = 500
	local list = Instance.new("UIListLayout", Holder)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.VerticalAlignment = Enum.VerticalAlignment.Bottom
	list.HorizontalAlignment = Enum.HorizontalAlignment.Right
	list.Padding = UDim.new(0, 8)
	NeverLose._ToastHolder = Holder
end

function NeverLose:Notify(title, message, kind, duration)
	kind = kind or "info"; duration = duration or 4
	local color = ({ info = NeverLose.AccentColor, success = NeverLose.ColorSuccess,
		warn = NeverLose.ColorWarn, error = NeverLose.ColorError })[kind] or NeverLose.AccentColor
	local Holder = NeverLose._ToastHolder
	if not Holder then return end
	local Toast = Instance.new("Frame", Holder)
	Toast.Size = UDim2.new(1, 0, 0, 56)
	Toast.BackgroundColor3 = NeverLose.ColorPanel
	Toast.BackgroundTransparency = 1
	Toast.ZIndex = 501
	corner(Toast, 10); stroke(Toast, color, 1, 0.3)
	local Bar = Instance.new("Frame", Toast)
	Bar.Size = UDim2.new(0, 4, 1, -14); Bar.Position = UDim2.new(0, 7, 0, 7)
	Bar.BackgroundColor3 = color; Bar.BorderSizePixel = 0; Bar.ZIndex = 502; corner(Bar, 2)
	local Title = Instance.new("TextLabel", Toast)
	Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 20, 0, 8)
	Title.Size = UDim2.new(1, -30, 0, 18); Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14; Title.TextColor3 = NeverLose.ColorText
	Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Text = tostring(title); Title.ZIndex = 502
	local Body = Instance.new("TextLabel", Toast)
	Body.BackgroundTransparency = 1; Body.Position = UDim2.new(0, 20, 0, 27)
	Body.Size = UDim2.new(1, -30, 0, 22); Body.Font = Enum.Font.Gotham
	Body.TextSize = 12; Body.TextColor3 = NeverLose.ColorSub
	Body.TextXAlignment = Enum.TextXAlignment.Left; Body.TextYAlignment = Enum.TextYAlignment.Top
	Body.TextWrapped = true; Body.Text = tostring(message); Body.ZIndex = 502
	local sc = Instance.new("UIScale", Toast); sc.Scale = 0.85
	NeverLose.PlayAnimate(Toast, FastTween, { BackgroundTransparency = 0 })
	NeverLose.PlayAnimate(sc, BounceTween, { Scale = 1 })
	task.delay(duration, function()
		NeverLose.PlayAnimate(Toast, FastTween, { BackgroundTransparency = 1 })
		NeverLose.PlayAnimate(sc, SlowyTween, { Scale = 0.85 })
		task.wait(0.2); Toast:Destroy()
	end)
end

--============================================================ EXECUTOR CHECK
function NeverLose:CheckExecutor()
	local exe, ver = NeverLose:GetExecutor()
	local label = ver and (exe .. " v" .. tostring(ver)) or exe
	print("========================================")
	print(" NeverLose injected from: " .. label)
	print("========================================")
	NeverLose:Log("info", "Injected from executor: " .. label)
	NeverLose:Notify("Executor detected", label, "info", 4)

	local function has(fn)
		return (type(_G[fn]) == "function")
			or (getgenv and type(getgenv()[fn]) == "function")
			or (type(rawget(getfenv(0), fn)) == "function")
	end
	local required = { "loadstring", "writefile", "readfile", "isfile", "setclipboard" }
	local optional = { "gethui", "appendfile", "identifyexecutor" }
	local missing = {}
	for _, fn in ipairs(required) do if not has(fn) then table.insert(missing, fn) end end
	local optMissing = {}
	for _, fn in ipairs(optional) do if not has(fn) then table.insert(optMissing, fn) end end
	if #missing > 0 then
		local m = "Missing: " .. table.concat(missing, ", ")
		NeverLose:Log("warn", "Weak executor. " .. m)
		NeverLose:Notify("Weak executor", m .. ". Some features may fail.", "warn", 7)
	end
	if #optMissing > 0 then
		NeverLose:Log("info", "Optional unavailable: " .. table.concat(optMissing, ", "))
	end
	return label, missing
end

--============================================================ SAFE EXECUTE
function NeverLose:SafeExecute(source, displayName)
	displayName = displayName or "script"
	NeverLose:Log("info", "Executing " .. displayName .. " ...")
	local runner
	if type(source) == "function" then
		runner = source
	elseif type(source) == "string" then
		runner = function()
			local fn = loadstring(game:HttpGet(source))
			if not fn then error("loadstring returned nil (bad script?)") end
			return fn()
		end
	else
		NeverLose:Notify("Launch failed", "No script source provided.", "error", 6)
		NeverLose:Log("error", "SafeExecute: invalid source " .. type(source))
		return false
	end
	local ok, err = pcall(runner)
	if ok then
		NeverLose:Log("success", displayName .. " executed successfully.")
		NeverLose:Notify("Launched", displayName .. " is now running.", "success", 4)
	else
		NeverLose:Log("error", displayName .. " crashed: " .. tostring(err))
		NeverLose:Notify("Script error", tostring(err), "error", 9)
	end
	return ok, err
end

--============================================================ PRODUCT WINDOW
function NeverLose:CreateProductWindow(gui)
	local Window = Instance.new("Frame", gui)
	Window.Name = "ProductWindow"
	Window.AnchorPoint = Vector2.new(0.5, 0.5)
	Window.Position = UDim2.new(0.5, 0, 0.5, 0)
	Window.Size = UDim2.new(0, 470, 0, 330)
	Window.BackgroundColor3 = NeverLose.ColorBG
	Window.BackgroundTransparency = 1
	Window.Visible = false
	Window.ZIndex = 300
	corner(Window, 12); stroke(Window, NeverLose.ColorStroke, 1, 0.4)
	local WinScale = Instance.new("UIScale", Window); WinScale.Scale = 1
	local Shadow = NeverLose:CreateShadow(Window)

	local Thumb = Instance.new("ImageLabel", Window)
	Thumb.Position = UDim2.new(0, 18, 0, 18); Thumb.Size = UDim2.new(0, 54, 0, 54)
	Thumb.BackgroundColor3 = NeverLose.ColorCard; Thumb.ScaleType = Enum.ScaleType.Crop
	Thumb.ZIndex = 302; corner(Thumb, 10)
	local Title = Instance.new("TextLabel", Window)
	Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 82, 0, 20)
	Title.Size = UDim2.new(1, -120, 0, 24); Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18; Title.TextColor3 = NeverLose.ColorText
	Title.TextXAlignment = Enum.TextXAlignment.Left; Title.ZIndex = 302
	local Sub = Instance.new("TextLabel", Window)
	Sub.BackgroundTransparency = 1; Sub.Position = UDim2.new(0, 82, 0, 46)
	Sub.Size = UDim2.new(1, -120, 0, 18); Sub.Font = Enum.Font.Gotham
	Sub.TextSize = 13; Sub.TextColor3 = NeverLose.ColorSub
	Sub.TextXAlignment = Enum.TextXAlignment.Left; Sub.ZIndex = 302
	local Close = Instance.new("TextLabel", Window)
	Close.BackgroundTransparency = 1; Close.Position = UDim2.new(1, -40, 0, 16)
	Close.Size = UDim2.new(0, 26, 0, 26); Close.Font = Enum.Font.GothamBold
	Close.TextSize = 20; Close.Text = "×"; Close.TextColor3 = NeverLose.ColorSub; Close.ZIndex = 302

	local Info = Instance.new("Frame", Window)
	Info.BackgroundTransparency = 1; Info.Position = UDim2.new(0, 18, 0, 88)
	Info.Size = UDim2.new(0.5, -24, 1, -160); Info.ZIndex = 302
	local InfoList = Instance.new("UIListLayout", Info); InfoList.Padding = UDim.new(0, 6)

	local Log = Instance.new("TextLabel", Window)
	Log.Position = UDim2.new(0.5, 6, 0, 88); Log.Size = UDim2.new(0.5, -24, 1, -160)
	Log.BackgroundColor3 = NeverLose.ColorPanel; Log.Font = Enum.Font.Gotham
	Log.TextSize = 12; Log.TextColor3 = NeverLose.ColorSub
	Log.TextXAlignment = Enum.TextXAlignment.Left; Log.TextYAlignment = Enum.TextYAlignment.Top
	Log.TextWrapped = true; Log.ZIndex = 302; corner(Log, 8)
	local LP = Instance.new("UIPadding", Log)
	LP.PaddingLeft = UDim.new(0, 10); LP.PaddingTop = UDim.new(0, 8); LP.PaddingRight = UDim.new(0, 10)

	local Download = Instance.new("Frame", Window)
	Download.AnchorPoint = Vector2.new(0.5, 1); Download.Position = UDim2.new(0.5, 0, 1, -18)
	Download.Size = UDim2.new(1, -36, 0, 44); Download.BackgroundColor3 = NeverLose.AccentColor
	Download.ZIndex = 302; corner(Download, 10)
	local DownloadText = Instance.new("TextLabel", Download)
	DownloadText.BackgroundTransparency = 1; DownloadText.Size = UDim2.fromScale(1, 1)
	DownloadText.Font = Enum.Font.GothamBold; DownloadText.TextSize = 15
	DownloadText.TextColor3 = Color3.new(1, 1, 1); DownloadText.Text = "▷ Launch"; DownloadText.ZIndex = 303

	local ProductLib = { Unlocked = false }
	local currentData, downloadBusy

	local function setButtonState()
		if ProductLib.Unlocked then
			DownloadText.Text = "▷ Launch"
			NeverLose.PlayAnimate(Download, FastTween, { BackgroundColor3 = NeverLose.AccentColor })
		else
			DownloadText.Text = "🔒 Redeem Key First"
			NeverLose.PlayAnimate(Download, FastTween, { BackgroundColor3 = NeverLose.ColorError })
		end
	end
	function ProductLib:SetUnlocked(state) ProductLib.Unlocked = state and true or false; setButtonState() end

	function ProductLib:Show(data)
		currentData = data
		Thumb.Image = data.Image or ""
		Title.Text = data.Name or "Product"
		Sub.Text = data.Content or ""
		Log.Text = (data.Changelog and data.Changelog ~= "none") and data.Changelog or "No changelog provided."
		for _, c in ipairs(Info:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
		for _, row in ipairs(data.Info or {}) do
			local L = Instance.new("TextLabel", Info)
			L.BackgroundTransparency = 1; L.Size = UDim2.new(1, 0, 0, 18)
			L.Font = Enum.Font.Gotham; L.TextSize = 13; L.RichText = true
			L.TextXAlignment = Enum.TextXAlignment.Left; L.TextColor3 = NeverLose.ColorSub; L.ZIndex = 303
			L.Text = ("<font color='#8a8fa0'>%s</font>  <font color='#ebeef5'>%s</font>"):format(tostring(row.Name), tostring(row.Value))
		end
		setButtonState()
		Window.Visible = true; Window.Size = UDim2.new(0, 470, 0, 330)
		Window.BackgroundTransparency = 1; WinScale.Scale = 0.9
		NeverLose.PlayAnimate(Window, SmoothTween, { BackgroundTransparency = 0 })
		NeverLose.PlayAnimate(WinScale, BounceTween, { Scale = 1 })
		Shadow:Render(true)
	end
	function ProductLib:Hide()
		Shadow:Render(false)
		NeverLose.PlayAnimate(Window, FastTween, { BackgroundTransparency = 1 })
		NeverLose.PlayAnimate(WinScale, TweenInfo.new(0.25, Enum.EasingStyle.Quint), { Scale = 0.9 })
		task.delay(0.28, function() Window.Visible = false end)
	end

	NeverLose:CreateInput(nil, Close, function() ProductLib:Hide() end)
	NeverLose:CreateInput(nil, Download, function()
		if downloadBusy then return end
		if not ProductLib.Unlocked then
			NeverLose:Notify("Locked", "Redeem a valid key to launch this product.", "error", 5); return
		end
		downloadBusy = true; task.delay(1.5, function() downloadBusy = false end)
		if currentData and currentData.OnDownload then pcall(currentData.OnDownload, currentData) end
		if ProductLib.OnLaunch then ProductLib.OnLaunch(currentData) end
	end)
	NeverLose:AddSignal(Close.MouseEnter:Connect(function() fade(Close, { TextColor3 = NeverLose.ColorText }) end))
	NeverLose:AddSignal(Close.MouseLeave:Connect(function() fade(Close, { TextColor3 = NeverLose.ColorSub }) end))
	return ProductLib
end

--============================================================ MAIN
function NeverLose.new(Config)
	Config = Config or {}
	local LoaderLib = { Redeemed = false, Minimized = false, Renderer = {}, Selected = nil }
	LoaderLib.YieldEvent = Instance.new("BindableEvent")

	local Screen = Instance.new("ScreenGui")
	Screen.Name = NeverLose.RandomString()
	Screen.ResetOnSpawn = false
	Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Screen.IgnoreGuiInset = true
	Screen.Parent = GetParent()
	LoaderLib.Screen = Screen
	NeverLose:InitToasts(Screen)

	local LoaderFrame = Instance.new("Frame", Screen)
	LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoaderFrame.Size = UDim2.new(0, 520, 0, 400)
	LoaderFrame.BackgroundColor3 = NeverLose.ColorBG
	LoaderFrame.BackgroundTransparency = 1
	LoaderFrame.ZIndex = 10
	corner(LoaderFrame, 14); stroke(LoaderFrame, NeverLose.ColorStroke, 1, 0.4)
	NeverLose:CreateShadow(LoaderFrame):Render(true)
	local LoaderScale = Instance.new("UIScale", LoaderFrame); LoaderScale.Scale = 1

	-- header
	local Logo = Instance.new("TextLabel", LoaderFrame)
	Logo.BackgroundColor3 = NeverLose.AccentColor; Logo.Position = UDim2.new(0, 18, 0, 16)
	Logo.Size = UDim2.new(0, 40, 0, 32); Logo.Font = Enum.Font.GothamBlack
	Logo.TextSize = 16; Logo.Text = "NL"; Logo.TextColor3 = Color3.new(1, 1, 1); Logo.ZIndex = 12; corner(Logo, 8)
	local HeadTitle = Instance.new("TextLabel", LoaderFrame)
	HeadTitle.BackgroundTransparency = 1; HeadTitle.Position = UDim2.new(0, 68, 0, 15)
	HeadTitle.Size = UDim2.new(1, -180, 0, 20); HeadTitle.Font = Enum.Font.GothamBold
	HeadTitle.TextSize = 17; HeadTitle.TextColor3 = NeverLose.ColorText
	HeadTitle.TextXAlignment = Enum.TextXAlignment.Left; HeadTitle.Text = Config.Name or "Neverlose"; HeadTitle.ZIndex = 12
	local HeadSub = Instance.new("TextLabel", LoaderFrame)
	HeadSub.BackgroundTransparency = 1; HeadSub.Position = UDim2.new(0, 68, 0, 33)
	HeadSub.Size = UDim2.new(1, -180, 0, 16); HeadSub.Font = Enum.Font.Gotham
	HeadSub.TextSize = 13; HeadSub.TextColor3 = NeverLose.ColorSub
	HeadSub.TextXAlignment = Enum.TextXAlignment.Left; HeadSub.Text = Config.Content or "Available Products"; HeadSub.ZIndex = 12
	local MinButton = Instance.new("TextLabel", LoaderFrame)
	MinButton.BackgroundTransparency = 1; MinButton.Position = UDim2.new(1, -70, 0, 14)
	MinButton.Size = UDim2.new(0, 26, 0, 26); MinButton.Font = Enum.Font.GothamBold
	MinButton.TextSize = 20; MinButton.Text = "—"; MinButton.TextColor3 = NeverLose.ColorSub; MinButton.ZIndex = 12
	local CloseButton = Instance.new("TextLabel", LoaderFrame)
	CloseButton.BackgroundTransparency = 1; CloseButton.Position = UDim2.new(1, -40, 0, 14)
	CloseButton.Size = UDim2.new(0, 26, 0, 26); CloseButton.Font = Enum.Font.GothamBold
	CloseButton.TextSize = 20; CloseButton.Text = "×"; CloseButton.TextColor3 = NeverLose.ColorSub; CloseButton.ZIndex = 12

	-- key row
	local KeyBox = Instance.new("Frame", LoaderFrame)
	KeyBox.Position = UDim2.new(0, 18, 0, 62); KeyBox.Size = UDim2.new(1, -160, 0, 40)
	KeyBox.BackgroundColor3 = NeverLose.ColorPanel; KeyBox.ZIndex = 12; corner(KeyBox, 9); stroke(KeyBox, NeverLose.ColorStroke, 1, 0.5)
	local KeyInput = Instance.new("TextBox", KeyBox)
	KeyInput.BackgroundTransparency = 1; KeyInput.Position = UDim2.new(0, 12, 0, 0)
	KeyInput.Size = UDim2.new(1, -24, 1, 0); KeyInput.Font = Enum.Font.Gotham; KeyInput.TextSize = 14
	KeyInput.TextColor3 = NeverLose.ColorText; KeyInput.PlaceholderText = "Paste your key here..."
	KeyInput.PlaceholderColor3 = NeverLose.ColorSub; KeyInput.Text = ""; KeyInput.ClearTextOnFocus = false
	KeyInput.TextXAlignment = Enum.TextXAlignment.Left; KeyInput.ZIndex = 13
	local GetKey = Instance.new("Frame", LoaderFrame)
	GetKey.Position = UDim2.new(1, -134, 0, 62); GetKey.Size = UDim2.new(0, 56, 0, 40)
	GetKey.BackgroundColor3 = NeverLose.ColorPanel; GetKey.ZIndex = 12; corner(GetKey, 9); stroke(GetKey, NeverLose.ColorStroke, 1, 0.5)
	local GetKeyText = Instance.new("TextLabel", GetKey)
	GetKeyText.BackgroundTransparency = 1; GetKeyText.Size = UDim2.fromScale(1, 1)
	GetKeyText.Font = Enum.Font.GothamBold; GetKeyText.TextSize = 13; GetKeyText.TextColor3 = NeverLose.ColorText
	GetKeyText.Text = "Get"; GetKeyText.ZIndex = 13
	local Redeem = Instance.new("Frame", LoaderFrame)
	Redeem.Position = UDim2.new(1, -70, 0, 62); Redeem.Size = UDim2.new(0, 52, 0, 40)
	Redeem.BackgroundColor3 = NeverLose.ColorError; Redeem.ZIndex = 12; corner(Redeem, 9)
	local RedeemText = Instance.new("TextLabel", Redeem)
	RedeemText.BackgroundTransparency = 1; RedeemText.Size = UDim2.fromScale(1, 1)
	RedeemText.Font = Enum.Font.GothamBold; RedeemText.TextSize = 12; RedeemText.TextColor3 = Color3.new(1, 1, 1)
	RedeemText.Text = "Key"; RedeemText.ZIndex = 13

	-- === FIXED PRODUCT LIST ===
	local List = Instance.new("ScrollingFrame", LoaderFrame)
	List.Position = UDim2.new(0, 18, 0, 116)
	List.Size = UDim2.new(1, -36, 1, -134)
	List.BackgroundTransparency = 1
	List.BorderSizePixel = 0
	List.ScrollBarThickness = 4
	List.ScrollBarImageColor3 = NeverLose.ColorStroke
	List.CanvasSize = UDim2.new()
	List.AutomaticCanvasSize = Enum.AutomaticSize.Y
	List.ZIndex = 11
	local ListLayout = Instance.new("UIListLayout", List)
	ListLayout.FillDirection = Enum.FillDirection.Vertical
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ListLayout.Padding = UDim.new(0, 8)
	local ListPad = Instance.new("UIPadding", List)
	ListPad.PaddingTop = UDim.new(0, 2); ListPad.PaddingBottom = UDim.new(0, 2); ListPad.PaddingRight = UDim.new(0, 6)

	local BodyParts = { KeyBox, GetKey, Redeem, List }

	-- key logic
	local redeemBusy = false
	local KeyFile = Config.KeyFile or "neverlose_key.txt"
	local function isKeyEmpty() return (KeyInput.Text:gsub("%s", "") == "") end
	local function UpdateRedeemButton()
		if LoaderLib.Redeemed then
			RedeemText.Text = "Active"; NeverLose.PlayAnimate(Redeem, FastTween, { BackgroundColor3 = NeverLose.ColorSuccess })
		elseif isKeyEmpty() then
			RedeemText.Text = "Key"; NeverLose.PlayAnimate(Redeem, FastTween, { BackgroundColor3 = NeverLose.ColorError })
		else
			RedeemText.Text = "Redeem"; NeverLose.PlayAnimate(Redeem, FastTween, { BackgroundColor3 = NeverLose.AccentColor })
		end
	end

	local ProductWindow = NeverLose:CreateProductWindow(Screen)
	LoaderLib.ProductWindow = ProductWindow
	local function SetRedeemed(state)
		LoaderLib.Redeemed = state; ProductWindow:SetUnlocked(state); UpdateRedeemButton()
	end
	local function TryRedeem()
		if redeemBusy or LoaderLib.Redeemed then return end
		if isKeyEmpty() then NeverLose:Notify("No key", "Enter your key before redeeming.", "warn", 4); return end
		redeemBusy = true; task.delay(0.75, function() redeemBusy = false end)
		local key = KeyInput.Text
		local ok, reason = true, nil
		if Config.OnRedeem then ok, reason = Config.OnRedeem(key) end
		if ok then
			SetRedeemed(true)
			NeverLose:Log("success", "Key redeemed.")
			NeverLose:Notify("Unlocked", "Products are now available.", "success", 4)
			if Config.SaveKey then pcall(function() if writefile then writefile(KeyFile, key) end end) end
		else
			NeverLose:Log("warn", "Redeem failed: " .. tostring(reason))
			NeverLose:Notify("Invalid key", tostring(reason or "This key is not valid."), "error", 6)
		end
	end

	NeverLose:CreateInput(nil, Redeem, TryRedeem)
	NeverLose:CreateInput(nil, GetKey, function()
		if Config.OnGetKey then pcall(Config.OnGetKey) end
		NeverLose:Notify("Key link copied", "The key page link was copied to clipboard.", "info", 4)
	end)
	NeverLose:AddSignal(KeyInput:GetPropertyChangedSignal("Text"):Connect(UpdateRedeemButton))
	NeverLose:AddSignal(KeyInput.FocusLost:Connect(function(enter) if enter then TryRedeem() end end))
	if Config.SaveKey and isfile and isfile(KeyFile) then
		pcall(function()
			local saved = readfile(KeyFile)
			if saved and #saved > 0 then KeyInput.Text = saved; task.defer(TryRedeem) end
		end)
	end

	-- cards
	for i, v in ipairs(Config.Versions or {}) do
		local Card = Instance.new("Frame", List)
		Card.BackgroundColor3 = NeverLose.ColorCard
		Card.BackgroundTransparency = 0.05
		Card.BorderSizePixel = 0
		Card.Size = UDim2.new(1, 0, 0, 68)
		Card.LayoutOrder = i
		Card.ZIndex = 12
		corner(Card, 10)
		local CardStroke = stroke(Card, NeverLose.ColorStroke, 1, 0.65)
		local CardScale = Instance.new("UIScale", Card); CardScale.Scale = 1

		local Img = Instance.new("ImageLabel", Card)
		Img.Position = UDim2.new(0, 10, 0, 10); Img.Size = UDim2.new(0, 48, 0, 48)
		Img.BackgroundColor3 = NeverLose.ColorPanel; Img.Image = v.Image or ""
		Img.ScaleType = Enum.ScaleType.Crop; Img.ZIndex = 13; corner(Img, 8)
		local Dot = Instance.new("Frame", Img)
		Dot.AnchorPoint = Vector2.new(1, 1); Dot.Position = UDim2.new(1, -3, 1, -3)
		Dot.Size = UDim2.new(0, 10, 0, 10); Dot.BackgroundColor3 = v.Dot or NeverLose.AccentColor; Dot.ZIndex = 14; corner(Dot, 5)

		local Name = Instance.new("TextLabel", Card)
		Name.BackgroundTransparency = 1; Name.Position = UDim2.new(0, 70, 0, 14)
		Name.Size = UDim2.new(1, -110, 0, 20); Name.Font = Enum.Font.GothamBold
		Name.TextSize = 15; Name.TextColor3 = NeverLose.ColorText
		Name.TextXAlignment = Enum.TextXAlignment.Left; Name.TextTruncate = Enum.TextTruncate.AtEnd
		Name.Text = v.Name or "Product"; Name.ZIndex = 13
		local Desc = Instance.new("TextLabel", Card)
		Desc.BackgroundTransparency = 1; Desc.Position = UDim2.new(0, 70, 0, 34)
		Desc.Size = UDim2.new(1, -110, 0, 18); Desc.Font = Enum.Font.Gotham
		Desc.TextSize = 12; Desc.TextColor3 = NeverLose.ColorSub
		Desc.TextXAlignment = Enum.TextXAlignment.Left; Desc.TextTruncate = Enum.TextTruncate.AtEnd
		Desc.Text = v.Content or ""; Desc.ZIndex = 13
		local Arrow = Instance.new("TextLabel", Card)
		Arrow.BackgroundTransparency = 1; Arrow.AnchorPoint = Vector2.new(1, 0.5)
		Arrow.Position = UDim2.new(1, -14, 0.5, 0); Arrow.Size = UDim2.new(0, 24, 0, 24)
		Arrow.Font = Enum.Font.GothamBold; Arrow.TextSize = 18; Arrow.Text = "›"
		Arrow.TextColor3 = NeverLose.ColorSub; Arrow.ZIndex = 13

		NeverLose:AddSignal(Card.MouseEnter:Connect(function()
			NeverLose.PlayAnimate(CardScale, PopTween, { Scale = 1.02 })
			NeverLose.PlayAnimate(CardStroke, SlowyTween, { Color = NeverLose.AccentColor, Transparency = 0.35 })
			fade(Arrow, { TextColor3 = NeverLose.AccentColor })
		end))
		NeverLose:AddSignal(Card.MouseLeave:Connect(function()
			NeverLose.PlayAnimate(CardScale, PopTween, { Scale = 1 })
			NeverLose.PlayAnimate(CardStroke, SlowyTween, { Color = NeverLose.ColorStroke, Transparency = 0.65 })
			fade(Arrow, { TextColor3 = NeverLose.ColorSub })
		end))
		NeverLose:CreateInput(nil, Card, function()
			ProductWindow.OnLaunch = function(data)
				LoaderLib.Selected = v.Idx
				local src = v.Execute or v.ScriptUrl
				if src then
					ProductWindow:Hide(); LoaderLib:SetRender(false); task.wait(0.2)
					NeverLose:SafeExecute(src, v.Name)
				end
				LoaderLib.YieldEvent:Fire(v.Idx)
			end
			ProductWindow:Show(v)
		end)

		table.insert(LoaderLib.Renderer, function(show)
			Card.Visible = show
			if show then
				Card.BackgroundTransparency = 1; CardScale.Scale = 0.95
				NeverLose.PlayAnimate(Card, SmoothTween, { BackgroundTransparency = 0.05 })
				NeverLose.PlayAnimate(CardScale, BounceTween, { Scale = 1 })
			end
		end)
	end

	-- minimize / close / drag
	local function SetMinimized(state)
		LoaderLib.Minimized = state
		MinButton.Text = state and "+" or "—"
		NeverLose.PlayAnimate(LoaderFrame, SmoothTween, {
			Size = state and UDim2.new(0, 520, 0, 54) or UDim2.new(0, 520, 0, 400)
		})
		if state then
			for _, o in ipairs(BodyParts) do fade(o, { BackgroundTransparency = 1 }) end
			task.delay(0.22, function()
				if LoaderLib.Minimized then for _, o in ipairs(BodyParts) do o.Visible = false end end
			end)
		else
			for _, o in ipairs(BodyParts) do o.Visible = true end
			KeyBox.BackgroundTransparency = 0; GetKey.BackgroundTransparency = 0; List.BackgroundTransparency = 1
			UpdateRedeemButton()
		end
	end
	NeverLose:CreateInput(nil, MinButton, function() SetMinimized(not LoaderLib.Minimized) end)
	NeverLose:CreateInput(nil, CloseButton, function() LoaderLib:Unload() end)

	do
		local dragging, dragStart, startPos
		local Header = Instance.new("TextButton", LoaderFrame)
		Header.BackgroundTransparency = 1; Header.Text = ""
		Header.Size = UDim2.new(1, -120, 0, 50); Header.Position = UDim2.new(0, 0, 0, 0); Header.ZIndex = 11
		NeverLose:AddSignal(Header.MouseButton1Down:Connect(function(x, y)
			dragging = true; dragStart = Vector2.new(x, y); startPos = LoaderFrame.Position
		end))
		NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
				LoaderFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end))
		NeverLose:AddSignal(UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end))
	end

	for _, b in ipairs({ MinButton, CloseButton }) do
		NeverLose:AddSignal(b.MouseEnter:Connect(function() fade(b, { TextColor3 = NeverLose.ColorText }) end))
		NeverLose:AddSignal(b.MouseLeave:Connect(function() fade(b, { TextColor3 = NeverLose.ColorSub }) end))
	end

	-- API
	function LoaderLib:SetRender(value)
		if value then
			LoaderFrame.Visible = true; LoaderFrame.Size = UDim2.new(0, 520, 0, 400); LoaderScale.Scale = 0.9
			NeverLose.PlayAnimate(LoaderFrame, SmoothTween, { BackgroundTransparency = 0 })
			NeverLose.PlayAnimate(LoaderScale, BounceTween, { Scale = 1 })
			for i, Render in ipairs(LoaderLib.Renderer) do task.delay(0.05 * i, function() Render(true) end) end
		else
			NeverLose.PlayAnimate(LoaderFrame, FastTween, { BackgroundTransparency = 1 })
			NeverLose.PlayAnimate(LoaderScale, SlowyTween, { Scale = 0.9 })
			task.delay(0.25, function() LoaderFrame.Visible = false end)
		end
	end
	function LoaderLib:Await() return LoaderLib.YieldEvent.Event:Wait() end
	function LoaderLib:Unload()
		LoaderLib:SetRender(false); task.wait(0.3)
		for _, c in ipairs(NeverLose.Connections) do pcall(function() c:Disconnect() end) end
		if Screen then Screen:Destroy() end
		NeverLose:Log("info", "Loader unloaded.")
	end

	UpdateRedeemButton()
	NeverLose:CheckExecutor()
	NeverLose:Notify("Loader ready", "Redeem your key to unlock products.", "info", 5)
	task.delay(0.2, function() LoaderLib:SetRender(true) end)
	return LoaderLib
end

return NeverLose
