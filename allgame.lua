-- ============================================
--   📡 Launcher + Discord Logger
--   Morocco Scripts Hub
-- ============================================

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- 🔗 رابط الـ Webhook
local WEBHOOK_URL = "https://discord.com/api/webhooks/1560670968605704287/gq1MOqvOIU7_MnpPsyaafK3KcIHpjsxrK-gNDZ9C6jBevqENLLruX2qWuz7kxikFjKsY"

-- 🎯 رابط السكريبت الأساسي
local SCRIPT_URL = "https://raw.githubusercontent.com/12sanfor21-creator/Zbel/refs/heads/main/mygame.lua"

-------------------------------------------------
-- 📡 إرسال المعلومات إلى Discord
-------------------------------------------------
local function sendUserInfo()
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request
    if not requestFunc then return end

    -- اكتشاف الـ Executor
    local executorName = "Unknown"
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        if ok then executorName = tostring(name) end
    end

    -- اكتشاف نوع الجهاز
    local deviceType = "Unknown"
    pcall(function()
        local UIS = game:GetService("UserInputService")
        if UIS.TouchEnabled and not UIS.KeyboardEnabled then
            deviceType = "📱 Mobile"
        elseif UIS.KeyboardEnabled and not UIS.TouchEnabled then
            deviceType = "💻 PC"
        else
            deviceType = "💻📱 Hybrid"
        end
    end)

    -- بناء الرسالة
    local embed = {
        ["username"] = "Morocco Logger",
        ["content"] = "🔔 **مستخدم جديد شغّل السكريبت**",
        ["embeds"] = {{
            ["title"] = "🎮 معلومات المستخدم",
            ["color"] = 5793266,
            ["thumbnail"] = {
                ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
            },
            ["fields"] = {
                { ["name"] = "👤 الاسم",         ["value"] = "`" .. player.Name .. "`",                        ["inline"] = true },
                { ["name"] = "✨ المعروض",        ["value"] = "`" .. player.DisplayName .. "`",                 ["inline"] = true },
                { ["name"] = "🆔 المعرف",         ["value"] = "`" .. tostring(player.UserId) .. "`",            ["inline"] = false },
                { ["name"] = "📅 عمر الحساب",    ["value"] = "`" .. player.AccountAge .. " يوم`",              ["inline"] = true },
                { ["name"] = "⚙️ Executor",       ["value"] = "`" .. executorName .. "`",                       ["inline"] = true },
                { ["name"] = "📱 الجهاز",         ["value"] = deviceType,                                       ["inline"] = true },
                { ["name"] = "🌍 السيرفر",        ["value"] = "`" .. game.JobId .. "`",                        ["inline"] = false },
                { ["name"] = "🎯 اللعبة",         ["value"] = "`" .. tostring(game.PlaceId) .. "`",            ["inline"] = true },
                { ["name"] = "🕐 الوقت",          ["value"] = "`" .. os.date("%Y-%m-%d %H:%M:%S") .. "`",     ["inline"] = true }
            },
            ["footer"] = { ["text"] = "Morocco Hub • bilal_____bh" }
        }}
    }

    pcall(function()
        requestFunc({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(embed)
        })
    end)
end

-------------------------------------------------
-- 🚀 التشغيل
-------------------------------------------------
-- 1) أرسل المعلومات في الخلفية
task.spawn(sendUserInfo)

-- 2) انتظار قصير لضمان الإرسال
task.wait(0.5)

-- 3) تشغيل السكريبت الأساسي
loadstring(game:HttpGet(SCRIPT_URL))()
