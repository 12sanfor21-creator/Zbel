-- ============================================
--    MOrocco New Life 
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
    clicksPerStep = 1,       -- 🔥 نقرة واحدة لكل خطوة
    clickDelay = 0.4,
    teleportOffset = 2,      -- 🔥 تقليل الارتفاع (كان 4)
    settleTime = 0.3,        -- 🔥 وقت الاستقرار بعد النقل
    antiAFK = true
}

local INSTAGRAM_URL = "https://www.instagram.com/bilal_____bh?obrf=MTltYjJuNHowN3Fxcg=="

-------------------------------------------------
-- 🔓 إصلاح LineOfSight
-------------------------------------------------
local function fixPrompt(prompt)
    pcall(function()
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = 100
        prompt.HoldDuration = 0
    end)
end

for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
        fixPrompt(obj)
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        task.wait(0.05)
        fixPrompt(obj)
    end
end)

-- 🔥 حلقة خلفية
task.spawn(function()
    while true do
        task.wait(0.2)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                if obj.RequiresLineOfSight then
                    pcall(function() obj.RequiresLineOfSight = false end)
                end
                if obj.MaxActivationDistance < 50 then
                    pcall(function() obj.MaxActivationDistance = 100 end)
                end
            end
        end
    end
end)

-------------------------------------------------
-- 🔍 خطوات المهمة
-------------------------------------------------
local STATIONS = {
    { type = "ingredient", name = "🧀 Grab Pizza",     keywords = {"grab pizza", "garb pizza", "ingredient", "مكون"} },
    { type = "box",        name = "📦 Take A Box",     keywords = {"take a box", "take box", "takeabox", "box"} },
    { type = "pizza",      name = "🍕 Box Pizza",      keywords = {"box pizza", "pizza & deliver", "& deliver", "بيتزا"} },
    { type = "sell",       name = "💰 Sell Pizza",     keywords = {"sell pizza", "sell", "بيع", "بيع بيتزا", "deliver pizza", "cash"} }
}

-------------------------------------------------
-- 📊 الحالة
-------------------------------------------------
local currentStation = 1
local cycleCount = 0

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
-- 🖥️ الواجهة
-------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PizzaFarmer"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 320)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
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

local titleBtn = Instance.new("TextButton")
titleBtn.Size = UDim2.new(1, 0, 0, 36)
titleBtn.BackgroundColor3 = THEMES[1].header
titleBtn.Text = "🍕 Pizza Farmer | 📷 bilal_____bh"
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
    titleBtn.Text = "🍕 Pizza Farmer | 📷 bilal_____bh"
end)
titleBtn.MouseButton1Click:Connect(function()
    if setclipboard then pcall(function() setclipboard(INSTAGRAM_URL) end) end
    pcall(function()
        game:GetService("GuiService"):OpenBrowserWindow(INSTAGRAM_URL)
    end)
    titleBtn.Text = "✅ تم نسخ الرابط!"
    titleBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(2)
    titleBtn.Text = "🍕 Pizza Farmer | 📷 bilal_____bh"
    titleBtn.TextColor3 = THEMES[currentThemeIndex].text
end)

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

local clickLabel = Instance.new("TextLabel")
clickLabel.Size = UDim2.new(1, -20, 0, 18)
clickLabel.Position = UDim2.new(0, 10, 0, 122)
clickLabel.BackgroundTransparency = 1
clickLabel.Text = "🔥 نقرات لكل خطوة:"
clickLabel.TextColor3 = THEMES[1].text
clickLabel.Font = Enum.Font.Gotham
clickLabel.TextSize = 11
clickLabel.TextXAlignment = Enum.TextXAlignment.Left
clickLabel.Parent = mainFrame

local clickMinus = Instance.new("TextButton")
clickMinus.Size = UDim2.new(0, 32, 0, 30)
clickMinus.Position = UDim2.new(0, 10, 0, 142)
clickMinus.BackgroundColor3 = THEMES[1].btn
clickMinus.Text = "-"
clickMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
clickMinus.Font = Enum.Font.GothamBold
clickMinus.TextSize = 18
clickMinus.Parent = mainFrame

local cmCorner = Instance.new("UICorner")
cmCorner.CornerRadius = UDim.new(0, 6)
cmCorner.Parent = clickMinus

local clickInput = Instance.new("TextBox")
clickInput.Size = UDim2.new(0, 100, 0, 30)
clickInput.Position = UDim2.new(0.5, -50, 0, 142)
clickInput.BackgroundColor3 = THEMES[1].header
clickInput.Text = tostring(Settings.clicksPerStep)
clickInput.TextColor3 = THEMES[1].text
clickInput.Font = Enum.Font.GothamBold
clickInput.TextSize = 14
clickInput.Parent = mainFrame

local ciCorner = Instance.new("UICorner")
ciCorner.CornerRadius = UDim.new(0, 6)
ciCorner.Parent = clickInput

local clickPlus = Instance.new("TextButton")
clickPlus.Size = UDim2.new(0, 32, 0, 30)
clickPlus.Position = UDim2.new(1, -42, 0, 142)
clickPlus.BackgroundColor3 = THEMES[1].btn
clickPlus.Text = "+"
clickPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
clickPlus.Font = Enum.Font.GothamBold
clickPlus.TextSize = 18
clickPlus.Parent = mainFrame

local cpCorner = Instance.new("UICorner")
cpCorner.CornerRadius = UDim.new(0, 6)
cpCorner.Parent = clickPlus

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1, -20, 0, 30)
resetBtn.Position = UDim2.new(0, 10, 0, 182)
resetBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 0)
resetBtn.Text = "🔄 إعادة تعيين"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 12
resetBtn.Parent = mainFrame

local rCorner = Instance.new("UICorner")
rCorner.CornerRadius = UDim.new(0, 6)
rCorner.Parent = resetBtn

local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(1, -20, 0, 28)
counterLabel.Position = UDim2.new(0, 10, 0, 222)
counterLabel.BackgroundColor3 = THEMES[1].header
counterLabel.Text = "🔄 الدورات المكتملة: 0"
counterLabel.TextColor3 = THEMES[1].text
counterLabel.Font = Enum.Font.GothamBold
counterLabel.TextSize = 11
counterLabel.Parent = mainFrame

local cntCorner = Instance.new("UICorner")
cntCorner.CornerRadius = UDim.new(0, 6)
cntCorner.Parent = counterLabel

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 55)
statusLabel.Position = UDim2.new(0, 10, 0, 255)
statusLabel.BackgroundColor3 = THEMES[1].header
statusLabel.Text = "الحالة: جاهز ⏸️"
statusLabel.TextColor3 = THEMES[1].text
statusLabel.Font = Enum.Font.Code
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Top
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 6)
sCorner.Parent = statusLabel

-------------------------------------------------
-- 🎨 منتقي الألوان
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

local function applyTheme(idx)
    currentThemeIndex = idx
    local t = THEMES[idx]
    
    mainFrame.BackgroundColor3 = t.dark
    titleBtn.BackgroundColor3 = t.header
    titleBtn.TextColor3 = t.text
    stroke.Color = t.stroke
    minimizeBtn.BackgroundColor3 = t.btn
    colorBtn.BackgroundColor3 = t.btn
    clickMinus.BackgroundColor3 = t.btn
    clickPlus.BackgroundColor3 = t.btn
    clickInput.BackgroundColor3 = t.header
    clickInput.TextColor3 = t.text
    clickLabel.TextColor3 = t.text
    counterLabel.BackgroundColor3 = t.header
    counterLabel.TextColor3 = t.text
    statusLabel.BackgroundColor3 = t.header
    statusLabel.TextColor3 = t.text
    
    colorPickerFrame.BackgroundColor3 = t.dark
    cpTitle.BackgroundColor3 = t.header
    cpTitle.TextColor3 = t.text
    cpStroke.Color = t.stroke
    
    floatingBtn.BackgroundColor3 = t.btn
    fbStroke.Color = t.stroke
end

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
    
    swatch.MouseButton1Click:Connect(function()
        applyTheme(i)
        statusLabel.Text = "🎨 اللون: " .. theme.name
    end)
end

-------------------------------------------------
-- 🗕 الأيقونة العائمة
-------------------------------------------------
local floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0, 55, 0, 55)
floatingBtn.Position = UDim2.new(0, 20, 0.5, -27)
floatingBtn.BackgroundColor3 = THEMES[1].btn
floatingBtn.Text = "🍕"
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
-- 🔍 دوال البحث
-------------------------------------------------
local function getAllPrompts()
    local prompts = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            table.insert(prompts, obj)
        end
    end
    return prompts
end

local function findPromptByKeywords(keywords)
    local best, bestDist = nil, math.huge
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    for _, prompt in ipairs(getAllPrompts()) do
        local name = string.lower(prompt.Name)
        local parentName = string.lower(prompt.Parent and prompt.Parent.Name or "")
        local actionText = string.lower(prompt.ActionText or "")
        local objectText = string.lower(prompt.ObjectText or "")
        
        for _, kw in ipairs(keywords) do
            local kwLow = string.lower(kw)
            if string.find(name, kwLow, 1, true)
                or string.find(parentName, kwLow, 1, true)
                or string.find(actionText, kwLow, 1, true)
                or string.find(objectText, kwLow, 1, true) then
                
                local part = prompt.Parent
                if part and part:IsA("BasePart") and hrp then
                    local dist = (part.Position - hrp.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = prompt
                    end
                else
                    if not best then best = prompt end
                end
                break
            end
        end
    end
    return best
end

local function getPromptPosition(prompt)
    if not prompt then return nil end
    local parent = prompt.Parent
    if parent:IsA("BasePart") then return parent.Position end
    if parent:IsA("Model") then
        local pp = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
        if pp then return pp.Position end
    end
    if parent:IsA("Attachment") then return parent.WorldPosition end
    return nil
end

-------------------------------------------------
-- 🔥 نقل بسيط (بدون دوران + إيقاف سرعة)
-------------------------------------------------
local function teleportTo(pos)
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not pos then return false end
    
    pcall(function()
        -- موقع على الأرض + إيقاف السرعة حتى لا يسقط
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, Settings.teleportOffset, 0))
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    
    -- انتظار الاستقرار
    task.wait(Settings.settleTime)
    return true
end

-------------------------------------------------
-- 🔥 تفعيل البرومبت
-------------------------------------------------
local function triggerPrompt(prompt)
    if not prompt then return false end
    
    pcall(function()
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = math.huge
        prompt.HoldDuration = 0
    end)
    
    if fireproximityprompt then
        pcall(function()
            fireproximityprompt(prompt)
        end)
        task.wait(0.08)
        return true
    end
    
    pcall(function()
        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration or 0)
        prompt:InputHoldEnd()
    end)
    
    task.wait(0.08)
    return true
end

local function resetProgress()
    currentStation = 1
    statusLabel.Text = "🔄 إعادة تعيين..."
end

-------------------------------------------------
-- 🔄 الحلقة الرئيسية (نقرة واحدة لكل خطوة)
-------------------------------------------------
local function runLoop()
    while true do
        task.wait(0.2)
        
        if not Settings.running then
            statusLabel.Text = "الحالة: متوقف ⏸️"
            task.wait(0.5)
            continue
        end
        
        local station = STATIONS[currentStation]
        if not station then resetProgress() continue end
        
        statusLabel.Text = string.format(
            "🔄 دورة %d\n📍 %s (%d/4)",
            cycleCount, station.name, currentStation
        )
        
        -- 🔥 بحث + نقل + نقرات
        local prompt = findPromptByKeywords(station.keywords)
        
        if prompt then
            local pos = getPromptPosition(prompt)
            if pos then
                teleportTo(pos)
                
                -- 🔥 نقرات حسب الإعداد (افتراضي = 1)
                for click = 1, Settings.clicksPerStep do
                    if not Settings.running then break end
                    
                    statusLabel.Text = string.format(
                        "🔄 دورة %d\n📍 %s\nنقرة %d/%d",
                        cycleCount, station.name, click, Settings.clicksPerStep
                    )
                    
                    -- أعد البحث في كل نقرة
                    local cp = findPromptByKeywords(station.keywords)
                    if cp and cp.Enabled then
                        triggerPrompt(cp)
                    end
                    task.wait(Settings.clickDelay)
                end
                
                -- الخطوة التالية
                currentStation = currentStation + 1
                if currentStation > #STATIONS then
                    currentStation = 1
                    cycleCount = cycleCount + 1
                    counterLabel.Text = "🔄 الدورات المكتملة: " .. cycleCount
                    task.wait(0.5)
                end
            else
                task.wait(0.3)
            end
        else
            statusLabel.Text = string.format(
                "⚠️ لم يجد: %s",
                station.name
            )
            task.wait(0.6)
        end
    end
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

resetBtn.MouseButton1Click:Connect(resetProgress)

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

local function setClicks(n)
    Settings.clicksPerStep = math.clamp(n, 1, 5)
    clickInput.Text = tostring(Settings.clicksPerStep)
end

clickMinus.MouseButton1Click:Connect(function() setClicks(Settings.clicksPerStep - 1) end)
clickPlus.MouseButton1Click:Connect(function() setClicks(Settings.clicksPerStep + 1) end)

clickInput.FocusLost:Connect(function()
    local n = tonumber(clickInput.Text)
    if n then setClicks(math.floor(n)) 
    else clickInput.Text = tostring(Settings.clicksPerStep) end
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
-- 🚀 التشغيل
-------------------------------------------------
print("[PizzaFarmer v13] بدأ - Simple Clean")
task.spawn(runLoop)
