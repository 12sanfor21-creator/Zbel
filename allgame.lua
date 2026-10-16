-- ============================================
--   📡 Launcher + Discord Logger v2
--   ✅ يضيف: الدولة + اسم اللعبة + اللغة
-- ============================================

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local WEBHOOK_URL = "https://discord.com/api/webhooks/1560670968605704287/gq1MOqvOIU7_MnpPsyaafK3KcIHpjsxrK-gNDZ9C6jBevqENLLruX2qWuz7kxikFjKsY"

local SCRIPT_URL = "https://raw.githubusercontent.com/12sanfor21-creator/Zbel/refs/heads/main/mygame.lua"

-------------------------------------------------
-- 🌍 خريطة الدول (حسب locale الرسمي)
-------------------------------------------------
local COUNTRY_MAP = {
    ["ar-001"] = "🌍 عربي (عام)",
    ["ar-SA"] = "🇸🇦 السعودية",
    ["ar-EG"] = "🇪🇬 مصر",
    ["ar-MA"] = "🇲🇦 المغرب",
    ["ar-DZ"] = "🇩🇿 الجزائر",
    ["ar-TN"] = "🇹🇳 تونس",
    ["ar-LY"] = "🇱🇾 ليبيا",
    ["ar-IQ"] = "🇮🇶 العراق",
    ["ar-JO"] = "🇯🇴 الأردن",
    ["ar-KW"] = "🇰🇼 الكويت",
    ["ar-AE"] = "🇦🇪 الإمارات",
    ["ar-QA"] = "🇶🇦 قطر",
    ["ar-BH"] = "🇧🇭 البحرين",
    ["ar-OM"] = "🇴🇲 عمان",
    ["ar-YE"] = "🇾🇪 اليمن",
    ["ar-SY"] = "🇸🇾 سوريا",
    ["ar-LB"] = "🇱🇧 لبنان",
    ["ar-PS"] = "🇵🇸 فلسطين",
    ["ar-SD"] = "🇸🇩 السودان",
    ["en-US"] = "🇺🇸 أمريكا",
    ["en-GB"] = "🇬🇧 بريطانيا",
    ["fr-FR"] = "🇫🇷 فرنسا",
    ["es-ES"] = "🇪🇸 إسبانيا",
    ["de-DE"] = "🇩🇪 ألمانيا",
    ["it-IT"] = "🇮🇹 إيطاليا",
    ["pt-BR"] = "🇧🇷 البرازيل",
    ["ru-RU"] = "🇷🇺 روسيا",
    ["tr-TR"] = "🇹🇷 تركيا",
    ["ja-JP"] = "🇯🇵 اليابان",
    ["ko-KR"] = "🇰🇷 كوريا",
    ["zh-CN"] = "🇨🇳 الصين",
    ["hi-IN"] = "🇮🇳 الهند",
    ["id-ID"] = "🇮🇩 إندونيسيا",
}

-------------------------------------------------
-- 📡 دالة إرسال المعلومات
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

    -- 🌍 اكتشاف الدولة من locale
    local locale = "غير معروف"
    local countryName = "غير معروف"
    pcall(function()
        locale = game:GetService("LocalizationService").RobloxLocaleId or "Unknown"
        countryName = COUNTRY_MAP[locale] or ("🌐 " .. locale)
    end)

    -- 🎮 جلب اسم اللعبة من Roblox API
    local gameName = "غير معروف"
    pcall(function()
        local url = "https://games.roblox.com/v1/games?universeIds=" .. game.GameId
        local response = requestFunc({
            Url = url,
            Method = "GET"
        })
        if response and response.Body then
            local data = HttpService:JSONDecode(response.Body)
            if data.data and data.data[1] and data.data[1].name then
                gameName = data.data[1].name
            end
        end
    end)

    -- 🎯 اسم المكان الحالي (خاص بالسيرفر)
    local placeName = "غير معروف"
    pcall(function()
        placeName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
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
                { ["name"] = "🌍 الدولة",         ["value"] = countryName,                                      ["inline"] = true },
                { ["name"] = "🗣️ اللغة",          ["value"] = "`" .. locale .. "`",                             ["inline"] = true },
                { ["name"] = "🎮 اللعبة",         ["value"] = "**" .. gameName .. "**",                         ["inline"] = false },
                { ["name"] = "🗺️ السيرفر",       ["value"] = "**" .. placeName .. "**",                        ["inline"] = false },
                { ["name"] = "⚙️ Executor",       ["value"] = "`" .. executorName .. "`",                       ["inline"] = true },
                { ["name"] = "📱 الجهاز",         ["value"] = deviceType,                                       ["inline"] = true },
                { ["name"] = "🌐 JobId",          ["value"] = "`" .. game.JobId .. "`",                        ["inline"] = false },
                { ["name"] = "🎯 PlaceId",        ["value"] = "`" .. tostring(game.PlaceId) .. "`",            ["inline"] = true },
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
task.spawn(sendUserInfo)
task.wait(0.5)

loadstring(game:HttpGet(SCRIPT_URL))()
