-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- ==========================================
-- CONFIGURATION (Hier kannst du deine Skripte anpassen)
-- ==========================================
local Config = {
    UniversalScript = {
        Title = "PyroX Universal Script (Down)",
        Desc = "its down i will make a remake",
        IconId = 101800459005792,
        Url = "https://down"
    },
    GameScripts = {
        [128039018996175] = {
            Title = "The Walking Death Online 3 Script",
            Desc = "a script made for twdo3",
            IconId = 87599473539232,
            Url = "https://raw.githubusercontent.com/PyroX5343/RobloxCheats/refs/heads/main/Games/TWDO3.lua"
        },
    }
}

-- Verhindern, dass das GUI doppelt geladen wird
if CoreGui:FindFirstChild("PyroXHubGUI") then
    CoreGui.PyroXHubGUI:Destroy()
end
if CoreGui:FindFirstChild("PyroXHubToggle") then
    CoreGui.PyroXHubToggle:Destroy()
end
if CoreGui:FindFirstChild("PyroXNotifications") then
    CoreGui.PyroXNotifications:Destroy()
end

-- Sound-Helper Funktion
local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = 1
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- Sound beim Öffnen des Menüs abspielen
playSound(7767565587)

-- ==========================================
-- NOTIFICATION SYSTEM
-- ==========================================
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "PyroXNotifications"
NotifyGui.Parent = CoreGui
NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifyGui.DisplayOrder = 9999999

local NotifyList = Instance.new("Frame")
NotifyList.Size = UDim2.new(0, 260, 1, -50)
NotifyList.Position = UDim2.new(1, -280, 0, 25)
NotifyList.BackgroundTransparency = 1
NotifyList.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 12)
NotifyLayout.Parent = NotifyList

-- Tabelle zum Verfolgen aktiver Animations-Gradienten in Notifications
local activeNotifGradients = {}

local function sendNotification(title, text, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 65)
    notif.BackgroundColor3 = Color3.fromRGB(12, 9, 18)
    notif.BackgroundTransparency = 1
    notif.Parent = NotifyList
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif
    
    -- Solider Basis-Stroke (schwarz) - Noch dünner gemacht (1)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 1
    stroke.Transparency = 1
    stroke.Parent = notif

    -- Animierter Glow-Stroke für die Notifications - Noch dünner gemacht (1)
    local notifGlowStroke = Instance.new("UIStroke")
    notifGlowStroke.Name = "NotifGlowStroke"
    notifGlowStroke.Color = Color3.fromRGB(186, 86, 253)
    notifGlowStroke.Thickness = 1.8
    notifGlowStroke.Transparency = 1
    notifGlowStroke.Parent = notif

    local notifGlowGradient = Instance.new("UIGradient")
    notifGlowGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0),
        NumberSequenceKeypoint.new(0.35, 1),
        NumberSequenceKeypoint.new(0.65, 1),
        NumberSequenceKeypoint.new(0.85, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    notifGlowGradient.Parent = notifGlowStroke

    table.insert(activeNotifGradients, notifGlowGradient)

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -20, 0, 20)
    tLbl.Position = UDim2.new(0, 15, 0, 10)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = Color3.fromRGB(243, 232, 255)
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 13
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.TextTransparency = 1
    tLbl.Parent = notif
    
    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(1, -20, 0, 20)
    dLbl.Position = UDim2.new(0, 15, 0, 32)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = text
    dLbl.TextColor3 = Color3.fromRGB(140, 130, 160)
    dLbl.Font = Enum.Font.Gotham
    dLbl.TextSize = 11
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.TextWrapped = true
    dLbl.TextTransparency = 1
    dLbl.Parent = notif
    
    playSound(106351605533621)
    
    TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(notifGlowStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(tLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(dLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.delay(duration or 3, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(notifGlowStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(tLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(dLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3)
        
        for i, grad in ipairs(activeNotifGradients) do
            if grad == notifGlowGradient then
                table.remove(activeNotifGradients, i)
                break
            end
        end
        
        notif:Destroy()
    end)
end

-- Haupt ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PyroXHubGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999995

-- Floating Toggle GUI
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "PyroXHubToggle"
ToggleGui.Parent = CoreGui
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.IgnoreGuiInset = true
ToggleGui.DisplayOrder = 999998

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(1, -75, 1, -75)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(8, 6, 12)
ToggleBtn.BackgroundTransparency = 0.4
ToggleBtn.Text = "P"
ToggleBtn.TextSize = 24
ToggleBtn.AutoButtonColor = false
ToggleBtn.Visible = false
ToggleBtn.Parent = ToggleGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(168, 85, 247)
ToggleStroke.Thickness = 1.5 -- Dünner gemacht (1.5 statt 2.5)
ToggleStroke.Parent = ToggleBtn

-- Fullscreen Hintergrund-Overlay
local BGOverlay = Instance.new("Frame")
BGOverlay.Name = "BackgroundOverlay"
BGOverlay.Size = UDim2.new(1, 0, 1, 0)
BGOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BGOverlay.BackgroundTransparency = 1
BGOverlay.BorderSizePixel = 0
BGOverlay.Parent = ScreenGui

local BGGradient = Instance.new("UIGradient")
BGGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 35, 165)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 3, 7))
})
BGGradient.Rotation = 90
BGGradient.Parent = BGOverlay

TweenService:Create(BGOverlay, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()

-- Blur-Effekt
local blur = Instance.new("BlurEffect")
blur.Name = "PyroXBlur"
blur.Size = 0
blur.Parent = Lighting
TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 28}):Play()

-- Kamera-Zoom Effekt
local originalFOV = camera.FieldOfView
TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {FieldOfView = originalFOV - 12}):Play()

-- ==========================================
-- LOADING SCREEN
-- ==========================================
local LoadingOverlay = Instance.new("Frame")
LoadingOverlay.Name = "LoadingOverlay"
LoadingOverlay.Size = UDim2.new(1, 0, 1, 0)
LoadingOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingOverlay.BackgroundTransparency = 0
LoadingOverlay.BorderSizePixel = 0
LoadingOverlay.ZIndex = 10
LoadingOverlay.Parent = ScreenGui

local LoadingBgImage = Instance.new("ImageLabel")
LoadingBgImage.Name = "LoadingBgImage"
LoadingBgImage.Size = UDim2.new(0, 480, 0, 480)
LoadingBgImage.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingBgImage.Position = UDim2.new(0.5, 0, 0.33, 0)
LoadingBgImage.BackgroundTransparency = 1
LoadingBgImage.Image = "rbxassetid://114390254506313"
LoadingBgImage.ScaleType = Enum.ScaleType.Fit
LoadingBgImage.ZIndex = 11
LoadingBgImage.Parent = LoadingOverlay

local LoadingContainer = Instance.new("Frame")
LoadingContainer.Name = "LoadingContainer"
LoadingContainer.Size = UDim2.new(0, 480, 0, 180)
LoadingContainer.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingContainer.Position = UDim2.new(0.5, 0, 0.74, 0)
LoadingContainer.BackgroundTransparency = 1
LoadingContainer.ZIndex = 12
LoadingContainer.Parent = LoadingOverlay

local SplashTitle = Instance.new("TextLabel")
SplashTitle.Name = "SplashTitle"
SplashTitle.Size = UDim2.new(1, 0, 0, 40)
SplashTitle.Position = UDim2.new(0, 0, 0, 0)
SplashTitle.BackgroundTransparency = 1
SplashTitle.Text = ""
SplashTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SplashTitle.TextSize = 36
SplashTitle.Font = Enum.Font.GothamBlack
SplashTitle.ZIndex = 12
SplashTitle.Parent = LoadingContainer

local SplashTitleGradient = Instance.new("UIGradient")
SplashTitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(216, 180, 254))
})
SplashTitleGradient.Rotation = 90
SplashTitleGradient.Parent = SplashTitle

local SplashGlow = Instance.new("UIStroke")
SplashGlow.Color = Color3.fromRGB(168, 85, 247)
SplashGlow.Thickness = 1 -- Dünner gemacht (1 statt 2)
SplashGlow.Transparency = 0.3
SplashGlow.Parent = SplashTitle

local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Size = UDim2.new(1, 0, 0, 20)
LoadingStatus.Position = UDim2.new(0, 0, 0, 50)
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Text = "INITIALIZING CORE SYSTEMS..."
LoadingStatus.TextColor3 = Color3.fromRGB(186, 86, 253)
LoadingStatus.TextSize = 11
LoadingStatus.Font = Enum.Font.GothamBold
LoadingStatus.ZIndex = 12
LoadingStatus.Parent = LoadingContainer

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 380, 0, 8)
BarBg.AnchorPoint = Vector2.new(0.5, 0)
BarBg.Position = UDim2.new(0.5, 0, 0, 95)
BarBg.BackgroundColor3 = Color3.fromRGB(14, 10, 22)
BarBg.BackgroundTransparency = 0.5
BarBg.BorderSizePixel = 0
BarBg.ZIndex = 12
BarBg.Parent = LoadingContainer

local BarBgCorner = Instance.new("UICorner")
BarBgCorner.CornerRadius = UDim.new(1, 0)
BarBgCorner.Parent = BarBg

local BarBgStroke = Instance.new("UIStroke")
BarBgStroke.Color = Color3.fromRGB(60, 40, 90)
BarBgStroke.Thickness = 1
BarBgStroke.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 13
BarFill.Parent = BarBg

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarFill

local BarGradient = Instance.new("UIGradient")
BarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 86, 253)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(216, 180, 254))
})
BarGradient.Parent = BarFill

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Size = UDim2.new(1, 0, 0, 20)
PercentLabel.Position = UDim2.new(0, 0, 0, 112)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(140, 130, 160)
PercentLabel.TextSize = 11
PercentLabel.Font = Enum.Font.GothamMedium
PercentLabel.ZIndex = 12
PercentLabel.Parent = LoadingContainer

-- ==========================================
-- HAUPTFENSTER
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 420)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.42, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 6, 12)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainScale = Instance.new("UIScale")
MainScale.Name = "MainScale"
MainScale.Parent = MainFrame

local function updateScale()
    local screenSize = camera.ViewportSize
    local scale = math.min(screenSize.X / 1280, screenSize.Y / 720)
    MainScale.Scale = math.clamp(scale, 0.6, 1.4)
end
camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
updateScale()

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- 1. Solider, schwarzer Basis-Stroke - Dünner gemacht (1.5)
local MainStroke = Instance.new("UIStroke")
MainStroke.Name = "MainStroke"
MainStroke.Color = Color3.fromRGB(0, 0, 0)
MainStroke.Transparency = 1
MainStroke.Thickness = 1.4
MainStroke.Parent = MainFrame

-- 2. Animierter Lila-Glow-Stroke - Dünner gemacht (1)
local GlowStroke = Instance.new("UIStroke")
GlowStroke.Name = "GlowStroke"
GlowStroke.Color = Color3.fromRGB(186, 86, 253)
GlowStroke.Transparency = 1
GlowStroke.Thickness = 1.5
GlowStroke.Parent = MainFrame

local GlowGradient = Instance.new("UIGradient")
GlowGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.15, 0),
    NumberSequenceKeypoint.new(0.35, 1),
    NumberSequenceKeypoint.new(0.65, 1),
    NumberSequenceKeypoint.new(0.85, 0),
    NumberSequenceKeypoint.new(1, 1)
})
GlowGradient.Parent = GlowStroke

local LogoContainer = Instance.new("Frame")
LogoContainer.Name = "LogoContainer"
LogoContainer.Size = UDim2.new(0, 50, 0, 50)
LogoContainer.Position = UDim2.new(0.5, -25, 0, 15)
LogoContainer.BackgroundColor3 = Color3.fromRGB(18, 10, 28)
LogoContainer.BackgroundTransparency = 0.3
LogoContainer.BorderSizePixel = 0
LogoContainer.Parent = MainFrame

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 13)
LogoCorner.Parent = LogoContainer

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(29, 20, 33)
LogoStroke.Thickness = 1 -- Dünner gemacht (1 statt 2)
LogoStroke.Parent = LogoContainer

local LogoImage = Instance.new("ImageLabel")
LogoImage.Size = UDim2.new(0, 38, 0, 38) 
LogoImage.AnchorPoint = Vector2.new(0.5, 0.5)
LogoImage.Position = UDim2.new(0.5, 0, 0.5, 0) 
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://107742855012780"
LogoImage.Parent = LogoContainer

local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, 0, 0, 20)
WelcomeLabel.Position = UDim2.new(0, 0, 0, 72)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "WELCOME TO RIFT HUB"
WelcomeLabel.TextColor3 = Color3.fromRGB(168, 85, 247)
WelcomeLabel.TextSize = 12
WelcomeLabel.Font = Enum.Font.GothamBold
WelcomeLabel.TextTransparency = 1
WelcomeLabel.Parent = MainFrame

local UltimateLabel = Instance.new("TextLabel")
UltimateLabel.Size = UDim2.new(1, 0, 0, 20)
UltimateLabel.Position = UDim2.new(0, 0, 0, 130)
UltimateLabel.BackgroundTransparency = 1
UltimateLabel.Text = "THE ULTIMATE EXPERIENCE"
UltimateLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
UltimateLabel.TextSize = 11
UltimateLabel.Font = Enum.Font.GothamMedium
UltimateLabel.Parent = MainFrame

-- ==========================================
-- ZWEITES FRAME (Andere Scripts)
-- ==========================================
local SecondaryFrame = Instance.new("Frame")
SecondaryFrame.Name = "SecondaryFrame"
SecondaryFrame.Size = UDim2.new(0, 680, 0, 145)
SecondaryFrame.Position = UDim2.new(0, 0, 1, 15)
SecondaryFrame.BackgroundColor3 = Color3.fromRGB(8, 6, 12)
SecondaryFrame.BackgroundTransparency = 0.45
SecondaryFrame.BorderSizePixel = 0
SecondaryFrame.Parent = MainFrame

local SecCorner = Instance.new("UICorner")
SecCorner.CornerRadius = UDim.new(0, 14)
SecCorner.Parent = SecondaryFrame

local SecStroke = Instance.new("UIStroke")
SecStroke.Name = "SecStroke"
SecStroke.Color = Color3.fromRGB(0, 0, 0)
SecStroke.Thickness = 1 -- Dünner gemacht (1 statt 2)
SecStroke.Parent = SecondaryFrame

-- Animierter Stroke für Second Frame - Dünner gemacht (1)
local SecGlowStroke = Instance.new("UIStroke")
SecGlowStroke.Name = "SecGlowStroke"
SecGlowStroke.Color = Color3.fromRGB(186, 86, 253)
SecGlowStroke.Thickness = 2
SecGlowStroke.Parent = SecondaryFrame

local SecGlowGradient = Instance.new("UIGradient")
SecGlowGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.15, 0),
    NumberSequenceKeypoint.new(0.35, 1),
    NumberSequenceKeypoint.new(0.65, 1),
    NumberSequenceKeypoint.new(0.85, 0),
    NumberSequenceKeypoint.new(1, 1)
})
SecGlowGradient.Parent = SecGlowStroke

RunService.RenderStepped:Connect(function(dt)
    GlowGradient.Rotation = (GlowGradient.Rotation + dt * 100) % 360
    SecGlowGradient.Rotation = (SecGlowGradient.Rotation + dt * 100) % 360
    
    for _, grad in ipairs(activeNotifGradients) do
        if grad and grad.Parent then
            grad.Rotation = (grad.Rotation + dt * 100) % 360
        end
    end
end)

local SecHeader = Instance.new("TextLabel")
SecHeader.Size = UDim2.new(1, -30, 0, 25)
SecHeader.Position = UDim2.new(0, 15, 0, 6)
SecHeader.BackgroundTransparency = 1
SecHeader.Text = "Other Scripts from Other Creators"
SecHeader.TextColor3 = Color3.fromRGB(168, 85, 247)
SecHeader.TextSize = 11
SecHeader.Font = Enum.Font.GothamBold
SecHeader.TextXAlignment = Enum.TextXAlignment.Left
SecHeader.Parent = SecondaryFrame

local HorizontalScroll = Instance.new("ScrollingFrame")
HorizontalScroll.Size = UDim2.new(1, -20, 0, 100)
HorizontalScroll.Position = UDim2.new(0, 10, 0, 35)
HorizontalScroll.BackgroundTransparency = 1
HorizontalScroll.BorderSizePixel = 0
HorizontalScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
HorizontalScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
HorizontalScroll.ScrollBarThickness = 4
HorizontalScroll.ScrollBarImageColor3 = Color3.fromRGB(168, 85, 247)
HorizontalScroll.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
HorizontalScroll.Parent = SecondaryFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.FillDirection = Enum.FillDirection.Horizontal
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 10)
ScrollLayout.Parent = HorizontalScroll

local ScrollPadding = Instance.new("UIPadding")
ScrollPadding.PaddingLeft = UDim.new(0, 5)
ScrollPadding.PaddingRight = UDim.new(0, 5)
ScrollPadding.Parent = HorizontalScroll

local function addExternalScript(title, desc, iconId, loadstringFunc)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 210, 0, 85)
    card.BackgroundColor3 = Color3.fromRGB(12, 9, 18)
    card.BackgroundTransparency = 0.4
    card.BorderSizePixel = 0
    card.Parent = HorizontalScroll

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(50, 30, 70)
    cardStroke.Thickness = 1
    cardStroke.Parent = card

    local cardTitle = Instance.new("TextLabel")
    cardTitle.Size = UDim2.new(1, -20, 0, 18)
    cardTitle.Position = UDim2.new(0, 10, 0, 8)
    cardTitle.BackgroundTransparency = 1
    cardTitle.Text = title
    cardTitle.TextColor3 = Color3.fromRGB(243, 232, 255)
    cardTitle.TextSize = 12
    cardTitle.Font = Enum.Font.GothamBold
    cardTitle.TextXAlignment = Enum.TextXAlignment.Left
    cardTitle.Parent = card

    local cardDesc = Instance.new("TextLabel")
    cardDesc.Size = UDim2.new(1, -20, 0, 20)
    cardDesc.Position = UDim2.new(0, 10, 0, 26)
    cardDesc.BackgroundTransparency = 1
    cardDesc.Text = desc
    cardDesc.TextColor3 = Color3.fromRGB(130, 120, 150)
    cardDesc.TextSize = 10
    cardDesc.Font = Enum.Font.Gotham
    cardDesc.TextXAlignment = Enum.TextXAlignment.Left
    cardDesc.TextTruncate = Enum.TextTruncate.AtEnd
    cardDesc.Parent = card

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(1, -20, 0, 24)
    execBtn.Position = UDim2.new(0, 10, 0, 52)
    execBtn.BackgroundColor3 = Color3.fromRGB(20, 14, 30)
    execBtn.BackgroundTransparency = 0.3
    execBtn.Text = "Execute Script"
    execBtn.TextColor3 = Color3.fromRGB(216, 180, 254)
    execBtn.TextSize = 10
    execBtn.Font = Enum.Font.GothamBold
    execBtn.AutoButtonColor = false
    execBtn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = execBtn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(60, 40, 90)
    btnStroke.Thickness = 1
    btnStroke.Parent = execBtn

    execBtn.MouseEnter:Connect(function()
        playSound(106351605533621)
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(168, 85, 247)}):Play()
        TweenService:Create(execBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 25, 55)}):Play()
    end)

    execBtn.MouseLeave:Connect(function()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 40, 90)}):Play()
        TweenService:Create(execBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 14, 30)}):Play()
    end)

    execBtn.MouseButton1Click:Connect(function()
        playSound(135244211779631)
        execBtn.Text = "Executed!"
        btnStroke.Color = Color3.fromRGB(74, 222, 128)
        TweenService:Create(execBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(15, 35, 25)}):Play()
        
        sendNotification("Execution Success", title .. " has been executed.", 4)
        task.spawn(loadstringFunc)
    end)
end

addExternalScript("Novoline", "Script i use by myself for anti vc ban", 0, function()
    loadstring(game:HttpGet("https://novoline.pro"))()
end)

addExternalScript("Bloxstrike", "bloxstrike script", 0, function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/2a98561d2db34084545ac12269b68961.lua"))()
end)

-- Lade-Logik & Fade-Out
task.spawn(function()
    task.wait(0.2)
    LoadingStatus.Text = "LOADING PREMIER SCRIPTS..."
    
    local startTime = tick()
    local duration = 4.5
    local conn
    
    conn = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / duration, 0, 1)
        
        local easedAlpha = TweenService:GetValue(alpha, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        BarFill.Size = UDim2.new(easedAlpha, 0, 1, 0)
        PercentLabel.Text = math.floor(alpha * 100) .. "%"
        
        if alpha >= 1 then
            conn:Disconnect()
        end
    end)
    
    task.delay(1.5, function()
        LoadingStatus.Text = "ESTABLISHING SECURE ENVIRONMENT..."
    end)
    
    task.delay(3.5, function()
        LoadingStatus.Text = "READY!"
    end)
    
    task.wait(4.8)
    
    local imageFadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(LoadingBgImage, imageFadeInfo, {ImageTransparency = 1}):Play()
    task.wait(0.3)
    
    local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    SplashTitle.Parent = MainFrame
    SplashTitle.Position = UDim2.new(0.5, -250, 0, 85)
    SplashTitle.Size = UDim2.new(0, 500, 0, 80)
    SplashTitle.TextTransparency = 0
    SplashGlow.Transparency = 0

    TweenService:Create(LoadingOverlay, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarBg, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarBgStroke, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(BarFill, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadingStatus, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(PercentLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(SplashGlow, fadeInfo, {Transparency = 1}):Play()
    
    task.wait(0.6)
    LoadingOverlay:Destroy()
    
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.4 
    }):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()
    TweenService:Create(GlowStroke, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()
    
    TweenService:Create(SplashTitle, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        TextSize = 26,
        Position = UDim2.new(0.5, -250, 0, 85)
    }):Play()
    
    WelcomeLabel.TextTransparency = 0
end)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.AbsolutePosition
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            MainFrame.AnchorPoint = Vector2.new(0, 0)
            MainFrame.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
        end
    end
end)

local currentRotX, currentRotY = 0, 0
local targetRotX, targetRotY = 0, 0

RunService.RenderStepped:Connect(function()
    if MainFrame.Visible and not dragging then
        local mouseLocation = UserInputService:GetMouseLocation()
        local screenSize = camera.ViewportSize
        local center = screenSize / 2
        
        local relX = (mouseLocation.X - center.X) / center.X
        local relY = (mouseLocation.Y - center.Y) / center.Y
        
        targetRotY = relX * 5
        targetRotX = -relY * 5
    else
        targetRotX, targetRotY = 0, 0
    end
    
    currentRotX = currentRotX + (targetRotX - currentRotX) * 0.1
    currentRotY = currentRotY + (targetRotY - currentRotY) * 0.1
    
    MainFrame.Rotation = currentRotY * 0.4
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -70, 0, 17)
MinBtn.BackgroundColor3 = Color3.fromRGB(16, 12, 24)
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(216, 180, 254)
MinBtn.TextSize = 12
MinBtn.Font = Enum.Font.GothamBold
MinBtn.AutoButtonColor = false
MinBtn.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Color3.fromRGB(60, 40, 90)
MinStroke.Thickness = 1
MinStroke.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 17)
CloseBtn.BackgroundColor3 = Color3.fromRGB(16, 12, 24)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(248, 113, 113)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(60, 40, 90)
CloseStroke.Thickness = 1
CloseStroke.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    playSound(106351605533621)
    TweenService:Create(CloseBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(180, 40, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 100, 100)}):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(16, 12, 24),
        TextColor3 = Color3.fromRGB(248, 113, 113)
    }):Play()
    TweenService:Create(CloseStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 40, 90)}):Play()
end)

MinBtn.MouseEnter:Connect(function()
    playSound(106351605533621)
    TweenService:Create(MinBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(45, 30, 65),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    TweenService:Create(MinStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(168, 85, 247)}):Play()
end)

MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(16, 12, 24),
        TextColor3 = Color3.fromRGB(216, 180, 254)
    }):Play()
    TweenService:Create(MinStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 40, 90)}):Play()
end)

local function closeGUI()
    playSound(6698737249)
    sendNotification("System", "Rift Script Hub fully closed.", 3)
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 150, 0, 100),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
    TweenService:Create(GlowStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
    TweenService:Create(BGOverlay, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
    TweenService:Create(blur, TweenInfo.new(0.35), {Size = 0}):Play()
    TweenService:Create(camera, TweenInfo.new(0.35), {FieldOfView = originalFOV}):Play()
    task.wait(0.35)
    blur:Destroy()
    ScreenGui:Destroy()
    ToggleGui:Destroy()
end

local function minimizeGUI()
    playSound(6698737249)
    sendNotification("System", "Hub minimized. Click 'P' to restore.", 4)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 120, 0, 80),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    TweenService:Create(GlowStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    TweenService:Create(BGOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(blur, TweenInfo.new(0.3), {Size = 0}):Play()
    TweenService:Create(camera, TweenInfo.new(0.3), {FieldOfView = originalFOV}):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    
    ToggleBtn.Visible = true
    ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleStroke.Transparency = 1
    ToggleBtn.TextTransparency = 1
    
    TweenService:Create(ToggleBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 52, 0, 52), BackgroundTransparency = 0.4}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
end

local function restoreGUI()
    playSound(7767565587)
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    task.wait(0.2)
    ToggleBtn.Visible = false
    
    MainFrame.Visible = true
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.42, 0)
    MainFrame.Size = UDim2.new(0, 150, 0, 100)
    MainFrame.BackgroundTransparency = 1
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 680, 0, 420),
        BackgroundTransparency = 0.4
    }):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
    TweenService:Create(GlowStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
    TweenService:Create(BGOverlay, TweenInfo.new(0.4), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(blur, TweenInfo.new(0.4), {Size = 28}):Play()
    TweenService:Create(camera, TweenInfo.new(0.4), {FieldOfView = originalFOV - 12}):Play()
end

CloseBtn.MouseButton1Click:Connect(closeGUI)
MinBtn.MouseButton1Click:Connect(minimizeGUI)
ToggleBtn.MouseButton1Click:Connect(restoreGUI)

ToggleBtn.MouseEnter:Connect(function()
    playSound(106351605533621)
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 12, 28)}):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(8, 6, 12)}):Play()
end)

-- Premium Scripts Container
local ScriptsContainer = Instance.new("Frame")
ScriptsContainer.Size = UDim2.new(1, -50, 0, 110)
ScriptsContainer.Position = UDim2.new(0, 25, 0, 155)
ScriptsContainer.BackgroundColor3 = Color3.fromRGB(12, 9, 18)
ScriptsContainer.BackgroundTransparency = 0.45
ScriptsContainer.BorderSizePixel = 0
ScriptsContainer.Parent = MainFrame

local ScriptsCorner = Instance.new("UICorner")
ScriptsCorner.CornerRadius = UDim.new(0, 12)
ScriptsCorner.Parent = ScriptsContainer

local ScriptsStroke = Instance.new("UIStroke")
ScriptsStroke.Color = Color3.fromRGB(50, 30, 70)
ScriptsStroke.Thickness = 1 -- Dünner gemacht (1 statt 1.5)
ScriptsStroke.Parent = ScriptsContainer

local ScriptsHeader = Instance.new("TextLabel")
ScriptsHeader.Size = UDim2.new(1, -20, 0, 30)
ScriptsHeader.Position = UDim2.new(0, 15, 0, 5)
ScriptsHeader.BackgroundTransparency = 1
ScriptsHeader.Text = "★ OUR SCRIPTS"
ScriptsHeader.TextColor3 = Color3.fromRGB(168, 85, 247)
ScriptsHeader.TextSize = 12
ScriptsHeader.Font = Enum.Font.GothamBold
ScriptsHeader.TextXAlignment = Enum.TextXAlignment.Left
ScriptsHeader.Parent = ScriptsContainer

local function createScriptCard(titleText, descText, yPos, iconId, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 56)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(16, 12, 24)
    btn.BackgroundTransparency = 0.4
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = ScriptsContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 40, 90)
    stroke.Thickness = 1
    stroke.Parent = btn

    local btnIcon = Instance.new("ImageLabel")
    btnIcon.Size = UDim2.new(0, 36, 0, 36)
    btnIcon.Position = UDim2.new(0, 14, 0.5, -18)
    btnIcon.BackgroundTransparency = 1
    btnIcon.Image = "rbxassetid://" .. tostring(iconId)
    btnIcon.Parent = btn

    local labelTitle = Instance.new("TextLabel")
    labelTitle.Size = UDim2.new(1, -74, 0, 22) 
    labelTitle.Position = UDim2.new(0, 62, 0, 8)
    labelTitle.BackgroundTransparency = 1
    labelTitle.Text = titleText
    labelTitle.TextColor3 = Color3.fromRGB(243, 232, 255)
    labelTitle.TextSize = 13
    labelTitle.Font = Enum.Font.GothamBold
    labelTitle.TextXAlignment = Enum.TextXAlignment.Left
    labelTitle.Parent = btn

    local labelDesc = Instance.new("TextLabel")
    labelDesc.Size = UDim2.new(1, -74, 0, 18)
    labelDesc.Position = UDim2.new(0, 62, 0, 30)
    labelDesc.BackgroundTransparency = 1
    labelDesc.Text = descText
    labelDesc.TextColor3 = Color3.fromRGB(140, 130, 160)
    labelDesc.TextSize = 11
    labelDesc.Font = Enum.Font.Gotham
    labelDesc.TextXAlignment = Enum.TextXAlignment.Left
    labelDesc.Parent = btn

    local executed = false

    btn.MouseEnter:Connect(function()
        if not executed then
            playSound(106351605533621)
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(168, 85, 247)}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(26, 18, 38)}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if not executed then
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 40, 90)}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(16, 12, 24)}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if executed then return end
        executed = true
        playSound(135244211779631)

        stroke.Color = Color3.fromRGB(74, 222, 128)
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(15, 35, 25)}):Play()
        
        sendNotification("Execution Success", titleText .. " has been executed.", 4)
        
        callback()
    end)

    return btn
end

local currentPlaceId = game.PlaceId
local scriptData = Config.GameScripts[currentPlaceId] or Config.UniversalScript

createScriptCard(scriptData.Title, scriptData.Desc, 40, scriptData.IconId, function()
    loadstring(game:HttpGet(scriptData.Url))()
end)

local function createInfoCard(title, desc, iconId, xPos)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 195, 0, 85)
    card.Position = UDim2.new(0, xPos, 0, 275)
    card.BackgroundColor3 = Color3.fromRGB(12, 9, 18)
    card.BackgroundTransparency = 0.4
    card.BorderSizePixel = 0
    card.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 30, 70)
    stroke.Thickness = 1
    stroke.Parent = card

    local cardIcon = Instance.new("ImageLabel")
    cardIcon.Size = UDim2.new(0, 40, 0, 40)
    cardIcon.Position = UDim2.new(0, 10, 0, 8)
    cardIcon.BackgroundTransparency = 1
    cardIcon.Image = "rbxassetid://" .. tostring(iconId)
    cardIcon.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -60, 0, 20)
    tLbl.Position = UDim2.new(0, 55, 0, 18)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = Color3.fromRGB(216, 180, 254)
    tLbl.TextSize = 11
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(1, -20, 0, 30)
    dLbl.Position = UDim2.new(0, 12, 0, 52)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.TextColor3 = Color3.fromRGB(130, 120, 150)
    dLbl.TextSize = 10
    dLbl.Font = Enum.Font.Gotham
    dLbl.TextWrapped = true
    dLbl.Parent = card
end

createInfoCard("PERFORMANCE", "Optimized for max FPS and play fun with cheats", 113438074405338, 25)
createInfoCard("SCRIPT  PROTECTED", "Our script is Protected from stealing", 94906293985685, 242)
createInfoCard("SAVE YOUR TIME", "we make scripts for you", 98620336180634, 460)

local FooterBar = Instance.new("Frame")
FooterBar.Size = UDim2.new(1, -50, 0, 30)
FooterBar.Position = UDim2.new(0, 25, 1, -38)
FooterBar.BackgroundTransparency = 1
FooterBar.Parent = MainFrame

local StatusIndicator = Instance.new("TextLabel")
StatusIndicator.Size = UDim2.new(0, 150, 1, 0)
StatusIndicator.BackgroundTransparency = 1
StatusIndicator.Text = "● STATUS: ONLINE"
StatusIndicator.TextColor3 = Color3.fromRGB(74, 222, 128)
StatusIndicator.TextSize = 11
StatusIndicator.Font = Enum.Font.GothamBold
StatusIndicator.TextXAlignment = Enum.TextXAlignment.Left
StatusIndicator.Parent = FooterBar

local PlayersOnline = Instance.new("TextLabel")
PlayersOnline.Size = UDim2.new(0, 100, 1, 0)
PlayersOnline.Position = UDim2.new(0.5, -50, 0, 0)
PlayersOnline.BackgroundTransparency = 1
PlayersOnline.Text = "V 1.061.4"
PlayersOnline.TextColor3 = Color3.fromRGB(130, 120, 150)
PlayersOnline.TextSize = 11
PlayersOnline.Font = Enum.Font.GothamBold
PlayersOnline.TextXAlignment = Enum.TextXAlignment.Center
PlayersOnline.Parent = FooterBar

local ProfileContainer = Instance.new("Frame")
ProfileContainer.Size = UDim2.new(0, 140, 1, 0)
ProfileContainer.Position = UDim2.new(1, -140, 0, 0)
ProfileContainer.BackgroundTransparency = 1
ProfileContainer.Parent = FooterBar

local ProfAvatar = Instance.new("ImageLabel")
ProfAvatar.Size = UDim2.new(0, 26, 0, 26)
ProfAvatar.Position = UDim2.new(1, -26, 0.5, -13)
ProfAvatar.BackgroundColor3 = Color3.fromRGB(20, 12, 30)
local success, image = pcall(function()
    return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)
ProfAvatar.Image = success and image or ""
ProfAvatar.Parent = ProfileContainer

local AvCorner = Instance.new("UICorner") 
AvCorner.CornerRadius = UDim.new(1, 0) 
AvCorner.Parent = ProfAvatar

local ProfStroke = Instance.new("UIStroke")
ProfStroke.Color = Color3.fromRGB(168, 85, 247)
ProfStroke.Thickness = 1
ProfStroke.Parent = ProfAvatar

local ProfName = Instance.new("TextLabel")
ProfName.Size = UDim2.new(1, -34, 1, 0)
ProfName.Position = UDim2.new(0, 0, 0, 0)
ProfName.BackgroundTransparency = 1
ProfName.Text = player.DisplayName or player.Name
ProfName.TextColor3 = Color3.fromRGB(243, 232, 255)
ProfName.Font = Enum.Font.GothamBold
ProfName.TextSize = 11
ProfName.TextXAlignment = Enum.TextXAlignment.Right
ProfName.TextTruncate = Enum.TextTruncate.AtEnd
ProfName.Parent = ProfileContainer
