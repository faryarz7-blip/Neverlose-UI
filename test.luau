do
    local Constant = 'LPH_'..'NO_VIRTUALIZE';
    getfenv()[Constant] = getfenv()[Constant] or function(f) return f end;
end;

local NeverLose = {};

NeverLose.BuiltInRegular = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Regular,Enum.FontStyle.Normal);
NeverLose.BuiltInBold = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Bold,Enum.FontStyle.Normal);
NeverLose.GlobalSignals = {};

local cloneref = cloneref or function(f) return f end;
local TweenService = cloneref(game:GetService('TweenService'));
local UserInputService = cloneref(game:GetService('UserInputService'));
local TextService = cloneref(game:GetService('TextService'));
local RunService = cloneref(game:GetService('RunService'));
local Players = cloneref(game:GetService('Players'));
local HttpService = cloneref(game:GetService('HttpService'));
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end;
local CoreGui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or cloneref(game:FindFirstChild('CoreGui')) or cloneref(LocalPlayer.PlayerGui);
local GlobalWindow = Instance.new('ScreenGui');
local ManualTween = TweenInfo.new(0.1);
local SlowyTween = TweenInfo.new(0.175);
local FastTween = TweenInfo.new(0.05);
local VSlowTween = TweenInfo.new(0.5,Enum.EasingStyle.Quint);

NeverLose.RandomString = LPH_NO_VIRTUALIZE(function()
    local s = "";
    for i = 1, 11 do
        s = s .. string.rep(string.char(math.random(1,7)), math.random(1,4));
    end;
    return s;
end);

ProtectGui(GlobalWindow);

GlobalWindow.Name = NeverLose.RandomString();
GlobalWindow.IgnoreGuiInset = true;
GlobalWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global;
GlobalWindow.ResetOnSpawn = false;
GlobalWindow.Parent = CoreGui;
NeverLose.ScreenGui = GlobalWindow;

NeverLose.AccentColor  = Color3.fromRGB(78, 127, 252);
NeverLose.ColorSuccess = Color3.fromRGB(70, 200, 120);
NeverLose.ColorError   = Color3.fromRGB(235, 75, 75);
NeverLose.ColorWarn    = Color3.fromRGB(240, 180, 70);

function NeverLose:AddSignal(RBXSignal)
    table.insert(NeverLose.GlobalSignals, RBXSignal);
    return RBXSignal;
end;

NeverLose.IsStudio = RunService:IsStudio();
NeverLose.IsMobile = UserInputService.TouchEnabled;

NeverLose.PlayAnimate = LPH_NO_VIRTUALIZE(function(Self, Info, Property)
    local Tween = TweenService:Create(Self, Info or TweenInfo.new(0.25), Property);
    Tween:Play();
    return Tween;
end);

-- ════════════════════════════════════════════════════
--  LOGGER (console + file)
-- ════════════════════════════════════════════════════
NeverLose.Logs = {};
NeverLose.LogFile = "neverlose_log.txt";

function NeverLose:Log(level, msg)
    local line = ("[%s] [%s] %s"):format(os.date("%X"), tostring(level), tostring(msg));
    table.insert(NeverLose.Logs, line);
    print("[NeverLose] " .. line);

    pcall(function()
        if appendfile then
            appendfile(NeverLose.LogFile, line .. "\n");
        elseif writefile then
            local existing = (isfile and isfile(NeverLose.LogFile) and readfile(NeverLose.LogFile)) or "";
            writefile(NeverLose.LogFile, existing .. line .. "\n");
        end;
    end);
end;

-- ════════════════════════════════════════════════════
--  TOAST NOTIFICATIONS
-- ════════════════════════════════════════════════════
NeverLose.ToastHolder = Instance.new("Frame");
NeverLose.ToastHolder.Name = NeverLose.RandomString();
NeverLose.ToastHolder.Parent = NeverLose.ScreenGui;
NeverLose.ToastHolder.AnchorPoint = Vector2.new(1, 1);
NeverLose.ToastHolder.BackgroundTransparency = 1;
NeverLose.ToastHolder.Position = UDim2.new(1, -16, 1, -16);
NeverLose.ToastHolder.Size = UDim2.new(0, 310, 1, -32);
NeverLose.ToastHolder.ZIndex = 500;

do
    local ToastLayout = Instance.new("UIListLayout");
    ToastLayout.Parent = NeverLose.ToastHolder;
    ToastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    ToastLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    ToastLayout.Padding = UDim.new(0, 8);
end

function NeverLose:Notify(title, message, kind, duration)
    kind = kind or "info";
    duration = duration or 4;

    local color, glyph = NeverLose.AccentColor, "circle-info";
    if kind == "success" then color, glyph = NeverLose.ColorSuccess, "circle-check";
    elseif kind == "error" then color, glyph = NeverLose.ColorError, "circle-xmark";
    elseif kind == "warn" then color, glyph = NeverLose.ColorWarn, "triangle-exclamation"; end;

    local Toast = Instance.new("Frame");
    Toast.Parent = NeverLose.ToastHolder;
    Toast.BackgroundColor3 = Color3.fromRGB(18, 20, 28);
    Toast.BackgroundTransparency = 1;
    Toast.Size = UDim2.new(1, 0, 0, 58);
    Toast.ZIndex = 501;

    local c = Instance.new("UICorner", Toast); c.CornerRadius = UDim.new(0, 10);
    local s = Instance.new("UIStroke", Toast); s.Color = Color3.fromRGB(45, 48, 58); s.Transparency = 1;

    local Bar = Instance.new("Frame", Toast);
    Bar.BackgroundColor3 = color;
    Bar.BackgroundTransparency = 1;
    Bar.Position = UDim2.new(0, 8, 0, 8);
    Bar.Size = UDim2.new(0, 4, 1, -16);
    Bar.ZIndex = 502;
    local bc = Instance.new("UICorner", Bar); bc.CornerRadius = UDim.new(1, 0);

    local GlyphLbl = Instance.new("TextLabel", Toast);
    GlyphLbl.BackgroundTransparency = 1;
    GlyphLbl.Position = UDim2.new(0, 18, 0, 0);
    GlyphLbl.Size = UDim2.new(0, 26, 1, 0);
    GlyphLbl.ZIndex = 502;
    GlyphLbl.FontFace = NeverLose.BuiltInBold;
    GlyphLbl.Text = glyph;
    GlyphLbl.TextColor3 = color;
    GlyphLbl.TextSize = 20;
    GlyphLbl.TextTransparency = 1;

    local TitleLbl = Instance.new("TextLabel", Toast);
    TitleLbl.BackgroundTransparency = 1;
    TitleLbl.Position = UDim2.new(0, 50, 0, 9);
    TitleLbl.Size = UDim2.new(1, -60, 0, 18);
    TitleLbl.ZIndex = 502;
    TitleLbl.Font = Enum.Font.GothamBold;
    TitleLbl.Text = title;
    TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255);
    TitleLbl.TextSize = 14;
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left;
    TitleLbl.TextTransparency = 1;

    local MsgLbl = Instance.new("TextLabel", Toast);
    MsgLbl.BackgroundTransparency = 1;
    MsgLbl.Position = UDim2.new(0, 50, 0, 28);
    MsgLbl.Size = UDim2.new(1, -60, 0, 22);
    MsgLbl.ZIndex = 502;
    MsgLbl.Font = Enum.Font.GothamMedium;
    MsgLbl.Text = message;
    MsgLbl.TextColor3 = Color3.fromRGB(150, 155, 170);
    MsgLbl.TextSize = 12;
    MsgLbl.TextWrapped = true;
    MsgLbl.TextXAlignment = Enum.TextXAlignment.Left;
    MsgLbl.TextTransparency = 1;

    NeverLose.PlayAnimate(Toast, SlowyTween, { BackgroundTransparency = 0 });
    NeverLose.PlayAnimate(s, SlowyTween, { Transparency = 0.5 });
    NeverLose.PlayAnimate(Bar, SlowyTween, { BackgroundTransparency = 0 });
    NeverLose.PlayAnimate(GlyphLbl, SlowyTween, { TextTransparency = 0 });
    NeverLose.PlayAnimate(TitleLbl, SlowyTween, { TextTransparency = 0 });
    NeverLose.PlayAnimate(MsgLbl, SlowyTween, { TextTransparency = 0.1 });

    task.delay(duration, function()
        NeverLose.PlayAnimate(Toast, SlowyTween, { BackgroundTransparency = 1 });
        NeverLose.PlayAnimate(s, SlowyTween, { Transparency = 1 });
        NeverLose.PlayAnimate(Bar, SlowyTween, { BackgroundTransparency = 1 });
        NeverLose.PlayAnimate(GlyphLbl, SlowyTween, { TextTransparency = 1 });
        NeverLose.PlayAnimate(TitleLbl, SlowyTween, { TextTransparency = 1 });
        NeverLose.PlayAnimate(MsgLbl, SlowyTween, { TextTransparency = 1 });
        task.wait(0.3);
        Toast:Destroy();
    end);
end;

-- ════════════════════════════════════════════════════
--  EXECUTOR CHECK
-- ════════════════════════════════════════════════════
function NeverLose:CheckExecutor()
    local checks = {
        { name = "loadstring",   fn = loadstring },
        { name = "writefile",    fn = writefile },
        { name = "readfile",     fn = readfile },
        { name = "isfile",       fn = isfile },
        { name = "setclipboard", fn = setclipboard },
        { name = "gethui",       fn = gethui },
    };

    local missing = {};
    for _, c in next, checks do
        if type(c.fn) ~= "function" then
            table.insert(missing, c.name);
        end;
    end;

    if #missing > 0 then
        NeverLose:Log("WARN", "Unsupported executor. Missing: " .. table.concat(missing, ", "));
        NeverLose:Notify("Executor Warning", "Missing functions: " .. table.concat(missing, ", ") .. ". Some features may not work.", "warn", 7);
    else
        NeverLose:Log("INFO", "Executor check passed.");
    end;

    return missing;
end;

function NeverLose:CreateInput(_, Frame, Callback)
    local Button = Instance.new('ImageButton', Frame);
    Button.ZIndex = Frame.ZIndex + 10;
    Button.Size = UDim2.fromScale(1, 1);
    Button.BackgroundTransparency = 1;
    Button.ImageTransparency = 1;
    if Callback then
        return Button.MouseButton1Click:Connect(Callback);
    end;
    return Button;
end;

function NeverLose:RollingEffect(parent)
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0.00, 0.5), NumberSequenceKeypoint.new(1.00, 0.00) };
    UIGradient.Parent = parent;
    return UIGradient;
end;

function NeverLose:MarkLoad(LoaderFrame)
    local LoadingFrame = Instance.new("Frame");
    local UICorner = Instance.new("UICorner");
    local UIStroke = Instance.new("UIStroke");
    local IconFrame = Instance.new("Frame");
    local UICorner_2 = Instance.new("UICorner");
    local UIStroke_2 = Instance.new("UIStroke");
    local Icon = Instance.new("TextLabel");

    LoadingFrame.Name = NeverLose.RandomString();
    LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13);
    LoadingFrame.BackgroundTransparency = 0.5;
    LoadingFrame.BorderSizePixel = 0;
    LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0);
    LoadingFrame.ZIndex = 100;
    UICorner.Parent = LoadingFrame;
    UIStroke.Transparency = 0.65; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = LoadingFrame;

    IconFrame.Name = NeverLose.RandomString();
    IconFrame.Parent = LoadingFrame;
    IconFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    IconFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27);
    IconFrame.BorderSizePixel = 0;
    IconFrame.ClipsDescendants = true;
    IconFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
    IconFrame.Size = UDim2.new(0.3, 0, 0.3, 0);
    IconFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    IconFrame.ZIndex = 101;
    UICorner_2.Parent = IconFrame;
    UIStroke_2.Transparency = 0.65; UIStroke_2.Color = Color3.fromRGB(45, 48, 58); UIStroke_2.Parent = IconFrame;

    Icon.Name = NeverLose.RandomString();
    Icon.Parent = IconFrame;
    Icon.AnchorPoint = Vector2.new(0.5, 0.5);
    Icon.BackgroundTransparency = 1;
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0);
    Icon.Size = UDim2.new(0.7, 0, 0.7, 0);
    Icon.ZIndex = 102;
    Icon.FontFace = NeverLose.BuiltInBold;
    Icon.Text = "arrow-spin-clockwise";
    Icon.TextColor3 = NeverLose.AccentColor;
    Icon.TextSize = 30;
    Icon.TextTransparency = 0.25;
    Icon.TextWrapped = true;

    local lib = {};
    lib.SetValue = LPH_NO_VIRTUALIZE(function(value)
        if lib.Thread then task.cancel(lib.Thread); lib.Thread = nil; end;
        if value then
            LoadingFrame.Parent = LoaderFrame;
            NeverLose.PlayAnimate(LoadingFrame, SlowyTween, { BackgroundTransparency = 0.5 });
            NeverLose.PlayAnimate(UIStroke, SlowyTween, { Transparency = 0.65 });
            NeverLose.PlayAnimate(IconFrame, SlowyTween, { BackgroundTransparency = 0, Size = UDim2.new(0.3, 0, 0.3, 0) });
            NeverLose.PlayAnimate(UIStroke_2, SlowyTween, { Transparency = 0.65 });
            NeverLose.PlayAnimate(Icon, SlowyTween, { TextTransparency = 0.25 });
            lib.Thread = task.spawn(function()
                while true do task.wait();
                    NeverLose.PlayAnimate(Icon, SlowyTween, { Rotation = Icon.Rotation + 45 });
                end;
            end);
        else
            NeverLose.PlayAnimate(LoadingFrame, SlowyTween, { BackgroundTransparency = 1 });
            NeverLose.PlayAnimate(UIStroke, SlowyTween, { Transparency = 1 });
            NeverLose.PlayAnimate(IconFrame, SlowyTween, { BackgroundTransparency = 1, Size = UDim2.new(0.15, 0, 0.15, 0) });
            NeverLose.PlayAnimate(UIStroke_2, SlowyTween, { Transparency = 1 });
            NeverLose.PlayAnimate(Icon, SlowyTween, { TextTransparency = 1 });
        end;
    end);
    lib.SetValue(false);
    return lib;
end;

function NeverLose:CreateShadow(parent, RollingEffect)
    local Shadow = {};
    local s85 = Instance.new("UIStroke"); s85.Thickness = 6; s85.Transparency = 1; s85.Parent = parent;
    local s65 = Instance.new("UIStroke"); s65.Thickness = 5; s65.Transparency = 1; s65.Parent = parent;
    local s50 = Instance.new("UIStroke"); s50.Thickness = 4; s50.Transparency = 1; s50.Parent = parent;
    local s45 = Instance.new("UIStroke"); s45.Thickness = 3; s45.Transparency = 1; s45.Parent = parent;

    local thread, r1, r2, r3, r4;
    if RollingEffect then
        r1 = NeverLose:RollingEffect(s85); r2 = NeverLose:RollingEffect(s65);
        r3 = NeverLose:RollingEffect(s50); r4 = NeverLose:RollingEffect(s45);
    end;

    Shadow.Render = LPH_NO_VIRTUALIZE(function(self, value)
        if thread then task.cancel(thread); thread = nil; end;
        if value then
            for _, st in next, { s85, s65, s50, s45 } do
                NeverLose.PlayAnimate(st, SlowyTween, { Transparency = 0.9 });
            end;
            if RollingEffect then
                thread = task.spawn(function()
                    while true do task.wait(0.025);
                        for _, r in next, { r1, r2, r3, r4 } do
                            NeverLose.PlayAnimate(r, SlowyTween, { Rotation = r.Rotation + 20 });
                        end;
                    end;
                end);
            end;
        else
            for _, st in next, { s85, s65, s50, s45 } do
                NeverLose.PlayAnimate(st, SlowyTween, { Transparency = 1 });
            end;
        end;
    end);
    return Shadow;
end;

NeverLose.ProcessParams = LPH_NO_VIRTUALIZE(function(self, Params, Fixed)
    Params = Params or {};
    local k = Params;
    for i, v in next, Fixed do
        rawset(k, i, rawget(Params, i) ~= nil and rawget(Params, i) or v);
    end;
    table.clear(Fixed);
    return k;
end);

-- ════════════════════════════════════════════════════
--  PRODUCT WINDOW
-- ════════════════════════════════════════════════════
function NeverLose:CreateProductWindow(AttachTo)
    local ProductLib = {};
    ProductLib.Unlocked = false;

    local Window = Instance.new("Frame");
    Window.Name = NeverLose.RandomString();
    Window.Parent = NeverLose.ScreenGui;
    Window.AnchorPoint = Vector2.new(0.5, 0.5);
    Window.BackgroundColor3 = Color3.fromRGB(10, 11, 16);
    Window.BorderSizePixel = 0;
    Window.ClipsDescendants = true;
    Window.Position = UDim2.new(0.5, 0, 0.5, 0);
    Window.Size = UDim2.new(0, 470, 0, 0);
    Window.Visible = false;
    Window.ZIndex = 200;
    local WinCorner = Instance.new("UICorner", Window); WinCorner.CornerRadius = UDim.new(0, 14);
    local WinStroke = Instance.new("UIStroke", Window); WinStroke.Transparency = 0.65; WinStroke.Color = Color3.fromRGB(45, 48, 58);
    local Shadow = NeverLose:CreateShadow(Window, false);

    -- Привязка к главному окну: описание двигается только вместе с ним
    if AttachTo then
        local FollowOffset = Vector2.new(0, 0);   -- смести при желании, напр. Vector2.new(500, 0) — правее
        local function syncPos()
            Window.Position = UDim2.new(
                AttachTo.Position.X.Scale, AttachTo.Position.X.Offset + FollowOffset.X,
                AttachTo.Position.Y.Scale, AttachTo.Position.Y.Offset + FollowOffset.Y
            );
        end
        syncPos();
        NeverLose:AddSignal(AttachTo:GetPropertyChangedSignal("Position"):Connect(syncPos));
    end

    local Icon = Instance.new("ImageLabel", Window);
    Icon.BackgroundColor3 = Color3.fromRGB(20, 22, 27);
    Icon.BorderSizePixel = 0;
    Icon.Position = UDim2.new(0, 20, 0, 18);
    Icon.Size = UDim2.new(0, 34, 0, 34);
    Icon.ZIndex = 201;
    local IconCorner = Instance.new("UICorner", Icon); IconCorner.CornerRadius = UDim.new(0, 8);

    local IconGlyph = Instance.new("TextLabel", Icon);
    IconGlyph.BackgroundTransparency = 1;
    IconGlyph.Size = UDim2.new(1, 0, 1, 0);
    IconGlyph.ZIndex = 202;
    IconGlyph.FontFace = NeverLose.BuiltInBold;
    IconGlyph.Text = "box";
    IconGlyph.TextColor3 = NeverLose.AccentColor;
    IconGlyph.TextSize = 20;
    IconGlyph.TextWrapped = true;

    local Title = Instance.new("TextLabel", Window);
    Title.BackgroundTransparency = 1;
    Title.Position = UDim2.new(0, 64, 0, 18);
    Title.Size = UDim2.new(1, -110, 0, 34);
    Title.ZIndex = 201;
    Title.Font = Enum.Font.GothamBold;
    Title.Text = "Product";
    Title.TextColor3 = Color3.fromRGB(255, 255, 255);
    Title.TextSize = 20;
    Title.TextXAlignment = Enum.TextXAlignment.Left;

    local Close = Instance.new("TextButton", Window);
    Close.AnchorPoint = Vector2.new(1, 0);
    Close.BackgroundTransparency = 1;
    Close.Position = UDim2.new(1, -14, 0, 18);
    Close.Size = UDim2.new(0, 26, 0, 26);
    Close.ZIndex = 201;
    Close.Font = Enum.Font.GothamBold;
    Close.Text = "×";
    Close.TextColor3 = Color3.fromRGB(200, 200, 210);
    Close.TextSize = 24;
    Close.AutoButtonColor = false;

    local InfoHolder = Instance.new("Frame", Window);
    InfoHolder.BackgroundTransparency = 1;
    InfoHolder.Position = UDim2.new(0, 20, 0, 74);
    InfoHolder.Size = UDim2.new(0, 200, 1, -140);
    InfoHolder.ZIndex = 201;
    local InfoLayout = Instance.new("UIListLayout", InfoHolder);
    InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    InfoLayout.Padding = UDim.new(0, 10);

    local ChangeDate = Instance.new("TextLabel", Window);
    ChangeDate.BackgroundTransparency = 1;
    ChangeDate.Position = UDim2.new(0, 240, 0, 74);
    ChangeDate.Size = UDim2.new(1, -260, 0, 18);
    ChangeDate.ZIndex = 201;
    ChangeDate.Font = Enum.Font.GothamMedium;
    ChangeDate.Text = "";
    ChangeDate.TextColor3 = Color3.fromRGB(235, 235, 240);
    ChangeDate.TextSize = 13;
    ChangeDate.TextXAlignment = Enum.TextXAlignment.Left;

    local ChangeScroll = Instance.new("ScrollingFrame", Window);
    ChangeScroll.Active = true;
    ChangeScroll.BackgroundTransparency = 1;
    ChangeScroll.BorderSizePixel = 0;
    ChangeScroll.Position = UDim2.new(0, 240, 0, 98);
    ChangeScroll.Size = UDim2.new(1, -260, 1, -168);
    ChangeScroll.ZIndex = 201;
    ChangeScroll.CanvasSize = UDim2.new(0, 0, 0, 0);
    ChangeScroll.ScrollBarThickness = 3;
    ChangeScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 64, 78);

    local ChangeText = Instance.new("TextLabel", ChangeScroll);
    ChangeText.BackgroundTransparency = 1;
    ChangeText.Size = UDim2.new(1, -6, 0, 0);
    ChangeText.AutomaticSize = Enum.AutomaticSize.Y;
    ChangeText.ZIndex = 202;
    ChangeText.Font = Enum.Font.GothamMedium;
    ChangeText.Text = "";
    ChangeText.RichText = true;
    ChangeText.TextColor3 = Color3.fromRGB(150, 155, 170);
    ChangeText.TextSize = 12;
    ChangeText.TextWrapped = true;
    ChangeText.TextXAlignment = Enum.TextXAlignment.Left;
    ChangeText.TextYAlignment = Enum.TextYAlignment.Top;
    ChangeText:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        ChangeScroll.CanvasSize = UDim2.new(0, 0, 0, ChangeText.AbsoluteSize.Y + 8);
    end);

    local Community = Instance.new("TextButton", Window);
    Community.AnchorPoint = Vector2.new(0, 1);
    Community.BackgroundTransparency = 1;
    Community.Position = UDim2.new(0, 20, 1, -20);
    Community.Size = UDim2.new(0, 90, 0, 20);
    Community.ZIndex = 201;
    Community.Font = Enum.Font.GothamMedium;
    Community.Text = "Community";
    Community.TextColor3 = Color3.fromRGB(150, 155, 170);
    Community.TextSize = 13;
    Community.TextXAlignment = Enum.TextXAlignment.Left;
    Community.AutoButtonColor = false;

    local ApiDocs = Instance.new("TextButton", Window);
    ApiDocs.AnchorPoint = Vector2.new(0, 1);
    ApiDocs.BackgroundTransparency = 1;
    ApiDocs.Position = UDim2.new(0, 118, 1, -20);
    ApiDocs.Size = UDim2.new(0, 120, 0, 20);
    ApiDocs.ZIndex = 201;
    ApiDocs.Font = Enum.Font.GothamMedium;
    ApiDocs.Text = "API Docs";
    ApiDocs.TextColor3 = Color3.fromRGB(150, 155, 170);
    ApiDocs.TextSize = 13;
    ApiDocs.TextXAlignment = Enum.TextXAlignment.Left;
    ApiDocs.AutoButtonColor = false;

    local VersionTag = Instance.new("TextLabel", Window);
    VersionTag.AnchorPoint = Vector2.new(1, 1);
    VersionTag.BackgroundColor3 = Color3.fromRGB(20, 22, 27);
    VersionTag.BorderSizePixel = 0;
    VersionTag.Position = UDim2.new(1, -158, 1, -14);
    VersionTag.Size = UDim2.new(0, 34, 0, 30);
    VersionTag.ZIndex = 201;
    VersionTag.Font = Enum.Font.GothamBold;
    VersionTag.Text = "H3";
    VersionTag.TextColor3 = Color3.fromRGB(235, 235, 240);
    VersionTag.TextSize = 13;
    local VTagCorner = Instance.new("UICorner", VersionTag); VTagCorner.CornerRadius = UDim.new(0, 8);

    local Download = Instance.new("TextButton", Window);
    Download.AnchorPoint = Vector2.new(1, 1);
    Download.BackgroundColor3 = NeverLose.ColorError;
    Download.BorderSizePixel = 0;
    Download.Position = UDim2.new(1, -14, 1, -14);
    Download.Size = UDim2.new(0, 136, 0, 30);
    Download.ZIndex = 201;
    Download.Font = Enum.Font.GothamBold;
    Download.Text = "🔒 Redeem Key First";
    Download.TextColor3 = Color3.fromRGB(255, 255, 255);
    Download.TextSize = 13;
    Download.AutoButtonColor = false;
    local DLCorner = Instance.new("UICorner", Download); DLCorner.CornerRadius = UDim.new(0, 10);

    local currentData;
    local downloadBusy = false;

    local function clearInfo()
        for _, child in next, InfoHolder:GetChildren() do
            if child:IsA("Frame") then child:Destroy(); end;
        end;
    end;

    local function addInfoRow(name, value)
        local Row = Instance.new("Frame", InfoHolder);
        Row.BackgroundTransparency = 1;
        Row.Size = UDim2.new(1, 0, 0, 18);
        Row.ZIndex = 201;
        local Label = Instance.new("TextLabel", Row);
        Label.BackgroundTransparency = 1;
        Label.Size = UDim2.new(0, 100, 1, 0);
        Label.ZIndex = 202;
        Label.Font = Enum.Font.GothamMedium;
        Label.Text = name;
        Label.TextColor3 = Color3.fromRGB(150, 155, 170);
        Label.TextSize = 13;
        Label.TextXAlignment = Enum.TextXAlignment.Left;
        local Value = Instance.new("TextLabel", Row);
        Value.BackgroundTransparency = 1;
        Value.Position = UDim2.new(0, 100, 0, 0);
        Value.Size = UDim2.new(1, -100, 1, 0);
        Value.ZIndex = 202;
        Value.Font = Enum.Font.GothamBold;
        Value.Text = value;
        Value.TextColor3 = NeverLose.AccentColor;
        Value.TextSize = 13;
        Value.TextXAlignment = Enum.TextXAlignment.Left;
    end;

    function ProductLib:SetUnlocked(state)
        ProductLib.Unlocked = state;
        if state then
            NeverLose.PlayAnimate(Download, SlowyTween, { BackgroundColor3 = NeverLose.AccentColor });
            Download.Text = "▷ Launch";
        else
            NeverLose.PlayAnimate(Download, SlowyTween, { BackgroundColor3 = NeverLose.ColorError });
            Download.Text = "🔒 Redeem Key First";
        end;
    end;
    ProductLib:SetUnlocked(false);

    function ProductLib:Show(data)
        currentData = data or {};
        Title.Text = data.Name or "Product";
        ChangeDate.Text = data.Date or "";
        ChangeText.Text = data.Changelog or "";
        VersionTag.Text = data.Version or "";
        Community.Text = (data.Links and data.Links[1] and data.Links[1].Name) or "Community";
        ApiDocs.Text = (data.Links and data.Links[2] and data.Links[2].Name) or "API Docs";

        if data.Image and data.Image ~= "" then
            Icon.Image = data.Image; Icon.BackgroundTransparency = 0; IconGlyph.TextTransparency = 1;
        else
            Icon.Image = ""; IconGlyph.Text = data.Icon or "box"; IconGlyph.TextTransparency = 0.2;
        end;

        clearInfo();
        for _, row in next, (data.Info or {}) do
            addInfoRow(row.Name or "", row.Value or "");
        end;

        Window.Visible = true;
        Window.Size = UDim2.new(0, 470, 0, 0);
        NeverLose.PlayAnimate(Window, VSlowTween, { Size = UDim2.new(0, 470, 0, 330) });
        Shadow:Render(true);
    end;

    function ProductLib:Hide()
        Shadow:Render(false);
        NeverLose.PlayAnimate(Window, VSlowTween, { Size = UDim2.new(0, 470, 0, 0) });
        task.delay(0.4, function() Window.Visible = false; end);
    end;

    NeverLose:CreateInput(NeverLose, Close, function() ProductLib:Hide(); end);

    NeverLose:CreateInput(NeverLose, Community, function()
        if currentData and currentData.Links and currentData.Links[1] and currentData.Links[1].Callback then
            currentData.Links[1].Callback();
        end;
    end);
    NeverLose:CreateInput(NeverLose, ApiDocs, function()
        if currentData and currentData.Links and currentData.Links[2] and currentData.Links[2].Callback then
            currentData.Links[2].Callback();
        end;
    end);

    NeverLose:AddSignal(Download.MouseEnter:Connect(function()
        local base = ProductLib.Unlocked and NeverLose.AccentColor or NeverLose.ColorError;
        NeverLose.PlayAnimate(Download, SlowyTween, { BackgroundColor3 = base:Lerp(Color3.fromRGB(255, 255, 255), 0.15) });
    end));
    NeverLose:AddSignal(Download.MouseLeave:Connect(function()
        NeverLose.PlayAnimate(Download, SlowyTween, { BackgroundColor3 = ProductLib.Unlocked and NeverLose.AccentColor or NeverLose.ColorError });
    end));

    NeverLose:CreateInput(NeverLose, Download, function()
        if downloadBusy then return; end;

        if not ProductLib.Unlocked then
            NeverLose:Notify("Locked", "Redeem a valid license key before launching.", "error");
            NeverLose:Log("WARN", "Launch blocked: no valid key.");
            return;
        end;

        downloadBusy = true;
        if currentData and currentData.OnDownload then
            currentData.OnDownload(currentData);
        end;
        task.wait(1.5); -- anti-spam
        downloadBusy = false;
    end);

    return ProductLib;
end;

-- ════════════════════════════════════════════════════
--  MAIN LOADER
-- ════════════════════════════════════════════════════
function NeverLose.new(Config)
    Config = NeverLose:ProcessParams(Config, {
        Name = "Neverlose",
        Content = "Available Products",
        Profile = LocalPlayer.Name,
        SaveKey = true,
        KeyFile = "neverlose_key.txt",
        Links = { { Name = "Discord" }, { Name = "Telegram" } },
        DefaultVersion = nil,
        Versions = {},
        OnGetKey = function() end,
        OnRedeem = function() return false, "Not implemented" end,
    });

    NeverLose:Log("INFO", "Loader initialising...");
    NeverLose:CheckExecutor();

    local LoaderLib = {};
    LoaderLib.Redeemed = false;

    local LoaderFrame = Instance.new("Frame");
    local UICorner = Instance.new("UICorner");
    local Sidebar = Instance.new("Frame");
    local LogoBack = Instance.new("TextLabel");
    local Logo = Instance.new("TextLabel");
    local NavHolder = Instance.new("Frame");
    local NavLayout = Instance.new("UIListLayout");
    local Profile = Instance.new("Frame");
    local Avatar = Instance.new("ImageLabel");
    local AvatarCorner = Instance.new("UICorner");
    local ProfileName = Instance.new("TextLabel");
    local ContentPanel = Instance.new("Frame");
    local WindowName = Instance.new("TextLabel");
    local WindowContent = Instance.new("TextLabel");
    local MinButton = Instance.new("TextLabel");
    local CloseButton = Instance.new("TextLabel");
    local ScrollingFrame = Instance.new("ScrollingFrame");
    local UIListLayout = Instance.new("UIListLayout");
    local InputFrame = Instance.new("Frame");
    local UICorner_2 = Instance.new("UICorner");
    local UIStroke = Instance.new("UIStroke");
    local KeyIcon = Instance.new("TextLabel");
    local TextBox = Instance.new("TextBox");
    local KeyFrame = Instance.new("Frame");
    local UICorner_3 = Instance.new("UICorner");
    local UIStroke_2 = Instance.new("UIStroke");
    local Content_Key = Instance.new("TextLabel");
    local Icon_Key = Instance.new("TextLabel");
    local RedeemFrame = Instance.new("Frame");
    local UICorner_4 = Instance.new("UICorner");
    local Content_Redeem = Instance.new("TextLabel");
    local Icon_Redeem = Instance.new("TextLabel");

    local Shadow = NeverLose:CreateShadow(LoaderFrame, true);
    local ProductWindow = NeverLose:CreateProductWindow(LoaderFrame);   -- привязка к главному окну
    LoaderLib.ProductWindow = ProductWindow;

    local function fade(inst, props) NeverLose.PlayAnimate(inst, SlowyTween, props); end

    LoaderLib.MarkLoad = NeverLose:MarkLoad(LoaderFrame);
    LoaderLib.YieldEvent = Instance.new('BindableEvent', LoaderFrame);

    LoaderFrame.Name = "LOADER=" .. NeverLose.RandomString();
    LoaderFrame.Parent = NeverLose.ScreenGui;
    LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    LoaderFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 16);
    LoaderFrame.BorderSizePixel = 0;
    LoaderFrame.ClipsDescendants = true;
    LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
    LoaderFrame.Size = UDim2.new(0, 520, 0, 15);
    UICorner.CornerRadius = UDim.new(0, 14); UICorner.Parent = LoaderFrame;

    Sidebar.Parent = LoaderFrame; Sidebar.BackgroundTransparency = 1; Sidebar.BorderSizePixel = 0;
    Sidebar.Size = UDim2.new(0, 160, 1, 0); Sidebar.ZIndex = 6;

    LogoBack.Parent = Sidebar; LogoBack.BackgroundTransparency = 1;
    LogoBack.Position = UDim2.new(0, 27, 0, 23); LogoBack.Size = UDim2.new(0, 90, 0, 46); LogoBack.ZIndex = 7;
    LogoBack.Font = Enum.Font.GothamBlack; LogoBack.Text = "NL"; LogoBack.TextColor3 = NeverLose.AccentColor;
    LogoBack.TextSize = 34; LogoBack.TextXAlignment = Enum.TextXAlignment.Left;

    Logo.Parent = Sidebar; Logo.BackgroundTransparency = 1;
    Logo.Position = UDim2.new(0, 24, 0, 20); Logo.Size = UDim2.new(0, 90, 0, 46); Logo.ZIndex = 8;
    Logo.Font = Enum.Font.GothamBlack; Logo.Text = "NL"; Logo.TextColor3 = Color3.fromRGB(255, 255, 255);
    Logo.TextSize = 34; Logo.TextXAlignment = Enum.TextXAlignment.Left;

    NavHolder.Parent = Sidebar; NavHolder.BackgroundTransparency = 1;
    NavHolder.Position = UDim2.new(0, 24, 0, 96); NavHolder.Size = UDim2.new(1, -34, 0, 160); NavHolder.ZIndex = 7;
    NavLayout.Parent = NavHolder; NavLayout.SortOrder = Enum.SortOrder.LayoutOrder; NavLayout.Padding = UDim.new(0, 16);

    local NavButtons = {};
    for i, link in next, Config.Links do
        local NavItem = Instance.new("TextButton", NavHolder);
        NavItem.BackgroundTransparency = 1; NavItem.Size = UDim2.new(1, 0, 0, 20); NavItem.ZIndex = 7;
        NavItem.Font = Enum.Font.GothamMedium; NavItem.Text = link.Name;
        NavItem.TextColor3 = Color3.fromRGB(200, 200, 210); NavItem.TextSize = 15;
        NavItem.TextTransparency = 0.25; NavItem.TextXAlignment = Enum.TextXAlignment.Left; NavItem.AutoButtonColor = false;
        NeverLose:AddSignal(NavItem.MouseEnter:Connect(function() fade(NavItem, { TextColor3 = NeverLose.AccentColor, TextTransparency = 0 }); end));
        NeverLose:AddSignal(NavItem.MouseLeave:Connect(function() fade(NavItem, { TextColor3 = Color3.fromRGB(200, 200, 210), TextTransparency = 0.25 }); end));
        NeverLose:AddSignal(NavItem.MouseButton1Click:Connect(function() if link.Callback then link.Callback(); end; end));
        table.insert(NavButtons, NavItem);
    end;

    Profile.Parent = Sidebar; Profile.AnchorPoint = Vector2.new(0, 1); Profile.BackgroundTransparency = 1;
    Profile.Position = UDim2.new(0, 18, 1, -18); Profile.Size = UDim2.new(1, -24, 0, 36); Profile.ZIndex = 7;

    Avatar.Parent = Profile; Avatar.AnchorPoint = Vector2.new(0, 0.5); Avatar.BackgroundColor3 = Color3.fromRGB(18, 20, 28);
    Avatar.BorderSizePixel = 0; Avatar.Position = UDim2.new(0, 0, 0.5, 0); Avatar.Size = UDim2.new(0, 34, 0, 34); Avatar.ZIndex = 8;
    AvatarCorner.CornerRadius = UDim.new(1, 0); AvatarCorner.Parent = Avatar;
    pcall(function() Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100); end);

    ProfileName.Parent = Profile; ProfileName.AnchorPoint = Vector2.new(0, 0.5); ProfileName.BackgroundTransparency = 1;
    ProfileName.Position = UDim2.new(0, 44, 0.5, 0); ProfileName.Size = UDim2.new(1, -44, 1, 0); ProfileName.ZIndex = 8;
    ProfileName.Font = Enum.Font.GothamBold; ProfileName.Text = Config.Profile; ProfileName.TextColor3 = Color3.fromRGB(255, 255, 255);
    ProfileName.TextSize = 15; ProfileName.TextXAlignment = Enum.TextXAlignment.Left;

    ContentPanel.Parent = LoaderFrame; ContentPanel.BackgroundTransparency = 1; ContentPanel.BorderSizePixel = 0;
    ContentPanel.Position = UDim2.new(0, 160, 0, 0); ContentPanel.Size = UDim2.new(1, -160, 1, 0); ContentPanel.ZIndex = 6;

    WindowName.Parent = ContentPanel; WindowName.BackgroundTransparency = 1;
    WindowName.Position = UDim2.new(0, 6, 0, 22); WindowName.Size = UDim2.new(1, -90, 0, 26); WindowName.ZIndex = 7;
    WindowName.Font = Enum.Font.GothamBold; WindowName.Text = Config.Name; WindowName.TextColor3 = Color3.fromRGB(255, 255, 255);
    WindowName.TextSize = 20; WindowName.TextXAlignment = Enum.TextXAlignment.Left;

    WindowContent.Parent = ContentPanel; WindowContent.BackgroundTransparency = 1;
    WindowContent.Position = UDim2.new(0, 6, 0, 48); WindowContent.Size = UDim2.new(1, -90, 0, 18); WindowContent.ZIndex = 7;
    WindowContent.Font = Enum.Font.GothamMedium; WindowContent.Text = Config.Content; WindowContent.TextColor3 = Color3.fromRGB(140, 145, 160);
    WindowContent.TextSize = 13; WindowContent.TextTransparency = 0.15; WindowContent.TextXAlignment = Enum.TextXAlignment.Left;

    MinButton.Parent = ContentPanel; MinButton.AnchorPoint = Vector2.new(1, 0); MinButton.BackgroundTransparency = 1;
    MinButton.Position = UDim2.new(1, -42, 0, 24); MinButton.Size = UDim2.new(0, 22, 0, 22); MinButton.ZIndex = 8;
    MinButton.Font = Enum.Font.GothamBold; MinButton.Text = "—"; MinButton.TextColor3 = Color3.fromRGB(200, 200, 210);
    MinButton.TextSize = 18; MinButton.TextTransparency = 0.35;

    CloseButton.Parent = ContentPanel; CloseButton.AnchorPoint = Vector2.new(1, 0); CloseButton.BackgroundTransparency = 1;
    CloseButton.Position = UDim2.new(1, -12, 0, 24); CloseButton.Size = UDim2.new(0, 22, 0, 22); CloseButton.ZIndex = 8;
    CloseButton.Font = Enum.Font.GothamBold; CloseButton.Text = "×"; CloseButton.TextColor3 = Color3.fromRGB(200, 200, 210);
    CloseButton.TextSize = 22; CloseButton.TextTransparency = 0.35;

    -- ─────────────────────────────────────────────────
    --  СПИСОК ПРОДУКТОВ (исправленный)
    --  • верхняя карточка не обрезается (UIPadding + сдвиг)
    --  • прокрутка при любом числе продуктов (ручной CanvasSize)
    -- ─────────────────────────────────────────────────
    ScrollingFrame.Parent = ContentPanel; ScrollingFrame.Active = true; ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0);
    ScrollingFrame.BackgroundTransparency = 1; ScrollingFrame.BorderSizePixel = 0; ScrollingFrame.ClipsDescendants = true;
    ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 96); ScrollingFrame.Size = UDim2.new(1, -16, 1, -190); ScrollingFrame.ZIndex = 7;
    ScrollingFrame.ScrollingEnabled = true;
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.ScrollBarThickness = 3;
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 64, 78); ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;

    local ScrollPadding = Instance.new("UIPadding", ScrollingFrame);
    ScrollPadding.PaddingTop = UDim.new(0, 6);
    ScrollPadding.PaddingBottom = UDim.new(0, 6);
    ScrollPadding.PaddingLeft = UDim.new(0, 4);
    ScrollPadding.PaddingRight = UDim.new(0, 4);

    UIListLayout.Parent = ScrollingFrame; UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder; UIListLayout.Padding = UDim.new(0, 8);

    -- Ручной расчёт высоты холста (работает на любой версии Roblox)
    NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0,
            UIListLayout.AbsoluteContentSize.Y
            + ScrollPadding.PaddingTop.Offset
            + ScrollPadding.PaddingBottom.Offset
            + 4);
    end));

    InputFrame.Parent = ContentPanel; InputFrame.AnchorPoint = Vector2.new(0.5, 1); InputFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28);
    InputFrame.BorderSizePixel = 0; InputFrame.Position = UDim2.new(0.5, 0, 1, -58); InputFrame.Size = UDim2.new(1, -16, 0, 38); InputFrame.ZIndex = 10;
    UICorner_2.CornerRadius = UDim.new(0, 10); UICorner_2.Parent = InputFrame;
    UIStroke.Transparency = 0.65; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = InputFrame;

    KeyIcon.Parent = InputFrame; KeyIcon.AnchorPoint = Vector2.new(0, 0.5); KeyIcon.BackgroundTransparency = 1;
    KeyIcon.Position = UDim2.new(0, 12, 0.5, 0); KeyIcon.Size = UDim2.new(0, 18, 0, 18); KeyIcon.ZIndex = 17;
    KeyIcon.FontFace = NeverLose.BuiltInBold; KeyIcon.Text = "key"; KeyIcon.TextColor3 = NeverLose.AccentColor;
    KeyIcon.TextSize = 16; KeyIcon.TextTransparency = 0.25; KeyIcon.TextWrapped = true;

    TextBox.Parent = InputFrame; TextBox.AnchorPoint = Vector2.new(0, 0.5); TextBox.BackgroundTransparency = 1;
    TextBox.Position = UDim2.new(0, 38, 0.5, 0); TextBox.Size = UDim2.new(1, -48, 0, 30); TextBox.ZIndex = 17;
    TextBox.ClearTextOnFocus = false; TextBox.Font = Enum.Font.GothamMedium; TextBox.PlaceholderText = "License Key";
    TextBox.Text = ""; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255); TextBox.TextSize = 12;
    TextBox.TextTransparency = 0.35; TextBox.TextXAlignment = Enum.TextXAlignment.Left;

    KeyFrame.Parent = ContentPanel; KeyFrame.AnchorPoint = Vector2.new(0, 1); KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28);
    KeyFrame.BorderSizePixel = 0; KeyFrame.Position = UDim2.new(0, 8, 1, -12); KeyFrame.Size = UDim2.new(0.5, -12, 0, 38); KeyFrame.ZIndex = 10;
    UICorner_3.CornerRadius = UDim.new(0, 10); UICorner_3.Parent = KeyFrame;
    UIStroke_2.Transparency = 0.65; UIStroke_2.Color = Color3.fromRGB(45, 48, 58); UIStroke_2.Parent = KeyFrame;

    Content_Key.Parent = KeyFrame; Content_Key.AnchorPoint = Vector2.new(0, 0.5); Content_Key.BackgroundTransparency = 1;
    Content_Key.Position = UDim2.new(0, 38, 0.5, 0); Content_Key.Size = UDim2.new(1, -40, 0, 25); Content_Key.ZIndex = 17;
    Content_Key.Font = Enum.Font.GothamBold; Content_Key.Text = "Get Key"; Content_Key.TextColor3 = Color3.fromRGB(235, 235, 240);
    Content_Key.TextSize = 14; Content_Key.TextTransparency = 0.2; Content_Key.TextXAlignment = Enum.TextXAlignment.Left;

    Icon_Key.Parent = KeyFrame; Icon_Key.AnchorPoint = Vector2.new(0, 0.5); Icon_Key.BackgroundTransparency = 1;
    Icon_Key.Position = UDim2.new(0, 12, 0.5, 0); Icon_Key.Size = UDim2.new(0, 20, 0, 20); Icon_Key.ZIndex = 17;
    Icon_Key.FontFace = NeverLose.BuiltInBold; Icon_Key.Text = "chain-link"; Icon_Key.TextColor3 = NeverLose.AccentColor;
    Icon_Key.TextSize = 17; Icon_Key.TextTransparency = 0.25; Icon_Key.TextWrapped = true;

    RedeemFrame.Parent = ContentPanel; RedeemFrame.AnchorPoint = Vector2.new(1, 1); RedeemFrame.BackgroundColor3 = NeverLose.ColorError;
    RedeemFrame.BorderSizePixel = 0; RedeemFrame.Position = UDim2.new(1, -8, 1, -12); RedeemFrame.Size = UDim2.new(0.5, -12, 0, 38); RedeemFrame.ZIndex = 10;
    UICorner_4.CornerRadius = UDim.new(0, 10); UICorner_4.Parent = RedeemFrame;

    Content_Redeem.Parent = RedeemFrame; Content_Redeem.AnchorPoint = Vector2.new(0, 0.5); Content_Redeem.BackgroundTransparency = 1;
    Content_Redeem.Position = UDim2.new(0, 38, 0.5, 0); Content_Redeem.Size = UDim2.new(1, -40, 0, 25); Content_Redeem.ZIndex = 17;
    Content_Redeem.Font = Enum.Font.GothamBold; Content_Redeem.Text = "Enter Key"; Content_Redeem.TextColor3 = Color3.fromRGB(255, 255, 255);
    Content_Redeem.TextSize = 14; Content_Redeem.TextXAlignment = Enum.TextXAlignment.Left;

    Icon_Redeem.Parent = RedeemFrame; Icon_Redeem.AnchorPoint = Vector2.new(0, 0.5); Icon_Redeem.BackgroundTransparency = 1;
    Icon_Redeem.Position = UDim2.new(0, 12, 0.5, 0); Icon_Redeem.Size = UDim2.new(0, 20, 0, 20); Icon_Redeem.ZIndex = 17;
    Icon_Redeem.FontFace = NeverLose.BuiltInBold; Icon_Redeem.Text = "lock"; Icon_Redeem.TextColor3 = Color3.fromRGB(255, 255, 255);
    Icon_Redeem.TextSize = 17; Icon_Redeem.TextWrapped = true;

    -- ── Redeem button state (red when empty) ──
    local function isKeyEmpty()
        return TextBox.Text == nil or TextBox.Text:gsub("%s", "") == "";
    end;

    local function UpdateRedeemButton()
        if LoaderLib.Redeemed then
            RedeemFrame.BackgroundColor3 = NeverLose.ColorSuccess;
            Content_Redeem.Text = "Activated"; Icon_Redeem.Text = "circle-check";
        elseif isKeyEmpty() then
            RedeemFrame.BackgroundColor3 = NeverLose.ColorError;
            Content_Redeem.Text = "Enter Key"; Icon_Redeem.Text = "lock";
        else
            RedeemFrame.BackgroundColor3 = NeverLose.AccentColor;
            Content_Redeem.Text = "Redeem"; Icon_Redeem.Text = "gift-card";
        end;
    end;
    NeverLose:AddSignal(TextBox:GetPropertyChangedSignal("Text"):Connect(UpdateRedeemButton));

    -- restore saved key
    if Config.SaveKey then
        pcall(function()
            if isfile and isfile(Config.KeyFile) then
                TextBox.Text = readfile(Config.KeyFile);
                NeverLose:Log("INFO", "Saved key restored from file.");
            end;
        end);
    end;
    UpdateRedeemButton();

    -- ── Product cards ──
    local VersionItems = {};
    LoaderLib.Renderer = {};

    for i, v in next, Config.Versions do
        local VersionProcess = {};
        VersionItems[v.Idx] = VersionProcess;

        local VersionFrame = Instance.new("Frame", ScrollingFrame);
        local VStroke = Instance.new("UIStroke", VersionFrame);
        local VCorner = Instance.new("UICorner", VersionFrame);
        local Dot = Instance.new("Frame", VersionFrame);
        local DotCorner = Instance.new("UICorner", Dot);
        local VersionName = Instance.new("TextLabel", VersionFrame);
        local VersionContent = Instance.new("TextLabel", VersionFrame);
        local VersionIcon = Instance.new("ImageLabel", VersionFrame);
        local VIconCorner = Instance.new("UICorner", VersionIcon);
        local VersionGlyph = Instance.new("TextLabel", VersionIcon);
        local Arrow = Instance.new("TextLabel", VersionFrame);

        local hasDot = v.Dot ~= nil;
        local iconX, textX = 12, 58;

        VersionFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28);
        VersionFrame.BackgroundTransparency = v.Locked and 0.55 or 0.05;
        VersionFrame.BorderSizePixel = 0; VersionFrame.Size = UDim2.new(1, -4, 0, 64); VersionFrame.ZIndex = 15;
        VersionFrame.LayoutOrder = i;                          -- стабильный порядок карточек
        local VScale = Instance.new("UIScale", VersionFrame);  -- для анимаций появления/наведения
        VScale.Scale = 1;
        VStroke.Transparency = 0.65; VStroke.Color = Color3.fromRGB(45, 48, 58);
        VCorner.CornerRadius = UDim.new(0, 10);

        VersionIcon.AnchorPoint = Vector2.new(0, 0.5); VersionIcon.BackgroundColor3 = Color3.fromRGB(28, 31, 42);
        VersionIcon.BorderSizePixel = 0; VersionIcon.Position = UDim2.new(0, iconX, 0.5, 0); VersionIcon.Size = UDim2.new(0, 36, 0, 36);
        VersionIcon.ZIndex = 16; VersionIcon.Image = v.Image or "";
        VIconCorner.CornerRadius = UDim.new(0, 8);

        VersionGlyph.AnchorPoint = Vector2.new(0.5, 0.5); VersionGlyph.BackgroundTransparency = 1;
        VersionGlyph.Position = UDim2.new(0.5, 0, 0.5, 0); VersionGlyph.Size = UDim2.new(0, 22, 0, 22); VersionGlyph.ZIndex = 17;
        VersionGlyph.FontFace = NeverLose.BuiltInBold; VersionGlyph.Text = (not v.Image) and (v.Icon or "box") or "";
        VersionGlyph.TextColor3 = NeverLose.AccentColor; VersionGlyph.TextTransparency = v.Image and 1 or 0.2;
        VersionGlyph.TextSize = 20; VersionGlyph.TextWrapped = true;

        Dot.AnchorPoint = Vector2.new(0.5, 0.5); Dot.BackgroundColor3 = typeof(v.Dot) == "Color3" and v.Dot or NeverLose.AccentColor;
        Dot.BackgroundTransparency = hasDot and 0 or 1; Dot.BorderSizePixel = 0;
        Dot.Position = UDim2.new(0, iconX + 34, 0.5, -12); Dot.Size = UDim2.new(0, 8, 0, 8); Dot.ZIndex = 18;
        DotCorner.CornerRadius = UDim.new(1, 0);

        VersionName.BackgroundTransparency = 1; VersionName.Position = UDim2.new(0, textX, 0, 12);
        VersionName.Size = UDim2.new(1, -textX-55, 0, 22); VersionName.ZIndex = 16;
        VersionName.Font = Enum.Font.GothamBold; VersionName.Text = v.Name;
        VersionName.TextColor3 = v.Locked and NeverLose.AccentColor or Color3.fromRGB(255, 255, 255);
        VersionName.TextSize = 16; VersionName.TextTransparency = 0.1; VersionName.TextXAlignment = Enum.TextXAlignment.Left;

        VersionContent.BackgroundTransparency = 1; VersionContent.Position = UDim2.new(0, textX, 0, 34);
        VersionContent.Size = UDim2.new(1, -textX-55, 0, 16); VersionContent.ZIndex = 16;
        VersionContent.Font = Enum.Font.GothamMedium; VersionContent.Text = v.Content;
        VersionContent.TextColor3 = Color3.fromRGB(140, 145, 160); VersionContent.TextSize = 12;
        VersionContent.TextTransparency = 0.15; VersionContent.TextXAlignment = Enum.TextXAlignment.Left;

        Arrow.AnchorPoint = Vector2.new(1, 0.5); Arrow.BackgroundTransparency = 1;
        Arrow.Position = UDim2.new(1, -16, 0.5, 0); Arrow.Size = UDim2.new(0, 20, 0, 20); Arrow.ZIndex = 16;
        Arrow.FontFace = NeverLose.BuiltInBold; Arrow.Text = v.Locked and "lock" or "chevron-right";
        Arrow.TextColor3 = Color3.fromRGB(140, 145, 160); Arrow.TextTransparency = 0.2; Arrow.TextSize = 18; Arrow.TextWrapped = true;

        VersionProcess.SetRender = LPH_NO_VIRTUALIZE(function(value)
            if value then
                -- анимация появления (каскадом по индексу)
                VScale.Scale = 0.9;
                task.delay((i - 1) * 0.05, function()
                    NeverLose.PlayAnimate(VScale, VSlowTween, { Scale = 1 });
                end);
                fade(VStroke, { Transparency = 0.65 }); fade(VersionName, { TextTransparency = 0.1 });
                fade(VersionContent, { TextTransparency = 0.15 }); fade(VersionGlyph, { TextTransparency = v.Image and 1 or 0.2 });
                fade(VersionIcon, { ImageTransparency = 0, BackgroundTransparency = 0 });
                fade(Dot, { BackgroundTransparency = hasDot and 0 or 1 }); fade(Arrow, { TextTransparency = 0.2 });
                VersionProcess.Match();
            else
                fade(VersionFrame, { BackgroundTransparency = 1 }); fade(VStroke, { Transparency = 1 });
                fade(VersionName, { TextTransparency = 1 }); fade(VersionContent, { TextTransparency = 1 });
                fade(VersionGlyph, { TextTransparency = 1 }); fade(VersionIcon, { ImageTransparency = 1, BackgroundTransparency = 1 });
                fade(Dot, { BackgroundTransparency = 1 }); fade(Arrow, { TextTransparency = 1 });
            end;
        end);
        table.insert(LoaderLib.Renderer, VersionProcess.SetRender);

        VersionProcess.Match = LPH_NO_VIRTUALIZE(function()
            if Config.DefaultVersion == v.Idx then
                fade(VersionFrame, { BackgroundColor3 = NeverLose.AccentColor, BackgroundTransparency = 0.82 });
                fade(VStroke, { Transparency = 0.35, Color = NeverLose.AccentColor });
            else
                fade(VersionFrame, { BackgroundColor3 = Color3.fromRGB(18, 20, 28), BackgroundTransparency = v.Locked and 0.55 or 0.05 });
                fade(VStroke, { Transparency = 0.65, Color = Color3.fromRGB(45, 48, 58) });
            end;
        end);

        NeverLose:AddSignal(VersionFrame.MouseEnter:Connect(function()
            if Config.DefaultVersion ~= v.Idx and not v.Locked then fade(VersionFrame, { BackgroundTransparency = 0 }); end;
            NeverLose.PlayAnimate(VScale, FastTween, { Scale = 1.02 });   -- лёгкий "pop" при наведении
            fade(Arrow, { TextColor3 = NeverLose.AccentColor, TextTransparency = 0 });
        end));
        NeverLose:AddSignal(VersionFrame.MouseLeave:Connect(function()
            if Config.DefaultVersion ~= v.Idx then fade(VersionFrame, { BackgroundTransparency = v.Locked and 0.55 or 0.05 }); end;
            NeverLose.PlayAnimate(VScale, FastTween, { Scale = 1 });
            fade(Arrow, { TextColor3 = Color3.fromRGB(140, 145, 160), TextTransparency = 0.2 });
        end));

        NeverLose:CreateInput(NeverLose, VersionFrame, function()
            if v.Locked then
                NeverLose:Notify("Locked", (v.Name or "This product") .. " is not available for your plan.", "warn");
                return;
            end;

            Config.DefaultVersion = v.Idx;
            for _, item in next, VersionItems do item.Match(); end;
            NeverLose:Log("INFO", "Opened product: " .. tostring(v.Name));

            ProductWindow:SetUnlocked(LoaderLib.Redeemed);
            ProductWindow:Show({
                Name = v.Name, Image = v.Image, Icon = v.Icon,
                Version = v.Version or v.Idx, Date = v.Date,
                Changelog = v.Changelog or v.Content, Info = v.Info or {},
                Links = v.WindowLinks or { { Name = "Community" }, { Name = "API Docs" } },
                OnDownload = function()
                    NeverLose:Log("INFO", "Launch requested: " .. tostring(v.Name));
                    LoaderLib.MarkLoad.SetValue(true);
                    task.wait(0.4);
                    LoaderLib.MarkLoad.SetValue(false);
                    ProductWindow:Hide();
                    LoaderLib:SetRender(false);
                    LoaderLib.YieldEvent:Fire(v.Idx);
                end,
            });
        end);

        VersionProcess.Match();
        VersionProcess.SetRender(false);
    end;

    -- ── Get Key ──
    NeverLose:CreateInput(NeverLose, KeyFrame, function()
        NeverLose:Log("INFO", "Get Key pressed.");
        Config.OnGetKey();
        NeverLose:Notify("License", "Key link copied / opened.", "info");
    end);

    -- ── Redeem (rate-limited) ──
    local redeemBusy = false;
    NeverLose:CreateInput(NeverLose, RedeemFrame, function()
        if redeemBusy then return; end;
        if LoaderLib.Redeemed then
            NeverLose:Notify("License", "Key already activated.", "info");
            return;
        end;
        if isKeyEmpty() then
            NeverLose:Notify("License", "Please enter your license key first.", "warn");
            return;
        end;

        redeemBusy = true;
        TextBox.TextEditable = false;

        local ok, result = pcall(function() return Config.OnRedeem(TextBox.Text); end);
        local success, why;
        if ok then
            success, why = result, select(2, Config.OnRedeem(TextBox.Text));
            -- на случай, если OnRedeem возвращает (bool, reason):
            local s2, w2 = Config.OnRedeem(TextBox.Text);
            success, why = s2, w2;
        else
            success, why = false, "Redeem handler error";
            NeverLose:Log("ERROR", "OnRedeem crashed: " .. tostring(result));
        end;

        if success then
            LoaderLib.Redeemed = true;
            ProductWindow:SetUnlocked(true);
            UpdateRedeemButton();
            NeverLose:Log("INFO", "Key accepted.");
            NeverLose:Notify("License", "Key accepted — products unlocked.", "success");
            if Config.SaveKey then
                pcall(function() if writefile then writefile(Config.KeyFile, TextBox.Text); end; end);
            end;
        else
            TextBox.TextEditable = true;
            NeverLose:Log("WARN", "Key rejected: " .. tostring(why));
            NeverLose:Notify("License", tostring(why or "Invalid key"), "error");
        end;

        task.wait(0.75); -- cooldown against spam
        redeemBusy = false;
    end);

    -- hover states
    NeverLose:AddSignal(KeyFrame.MouseEnter:Connect(function() fade(KeyFrame, { BackgroundColor3 = Color3.fromRGB(28, 31, 42) }); end));
    NeverLose:AddSignal(KeyFrame.MouseLeave:Connect(function() fade(KeyFrame, { BackgroundColor3 = Color3.fromRGB(18, 20, 28) }); end));
    NeverLose:AddSignal(RedeemFrame.MouseEnter:Connect(function()
        fade(RedeemFrame, { BackgroundColor3 = RedeemFrame.BackgroundColor3:Lerp(Color3.fromRGB(255, 255, 255), 0.15) });
    end));
    NeverLose:AddSignal(RedeemFrame.MouseLeave:Connect(UpdateRedeemButton));
    NeverLose:AddSignal(InputFrame.MouseEnter:Connect(function() fade(UIStroke, { Transparency = 0.35, Color = NeverLose.AccentColor }); end));
    NeverLose:AddSignal(InputFrame.MouseLeave:Connect(function() fade(UIStroke, { Transparency = 0.65, Color = Color3.fromRGB(45, 48, 58) }); end));

    -- ── Close ──
    NeverLose:CreateInput(NeverLose, CloseButton, function() LoaderLib:Unload(); end);

    -- ── Minimize ──
    LoaderLib.Minimized = false;
    local function SetMinimized(state)
        LoaderLib.Minimized = state;
        NeverLose.PlayAnimate(LoaderFrame, VSlowTween, {
            Size = state and UDim2.new(0, 520, 0, 64) or UDim2.new(0, 520, 0, 400)
        });
        MinButton.Text = state and "+" or "—";
        ScrollingFrame.Visible = not state;
        InputFrame.Visible = not state;
        KeyFrame.Visible = not state;
        RedeemFrame.Visible = not state;
        Profile.Visible = not state;
        for _, nav in next, NavButtons do nav.Visible = not state; end;
    end
    NeverLose:CreateInput(NeverLose, MinButton, function() SetMinimized(not LoaderLib.Minimized); end);

    -- ── Drag (главное окно; окно описания следует за ним) ──
    do
        local dragging, dragStart, startPos;
        local Header = Instance.new("TextButton", LoaderFrame);
        Header.BackgroundTransparency = 1; Header.Text = ""; Header.AutoButtonColor = false;
        Header.Position = UDim2.new(0, 160, 0, 0); Header.Size = UDim2.new(1, -160, 0, 64); Header.ZIndex = 5;
        NeverLose:AddSignal(Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = LoaderFrame.Position;
            end;
        end));
        NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart;
                LoaderFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);
            end;
        end));
        NeverLose:AddSignal(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false; end;
        end));
    end

    -- ── Show / hide loader ──
    LoaderLib.SetRender = LPH_NO_VIRTUALIZE(function(self, value)
        if value then
            LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
            NeverLose.PlayAnimate(LoaderFrame, VSlowTween, { BackgroundTransparency = 0, Size = UDim2.new(0, 520, 0, 400) });
            for _, o in next, { Logo, LogoBack, ProfileName, WindowName } do fade(o, { TextTransparency = 0 }); end;
            fade(Avatar, { ImageTransparency = 0, BackgroundTransparency = 0 });
            fade(WindowContent, { TextTransparency = 0.15 }); fade(MinButton, { TextTransparency = 0.35 }); fade(CloseButton, { TextTransparency = 0.35 });
            for _, nav in next, NavButtons do fade(nav, { TextTransparency = 0.25 }); end;
            fade(InputFrame, { BackgroundTransparency = 0 }); fade(UIStroke, { Transparency = 0.65 });
            fade(KeyIcon, { TextTransparency = 0.25 }); fade(TextBox, { TextTransparency = 0.35 });
            fade(KeyFrame, { BackgroundTransparency = 0 }); fade(UIStroke_2, { Transparency = 0.65 });
            fade(Content_Key, { TextTransparency = 0.2 }); fade(Icon_Key, { TextTransparency = 0.25 });
            fade(RedeemFrame, { BackgroundTransparency = 0 }); fade(Content_Redeem, { TextTransparency = 0 }); fade(Icon_Redeem, { TextTransparency = 0 });
            for _, Render in next, LoaderLib.Renderer do Render(true); end;
            Shadow:Render(true);
        else
            fade(LoaderFrame, { BackgroundTransparency = 1 });
            for _, o in next, { Logo, LogoBack, ProfileName, WindowName, WindowContent, MinButton, CloseButton } do fade(o, { TextTransparency = 1 }); end;
            fade(Avatar, { ImageTransparency = 1, BackgroundTransparency = 1 });
            for _, nav in next, NavButtons do fade(nav, { TextTransparency = 1 }); end;
            fade(InputFrame, { BackgroundTransparency = 1 }); fade(UIStroke, { Transparency = 1 });
            fade(KeyIcon, { TextTransparency = 1 }); fade(TextBox, { TextTransparency = 1 });
            fade(KeyFrame, { BackgroundTransparency = 1 }); fade(UIStroke_2, { Transparency = 1 });
            fade(Content_Key, { TextTransparency = 1 }); fade(Icon_Key, { TextTransparency = 1 });
            fade(RedeemFrame, { BackgroundTransparency = 1 }); fade(Content_Redeem, { TextTransparency = 1 }); fade(Icon_Redeem, { TextTransparency = 1 });
            for _, Render in next, LoaderLib.Renderer do Render(false); end;
            LoaderLib.MarkLoad.SetValue(false);
            Shadow:Render(false);
        end;
    end);

    LoaderLib:SetRender(false);
    task.delay(0.3, LoaderLib.SetRender, LoaderLib, true);
    NeverLose:Notify("Neverlose", "Loader ready. Redeem your key to unlock products.", "info", 5);

    function LoaderLib:Await() return LoaderLib.YieldEvent.Event:Wait(); end;
    function LoaderLib:Unload()
        LoaderLib:SetRender(false);
        task.wait();
        task.delay(0.45, function() NeverLose:Unload(); end);
        task.wait(0.3);
    end;

    return LoaderLib;
end;

return NeverLose
