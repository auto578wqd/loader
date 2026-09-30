-- ============================================================================
--  Cokeboys NoKey ULTIMATE Loader v3.0 (2026-09-30)
--  4-URL (GitHub raw + jsdelivr CDN + GitHub mirror + githack)
--  + cache-buster + VERSION-GATED download (ปฏิเสธไฟล์เวอร์ชันเก่าจาก CDN เสมอ
--    ถ้า URL ไหนให้ไฟล์เก่า = ข้ามไป URL ถัดไปทันที ไม่มีการรันไฟล์เก่าอีกแล้ว)
--  + ตรวจ integrity หลายชั้น (size + markers + version literal)
--  + retry พร้อม backoff/jitter + ลองหลาย HTTP API
--  + ตรวจสอบหลังรัน (verify layer ของ v3.0 ทำงานจริง)
--  + แจ้ง error ภาษาไทยชัดเจน
--
--  ตัวเลือกเสริม (แก้ก่อนรันได้):
--    getgenv().CB_Loader = { verbose = true }  -- ดู log ละเอียดของ loader
--    getgenv().CB_Loader = { urls = { "https://...ของคุณ" } } -- กำหนด URL เอง
-- ============================================================================

local CONFIG = {
        URLS = {
                "https://raw.githubusercontent.com/auto578wqd/loader/main/cokeboys-bloxfruits-NOKKEY.lua",
                "https://cdn.jsdelivr.net/gh/auto578wqd/loader@main/cokeboys-bloxfruits-NOKKEY.lua",
                "https://github.com/auto578wqd/loader/raw/main/cokeboys-bloxfruits-NOKKEY.lua",
                "https://raw.githack.com/auto578wqd/loader/main/cokeboys-bloxfruits-NOKKEY.lua",
        },
        EXPECT_VERSION = '__nkver="v3.0"',  -- literal จริงในไฟล์ (banner ใช้ string concat)
        MARKERS  = { "setmetatable", "COKEBOYS-OFFLINE-KEY", "__nkver=" },
        MIN_SIZE = 100000,                  -- ไฟล์จริง ~2.3MB (กันได้ไฟล์ html/error page)
        RETRIES  = 3,
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
        if #u > 0 then CONFIG.URLS = u; end
end

local function vlog(...)
        if VERBOSE then print("[NoKey Loader v3.0]", ...); end
end

local function notify(title, text, dur)
        pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = title, Text = text, Duration = dur or 6
                })
        end)
end

local function urlKind(u)
        if u:find("jsdelivr", 1, true) then return "jsdelivr CDN"
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

-- ตรวจไฟล์ว่าเป็น v3.0 จริง: size + markers + version literal (ทั้งหมดต้องผ่าน)
local function verify(src)
        if type(src) ~= "string" or #src < CONFIG.MIN_SIZE then
                return false, "size ต่ำกว่า " .. tostring(CONFIG.MIN_SIZE) .. " bytes"
        end
        for _, mk in ipairs(CONFIG.MARKERS) do
                if not src:find(mk, 1, true) then
                        return false, "marker หาย: " .. mk
                end
        end
        if not src:find(CONFIG.EXPECT_VERSION, 1, true) then
                return false, "ไม่ใช่ไฟล์ v3.0 (เป็นไฟล์เก่าหรือแคช CDN เก่า)"
        end
        return true, "ok"
end

print(("[NoKey Loader v3.0] เริ่มดาวน์โหลด... (%d URL, retry %d ครั้ง/URL, version-gated)"):format(#CONFIG.URLS, CONFIG.RETRIES))
notify("NoKey Loader v3.0", "กำลังโหลดสคริปต์ (v3.0)...", 4)

-- 1) ดาวน์โหลด + VERSION GATE: ไฟล์เก่า = ถือว่าล้มเหลวทันที ไป URL ถัดไป
local src, usedURL, usedAPI = nil, nil, nil
for _, url in ipairs(CONFIG.URLS) do
        for attempt = 1, CONFIG.RETRIES do
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
                        else
                                warn(("[NoKey Loader] [%s] ครั้งที่ %d/%d: ได้ไฟล์แต่ไม่ผ่านเงื่อนไข (%d bytes) - %s")
                                        :format(urlKind(url), attempt, CONFIG.RETRIES, #res, why))
                        end
                else
                        warn(("[NoKey Loader] [%s] ครั้งที่ %d/%d ล้มเหลว: %s")
                                :format(urlKind(url), attempt, CONFIG.RETRIES, tostring(api)))
                end
                if attempt < CONFIG.RETRIES then
                        task.wait(attempt * 1.1 + math.random() * 0.4)
                end
        end
        if src then break end
        vlog("หมด retry ของ", url, "- ไป URL ถัดไป")
end

if not src then
        local msg = "ดาวน์โหลด v3.0 ไม่สำเร็จจากทุกช่องทาง (raw / jsdelivr / github mirror / githack)\n"
                .. "ตรวจว่า: 1) repo auto578wqd/loader เป็น Public และอัปโหลดไฟล์ v3.0 แล้ว\n"
                .. "2) เคลียร์แคช CDN ที่ https://www.jsdelivr.com/tools/purge (ถ้าเพิ่งอัปโหลด)\n"
                .. "3) เน็ตปกติ (เปิด URL ในเบราว์เซอร์ได้ ไม่ต้องใช้ VPN)"
        warn("[NoKey Loader] " .. msg)
        notify("NoKey Loader", "โหลดไม่สำเร็จ - ดู console (F9)", 8)
        return
end

-- 2) compile พร้อมรายงาน error ที่อ่านได้
local fn, compileErr = loadstring(src)
if not fn then
        warn("[NoKey Loader] โค้ดเสียหาย ไม่สามารถ compile ได้: " .. tostring(compileErr))
        notify("NoKey Loader", "โค้ดเสียหาย - ดู console (F9)", 8)
        return
end

-- 3) รันพร้อมจับ error ให้สั้นและชัด
local okRun, runErr = pcall(fn)
if not okRun then
        warn("[NoKey Loader] Runtime error: " .. tostring(runErr))
        notify("NoKey Loader", "สคริปต์ error - ดู console (F9)", 10)
        return
end
print("[NoKey Loader] โหลดเสร็จสมบูรณ์ (v3.0 ผ่าน " .. urlKind(usedURL) .. ")")

-- 4) POST-RUN VERIFY: ยืนยันว่า layer v3.0 ทำงานจริง (ตั้ง flag ใน getgenv)
task.delay(2, function()
        local okL, layer = pcall(function()
                return (type(getgenv) == "function" and getgenv() or _G).CB_NoKey
        end)
        if okL and type(layer) == "table" and layer.version == "v3.0" then
                print(("[NoKey Loader] ยืนยันแล้ว: layer v3.0 active (ready=%s guard=%s)")
                        :format(tostring(layer.ready), tostring(layer.capabilities and layer.capabilities.hook)))
                notify("NoKey Loader v3.0", "โหลดสำเร็จ - การ์ด + HUD ของ v3.0 ทำงานแล้ว", 6)
        else
                warn("[NoKey Loader] !! layer v3.0 ไม่ตอบสนอง (อาจโหลดผิดเวอร์ชัน) - กด F9 ดู console !!")
                notify("NoKey Loader", "โหลดแล้วแต่ยืนยัน v3.0 ไม่ได้ - ดู F9", 8)
        end
end)
