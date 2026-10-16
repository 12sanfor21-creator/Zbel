-- ============================================
--   Auto Garbage Collector v5
--   إصلاح آمن: كلمات سوداء + وضع صارم + مسافة
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- ⚙️ الإعدادات
-------------------------------------------------
local Settings = {
    running = true,
    delayBetween = 0.1,
    heightOffset = 3,
    timeoutCollect = 1.5,
    rescanDelay = 0.5,
    strictMode = false,        -- 🔥 وضع صارم (فقط الأسماء)
    maxDistance = 500          -- 🔥 أقصى مسافة (studs)
}

-- 🚫 القائمة السوداء (موسّعة)
local BLACKLIST = {
    "truck", "vehicle", "car", "bin", "dumpster",
    "شاحنة", "سيارة", "حاوية", "مكب",
    "player", "character", "humanoid", "vip",
    "accessory", "hat", "shirt", "pants", "body",
    -- 🔥 جديد - البيئة والطبيعة
    "tree", "leaf", "leaves", "bush", "plant", "flower", "grass",
    "rock", "stone", "wood", "log", "branch", "root",
    "شجرة", "أوراق", "ورق", "نبتة", "زهرة", "عشب",
    "صخرة", "حجر", "خشب", "جذع", "فرع"
}

-- ✅ القائمة البيضاء
local WHITELIST = {
    "trash", "garbage", "waste", "litter", "rubbish",
    "زبال", "زباله", "زبالة", "قمامة", "نفايات", "أزبال", "ازبال",
    "trashbag", "garbagebag", "trashpile", "garbagepile"    -- 🔥 أكثر تحديدًا
}

-------------------------------------------------
-- 🖥️ الواجهة
-------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoCollectorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 240)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 70)
stroke.Thickness = 2
stroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.Text = "🧹 Auto Collector v5"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.35, -8, 0, 28)
toggleBtn.Position = UDim2.new(0, 10, 0, 42)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleBtn.Text = "ON"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- 🔥 زر الوضع الصارم
local strictBtn = Instance.new("TextButton")
strictBtn.Size = UDim2.new(0.35, -8, 0, 28)
strictBtn.Position = UDim2.new(0.35, 0, 0, 42)
strictBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 20)
strictBtn.Text = "صارم: OFF"
strictBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
strictBtn.Font = Enum.Font.GothamBold
strictBtn.TextSize = 10
strictBtn.Parent = mainFrame

local strictCorner = Instance.new("UICorner")
strictCorner.CornerRadius = UDim.new(0, 6)
strictCorner.Parent = strictBtn

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0.3, -8, 0, 28)
hideBtn.Position = UDim2.new(0.7, 0, 0, 42)
hideBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
hideBtn.Text = "Hide"
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 11
hideBtn.Parent = mainFrame

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 6)
hideCorner.Parent = hideBtn

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 18)
speedLabel.Position = UDim2.new(0, 10, 0, 78)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⏱️ وقت الانتقال:"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 32, 0, 30)
minusBtn.Position = UDim2.new(0, 10, 0, 98)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
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
speedInput.Position = UDim2.new(0.5, -50, 0, 98)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
speedInput.Text = string.format("%.2f", Settings.delayBetween)
speedInput.TextColor3 = Color3.fromRGB(0, 255, 150)
speedInput.Font = Enum.Font.GothamBold
speedInput.TextSize = 14
speedInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = speedInput

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 32, 0, 30)
plusBtn.Position = UDim2.new(1, -42, 0, 98)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.Parent = mainFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 6)
plusCorner.Parent = plusBtn

-- 🔥 عنوان المسافة
local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(1, -20, 0, 18)
distLabel.Position = UDim2.new(0, 10, 0, 138)
distLabel.BackgroundTransparency = 1
distLabel.Text = "📏 أقصى مسافة (studs):"
distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 11
distLabel.TextXAlignment = Enum.TextXAlignment.Left
distLabel.Parent = mainFrame

local distInput = Instance.new("TextBox")
distInput.Size = UDim2.new(1, -20, 0, 28)
distInput.Position = UDim2.new(0, 10, 0, 158)
distInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
distInput.Text = tostring(Settings.maxDistance)
distInput.TextColor3 = Color3.fromRGB(255, 200, 100)
distInput.Font = Enum.Font.GothamBold
distInput.TextSize = 13
distInput.Parent = mainFrame

local distCorner = Instance.new("UICorner")
distCorner.CornerRadius = UDim.new(0, 6)
distCorner.Parent = distInput

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 1, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "الحالة: جاهز"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-------------------------------------------------
-- 🎮 ربط الأزرار
-------------------------------------------------
toggleBtn.MouseButton1Click:Connect(function()
    Settings.running = not Settings.running
    toggleBtn.Text = Settings.running and "ON" or "OFF"
    toggleBtn.BackgroundColor3 = Settings.running 
        and Color3.fromRGB(0, 170, 0) 
        or Color3.fromRGB(170, 0, 0)
end)

strictBtn.MouseButton1Click:Connect(function()
    Settings.strictMode = not Settings.strictMode
    strictBtn.Text = Settings.strictMode and "صارم: ON" or "صارم: OFF"
    strictBtn.BackgroundColor3 = Settings.strictMode 
        and Color3.fromRGB(0, 120, 180) 
        or Color3.fromRGB(100, 60, 20)
end)

local isHidden = false
hideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    for _, child in ipairs(mainFrame:GetChildren()) do
        if child ~= title and child ~= hideBtn then
            child.Visible = not isHidden
        end
    end
    mainFrame.Size = isHidden and UDim2.new(0, 200, 0, 35) or UDim2.new(0, 280, 0, 240)
    hideBtn.Text = isHidden and "Show" or "Hide"
    hideBtn.Position = isHidden and UDim2.new(0.5, -30, 0, 0) or UDim2.new(0.7, 0, 0, 42)
end)

local function updateSpeed(val)
    Settings.delayBetween = math.clamp(val, 0.05, 5.0)
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

-------------------------------------------------
-- 🔍 دوال التحقق
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
    
    -- 🚫 القائمة السوداء
    for _, bad in ipairs(BLACKLIST) do
        if string.find(name, string.lower(bad), 1, true) then 
            return false 
        end
    end
    
    -- ✅ القائمة البيضاء
    local hasWhitelistKeyword = false
    for _, good in ipairs(WHITELIST) do
        if string.find(name, string.lower(good), 1, true) then 
            hasWhitelistKeyword = true
            break
        end
    end
    
    -- 🔥 في الوضع الصارم: نقبل فقط ما فيه كلمة whitelist
    if Settings.strictMode then
        return hasWhitelistKeyword
    end
    
    -- الوضع العادي
    if hasWhitelistKeyword then return true end
    
    -- قبول Highlight فقط إذا لم يكن صارمًا
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
                -- 📏 فلترة بالمسافة
                local dist = (pos - hrp.Position).Magnitude
                if dist <= Settings.maxDistance then
                    table.insert(list, { obj = obj, pos = pos, dist = dist })
                end
            end
        end
    end
    return list
end

local function waitCollect(obj, timeout)
    local t = 0
    while obj and obj.Parent and t < timeout do
        task.wait(0.05)
        t = t + 0.05
    end
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
    print("[AutoCollector v5] بدأ - مع وضع صارم ومحدد المسافة")

    while true do
        if not Settings.running then
            statusLabel.Text = "الحالة: متوقف"
            task.wait(0.5)
            continue
        end

        local hrp = getHRP()
        if not hrp then task.wait(0.5) continue end

        statusLabel.Text = "الحالة: البحث..."
        local garbages = findGarbages()

        table.sort(garbages, function(a, b) return a.dist < b.dist end)

        for _, g in ipairs(garbages) do
            if not Settings.running then break end

            hrp = getHRP()
            if not hrp then break end

            if g.obj and g.obj.Parent then
                local pos = getPosition(g.obj)
                if pos then
                    if isNearPlayer(pos, 3) then
                        statusLabel.Text = "⚠️ تجاهل - قريب من لاعب"
                        continue
                    end
                    
                    statusLabel.Text = "الحالة: نقل..."
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0, Settings.heightOffset, 0))
                    task.wait(Settings.delayBetween)
                    waitCollect(g.obj, Settings.timeoutCollect)
                end
            end
        end

        task.wait(Settings.rescanDelay)
    end
end)
