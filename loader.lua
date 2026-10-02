-- THE VOIDER loader.lua — GENERATED FILE ห้ามแก้มือ (§3.10 กติกาเดียวกับ graph.lua)
-- แหล่งต้นฉบับ: core/runtime/{preflight,version,sha256,manifest(?),update,loader_main} + core/foundation/json.lua
-- ประกอบโดย build/tools/build_dist.py | loader version 0.3.0
-- เวอร์ชันล่าสุดของไฟล์นี้: ดูที่ repo loader (SSOT = ไฟล์ต้นฉบับใน core/)

__TV_EMBED = {}
-- ==== embedded: preflight (core/runtime/preflight.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/preflight.lua
-- Bootstrap Preflight (แผน freeze v2.1 §3.2 ข้อ 0, hardening #6)
--
-- รัน "ใน loader ก่อนโหลด core" ตรวจเฉพาะ prerequisite ที่ loader เองต้องใช้:
--   1) มี HTTP request function จริงหรือไม่ (ชื่อไหนก็ตามที่ executor รองรับ)
--   2) เข้าถึง GitHub/CDN ได้หรือไม่
--
-- พัง = แจ้ง plain text ผ่านคอนโซลของ executor (ข้อความไทยชัดเจน 1 บรรทัด)
-- แล้วหยุดทำงานทันที — ไม่มี UI ใด ๆ เพราะ core ยังไม่ถูกโหลด
-- (แยกชัดจาก Runtime Capability = หลัง core = Notification UI + graceful disable)
--
-- หมายเหตุ build: loader.lua ส่งมอบจริง embed ไฟล์นี้ (core ยังไม่ถูกโหลด
-- จึง require จากไฟล์อื่นไม่ได้) — build script คัดลอก/ฝังให้อัตโนมัติทุกรอบ
-- ============================================================================

local Preflight = {}

-- ชื่อ HTTP API ที่ค้ำเลือก (เรียงตามควา่นิยม) — Volt ใช้ http_request
Preflight.HTTP_CANDIDATES = {
  "http_request", -- มาตรฐาน executor รุ่นใหม่ (Volt)
  "syn.request",  -- มาตรฐานเก่า
  "request",
  "http_get",     -- GET-only (คืน body เป็น string)
  "httpget",
}

Preflight.MSG_NO_HTTP =
  "[The Voider] รันสคริปต์ไม่ได้: ไม่พบระบบเชื่อมต่ออินเทอร์เน็ต (HTTP) — The Voider รองรับการใช้งานบน Volt เท่านั้น"

Preflight.MSG_CDN_FAIL =
  "[The Voider] รันสคริปต์ไม่ได้: เข้าถึงเซิร์ฟเวอร์อัปเดต (GitHub/CDN) ไม่สำเร็จ — กรุณาตรวจอินเทอร์เน็ตแล้วรันใหม่ (The Voider รองรับ Volt เท่านั้น)"

--- ค้นหา HTTP function จาก environment — คืน (name, fn) หรือ (nil, nil)
function Preflight.FindHTTP(env)
  env = env or _G
  for _, name in ipairs(Preflight.HTTP_CANDIDATES) do
    if name == "syn.request" then
      if type(env.syn) == "table" and type(env.syn.request) == "function" then
        return name, env.syn.request
      end
    else
      local v = env[name]
      if type(v) == "function" then
        return name, v
      end
    end
  end
  return nil, nil
end

-- ปรับผลตอบของ HTTP API หลายรูปแบบให้เป็นมาตรฐานเดียว {ok, status}
local function normalize(res)
  if type(res) == "table" then
    if res.Success == true then return { ok = true, status = "Success=true" } end
    local code = res.StatusCode or res.Status or res.code
    if type(code) == "number" then
      if code >= 200 and code <= 299 then
        return { ok = true, status = tostring(code) }
      end
      return { ok = false, status = tostring(code) }
    end
    if type(res.Body) == "string" and #res.Body > 0 then
      return { ok = true, status = "body:" .. tostring(#res.Body) .. "B" }
    end
  elseif type(res) == "string" then
    if #res > 0 then return { ok = true, status = "body:" .. tostring(#res) .. "B" } end
  end
  return { ok = false, status = "no-response" }
end

-- สร้าง requester ที่คุมรูปแบบการเรียกตามชื่อ API (table-request vs GET-only)
local function makeRequester(name, fn, timeout)
  if name == "http_get" or name == "httpget" then
    return function(url)
      local ok, body = pcall(fn, url)
      if not ok then return { ok = false, status = "error:" .. tostring(body) } end
      return normalize(body)
    end
  end
  return function(url)
    local req = { Url = url, Method = "GET" }
    if timeout then req.Timeout = timeout end
    local ok, res = pcall(fn, req)
    if not ok then return { ok = false, status = "error:" .. tostring(res) } end
    return normalize(res)
  end
end

--- ตรวจ 2 ขั้น: HTTP function + CDN เข้าถึงได้
--- opts = { env=table, urls={...}, log=function, httpFn=function, httpName=string, timeout=number }
--- คืน result = { ok, stage, httpName, httpFn, url, message, lastStatus }
---   stage: "http_function" | "cdn" | "done"
function Preflight.Run(opts)
  opts = opts or {}
  local env = opts.env or _G
  local timeout = opts.timeout or 8

  local function log(msg)
    if opts.log then
      opts.log(msg)
    else
      local w = type(warn) == "function" and warn or print
      w(msg)
    end
  end

  local result = { ok = false, stage = nil, httpName = nil, httpFn = nil, url = nil, message = nil }

  -- ขั้น 1: หา HTTP function จริง
  local name, fn
  if opts.httpFn then
    name, fn = opts.httpName or "(custom)", opts.httpFn
  else
    name, fn = Preflight.FindHTTP(env)
  end
  if not name then
    result.stage = "http_function"
    result.message = Preflight.MSG_NO_HTTP
    log(result.message) -- plain text 1 บรรทัด แล้วหยุด (loader เรียก return เอง)
    return result
  end
  result.httpName = name
  result.httpFn = fn

  -- ขั้น 2: CDN/GitHub เข้าถึงได้อย่างน้อย 1 URL (fallback ตามลำดับ)
  local request = makeRequester(name, fn, timeout)
  local urls = opts.urls or {}
  local lastStatus = nil
  for _, url in ipairs(urls) do
    local res = request(url)
    if res.ok then
      result.ok = true
      result.stage = "done"
      result.url = url
      return result
    end
    lastStatus = res.status
  end

  result.stage = "cdn"
  result.message = Preflight.MSG_CDN_FAIL
  result.lastStatus = lastStatus
  log(result.message)
  return result
end

return Preflight

  end)();
  __TV_EMBED['preflight'] = __m;
end
-- ==== embedded: version (core/runtime/version.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/version.lua (loader-domain: 4-URL + Version Gate §7.1)
--
-- เวอร์ชัน/การเปรียบเทียบ/กติกา version gate — ใช้ทั้งใน loader (ก่อนโหลด core)
-- และใน Hot Update orchestrator (ตรวจ PRE-STAGE ขั้น version gate §3.6)
--
--   รูปแบบเวอร์ชัน: "MAJOR.MINOR.PATCH" (อาจมี "v" นำหน้า) — เช่น "0.3.0"
--   ไม่รองรับ pre-release (-beta ฯลฯ) ในเฟส 0 — ปฏิเสธชัด ๆ ไม่เดา
--
--   กติกา gate (§7.1 + §7.4):
--     - ไฟล์เก่ากว่า manifest ปัจจุบัน = ปฏิเสธโดยเด็ดขาด (บทเรียน CDN ค้าง v2.1)
--     - channel "stable"  = อัปเกรดอย่างเดียว ห้ามลดเวอร์ชัน
--     - channel "rollback" = ยอมรับการลดเวอร์ชัน (เมื่อรุ่นใหม่มีปัญหา ชี้กลับรุ่นก่อน)
--     - minLoaderVersion   = ถ้ารุ่นใหม่ต้องการ loader ใหม่กว่าที่ผู้ใช้มี
--                            → บอกผู้ใช้ชัดเจน ไม่พังเงียบ ๆ
--
-- ไฟล์นี้ self-contained (ไม่ require อะไร) — build ฝังลง loader.lua ได้ทันที
-- ============================================================================

local Version = {}

Version.VERSION = "0.3.0"

--- parse("0.3.0") → {major=0, minor=3, patch=0} หรือ (nil, err)
function Version.parse(s)
  if type(s) ~= "string" then
    return nil, ("version ต้องเป็น string (ได้ %s)"):format(tostring(s))
  end
  local t = s:match("^v?(%d+)%.(%d+)%.(%d+)%s*$")
  if not t then
    local m = s:match("^v?(%d+)%.(%d+)%.(%d+)%-")
    if m then
      return nil, ("เวอร์ชัน %q มี pre-release — ยังไม่รองรับในเฟส 0 (ใช้ x.y.z เท่านั้น)"):format(s)
    end
    return nil, ("เวอร์ชัน %q ไม่ใช่รูปแบบ MAJOR.MINOR.PATCH"):format(s)
  end
  local a, b, c = s:match("^v?(%d+)%.(%d+)%.(%d+)%s*$")
  return { major = tonumber(a), minor = tonumber(b), patch = tonumber(c) }
end

--- คืน string จาก table เวอร์ชัน (ใช้ในข้อความรายงาน)
function Version.stringify(v)
  if type(v) == "string" then return v end
  if type(v) == "table" then
    return ("%d.%d.%d"):format(v.major or 0, v.minor or 0, v.patch or 0)
  end
  return tostring(v)
end

--- compare("0.3.0", "0.4.0") → -1 | 0 | 1  — ตัวใดไม่ parse ได้ = error ชัด (ไม่เดา)
function Version.compare(a, b)
  local va, ea = Version.parse(a)
  if not va then error(("Version.compare: a ผิดรูปแบบ (%s)"):format(tostring(ea)), 2) end
  local vb, eb = Version.parse(b)
  if not vb then error(("Version.compare: b ผิดรูปแบบ (%s)"):format(tostring(eb)), 2) end
  if va.major ~= vb.major then return va.major < vb.major and -1 or 1 end
  if va.minor ~= vb.minor then return va.minor < vb.minor and -1 or 1 end
  if va.patch ~= vb.patch then return va.patch < vb.patch and -1 or 1 end
  return 0
end

function Version.eq(a, b) return Version.compare(a, b) == 0 end
function Version.lt(a, b) return Version.compare(a, b) < 0 end
function Version.gt(a, b) return Version.compare(a, b) > 0 end

--- ตรวจ minLoaderVersion — คืน (ok, message)
--- ok=false = loader ผู้ใช้เก่าเกินไปสำหรับ manifest นี้ → message เป็นภาษาไทยชัดเจน
function Version.checkMinLoader(manifestMin, loaderVersion)
  if manifestMin == nil or manifestMin == "" then
    return true, nil
  end
  local ok, err = pcall(Version.compare, manifestMin, loaderVersion)
  if not ok then
    return false, ("manifest ระบุ minLoaderVersion ผิดรูปแบบ (%s): %s"):format(
      tostring(manifestMin), tostring(err))
  end
  if Version.gt(manifestMin, loaderVersion) then
    return false, ("รุ่นใหม่นี้ต้องการ loader v%s ขึ้นไป แต่ตัวคุณเป็น v%s — "
      .. "กรุณารัน loader ล่าสุดจากแหล่งที่เผยแพร่ (The Voider รองรับ Volt เท่านั้น)")
      :format(Version.stringify(manifestMin), Version.stringify(loaderVersion))
  end
  return true, nil
end

--- คำตัดสินของ version gate — ใช้ทั้ง loader ตอน DETECT และ updater ตอน PRE-STAGE
--- opts = { manifestVersion, activeVersion (nil = ยังไม่มีระบบเดิม เช่น boot ครั้งแรก),
---           channel = manifest.channel ("stable"|"rollback") }
--- คืน decision: "update" | "noop" | "reject-downgrade"
---   + detail เป็นภาษาไทย (ไปแสดงผู้ใช้/บันทึก log)
function Version.gate(opts)
  opts = opts or {}
  local mv = opts.manifestVersion
  local av = opts.activeVersion
  local channel = opts.channel or "stable"

  -- ยังไม่มีระบบเดิม (boot ครั้งแรก) = รับได้ทุกกรณีที่ manifest สมเหตุสมผล
  if not av then
    return "update", "boot ครั้งแรก — ติดตั้งรุ่น " .. Version.stringify(mv)
  end

  local cmp = Version.compare(mv, av)
  if cmp > 0 then
    return "update", ("พบรุ่นใหม่: %s → %s"):format(Version.stringify(av), Version.stringify(mv))
  end
  if cmp == 0 then
    return "noop", ("รุ่นล่าสุดแล้ว (%s)"):format(Version.stringify(mv))
  end

  -- รุ่นเก่ากว่า — ดู channel
  if channel == "rollback" then
    return "update", ("manifest ชี้กลับรุ่นก่อน (channel=rollback): %s → %s")
      :format(Version.stringify(av), Version.stringify(mv))
  end
  return "reject-downgrade", ("ปฏิเสธไฟล์เก่า: manifest เป็น v%s แต่ระบบกำลังรัน v%s "
    .. "(channel=%s ไม่อนุญาตการลดเวอร์ชัน — Version Gate §7.1)")
    :format(Version.stringify(mv), Version.stringify(av), tostring(channel))
end

return Version

  end)();
  __TV_EMBED['version'] = __m;
end
-- ==== embedded: sha256 (core/runtime/sha256.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/sha256.lua (loader-domain §7.2)
--
-- SHA-256 สามระดับตามแผน §7.2 (บอกตามจริง ไม่อวดอ้าง):
--   ระดับ 1 "crypto-api" : executor มี crypto API (crypto.hash / syn.crypt.hash)
--                           และผ่าน Known-Answer Test — ใช้ของมัน
--   ระดับ 2 "software"   : pure-Lua SHA-256 (ไฟล์นี้) — ใช้เมื่อไม่มี crypto API
--                           และ hash จบภายในงบเวลา (วัดจริงทุกครั้ง §9.1)
--   ระดับ 3 "level2"     : version + size + header marker (ช้าเกินงบ = ตกมาที่ระดับนี้
--                           และรายงาน "ตรวจระดับพื้นฐาน" ตามความจริง)
--
-- การเลือกชุด op ตาม environment: bit32 (Luau/Volt) → bit (LuaJIT) →
--   ตาราง byte 8-bit (256x256) สำหรับ AND/OR/XOR + เลขคณิตล้วนสำหรับ
--   ADD/SHR/ROTR/NOT — ไม่ใช้ bitwise operator ของ Lua 5.3 (Lua 5.1 parser
--   ไม่รองรับ → ไฟล์จะพังตอน parse ทั้งไฟล์ ถ้าอยู่บน executor 5.1)
--
-- Known-Answer Test ชุดเดียวกับ core/runtime/capability.lua:
--   sha256("TheVoider-KAT") = a0c4fa5d1b78...196b4ee (ตรวจกับ python hashlib แล้ว)
--
-- ไฟล์นี้ self-contained — build ฝังลง loader.lua ได้ทันที
-- ============================================================================

local Sha256 = {}

Sha256.VERSION = "0.3.0"

-- ---- ค่าคงที่ของ SHA-256 (FIPS 180-4) --------------------------------------
-- IMPORTANT: เขียนเป็นฐานสิบเท่านั้น — hex literal เกิน 0x7fffffff ในบาง runtime
-- (fengari) ถูก parse เป็นค่าติดลบ (BUG-016) — ฐานสิบปลอดภัยทุก runtime

local K = {
  1116352408, 1899447441, 3049323471, 3921009573,  961987163, 1508970993, 2453635748, 2870763221,
  3624381080,  310598401,  607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580,
  3835390401, 4022224774,  264347078,  604807628,  770255983, 1249150122, 1555081692, 1996064986,
  2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711,  113926993,  338241895,
   666307205,  773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037,
  2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909,  275423344,
   430227734,  506948616,  659060556,  883997877,  958139571, 1322822218, 1537002063, 1747873779,
  1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298,
}

local H0 = {
  1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924,  528734635, 1541459225,
}

local MOD = 4294967296.0 -- 2^32 (float เสมอ: fengari ทำ integer arithmetic แบบ wrap ที่ 2^31 — BUG-016b)
local floor = math.floor

-- ---- เลือกชุด op ตาม environment --------------------------------------------

local bor, band, bxor, bnot, rshift
local opsReady = false

local function initBit32()
  local b = (type(bit32) == "table" and bit32) or rawget(_G, "bit32") -- VoltCompat
  if type(b) == "table" and type(b.bor) == "function"
    and type(b.band) == "function" and type(b.bxor) == "function" then
    bor, band, bxor = b.bor, b.band, b.bxor
    bnot = b.bnot
    rshift = function(x, n) return b.rshift(x, n) end
    return true
  end
  return false
end

local function initBitLib()
  local b = (type(bit) == "table" and bit) or rawget(_G, "bit") -- VoltCompat
  if type(b) == "table" and type(b.bor) == "function"
    and type(b.band) == "function" and type(b.bxor) == "function" then
    bor, band, bxor = b.bor, b.band, b.bxor
    bnot = function(x) return b.bxor(x, 0xFFFFFFFF) end
    rshift = function(x, n) return b.rshift(x, n) end
    return true
  end
  return false
end

-- ตาราง byte 8-bit (256 x 256) สำหรับ AND/OR/XOR — สร้างครั้งเดียวเมื่อจำเป็น
local T_X, T_A, T_O

local function buildTables()
  T_X, T_A, T_O = {}, {}, {}
  for i = 0, 255 do
    local xi, ai, oi = {}, {}, {}
    for j = 0, 255 do
      local p, q, bitv, andv, xorv = i, j, 1, 0, 0
      while p > 0 or q > 0 do
        local pb, qb = p % 2, q % 2
        if pb == 1 and qb == 1 then andv = andv + bitv end
        if pb ~= qb then xorv = xorv + bitv end
        p = floor(p / 2)
        q = floor(q / 2)
        bitv = bitv * 2
      end
      xi[j + 1] = xorv
      ai[j + 1] = andv
      oi[j + 1] = i + j - andv -- OR = a + b - AND
    end
    T_X[i + 1] = xi
    T_A[i + 1] = ai
    T_O[i + 1] = oi
  end
end

local function initArith()
  if not T_X then buildTables() end
  bor = function(a, b)
    if a == 0 then return b end
    if b == 0 then return a end
    local a1, a2, a3 = a % 256, floor(a / 256) % 256, floor(a / 65536) % 256
    local b1, b2, b3 = b % 256, floor(b / 256) % 256, floor(b / 65536) % 256
    return T_O[a1 + 1][b1 + 1]
      + T_O[a2 + 1][b2 + 1] * 256.0
      + T_O[a3 + 1][b3 + 1] * 65536.0
      + T_O[floor(a / 16777216) + 1][floor(b / 16777216) + 1] * 16777216.0
  end
  band = function(a, b)
    if a == 0 or b == 0 then return 0 end
    local a1, a2, a3 = a % 256, floor(a / 256) % 256, floor(a / 65536) % 256
    local b1, b2, b3 = b % 256, floor(b / 256) % 256, floor(b / 65536) % 256
    return T_A[a1 + 1][b1 + 1]
      + T_A[a2 + 1][b2 + 1] * 256.0
      + T_A[a3 + 1][b3 + 1] * 65536.0
      + T_A[floor(a / 16777216) + 1][floor(b / 16777216) + 1] * 16777216.0
  end
  bxor = function(a, b)
    if a == 0 then return b end
    if b == 0 then return a end
    local a1, a2, a3 = a % 256, floor(a / 256) % 256, floor(a / 65536) % 256
    local b1, b2, b3 = b % 256, floor(b / 256) % 256, floor(b / 65536) % 256
    return T_X[a1 + 1][b1 + 1]
      + T_X[a2 + 1][b2 + 1] * 256.0
      + T_X[a3 + 1][b3 + 1] * 65536.0
      + T_X[floor(a / 16777216) + 1][floor(b / 16777216) + 1] * 16777216.0
  end
  bnot = function(x) return 4294967295.0 - x end
  rshift = function(x, n) return floor(x / (2 ^ n)) end
  return true
end

local function ensureOps()
  if opsReady then return end
  opsReady = true
  if not initBit32() and not initBitLib() then
    initArith()
  end
end

-- ROTR แบบเลขคณิตล้วน (ไม่พึ่งตาราง — ใช้ได้ทุกโหมด)
local function rotr(x, n)
  local dn = 2 ^ n
  local hi = floor(x / dn)
  local lo = x % dn
  return hi + lo * (2 ^ (32 - n))
end

-- ---- hex -------------------------------------------------------------------

local HEXCHARS = "0123456789abcdef"
local function toHex32(v)
  local out = {}
  for i = 8, 1, -1 do
    local nib = v % 16
    out[i] = HEXCHARS:sub(nib + 1, nib + 1)
    v = floor(v / 16)
  end
  return table.concat(out)
end

-- ---- แกนกลาง: hash ข้อความ (string) → 64 hex ตัวพิมพ์เล็ก -------------------

local W = {}

local function hashBlock(bytes, off, h1, h2, h3, h4, h5, h6, h7, h8)
  local i
  for i = 1, 16 do
    local j = off + (i - 1) * 4
    W[i] = bytes[j] * 16777216.0 + bytes[j + 1] * 65536.0 + bytes[j + 2] * 256.0 + bytes[j + 3]
  end
  for i = 17, 64 do
    local w15, w2 = W[i - 15], W[i - 2]
    local s0 = bxor(bxor(rotr(w15, 7), rotr(w15, 18)), rshift(w15, 3))
    local s1 = bxor(bxor(rotr(w2, 17), rotr(w2, 19)), rshift(w2, 10))
    W[i] = (W[i - 16] + s0 + W[i - 7] + s1) % MOD
  end
  local a, b, c, d, e, f, g, hh = h1, h2, h3, h4, h5, h6, h7, h8
  for i = 1, 64 do
    local S1 = bxor(bxor(rotr(e, 6), rotr(e, 11)), rotr(e, 25))
    local ch = bxor(band(e, f), band(bnot(e), g))
    local t1 = (hh + S1 + ch + K[i] + W[i]) % MOD
    local S0 = bxor(bxor(rotr(a, 2), rotr(a, 13)), rotr(a, 22))
    local maj = bxor(bxor(band(a, b), band(a, c)), band(b, c))
    local t2 = S0 + maj
    hh = g; g = f; f = e
    e = (d + t1) % MOD
    d = c; c = b; b = a
    a = (t1 + t2) % MOD
  end
  return
    (h1 + a) % MOD, (h2 + b) % MOD, (h3 + c) % MOD, (h4 + d) % MOD,
    (h5 + e) % MOD, (h6 + f) % MOD, (h7 + g) % MOD, (h8 + hh) % MOD
end

function Sha256.hex(msg)
  if type(msg) ~= "string" then
    error("Sha256.hex(msg): msg ต้องเป็น string (ได้ " .. type(msg) .. ")", 2)
  end
  ensureOps()

  local len = #msg
  local bitLen = len * 8
  local lenHi = floor(bitLen / MOD)
  local lenLo = bitLen % MOD

  -- สร้าง padded byte array: msg + 0x80 + ศูนย์ + 8 ไบต์ความยาว (BE)
  local bytes = {}
  local n = 0
  local idx
  for idx = 1, len do
    n = n + 1
    bytes[n] = string.byte(msg, idx)
  end
  n = n + 1
  bytes[n] = 0x80
  while n % 64 ~= 56 do
    n = n + 1
    bytes[n] = 0
  end
  -- ความยาว 64-bit BE: 4 ไบต์บน (lenHi) + 4 ไบต์ล่าง (lenLo)
  bytes[n + 1] = floor(lenHi / 16777216.0) % 256
  bytes[n + 2] = floor(lenHi / 65536.0) % 256
  bytes[n + 3] = floor(lenHi / 256.0) % 256
  bytes[n + 4] = lenHi % 256
  bytes[n + 5] = floor(lenLo / 16777216.0) % 256
  bytes[n + 6] = floor(lenLo / 65536.0) % 256
  bytes[n + 7] = floor(lenLo / 256.0) % 256
  bytes[n + 8] = lenLo % 256

  local h1, h2, h3, h4, h5, h6, h7, h8 =
    H0[1], H0[2], H0[3], H0[4], H0[5], H0[6], H0[7], H0[8]
  local off = 1
  while off <= n do
    h1, h2, h3, h4, h5, h6, h7, h8 =
      hashBlock(bytes, off, h1, h2, h3, h4, h5, h6, h7, h8)
    off = off + 64
  end

  return toHex32(h1) .. toHex32(h2) .. toHex32(h3) .. toHex32(h4)
    .. toHex32(h5) .. toHex32(h6) .. toHex32(h7) .. toHex32(h8)
end

-- ชื่อเดียวกัน (โหมดซอฟต์แวร์ §7.2) — ให้ caller อ่านออกง่าย
Sha256.software = Sha256.hex

-- ---- ระดับ 1: crypto API ของ executor (มีหรือไม่ + ใช้ได้จริงไหม) ----------

-- รูปแบบที่รองรับ (เรียงตามความนิยม) — KAT เดียวกับ capability.lua
Sha256.KAT_INPUT = "TheVoider-KAT"
Sha256.KAT_DIGEST = "a0c4fa5d1b78ce13eb7d6bc3309f6b0009b06b3ce0412a8e9612aecdc196b4ee"

local function cryptoForms(env)
  local forms = {}
  local crypto = rawget(env, "crypto")
  if type(crypto) == "table" and type(crypto.hash) == "function" then
    forms[#forms + 1] = { name = "crypto.hash(algo, s)", fn = function(s) return crypto.hash("sha256", s) end }
    forms[#forms + 1] = { name = "crypto.hash(s, algo)", fn = function(s) return crypto.hash(s, "sha256") end }
  end
  local syn = rawget(env, "syn")
  if type(syn) == "table" and type(syn.crypt) == "table" and type(syn.crypt.hash) == "function" then
    forms[#forms + 1] = { name = "syn.crypt.hash(algo, s)", fn = function(s) return syn.crypt.hash("sha256", s) end }
    forms[#forms + 1] = { name = "syn.crypt.hash(s, algo)", fn = function(s) return syn.crypt.hash(s, "sha256") end }
  end
  return forms
end

local function digestOk(v)
  return type(v) == "string" and #v == 64 and v:match("^[%x]+$") ~= nil
end

--- หา crypto API ที่ hash ได้ถูกต้องจริง (KAT) — คืน (apiName, hashFn) หรือ (nil, เหตุผล)
--- ผ่าน KAT เท่านั้น — API ที่ตอบค่าผิด/พัง = ไม่ใช้ (ป้องกัน "มีชื่อแต่ใช้ไม่ได้")
function Sha256.probe(env)
  env = env or _G
  local forms = cryptoForms(env)
  for _, f in ipairs(forms) do
    local ok, v = pcall(f.fn, Sha256.KAT_INPUT)
    if ok and digestOk(v) then
      local dv = v:lower()
      if dv == Sha256.KAT_DIGEST then
        return f.name, f.fn
      end
    end
  end
  if #forms == 0 then
    return nil, "ไม่มี crypto API ที่รู้จัก"
  end
  return nil, "มี crypto API แต่ไม่ผ่าน Known-Answer Test (ใช้ hash จริงไม่ได้)"
end

--- hash ผ่าน crypto API ที่ผ่าน KAT แล้ว — คืน (hex, apiName) หรือ (nil, เหตุผล)
function Sha256.cryptoHex(env, msg)
  env = env or _G
  local name, fn = Sha256.probe(env)
  if not name then
    return nil, name == nil and "no-crypto" or name
  end
  local ok, v = pcall(fn, msg)
  if not ok then
    return nil, ("crypto API พังกลางทาง: " .. tostring(v))
  end
  if not digestOk(v) then
    return nil, "crypto API ตอบค่าไม่ใช่ 64-hex"
  end
  return v:lower(), name
end

-- ---- self-test (ใช้ใน L1 + SELFCHECK ย่อยได้) --------------------------------

Sha256.KAT_VECTORS = {
  { input = "", digest = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" },
  { input = "abc", digest = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad" },
  { input = "TheVoider-KAT", digest = "a0c4fa5d1b78ce13eb7d6bc3309f6b0009b06b3ce0412a8e9612aecdc196b4ee" },
}

--- รัน KAT 3 ตัวด้วยโหมดซอฟต์แวร์ — คืน (ok, detail)
function Sha256.selfTest()
  for _, v in ipairs(Sha256.KAT_VECTORS) do
    local got = Sha256.hex(v.input)
    if got ~= v.digest then
      return false, ("KAT ไม่ผ่าน: sha256(%q)\n  อยากได้ %s\n  ได้จริง    %s")
        :format(v.input, v.digest, got)
    end
  end
  return true, "KAT ผ่านครบ 3 ตัว (โหมดซอฟต์แวร์)"
end

return Sha256

  end)();
  __TV_EMBED['sha256'] = __m;
end
-- ==== embedded: json (core/foundation/json.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/foundation/json.lua
-- JSON codec ขนาดเล็กเขียนเอง (ใช้กับ ConfigService §3.7)
--
--   เหตุผลที่เขียนเอง: ต้องคุมพฤติกรรม encode/decode 100% (round-trip ตรงเป๊ะ
--   ทดสอบด้วย L1) และต้องรันได้ทั้งบน Volt และในชุดทดสอบ (fengari) โดยไม่
--   พึ่ง HttpService ของเกม (ผ่าน Game Adapter เท่านั้น — แต่ config โหลดก่อน
--   adapter พร้อม จึงต้องไม่ depend ต่อกัน §3.10)
--
--   รองรับ: null / boolean / number / string / array / object (ซ้อนกี่ชั้นก็ได้)
--   ปฏิเสธ: function / userdata / thread / key ที่ไม่ใช่ string / table ผสม
--           array+object คลุมเครือ / NaN / Inf — ทั้งหมด error พร้อม path
--           (config เสียต้อง "รู้ตัว" ตั้งแต่ตอน encode — ไม่ใช่เงียบ ๆ §3.9 ข้อ 5)
--
--   สัญญา round-trip: Decode(Encode(t)) == t (deep equal) สำหรับข้อมูลธรรมดา
--   ทุกชนิดที่รองรับ — มี L1 พิสูจน์ทุกชนิด
-- ============================================================================

local Json = {}

Json.VERSION = "0.2.0"

local INF = math.huge

-- ---- encode ---------------------------------------------------------------

local function encodeString(s, out)
  table.insert(out, "\"")
  -- escape ตัวที่ JSON บังคับ + ควบคุมอื่น ๆ (เขียนเป็น \u00XX เพื่อไฟล์สะอาด)
  local buf = {}
  for i = 1, #s do
    local c = s:sub(i, i)
    local b = s:byte(i)
    if c == "\"" then buf[#buf + 1] = "\\\""
    elseif c == "\\" then buf[#buf + 1] = "\\\\"
    elseif c == "\n" then buf[#buf + 1] = "\\n"
    elseif c == "\r" then buf[#buf + 1] = "\\r"
    elseif c == "\t" then buf[#buf + 1] = "\\t"
    elseif b < 32 then
      buf[#buf + 1] = ("\\u%04x"):format(b)
    else
      buf[#buf + 1] = c
    end
  end
  table.insert(out, table.concat(buf))
  table.insert(out, "\"")
end

local function encodeValue(v, out, path)
  local t = type(v)
  if v == nil then
    table.insert(out, "null")
  elseif t == "boolean" then
    table.insert(out, v and "true" or "false")
  elseif t == "number" then
    if v ~= v or v == INF or v == -INF then
      error(("Json.encode: เลข %s ที่ path %s เก็บไม่ได้ (NaN/Inf ต้องเป็น string แทน)")
        :format(tostring(v), path), 0)
    end
    -- จำนวนเต็มพิมพ์ไม่มี .0 (อ่านกลับได้ค่าเดิมเป๊ะด้วย tonumber)
    if math.floor(v) == v and math.abs(v) < 1e15 then
      table.insert(out, ("%d"):format(v))
    else
      table.insert(out, tostring(v))
    end
  elseif t == "string" then
    encodeString(v, out)
  elseif t == "table" then
    -- แยก array / object / ผสมคลุมเครือ
    local n = #v
    local hasOther = false
    for k in pairs(v) do
      if type(k) ~= "number" or k < 1 or k > n or math.floor(k) ~= k then
        hasOther = true
        break
      end
    end
    if n > 0 and hasOther then
      error(("Json.encode: table ที่ path %s ผสม array + key อื่น — แยกให้ชัดก่อนเก็บ"):format(path), 0)
    end
    if n > 0 then
      table.insert(out, "[")
      for i = 1, n do
        if i > 1 then table.insert(out, ",") end
        encodeValue(v[i], out, ("%s[%d]"):format(path, i))
      end
      table.insert(out, "]")
    else
      table.insert(out, "{")
      local first = true
      -- เรียง key เพื่อ output เสถียร (diff ได้ / md5 ตรงกัน)
      local keys = {}
      for k in pairs(v) do
        if type(k) ~= "string" then
          error(("Json.encode: key ที่ path %s ไม่ใช่ string (ได้ %s) — ห้ามใช้ key ตัวเลข/boolean ใน object")
            :format(path, type(k)), 0)
        end
        keys[#keys + 1] = k
      end
      table.sort(keys)
      for _, k in ipairs(keys) do
        if v[k] ~= nil then -- nil = ไม่เขียน (เหมือนไม่มี)
          if not first then table.insert(out, ",") end
          first = false
          encodeString(k, out)
          table.insert(out, ":")
          encodeValue(v[k], out, path == "" and k or (path .. "." .. k))
        end
      end
      table.insert(out, "}")
    end
  else
    error(("Json.encode: ค่าชนิด %s ที่ path %s เก็บใน config ไม่ได้ (อนุญาตเฉพาะข้อมูลธรรมดา)")
      :format(t, path), 0)
  end
end

--- ตาราง → สตริง JSON (key เรียงเสถียร)
function Json.encode(v)
  local out = {}
  encodeValue(v, out, "")
  return table.concat(out)
end

-- ---- decode ----------------------------------------------------------------

local Decoder = {}
Decoder.__index = Decoder

function Decoder.new(s)
  return setmetatable({ s = s, i = 1, depth = 0 }, Decoder)
end

function Decoder:err(msg)
  -- บอกตำแหน่ง + ตัวอักษรรอบข้าง เพื่อแก้ไฟล์ config มือได้ง่าย
  local around = self.s:sub(math.max(1, self.i - 12), self.i + 12)
  error(("Json.decode: %s (ที่ตำแหน่ง %d, ใกล้ ๆ: %q)"):format(msg, self.i, around), 0)
end

function Decoder:peek()
  return self.s:sub(self.i, self.i)
end

function Decoder:skipWs()
  while self.i <= #self.s do
    local c = self.s:sub(self.i, self.i)
    if c == " " or c == "\t" or c == "\n" or c == "\r" then
      self.i = self.i + 1
    else
      break
    end
  end
end

function Decoder:expect(c)
  if self:peek() ~= c then
    self:err(("คาดหวัง '%s'"):format(c))
  end
  self.i = self.i + 1
end

local function utf8Encode(cp)
  -- \uXXXX → UTF-8 (รองรับ surrogate pair จาก caller)
  -- ใช้ arithmetic ล้วน (ไม่ใช้ bitwise operator) เพื่อรันได้ทุกสภาพแวดล้อม:
  -- Luau / Lua 5.3 / Lua 5.1 + LuaJIT — ค่า bit ของเราไม่ซ้อนกันจึงใช้ + แทน | ได้เป๊ะ
  if cp < 0x80 then
    return string.char(cp)
  elseif cp < 0x800 then
    return string.char(0xC0 + math.floor(cp / 64), 0x80 + (cp % 64))
  elseif cp < 0x10000 then
    return string.char(
      0xE0 + math.floor(cp / 4096),
      0x80 + (math.floor(cp / 64) % 64),
      0x80 + (cp % 64)
    )
  else
    return string.char(
      0xF0 + math.floor(cp / 262144),
      0x80 + (math.floor(cp / 4096) % 64),
      0x80 + (math.floor(cp / 64) % 64),
      0x80 + (cp % 64)
    )
  end
end

function Decoder:decodeString()
  self:expect("\"")
  local buf = {}
  while true do
    local c = self:peek()
    if c == "" then
      self:err("string ไม่ปิด (ไม่มีเครื่องหมาย \")")
    elseif c == "\"" then
      self.i = self.i + 1
      return table.concat(buf)
    elseif c == "\\" then
      self.i = self.i + 1
      local e = self:peek()
      if e == "\"" then buf[#buf + 1] = "\""
      elseif e == "\\" then buf[#buf + 1] = "\\"
      elseif e == "/" then buf[#buf + 1] = "/"
      elseif e == "b" then buf[#buf + 1] = "\b"
      elseif e == "f" then buf[#buf + 1] = "\f"
      elseif e == "n" then buf[#buf + 1] = "\n"
      elseif e == "r" then buf[#buf + 1] = "\r"
      elseif e == "t" then buf[#buf + 1] = "\t"
      elseif e == "u" then
        local hex = self.s:sub(self.i + 1, self.i + 4)
        if not hex:match("^%x%x%x%x$") then
          self:err("\\u ต้องตามด้วยเลขฐานสิบหก 4 ตัว")
        end
        self.i = self.i + 4
        local cp = tonumber(hex, 16)
        -- surrogate pair (D800-DBFF ตามด้วย DC00-DFFF)
        if cp >= 0xD800 and cp <= 0xDBFF then
          if self.s:sub(self.i + 1, self.i + 2) ~= "\\u" then
            self:err("surrogate ไม่ครบคู่")
          end
          local hex2 = self.s:sub(self.i + 3, self.i + 6)
          if not hex2:match("^%x%x%x%x$") then
            self:err("\\u ที่สองต้องเป็นเลขฐานสิบหก 4 ตัว")
          end
          local low = tonumber(hex2, 16)
          if low < 0xDC00 or low > 0xDFFF then
            self:err("surrogate คู่ที่สองไม่ถูกต้อง")
          end
          self.i = self.i + 6
          cp = 0x10000 + ((cp - 0xD800) * 1024) + (low - 0xDC00)
        elseif cp >= 0xDC00 and cp <= 0xDFFF then
          self:err("surrogate ตัวเดียวไม่ใช้ได้")
        end
        buf[#buf + 1] = utf8Encode(cp)
      else
        self:err(("escape ไม่รู้จัก: \\%s"):format(e))
      end
      self.i = self.i + 1
    else
      buf[#buf + 1] = c
      self.i = self.i + 1
    end
  end
end

function Decoder:decodeNumber()
  local start = self.i
  local s = self.s
  -- ตัวเลข JSON: -?(0|[1-9]\d*)(\.\d+)?([eE][+-]?\d+)?
  if s:sub(self.i, self.i) == "-" then self.i = self.i + 1 end
  local digits = s:match("^%d+", self.i)
  if not digits then self:err("ตัวเลขไม่ถูกต้อง") end
  if digits:len() > 1 and digits:sub(1, 1) == "0" then
    self:err("ตัวเลขขึ้นต้น 0 ตามด้วยตัวเลขไม่ได้ (ตามสเปค JSON)")
  end
  self.i = self.i + #digits
  if s:sub(self.i, self.i) == "." then
    self.i = self.i + 1
    local frac = s:match("^%d+", self.i)
    if not frac then self:err("ทศนิยมไม่มีตัวเลขหลังจุด") end
    self.i = self.i + #frac
  end
  local c = s:sub(self.i, self.i)
  if c == "e" or c == "E" then
    self.i = self.i + 1
    c = s:sub(self.i, self.i)
    if c == "+" or c == "-" then self.i = self.i + 1 end
    local exp = s:match("^%d+", self.i)
    if not exp then self:err("เลขชี้กำลังไม่มีตัวเลข") end
    self.i = self.i + #exp
  end
  local num = tonumber(s:sub(start, self.i - 1))
  if not num then self:err("ตัวเลขกลายเป็น nil หลังแปลง") end
  return num
end

Decoder.MAX_DEPTH = 64

function Decoder:decodeValue()
  self.depth = self.depth + 1
  if self.depth > Decoder.MAX_DEPTH then
    self:err("ซ้อนลึกเกิน 64 ชั้น — config ผิดปกติ")
  end
  self:skipWs()
  local c = self:peek()
  local v
  if c == "{" then
    self.i = self.i + 1
    local obj = {}
    self:skipWs()
    if self:peek() == "}" then
      self.i = self.i + 1
      v = obj
    else
      while true do
        self:skipWs()
        local k = self:decodeString()
        self:skipWs()
        self:expect(":")
        obj[k] = self:decodeValue()
        self:skipWs()
        local sep = self:peek()
        if sep == "," then
          self.i = self.i + 1
        elseif sep == "}" then
          self.i = self.i + 1
          break
        else
          self:err("คาดหวัง ',' หรือ '}' ใน object")
        end
      end
    end
    v = obj
  elseif c == "[" then
    self.i = self.i + 1
    local arr = {}
    self:skipWs()
    if self:peek() == "]" then
      self.i = self.i + 1
      v = arr
    else
      while true do
        arr[#arr + 1] = self:decodeValue()
        self:skipWs()
        local sep = self:peek()
        if sep == "," then
          self.i = self.i + 1
        elseif sep == "]" then
          self.i = self.i + 1
          break
        else
          self:err("คาดหวัง ',' หรือ ']' ใน array")
        end
      end
    end
    v = arr
  elseif c == "\"" then
    v = self:decodeString()
  elseif self.s:sub(self.i, self.i + 3) == "true" then
    self.i = self.i + 4
    v = true
  elseif self.s:sub(self.i, self.i + 4) == "false" then
    self.i = self.i + 5
    v = false
  elseif self.s:sub(self.i, self.i + 3) == "null" then
    self.i = self.i + 4
    v = nil
  elseif c == "-" or c:match("%d") then
    v = self:decodeNumber()
  else
    self:err(("ไม่รู้จักค่าที่ขึ้นต้นด้วย %q"):format(c))
  end
  self.depth = self.depth - 1
  return v
end

--- สตริง JSON → ตาราง (error พร้อมตำแหน่ง — ให้ ConfigService ทำ fallback ต่อ)
function Json.decode(s)
  if type(s) ~= "string" then
    error("Json.decode(s): s ต้องเป็น string", 2)
  end
  local d = Decoder.new(s)
  d:skipWs()
  if d:peek() == "" then
    error("Json.decode: สตริงว่าง", 2)
  end
  local v = d:decodeValue()
  d:skipWs()
  if d.i <= #d.s then
    d:err("มีขยะหลังค่า JSON จบ")
  end
  return v
end

return Json

  end)();
  __TV_EMBED['json'] = __m;
end
-- ==== embedded: manifest (core/runtime/manifest.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/manifest.lua (loader-domain §7.1 + §7.2)
--
-- Manifest รุ่นใหม่ครบชุด (แทน "ขนาด+เวอร์ชัน+md5" ของระบบเก่า):
--
--   {
--     "product": "the-voider",
--     "version": "0.3.0",
--     "releaseId": "r2026-10-01-01",
--     "files": { "the-voider.lua": { "sha256": "<64 hex>", "size": 123456 } },
--     "minLoaderVersion": "0.3.0",
--     "channel": "stable"
--   }
--
--   + Manifest.Verify: ตรวจความถูกต้นฉบับของ source 3 ระดับ (§7.2)
--     "crypto-api" → "software" (วัดเวลาจริง เกินงบ = ตกไประดับถัดไป)
--     → "level2" (version+size+header marker) — บอกตามจริงทุกครั้ง ไม่อวดอ้าง
--
-- dependency: ต้องมี JSON codec — รับผ่าน ctx.json หรือ __TV_PACKAGES.json
--   (ใน L1/L2) หรือ __TV_EMBED.json (ใน loader.lua ที่ build ประกอบแล้ว)
--   ไม่พบ = error ชัด ๆ ทันที (ไม่เดา)
-- ============================================================================

-- หา dependency จาก 3 แหล่ง (test packages → embedded loader → ไม่มี = error)
local function _pkg(name)
  -- NoKey-VoltCompat v1: executor sandboxes (Volt) hide chunk-written
  -- globals from rawget(_G) — plain reads go through the chunk env, so
  -- try them first and keep the original _G lookups as fallbacks.
  local pg = __TV_PACKAGES
  if type(pg) == "table" and pg[name] then return pg[name] end
  local pe = __TV_EMBED
  if type(pe) == "table" and pe[name] then return pe[name] end
  local g = rawget(_G, "__TV_PACKAGES")
  if g and g[name] then return g[name] end
  local e = rawget(_G, "__TV_EMBED")
  if e and e[name] then return e[name] end
  return nil
end

local Version = _pkg("version")
local Sha256 = _pkg("sha256")

local Manifest = {}

Manifest.VERSION = "0.3.0"

Manifest.PRODUCT = "the-voider"
Manifest.CHANNELS = { stable = true, rollback = true }

-- ---- decode + validate ------------------------------------------------------

--- decode JSON string → (m, err) — ผ่าน Validate ให้เสร็จในตัว (decode อย่างเดียวไม่มีใช้)
function Manifest.Decode(jsonStr, ctx)
  ctx = ctx or {}
  local Json = ctx.json or _pkg("json")
  if not Json then
    return nil, "Manifest.Decode: หา JSON codec ไม่ได้ (ctx.json / __TV_PACKAGES.json / __TV_EMBED.json)"
  end
  if type(jsonStr) ~= "string" or #jsonStr == 0 then
    return nil, "manifest ว่างหรือไม่ใช่ string"
  end
  local ok, m = pcall(Json.decode, jsonStr)
  if not ok then
    return nil, ("manifest parse ไม่ผ่าน (JSON): " .. tostring(m))
  end
  if type(m) ~= "table" then
    return nil, "manifest ต้องเป็น JSON object"
  end
  local verr = Manifest.Validate(m, { product = ctx.product })
  if #verr > 0 then
    return nil, "manifest ไม่ผ่านการตรวจ: " .. table.concat(verr, "; ")
  end
  return m
end

--- ตรวจโครง manifest ครบทุกช่องบังคับ (§7.1) — คืนรายการข้อผิดพลาด (ว่าง = ผ่าน)
function Manifest.Validate(m, opts)
  opts = opts or {}
  local wantProduct = opts.product or Manifest.PRODUCT
  local errs = {}

  if type(m) ~= "table" then
    return { "manifest ต้องเป็น table" }
  end

  if m.product ~= wantProduct then
    errs[#errs + 1] = ("product ต้องเป็น %q (ได้ %s)"):format(
      wantProduct, tostring(m.product))
  end

  if Version then
    local pv, perr = Version.parse(m.version)
    if not pv then
      errs[#errs + 1] = ("version ผิดรูปแบบ: %s"):format(tostring(perr))
    end
    local mlv, mlerr
    if m.minLoaderVersion ~= nil and m.minLoaderVersion ~= "" then
      mlv, mlerr = Version.parse(m.minLoaderVersion)
      if not mlv then
        errs[#errs + 1] = ("minLoaderVersion ผิดรูปแบบ: %s"):format(tostring(mlerr))
      end
    else
      errs[#errs + 1] = "minLoaderVersion ขาดหาย (บังคับมีทุก manifest §7.1)"
    end
  else
    if type(m.version) ~= "string" or #m.version == 0 then
      errs[#errs + 1] = "version ต้องเป็น string ไม่ว่าง"
    end
  end

  if type(m.releaseId) ~= "string" or #m.releaseId == 0 then
    errs[#errs + 1] = "releaseId ต้องเป็น string ไม่ว่าง (อ้างราย release เดียว §7.1)"
  end

  if type(m.files) ~= "table" then
    errs[#errs + 1] = "files ต้องเป็น table { [ชื่อไฟล์] = { sha256, size } }"
  else
    local count = 0
    for fname, entry in pairs(m.files) do
      count = count + 1
      if type(fname) ~= "string" or #fname == 0 then
        errs[#errs + 1] = "ชื่อไฟล์ใน files ต้องเป็น string ไม่ว่าง"
      end
      if type(entry) ~= "table" then
        errs[#errs + 1] = ("files[%s]: ต้องเป็น table"):format(tostring(fname))
      else
        if type(entry.sha256) ~= "string"
          or #entry.sha256 ~= 64
          or entry.sha256:match("^[%x]+$") == nil then
          errs[#errs + 1] = ("files[%s].sha256 ต้องเป็น 64 ตัวเลขฐานสิบหก"):format(tostring(fname))
        end
        if type(entry.size) ~= "number"
          or math.floor(entry.size) ~= entry.size
          or entry.size <= 0 then
          errs[#errs + 1] = ("files[%s].size ต้องเป็นจำนวนเต็มบวก"):format(tostring(fname))
        end
      end
    end
    if count == 0 then
      errs[#errs + 1] = "files ว่าง — ต้องมีอย่างน้อย 1 ไฟล์"
    end
  end

  if not Manifest.CHANNELS[m.channel] then
    errs[#errs + 1] = ("channel ต้องเป็น stable|rollback เท่านั้น (ได้ %s)"):format(tostring(m.channel))
  end

  return errs
end

--- สร้าง manifest ใน memory (ใช้ในเทส/สร้างจริงใน build/tools/gen_manifest.py ฝั่ง python)
function Manifest.Build(fields)
  local m = {
    product = fields.product or Manifest.PRODUCT,
    version = fields.version,
    releaseId = fields.releaseId,
    files = fields.files or {},
    minLoaderVersion = fields.minLoaderVersion,
    channel = fields.channel or "stable",
  }
  local errs = Manifest.Validate(m, { product = fields.product })
  if #errs > 0 then
    return nil, "Manifest.Build: " .. table.concat(errs, "; ")
  end
  return m
end

-- ---- Verify: ความถูกต้นฉบับ 3 ระดับ (§7.2) -----------------------------------

-- หา version+releaseId จาก header marker ของ bundle (level 2 ใช้)
-- รูปแบบ marker (build_bundle.py เขียนให้ทุกครั้ง):
--   --[[ TV-BUNDLE version=0.3.0 releaseId=r... ]]
local function headerMarker(source)
  if type(source) ~= "string" then return nil end
  local ver = source:match("%-%-%[%[%s*TV%-BUNDLE%s+version=([%d%.]+)")
  local rid = source:match("releaseId=([%w%-_]+)")
  return ver, rid
end

Manifest.headerMarker = headerMarker

--- ตรวจ source ตรงกับรายการ files[entryName] ของ manifest
--- opts = { clock, softwareBudgetMs (default 1000), env (crypto probe ใช้ — default _G) }
--- คืน { ok, mode, detail, ms, expectedSize, gotSize }
---   mode: "crypto-api" | "software" | "level2"
---   (เลือกให้เองอัตโนมัติตาม §7.2 — รายงานเป็นภาษาไทยตรงไปตรงมา)
function Manifest.Verify(source, entryName, m, opts)
  opts = opts or {}
  local clock = opts.clock or os.clock
  local budgetMs = opts.softwareBudgetMs or 1000
  local entry = (type(m) == "table" and type(m.files) == "table") and m.files[entryName] or nil

  local out = {
    ok = false, mode = nil, detail = nil, ms = 0,
    expectedSize = entry and entry.size or nil,
    gotSize = type(source) == "string" and #source or nil,
  }
  if not entry then
    out.detail = ("manifest ไม่มีไฟล์ชื่อ %q"):format(tostring(entryName))
    return out
  end
  if type(source) ~= "string" or #source == 0 then
    out.detail = "source ว่างหรือไม่ใช่ string"
    return out
  end

  local expected = entry.sha256:lower()

  -- ระดับ 1: crypto API ของ executor (ถ้ามีและผ่าน KAT)
  if Sha256 then
    local hex, apiName = Sha256.cryptoHex(opts.env or _G, source)
    if hex then
      out.mode = "crypto-api"
      out.ms = 0
      if hex == expected then
        out.ok = true
        out.detail = ("ตรวจสอบความถูกต้นฉบับ: เต็มรูปแบบ (SHA-256 ผ่าน %s)"):format(apiName)
      else
        out.detail = ("SHA-256 ไม่ตรง (ผ่าน %s) — ไฟล์เสียหาย/ถูกแปลงกลางทาง"):format(apiName)
      end
      return out
    end
  end

  -- ระดับ 2: pure-Lua SHA-256 — วัดเวลาจริง เกินงบ = ตกไประดับ 3
  if Sha256 then
    local t0 = clock()
    local okH, got = pcall(Sha256.hex, source)
    local ms = (clock() - t0) * 1000
    if okH and ms <= budgetMs then
      out.mode = "software"
      out.ms = ms
      got = got:lower()
      if got == expected then
        out.ok = true
        out.detail = ("ตรวจสอบความถูกต้นฉบับ: เต็มรูปแบบ (โหมดซอฟต์แวร์, %.1f ms)"):format(ms)
      else
        out.detail = "SHA-256 ไม่ตรง (โหมดซอฟต์แวร์) — ไฟล์เสียหาย/ถูกแปลงกลางทาง"
      end
      return out
    end
    -- ช้าเกินงบ (หรือพัง) → ไประดับ 3 พร้อมบอกตามจริง
  end

  -- ระดับ 3: version + size + header marker
  out.mode = "level2"
  if #source ~= entry.size then
    out.detail = ("ตรวจระดับพื้นฐาน (version+size): ขนาดไม่ตรง (อยากได้ %d ได้ %d)")
      :format(entry.size, #source)
    return out
  end
  local ver = headerMarker(source)
  if not ver then
    out.detail = "ตรวจระดับพื้นฐาน (version+size): ไม่พบ header marker ของ bundle"
    return out
  end
  if Version and Version.parse(ver) and m.version and not Version.eq(ver, m.version) then
    out.detail = ("ตรวจระดับพื้นฐาน (version+size): marker v%s ไม่ตรง manifest v%s")
      :format(ver, tostring(m.version))
    return out
  end
  if not Version and tostring(ver) ~= tostring(m.version) then
    out.detail = ("ตรวจระดับพื้นฐาน (version+size): marker v%s ไม่ตรง manifest v%s")
      :format(tostring(ver), tostring(m.version))
  end

  out.ok = true
  out.detail = ("ตรวจระดับพื้นฐาน (version+size) — ระบบนี้ไม่มี crypto API และ "
    .. "SHA-256 โหมดซอฟต์แวร์ไม่จบในงบเวลา จึงตรวจได้เท่าระดับนี้ (บอกตามจริง §7.2)")
  return out
end

return Manifest

  end)();
  __TV_EMBED['manifest'] = __m;
end
-- ==== embedded: update (core/runtime/update.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/update.lua
-- Hot Update Orchestrator (แผน freeze v2.1 §3.6 + R3/R4 + §7.2)
--
-- เจ้าของ protocol ทั้งหมด — อยู่นอกระบบที่ถูกสลับ (loader-domain) จึงรอด
-- จาก TEARDOWN และเป็นคนเดียวที่สลับรุ่นได้:
--
--   การ map กับ 12 ขั้นของแผน §3.6 (ขั้น 1-2 PUBLISH/DETECT อยู่ฝั่งเรา/loader):
--     3  PRE-STAGE   = pre-stage     (validate manifest + version gate + integrity)
--     4  FREEZE      = freeze
--     5  DRAIN       = drain
--     6  SNAPSHOT    = snapshot      (+ ROLLBACK SNAPSHOT 7 ช่อง)
--     7  TEARDOWN    = teardown      (ตาม dependency graph กลับด้าน §3.10)
--     8  VERIFY      = verify        (orphan รวม 4 ชนิด = 0 ไม่ใช่ = ABORT)
--     9  LOAD        = load
--     10 MIGRATE     = migrate       (config ผ่าน Migration chain + state providers)
--     11 RESUME      = resume        (replay ตาม policy: คิวที่ข้าม generation
--                                    มาจาก bus รุ่นเก่า + คิวที่เกิดระหว่าง
--                                    MIGRATE บน bus รุ่นใหม่ — CR-REPLAY-001)
--     12 SELFCHECK   = selfcheck     (+ REPORT)
--     +  ATOMIC RULE (freeze R3) เพิ่มขั้นท้าย: adapter-probe → commit
--
--   ROLLBACK PATHS:
--     F0      PRE-STAGE พัง (validate/gate/integrity) → ยกเลิก ระบบเดิมเดินต่อ
--     F-SNAP  snapshot สร้าง/ตรวจไม่ผ่าน (R4: ตรวจ recover ได้ก่อน TEARDOWN
--             เด็ดขาด) → ABORT ก่อนทำลายอะไร + Resume คิวเดิม
--     F1      VERIFY: orphan > 0                    → ROLLBACK + BUG
--     F2      LOAD หรือ MIGRATE พัง                  → ROLLBACK + BUG
--     F3      SELFCHECK พัง                          → ROLLBACK + BUG
--     F4      ADAPTER PROBE: dead                   → ROLLBACK + BUG
--             (degraded = เดินต่อ + เตือน — ปิดเฉพาะโมดูลที่กระทบตาม §3.3
--              เฟส 0 ยังไม่มีโมดูล จึงเป็นการเตือนพร้อมรายชื่อ impacted)
--     F-ROLLBACK-FAIL  rollback เองกลับพัง → "broken" + แจ้งเสียงดัง (ห้ามเงียบ)
--
--   ATOMIC UPDATE RULE (freeze R3): OLD = active / NEW = staged —
--     ระบบรุ่นใหม่ไม่ได้เป็น active จนกว่า LOAD → MIGRATE → SELFCHECK →
--     ADAPTER PROBE ผ่านครบ (ดู self.active/self.staged ระหว่างดำเนินการ)
--
--   สัญญาของ "system handle" (สร้างโดย core/runtime/bundle.lua):
--     { version, releaseId, runtime R, foundation F, adapter A,
--       bus, config, migration, shutdown, registry, boundary, watchdog,
--       diag, probe (fn → Adapter Health report), providers (ลำดับ),
--       selfChecks (ลำดับ) } — ทั้งหมดเป็น interface สาธารณะเดิมของ
--     Runtime/Foundation/Adapter ไม่มีการแตะภายในหรือแก้ไฟล์เหล่านั้นเลย
--
-- ใช้เฉพาะ interface สาธารณะเดิม (ไม่แก้ไฟล์ที่ผ่าน gate แล้วแม้บรรทัดเดียว
-- — ยกเว้น CR-REPLAY-001 ที่เจ้าของอนุมัติ 1 ต.ค. 2026 ให้เพิ่ม
--   Bus:ExportQueue/ImportQueue ใน eventbus.lua):
--   Bus:Freeze/Resume/Stats/Publish/Declare · Bus:ExportQueue/ImportQueue
--   (CR-REPLAY-001) · Config:Data/Replace ·
--   Migration:Run · Shutdown:Run · Registry:ModuleTotals/VerifyZero/Release ·
--   Watchdog:Stop · probe:Probe · Diag:Mark
-- ============================================================================

local function _pkg(name)
  -- NoKey-VoltCompat v1: executor sandboxes (Volt) hide chunk-written
  -- globals from rawget(_G) — plain reads go through the chunk env, so
  -- try them first and keep the original _G lookups as fallbacks.
  local pg = __TV_PACKAGES
  if type(pg) == "table" and pg[name] then return pg[name] end
  local pe = __TV_EMBED
  if type(pe) == "table" and pe[name] then return pe[name] end
  local g = rawget(_G, "__TV_PACKAGES")
  if g and g[name] then return g[name] end
  local e = rawget(_G, "__TV_EMBED")
  if e and e[name] then return e[name] end
  return nil
end

local Version = _pkg("version")
local Manifest = _pkg("manifest")

local Update = {}

Update.VERSION = "0.3.0"

-- ---- helpers (ภายใน) ---------------------------------------------------------

local function deepClone(v)
  if type(v) ~= "table" then return v end
  local out = {}
  for k, val in pairs(v) do
    out[deepClone(k)] = deepClone(val)
  end
  return out
end

--- เดินตาราง: คืน (ok, ที่พบเจ้าแรก) — ใช้ได้กับ key+value พร้อมกัน
local function walkPlain(t, path)
  path = path or "root"
  if type(t) ~= "table" then
    if type(t) == "function" or type(t) == "userdata" or type(t) == "thread" then
      return false, ("%s เป็น %s (ห้าม — ต้อง serialize ได้)"):format(path, type(t))
    end
    return true, nil
  end
  for k, v in pairs(t) do
    if type(k) ~= "string" and type(k) ~= "number" then
      return false, ("%s.[%s] key ชนิด %s"):format(path, tostring(k), type(k))
    end
    local ok, why = walkPlain(v, ("%s.%s"):format(path, tostring(k)))
    if not ok then return false, why end
  end
  return true, nil
end

local function sumKinds(rows)
  local t = { tasks = 0, connections = 0, renders = 0, temps = 0, total = 0, owners = {} }
  for _, row in ipairs(rows) do
    local o = row.orphan
    if o then
      t.tasks = t.tasks + (o.tasks or 0)
      t.connections = t.connections + (o.connections or 0)
      t.renders = t.renders + (o.renders or 0)
      t.temps = t.temps + (o.temps or 0)
      t.total = t.total + (o.total or 0)
      if o.total and o.total > 0 then
        t.owners[#t.owners + 1] = ("%s (%d ชิ้น)"):format(row.name, o.total)
      end
    end
  end
  return t
end

-- ---- constructor ---------------------------------------------------------------

-- ctx = {
--   loadFn   = function(source, chunkName) -> (execFn, err)   [บังคับ]
--              execFn() จะสร้าง system handle ของรุ่นนั้น (bundle entry)
--   clock    = function() → วินาที (จับเวลา per-step) default os.clock
--   time     = function() → timestamp (ใส่ใน snapshot) default os.time
--   logger   = function(level, msg) — default print
--   onStep   = function(step, info) — จุดสังเกตทุกขั้น (ใช้ในเทสพิสูจน์ atomic)
--   budgetMs = ตัวเลข — งบเวลารวม (default 5000 ตาม §9.1)
--   softwareBudgetMs = งบ hash โหมดซอฟต์แวร์ (default 1000, ส่งต่อให้ Manifest.Verify)
--   loaderVersion = เวอร์ชัน loader ปัจจุบัน (ตรวจ minLoaderVersion อีกชั้น)
--   env      = environment สำหรับ crypto probe (default _G)
-- }
function Update.new(ctx)
  ctx = ctx or {}
  if type(ctx.loadFn) ~= "function" then
    error("Update.new({ loadFn = ... }): ต้องส่ง loadFn(source, chunkName) → (execFn, err)", 2)
  end

  local self = setmetatable({}, { __index = Update })
  self.loadFn = ctx.loadFn
  self.clock = ctx.clock or os.clock
  self.time = ctx.time or os.time
  self.logger = ctx.logger or function(level, msg)
    print(("[The Voider][Update][%s] %s"):format(level, msg))
  end
  self.onStep = ctx.onStep
  self.budgetMs = ctx.budgetMs or 5000
  self.softwareBudgetMs = ctx.softwareBudgetMs or 1000
  self.loaderVersion = ctx.loaderVersion
  self.env = ctx.env or _G

  self.active = nil        -- { system, source, manifest, version, releaseId }
  self.staged = nil        -- { source, manifest, version, releaseId } (ระหว่าง protocol)
  self.rollbackTarget = nil
  self.inFlight = false
  self.broken = nil        -- { message, path, bugId } — rollback ก็พัง
  self.lastResult = nil
  self.lastSnapshot = nil
  self._bugSeq = 0
  return self
end

-- ---- รายงานสถานะ (ใช้ตรวจ atomic + Diagnostics) -------------------------------

function Update:Active()
  if not self.active then return nil end
  return {
    version = self.active.version,
    releaseId = self.active.releaseId,
    system = self.active.system,
  }
end

function Update:Staged()
  if not self.staged then return nil end
  return { version = self.staged.version, releaseId = self.staged.releaseId }
end

function Update:RollbackTarget()
  if not self.rollbackTarget then return nil end
  return { version = self.rollbackTarget.version, releaseId = self.rollbackTarget.releaseId }
end

function Update:Status()
  return {
    active = self:Active() and self:Active().version or nil,
    staged = self:Staged() and self:Staged().version or nil,
    rollbackTarget = self:RollbackTarget() and self:RollbackTarget().version or nil,
    inFlight = self.inFlight,
    broken = self.broken and self.broken.message or nil,
    lastResult = self.lastResult and self.lastResult.path or nil,
  }
end

function Update:LastResult()
  return self.lastResult
end

-- ---- bug id (§11: ไม่มี error ที่ไม่มี Bug ID) --------------------------------

function Update:_nextBugId()
  self._bugSeq = self._bugSeq + 1
  return ("BUG-UPD-%03d"):format(self._bugSeq)
end

-- ---- step bookkeeping ---------------------------------------------------------

local STEP_ORDER = {
  "pre-stage", "freeze", "drain", "snapshot", "snapshot-validate",
  "teardown", "verify", "load", "migrate", "resume", "selfcheck",
  "adapter-probe", "commit",
  "rollback.load", "rollback.migrate", "rollback.resume",
  "rollback.selfcheck", "rollback.adapter-probe", "rollback.commit",
}

function Update:_emit(step, info)
  info = info or {}
  info.step = step
  if self.onStep then
    local ok, err = pcall(self.onStep, step, info)
    if not ok then
      self.logger("warn", ("onStep hook พัง (ขั้น %s): %s"):format(step, tostring(err)))
    end
  end
  return info
end

-- ---- Attach: ระบบที่ boot แล้วมารายงานตัวเป็น active -------------------------

Update.EVENTS = {
  { "update:succeeded", "idempotent" },
  { "update:failed",    "idempotent" },
  { "update:rolledback","idempotent" },
}

function Update:Attach(record)
  record = record or {}
  if self.inFlight then
    error("Update:Attach: กำลังอัปเดตอยู่ (in-flight) — ห้ามเปลี่ยน active กลาง protocol", 2)
  end
  local sys = record.system
  if type(sys) ~= "table"
    or not sys.bus or not sys.config or not sys.migration
    or not sys.shutdown or not sys.registry or not sys.probe then
    error("Update:Attach: system handle ไม่ครบสัญญา (bus/config/migration/shutdown/registry/probe)", 2)
  end
  if type(sys.version) ~= "string" or type(sys.releaseId) ~= "string" then
    error("Update:Attach: system ต้องมี version+releaseId เป็น string", 2)
  end

  -- ประกาศ event ของ update domain บน bus ของระบบนี้ (Declare สาธารณะ —
  -- ไม่แก้ foundation/init.lua) — ตัวที่ไม่ Declare จะถูกนับเป็น undeclared
  for _, ev in ipairs(Update.EVENTS) do
    if sys.bus:Policy(ev[1]) == nil then
      sys.bus:Declare(ev[1], ev[2])
    end
  end

  self.active = {
    system = sys,
    source = record.source,
    manifest = record.manifest,
    version = sys.version,
    releaseId = sys.releaseId,
  }
  self.broken = nil
  return self
end

-- ---- ผลลัพธ์มาตรฐาน -----------------------------------------------------------

function Update:_result(path, opts)
  opts = opts or {}
  local r = {
    ok = opts.ok or false,
    path = path,
    bugId = opts.bugId,
    detail = opts.detail,
    from = opts.from or (self.active and {
      version = self.active.version, releaseId = self.active.releaseId,
    } or nil),
    to = opts.to or (self.staged and {
      version = self.staged.version, releaseId = self.staged.releaseId,
    } or nil),
    rolledBack = opts.rolledBack or false,
    broken = opts.broken or false,
    orphans = opts.orphans,
    replay = opts.replay,
    integrity = opts.integrity,
    snapshot = opts.snapshot,
    warnings = opts.warnings or {},
    timing = opts.timing,
    system = self.active and self.active.system or nil,
  }
  self.lastResult = r
  return r
end

local function finishTiming(self, steps, t0)
  local totalMs = (self.clock() - t0) * 1000
  local overBudget = totalMs > self.budgetMs
  return {
    totalMs = totalMs,
    budgetMs = self.budgetMs,
    overBudget = overBudget,
    steps = steps,
  }, totalMs
end

-- ---- SNAPSHOT: สร้าง + ตรวจ (R4 — ก่อน TEARDOWN เด็ดขาด) ---------------------

function Update:_makeSnapshot()
  local sys = self.active.system
  local snap = {
    version = self.active.version,
    releaseId = self.active.releaseId,
    bundle = self.active.source,
    manifest = deepClone(self.active.manifest),
    moduleStates = {},
    configState = deepClone(sys.config:Data()),
    timestamp = self.time(),
  }
  if snap.configState == nil then
    return nil, "config:Data() คืน nil — จับ snapshot ไม่ได้"
  end
  for _, provider in ipairs(sys.providers or {}) do
    local ok, state = pcall(provider.Serialize, sys)
    if not ok then
      return nil, ("provider %s:Serialize พัง: %s"):format(provider.name, tostring(state))
    end
    local plain, why = walkPlain(state, ("moduleStates.%s"):format(provider.name))
    if not plain then
      return nil, ("provider %s:Serialize คืนค่า serialize ไม่ได้ (%s)"):format(provider.name, why)
    end
    snap.moduleStates[provider.name] = deepClone(state)
  end
  return snap
end

function Update:_validateSnapshot(snap)
  if type(snap) ~= "table" then
    return false, "snapshot ไม่ใช่ table"
  end
  -- ครบ 7 ช่อง (R4) — ตรวจชนิดเข้ม
  if type(snap.version) ~= "string" or #snap.version == 0 then
    return false, "ช่อง version ไม่ใช่ string ที่ไม่ว่าง"
  end
  if type(snap.releaseId) ~= "string" or #snap.releaseId == 0 then
    return false, "ช่อง releaseId ไม่ใช่ string ที่ไม่ว่าง"
  end
  if type(snap.bundle) ~= "string" or #snap.bundle == 0 then
    return false, "ช่อง bundle (โค้ดรุ่นเดิม) ว่าง — โหลดกลับไม่ได้"
  end
  if type(snap.manifest) ~= "table" then
    return false, "ช่อง manifest ไม่ใช่ table"
  end
  if type(snap.moduleStates) ~= "table" then
    return false, "ช่อง moduleStates ไม่ใช่ table"
  end
  if type(snap.configState) ~= "table" then
    return false, "ช่อง configState ไม่ใช่ table"
  end
  if type(snap.timestamp) ~= "number" then
    return false, "ช่อง timestamp ไม่ใช่ number"
  end
  -- ความสอดคล้องภายใน
  if snap.manifest.version ~= nil and snap.manifest.version ~= snap.version then
    return false, ("manifest ใน snapshot เป็น v%s แต่ version เป็น v%s ไม่ตรงกัน")
      :format(tostring(snap.manifest.version), tostring(snap.version))
  end
  if type(snap.configState.schemaVersion) ~= "number" then
    return false, "configState.schemaVersion ไม่ใช่ number"
  end
  -- state ทุกชุดต้อง serialize ได้ (ห้าม function/userdata)
  local plain, why = walkPlain(snap.moduleStates, "moduleStates")
  if not plain then return false, why end
  plain, why = walkPlain(snap.configState, "configState")
  if not plain then return false, why end
  -- recover ได้จริง: โค้ดรุ่นเดิมต้อง compile ผ่าน (ยังไม่ execute —
  -- การ compile ไม่มีผลข้างเคียง)
  local execFn, err = self.loadFn(snap.bundle, "@rollback:" .. tostring(snap.version))
  if not execFn then
    return false, ("โค้ดรุ่นเดิม compile ไม่ผ่าน — recover ไม่ได้: %s"):format(tostring(err))
  end
  return true, nil
end

-- ---- bootstrap ระบบจาก source (ใช้ทั้ง LOAD ปกติและ rollback) ----------------

-- คืน (sys, err) — execFn() ต้องคืน system handle (สัญญาของ bundle entry)
function Update:_execSource(source, chunkName)
  local execFn, err = self.loadFn(source, chunkName)
  if not execFn then
    return nil, ("compile ไม่ผ่าน: %s"):format(tostring(err))
  end
  local ok, sys = pcall(execFn)
  if not ok then
    return nil, ("รัน bundle พัง: %s"):format(tostring(sys))
  end
  if type(sys) ~= "table" or not sys.bus then
    return nil, "bundle ไม่คืน system handle ตามสัญญา"
  end
  return sys
end

-- MIGRATE ระบบเป้าหมายด้วย snapshot ของระบบเก่า (ใช้ทั้ง update และ rollback)
-- คืน (ok, err)
function Update:_migrateSystem(sys, snap)
  -- 1) config: ผ่าน Migration chain ของระบบใหม่เอง → Replace
  local cfg = deepClone(snap.configState)
  local ok, err = pcall(sys.migration.Run, sys.migration, cfg)
  if not ok then
    return false, ("Migration:Run พัง (MIGRATE): %s"):format(tostring(err))
  end
  if type(cfg.schemaVersion) ~= "number" then
    return false, "MIGRATE: config หลัง migration ไม่มี schemaVersion"
  end
  ok, err = pcall(sys.config.Replace, sys.config, cfg)
  if not ok then
    return false, ("Config:Replace พัง (MIGRATE): %s"):format(tostring(err))
  end
  -- 2) state providers ทุกตัว: รับ oldState ของตัวเอง (nil = รุ่นนี้เพิ่มมาใหม่
  --    provider เริ่มจากศูนย์เองตามสัญญา §3.4 MigrateState)
  for _, provider in ipairs(sys.providers or {}) do
    local oldState = snap.moduleStates[provider.name]
    ok, err = pcall(provider.Apply, sys, oldState)
    if not ok then
      return false, ("provider %s:Apply พัง (MIGRATE): %s"):format(provider.name, tostring(err))
    end
  end
  return true, nil
end

-- SELFCHECK: รัน checks ทั้งชุดของระบบเป้าหมาย — คืน (ok, ชื่อ+detail ที่พัง)
-- selfChecks = ลำดับ { name = string, fn = function(sys, ctx) → (ok, detail) } (สัญญาเดียวกับ bundle.lua)
function Update:_selfCheckSystem(sys, purpose, newGen, m)
  for _, check in ipairs(sys.selfChecks or {}) do
    if type(check) ~= "table" or type(check.fn) ~= "function" then
      return false, ("selfCheck %s ไม่ครบสัญญา (ต้องมี fn)"):format(tostring(check and check.name))
    end
    local ok, detail = check.fn(sys, {
      generation = newGen,
      manifest = m,
      purpose = purpose,
    })
    if not ok then
      return false, ("%s: %s"):format(check.name, tostring(detail))
    end
  end
  return true, nil
end

-- ==============================================================================
-- :Apply — protocol หลัก
--
-- newSource = โค้ดรุ่นใหม่ (string)
-- m         = manifest รุ่นใหม่ (table ที่ผ่าน Manifest.Validate แล้ว)
-- opts      = { entryName (default "the-voider.lua"), drainFns = {fn...} }
-- คืน result (ดูรูปทรงด้านบน) — ทุก path มี bugId ยกเว้น OK/NOOP (§11)
-- ==============================================================================

function Update:Apply(newSource, m, opts)
  opts = opts or {}
  local entryName = opts.entryName or "the-voider.lua"

  if self.inFlight then
    error("Update:Apply: มี protocol กำลังเดินอยู่ — ห้ามซ้อน", 2)
  end
  if not self.active then
    error("Update:Apply: ยังไม่มีระบบเดิม — ใช้ loader บูตก่อนแล้ว Attach", 2)
  end

  self.inFlight = true
  local steps = {}
  local t0 = self.clock()
  local warnings = {}

  local function markMs(name, st)
    steps[name] = (self.clock() - st) * 1000
  end

  -- ผลลัพธ์ของ integrity ระดับไหน (รายงานตามจริง §7.2)
  local integrity = nil

  -- ---------------------------------------------------------------- F0 ----
  local st = self.clock()
  self:_emit("pre-stage", { manifestVersion = m and m.version or nil })

  if type(m) ~= "table" then
    self.inFlight = false
    return self:_result("F0", {
      bugId = self:_nextBugId(),
      detail = "manifest ไม่ใช่ table (PRE-STAGE ไม่ผ่าน)",
      timing = finishTiming(self, steps, t0),
    })
  end

  local errs = Manifest and Manifest.Validate(m, {}) or {}
  if #errs > 0 then
    self.inFlight = false
    return self:_result("F0", {
      bugId = self:_nextBugId(),
      detail = "manifest ไม่ผ่านการตรวจ (PRE-STAGE): " .. table.concat(errs, "; "),
      timing = finishTiming(self, steps, t0),
    })
  end

  local gateDecision, gateDetail
  if Version then
    gateDecision, gateDetail = Version.gate({
      manifestVersion = m.version,
      activeVersion = self.active.version,
      channel = m.channel,
    })
  else
    gateDecision = (m.version ~= self.active.version) and "update" or "noop"
    gateDetail = gateDecision
  end

  if gateDecision == "noop" then
    self.inFlight = false
    self:_emit("pre-stage.noop", { detail = gateDetail })
    return self:_result("NOOP", {
      ok = true,
      detail = gateDetail,
      to = { version = m.version, releaseId = m.releaseId },
      timing = finishTiming(self, steps, t0),
    })
  end

  if gateDecision == "reject-downgrade" then
    self.inFlight = false
    return self:_result("F0", {
      bugId = self:_nextBugId(),
      detail = gateDetail .. " (PRE-STAGE: version gate ปฏิเสธ)",
      to = { version = m.version, releaseId = m.releaseId },
      timing = finishTiming(self, steps, t0),
    })
  end

  -- minLoaderVersion (ป้องกันอีกชั้น — loader เองก็ตรวจก่อน fetch)
  if Version and self.loaderVersion and m.minLoaderVersion then
    local okMin, msgMin = Version.checkMinLoader(m.minLoaderVersion, self.loaderVersion)
    if not okMin then
      self.inFlight = false
      return self:_result("F0", {
        bugId = self:_nextBugId(),
        detail = msgMin .. " (PRE-STAGE: minLoaderVersion ไม่ผ่าน)",
        to = { version = m.version, releaseId = m.releaseId },
        timing = finishTiming(self, steps, t0),
      })
    end
  end

  if type(newSource) ~= "string" or #newSource == 0 then
    self.inFlight = false
    return self:_result("F0", {
      bugId = self:_nextBugId(),
      detail = "source รุ่นใหม่ว่าง (PRE-STAGE)",
      to = { version = m.version, releaseId = m.releaseId },
      timing = finishTiming(self, steps, t0),
    })
  end

  integrity = Manifest and Manifest.Verify(newSource, entryName, m, {
    clock = self.clock,
    softwareBudgetMs = self.softwareBudgetMs,
    env = self.env,
  }) or nil
  markMs("pre-stage", st)
  self:_emit("pre-stage.done", { integrity = integrity and integrity.mode })

  if not integrity or not integrity.ok then
    self.inFlight = false
    return self:_result("F0", {
      bugId = self:_nextBugId(),
      detail = (integrity and integrity.detail or "ตรวจความถูกต้นฉบับไม่ได้")
        .. " (PRE-STAGE: integrity ไม่ผ่าน — ระบบเดิมไม่ถูกแตะ)",
      to = { version = m.version, releaseId = m.releaseId },
      integrity = integrity,
      timing = finishTiming(self, steps, t0),
    })
  end

  -- ตรงจุดนี้เท่านั้นที่ระบบเดิมเริ่มถูกแตะ (FREEZE) — F0 ไม่แตะอะไรเลย
  self.staged = {
    source = newSource, manifest = deepClone(m),
    version = m.version, releaseId = m.releaseId,
  }

  -- ------------------------------------------------------------- FREEZE ----
  st = self.clock()
  local oldSys = self.active.system
  local oldStats = oldSys.bus:Stats()
  local newGen = (oldStats.generation or 0) + 1
  oldSys.bus:Freeze(newGen)
  markMs("freeze", st)
  self:_emit("freeze", { generation = newGen, queuedBefore = oldStats.queued })

  -- -------------------------------------------------------------- DRAIN ----
  st = self.clock()
  for _, fn in ipairs(opts.drainFns or {}) do
    local ok, err = pcall(fn)
    if not ok then
      self.logger("warn", ("drain hook พัง (ข้าม): %s"):format(tostring(err)))
    end
  end
  markMs("drain", st)
  self:_emit("drain", { hooks = #(opts.drainFns or {}) })

  -- ------------------------------------------------------------ SNAPSHOT ----
  st = self.clock()
  self:_emit("snapshot")
  local snap, snapErr = self:_makeSnapshot()
  markMs("snapshot", st)

  -- ----------------------------------------------------- SNAPSHOT-VALIDATE --
  -- R4: สร้างเสร็จ + ตรวจว่า recover ได้จริง "ก่อน TEARDOWN เด็ดขาด"
  st = self.clock()
  local snapOk, snapWhy
  if snap then
    snapOk, snapWhy = self:_validateSnapshot(snap)
  else
    snapOk, snapWhy = false, (snapErr or "สร้าง snapshot ไม่ได้ (serializer พัง/ขาดช่อง)")
  end
  markMs("snapshot-validate", st)

  if not snapOk then
    -- ยังไม่มีอะไวถูกทำลาย — ถอน freeze + replay คิวเดิม + อยู่รุ่นเก่าต่อ
    snapWhy = snapWhy or (snapErr or "สร้าง snapshot ไม่ได้")
    oldSys.bus:Resume()
    self.staged = nil
    self.inFlight = false
    self.lastSnapshot = nil
    local res = self:_result("F-SNAP", {
      bugId = self:_nextBugId(),
      detail = ("Rollback Snapshot ไม่ผ่านการตรวจ: %s — ABORT ก่อน TEARDOWN "
        .. "(ระบบเดิมเดินต่อ ไม่มีอะไรถูกทำลาย §3.6 R4)"):format(snapWhy),
      to = { version = m.version, releaseId = m.releaseId },
      integrity = integrity,
      snapshot = nil,
      timing = finishTiming(self, steps, t0),
    })
    self.logger("error", res.detail)
    return res
  end

  self.lastSnapshot = snap
  self:_emit("snapshot.validate.done", { fields = 7, version = snap.version })

  -- ------------------------------------------------------------ TEARDOWN ----
  st = self.clock()
  self:_emit("teardown")
  local tdReport = oldSys.shutdown:Run({ assertZero = false })
  markMs("teardown", st)

  -- CR-REPLAY-001 (§3.6 ตามคำตัดสินเจ้าของ 1 ต.ค. 2026 — ตัวเลือก ข):
  -- คิวของ bus รุ่นเก่าที่ค้างตลอดหน้าต่าง freeze (FREEZE → DRAIN → SNAPSHOT →
  -- TEARDOWN รวม event ที่ hook ปล่อยออกมาตอนถอดระบบ) ต้องข้าม generation ไป
  -- replay ตาม policy บนระบบปลายทาง — เดิมทิ้งทั้งคิวเงียบ ๆ ขัด §3.6
  -- export หลัง TEARDOWN เสร็จ (คิวนิ่งแล้ว) — path สำเร็จนำไป import ที่ RESUME
  -- / path ย้อนรุ่นนำไป import ที่ rollback.resume
  local carried = oldSys.bus:ExportQueue()
  self:_emit("carry-export", { carried = #carried })

  -- -------------------------------------------------------------- VERIFY ----
  -- orphan รวม 4 ชนิด = 0 ไม่ใช่ = ABORT + ROLLBACK (ห้าม force-clean §3.6)
  st = self.clock()
  local orphans = sumKinds(tdReport.rows)
  if tdReport.orphans == 0 then
    -- คืนส่วนที่ runtime เป็นเจ้าของเอง (หลังพิสูจน์ว่าโมดูลคืนครบแล้ว —
    -- ต่างจาก force-clean: ตรงนี้ cleanup หลัง orphans=0 เท่านั้น)
    if oldSys.watchdog and oldSys.watchdog.Stop then
      pcall(oldSys.watchdog.Stop, oldSys.watchdog)
    end
    oldSys.registry:Release(nil)
  end
  markMs("verify", st)
  self:_emit("verify", { orphans = orphans.total })

  if tdReport.orphans > 0 then
    orphans.owners = orphans.owners or {}
    local res = self:_rollbackFromSnapshot("F1", ("VERIFY ไม่ผ่าน: orphan รวม %d ชิ้น "
      .. "(tasks=%d connections=%d renders=%d temps=%d) เจ้าของที่ค้าง: %s — "
      .. "ห้าม force-clean แล้วไปต่อ (§3.6 F1)")
      :format(tdReport.orphans, orphans.tasks, orphans.connections,
        orphans.renders, orphans.temps,
        #orphans.owners > 0 and table.concat(orphans.owners, ", ") or "(ไม่มีรายงาน)"),
      snap, integrity, steps, t0, warnings, orphans, carried)
    return res
  end

  -- ---------------------------------------------------------------- LOAD ----
  st = self.clock()
  local sysNew, loadErr = self:_execSource(newSource, "@" .. entryName .. ":" .. tostring(m.version))
  self:_emit("load", { system = sysNew }) -- จุดเข้าถึกระบบที่ staged (เทส/Diagnostics)
  markMs("load", st)

  if sysNew then
    -- ระบบใหม่ถูกสร้างแล้ว — กันหน้า: freeze bus ของรุ่นใหม่ทันที ให้เหตุการณ์
    -- ที่เกิดจาก MIGRATE เข้าคิว แล้ว replay ตอน RESUME (ใกล้เคียง §3.6
    -- มากที่สุดโดยไม่แก้ไฟล์ที่ผ่าน gate)
    sysNew.bus:Freeze(newGen)
  end

  -- -------------------------------------------------------------- MIGRATE --
  if sysNew then
    st = self.clock()
    self:_emit("migrate")
    local okM, errM = self:_migrateSystem(sysNew, snap)
    markMs("migrate", st)

    if not okM then
      local res = self:_rollbackFromSnapshot("F2", errM .. " (LOAD/MIGRATE)", snap, integrity, steps, t0, warnings, nil, carried)
      return res
    end
  else
    local res = self:_rollbackFromSnapshot("F2", loadErr .. " (LOAD)", snap, integrity, steps, t0, warnings, nil, carried)
    return res
  end

  -- -------------------------------------------------------------- RESUME --
  st = self.clock()
  -- CR-REPLAY-001: คิวจาก bus รุ่นเก่าถูก import เข้า bus รุ่นใหม่ (frozen อยู่)
  -- policy ตัดสินใหม่ตาม Declare ของรุ่นใหม่ แล้ว replay รวมกับคิวที่เกิด
  -- ระหว่าง MIGRATE — เรียงเวลาจริงทั้งคิว (last-write-wins)
  local carry = sysNew.bus:ImportQueue(carried)
  local replay = sysNew.bus:Resume(newGen)
  local replayReport = {
    replayed = replay.replayed,
    dropped = replay.dropped + carry.dropped,
    total = replay.total + carry.dropped,
    carried = carry.total,
    carriedAccepted = carry.accepted,
    carriedDropped = carry.dropped,
  }
  markMs("resume", st)
  self:_emit("resume", {
    replayed = replayReport.replayed, dropped = replayReport.dropped,
    total = replayReport.total, carried = replayReport.carried,
  })

  -- ----------------------------------------------------------- SELFCHECK --
  st = self.clock()
  self:_emit("selfcheck")
  local scOk, scWhy = self:_selfCheckSystem(sysNew, "update", newGen, m)
  markMs("selfcheck", st)
  if not scOk then
    local res = self:_rollbackFromSnapshot("F3", ("SELFCHECK ไม่ผ่าน: %s"):format(scWhy),
      snap, integrity, steps, t0, warnings, nil, carried)
    return res
  end

  -- -------------------------------------------------------- ADAPTER PROBE --
  st = self.clock()
  self:_emit("adapter-probe")
  local probeReport = sysNew.probe:Probe()
  markMs("adapter-probe", st)

  if probeReport.status == "dead" then
    local res = self:_rollbackFromSnapshot("F4", ("ADAPTER PROBE ไม่ผ่าน: %s — %s")
      :format(probeReport.summary, "adapter ตายหลัง migrate = รุ่นใหม่ไม่น่าไว้ใจ กลับรุ่นเดิม (§3.6 F4)"),
      snap, integrity, steps, t0, warnings, nil, carried)
    return res
  elseif probeReport.status == "degraded" then
    warnings[#warnings + 1] = ("Adapter เสื่อมหลังอัปเดต: %s — ปิดเฉพาะโมดูลที่กระทบตามกฎ §3.3 "
      .. "(เฟส 0 ยังไม่มีโมดูล จึงเป็นการเตือนพร้อมรายชื่อ impacted)")
      :format(probeReport.summary)
  end

  -- --------------------------------------------------------------- COMMIT --
  -- ATOMIC UPDATE RULE (R3): ตรงนี้เท่านั้นที่ NEW กลายเป็น active
  st = self.clock()
  self.rollbackTarget = {
    source = self.active.source,
    manifest = self.active.manifest,
    version = self.active.version,
    releaseId = self.active.releaseId,
  }
  self.active = {
    system = sysNew, source = newSource, manifest = deepClone(m),
    version = m.version, releaseId = m.releaseId,
  }
  self.staged = nil
  self.inFlight = false
  markMs("commit", st)
  self:_emit("commit", { system = sysNew }) -- หลังสลับ — ผู้สังเกตเห็น NEW เป็น active แล้ว

  local timing, totalMs = finishTiming(self, steps, t0)
  if timing.overBudget then
    warnings[#warnings + 1] = ("เวลารวม %.1f ms เกินงบ %d ms (§9.1) — บันทึกเป็น metric")
      :format(totalMs, self.budgetMs)
  end

  -- metrics เข้า Diagnostics ของระบบใหม่ (§8.4)
  pcall(sysNew.diag.Mark, sysNew.diag, "hotUpdateMs", totalMs)

  local res = self:_result("OK", {
    ok = true,
    detail = ("อัปเดตสำเร็จ v%s → v%s (ใช้เวลา %.1f ms, orphan 0, replay %d/%d"
      .. " รวมข้าม generation %d ตัว)")
      :format(self.rollbackTarget.version, m.version, totalMs,
        replayReport.replayed, replayReport.total, replayReport.carried),
    to = { version = m.version, releaseId = m.releaseId },
    rolledBack = false,
    orphans = orphans,
    replay = replayReport,
    integrity = integrity,
    snapshot = snap,
    warnings = warnings,
    timing = timing,
  })

  -- REPORT (ขั้น 12 ของแผน): แจ้งผู้ใช้เป็นภาษาไทยผ่าน bus ของระบบที่ active
  sysNew.bus:Publish("update:succeeded", {
    from = res.from, to = res.to, totalMs = totalMs, replay = res.replay,
  })
  sysNew.bus:Publish("notify:user", {
    level = "info",
    key = "notify.update.succeeded",
    params = { from = res.from.version, to = res.to.version, ms = ("%.0f"):format(totalMs) },
  })
  self.logger("info", res.detail)
  return res
end

-- ==============================================================================
-- rollback จาก snapshot — ใช้ร่วมทุก path F1–F4
-- พิสูจน์ว่า "กลับรุ่นเดิม + ใช้งานได้จริง" ไม่ใช่แค่ "โหลดโค้ดเก่า":
--   LOAD รุ่นเดิม → freeze → MIGRATE state/config เดิม → RESUME →
--   SELFCHECK → ADAPTER PROBE → COMMIT (รุ่นเดิมกลับมาเป็น active)
-- ==============================================================================

function Update:_rollbackFromSnapshot(path, reason, snap, integrity, steps, t0, warnings, orphans, carried)
  warnings = warnings or {}
  carried = carried or {} -- CR-REPLAY-001: คิวที่ export จาก bus รุ่นเก่าก่อน TEARDOWN

  -- เวอร์ชันที่ "ตั้งใจไป" (รายงานใน result.to ของทุก path ที่ rollback)
  local attempt = self.staged and {
    version = self.staged.version, releaseId = self.staged.releaseId,
  } or nil

  -- ยังไม่มี snapshot ที่เชื่อถือได้ = ไม่มีทางกลับ (ห้ามเงียบ)
  if not snap then
    self.inFlight = false
    self.broken = { message = reason, path = path }
    local res = self:_result(path .. "+NO-SNAPSHOT", {
      bugId = self:_nextBugId(),
      detail = reason .. " — และไม่มี snapshot ให้กลับ (ระบบอยู่ในสถานะ broken)",
      broken = true,
      to = attempt,
      integrity = integrity,
      warnings = warnings,
      timing = finishTiming(self, steps, t0),
    })
    self.logger("error", res.detail)
    return res
  end

  local function rbFail(rpath, rdetail)
    self.inFlight = false
    self.broken = { message = rdetail, path = path }
    self.staged = nil
    local res = self:_result(path .. "+ROLLBACK-FAIL", {
      bugId = self:_nextBugId(),
      detail = ("%s → แล้ว rollback เองกลับพัง (%s): %s — ระบบอยู่ในสถานะ broken "
        .. "ห้ามแอบอ้างว่าใช้ได้ (No Silent Degradation)")
        :format(reason, rpath, rdetail),
      broken = true,
      rolledBack = false,
      to = attempt,
      integrity = integrity,
      warnings = warnings,
      timing = finishTiming(self, steps, t0),
    })
    self.logger("error", res.detail)
    return res
  end

  -- rollback.load
  local st = self.clock()
  local sysOld, err = self:_execSource(snap.bundle, "@rollback:" .. tostring(snap.version))
  local loadMs = (self.clock() - st) * 1000
  steps["rollback.load"] = loadMs
  self:_emit("rollback.load", { system = sysOld }) -- จุดเข้าถึงระบบที่กำลังกู้คืน
  if not sysOld then
    return rbFail("rollback.load", err)
  end
  sysOld.bus:Freeze() -- generation ใหม่ของรอบ rollback = generation เดิม + 1 (ค่า default)

  -- rollback.migrate
  st = self.clock()
  self:_emit("rollback.migrate")
  local okM, errM = self:_migrateSystem(sysOld, snap)
  steps["rollback.migrate"] = (self.clock() - st) * 1000
  if not okM then
    return rbFail("rollback.migrate", errM)
  end

  -- rollback.resume
  st = self.clock()
  -- CR-REPLAY-001: event ที่ค้างในหน้าต่าง freeze ของ bus รุ่นเก่า (รวมที่
  -- เกิดระหว่าง TEARDOWN) ถูกส่งข้าม generation มาที่รุ่นเดิมที่กลับมา —
  -- replay ตาม policy ของรุ่นนี้เอง (Transient DROP / State-Config REPLAY
  -- LWW / Idempotent REPLAY — สถานะโลกจริง DROP + re-derive จาก Adapter)
  local carry = sysOld.bus:ImportQueue(carried)
  local replay = sysOld.bus:Resume()
  local replayReport = {
    replayed = replay.replayed,
    dropped = replay.dropped + carry.dropped,
    total = replay.total + carry.dropped,
    carried = carry.total,
    carriedAccepted = carry.accepted,
    carriedDropped = carry.dropped,
  }
  steps["rollback.resume"] = (self.clock() - st) * 1000
  self:_emit("rollback.resume", {
    replayed = replayReport.replayed, dropped = replayReport.dropped,
    carried = replayReport.carried,
  })

  -- rollback.selfcheck
  st = self.clock()
  self:_emit("rollback.selfcheck")
  local scOk, scWhy = self:_selfCheckSystem(sysOld, "rollback", nil, snap.manifest)
  steps["rollback.selfcheck"] = (self.clock() - st) * 1000
  if not scOk then
    return rbFail("rollback.selfcheck", scWhy)
  end

  -- rollback.adapter-probe
  st = self.clock()
  self:_emit("rollback.adapter-probe")
  local probeReport = sysOld.probe:Probe()
  steps["rollback.adapter-probe"] = (self.clock() - st) * 1000
  if probeReport.status == "dead" then
    return rbFail("rollback.adapter-probe", ("รุ่นเดิมก็เห็น adapter ตายเหมือนกัน: %s "
      .. "(ถ้าเกมเปลี่ยนจริง การกลับรุ่นไม่ช่วย — ต้องแจ้งเป็น BUG แล้ววิเคราะห์ต่อ)")
      :format(probeReport.summary))
  elseif probeReport.status == "degraded" then
    warnings[#warnings + 1] = ("หลัง rollback พบ Adapter เสื่อม: %s"):format(probeReport.summary)
  end

  -- rollback.commit — รุ่นเดิมกลับมาเป็น active อีกครั้ง
  st = self.clock()
  self:_emit("rollback.commit")
  self.active = {
    system = sysOld, source = snap.bundle, manifest = snap.manifest,
    version = snap.version, releaseId = snap.releaseId,
  }
  self.staged = nil
  self.inFlight = false
  steps["rollback.commit"] = (self.clock() - st) * 1000

  -- bus ของระบบที่ rollback มาเป็น bus ใหม่ — ต้อง Declare event ของ update domain
  -- ก่อน publish (มิฉะนั้นเป็น undeclared และถูก drop เงียบ ๆ)
  for _, ev in ipairs(Update.EVENTS) do
    if sysOld.bus:Policy(ev[1]) == nil then
      sysOld.bus:Declare(ev[1], ev[2])
    end
  end

  local timing, totalMs = finishTiming(self, steps, t0)
  if timing.overBudget then
    warnings[#warnings + 1] = ("เวลารวม %.1f ms เกินงบ %d ms (§9.1)")
      :format(totalMs, self.budgetMs)
  end

  pcall(sysOld.diag.Mark, sysOld.diag, "hotUpdateMs", totalMs)

  local res = self:_result(path, {
    bugId = self:_nextBugId(),
    detail = ("%s — ROLLBACK สำเร็จ: กลับรุ่น v%s + state/config กลับคืน "
      .. "+ SELFCHECK/PROBE ผ่าน (ใช้งานต่อได้จริง %.1f ms)")
      :format(reason, snap.version, totalMs),
    rolledBack = true,
    to = attempt,
    orphans = orphans,
    replay = replayReport,
    integrity = integrity,
    snapshot = snap,
    warnings = warnings,
    timing = timing,
  })

  sysOld.bus:Publish("update:rolledback", {
    path = path, bugId = res.bugId, from = res.from, back = res.to, totalMs = totalMs,
  })
  sysOld.bus:Publish("notify:user", {
    level = "warn",
    key = "notify.update.rolledback",
    params = { path = path, bugId = res.bugId, version = snap.version },
  })
  self.logger("warn", res.detail)
  return res
end

return Update

  end)();
  __TV_EMBED['update'] = __m;
end
-- ==== embedded: loadermain (core/runtime/loader_main.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/loader_main.lua (Loader v2 — แผน §3.2 ข้อ 0 + §7)
--
-- จุดเข้าเดียวที่ผู้ใช้รัน (repo root loader.lua = ไฟล์นี้ + package ที่ฝัง
-- ประกอบโดย build/tools/build_dist.py):
--
--   1. Bootstrap Preflight (§3.2 ข้อ 0 — แยกจาก runtime capability ชัดเจน):
--      หา HTTP function จริง → ตรวจ CDN — พัง = plain text ไทย 1 บรรทัด แล้วหยุด
--      (ยังไม่โหลด core = ไม่มี UI ให้เปิด จึงห้ามสัญญา UI ตรงนี้)
--   2. ดึง manifest.json (4-URL fallback) → Version Gate + minLoaderVersion
--   3. ดึง the-voider.lua → ตรวจความถูกต้นฉบับ 3 ระดับ (§7.2 — บอกตามจริง)
--   4. execute bundle → host.register → Update orchestrator ถือ active ต่อ
--   5. เปิดใช้ host.checkUpdate() = ตัวจุดชนของ Hot Update Protocol (§3.6)
--      (เฟส 0 ยังไม่มี UI — เรียกได้จาก console/Diagnostics; อนาคตปุ่มใน Hub)
--
-- executor: Volt เท่านั้น (แผน freeze v2.1) — ข้อความทุกอันเป็นภาษาไทย
--
-- URL: ตั้ง OWNER ให้ถูกตอนเผยแพร่จริง — ถ้ายังเป็น placeholder loader จะเตือน
-- ชัดเจนตอนรัน (รอบนี้ยังไม่มี deployment จึงไม่มี URL จริงให้ตรวจ)
-- ============================================================================

local function _pkg(name)
  -- NoKey-VoltCompat v1: executor sandboxes (Volt) hide chunk-written
  -- globals from rawget(_G) — plain reads go through the chunk env, so
  -- try them first and keep the original _G lookups as fallbacks.
  local pg = __TV_PACKAGES
  if type(pg) == "table" and pg[name] then return pg[name] end
  local pe = __TV_EMBED
  if type(pe) == "table" and pe[name] then return pe[name] end
  local g = rawget(_G, "__TV_PACKAGES")
  if g and g[name] then return g[name] end
  local e = rawget(_G, "__TV_EMBED")
  if e and e[name] then return e[name] end
  return nil
end

local Preflight = _pkg("preflight")
local Version = _pkg("version")
local Manifest = _pkg("manifest")
local Update = _pkg("update")

local LoaderMain = {}

LoaderMain.VERSION = "0.3.0"        -- เวอร์ชัน loader ตัวเอง
LoaderMain.PRODUCT = "the-voider"
LoaderMain.ENTRY_FILE = "the-voider.lua"
LoaderMain.MANIFEST_FILE = "manifest.json"

-- เผยแพร่จริง: แก้ OWNER เป็น GitHub user/org ของโปรเจกต์ (บันทึกใน CHANGELOG)
LoaderMain.OWNER = "auto578wqd"
LoaderMain.REPO = "loader"

LoaderMain.BASES = {
  "https://raw.githubusercontent.com/OWNER/loader/main",
  "https://cdn.jsdelivr.net/gh/OWNER/loader@main",
  "https://raw.githack.com/OWNER/loader/main",
  "https://github.com/OWNER/loader/raw/main",
}

--- รายการ URL เต็ม (แทน OWNER จริง) — ใช้ต่อ path ที่ต้องการ
function LoaderMain.urls()
  local out = {}
  for _, base in ipairs(LoaderMain.BASES) do
    local b = base:gsub("OWNER", LoaderMain.OWNER)
    out[#out + 1] = b
  end
  return out
end

-- ---- HTTP fetch (คืน body จริง — ต่างจาก preflight ที่ตรวจแค่ ok) ----------

local function respondOnce(name, fn, url, timeout)
  if name == "http_get" or name == "httpget" then
    local ok, body = pcall(fn, url)
    if not ok then return { ok = false, status = "error:" .. tostring(body), body = nil } end
    if type(body) == "string" and #body > 0 then
      return { ok = true, status = "200", body = body, url = url }
    end
    return { ok = false, status = "empty", body = nil }
  end
  -- รูปแบบ table-request (http_request / syn.request / request)
  local req = { Url = url, Method = "GET" }
  if timeout then req.Timeout = timeout end
  local ok, res = pcall(fn, req)
  if not ok then return { ok = false, status = "error:" .. tostring(res), body = nil } end
  if type(res) == "table" then
    local body = res.Body
    local code = res.StatusCode or res.Status or res.code
    local okCode = (res.Success == true)
      or (type(code) == "number" and code >= 200 and code <= 299)
    if okCode and type(body) == "string" and #body > 0 then
      return { ok = true, status = tostring(code or "ok"), body = body, url = url }
    end
    return { ok = false, status = tostring(code or "no-body"), body = nil }
  elseif type(res) == "string" and #res > 0 then
    return { ok = true, status = "200", body = res, url = url }
  end
  return { ok = false, status = "no-response", body = nil }
end

-- ---- default loadFn (Luau: loadstring / Lua 5.3: load) ----------------------

local function defaultLoadFn(source, chunkName)
  -- NoKey-VoltCompat v1: plain env reads first (see _pkg note)
  local ls = (type(loadstring) == "function" and loadstring)
    or (type(load) == "function" and load)
    or rawget(_G, "loadstring") or rawget(_G, "load")
  if type(ls) ~= "function" then
    return nil, "environment นี้ไม่มี loadstring/load — โหลด bundle ไม่ได้"
  end
  return ls(source, chunkName)
end

-- ---- constructor --------------------------------------------------------------

-- opts (ทั้งหมด optional — ใช้แทนค่า default ได้ สะดวกใน L2):
--   env, httpFn, httpName, urls, loadFn, logger, clock, onStep,
--   softwareBudgetMs, budgetMs, timeout
function LoaderMain.new(opts)
  opts = opts or {}
  local self = setmetatable({}, { __index = LoaderMain })
  self.env = opts.env or (function()
    -- NoKey-VoltCompat v1: prefer the chunk env (getfenv) over _G —
    -- executor APIs (http_request) may be injected into the chunk env only
    local ok, e = pcall(function()
      if type(getfenv) == "function" then return getfenv() end
      return nil
    end)
    if ok and type(e) == "table" then return e end
    return _G
  end)()
  self.logger = opts.logger or function(level, msg)
    local w = level == "error" and (type(warn) == "function" and warn or print)
      or print
    w(("[The Voider][Loader][%s] %s"):format(level, msg))
  end
  self.httpFn = opts.httpFn
  self.httpName = opts.httpName
  self.urls = opts.urls or LoaderMain.urls()
  self.loadFn = opts.loadFn or defaultLoadFn
  self.clock = opts.clock or os.clock
  self.timeout = opts.timeout or 8
  self.softwareBudgetMs = opts.softwareBudgetMs or 1000
  self.updateBudgetMs = opts.budgetMs or 5000
  self.onStep = opts.onStep

  self.updater = nil
  self.host = nil
  self.booted = nil
  return self
end

-- ---- ขั้น 1: Bootstrap Preflight (plain text — §3.2 ข้อ 0) -------------------

function LoaderMain:preflight()
  -- ตรวจด้วย URL ของ manifest จริง (base เปล่าตอบ 404 บน CDN จริง —
  -- ใช้ path ที่จะถูกดึงจริงจึงวัดความเข้าถึงได้ตรง)
  local mfUrls = {}
  for _, b in ipairs(self.urls) do
    mfUrls[#mfUrls + 1] = b .. "/" .. LoaderMain.MANIFEST_FILE
  end
  local result = Preflight.Run({
    env = self.env,
    urls = mfUrls,
    httpFn = self.httpFn,
    httpName = self.httpName,
    timeout = self.timeout,
    log = function(msg) self.logger("error", msg) end,
  })
  return result
end

-- ---- ขั้น 2-3: ดึง manifest/entry จาก 4-URL -----------------------------------

function LoaderMain:fetch(url)
  local name, fn
  if self.httpFn then
    name = self.httpName or "(custom)"
    fn = self.httpFn
  else
    name, fn = Preflight.FindHTTP(self.env)
  end
  if not name then
    return { ok = false, status = "no-http" }
  end
  return respondOnce(name, fn, url, self.timeout)
end

--- ลองทุก URL จนกว่าจะได้ manifest ที่ผ่านการตรวจ — คืน (m, tried[])
function LoaderMain:fetchManifest()
  local tried = {}
  for _, base in ipairs(self.urls) do
    local url = base .. "/" .. LoaderMain.MANIFEST_FILE
    local res = self:fetch(url)
    tried[#tried + 1] = ("%s → %s"):format(url, res.ok and "ok" or res.status)
    if res.ok then
      local m, err = Manifest.Decode(res.body, {})
      if m then
        return m, tried
      end
      tried[#tried] = tried[#tried] .. " (manifest เสีย: " .. tostring(err) .. ")"
    end
  end
  return nil, tried
end

--- ดึง entry file ตาม manifest + ตรวจความถูกต้นฉบับ 3 ระดับ
function LoaderMain:fetchEntry(m)
  local tried = {}
  for _, base in ipairs(self.urls) do
    local url = base .. "/" .. LoaderMain.ENTRY_FILE
    local res = self:fetch(url)
    if res.ok then
      local verify = Manifest.Verify(res.body, LoaderMain.ENTRY_FILE, m, {
        clock = self.clock,
        softwareBudgetMs = self.softwareBudgetMs,
        env = self.env,
      })
      if verify.ok then
        return res.body, verify, tried
      end
      tried[#tried + 1] = ("%s → %s"):format(url, verify.detail)
    else
      tried[#tried + 1] = ("%s → %s"):format(url, res.status)
    end
  end
  return nil, nil, tried
end

-- ---- host + updater wiring ----------------------------------------------------

function LoaderMain:_ensureHost()
  if self.host then return end
  local loader = self
  self.host = {
    loaderVersion = LoaderMain.VERSION,
    register = function(record)
      loader.updater:Attach(record)
      loader.logger("info", ("ระบบ v%s พร้อมใช้งาน (releaseId %s)")
        :format(record.system.version, tostring(record.system.releaseId)))
    end,
    checkUpdate = function()
      return loader:checkUpdate()
    end,
    log = function(level, msg) loader.logger(level, msg) end,
  }
  self.updater = Update.new({
    loadFn = self.loadFn,
    clock = self.clock,
    logger = self.logger,
    onStep = self.onStep,
    budgetMs = self.updateBudgetMs,
    softwareBudgetMs = self.softwareBudgetMs,
    loaderVersion = LoaderMain.VERSION,
    env = self.env,
  })
end

-- ---- ขั้น 4-5: boot ทั้ง flow ---------------------------------------------------

function LoaderMain:boot()
  if self.booted then
    return self.booted
  end

  if LoaderMain.OWNER == "OWNER-PLACEHOLDER" then
    self.logger("warn", "loader ยังไม่ได้ตั้ง OWNER ของ repo (ยังไม่เผยแพร่จริง) — "
      .. "แก้ LoaderMain.OWNER ตอน publish แล้ว purge CDN ทุกครั้ง (§7.4)")
  end

  -- 1) Preflight: HTTP + CDN (พัง = หยุดทันที — plain text ไทยจาก preflight เอง)
  local pre = self:preflight()
  if not pre.ok then
    self.booted = { ok = false, stage = "preflight", message = pre.message }
    return self.booted
  end

  -- 2) manifest + Version Gate
  local m, tried = self:fetchManifest()
  if not m then
    self.booted = {
      ok = false,
      stage = "manifest",
      message = ("ดึง manifest ไม่ได้จากทุก URL:\n  %s"):format(table.concat(tried, "\n  ")),
    }
    self.logger("error", self.booted.message)
    return self.booted
  end

  local okMin, msgMin = Version.checkMinLoader(m.minLoaderVersion, LoaderMain.VERSION)
  if not okMin then
    self.booted = { ok = false, stage = "min-loader", message = msgMin }
    self.logger("error", msgMin)
    return self.booted
  end

  -- 3) entry + integrity (บอกระดับตรวจตามจริง §7.2)
  local source, verify, etried = self:fetchEntry(m)
  if not source then
    self.booted = {
      ok = false,
      stage = "entry",
      message = ("ดึง/ตรวจ %s ไม่ผ่าน:\n  %s"):format(
        LoaderMain.ENTRY_FILE, table.concat(etried, "\n  ")),
    }
    self.logger("error", self.booted.message)
    return self.booted
  end
  self.logger("info", verify.detail)

  -- 4) execute bundle (ตั้ง host + BUNDLE_RUN ก่อนเสมอ)
  self:_ensureHost()
  -- NoKey-VoltCompat v1b: executor sandboxes (Volt) hide Roblox builtins from
  -- rawget(_G) inside loadstring'd chunks (proven: :2434 crash + missing
  -- ctx.task). Probe every channel and mirror what we find into _G + getgenv
  -- so the bundle's rawget(_G, ...) lookups resolve. task is a hard
  -- requirement (Registry:Spawn throws without it).
  do
    local okE, E = pcall(getfenv)
    local okG, GG = pcall(getgenv)
    local lookup = {}
    if okE and type(E) == "table" then lookup[#lookup + 1] = E end
    if type(_G) == "table" then lookup[#lookup + 1] = _G end
    if okG and type(GG) == "table" and GG ~= _G then lookup[#lookup + 1] = GG end
    local names = {
      "task", "Instance", "game", "workspace", "Drawing", "warn",
      "readfile", "writefile", "isfile", "setclipboard", "gethui", "getgenv",
    }
    for _, name in ipairs(names) do
      if type(_G) ~= "table" or rawget(_G, name) == nil then
        for _, t in ipairs(lookup) do
          local v = t[name]
          if v ~= nil then
            if type(_G) == "table" then pcall(function() rawset(_G, name, v) end) end
            if okG and type(GG) == "table" then pcall(function() GG[name] = v end) end
            break
          end
        end
      end
    end
    -- last resort: no real task library anywhere -> minimal shim built on
    -- RunService.Heartbeat so Registry:Spawn / Watchdog can run
    if type(_G) == "table" and rawget(_G, "task") == nil then
      local gameRef
      for _, t in ipairs(lookup) do
        local g = t.game
        if g ~= nil and type(g) ~= "function" then gameRef = g break end
      end
      local okRS, hb = pcall(function()
        return gameRef:GetService("RunService").Heartbeat
      end)
      if gameRef and okRS and type(hb) == "userdata" then
        local shim = {}
        function shim.spawn(f, ...)
          if type(f) ~= "function" then return nil end
          local co = coroutine.create(f)
          local n = select("#", ...)
          local args = { ... }
          local okRes, err = coroutine.resume(co, unpack(args, 1, n))
          if not okRes and co then
            pcall(function()
              warn("[The Voider][VoltCompat] task shim error: " .. tostring(err))
            end)
          end
          return co
        end
        function shim.wait(t)
          local sec = tonumber(t) or 0
          local start = os.clock()
          while os.clock() - start < sec do
            hb:Wait()
          end
          return os.clock() - start
        end
        pcall(function() rawset(_G, "task", shim) end)
        if okG and type(GG) == "table" then pcall(function() GG.task = shim end) end
        self.logger("warn", "VoltCompat: ไม่พบ task library จริง - เปิดใช้ task shim (Heartbeat) แทน")
      end
    end
  end
  local run = rawget(_G, "__TV_BUNDLE_RUN")
  rawset(_G, "__TV_BUNDLE_RUN", { source = source, manifest = m })
  local prevHost = rawget(_G, "__TV_HOST")
  rawset(_G, "__TV_HOST", self.host)

  local execFn, err = self.loadFn(source, "@" .. LoaderMain.ENTRY_FILE .. ":" .. m.version)
  local sys
  if execFn then
    local okRun, r = pcall(execFn)
    if okRun then sys = r end
    err = okRun and nil or r
  end
  rawset(_G, "__TV_BUNDLE_RUN", run)
  rawset(_G, "__TV_HOST", prevHost)

  if not sys then
    self.booted = {
      ok = false,
      stage = "execute",
      message = ("รัน bundle v%s ไม่สำเร็จ: %s"):format(m.version, tostring(err)),
    }
    self.logger("error", self.booted.message)
    return self.booted
  end

  self.booted = {
    ok = true, stage = "done", system = sys, manifest = m,
    version = m.version, verify = verify,
  }
  self.logger("info", ("โหลดสำเร็จ v%s (releaseId %s, channel %s)")
    :format(m.version, tostring(m.releaseId), tostring(m.channel)))
  return self.booted
end

-- ---- Hot Update: จุดชนของ protocol (§3.6) --------------------------------------

function LoaderMain:checkUpdate()
  if not self.updater or not self.updater.active then
    return { ok = false, path = "NO-BOOT", detail = "ยังไม่ได้ boot — ไม่มีระบบเดิมให้อัปเดต" }
  end
  local active = self.updater:Active()

  local m, tried = self:fetchManifest()
  if not m then
    return { ok = false, path = "F0", detail = ("ดึง manifest ไม่ได้:\n  %s")
      :format(table.concat(tried, "\n  ")) }
  end

  local decision, detail = Version.gate({
    manifestVersion = m.version,
    activeVersion = active.version,
    channel = m.channel,
  })

  if decision == "noop" then
    return { ok = true, path = "NOOP", detail = detail }
  end
  if decision ~= "update" then
    self.logger("warn", detail)
    return { ok = false, path = "F0", detail = detail }
  end

  self.logger("info", detail)

  local okMin, msgMin = Version.checkMinLoader(m.minLoaderVersion, LoaderMain.VERSION)
  if not okMin then
    return { ok = false, path = "F0", detail = msgMin }
  end

  local source, verify, etried = self:fetchEntry(m)
  if not source then
    return { ok = false, path = "F0", detail = ("ดึง/ตรวจ entry ไม่ผ่าน:\n  %s")
      :format(table.concat(etried, "\n  ")) }
  end
  self.logger("info", verify.detail)

  local res = self.updater:Apply(source, m, { entryName = LoaderMain.ENTRY_FILE })
  self.logger(res.ok and "info" or "error", res.detail)
  return res
end

function LoaderMain:Status()
  return {
    loaderVersion = LoaderMain.VERSION,
    booted = self.booted and self.booted.ok or false,
    stage = self.booted and self.booted.stage or nil,
    update = self.updater and self.updater:Status() or nil,
  }
end

return LoaderMain

  end)();
  __TV_EMBED['loadermain'] = __m;
end

-- ==== entry ====
local LoaderMain = __TV_EMBED.loadermain
if rawget(_G, "__TV_LOADER_TEST_MODE") then
  return { new = LoaderMain.new }
end
LoaderMain.new():boot()
