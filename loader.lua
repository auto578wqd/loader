-- ============================================================================
--  Cokeboys NoKey ULTIMATE Loader v3.1 (2026-09-30)
--
--  ใหม่ใน v3.1 (แก้จาก log จริงของผู้ใช้):
--   1) URL ALIAS (cb-bf-nk.lua) ลองก่อน - URL ไม่มีคำว่า "cokeboys" เลย
--      -> กัน hook ของ v3.0 เดิมที่บล็อก URL มีคำ "cokeboys" (โหลดทับได้เลย
--         ไม่ต้องรีสตาร์ทเกม)
--   2) ตรวจจับ JSON ปลอม (__cbfake / success:true ตัวเล็ก) ที่ hook เก่าตอบมา
--      -> แจ้งสาเหตุจริงแทน "ดาวน์โหลดไม่สำเร็จ" กว้าง ๆ
--   3) ตั้ง flag __NK_LOADER_FETCH ระหว่างดาวน์โหลด -> hook ของ v3.1 ปล่อยผ่านทุก URL
--   4) รันซ้ำเมื่อ v3.1 ยังทำงานอยู่ (heartbeat) = no-op พร้อมข้อความสวย ๆ
--      (ไม่โหลดซ้ำ ไม่พัง session)
--   5) อัปเดตจากเวอร์ชันเก่า (v3.0 ที่ยังรันอยู่) = โหลดทับได้ทันทีผ่าน alias
--
--  คงไว้จาก v3.0:
--   + 4 มิเรอร์ (GitHub raw / jsdelivr CDN / GitHub mirror / githack) x2 ชุด
--   + cache-buster + VERSION-GATED (ไฟล์เก่า = ปฏิเสธทันที ไป URL ถัดไป)
--   + ตรวจ integrity หลายชั้น (size + markers + version literal)
--   + retry พร้อม backoff/jitter + ลองหลาย HTTP API
--   + ตรวจสอบหลังรัน (verify layer v3.1 ทำงานจริง)
--
--  ตัวเลือกเสริม (แก้ก่อนรันได้):
--    getgenv().CB_Loader = { verbose = true }  -- ดู log ละเอียดของ loader
--    getgenv().CB_Loader = { urls = { "https://...ของคุณ" } } -- กำหนด URL เอง
-- ============================================================================

local CONFIG = {
        -- ชุด alias: ชื่อไฟล์ไม่มีคำ "cokeboys" -> hook เก่าของ v3.0 ไม่จับ (ลองก่อน, retry น้อย)
        URLS_ALIAS = {
                "https://raw.githubusercontent.com/auto578wqd/loader/main/cb-bf-nk.lua",
                "https://cdn.jsdelivr.net/gh/auto578wqd/loader@main/cb-bf-nk.lua",
                "https://github.com/auto578wqd/loader/raw/main/cb-bf-nk.lua",
                "https://raw.githack.com/auto578wqd/loader/main/cb-bf-nk.lua",
        },
        -- ชุดหลัก: ชื่อไฟล์เดิม (ลองทีหลัง, retry เต็ม)
        URLS_MAIN = {
                "https://raw.githubusercontent.com/auto578wqd/loader/main/cokeboys-bloxfruits-NOKKEY.lua",
                "https://cdn.jsdelivr.net/gh/auto578wqd/loader@main/cokeboys-bloxfruits-NOKKEY.lua",
                "https://github.com/auto578wqd/loader/raw/main/cokeboys-bloxfruits-NOKKEY.lua",
                "https://raw.githack.com/auto578wqd/loader/main/cokeboys-bloxfruits-NOKKEY.lua",
        },
        EXPECT_VERSION = '__nkver="v3.1"',  -- literal จริงในไฟล์
        MARKERS  = { "setmetatable", "COKEBOYS-OFFLINE-KEY", "__nkver=" },
        MIN_SIZE = 100000,                  -- ไฟล์จริง ~2.3MB (กัน html/error page)
        RETRIES_ALIAS = 1,                  -- alias: ลองครั้งเดียวต่อ URL (ให้เร็ว)
        RETRIES_MAIN  = 3,                  -- ชุดหลัก: retry เต็ม
        FAKE_MARKERS  = { "__cbfake", '"success":true,"valid":true' }, -- เจอ = hook เก่าตอบมา
}

pcall(function() math.randomseed(os.time() + math.floor(os.clock() * 1000)); end)

local __genv = (type(getgenv) == "function" and getgenv()) or _G
local LCFG = type(__genv.CB_Loader) == "table" and __genv.CB_Loader or {}
local VERBOSE = (LCFG.verbose == true)

if type(LCFG.urls) == "table" then
        local u = {}
        for _, x in ipairs(LCFG.urls) do
                if type(x) == "string" and #x > 8 then u[#u + 1] = x; end
        end
        if #u > 0 then
                CONFIG.URLS_ALIAS = u
                CONFIG.URLS_MAIN = {}
        end
end

local function vlog(...)
        if VERBOSE then print("[NoKey Loader v3.1]", ...); end
end

local function notify(title, text, dur)
        pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = title, Text = text, Duration = dur or 6
                })
        end)
end

local function urlKind(u)
        if u:find("cb-bf-nk", 1, true) then return "alias file"
        elseif u:find("jsdelivr", 1, true) then return "jsdelivr CDN"
        elseif u:find("githack", 1, true) then return "githack mirror"
        elseif u:find("raw.githubusercontent", 1, true) then return "GitHub raw"
        elseif u:find("github.com", 1, true) then return "GitHub mirror"
        else return "custom URL" end
end

-- ตัวดึงข้อมูล: ลองหลาย API ตามลำดับ (game:HttpGet -> global HttpGet -> request GET)
local function fetch(url)
        local ok, res = pcall(function() return game:HttpGet(url, true); end)
        if ok and type(res) == "string" and #res > 0 then return res, "game:HttpGet"; end
        vlog("game:HttpGet ไม่ได้ผล ลอง global HttpGet...", tostring(res))
        ok, res = pcall(function()
                local h = rawget(_G, "HttpGet") or rawget(__genv, "HttpGet")
                        or (type(getgenv) == "function" and rawget(getgenv(), "HttpGet")) or nil
                if type(h) ~= "function" then error("no global HttpGet"); end
                return h(url)
        end)
        if ok and type(res) == "string" and #res > 0 then return res, "global HttpGet"; end
        vlog("global HttpGet ไม่ได้ผล ลอง request()...", tostring(res))
        ok, res = pcall(function()
                local rq = rawget(_G, "request") or rawget(_G, "http_request")
                        or rawget(__genv, "request") or rawget(__genv, "http_request")
                if type(rq) ~= "function" then error("no request fn"); end
                local r = rq({ Url = url, Method = "GET" })
                if type(r) == "table" then return tostring(r.Body or ""); end
                return tostring(r or "")
        end)
        if ok and type(res) == "string" and #res > 0 then return res, "request()"; end
        return nil, "no working http api in this executor"
end

-- ตรวจไฟล์: (1) JSON ปลอมจาก hook เก่า? (2) size (3) markers (4) version literal
local function verify(src)
        if type(src) == "string" and #src < 500 then
                for _, fm in ipairs(CONFIG.FAKE_MARKERS) do
                        if src:find(fm, 1, true) then
                                return false, "__SELF_HOOK__"
                        end
                end
        end
        if type(src) ~= "string" or #src < CONFIG.MIN_SIZE then
                return false, "size ต่ำกว่า " .. tostring(CONFIG.MIN_SIZE) .. " bytes"
        end
        for _, mk in ipairs(CONFIG.MARKERS) do
                if not src:find(mk, 1, true) then
                        return false, "marker หาย: " .. mk
                end
        end
        if not src:find(CONFIG.EXPECT_VERSION, 1, true) then
                return false, "ไม่ใช่ไฟล์ v3.1 (เป็นไฟล์เก่าหรือแคช CDN เก่า)"
        end
        return true, "ok"
end

-- ============================================================================
-- 0) กรณีรันซ้ำ: v3.1 ยังทำงานอยู่และ heartbeat สดๆ = ไม่ต้องทำอะไรเลย
-- ============================================================================
do
        local cur = __genv.CB_NoKey
        if type(cur) == "table" and cur.version == "v3.1" and cur.ready == true then
                local hb = tonumber(cur.hb) or 0
                local now = (type(tick) == "function" and tick()) or os.clock()
                if now - hb < 45 then
                        print("[NoKey Loader v3.1] สคริปต์ v3.1 ทำงานอยู่แล้วในเซสชันนี้ - ไม่ต้องรันซ้ำ (guard ยัง active)")
                        notify("NoKey Loader v3.1", "สคริปต์ทำงานอยู่แล้ว - ใช้งานได้เลย", 5)
                        return
                else
                        print("[NoKey Loader v3.1] พบ layer เก่าที่หยุดทำงาน (heartbeat หาย) - จะโหลดใหม่ให้")
                end
        end
end

print("[NoKey Loader v3.1] เริ่มดาวน์โหลด... (alias 4 URL + main 4 URL, version-gated)")
notify("NoKey Loader v3.1", "กำลังโหลดสคริปต์ (v3.1)...", 4)

-- v3.1: ตั้ง flag ให้ hook ของ layer v3.1 ปล่อยผ่าน URL ทุกประเภทระหว่างดาวน์โหลด
__genv.__NK_LOADER_FETCH = true

-- ============================================================================
-- 1) ดาวน์โหลด: alias ก่อน (กัน hook เก่า) แล้วค่อยชุดหลัก
-- ============================================================================
local src, usedURL, usedAPI = nil, nil, nil
local sawSelfHook = false

for _, set in ipairs({ { urls = CONFIG.URLS_ALIAS, retries = CONFIG.RETRIES_ALIAS },
                       { urls = CONFIG.URLS_MAIN,  retries = CONFIG.RETRIES_MAIN  } }) do
        for _, url in ipairs(set.urls) do
                for attempt = 1, set.retries do
                        local bust = url .. "?nk=" .. tostring(os.time()) .. tostring(math.random(1000, 9999))
                        local t0 = os.clock()
                        local res, api = fetch(bust)
                        if type(res) == "string" and #res > 0 then
                                local ok, why = verify(res)
                                if ok then
                                        src, usedURL, usedAPI = res, url, api
                                        print(("[NoKey Loader] ดาวน์โหลดสำเร็จ: %s | ครั้งที่ %d | %d bytes (~%.1f KB) | %.0f ms | %s ผ่าน %s")
                                                :format(urlKind(url), attempt, #res, #res / 1024, (os.clock() - t0) * 1000, url, api))
                                        break
                                elseif why == "__SELF_HOOK__" then
                                        sawSelfHook = true
                                        vlog("[%s] คำตอบเป็น JSON ปลอมจาก hook เก่า (%d bytes)", urlKind(url), #res)
                                else
                                        warn(("[NoKey Loader] [%s] ครั้งที่ %d/%d: ได้ไฟล์แต่ไม่ผ่านเงื่อนไข (%d bytes) - %s")
                                                :format(urlKind(url), attempt, set.retries, #res, why))
                                end
                        else
                                warn(("[NoKey Loader] [%s] ครั้งที่ %d/%d ล้มเหลว: %s")
                                        :format(urlKind(url), attempt, set.retries, tostring(api)))
                        end
                        if attempt < set.retries then
                                task.wait(attempt * 1.1 + math.random() * 0.4)
                        end
                end
                if src then break end
                vlog("หมด retry ของ", url, "- ไป URL ถัดไป")
        end
        if src then break end
end

-- เลิก flag ทันทีที่ดาวน์โหลดจบ (สำเร็จหรือล้มเหลว) เพื่อให้ guard กลับมาทำงานเต็มที่
__genv.__NK_LOADER_FETCH = nil

if not src then
        if sawSelfHook then
                warn("[NoKey Loader] ตรวจพบ: hook ของ NoKey เวอร์ชันเก่า (v3.0) กำลังทำงานอยู่ในเซสชันนี้")
                warn("[NoKey Loader] มันบล็อก URL ที่มีคำว่า 'cokeboys' (ตอบ JSON ปลอม ~128 bytes ทุก URL)")
                warn("[NoKey Loader] วิธีแก้: 1) อัปโหลดไฟล์ cb-bf-nk.lua ขึ้น repo แล้วรัน loader นี้ใหม่ (อัปเดตได้เลยไม่ต้อง restart)")
                warn("[NoKey Loader]            2) หรือออกจากเกม เข้าใหม่ แล้วรัน loader v3.1 อีกครั้ง")
                notify("NoKey Loader", "hook เก่าบล็อกการโหลดซ้ำ - กด F9 ดูวิธีแก้", 8)
        else
                local msg = "ดาวน์โหลด v3.1 ไม่สำเร็จจากทุกช่องทาง (alias + raw / jsdelivr / github mirror / githack)\n"
                        .. "ตรวจว่า: 1) repo auto578wqd/loader เป็น Public และอัปโหลดไฟล์ v3.1 แล้ว\n"
                        .. "2) เคลียร์แคช CDN ที่ https://www.jsdelivr.com/tools/purge (ถ้าเพิ่งอัปโหลด)\n"
                        .. "3) เน็ตปกติ (เปิด URL ในเบราว์เซอร์ได้ ไม่ต้องใช้ VPN)"
                warn("[NoKey Loader] " .. msg)
                notify("NoKey Loader", "โหลดไม่สำเร็จ - ดู console (F9)", 8)
        end
        return
end

-- ============================================================================
-- 2) compile พร้อมรายงาน error ที่อ่านได้
-- ============================================================================
local fn, compileErr = loadstring(src)
if not fn then
        warn("[NoKey Loader] โค้ดเสียหาย ไม่สามารถ compile ได้: " .. tostring(compileErr))
        notify("NoKey Loader", "โค้ดเสียหาย - ดู console (F9)", 8)
        return
end

-- จำเวอร์ชันเดิมก่อนรัน (ไว้พิมพ์ข้อความอัปเดต)
local prevVersion = (type(__genv.CB_NoKey) == "table" and tostring(__genv.CB_NoKey.version)) or nil

-- ============================================================================
-- 3) รันพร้อมจับ error ให้สั้นและชัด
-- ============================================================================
local okRun, runErr = pcall(fn)
if not okRun then
        warn("[NoKey Loader] Runtime error: " .. tostring(runErr))
        notify("NoKey Loader", "สคริปต์ error - ดู console (F9)", 10)
        return
end

if prevVersion and prevVersion ~= "v3.1" then
        print("[NoKey Loader] อัปเดตจาก " .. prevVersion .. " -> v3.1 สำเร็จ (โหลดทับ ไม่ต้อง restart เกม)")
else
        print("[NoKey Loader] โหลดเสร็จสมบูรณ์ (v3.1 ผ่าน " .. urlKind(usedURL) .. ")")
end

-- ============================================================================
-- 4) POST-RUN VERIFY: ยืนยันว่า layer v3.1 ทำงานจริง
-- ============================================================================
task.delay(2, function()
        local okL, layer = pcall(function()
                return (type(getgenv) == "function" and getgenv() or _G).CB_NoKey
        end)
        if okL and type(layer) == "table" and layer.version == "v3.1" then
                print(("[NoKey Loader] ยืนยันแล้ว: layer v3.1 active (ready=%s guard=%s)")
                        :format(tostring(layer.ready), tostring(layer.capabilities and layer.capabilities.hook)))
                notify("NoKey Loader v3.1", "โหลดสำเร็จ - การ์ด + HUD ของ v3.1 ทำงานแล้ว", 6)
        else
                warn("[NoKey Loader] !! layer v3.1 ไม่ตอบสนอง (อาจโหลดผิดเวอร์ชัน) - กด F9 ดู console !!")
                notify("NoKey Loader", "โหลดแล้วแต่ยืนยัน v3.1 ไม่ได้ - ดู F9", 8)
        end
end)
