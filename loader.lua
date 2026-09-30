-- ============================================================================
--  Cokeboys NoKey Hardened Loader v2.1 (2026-09-29) - Init Recovery build
--  dual-URL (GitHub raw + jsdelivr CDN fallback) + cache-buster + version check
--  + retry + แจ้ง error ภาษาไทยชัดเจน
--
--  ตัวเลือกเสริม (แก้ก่อนรันได้):
--    getgenv().CB_NoKey = { fpsBoost = true }   -- เปิด FPS boost (ตัดเงา/เบลอ/น้ำ)
--    getgenv().CB_NoKey = { hud = false }       -- ปิด HUD แจ้งเวอร์ชัน
-- ============================================================================

local CONFIG = {
        PRIMARY_URL  = "https://raw.githubusercontent.com/auto578wqd/loader/main/cokeboys-bloxfruits-NOKKEY.lua",
        FALLBACK_URL = "https://cdn.jsdelivr.net/gh/auto578wqd/loader@main/cokeboys-bloxfruits-NOKKEY.lua",
        EXPECT_VERSION = '__nkver="v2.1"',   -- literal จริงในไฟล์ (banner ใช้ string concat)
        MIN_SIZE     = 100000,               -- ไฟล์จริง ~2.3MB
        RETRIES      = 3,
}

local function notify(title, text, dur)
        pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = title, Text = text, Duration = dur or 6
                })
        end)
end

print("[NoKey Loader v2.1] เริ่มดาวน์โหลดสคริปต์...")

-- 1) ดาวน์โหลด: ลอง primary (raw) ก่อน ถ้าไม่ได้ค่อยใช้ CDN สำรอง + retry ทุก URL
local src, usedURL = nil, nil
for _, url in ipairs({ CONFIG.PRIMARY_URL, CONFIG.FALLBACK_URL }) do
        for attempt = 1, CONFIG.RETRIES do
                local bust = url .. "?nk=" .. tostring(os.time()) .. tostring(math.random(1000, 9999))
                local ok, res = pcall(function()
                        return game:HttpGet(bust, true)
                end)
                if ok and type(res) == "string" and #res >= CONFIG.MIN_SIZE and res:find("setmetatable", 1, true) then
                        src, usedURL = res, url
                        print(("[NoKey Loader] ดาวน์โหลดสำเร็จ (ครั้งที่ %d, %s bytes, %s)")
                                :format(attempt, tostring(#res), url:find("jsdelivr", 1, true) and "CDN สำรอง" or "GitHub raw"))
                        break
                end
                local why = ok and ("เนื้อหาผิดปกติ (" .. tostring(res and #res or 0) .. " bytes)") or tostring(res)
                warn(("[NoKey Loader] %s ครั้งที่ %d/%d ล้มเหลว: %s")
                        :format(url:find("jsdelivr", 1, true) and "[CDN]" or "[raw]", attempt, CONFIG.RETRIES, why))
                if attempt < CONFIG.RETRIES then task.wait(attempt) end
        end
        if src then break end
end

if not src then
        local msg = "ดาวน์โหลดสคริปต์ไม่สำเร็จทั้ง raw และ CDN\nตรวจว่า: 1) repo เป็น Public 2) เน็ต/VPN ปกติ 3) ลองใหม่ภายหลัง"
        warn("[NoKey Loader] " .. msg)
        notify("NoKey Loader", "โหลดไม่สำเร็จ — ดู console", 8)
        return
end

-- 2) ตรวจเวอร์ชัน (literal จริงในไฟล์ - ไม่ใช่ข้อความที่ประกอบตอน runtime)
if src:find(CONFIG.EXPECT_VERSION, 1, true) then
        print("[NoKey Loader] เวอร์ชันถูกต้อง: v2.1 ✓")
else
        warn("[NoKey Loader] !! ไฟล์ใน repo ไม่ใช่ v2.1 (อาจเป็นไฟล์เก่า/CDN cache) !!")
        warn("[NoKey Loader] กรุณาอัปโหลด cokeboys-bloxfruits-NOKKEY.lua (v2.1) ทับใน GitHub อีกครั้ง")
        notify("NoKey Loader", "repo เป็นไฟล์เก่า - อัป v2.1 ทับ", 10)
end

-- 3) compile พร้อมรายงาน error ที่อ่านได้
local fn, compileErr = loadstring(src)
if not fn then
        warn("[NoKey Loader] โค้ดเสียหาย ไม่สามารถ compile ได้: " .. tostring(compileErr))
        notify("NoKey Loader", "โค้ดเสียหาย — ดู console", 8)
        return
end

-- 4) รันพร้อมจับ error ให้สั้นและชัด
local okRun, runErr = pcall(fn)
if not okRun then
        warn("[NoKey Loader] Runtime error: " .. tostring(runErr))
        notify("NoKey Loader", "สคริปต์ error — ดู console", 10)
else
        print("[NoKey Loader] โหลดเสร็จสมบูรณ์")
end
