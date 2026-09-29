-- ============================================================================
--  Cokeboys NoKey Hardened Loader v1.2 (2026-09-29)
--  ตัวโหลด: cache-buster + ตรวจเวอร์ชัน + retry + แจ้ง error ชัดเจน
--  วิธีใช้: อัปโหลดไฟล์นี้ขึ้น repo (หรือวางในโฟลเดอร์ executor) แล้วรันผ่าน loadstring
-- ============================================================================

local URL = "https://raw.githubusercontent.com/auto578wqd/loader/main/cokeboys-bloxfruits-NOKKEY.lua"
local MIN_SIZE = 100000       -- ไฟล์จริง ~2.3MB ; ถ้าเล็กกว่านี้แปลว่าเป็นหน้า error
local RETRIES = 3             -- จำนวนครั้งที่ลองดาวน์โหลดซ้ำ
local EXPECT_VERSION = "[Cokeboys NoKey v1.3]"  -- ต้องเจอในไฟล์ที่โหลดมา

local function notify(title, text, dur)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title, Text = text, Duration = dur or 6
        })
    end)
end

print("[NoKey Loader v1.2] เริ่มดาวน์โหลดสคริปต์...")

-- 1) ดาวน์โหลด + cache-buster (กัน executor/HTTP cache ไฟล์เก่า) + retry
local src = nil
for attempt = 1, RETRIES do
    local bust = URL .. "?nk=" .. tostring(os.time()) .. tostring(math.random(1000, 9999))
    local ok, res = pcall(function()
        return game:HttpGet(bust, true)
    end)
    if ok and type(res) == "string" and #res >= MIN_SIZE and res:find("setmetatable", 1, true) then
        src = res
        print(("[NoKey Loader] ดาวน์โหลดสำเร็จ (ครั้งที่ %d, %s bytes)"):format(attempt, tostring(#res)))
        break
    end
    local why = ok and ("เนื้อหาผิดปกติ (" .. tostring(res and #res or 0) .. " bytes)") or tostring(res)
    warn(("[NoKey Loader] ครั้งที่ %d/%d ล้มเหลว: %s"):format(attempt, RETRIES, why))
    if attempt < RETRIES then task.wait(attempt) end
end

if not src then
    local msg = "ดาวน์โหลดสคริปต์ไม่สำเร็จหลังลอง " .. RETRIES .. " ครั้ง\nตรวจว่า: 1) repo เป็น Public 2) URL ถูกต้อง 3) เน็ต/VPN ปกติ"
    warn("[NoKey Loader] " .. msg)
    notify("NoKey Loader", "โหลดไม่สำเร็จ — ดู console", 8)
    return
end

-- 2) ตรวจเวอร์ชัน: ต้องเป็น v1.3 เท่านั้น (ถ้าไม่ใช่ = repo ยังมีไฟล์เก่าค้าง)
if not src:find(EXPECT_VERSION, 1, true) then
    warn("[NoKey Loader] !! ไฟล์ใน repo ไม่ใช่ v1.3 !!")
    warn("[NoKey Loader] repo อาจยังเป็นไฟล์เก่า - กรุณาอัปโหลด cokeboys-bloxfruits-NOKKEY.lua (v1.3) ทับใน GitHub อีกครั้ง")
    notify("NoKey Loader", "repo เป็นไฟล์เก่า - อัป v1.3 ทับ", 10)
    -- ยังรันต่อให้ (ถ้าเป็น v1.2 อาจยังใช้ได้) แต่เตือนให้ชัด
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
