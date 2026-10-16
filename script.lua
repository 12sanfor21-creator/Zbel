-- ============================================
--   Realistic Morocco
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local VirtualUser = game:GetService("VirtualUser")

-------------------------------------------------
-- ⚙️ الإعدادات
-------------------------------------------------
local Settings = {
    running = false,
    delayBetween = 3.00,
    heightOffset = 3,
    timeoutCollect = 1.5,
    rescanDelay = 0.8,
    maxDistance = 1500,
    antiAFK = true
}

local INSTAGRAM_URL = "https://www.instagram.com/bilal_____bh?obrf=MTltYjJuNHowN3Fxcg=="

-- 🚫 القائمة السوداء للزبالة
local BLACKLIST = {
    "truck", "vehicle", "car", "bin", "dumpster",
    "شاحنة", "سيارة", "حاوية", "مكب",
    "player", "character", "humanoid", "vip",
    "accessory", "hat", "shirt", "pants", "body",
    "tree", "leaf", "leaves", "bush", "plant", "flower", "grass",
    "rock", "stone", "wood", "log", "branch", "root",
    "شجرة", "أوراق", "ورق", "نبتة", "زهرة", "عشب",
    "صخرة", "حجر", "خشب", "جذع", "فرع"
}

-- ✅ القائمة البيضاء للزبالة
local WHITELIST = {
    "trash", "garbage", "waste", "litter", "rubbish",
    "زبال", "زباله", "زبالة", "قمامة", "نفايات", "أزبال", "ازبال",
    "trashbag", "garbagebag", "trashpile", "garbagepile"
}

-- 🎯 كلمات البحث عن NPC المهمة
local JOB_KEYWORDS = {
    "start", "job", "work", "clean", "cleaning", "begin",
    "مهمة", "عمل", "شغل", "ابدأ", "بدء", "نظافة"
}

-- 🚫 كلمات لاستبعادها
local JOB_EXCLUDE = {
    "stop", "end", "finish", "quit", "leave", "cancel", "sell", "buy"
}

-- 🧹 كلمات البحث عن الشطابة
local BROOM_KEYWORDS = {
    "broom", "mop", "brush", "cleaning", "sweep",
    "شطاب", "شطابة", "مكنسة", "فرشاة", "أداة"
}

-------------------------------------------------
-- 🎨 الثيمات
-------------------------------------------------
local THEMES = {
    {name = "Blood",   dark = Color3.fromRGB(40,5,5),    header = Color3.fromRGB(75,10,10),   btn = Color3.fromRGB(120,15,15),  stroke = Color3.fromRGB(180,25,25),  text = Color3.fromRGB(255,230,230)},
    {name = "Ocean",   dark = Color3.fromRGB(5,20,40),   header = Color3.fromRGB(10,40,75),   btn = Color3.fromRGB(15,70,120),  stroke = Color3.fromRGB(25,120,180), text = Color3.fromRGB(230,240,255)},
    {name = "Royal",   dark = Color3.fromRGB(20,10,45),  header = Color3.fromRGB(40,20,80),   btn = Color3.fromRGB(70,40,140),  stroke = Color3.fromRGB(130,80,220), text = Color3.fromRGB(240,230,255)},
    {name = "Emerald", dark = Color3.fromRGB(5,30,15),   header = Color3.fromRGB(10,60,30),   btn = Color3.fromRGB(15,100,50),  stroke = Color3.fromRGB(50,180,100), text = Color3.fromRGB(220,255,230)},
    {name = "Neon",    dark = Color3.fromRGB(30,5,45),   header = Color3.fromRGB(55,10,80),   btn = Color3.fromRGB(110,20,160), stroke = Color3.fromRGB(210,80,255), text = Color3.fromRGB(245,225,255)},
    {name = "Sunset",  dark = Color3.fromRGB(50,20,5),   header = Color3.fromRGB(90,40,10),   btn = Color3.fromRGB(180,80,20),  stroke = Color3.fromRGB(255,150,50), text = Color3.fromRGB(255,240,220)},
    {name = "Gold",    dark = Color3.fromRGB(40,30,5),   header = Color3.fromRGB(80,60,10),   btn = Color3.fromRGB(150,120,20), stroke = Color3.fromRGB(230,190,40), text = Color3.fromRGB(255,250,220)},
    {name = "Pink",    dark = Color3.fromRGB(45,10,30),  header = Color3.fromRGB(85,20,55),   btn = Color3.fromRGB(160,40,100), stroke = Color3.fromRGB(230,80,160), text = Color3.fromRGB(255,230,240)},
    {name = "Cyan",    dark = Color3.fromRGB(5,35,40),   header = Color3.fromRGB(10,70,80),   btn = Color3.fromRGB(20,130,145), stroke = Color3.fromRGB(60,210,230), text = Color3.fromRGB(225,255,255)},
    {name = "Carbon",  dark = Color3.fromRGB(15,15,20),  header = Color3.fromRGB(30,30,40),   btn = Color3.fromRGB(50,50,70),   stroke = Color3.fromRGB(100,100,120),text = Color3.fromRGB(230,230,240)},
    {name = "Forest",  dark = Color3.fromRGB(15,30,10),  header = Color3.fromRGB(30,60,20),   btn = Color3.fromRGB(50,100,30),  stroke = Color3.fromRGB(100,180,60), text = Color3.fromRGB(235,255,225)},
    {name = "Ice",     dark = Color3.fromRGB(30,35,45),  header = Color3.fromRGB(60,70,90),   btn = Color3.fromRGB(90,110,140), stroke = Color3.fromRGB(160,190,230),text = Color3.fromRGB(240,245,255)}
}

local currentThemeIndex = 1

-------------------------------------------------
-- 🖥️ الواجهة الرئيسية
-------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoCollectorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 310)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -155)
mainFrame.BackgroundColor3 = THEMES[1].dark
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = THEMES[1].stroke
stroke.Thickness = 2
stroke.Parent = mainFrame

-------------------------------------------------
-- 🔗 زر Instagram
-------------------------------------------------
local titleBtn = Instance.new("TextButton")
titleBtn.Size = UDim2.new(1, 0, 0, 36)
titleBtn.BackgroundColor3 = THEMES[1].header
titleBtn.Text = "📷 my instagram: bilal_____bh"
titleBtn.TextColor3 = THEMES[1].text
titleBtn.Font = Enum.Font.GothamBold
titleBtn.TextSize = 13
titleBtn.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBtn

titleBtn.MouseEnter:Connect(function()
    titleBtn.Text = "🔗 اضغط لفتح حسابي"
end)
titleBtn.MouseLeave:Connect(function()
    titleBtn.Text = "📷 my instagram: bilal_____bh"
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
    titleBtn.TextColor3 = THEMES[currentThemeIndex].text
end)

-------------------------------------------------
-- 🗕 زر التصغير
-------------------------------------------------
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -34, 0, 4)
minimizeBtn.BackgroundColor3 = THEMES[1].btn
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
-- ▶ صف 1: Pause + Admin
-------------------------------------------------
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.5, -15, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 46)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
toggleBtn.Text = "⏸ OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

local adminBtn = Instance.new("TextButton")
adminBtn.Size = UDim2.new(0.5, -15, 0, 30)
adminBtn.Position = UDim2.new(0.5, 5, 0, 46)
adminBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
adminBtn.Text = "⚡ Admin"
adminBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
adminBtn.Font = Enum.Font.GothamBold
adminBtn.TextSize = 12
adminBtn.Parent = mainFrame

local adminCorner = Instance.new("UICorner")
adminCorner.CornerRadius = UDim.new(0, 6)
adminCorner.Parent = adminBtn

-------------------------------------------------
-- 🎨 صف 2: Color + Anti-AFK
-------------------------------------------------
local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(0.5, -15, 0, 30)
colorBtn.Position = UDim2.new(0, 10, 0, 82)
colorBtn.BackgroundColor3 = THEMES[1].btn
colorBtn.Text = "🎨 Color"
colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorBtn.Font = Enum.Font.GothamBold
colorBtn.TextSize = 12
colorBtn.Parent = mainFrame

local colorCorner = Instance.new("UICorner")
colorCorner.CornerRadius = UDim.new(0, 6)
colorCorner.Parent = colorBtn

local antiAFKBtn = Instance.new("TextButton")
antiAFKBtn.Size = UDim2.new(0.5, -15, 0, 30)
antiAFKBtn.Position = UDim2.new(0.5, 5, 0, 82)
antiAFKBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
antiAFKBtn.Text = "🛡️ Anti-AFK: ON"
antiAFKBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiAFKBtn.Font = Enum.Font.GothamBold
antiAFKBtn.TextSize = 11
antiAFKBtn.Parent = mainFrame

local aafkCorner = Instance.new("UICorner")
aafkCorner.CornerRadius = UDim.new(0, 6)
aafkCorner.Parent = antiAFKBtn

-------------------------------------------------
-- 🎯 زر أخذ المهمة
-------------------------------------------------
local takeJobBtn = Instance.new("TextButton")
takeJobBtn.Size = UDim2.new(1, -20, 0, 34)
takeJobBtn.Position = UDim2.new(0, 10, 0, 118)
takeJobBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
takeJobBtn.Text = "🎯 أخذ المهمة + 🧹 الشطابة"
takeJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
takeJobBtn.Font = Enum.Font.GothamBold
takeJobBtn.TextSize = 12
takeJobBtn.Parent = mainFrame

local tjc = Instance.new("UICorner")
tjc.CornerRadius = UDim.new(0, 6)
tjc.Parent = takeJobBtn

-------------------------------------------------
-- ⏱️ السرعة
-------------------------------------------------
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 18)
speedLabel.Position = UDim2.new(0, 10, 0, 158)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⏱️ وقت الانتقال:"
speedLabel.TextColor3 = THEMES[1].text
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 32, 0, 30)
minusBtn.Position = UDim2.new(0, 10, 0, 178)
minusBtn.BackgroundColor3 = THEMES[1].btn
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.Parent = mainFrame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 6)
minusCorner.Parent = minusBtn

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 100, 0, 30)
speedInput.Position = UDim2.new(0.5, -50, 0, 178)
speedInput.BackgroundColor3 = THEMES[1].header
speedInput.Text = string.format("%.2f", Settings.delayBetween)
speedInput.TextColor3 = THEMES[1].text
speedInput.Font = Enum.Font.GothamBold
speedInput.TextSize = 14
speedInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = speedInput

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 32, 0, 30)
plusBtn.Position = UDim2.new(1, -42, 0, 178)
plusBtn.BackgroundColor3 = THEMES[1].btn
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.Parent = mainFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 6)
plusCorner.Parent = plusBtn

-------------------------------------------------
-- 📏 المسافة
-------------------------------------------------
local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(1, -20, 0, 18)
distLabel.Position = UDim2.new(0, 10, 0, 218)
distLabel.BackgroundTransparency = 1
distLabel.Text = "📏 أقصى مسافة:"
distLabel.TextColor3 = THEMES[1].text
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 11
distLabel.TextXAlignment = Enum.TextXAlignment.Left
distLabel.Parent = mainFrame

local distInput = Instance.new("TextBox")
distInput.Size = UDim2.new(1, -20, 0, 28)
distInput.Position = UDim2.new(0, 10, 0, 238)
distInput.BackgroundColor3 = THEMES[1].header
distInput.Text = "1500"
distInput.TextColor3 = THEMES[1].text
distInput.Font = Enum.Font.GothamBold
distInput.TextSize = 13
distInput.Parent = mainFrame

local distCorner = Instance.new("UICorner")
distCorner.CornerRadius = UDim.new(0, 6)
distCorner.Parent = distInput

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 18)
statusLabel.Position = UDim2.new(0, 10, 1, -22)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "الحالة: متوقف ⏸️"
statusLabel.TextColor3 = THEMES[1].text
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-------------------------------------------------
-- 🎨 نافذة منتقي الألوان
-------------------------------------------------
local colorPickerFrame = Instance.new("Frame")
colorPickerFrame.Size = UDim2.new(0, 260, 0, 200)
colorPickerFrame.Position = UDim2.new(0.5, -130, 0.5, -100)
colorPickerFrame.BackgroundColor3 = THEMES[1].dark
colorPickerFrame.BorderSizePixel = 0
colorPickerFrame.Visible = false
colorPickerFrame.Active = true
colorPickerFrame.Draggable = true
colorPickerFrame.ZIndex = 100
colorPickerFrame.Parent = screenGui

local cpCorner = Instance.new("UICorner")
cpCorner.CornerRadius = UDim.new(0, 10)
cpCorner.Parent = colorPickerFrame

local cpStroke = Instance.new("UIStroke")
cpStroke.Color = THEMES[1].stroke
cpStroke.Thickness = 2
cpStroke.Parent = colorPickerFrame

local cpTitle = Instance.new("TextLabel")
cpTitle.Size = UDim2.new(1, 0, 0, 30)
cpTitle.BackgroundColor3 = THEMES[1].header
cpTitle.Text = "🎨 اختر لون الواجهة"
cpTitle.TextColor3 = THEMES[1].text
cpTitle.Font = Enum.Font.GothamBold
cpTitle.TextSize = 13
cpTitle.ZIndex = 101
cpTitle.Parent = colorPickerFrame

local cpTitleCorner = Instance.new("UICorner")
cpTitleCorner.CornerRadius = UDim.new(0, 10)
cpTitleCorner.Parent = cpTitle

local cpCloseBtn = Instance.new("TextButton")
cpCloseBtn.Size = UDim2.new(0, 26, 0, 26)
cpCloseBtn.Position = UDim2.new(1, -30, 0, 2)
cpCloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
cpCloseBtn.Text = "X"
cpCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
cpCloseBtn.Font = Enum.Font.GothamBold
cpCloseBtn.TextSize = 13
cpCloseBtn.ZIndex = 102
cpCloseBtn.Parent = colorPickerFrame

local cpCloseCorner = Instance.new("UICorner")
cpCloseCorner.CornerRadius = UDim.new(0, 6)
cpCloseCorner.Parent = cpCloseBtn

local colorGrid = Instance.new("Frame")
colorGrid.Size = UDim2.new(1, -20, 1, -45)
colorGrid.Position = UDim2.new(0, 10, 0, 38)
colorGrid.BackgroundTransparency = 1
colorGrid.ZIndex = 101
colorGrid.Parent = colorPickerFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 50, 0, 50)
gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = colorGrid

for i, theme in ipairs(THEMES) do
    local swatch = Instance.new("TextButton")
    swatch.Size = UDim2.new(0, 50, 0, 50)
    swatch.BackgroundColor3 = theme.stroke
    swatch.Text = ""
    swatch.ZIndex = 102
    swatch.LayoutOrder = i
    swatch.Parent = colorGrid
    
    local swatchCorner = Instance.new("UICorner")
    swatchCorner.CornerRadius = UDim.new(1, 0)
    swatchCorner.Parent = swatch
    
    local swatchStroke = Instance.new("UIStroke")
    swatchStroke.Color = Color3.fromRGB(255, 255, 255)
    swatchStroke.Thickness = 2
    swatchStroke.Parent = swatch
    
    swatch.MouseEnter:Connect(function()
        swatch.Size = UDim2.new(0, 55, 0, 55)
    end)
    swatch.MouseLeave:Connect(function()
        swatch.Size = UDim2.new(0, 50, 0, 50)
    end)
    
    swatch.MouseButton1Click:Connect(function()
        currentThemeIndex = i
        local t = THEMES[i]
        
        mainFrame.BackgroundColor3 = t.dark
        titleBtn.BackgroundColor3 = t.header
        titleBtn.TextColor3 = t.text
        stroke.Color = t.stroke
        minimizeBtn.BackgroundColor3 = t.btn
        colorBtn.BackgroundColor3 = t.btn
        minusBtn.BackgroundColor3 = t.btn
        plusBtn.BackgroundColor3 = t.btn
        speedInput.BackgroundColor3 = t.header
        speedInput.TextColor3 = t.text
        distInput.BackgroundColor3 = t.header
        distInput.TextColor3 = t.text
        speedLabel.TextColor3 = t.text
        distLabel.TextColor3 = t.text
        statusLabel.TextColor3 = t.text
        
        colorPickerFrame.BackgroundColor3 = t.dark
        cpTitle.BackgroundColor3 = t.header
        cpTitle.TextColor3 = t.text
        cpStroke.Color = t.stroke
        
        floatingBtn.BackgroundColor3 = t.btn
        fbStroke.Color = t.stroke
        
        statusLabel.Text = "🎨 اللون: " .. t.name
    end)
end

-------------------------------------------------
-- 🗕 الأيقونة العائمة
-------------------------------------------------
local floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0, 55, 0, 55)
floatingBtn.Position = UDim2.new(0, 20, 0.5, -27)
floatingBtn.BackgroundColor3 = THEMES[1].btn
floatingBtn.Text = "🧹"
floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingBtn.Font = Enum.Font.GothamBold
floatingBtn.TextSize = 26
floatingBtn.Visible = false
floatingBtn.Draggable = true
floatingBtn.Parent = screenGui

local fbc = Instance.new("UICorner")
fbc.CornerRadius = UDim.new(1, 0)
fbc.Parent = floatingBtn

local fbStroke = Instance.new("UIStroke")
fbStroke.Color = THEMES[1].stroke
fbStroke.Thickness = 2
fbStroke.Parent = floatingBtn

-------------------------------------------------
-- 🛡️ Anti-AFK
-------------------------------------------------
local antiAFKConnection = nil

local function enableAntiAFK()
    if antiAFKConnection then return end
    antiAFKConnection = player.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

local function disableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

if Settings.antiAFK then enableAntiAFK() end

-------------------------------------------------
-- 🧹 دالة تجهيز الشطابة
-------------------------------------------------
local function equipBroom()
    local char = player.Character
    if not char then return false end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    -- إذا كانت في اليد بالفعل
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local name = string.lower(tool.Name)
            for _, kw in ipairs(BROOM_KEYWORDS) do
                if string.find(name, string.lower(kw), 1, true) then
                    return true
                end
            end
        end
    end
    
    -- البحث في الحقيبة
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return false end
    
    local found = nil
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = string.lower(tool.Name)
            for _, kw in ipairs(BROOM_KEYWORDS) do
                if string.find(name, string.lower(kw), 1, true) then
                    found = tool
                    break
                end
            end
            if found then break end
        end
    end
    
    -- تفعيل
    if found then
        pcall(function()
            humanoid:EquipTool(found)
        end)
        return true
    end
    
    return false
end

-------------------------------------------------
-- 🎯 دالة أخذ المهمة
-------------------------------------------------
local function getPromptNames(prompt)
    local names = {}
    table.insert(names, string.lower(prompt.Name or ""))
    if prompt.Parent then
        table.insert(names, string.lower(prompt.Parent.Name or ""))
    end
    table.insert(names, string.lower(prompt.ActionText or ""))
    table.insert(names, string.lower(prompt.ObjectText or ""))
    return names
end

local function takeJob()
    statusLabel.Text = "🔍 البحث عن NPC المهمة..."
    
    local found = nil
    local foundScore = 0
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local names = getPromptNames(obj)
            
            -- استبعاد
            local excluded = false
            for _, n in ipairs(names) do
                for _, ex in ipairs(JOB_EXCLUDE) do
                    if string.find(n, ex, 1, true) then
                        excluded = true
                        break
                    end
                end
                if excluded then break end
            end
            if excluded then continue end
            
            -- حساب النقاط
            local score = 0
            for _, n in ipairs(names) do
                for _, kw in ipairs(JOB_KEYWORDS) do
                    if string.find(n, kw, 1, true) then
                        score = score + 10
                    end
                end
                if string.find(n, "start", 1, true) then
                    score = score + 20
                end
            end
            
            if score > foundScore then
                found = obj
                foundScore = score
            end
        end
    end
    
    if not found then
        statusLabel.Text = "❌ لم أجد NPC المهمة"
        takeJobBtn.Text = "❌ لم يجد"
        takeJobBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        task.wait(2)
        takeJobBtn.Text = "🎯 أخذ المهمة + 🧹 الشطابة"
        takeJobBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        return
    end
    
    -- النقل للـ NPC
    local part = found.Parent
    if part and part:IsA("BasePart") and hrp then
        pcall(function()
            hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
        end)
        task.wait(0.3)
    elseif part and part:IsA("Model") then
        local primary = part.PrimaryPart or part:FindFirstChildWhichIsA("BasePart")
        if primary and hrp then
            pcall(function()
                hrp.CFrame = CFrame.new(primary.Position + Vector3.new(0, 3, 0))
            end)
            task.wait(0.3)
        end
    elseif part and part:IsA("Attachment") and hrp then
        pcall(function()
            hrp.CFrame = CFrame.new(part.WorldPosition + Vector3.new(0, 3, 0))
        end)
        task.wait(0.3)
    end
    
    -- تفعيل البرومبت
    pcall(function()
        found.RequiresLineOfSight = false
        found:InputHoldBegin()
        task.wait(found.HoldDuration or 0)
        found:InputHoldEnd()
    end)
    
    statusLabel.Text = "✅ تم أخذ المهمة!"
    
    -- تجهيز الشطابة
    task.wait(0.5)
    local broomOK = equipBroom()
    if broomOK then
        statusLabel.Text = "✅ تم أخذ المهمة + 🧹 الشطابة"
    else
        statusLabel.Text = "✅ تم أخذ المهمة (⚠️ لم أجد الشطابة)"
    end
    
    takeJobBtn.Text = "✅ تم!"
    takeJobBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    task.wait(2)
    takeJobBtn.Text = "🎯 أخذ المهمة + 🧹 الشطابة"
    takeJobBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
end

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

takeJobBtn.MouseButton1Click:Connect(function()
    takeJobBtn.Text = "⏳ جاري..."
    takeJobBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 0)
    task.spawn(takeJob)
end)

colorBtn.MouseButton1Click:Connect(function()
    colorPickerFrame.Visible = not colorPickerFrame.Visible
end)

cpCloseBtn.MouseButton1Click:Connect(function()
    colorPickerFrame.Visible = false
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

antiAFKBtn.MouseButton1Click:Connect(function()
    Settings.antiAFK = not Settings.antiAFK
    if Settings.antiAFK then
        enableAntiAFK()
        antiAFKBtn.Text = "🛡️ Anti-AFK: ON"
        antiAFKBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        disableAntiAFK()
        antiAFKBtn.Text = "🛡️ Anti-AFK: OFF"
        antiAFKBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    end
end)

local function updateSpeed(val)
    Settings.delayBetween = math.clamp(val, 0.1, 10.0)
    speedInput.Text = string.format("%.2f", Settings.delayBetween)
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
    else
        distInput.Text = tostring(Settings.maxDistance)
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    colorPickerFrame.Visible = false
    floatingBtn.Visible = true
end)

floatingBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingBtn.Visible = false
end)

-------------------------------------------------
-- 🔍 دوال التحقق من الزبالة
-------------------------------------------------
local function isPlayerRelated(obj)
    if not obj then return false end
    if obj:IsA("Humanoid") then return true end
    local current = obj
    local depth = 0
    while current and depth < 8 do
        if current == workspace or current == game then break end
        if current:IsA("Humanoid") then return true end
        if current:IsA("Model") and Players:GetPlayerFromCharacter(current) then
            return true
        end
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
        if string.find(name, string.lower(bad), 1, true) then 
            return false 
        end
    end
    
    for _, good in ipairs(WHITELIST) do
        if string.find(name, string.lower(good), 1, true) then 
            return true 
        end
    end
    
    if obj:IsA("BasePart") then
        if obj:FindFirstChildOfClass("Highlight") or obj:FindFirstChildOfClass("SelectionBox") then 
            return true 
        end
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
            if plrHRP and (plrHRP.Position - pos).Magnitude < threshold then
                return true
            end
        end
    end
    return false
end

-------------------------------------------------
-- 🔄 الحلقة الرئيسية
-------------------------------------------------
task.spawn(function()
    print("[AutoCollector v13] بدأ")

    while true do
        if not Settings.running then
            statusLabel.Text = "الحالة: متوقف ⏸️"
            task.wait(0.3)
            continue
        end

        local hrp = getHRP()
        if not hrp then 
            task.wait(0.5)
            continue 
        end

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
