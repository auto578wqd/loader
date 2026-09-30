-- ============================================================================
--  Cokeboys NoKey Hardened Loader v2.2 (2026-09-30)
--  4-URL (GitHub raw + jsdelivr CDN + GitHub mirror + githack)
--  + cache-buster
--  + ตรวจเวอร์ชัน + ตรวจ integrity หลายชั้น (size + markers)
--  + retry พร้อม backoff/jitter + ลองหลาย HTTP API
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
        EXPECT_VERSION = '__nkver="v2.2"',  -- literal จริงในไฟล์ (banner ใช้ string concat)
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
        if VERBOSE then print("[NoKey Loader v2.2]", ...); end
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

print(("[NoKey Loader v2.2] เริ่มดาวน์โหลด... (%d URL, retry %d ครั้ง/URL)"):format(#CONFIG.URLS, CONFIG.RETRIES))

-- 1) ดาวน์โหลด: ไล่ทุก URL ตามลำดับ + retry พร้อม backoff/jitter
local src, usedURL, usedAPI = nil, nil, nil
for _, url in ipairs(CONFIG.URLS) do
        for attempt = 1, CONFIG.RETRIES do
                local bust = url .. "?nk=" .. tostring(os.time()) .. tostring(math.random(1000, 9999))
                local t0 = os.clock()
                local res, api = fetch(bust)
                if type(res) == "string" and #res >= CONFIG.MIN_SIZE then
                        local pass = true
                        for _, mk in ipairs(CONFIG.MARKERS) do
                                if not res:find(mk, 1, true) then pass = false break end
                        end
                        if pass then
                                src, usedURL, usedAPI = res, url, api
                                print(("[NoKey Loader] ดาวน์โหลดสำเร็จ: %s | ครั้งที่ %d | %d bytes (~%.1f KB) | %.0f ms | %s ผ่าน %s")
                                        :format(urlKind(url), attempt, #res, #res / 1024, (os.clock() - t0) * 1000, url, api))
                                break
                        end
                        warn(("[NoKey Loader] [%s] ครั้งที่ %d/%d: ได้ไฟล์แต่ integrity ไม่ผ่าน (%d bytes) - %s")
                                :format(urlKind(url), attempt, CONFIG.RETRIES, #res, url))
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
        local msg = "ดาวน์โหลดไม่สำเร็จจากทุกช่องทาง (raw / jsdelivr / github mirror / githack)\n"
                .. "ตรวจว่า: 1) repo auto578wqd/loader เป็น Public 2) ไฟล์ cokeboys-bloxfruits-NOKKEY.lua อยู่ branch main 3) เน็ตปกติ (ทดสอบเปิด URL ในเบราว์เซอร์ได้ ไม่ต้องใช้ VPN)"
        warn("[NoKey Loader] " .. msg)
        notify("NoKey Loader", "โหลดไม่สำเร็จทุกช่องทาง - ดู console (F9)", 8)
        return
end

-- 2) ตรวจเวอร์ชัน (literal จริงในไฟล์ - ไม่ใช่ข้อความที่ประกอบตอน runtime)
if src:find(CONFIG.EXPECT_VERSION, 1, true) then
        print("[NoKey Loader] เวอร์ชันถูกต้อง: v2.2 (ดึงผ่าน " .. tostring(usedAPI) .. ")")
else
        warn("[NoKey Loader] !! ไฟล์ที่ได้ไม่ใช่ v2.2 (อาจเป็นไฟล์เก่า หรือแคช CDN เก่า) !!")
        warn("[NoKey Loader] แก้ไข: 1) อัปโหลดไฟล์ v2.2 ทับใน GitHub (branch main) 2) เคลียร์แคช jsdelivr ที่ https://www.jsdelivr.com/tools/purge")
        notify("NoKey Loader", "ได้ไฟล์เก่า - อัป v2.2 ทับ + เคลียร์แคช CDN", 10)
end

-- 3) compile พร้อมรายงาน error ที่อ่านได้
local fn, compileErr = loadstring(src)
if not fn then
        warn("[NoKey Loader] โค้ดเสียหาย ไม่สามารถ compile ได้: " .. tostring(compileErr))
        notify("NoKey Loader", "โค้ดเสียหาย - ดู console (F9)", 8)
        return
end

-- 4) รันพร้อมจับ error ให้สั้นและชัด
local okRun, runErr = pcall(fn)
if not okRun then
        warn("[NoKey Loader] Runtime error: " .. tostring(runErr))
        notify("NoKey Loader", "สคริปต์ error - ดู console (F9)", 10)
else
        print("[NoKey Loader] โหลดเสร็จสมบูรณ์ (v2.2 ผ่าน " .. urlKind(usedURL) .. ")")
end
