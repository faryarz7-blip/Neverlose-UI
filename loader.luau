do
	local Constant = 'LPH_'..'NO_VIRTUALIZE';
	getfenv()[Constant] = getfenv()[Constant] or function(f) return f end;
end;

local NeverLose = {};

NeverLose.BuiltInRegular = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Regular,Enum.FontStyle.Normal);
NeverLose.BuiltInBold = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Bold,Enum.FontStyle.Normal);
NeverLose.GlobalSignals = {};

local cloneref: cloneref = cloneref or function(f) return f end;
local TweenService: TweenService = cloneref(game:GetService('TweenService'));
local UserInputService: UserInputService = cloneref(game:GetService('UserInputService'));
local TextService: TextService = cloneref(game:GetService('TextService'));
local RunService: RunService = cloneref(game:GetService('RunService'));
local Players: Players = cloneref(game:GetService('Players'));
local HttpService: HttpService = cloneref(game:GetService('HttpService'));
local LocalPlayer: Player = Players.LocalPlayer;
local CoreGui: PlayerGui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or cloneref(game:FindFirstChild('CoreGui')) or cloneref(LocalPlayer.PlayerGui);
local Mouse: Mouse = LocalPlayer:GetMouse();
local CurrentCamera: Camera = cloneref(workspace.CurrentCamera);
local ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end;
local GlobalWindow = Instance.new('ScreenGui');
local ManualTween = TweenInfo.new(0.1);
local SlowyTween = TweenInfo.new(0.175);
local FastTween = TweenInfo.new(0.05);
local VSlowTween = TweenInfo.new(0.5,Enum.EasingStyle.Quint);
local Encryption = {};

NeverLose.RandomString = LPH_NO_VIRTUALIZE(function()
	return string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4));
end);

ProtectGui(GlobalWindow);

GlobalWindow.Name = NeverLose.RandomString();
GlobalWindow.IgnoreGuiInset = true;
GlobalWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global;
GlobalWindow.ResetOnSpawn = false;
GlobalWindow.Parent = CoreGui;
NeverLose.ScreenGui = GlobalWindow;
NeverLose.AccentColor = Color3.fromRGB(78, 127, 252);
NeverLose.RegisiteryColor = {};

function NeverLose:AddSignal(RBXSignal)
	if NeverLose.UnloadEnabled then
		table.insert(NeverLose.GlobalSignals,RBXSignal);	
	end;

	return RBXSignal;
end;

NeverLose.IsStudio = RunService:IsStudio();
NeverLose.IsMobile = UserInputService.TouchEnabled;

NeverLose.CreateInput = LPH_NO_VIRTUALIZE(function(self , Frame , Callback)
	local Button = Instance.new('ImageButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.ImageTransparency = 1;
	Button.Image = "rbxasset://textures/translateIcon.png";

	if Callback then
		local bth_signal = Button.MouseButton1Click:Connect(Callback);

		return bth_signal;
	end;

	return Button;
end);

NeverLose.PlayAnimate = LPH_NO_VIRTUALIZE(function(Self , Info , Property)
	local Tween = TweenService:Create(Self , Info or TweenInfo.new(0.25) , Property);

	Tween:Play();

	return Tween;
end);

function NeverLose:RollingEffect(parent)
	local UIGradient = Instance.new("UIGradient")

	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.5), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient.Parent = parent

	return UIGradient;
end;

function NeverLose:MarkLoad(LoaderFrame)
	local LoadingFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local IconFrame = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local Icon = Instance.new("TextLabel")

	LoadingFrame.Name = NeverLose.RandomString();
	LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
	LoadingFrame.BackgroundTransparency = 0.500
	LoadingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LoadingFrame.BorderSizePixel = 0
	LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
	LoadingFrame.ZIndex = 100

	UICorner.Parent = LoadingFrame

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = LoadingFrame

	IconFrame.Name = NeverLose.RandomString();
	IconFrame.Parent = LoadingFrame
	IconFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	IconFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	IconFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	IconFrame.BorderSizePixel = 0
	IconFrame.ClipsDescendants = true
	IconFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	IconFrame.Size = UDim2.new(0.300000012, 0, 0.300000012, 0)
	IconFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	IconFrame.ZIndex = 101

	UICorner_2.Parent = IconFrame

	UIStroke_2.Transparency = 0.650
	UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
	UIStroke_2.Parent = IconFrame

	Icon.Name = NeverLose.RandomString();
	Icon.Parent = IconFrame
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
	Icon.BackgroundTransparency = 1.000
	Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon.BorderSizePixel = 0
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
	Icon.ZIndex = 102
	Icon.FontFace = NeverLose.BuiltInBold
	Icon.Text = "arrow-spin-clockwise"
	Icon.TextColor3 = Color3.fromRGB(78, 127, 252)
	Icon.TextSize = 30.000
	Icon.TextTransparency = 0.250
	Icon.TextWrapped = true

	local lib = {};

	lib.SetValue = LPH_NO_VIRTUALIZE(function(value)
		if lib.Thread then
			task.cancel(lib.Thread);
			lib.Thread = nil;
		end;

		if value then
			LoadingFrame.Parent = LoaderFrame;

			NeverLose.PlayAnimate(LoadingFrame,SlowyTween,{
				BackgroundTransparency = 0.500
			})	

			NeverLose.PlayAnimate(UIStroke,SlowyTween,{
				Transparency = 0.650
			})	

			NeverLose.PlayAnimate(IconFrame,SlowyTween,{
				BackgroundTransparency = 0,
				Size = UDim2.new(0.300000012, 0, 0.300000012, 0)
			})	

			NeverLose.PlayAnimate(UIStroke_2,SlowyTween,{
				Transparency = 0.650
			})	

			NeverLose.PlayAnimate(Icon,SlowyTween,{
				TextTransparency = 0.250
			})	

			lib.Thread = task.spawn(function()
				while true do task.wait()
					NeverLose.PlayAnimate(Icon,SlowyTween,{
						Rotation = Icon.Rotation + 45
					})
				end;
			end);
		else
			NeverLose.PlayAnimate(LoadingFrame,SlowyTween,{
				BackgroundTransparency = 1
			})	

			NeverLose.PlayAnimate(UIStroke,SlowyTween,{
				Transparency = 1
			})	

			NeverLose.PlayAnimate(IconFrame,SlowyTween,{
				BackgroundTransparency = 1,
				Size = UDim2.new(0.15, 0, 0.15, 0)
			})	

			NeverLose.PlayAnimate(UIStroke_2,SlowyTween,{
				Transparency = 1
			})	

			NeverLose.PlayAnimate(Icon,SlowyTween,{
				TextTransparency = 1
			})	
		end;
	end);

	lib.SetValue(false);

	return lib;
end;

function NeverLose:CreateShadow(parent , RollingEffect)
	local Shadow = {};

	local UIShadowSafe85 = Instance.new("UIStroke")
	local UIShadowSafe65 = Instance.new("UIStroke")
	local UIShadowSafe50 = Instance.new("UIStroke")
	local UIShadowSafe45 = Instance.new("UIStroke")

	UIShadowSafe85.Thickness = 6.000
	UIShadowSafe85.Transparency = 1
	UIShadowSafe85.Parent = parent

	UIShadowSafe65.Thickness = 5.000
	UIShadowSafe65.Transparency = 1
	UIShadowSafe65.Parent = parent

	UIShadowSafe50.Thickness = 4.000
	UIShadowSafe50.Transparency = 1
	UIShadowSafe50.Parent = parent

	UIShadowSafe45.Thickness = 3.000
	UIShadowSafe45.Transparency = 1
	UIShadowSafe45.Parent = parent

	local RollingEffectThread;
	local r1,r2,r3,r4;

	if RollingEffect then
		r1 = NeverLose:RollingEffect(UIShadowSafe85);
		r2 = NeverLose:RollingEffect(UIShadowSafe65);
		r3 = NeverLose:RollingEffect(UIShadowSafe50);
		r4 = NeverLose:RollingEffect(UIShadowSafe45);
	end;

	Shadow.Render = LPH_NO_VIRTUALIZE(function(self , value)
		if RollingEffectThread then
			task.cancel(RollingEffectThread);
			RollingEffectThread = nil;
		end;

		if value then
			NeverLose.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = 0.900
			})

			NeverLose.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = 0.900
			})

			NeverLose.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = 0.900
			})

			NeverLose.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = 0.900
			})

			if RollingEffect then
				RollingEffectThread = task.spawn(function()
					local level = 20;
					while true do task.wait(0.025)
						NeverLose.PlayAnimate(r1 , SlowyTween , {
							Rotation = r1.Rotation + level
						});

						NeverLose.PlayAnimate(r2 , SlowyTween , {
							Rotation = r2.Rotation + level
						});

						NeverLose.PlayAnimate(r3 , SlowyTween , {
							Rotation = r3.Rotation + level
						});

						NeverLose.PlayAnimate(r4 , SlowyTween , {
							Rotation = r4.Rotation + level
						});
					end;
				end);
			end;
		else
			NeverLose.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = 1
			})
		end;
	end);

	return Shadow;
end;

NeverLose.ProcessParams = LPH_NO_VIRTUALIZE(function(self , Params , Fixed)
	Params = Params or {};

	local k = Params or {};

	for i,v in next , Fixed do
		rawset(k,i , rawget(Params,i) or v)
	end;

	table.clear(Fixed);

	return k;
end);

function NeverLose.new(Config)
	Config = NeverLose:ProcessParams(Config , {
		Name = "Подписки",
		Content = "Доступные подписки",
		Process = "Script will automatically load.",
		Default = "",
		Yield = true,
		Profile = LocalPlayer.Name,
		Links = {
			{ Name = "Сайт" },
			{ Name = "Поддержка" },
			{ Name = "Маркет" },
		},
		DefaultVersion = nil,
		Versions = {},
		OnGetKey = function() end,
		OnRedeem = function() end,
	});

	local LoaderLib = {};
	local LoaderFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")

	local Sidebar = Instance.new("Frame")
	local Logo = Instance.new("TextLabel")
	local NavHolder = Instance.new("Frame")
	local NavLayout = Instance.new("UIListLayout")
	local Profile = Instance.new("Frame")
	local Avatar = Instance.new("ImageLabel")
	local AvatarCorner = Instance.new("UICorner")
	local ProfileName = Instance.new("TextLabel")

	local Content = Instance.new("Frame")
	local WindowName = Instance.new("TextLabel")
	local WindowContent = Instance.new("TextLabel")
	local MinButton = Instance.new("TextLabel")
	local CloseButton = Instance.new("TextLabel")

	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")

	local InputFrame = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local KeyIcon = Instance.new("TextLabel")
	local TextBox = Instance.new("TextBox")

	local KeyFrame = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local Content_Key = Instance.new("TextLabel")
	local Icon_Key = Instance.new("TextLabel")

	local RedeemFrame = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local Content_Redeem = Instance.new("TextLabel")
	local Icon_Redeem = Instance.new("TextLabel")

	local Shadow = NeverLose:CreateShadow(LoaderFrame,true);

	local function fade(inst, props)
		NeverLose.PlayAnimate(inst, SlowyTween, props);
	end

	LoaderLib.MarkLoad = NeverLose:MarkLoad(LoaderFrame);
	LoaderLib.YieldEvent = Instance.new('BindableEvent',LoaderFrame);

	LoaderFrame.Name = "LOADER="..NeverLose.RandomString();
	LoaderFrame.Parent = NeverLose.ScreenGui
	LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LoaderFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 16)
	LoaderFrame.BorderSizePixel = 0
	LoaderFrame.ClipsDescendants = true
	LoaderFrame.Position = UDim2.new(255,255,255,255)
	LoaderFrame.Size = UDim2.new(0, 520, 0, 15)

	UICorner.CornerRadius = UDim.new(0, 14)
	UICorner.Parent = LoaderFrame

	Sidebar.Name = NeverLose.RandomString();
	Sidebar.Parent = LoaderFrame
	Sidebar.BackgroundTransparency = 1
	Sidebar.BorderSizePixel = 0
	Sidebar.Position = UDim2.new(0, 0, 0, 0)
	Sidebar.Size = UDim2.new(0, 160, 1, 0)
	Sidebar.ZIndex = 6

	Logo.Name = NeverLose.RandomString();
	Logo.Parent = Sidebar
	Logo.BackgroundTransparency = 1
	Logo.Position = UDim2.new(0, 24, 0, 20)
	Logo.Size = UDim2.new(0, 90, 0, 46)
	Logo.ZIndex = 7
	Logo.Font = Enum.Font.GothamBlack
	Logo.Text = "NL"
	Logo.TextColor3 = NeverLose.AccentColor
	Logo.TextSize = 34.000
	Logo.TextXAlignment = Enum.TextXAlignment.Left

	NavHolder.Name = NeverLose.RandomString();
	NavHolder.Parent = Sidebar
	NavHolder.BackgroundTransparency = 1
	NavHolder.Position = UDim2.new(0, 24, 0, 96)
	NavHolder.Size = UDim2.new(1, -34, 0, 160)
	NavHolder.ZIndex = 7

	NavLayout.Parent = NavHolder
	NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NavLayout.Padding = UDim.new(0, 16)

	local NavButtons = {};

	for i,link in next , Config.Links do
		local NavItem = Instance.new("TextButton")
		NavItem.Name = NeverLose.RandomString();
		NavItem.Parent = NavHolder
		NavItem.BackgroundTransparency = 1
		NavItem.Size = UDim2.new(1, 0, 0, 20)
		NavItem.ZIndex = 7
		NavItem.Font = Enum.Font.GothamMedium
		NavItem.Text = link.Name
		NavItem.TextColor3 = Color3.fromRGB(200, 200, 210)
		NavItem.TextSize = 15.000
		NavItem.TextTransparency = 0.25
		NavItem.TextXAlignment = Enum.TextXAlignment.Left
		NavItem.AutoButtonColor = false

		NeverLose:AddSignal(NavItem.MouseEnter:Connect(function()
			fade(NavItem, { TextColor3 = NeverLose.AccentColor, TextTransparency = 0 })
		end))
		NeverLose:AddSignal(NavItem.MouseLeave:Connect(function()
			fade(NavItem, { TextColor3 = Color3.fromRGB(200, 200, 210), TextTransparency = 0.25 })
		end))
		NeverLose:AddSignal(NavItem.MouseButton1Click:Connect(function()
			if link.Callback then link.Callback() end;
		end))

		table.insert(NavButtons, NavItem);
	end;

	Profile.Name = NeverLose.RandomString();
	Profile.Parent = Sidebar
	Profile.AnchorPoint = Vector2.new(0, 1)
	Profile.BackgroundTransparency = 1
	Profile.BorderSizePixel = 0
	Profile.Position = UDim2.new(0, 18, 1, -18)
	Profile.Size = UDim2.new(1, -24, 0, 36)
	Profile.ZIndex = 7

	Avatar.Name = NeverLose.RandomString();
	Avatar.Parent = Profile
	Avatar.AnchorPoint = Vector2.new(0, 0.5)
	Avatar.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
	Avatar.BorderSizePixel = 0
	Avatar.Position = UDim2.new(0, 0, 0.5, 0)
	Avatar.Size = UDim2.new(0, 34, 0, 34)
	Avatar.ZIndex = 8

	AvatarCorner.CornerRadius = UDim.new(1, 0)
	AvatarCorner.Parent = Avatar

	pcall(function()
		Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	end)

	ProfileName.Name = NeverLose.RandomString();
	ProfileName.Parent = Profile
	ProfileName.AnchorPoint = Vector2.new(0, 0.5)
	ProfileName.BackgroundTransparency = 1
	ProfileName.Position = UDim2.new(0, 44, 0.5, 0)
	ProfileName.Size = UDim2.new(1, -44, 1, 0)
	ProfileName.ZIndex = 8
	ProfileName.Font = Enum.Font.GothamBold
	ProfileName.Text = Config.Profile
	ProfileName.TextColor3 = Color3.fromRGB(255, 255, 255)
	ProfileName.TextSize = 15.000
	ProfileName.TextXAlignment = Enum.TextXAlignment.Left

	Content.Name = NeverLose.RandomString();
	Content.Parent = LoaderFrame
	Content.BackgroundTransparency = 1
	Content.BorderSizePixel = 0
	Content.Position = UDim2.new(0, 160, 0, 0)
	Content.Size = UDim2.new(1, -160, 1, 0)
	Content.ZIndex = 6

	WindowName.Name = NeverLose.RandomString();
	WindowName.Parent = Content
	WindowName.BackgroundTransparency = 1.000
	WindowName.Position = UDim2.new(0, 6, 0, 22)
	WindowName.Size = UDim2.new(1, -90, 0, 26)
	WindowName.ZIndex = 7
	WindowName.Font = Enum.Font.GothamBold
	WindowName.Text = Config.Name
	WindowName.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.TextSize = 20.000
	WindowName.TextXAlignment = Enum.TextXAlignment.Left

	WindowContent.Name = NeverLose.RandomString();
	WindowContent.Parent = Content
	WindowContent.BackgroundTransparency = 1.000
	WindowContent.Position = UDim2.new(0, 6, 0, 48)
	WindowContent.Size = UDim2.new(1, -90, 0, 18)
	WindowContent.ZIndex = 7
	WindowContent.Font = Enum.Font.GothamMedium
	WindowContent.Text = Config.Content
	WindowContent.TextColor3 = Color3.fromRGB(140, 145, 160)
	WindowContent.TextSize = 13.000
	WindowContent.TextTransparency = 0.150
	WindowContent.TextXAlignment = Enum.TextXAlignment.Left

	MinButton.Name = NeverLose.RandomString();
	MinButton.Parent = Content
	MinButton.AnchorPoint = Vector2.new(1, 0)
	MinButton.BackgroundTransparency = 1
	MinButton.Position = UDim2.new(1, -42, 0, 24)
	MinButton.Size = UDim2.new(0, 22, 0, 22)
	MinButton.ZIndex = 8
	MinButton.Font = Enum.Font.GothamBold
	MinButton.Text = "—"
	MinButton.TextColor3 = Color3.fromRGB(200, 200, 210)
	MinButton.TextSize = 18.000
	MinButton.TextTransparency = 0.35

	CloseButton.Name = NeverLose.RandomString();
	CloseButton.Parent = Content
	CloseButton.AnchorPoint = Vector2.new(1, 0)
	CloseButton.BackgroundTransparency = 1
	CloseButton.Position = UDim2.new(1, -12, 0, 24)
	CloseButton.Size = UDim2.new(0, 22, 0, 22)
	CloseButton.ZIndex = 8
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = "×"
	CloseButton.TextColor3 = Color3.fromRGB(200, 200, 210)
	CloseButton.TextSize = 22.000
	CloseButton.TextTransparency = 0.35

	ScrollingFrame.Name = NeverLose.RandomString();
	ScrollingFrame.Parent = Content
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 82)
	ScrollingFrame.Size = UDim2.new(1, -16, 1, -172)
	ScrollingFrame.ZIndex = 7
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 8)

	NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 4)
	end))

	InputFrame.Name = "InputFrame"
	InputFrame.Parent = Content
	InputFrame.AnchorPoint = Vector2.new(0.5, 1)
	InputFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
	InputFrame.BorderSizePixel = 0
	InputFrame.Position = UDim2.new(0.5, 0, 1, -58)
	InputFrame.Size = UDim2.new(1, -16, 0, 38)
	InputFrame.ZIndex = 10

	UICorner_2.CornerRadius = UDim.new(0, 10)
	UICorner_2.Parent = InputFrame

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = InputFrame

	KeyIcon.Name = NeverLose.RandomString();
	KeyIcon.Parent = InputFrame
	KeyIcon.AnchorPoint = Vector2.new(0, 0.5)
	KeyIcon.BackgroundTransparency = 1
	KeyIcon.Position = UDim2.new(0, 12, 0.5, 0)
	KeyIcon.Size = UDim2.new(0, 18, 0, 18)
	KeyIcon.ZIndex = 17
	KeyIcon.FontFace = NeverLose.BuiltInBold
	KeyIcon.Text = "key"
	KeyIcon.TextColor3 = NeverLose.AccentColor
	KeyIcon.TextSize = 16.000
	KeyIcon.TextTransparency = 0.25
	KeyIcon.TextWrapped = true

	TextBox.Name = NeverLose.RandomString();
	TextBox.Parent = InputFrame
	TextBox.AnchorPoint = Vector2.new(0, 0.5)
	TextBox.BackgroundTransparency = 1.000
	TextBox.Position = UDim2.new(0, 38, 0.5, 0)
	TextBox.Size = UDim2.new(1, -48, 0, 30)
	TextBox.ZIndex = 17
	TextBox.ClearTextOnFocus = false
	TextBox.Font = Enum.Font.GothamMedium
	TextBox.PlaceholderText = "Product Key"
	TextBox.Text = Config.Default
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 12.000
	TextBox.TextTransparency = 0.350
	TextBox.TextXAlignment = Enum.TextXAlignment.Left

	KeyFrame.Name = NeverLose.RandomString();
	KeyFrame.Parent = Content
	KeyFrame.AnchorPoint = Vector2.new(0, 1)
	KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
	KeyFrame.BorderSizePixel = 0
	KeyFrame.Position = UDim2.new(0, 8, 1, -12)
	KeyFrame.Size = UDim2.new(0.5, -12, 0, 38)
	KeyFrame.ZIndex = 10

	UICorner_3.CornerRadius = UDim.new(0, 10)
	UICorner_3.Parent = KeyFrame

	UIStroke_2.Transparency = 0.650
	UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
	UIStroke_2.Parent = KeyFrame

	Content_Key.Name = NeverLose.RandomString();
	Content_Key.Parent = KeyFrame
	Content_Key.AnchorPoint = Vector2.new(0, 0.5)
	Content_Key.BackgroundTransparency = 1.000
	Content_Key.Position = UDim2.new(0, 38, 0.5, 0)
	Content_Key.Size = UDim2.new(1, -40, 0, 25)
	Content_Key.ZIndex = 17
	Content_Key.Font = Enum.Font.GothamBold
	Content_Key.Text = "Get Key"
	Content_Key.TextColor3 = Color3.fromRGB(235, 235, 240)
	Content_Key.TextSize = 14.000
	Content_Key.TextTransparency = 0.200
	Content_Key.TextXAlignment = Enum.TextXAlignment.Left

	Icon_Key.Name = NeverLose.RandomString();
	Icon_Key.Parent = KeyFrame
	Icon_Key.AnchorPoint = Vector2.new(0, 0.5)
	Icon_Key.BackgroundTransparency = 1.000
	Icon_Key.Position = UDim2.new(0, 12, 0.5, 0)
	Icon_Key.Size = UDim2.new(0, 20, 0, 20)
	Icon_Key.ZIndex = 17
	Icon_Key.FontFace = NeverLose.BuiltInBold
	Icon_Key.Text = "chain-link"
	Icon_Key.TextColor3 = NeverLose.AccentColor
	Icon_Key.TextSize = 17.000
	Icon_Key.TextTransparency = 0.250
	Icon_Key.TextWrapped = true

	RedeemFrame.Name = "RedeemFrame"
	RedeemFrame.Parent = Content
	RedeemFrame.AnchorPoint = Vector2.new(1, 1)
	RedeemFrame.BackgroundColor3 = NeverLose.AccentColor
	RedeemFrame.BorderSizePixel = 0
	RedeemFrame.Position = UDim2.new(1, -8, 1, -12)
	RedeemFrame.Size = UDim2.new(0.5, -12, 0, 38)
	RedeemFrame.ZIndex = 10

	UICorner_4.CornerRadius = UDim.new(0, 10)
	UICorner_4.Parent = RedeemFrame

	Content_Redeem.Name = NeverLose.RandomString();
	Content_Redeem.Parent = RedeemFrame
	Content_Redeem.AnchorPoint = Vector2.new(0, 0.5)
	Content_Redeem.BackgroundTransparency = 1.000
	Content_Redeem.Position = UDim2.new(0, 38, 0.5, 0)
	Content_Redeem.Size = UDim2.new(1, -40, 0, 25)
	Content_Redeem.ZIndex = 17
	Content_Redeem.Font = Enum.Font.GothamBold
	Content_Redeem.Text = "Redeem"
	Content_Redeem.TextColor3 = Color3.fromRGB(255, 255, 255)
	Content_Redeem.TextSize = 14.000
	Content_Redeem.TextTransparency = 0.000
	Content_Redeem.TextXAlignment = Enum.TextXAlignment.Left

	Icon_Redeem.Name = NeverLose.RandomString();
	Icon_Redeem.Parent = RedeemFrame
	Icon_Redeem.AnchorPoint = Vector2.new(0, 0.5)
	Icon_Redeem.BackgroundTransparency = 1.000
	Icon_Redeem.Position = UDim2.new(0, 12, 0.5, 0)
	Icon_Redeem.Size = UDim2.new(0, 20, 0, 20)
	Icon_Redeem.ZIndex = 17
	Icon_Redeem.FontFace = NeverLose.BuiltInBold
	Icon_Redeem.Text = "gift-card"
	Icon_Redeem.TextColor3 = Color3.fromRGB(255, 255, 255)
	Icon_Redeem.TextSize = 17.000
	Icon_Redeem.TextTransparency = 0.000
	Icon_Redeem.TextWrapped = true

	local VersionItems = {};
	LoaderLib.Renderer = {};

	for i,v in next , Config.Versions do
		local VersionProcess = {};

		VersionItems[v.Idx] = VersionProcess;

		local VersionFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local Dot = Instance.new("Frame")
		local DotCorner = Instance.new("UICorner")
		local VersionName = Instance.new("TextLabel")
		local VersionContent = Instance.new("TextLabel")
		local VersionIcon = Instance.new("ImageLabel")
		local VersionIconCorner = Instance.new("UICorner")
		local VersionGlyph = Instance.new("TextLabel")

		local hasDot = v.Dot ~= nil;
		local nameX = hasDot and 30 or 16;

		VersionFrame.Name = NeverLose.RandomString();
		VersionFrame.Parent = ScrollingFrame
		VersionFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
		VersionFrame.BackgroundTransparency = v.Locked and 0.55 or 0.050
		VersionFrame.BorderSizePixel = 0
		VersionFrame.Size = UDim2.new(1, -4, 0, 64)
		VersionFrame.ZIndex = 15

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = VersionFrame

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = VersionFrame

		Dot.Name = NeverLose.RandomString();
		Dot.Parent = VersionFrame
		Dot.AnchorPoint = Vector2.new(0, 0)
		Dot.BackgroundColor3 = typeof(v.Dot) == "Color3" and v.Dot or NeverLose.AccentColor
		Dot.BackgroundTransparency = hasDot and 0 or 1
		Dot.BorderSizePixel = 0
		Dot.Position = UDim2.new(0, 16, 0, 18)
		Dot.Size = UDim2.new(0, 7, 0, 7)
		Dot.ZIndex = 16

		DotCorner.CornerRadius = UDim.new(1, 0)
		DotCorner.Parent = Dot

		VersionName.Name = NeverLose.RandomString();
		VersionName.Parent = VersionFrame
		VersionName.BackgroundTransparency = 1.000
		VersionName.Position = UDim2.new(0, nameX, 0, 12)
		VersionName.Size = UDim2.new(1, -nameX-55, 0, 22)
		VersionName.ZIndex = 16
		VersionName.Font = Enum.Font.GothamBold
		VersionName.Text = v.Name
		VersionName.TextColor3 = v.Locked and NeverLose.AccentColor or Color3.fromRGB(255, 255, 255)
		VersionName.TextSize = 16.000
		VersionName.TextTransparency = 0.100
		VersionName.TextXAlignment = Enum.TextXAlignment.Left

		VersionContent.Name = "VersionContent"
		VersionContent.Parent = VersionFrame
		VersionContent.BackgroundTransparency = 1.000
		VersionContent.Position = UDim2.new(0, 16, 0, 34)
		VersionContent.Size = UDim2.new(1, -70, 0, 16)
		VersionContent.ZIndex = 16
		VersionContent.Font = Enum.Font.GothamMedium
		VersionContent.Text = v.Content
		VersionContent.TextColor3 = Color3.fromRGB(140, 145, 160)
		VersionContent.TextSize = 12.000
		VersionContent.TextTransparency = 0.150
		VersionContent.TextXAlignment = Enum.TextXAlignment.Left

		VersionIcon.Name = NeverLose.RandomString();
		VersionIcon.Parent = VersionFrame
		VersionIcon.AnchorPoint = Vector2.new(1, 0.5)
		VersionIcon.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
		VersionIcon.BackgroundTransparency = v.Image and 0 or 1
		VersionIcon.BorderSizePixel = 0
		VersionIcon.Position = UDim2.new(1, -14, 0.5, 0)
		VersionIcon.Size = UDim2.new(0, 34, 0, 34)
		VersionIcon.ZIndex = 16
		VersionIcon.Image = v.Image or ""

		VersionIconCorner.CornerRadius = UDim.new(0, 8)
		VersionIconCorner.Parent = VersionIcon

		VersionGlyph.Name = NeverLose.RandomString();
		VersionGlyph.Parent = VersionFrame
		VersionGlyph.AnchorPoint = Vector2.new(1, 0.5)
		VersionGlyph.BackgroundTransparency = 1
		VersionGlyph.Position = UDim2.new(1, -16, 0.5, 0)
		VersionGlyph.Size = UDim2.new(0, 24, 0, 24)
		VersionGlyph.ZIndex = 16
		VersionGlyph.FontFace = NeverLose.BuiltInBold
		VersionGlyph.Text = (not v.Image) and (v.Icon or "box") or ""
		VersionGlyph.TextColor3 = NeverLose.AccentColor
		VersionGlyph.TextTransparency = v.Image and 1 or 0.2
		VersionGlyph.TextSize = 20.000
		VersionGlyph.TextWrapped = true

		VersionProcess.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				fade(UIStroke, { Transparency = 0.650 })
				fade(VersionName, { TextTransparency = 0.100 })
				fade(VersionContent, { TextTransparency = 0.150 })
				fade(VersionGlyph, { TextTransparency = v.Image and 1 or 0.2 })
				fade(VersionIcon, { ImageTransparency = 0, BackgroundTransparency = v.Image and 0 or 1 })
				fade(Dot, { BackgroundTransparency = hasDot and 0 or 1 })
				VersionProcess.Match();
			else
				fade(VersionFrame, { BackgroundTransparency = 1 })
				fade(UIStroke, { Transparency = 1 })
				fade(VersionName, { TextTransparency = 1 })
				fade(VersionContent, { TextTransparency = 1 })
				fade(VersionGlyph, { TextTransparency = 1 })
				fade(VersionIcon, { ImageTransparency = 1, BackgroundTransparency = 1 })
				fade(Dot, { BackgroundTransparency = 1 })
			end;
		end);

		table.insert(LoaderLib.Renderer,VersionProcess.SetRender);

		VersionProcess.Match = LPH_NO_VIRTUALIZE(function()
			if Config.DefaultVersion == v.Idx then
				fade(VersionFrame, { BackgroundColor3 = NeverLose.AccentColor, BackgroundTransparency = 0.82 })
				fade(UIStroke, { Transparency = 0.35, Color = NeverLose.AccentColor })
			else
				fade(VersionFrame, { BackgroundColor3 = Color3.fromRGB(18, 20, 28), BackgroundTransparency = v.Locked and 0.55 or 0.050 })
				fade(UIStroke, { Transparency = 0.650, Color = Color3.fromRGB(45, 48, 58) })
			end;
		end);

		NeverLose:AddSignal(VersionFrame.MouseEnter:Connect(function()
			if Config.DefaultVersion ~= v.Idx and not v.Locked then
				fade(VersionFrame, { BackgroundTransparency = 0 })
			end;
		end));

		NeverLose:AddSignal(VersionFrame.MouseLeave:Connect(function()
			if Config.DefaultVersion ~= v.Idx then
				fade(VersionFrame, { BackgroundTransparency = v.Locked and 0.55 or 0.050 })
			end;
		end));

		NeverLose:AddSignal(NeverLose:CreateInput(VersionFrame,function()
			if v.Locked then return end;

			Config.DefaultVersion = v.Idx;

			for i,item in next , VersionItems do
				item.Match();
			end;
		end))

		VersionProcess.Match();
		VersionProcess.SetRender(false);
	end;

	NeverLose:AddSignal(NeverLose:CreateInput(KeyFrame,function()
		return Config.OnGetKey();
	end))

	local ratelimit = false;
	NeverLose:AddSignal(NeverLose:CreateInput(RedeemFrame,function()
		if ratelimit then
			return;
		end;

		ratelimit = true;

		local check,rason = Config.OnRedeem(TextBox.Text);

		if check then
			TextBox.TextEditable = false;

			LoaderLib.MarkLoad.SetValue(true);

			task.wait(0.1);

			return LoaderLib.YieldEvent:Fire(Config.DefaultVersion or TextBox.Text);
		else
			if rason then
				TextBox.Text = tostring(rason);
				task.wait(0.75);
				TextBox.Text = "";
			else
				TextBox.Text = "";
			end;
		end;

		ratelimit = false;
	end))

	NeverLose:AddSignal(NeverLose:CreateInput(CloseButton,function()
		LoaderLib:Unload();
	end))

	NeverLose:AddSignal(NeverLose:CreateInput(MinButton,function()
		LoaderLib.Minimized = not LoaderLib.Minimized;

		NeverLose.PlayAnimate(LoaderFrame, VSlowTween, {
			Size = LoaderLib.Minimized and UDim2.new(0, 520, 0, 64) or UDim2.new(0, 520, 0, 400)
		});
	end))

	NeverLose:AddSignal(KeyFrame.MouseEnter:Connect(function()
		fade(KeyFrame, { BackgroundColor3 = Color3.fromRGB(28, 31, 42) })
	end));

	NeverLose:AddSignal(KeyFrame.MouseLeave:Connect(function()
		fade(KeyFrame, { BackgroundColor3 = Color3.fromRGB(18, 20, 28) })
	end));

	NeverLose:AddSignal(RedeemFrame.MouseEnter:Connect(function()
		fade(RedeemFrame, { BackgroundColor3 = NeverLose.AccentColor:Lerp(Color3.fromRGB(255,255,255), 0.15) })
	end));

	NeverLose:AddSignal(RedeemFrame.MouseLeave:Connect(function()
		fade(RedeemFrame, { BackgroundColor3 = NeverLose.AccentColor })
	end));

	NeverLose:AddSignal(InputFrame.MouseEnter:Connect(function()
		fade(UIStroke, { Transparency = 0.35, Color = NeverLose.AccentColor })
	end));

	NeverLose:AddSignal(InputFrame.MouseLeave:Connect(function()
		fade(UIStroke, { Transparency = 0.650, Color = Color3.fromRGB(45, 48, 58) })
	end));

	do
		local dragging, dragStart, startPos;

		local Header = Instance.new("TextButton")
		Header.Name = NeverLose.RandomString();
		Header.Parent = LoaderFrame
		Header.BackgroundTransparency = 1
		Header.Text = ""
		Header.AutoButtonColor = false
		Header.Position = UDim2.new(0, 160, 0, 0)
		Header.Size = UDim2.new(1, -160, 0, 64)
		Header.ZIndex = 5

		NeverLose:AddSignal(Header.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true;
				dragStart = input.Position;
				startPos = LoaderFrame.Position;
			end;
		end));

		NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart;
				LoaderFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);
			end;
		end));

		NeverLose:AddSignal(UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false;
			end;
		end));
	end

	LoaderLib.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
		if value then
			LoaderFrame.Position = UDim2.new(0.5,0,0.5,0)

			NeverLose.PlayAnimate(LoaderFrame,VSlowTween , {
				BackgroundTransparency = 0,
				Size = UDim2.new(0, 520, 0, 400)
			});

			fade(Logo, { TextTransparency = 0 })
			fade(ProfileName, { TextTransparency = 0 })
			fade(Avatar, { ImageTransparency = 0, BackgroundTransparency = 0 })
			fade(WindowName, { TextTransparency = 0 })
			fade(WindowContent, { TextTransparency = 0.150 })
			fade(MinButton, { TextTransparency = 0.35 })
			fade(CloseButton, { TextTransparency = 0.35 })

			for i,nav in next , NavButtons do
				fade(nav, { TextTransparency = 0.25 })
			end;

			fade(InputFrame, { BackgroundTransparency = 0 })
			fade(UIStroke, { Transparency = 0.650 })
			fade(KeyIcon, { TextTransparency = 0.25 })
			fade(TextBox, { TextTransparency = 0.350 })
			fade(KeyFrame, { BackgroundTransparency = 0 })
			fade(UIStroke_2, { Transparency = 0.650 })
			fade(Content_Key, { TextTransparency = 0.200 })
			fade(Icon_Key, { TextTransparency = 0.250 })
			fade(RedeemFrame, { BackgroundTransparency = 0 })
			fade(Content_Redeem, { TextTransparency = 0 })
			fade(Icon_Redeem, { TextTransparency = 0 })

			for i,Render in next , LoaderLib.Renderer do
				Render(true);
			end;

			Shadow:Render(true);
		else
			fade(LoaderFrame, { BackgroundTransparency = 1 });
			fade(Logo, { TextTransparency = 1 })
			fade(ProfileName, { TextTransparency = 1 })
			fade(Avatar, { ImageTransparency = 1, BackgroundTransparency = 1 })
			fade(WindowName, { TextTransparency = 1 })
			fade(WindowContent, { TextTransparency = 1 })
			fade(MinButton, { TextTransparency = 1 })
			fade(CloseButton, { TextTransparency = 1 })

			for i,nav in next , NavButtons do
				fade(nav, { TextTransparency = 1 })
			end;

			fade(InputFrame, { BackgroundTransparency = 1 })
			fade(UIStroke, { Transparency = 1 })
			fade(KeyIcon, { TextTransparency = 1 })
			fade(TextBox, { TextTransparency = 1 })
			fade(KeyFrame, { BackgroundTransparency = 1 })
			fade(UIStroke_2, { Transparency = 1 })
			fade(Content_Key, { TextTransparency = 1 })
			fade(Icon_Key, { TextTransparency = 1 })
			fade(RedeemFrame, { BackgroundTransparency = 1 })
			fade(Content_Redeem, { TextTransparency = 1 })
			fade(Icon_Redeem, { TextTransparency = 1 })

			for i,Render in next , LoaderLib.Renderer do
				Render(false);
			end;

			LoaderLib.MarkLoad.SetValue(false);
			Shadow:Render(false);
		end;
	end);

	LoaderLib:SetRender(false);

	task.delay(0.3,LoaderLib.SetRender,LoaderLib,true);

	function LoaderLib:Await()
		return LoaderLib.YieldEvent.Event:Wait();
	end;

	function LoaderLib:Unload()
		LoaderLib:SetRender(false);
		task.wait()
		task.delay(0.45,function()
			NeverLose:Unload()
		end);
		task.wait(0.3);
	end;

	return LoaderLib;
end;

function NeverLose:Unload()
	NeverLose.ScreenGui:Destroy();

	for i,v in next , NeverLose.GlobalSignals do
		pcall(v.Disconnect,v)
	end;

	table.clear(NeverLose);
end;

return NeverLose;
