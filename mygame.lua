-- ============================================
--   🎮 Morocco Scripts Hub
--   ✅ realistic morocco
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- 🔗 روابط السكريبتات
-------------------------------------------------
local SCRIPT_1_URL = "https://raw.githubusercontent.com/12sanfor21-creator/Zbel/refs/heads/main/script.lua"
local SCRIPT_2_URL = "https://raw.githubusercontent.com/12sanfor21-creator/Zbel/refs/heads/main/pizza.lua"

-------------------------------------------------
-- 🖼️ رابط صورة اللوغو (يمكنك تغييره)
-- ارفع صورتك على imgur.com وضع الرابط هنا
-------------------------------------------------
local LOGO_URL = "rbxassetid://0"  -- 🔥 ضع رابط الصورة هنا (اختياري)

-------------------------------------------------
-- 🎨 الألوان
-------------------------------------------------
local DARK_BG    = Color3.fromRGB(15, 10, 25)
local HEADER_BG  = Color3.fromRGB(40, 15, 60)
local BTN_1      = Color3.fromRGB(20, 100, 180)   -- أزرق (Realistic Morocco)
local BTN_2      = Color3.fromRGB(180, 80, 20)    -- برتقالي (New Life)
local BTN_HIDE   = Color3.fromRGB(150, 30, 30)
local STROKE_COL = Color3.fromRGB(120, 60, 200)
local TEXT_COL   = Color3.fromRGB(255, 240, 255)

-------------------------------------------------
-- 🖥️ الواجهة الرئيسية
-------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoroccoScriptsHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 260)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
mainFrame.BackgroundColor3 = DARK_BG
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = STROKE_COL
stroke.Thickness = 2
stroke.Parent = mainFrame

-------------------------------------------------
-- 📝 العنوان
-------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = HEADER_BG
title.Text = "🇲🇦 Morocco Scripts Hub"
title.TextColor3 = TEXT_COL
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-------------------------------------------------
-- 🗕 زر التصغير
-------------------------------------------------
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -34, 0, 8)
minimizeBtn.BackgroundColor3 = BTN_HIDE
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.ZIndex = 5
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-------------------------------------------------
-- 📋 وصف صغير
-------------------------------------------------
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 24)
subtitle.Position = UDim2.new(0, 10, 0, 55)
subtitle.BackgroundTransparency = 1
subtitle.Text = "اختر السكريبت الذي تريد تشغيله:"
subtitle.TextColor3 = Color3.fromRGB(200, 180, 220)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.Parent = mainFrame

-------------------------------------------------
-- 🎮 زر 1: Realistic Morocco
-------------------------------------------------
local btn1 = Instance.new("TextButton")
btn1.Size = UDim2.new(1, -20, 0, 55)
btn1.Position = UDim2.new(0, 10, 0, 88)
btn1.BackgroundColor3 = BTN_1
btn1.Text = "🎮 Realistic Morocco\n(مايك مغرب عربي)"
btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
btn1.Font = Enum.Font.GothamBold
btn1.TextSize = 13
btn1.Parent = mainFrame

local btn1Corner = Instance.new("UICorner")
btn1Corner.CornerRadius = UDim.new(0, 8)
btn1Corner.Parent = btn1

-------------------------------------------------
-- 🎮 زر 2: Morocco New Life
-------------------------------------------------
local btn2 = Instance.new("TextButton")
btn2.Size = UDim2.new(1, -20, 0, 55)
btn2.Position = UDim2.new(0, 10, 0, 152)
btn2.BackgroundColor3 = BTN_2
btn2.Text = "🍕 Morocco New Life\n(الحياة الجديدة)"
btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
btn2.Font = Enum.Font.GothamBold
btn2.TextSize = 13
btn2.Parent = mainFrame

local btn2Corner = Instance.new("UICorner")
btn2Corner.CornerRadius = UDim.new(0, 8)
btn2Corner.Parent = btn2

-------------------------------------------------
-- 📊 شريط الحالة
-------------------------------------------------
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 24)
statusLabel.Position = UDim2.new(0, 10, 0, 220)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "✅ جاهز - اختر سكريبت"
statusLabel.TextColor3 = Color3.fromRGB(150, 220, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.Parent = mainFrame

-------------------------------------------------
-- 🗕 الأيقونة العائمة (بعد التصغير)
-------------------------------------------------
local floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0, 60, 0, 60)
floatingBtn.Position = UDim2.new(0, 20, 0.5, -30)
floatingBtn.BackgroundColor3 = HEADER_BG
floatingBtn.Text = "🇲🇦"
floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.Font = Enum.Font.GothamBold
floatingBtn.TextSize = 32
floatingBtn.Visible = false
floatingBtn.Draggable = true
floatingBtn.Parent = screenGui

local fbc = Instance.new("UICorner")
fbc.CornerRadius = UDim.new(1, 0)
fbc.Parent = floatingBtn

local fbStroke = Instance.new("UIStroke")
fbStroke.Color = STROKE_COL
fbStroke.Thickness = 3
fbStroke.Parent = floatingBtn

-------------------------------------------------
-- 🖼️ اللوغو داخل الأيقونة (إذا كان الرابط موجود)
-------------------------------------------------
if LOGO_URL ~= "rbxassetid://0" then
    local logoImage = Instance.new("ImageLabel")
    logoImage.Size = UDim2.new(1, -8, 1, -8)
    logoImage.Position = UDim2.new(0, 4, 0, 4)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = LOGO_URL
    logoImage.Parent = floatingBtn
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(1, 0)
    logoCorner.Parent = logoImage
    
    floatingBtn.Text = ""  -- إخفاء النص عند وجود صورة
end

-------------------------------------------------
-- 🔄 دوال تشغيل السكريبتات
-------------------------------------------------
local function runScript1()
    statusLabel.Text = "⏳ جاري تحميل Realistic Morocco..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    btn1.Text = "⏳ جاري التحميل..."
    
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet(SCRIPT_1_URL))()
        end)
        
        if ok then
            statusLabel.Text = "✅ تم تشغيل Realistic Morocco"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            btn1.Text = "✅ Realistic Morocco\n(تم التحميل)"
        else
            statusLabel.Text = "❌ فشل التحميل - تحقق من الرابط"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn1.Text = "🎮 Realistic Morocco\n(مايك مغرب عربي)"
            warn("[Hub] فشل تشغيل سكريبت 1:", err)
        end
    end)
end

local function runScript2()
    statusLabel.Text = "⏳ جاري تحميل Morocco New Life..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    btn2.Text = "⏳ جاري التحميل..."
    
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet(SCRIPT_2_URL))()
        end)
        
        if ok then
            statusLabel.Text = "✅ تم تشغيل Morocco New Life"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            btn2.Text = "✅ Morocco New Life\n(تم التحميل)"
        else
            statusLabel.Text = "❌ فشل التحميل - تحقق من الرابط"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn2.Text = "🍕 Morocco New Life\n(الحياة الجديدة)"
            warn("[Hub] فشل تشغيل سكريبت 2:", err)
        end
    end)
end

-------------------------------------------------
-- 🎮 ربط الأزرار
-------------------------------------------------
btn1.MouseButton1Click:Connect(runScript1)
btn2.MouseButton1Click:Connect(runScript2)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingBtn.Visible = true
end)

floatingBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingBtn.Visible = false
end)

-------------------------------------------------
-- 🚀 رسالة الترحيب
-------------------------------------------------
print("[Morocco Scripts Hub] ✅ جاهز")
