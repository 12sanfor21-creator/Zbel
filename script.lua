-- ============================================
--   Auto Collector v9 - Pro Edition
--   ✅ حفظ تلقائي | ألوان | Server Hop
--   ✅ Anti-AFK | Teleport Shortcuts
--   ✅ Auto-resume بعد الطرد
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-------------------------------------------------
-- 🔗 رابط سكريبتك (ضعه هنا لتفعيل Auto-Reload)
-- مثال: "https://raw.githubusercontent.com/user/repo/main/script.lua"
-------------------------------------------------
local SCRIPT_URL = ""  -- 🔥 ضع رابط Raw هنا

-------------------------------------------------
-- ⚙️ الإعدادات
-------------------------------------------------
local Settings = {
    running = false,
    delayBetween = 0.15,
    heightOffset = 3,
    timeoutCollect = 1.5,
    rescanDelay = 0.8,
    maxDistance = 700,
    antiAFK = true,
    autoResume = false   -- 🔥 يبدأ OFF، عند تفعيله: السكريبت يعمل تلقائيًا عند الدخول
}

local savedShortcuts = {}
local currentThemeName = "Blood"

local INSTAGRAM_URL = "https://www.instagram.com/bilal_____bh?obrf=MTltYjJuNHowN3Fxcg=="

-------------------------------------------------
-- 🎨 الألوان (5 ثيمات)
-------------------------------------------------
local THEMES = {
    Blood   = {dark = Color3.fromRGB(40,5,5),   header = Color3.fromRGB(75,10,10),  btn = Color3.fromRGB(120,15,15),  stroke = Color3.fromRGB(180,25,25),  text = Color3.fromRGB(255,230,230)},
    Royal   = {dark = Color3.fromRGB(10,15,40), header = Color3.fromRGB(20,30,75),  btn = Color3.fromRGB(30,50,120),  stroke = Color3.fromRGB(80,130,200), text = Color3.fromRGB(230,240,255)},
    Emerald = {dark = Color3.fromRGB(5,30,15),  header = Color3.fromRGB(10,60,30),  btn = Color3.fromRGB(15,100,50),  stroke = Color3.fromRGB(50,180,100), text = Color3.fromRGB(220,255,230)},
    Neon    = {dark = Color3.fromRGB(25,5,40),  header = Color3.fromRGB(50,10,75),  btn = Color3.fromRGB(100,20,150), stroke = Color3.fromRGB(200,80,255), text = Color3.fromRGB(240,220,255)},
    Carbon  = {dark = Color3.fromRGB(15,15,20), header = Color3.fromRGB(30,30,40),  btn = Color3.fromRGB(50,50,70),   stroke = Color3.fromRGB(100,100,120),text = Color3.fromRGB(230,230,240)}
}

-------------------------------------------------
-- 💾 نظام حفظ الإعدادات
-------------------------------------------------
local SETTINGS_FOLDER = "AutoCollector"
local SETTINGS_FILE = SETTINGS_FOLDER .. "/settings.json"

local function hasFS()
    return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local function saveSettings()
    if not hasFS() then return end
    pcall(function()
        if type(isfolder) == "function" and type(makefolder) == "function" then
            if not isfolder(SETTINGS_FOLDER) then makefolder(SETTINGS_FOLDER) end
        end
        local data = {
            delayBetween = Settings.delayBetween,
            maxDistance = Settings.maxDistance,
            antiAFK = Settings.antiAFK,
            autoResume = Settings.autoResume,
            theme = currentThemeName,
            shortcuts = savedShortcuts
        }
        writefile(SETTINGS_FILE, HttpService:JSONEncode(data))
    end)
end

local function loadSettings()
    if not hasFS() then return end
    pcall(function()
        if isfile(SETTINGS_FILE) then
            local data = HttpService:JSONDecode(readfile(SETTINGS_FILE))
            if data.delayBetween then Settings.delayBetween = data.delayBetween end
            if data.maxDistance then Settings.maxDistance = data.maxDistance end
            if data.antiAFK ~= nil then Settings.antiAFK = data.antiAFK end
            if data.autoResume ~= nil then Settings.autoResume = data.autoResume end
            if data.theme and THEMES[data.theme] then currentThemeName = data.theme end
            if data.shortcuts then savedShortcuts = data.shortcuts end
        end
    end)
end

loadSettings()

-------------------------------------------------
-- 🛡️ Anti-AFK
-------------------------------------------------
local antiAFKConn = nil
local function enableAntiAFK()
    if antiAFKConn then return end
    antiAFKConn = player.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end
local function disableAntiAFK()
    if antiAFKConn then antiAFKConn:Disconnect() antiAFKConn = nil end
end
if Settings.antiAFK then enableAntiAFK() end

-------------------------------------------------
-- 🎨 نظام الثيمات
-------------------------------------------------
local themeRefs = {frames = {}, headers = {}, buttons = {}, strokes = {}, texts = {}}

local function regFrames(...) for _, f in ipairs({...}) do table.insert(themeRefs.frames, f) end end
local function regHeaders(...) for _, f in ipairs({...}) do table.insert(themeRefs.headers, f) end end
local function regButtons(...) for _, f in ipairs({...}) do table.insert(themeRefs.buttons, f) end end
local function regStrokes(...) for _, f in ipairs({...}) do table.insert(themeRefs.strokes, f) end end
local function regTexts(...) for _, f in ipairs({...}) do table.insert(themeRefs.texts, f) end end

local function applyTheme(name)
    local t = THEMES[name]
    if not t then return end
    currentThemeName = name
    for _, f in ipairs(themeRefs.frames) do f.BackgroundColor3 = t.dark end
    for _, f in ipairs(themeRefs.headers) do f.BackgroundColor3 = t.header end
    for _, f in ipairs(themeRefs.buttons) do f.BackgroundColor3 = t.btn end
    for _, f in ipairs(themeRefs.strokes) do f.Color = t.stroke end
    for _, f in ipairs(themeRefs.texts) do f.TextColor3 = t.text end
    saveSettings()
end

-------------------------------------------------
-- 🖥️ بناء الواجهة
-------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoCollectorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 520)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 5, 5)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
regFrames(mainFrame)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Parent = mainFrame
regStrokes(stroke)

-- زر تصغير (خارج الـ frame، دائم)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -34, 0, 4)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.ZIndex = 5
minimizeBtn.Parent = mainFrame
regButtons(minimizeBtn)

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- العنوان (Instagram)
local titleBtn = Instance.new("TextButton")
titleBtn.Size = UDim2.new(1, 0, 0, 36)
titleBtn.Text = "📷 my instagram: bilal_____bh"
titleBtn.Font = Enum.Font.GothamBold
titleBtn.TextSize = 13
titleBtn.AutoButtonColor = true
titleBtn.Parent = mainFrame
regHeaders(titleBtn)
regTexts(titleBtn)

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBtn

titleBtn.MouseEnter:Connect(function()
    titleBtn.Text = "🔗 اضغط لفتح حسابي"
    titleBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
end)
titleBtn.MouseLeave:Connect(function()
    titleBtn.Text = "📷 my instagram: bilal_____bh"
    titleBtn.TextColor3 = THEMES[currentThemeName].text
end)
titleBtn.MouseButton1Click:Connect(function()
    if setclipboard then pcall(function() setclipboard(INSTAGRAM_URL) end) end
    pcall(function()
        game:GetService("GuiService"):OpenBrowserWindow(INSTAGRAM_URL)
    end)
    titleBtn.Text = "✅ تم نسخ الرابط!"
    titleBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(2)
    titleBtn.Text = "📷 my instagram: bilal_____bh"
    titleBtn.TextColor3 = THEMES[currentThemeName].text
end)

-- زر Pause + Admin
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.5, -15, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 44)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
toggleBtn.Text = "⏸ OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

local adminBtn = Instance.new("TextButton")
adminBtn.Size = UDim2.new(0.5, -15, 0, 30)
adminBtn.Position = UDim2.new(0.5, 5, 0, 44)
adminBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
adminBtn.Text = "⚡ Admin"
adminBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
adminBtn.Font = Enum.Font.GothamBold
adminBtn.TextSize = 12
adminBtn.Parent = mainFrame

local adminCorner = Instance.new("UICorner")
adminCorner.CornerRadius = UDim.new(0, 6)
adminCorner.Parent = adminBtn

-- الحالة
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 18)
statusLabel.Position = UDim2.new(0, 10, 0, 78)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "الحالة: متوقف ⏸️"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame
regTexts(statusLabel)

-------------------------------------------------
-- 📜 ScrollingFrame للمحتوى
-------------------------------------------------
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 100)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(180, 25, 25)
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
scroll.Parent = mainFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 6)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Parent = scroll

-------------------------------------------------
-- 🧩 دالة مساعدة: إنشاء قسم
-------------------------------------------------
local function makeSection(title, height)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, height)
    f.BackgroundColor3 = Color3.fromRGB(30, 5, 5)
    f.BorderSizePixel = 0
    f.Parent = scroll
    regFrames(f)
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = f
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = UDim2.new(0, 5, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    regTexts(lbl)
    
    return f
end

-------------------------------------------------
-- ⏱️ قسم السرعة
-------------------------------------------------
local speedSec = makeSection("⏱️ وقت الانتقال (ثانية)", 55)

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 30, 0, 28)
minusBtn.Position = UDim2.new(0, 5, 0, 24)
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 16
minusBtn.Parent = speedSec
regButtons(minusBtn)

local minusC = Instance.new("UICorner") minusC.CornerRadius = UDim.new(0, 5) minusC.Parent = minusBtn

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 100, 0, 28)
speedInput.Position = UDim2.new(0.5, -50, 0, 24)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
speedInput.Text = string.format("%.2f", Settings.delayBetween)
speedInput.TextColor3 = Color3.fromRGB(255, 200, 200)
speedInput.Font = Enum.Font.GothamBold
speedInput.TextSize = 13
speedInput.Parent = speedSec
regButtons(speedInput)

local sic = Instance.new("UICorner") sic.CornerRadius = UDim.new(0, 5) sic.Parent = speedInput

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 30, 0, 28)
plusBtn.Position = UDim2.new(1, -35, 0, 24)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 16
plusBtn.Parent = speedSec
regButtons(plusBtn)

local plusC = Instance.new("UICorner") plusC.CornerRadius = UDim.new(0, 5) plusC.Parent = plusBtn

-------------------------------------------------
-- 📏 قسم المسافة
-------------------------------------------------
local distSec = makeSection("📏 أقصى مسافة (studs)", 55)

local distInput = Instance.new("TextBox")
distInput.Size = UDim2.new(1, -10, 0, 28)
distInput.Position = UDim2.new(0, 5, 0, 24)
distInput.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
distInput.Text = tostring(Settings.maxDistance)
distInput.TextColor3 = Color3.fromRGB(255, 180, 180)
distInput.Font = Enum.Font.GothamBold
distInput.TextSize = 13
distInput.Parent = distSec
regButtons(distInput)

local dic = Instance.new("UICorner") dic.CornerRadius = UDim.new(0, 5) dic.Parent = distInput

-------------------------------------------------
-- 🎨 قسم الثيمات
-------------------------------------------------
local themeSec = makeSection("🎨 لون الواجهة", 55)

local themeOrder = {"Blood", "Royal", "Emerald", "Neon", "Carbon"}
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(1, -10, 0, 28)
themeBtn.Position = UDim2.new(0, 5, 0, 24)
themeBtn.Text = "🎨 الحالي: " .. currentThemeName
themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 12
themeBtn.Parent = themeSec
regButtons(themeBtn)

local tbc = Instance.new("UICorner") tbc.CornerRadius = UDim.new(0, 5) tbc.Parent = themeBtn

-------------------------------------------------
-- 🚀 قسم Teleport Shortcuts
-------------------------------------------------
local shortcutSec = makeSection("🚀 أماكن سريعة", 20 + 30 * 6)
shortcutSec.Size = UDim2.new(1, -4, 0, 200)

-- TextBox للاسم + زر حفظ
local shortcutNameInput = Instance.new("TextBox")
shortcutNameInput.Size = UDim2.new(0.55, -5, 0, 26)
shortcutNameInput.Position = UDim2.new(0, 5, 0, 24)
shortcutNameInput.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
shortcutNameInput.PlaceholderText = "اسم المكان..."
shortcutNameInput.Text = ""
shortcutNameInput.TextColor3 = Color3.fromRGB(255, 200, 200)
shortcutNameInput.Font = Enum.Font.Gotham
shortcutNameInput.TextSize = 11
shortcutNameInput.Parent = shortcutSec
regButtons(shortcutNameInput)

local snic = Instance.new("UICorner") snic.CornerRadius = UDim.new(0, 5) snic.Parent = shortcutNameInput

local saveLocBtn = Instance.new("TextButton")
saveLocBtn.Size = UDim2.new(0.45, -5, 0, 26)
saveLocBtn.Position = UDim2.new(0.55, 0, 0, 24)
saveLocBtn.Text = "💾 حفظ موقعي"
saveLocBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveLocBtn.Font = Enum.Font.GothamBold
saveLocBtn.TextSize = 11
saveLocBtn.Parent = shortcutSec
regButtons(saveLocBtn)

local slbc = Instance.new("UICorner") slbc.CornerRadius = UDim.new(0, 5) slbc.Parent = saveLocBtn

-- قائمة الأماكن المحفوظة
local shortcutsList = Instance.new("Frame")
shortcutsList.Size = UDim2.new(1, -10, 0, 120)
shortcutsList.Position = UDim2.new(0, 5, 0, 56)
shortcutsList.BackgroundTransparency = 1
shortcutsList.Parent = shortcutSec

local shortcutsLayout = Instance.new("UIListLayout")
shortcutsLayout.Padding = UDim.new(0, 4)
shortcutsLayout.Parent = shortcutsList

local function refreshShortcuts()
    for _, c in ipairs(shortcutsList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    
    for name, loc in pairs(savedShortcuts) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 26)
        row.BackgroundTransparency = 1
        row.Parent = shortcutsList
        
        local goBtn = Instance.new("TextButton")
        goBtn.Size = UDim2.new(0.75, -2, 1, 0)
        goBtn.Position = UDim2.new(0, 0, 0, 0)
        goBtn.Text = "📍 " .. name
        goBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        goBtn.Font = Enum.Font.GothamBold
        goBtn.TextSize = 11
        goBtn.Parent = row
        regButtons(goBtn)
        
        local gc = Instance.new("UICorner") gc.CornerRadius = UDim.new(0, 5) gc.Parent = goBtn
        
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0.25, -2, 1, 0)
        delBtn.Position = UDim2.new(0.75, 4, 0, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        delBtn.Text = "🗑️"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 11
        delBtn.Parent = row
        
        local dc = Instance.new("UICorner") dc.CornerRadius = UDim.new(0, 5) dc.Parent = delBtn
        
        goBtn.MouseButton1Click:Connect(function()
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            pcall(function()
                hrp.CFrame = CFrame.new(Vector3.new(loc.x, loc.y + 3, loc.z))
            end)
            statusLabel.Text = "📍 رُحت إلى: " .. name
        end)
        
        delBtn.MouseButton1Click:Connect(function()
            savedShortcuts[name] = nil
            saveSettings()
            refreshShortcuts()
        end)
    end
end

saveLocBtn.MouseButton1Click:Connect(function()
    local name = shortcutNameInput.Text
    if name == "" then
        statusLabel.Text = "⚠️ اكتب اسم المكان أولاً"
        return
    end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    savedShortcuts[name] = {x = hrp.Position.X, y = hrp.Position.Y, z = hrp.Position.Z}
    saveSettings()
    refreshShortcuts()
    shortcutNameInput.Text = ""
    statusLabel.Text = "✅ تم حفظ: " .. name
end)

refreshShortcuts()

-------------------------------------------------
-- 🛠️ قسم الأدوات (Anti-AFK / Server Hop)
-------------------------------------------------
local toolsSec = makeSection("🛠️ أدوات", 90)

local antiAFKBtn = Instance.new("TextButton")
antiAFKBtn.Size = UDim2.new(0.5, -5, 0, 28)
antiAFKBtn.Position = UDim2.new(0, 5, 0, 24)
antiAFKBtn.Text = "🛡️ Anti-AFK: " .. (Settings.antiAFK and "ON" or "OFF")
antiAFKBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiAFKBtn.Font = Enum.Font.GothamBold
antiAFKBtn.TextSize = 11
antiAFKBtn.BackgroundColor3 = Settings.antiAFK and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
antiAFKBtn.Parent = toolsSec

local aac = Instance.new("UICorner") aac.CornerRadius = UDim.new(0, 5) aac.Parent = antiAFKBtn

local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(0.5, -5, 0, 28)
hopBtn.Position = UDim2.new(0.5, 0, 0, 24)
hopBtn.Text = "🌐 Server Hop"
hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 11
hopBtn.Parent = toolsSec
regButtons(hopBtn)

local hbc = Instance.new("UICorner") hbc.CornerRadius = UDim.new(0, 5) hbc.Parent = hopBtn

-- زر Auto-Resume
local autoResumeBtn = Instance.new("TextButton")
autoResumeBtn.Size = UDim2.new(1, -10, 0, 28)
autoResumeBtn.Position = UDim2.new(0, 5, 0, 56)
autoResumeBtn.Text = "🔁 إعادة تشغيل تلقائية: " .. (Settings.autoResume and "ON" or "OFF")
autoResumeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoResumeBtn.Font = Enum.Font.GothamBold
autoResumeBtn.TextSize = 11
autoResumeBtn.BackgroundColor3 = Settings.autoResume and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
autoResumeBtn.Parent = toolsSec

local arc = Instance.new("UICorner") arc.CornerRadius = UDim.new(0, 5) arc.CornerRadius = UDim.new(0, 5) arc.Parent = autoResumeBtn

-------------------------------------------------
-- 🎮 ربط الأزرار
-------------------------------------------------
toggleBtn.MouseButton1Click:Connect(function()
    Settings.running = not Settings.running
    toggleBtn.Text = Settings.running and "▶ ON" or "⏸ OFF"
    toggleBtn.BackgroundColor3 = Settings.running 
        and Color3.fromRGB(0, 150, 0) 
        or Color3.fromRGB(100, 0, 0)
    statusLabel.Text = Settings.running and "الحالة: يعمل..." or "الحالة: متوقف ⏸️"
end)

adminBtn.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        adminBtn.Text = "✅ Loaded"
        adminBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(2)
        adminBtn.Text = "⚡ Admin"
        adminBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    end)
end)

local function updateSpeed(val)
    Settings.delayBetween = math.clamp(val, 0.1, 5.0)
    speedInput.Text = string.format("%.2f", Settings.delayBetween)
    saveSettings()
end

minusBtn.MouseButton1Click:Connect(function() updateSpeed(Settings.delayBetween - 0.05) end)
plusBtn.MouseButton1Click:Connect(function() updateSpeed(Settings.delayBetween + 0.05) end)

speedInput.FocusLost:Connect(function()
    local num = tonumber(speedInput.Text)
    if num then updateSpeed(num)
    else speedInput.Text = string.format("%.2f", Settings.delayBetween) end
end)

distInput.FocusLost:Connect(function()
    local num = tonumber(distInput.Text)
    if num and num > 0 then
        Settings.maxDistance = math.floor(num)
        distInput.Text = tostring(Settings.maxDistance)
        saveSettings()
    else
        distInput.Text = tostring(Settings.maxDistance)
    end
end)

themeBtn.MouseButton1Click:Connect(function()
    local idx = 1
    for i, n in ipairs(themeOrder) do
        if n == currentThemeName then idx = i break end
    end
    idx = idx % #themeOrder + 1
    local newTheme = themeOrder[idx]
    applyTheme(newTheme)
    themeBtn.Text = "🎨 الحالي: " .. newTheme
    scroll.ScrollBarImageColor3 = THEMES[newTheme].stroke
end)

antiAFKBtn.MouseButton1Click:Connect(function()
    Settings.antiAFK = not Settings.antiAFK
    antiAFKBtn.Text = "🛡️ Anti-AFK: " .. (Settings.antiAFK and "ON" or "OFF")
    antiAFKBtn.BackgroundColor3 = Settings.antiAFK 
        and Color3.fromRGB(0, 150, 0) 
        or Color3.fromRGB(150, 0, 0)
    if Settings.antiAFK then enableAntiAFK() else disableAntiAFK() end
    saveSettings()
end)

autoResumeBtn.MouseButton1Click:Connect(function()
    Settings.autoResume = not Settings.autoResume
    autoResumeBtn.Text = "🔁 إعادة تشغيل تلقائية: " .. (Settings.autoResume and "ON" or "OFF")
    autoResumeBtn.BackgroundColor3 = Settings.autoResume 
        and Color3.fromRGB(0, 150, 0) 
        or Color3.fromRGB(150, 0, 0)
    saveSettings()
    if Settings.autoResume then
        statusLabel.Text = "✅ سيعمل تلقائيًا عند الدخول التالي"
    end
end)

hopBtn.MouseButton1Click:Connect(function()
    hopBtn.Text = "🌐 جاري البحث..."
    hopBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    
    task.spawn(function()
        local ok, result = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if not ok or not result or not result.data then
            hopBtn.Text = "❌ فشل"
            task.wait(2)
            hopBtn.Text = "🌐 Server Hop"
            hopBtn.BackgroundColor3 = THEMES[currentThemeName].btn
            return
        end
        
        local servers = {}
        for _, s in ipairs(result.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                table.insert(servers, s.id)
            end
        end
        
        if #servers == 0 then
            hopBtn.Text = "❌ لا يوجد"
            task.wait(2)
            hopBtn.Text = "🌐 Server Hop"
            hopBtn.BackgroundColor3 = THEMES[currentThemeName].btn
            return
        end
        
        local chosen = servers[math.random(1, #servers)]
        hopBtn.Text = "🌐 الانتقال..."
        
        -- Queue script for auto-run after teleport
        if SCRIPT_URL ~= "" and type(queue_on_teleport) == "function" then
            pcall(function()
                queue_on_teleport([[
                    loadstring(game:HttpGet("]] .. SCRIPT_URL .. [["))()
                ]])
            end)
        end
        
        task.wait(0.5)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen, player)
    end)
end)

-- زر التصغير
local floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0, 55, 0, 55)
floatingBtn.Position = UDim2.new(0, 20, 0.5, -27)
floatingBtn.BackgroundColor3 = Color3.fromRGB(120, 15, 15)
floatingBtn.Text = "🧹"
floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.Font = Enum.Font.GothamBold
floatingBtn.TextSize = 26
floatingBtn.Visible = false
floatingBtn.Draggable = true
floatingBtn.Parent = screenGui

local fbc = Instance.new("UICorner") fbc.CornerRadius = UDim.new(1, 0) fbc.Parent = floatingBtn

local fbs = Instance.new("UIStroke")
fbs.Color = Color3.fromRGB(180, 25, 25)
fbs.Thickness = 2
fbs.Parent = floatingBtn

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingBtn.Visible = true
end)

floatingBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingBtn.Visible = false
end)

-------------------------------------------------
-- 🔍 دوال التحقق (كما هي)
-------------------------------------------------
local BLACKLIST = {
    "truck", "vehicle", "car", "bin", "dumpster", "شاحنة", "سيارة", "حاوية", "مكب",
    "player", "character", "humanoid", "vip", "accessory", "hat", "shirt", "pants", "body",
    "tree", "leaf", "leaves", "bush", "plant", "flower", "grass", "rock", "stone", "wood",
    "log", "branch", "root", "شجرة", "أوراق", "ورق", "نبتة", "زهرة", "عشب", "صخرة", "حجر", "خشب", "جذع", "فرع"
}

local WHITELIST = {
    "trash", "garbage", "waste", "litter", "rubbish",
    "زبال", "زباله", "زبالة", "قمامة", "نفايات", "أزبال", "ازبال",
    "trashbag", "garbagebag", "trashpile", "garbagepile"
}

local function isPlayerRelated(obj)
    if not obj then return false end
    if obj:IsA("Humanoid") then return true end
    local current = obj
    local depth = 0
    while current and depth < 8 do
        if current == workspace or current == game then break end
        if current:IsA("Humanoid") then return true end
        if current:IsA("Model") and Players:GetPlayerFromCharacter(current) then return true end
        current = current.Parent
        depth = depth + 1
    end
    return false
end

local function isRealGarbage(obj)
    if not obj or not obj.Parent then return false end
    if isPlayerRelated(obj) then return false end
    local name = string.lower(obj.Name)
    for _, bad in ipairs(BLACKLIST) do
        if string.find(name, string.lower(bad), 1, true) then return false end
    end
    for _, good in ipairs(WHITELIST) do
        if string.find(name, string.lower(good), 1, true) then return true end
    end
    if obj:IsA("BasePart") then
        if obj:FindFirstChildOfClass("Highlight") or obj:FindFirstChildOfClass("SelectionBox") then return true end
    end
    if obj:IsA("Model") then
        if obj:FindFirstChildOfClass("Humanoid") then return false end
        if obj:FindFirstChildOfClass("Highlight", true) then return true end
    end
    return false
end

local function getPosition(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj.Position
    elseif obj:IsA("Model") then
        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if part then return part.Position end
    end
    return nil
end

local function findGarbages()
    local list = {}
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return list end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isRealGarbage(obj) then
            local pos = getPosition(obj)
            if pos then
                local dist = (pos - hrp.Position).Magnitude
                if dist <= Settings.maxDistance then
                    table.insert(list, { obj = obj, pos = pos, dist = dist })
                end
            end
        end
    end
    return list
end

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart", 10)
end

local function isNearPlayer(pos, threshold)
    threshold = threshold or 3
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local plrHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            if plrHRP and (plrHRP.Position - pos).Magnitude < threshold then return true end
        end
    end
    return false
end

-------------------------------------------------
-- 🚀 تطبيق الثيم + Auto-Resume
-------------------------------------------------
applyTheme(currentThemeName)
themeBtn.Text = "🎨 الحالي: " .. currentThemeName

-- إذا Auto-Resume مفعّل → ابدأ تلقائيًا
if Settings.autoResume then
    Settings.running = true
    toggleBtn.Text = "▶ ON"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    statusLabel.Text = "الحالة: تشغيل تلقائي ✅"
end

-------------------------------------------------
-- 🔄 الحلقة الرئيسية
-------------------------------------------------
task.spawn(function()
    print("[AutoCollector v9] بدأ - Pro Edition")

    while true do
        if not Settings.running then
            statusLabel.Text = "الحالة: متوقف ⏸️"
            task.wait(0.3)
            continue
        end

        local hrp = getHRP()
        if not hrp then task.wait(0.5) continue end

        statusLabel.Text = "🔍 البحث..."
        local garbages = findGarbages()
        table.sort(garbages, function(a, b) return a.dist < b.dist end)

        local collected = 0
        local total = #garbages
        
        for _, g in ipairs(garbages) do
            if not Settings.running then break end
            hrp = getHRP()
            if not hrp then break end

            if g.obj and g.obj.Parent then
                local pos = getPosition(g.obj)
                if pos and not isNearPlayer(pos, 3) then
                    collected = collected + 1
                    statusLabel.Text = string.format("📍 %d/%d", collected, total)
                    
                    pcall(function()
                        hrp.CFrame = CFrame.new(pos + Vector3.new(0, Settings.heightOffset, 0))
                    end)
                    
                    task.wait(Settings.delayBetween)
                    
                    local elapsed = 0
                    while g.obj and g.obj.Parent and elapsed < Settings.timeoutCollect do
                        task.wait(0.1)
                        elapsed = elapsed + 0.1
                    end
                end
            end
        end

        statusLabel.Text = "الحالة: إعادة البحث..."
        task.wait(Settings.rescanDelay)
    end
end)
