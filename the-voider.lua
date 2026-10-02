--[[ THE VOIDER BUNDLE — GENERATED FILE ห้ามแก้มือ
  build: build/tools/build_dist.py | source: core/**
  TV-BUNDLE version=0.7.0 releaseId=r2026-10-01-16
]]

__TV_PACKAGES = __TV_PACKAGES or {}
-- ==== package: graph (core/runtime/graph.lua) ====
do
  local __m = (function()
-- GENERATED FILE — ห้ามแก้มือ
-- source of truth = docs/architecture/dependencies.md | แก้ที่นั่นแล้วรัน build/tools/gen_graph.py
-- source md5: 8dd607fb5d0d513481e8678454b9af95 | nodes: 38 | edges: 53 | generated: 2026-10-01
-- ใช้: Init() = initOrder / Shutdown+TEARDOWN = shutdownOrder (reverse เป๊ะ §3.10)
return {
  source = "docs/architecture/dependencies.md",
  sourceMd5 = "8dd607fb5d0d513481e8678454b9af95",
  nodes = 38,
  edges = 53,
  initOrder = { "BootstrapPreflight", "UpdateCoordinator", "CapabilityDetection", "ResourceRegistry", "ErrorBoundary", "Watchdog", "ShutdownManager", "EventBus", "ConfigService", "MigrationService", "PresetService", "FFlagService", "I18nService", "KeybindService", "DiagnosticsService", "PlayerAdapter", "CharacterAdapter", "CombatAdapter", "CameraAdapter", "InputAdapter", "WorldAdapter", "AdapterSelfProbe", "TargetService", "PredictionService", "CameraService", "CombatStateService", "VoidAim", "VoidESP", "VoidMacro", "CombatCore", "Race", "Fruit", "Movement", "ServerHop", "ThemeEngine", "Hub", "HUD", "Notification" },
  shutdownOrder = { "Notification", "HUD", "Hub", "ThemeEngine", "ServerHop", "Movement", "Fruit", "Race", "CombatCore", "VoidMacro", "VoidESP", "VoidAim", "CombatStateService", "CameraService", "PredictionService", "TargetService", "AdapterSelfProbe", "WorldAdapter", "InputAdapter", "CameraAdapter", "CombatAdapter", "CharacterAdapter", "PlayerAdapter", "DiagnosticsService", "KeybindService", "I18nService", "FFlagService", "PresetService", "MigrationService", "ConfigService", "EventBus", "ShutdownManager", "Watchdog", "ErrorBoundary", "ResourceRegistry", "CapabilityDetection", "UpdateCoordinator", "BootstrapPreflight" },
  layers = {
    ["BootstrapPreflight"] = 0,
    ["UpdateCoordinator"] = 0,
    ["CapabilityDetection"] = 1,
    ["ResourceRegistry"] = 1,
    ["ErrorBoundary"] = 1,
    ["Watchdog"] = 1,
    ["ShutdownManager"] = 1,
    ["EventBus"] = 2,
    ["ConfigService"] = 2,
    ["MigrationService"] = 2,
    ["PresetService"] = 2,
    ["FFlagService"] = 2,
    ["I18nService"] = 2,
    ["KeybindService"] = 2,
    ["DiagnosticsService"] = 2,
    ["PlayerAdapter"] = 3,
    ["CharacterAdapter"] = 3,
    ["CombatAdapter"] = 3,
    ["CameraAdapter"] = 3,
    ["InputAdapter"] = 3,
    ["WorldAdapter"] = 3,
    ["AdapterSelfProbe"] = 3,
    ["TargetService"] = 4,
    ["PredictionService"] = 4,
    ["CameraService"] = 4,
    ["CombatStateService"] = 4,
    ["VoidAim"] = 5,
    ["VoidESP"] = 5,
    ["VoidMacro"] = 5,
    ["CombatCore"] = 5,
    ["Race"] = 5,
    ["Fruit"] = 5,
    ["Movement"] = 5,
    ["ServerHop"] = 5,
    ["ThemeEngine"] = 6,
    ["Hub"] = 6,
    ["HUD"] = 6,
    ["Notification"] = 6,
  },
  deps = {
    ["BootstrapPreflight"] = {},
    ["UpdateCoordinator"] = {},
    ["CapabilityDetection"] = {},
    ["ResourceRegistry"] = {},
    ["ErrorBoundary"] = {},
    ["Watchdog"] = { "ErrorBoundary" },
    ["ShutdownManager"] = {},
    ["EventBus"] = {},
    ["ConfigService"] = {},
    ["MigrationService"] = { "ConfigService" },
    ["PresetService"] = { "ConfigService" },
    ["FFlagService"] = { "ConfigService" },
    ["I18nService"] = { "ConfigService" },
    ["KeybindService"] = { "EventBus", "I18nService" },
    ["DiagnosticsService"] = { "EventBus" },
    ["PlayerAdapter"] = {},
    ["CharacterAdapter"] = {},
    ["CombatAdapter"] = {},
    ["CameraAdapter"] = {},
    ["InputAdapter"] = {},
    ["WorldAdapter"] = {},
    ["AdapterSelfProbe"] = {},
    ["TargetService"] = { "PlayerAdapter", "WorldAdapter" },
    ["PredictionService"] = { "TargetService", "WorldAdapter" },
    ["CameraService"] = { "CameraAdapter" },
    ["CombatStateService"] = { "CharacterAdapter", "CombatAdapter" },
    ["VoidAim"] = { "TargetService", "PredictionService", "CameraService", "CombatStateService", "KeybindService", "InputAdapter" },
    ["VoidESP"] = { "TargetService", "WorldAdapter", "CameraAdapter" },
    ["VoidMacro"] = { "InputAdapter", "ConfigService", "CombatAdapter", "KeybindService" },
    ["CombatCore"] = { "CombatStateService", "CombatAdapter" },
    ["Race"] = { "PlayerAdapter", "CharacterAdapter", "KeybindService" },
    ["Fruit"] = { "WorldAdapter", "PlayerAdapter", "CombatAdapter" },
    ["Movement"] = { "CharacterAdapter", "InputAdapter" },
    ["ServerHop"] = { "WorldAdapter" },
    ["ThemeEngine"] = {},
    ["Hub"] = { "ConfigService", "I18nService", "VoidAim", "VoidESP", "VoidMacro", "CombatCore", "Race", "Fruit", "Movement", "ServerHop" },
    ["HUD"] = { "DiagnosticsService", "EventBus" },
    ["Notification"] = { "EventBus", "I18nService" },
  },
  capabilityDeps = {
    ["ServerHop"] = { "HTTP" },
  },
}

  end)();
  __TV_PACKAGES['graph'] = __m;
end
-- ==== package: preflight (core/runtime/preflight.lua) ====
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
  __TV_PACKAGES['preflight'] = __m;
end
-- ==== package: capability (core/runtime/capability.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/capability.lua
-- Runtime Capability Detection (แผน freeze v2.1 §3.2 ข้อ 1)
--
-- ตอน startup ระบบ "ทดสอบจริง" (เรียกใช้แล้วดูผล ไม่ใช่แค่เช็คว่ามีชื่อ function
-- เพราะบาง executor มีชื่อแต่พัง) ว่า runtime ปัจจุบันทำอะไรได้ 8 อย่าง:
--   DRAWING / HOOK / HTTP / FILEIO / INPUT / CLIPBOARD / TASK / CRYPTO
--
-- ผลเก็บเป็น Capability Report → Developer Diagnostics (§8.4)
-- ทุกฟีเจอร์ต้องเช็ค capability ก่อนเปิด — ไม่ hard-code ตาม executor (§6.3)
-- ผลอ้างอิงของโปรเจกต์เก็บจาก Volt เท่านั้น + probe ใหม่ทุก release
--
-- หมายเหตุ: กรณี "ไม่มี HTTP เลยจน loader โหลดไม่ได้" = หน้าที่ของ
-- Bootstrap Preflight (§3.2 ข้อ 0) ก่อนโหลด core — สองระดับไม่ปนกัน
-- ============================================================================

local Capability = {}
Capability.__index = Capability

Capability.NAMES = { "DRAWING", "HOOK", "HTTP", "FILEIO", "INPUT", "CLIPBOARD", "TASK", "CRYPTO" }

-- Known-Answer Test ของ SHA-256 (ใช้ตรวจว่า crypto API ใช้ได้จริง ไม่ใช่แค่มีชื่อ)
-- sha256("TheVoider-KAT") = a0c4fa5d... (ตรวจสอบก่อนฝังด้วย python3 hashlib)
Capability.KAT_INPUT = "TheVoider-KAT"
Capability.KAT_DIGEST = "a0c4fa5d1b78ce13eb7d6bc3309f6b0009b06b3ce0412a8e9612aecdc196b4ee"

function Capability.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    clock = ctx.clock or os.clock,
    env = ctx.env or _G, -- tests แทนด้วย stub environment ได้
    httpProbeUrl = ctx.httpProbeUrl or "https://raw.githubusercontent.com/",
    report = nil,
  }, Capability)
  return self
end

-- ค้นหาค่าจาก env โดยมี getgenv เป็นทางเลือก (executor บางตัวเก็บ global ที่นั่น)
local function resolve(env, key)
  local v = env[key]
  if v ~= nil then return v end
  local gg = env.getgenv or (type(_G.getgenv) == "function" and _G.getgenv)
  if type(gg) == "function" then
    local ok, res = pcall(gg)
    if ok and type(res) == "table" then
      return res[key]
    end
  end
  return nil
end

-- ---------------------------------------------------------------------------
-- probes: ทุกตัวคืน (supported: boolean, detail: string) — ห้าม panic เด็ดขาด
-- ---------------------------------------------------------------------------

local function probeDrawing(env)
  local Drawing = resolve(env, "Drawing")
  if not (type(Drawing) == "table" and type(Drawing.new) == "function") then
    return false, "ไม่มี Drawing library"
  end
  local ok, err = pcall(function()
    local line = Drawing.new("Line")
    line.Visible = true
    line.Thickness = 1
    line:Remove()
  end)
  if ok then
    return true, "Drawing.new สร้าง/ตั้ง props/Remove ได้จริง"
  end
  return false, "Drawing.new มีชื่อแต่ใช้งานพัง: " .. tostring(err)
end

local function probeHook(env)
  local hookfunction = resolve(env, "hookfunction")
  if type(hookfunction) == "function" then
    -- ทดสอบจริง: hook ต้อง "มีผล" ต่อการเรียกฟังก์ชัน (ไม่ใช่แค่เรียกผ่าน)
    -- ใช้ global เพื่อให้ hookfunction ของ runtime จริงและ stub แทนค่าได้ทั้งคู่
    local ok, res = pcall(function()
      __TV_HOOK_PROBE_BASE = function(a) return a * 2 end
      hookfunction(__TV_HOOK_PROBE_BASE, function(a) return (a * 2) + 100 end)
      local r = __TV_HOOK_PROBE_BASE(1)
      __TV_HOOK_PROBE_BASE = nil
      return r
    end)
    if ok and res == 102 then
      return true, "hookfunction ทดสอบจริงผ่าน (hook มีผลต่อการเรียก)"
    end
    if ok then
      __TV_HOOK_PROBE_BASE = nil
      return false, "hookfunction มีชื่อแต่ hook ไม่มีผลจริง (ได้ " .. tostring(res) .. " ไม่ใช่ 102)"
    end
    __TV_HOOK_PROBE_BASE = nil
    return false, "hookfunction เรียกแล้ว error: " .. tostring(res)
  end
  local hookmeta = resolve(env, "hookmetamethod")
  if type(hookmeta) == "function" then
    local ok2, res2 = pcall(function()
      local t = setmetatable({}, { __index = function(_, k) return k .. "!" end })
      hookmeta(t, "__index", function(_, k) return k .. "?" end)
      return t.foo
    end)
    if ok2 and res2 == "foo?" then
      return true, "hookmetamethod ทดสอบจริงผ่าน"
    end
    return false, "hookmetamethod มีชื่อแต่ใช้ไม่ได้: " .. tostring(res2)
  end
  return false, "ไม่มี hookfunction/hookmetamethod"
end

local function probeHttp(env, probeUrl)
  local list = {}
  local http_request = resolve(env, "http_request")
  if type(http_request) == "function" then table.insert(list, { "http_request", http_request }) end
  local syn = resolve(env, "syn")
  if type(syn) == "table" and type(syn.request) == "function" then table.insert(list, { "syn.request", syn.request }) end
  local request = resolve(env, "request")
  if type(request) == "function" then table.insert(list, { "request", request }) end
  local http_get = resolve(env, "http_get")
  if type(http_get) == "function" then table.insert(list, { "http_get", http_get }) end
  local httpget = resolve(env, "httpget")
  if type(httpget) == "function" then table.insert(list, { "httpget", httpget }) end

  if #list == 0 then
    return false, "ไม่มี HTTP API ที่รู้จักเลย"
  end
  local names = {}
  for _, c in ipairs(list) do table.insert(names, c[1]) end

  for _, cand in ipairs(list) do
    local name, fn = cand[1], cand[2]
    local ok, res
    if name == "http_get" or name == "httpget" then
      ok, res = pcall(fn, probeUrl)
    else
      ok, res = pcall(fn, { Url = probeUrl, Method = "GET", Timeout = 8 })
    end
    if ok then
      if type(res) == "table" then
        local code = res.StatusCode or res.Status or res.code
        if res.Success == true or (type(code) == "number" and code >= 200 and code <= 299) then
          return true, name .. " เรียกจริงผ่าน (ตอบ " .. tostring(code or "Success") .. ")"
        end
      elseif type(res) == "string" and #res > 0 then
        return true, name .. " เรียกจริงผ่าน (body " .. tostring(#res) .. "B)"
      end
    end
  end
  return false, "มี HTTP API (" .. table.concat(names, ", ") .. ") แต่เรียกจริงไม่สำเร็จ"
end

local function probeFileio(env)
  local writefile = resolve(env, "writefile")
  local readfile = resolve(env, "readfile")
  local delfile = resolve(env, "delfile")
  if not (type(writefile) == "function" and type(readfile) == "function") then
    return false, "ไม่มี writefile/readfile"
  end
  local path = "thevoider_probe.tmp"
  local ok, err = pcall(function()
    writefile(path, "ok")
    local content = readfile(path)
    assert(content == "ok", "อ่านกลับไม่ตรงกับที่เขียน (ได้ " .. tostring(content) .. ")")
    if type(delfile) == "function" then
      delfile(path)
    end
  end)
  if ok then
    local extra = type(delfile) == "function" and "" or " (ไม่มี delfile — ลบไฟล์ไม่ได้แต่บันทึก/อ่านใช้ได้)"
    return true, "เขียน-อ่าน round-trip ได้จริง" .. extra
  end
  return false, "file round-trip พัง: " .. tostring(err)
end

local function probeInput(env)
  local game = resolve(env, "game")
  if not (type(game) == "table" or type(game) == "userdata") then
    return false, "ไม่มี game object"
  end
  local ok, uis = pcall(function()
    return game:GetService("UserInputService")
  end)
  if not ok or type(uis) ~= "table" then
    return false, "เข้าถึง UserInputService ไม่ได้: " .. tostring(uis)
  end
  local ok2, err = pcall(function()
    -- อ่าน property จริง + connect/disconnect จริง (แล้วถอดทันที — ไม่ทิ้ง connection)
    local _ = uis.KeyboardEnabled
    local _m = uis.MouseEnabled
    local conn = uis.InputBegan:Connect(function() end)
    conn:Disconnect()
  end)
  if ok2 then
    return true, "UserInputService: อ่าน property + InputBegan connect/disconnect ได้จริง"
  end
  return false, "UserInputService มีชื่อแต่ใช้งานพัง: " .. tostring(err)
end

local function probeClipboard(env)
  local set = resolve(env, "setclipboard")
  local get = resolve(env, "getclipboard")
  if type(set) ~= "function" then
    return false, "ไม่มี setclipboard"
  end
  if type(get) ~= "function" then
    -- มีแค่ set: ไม่ยอมเขียนทับคลิปบอร์ดผู้ใช้ตอน startup เพื่อพิสูจน์ชื่อ
    return true, "มี setclipboard (ตรวจชื่ออย่างเดียว — ไม่ยุ่งคลิปบอร์ดผู้ใช้ตอน probe)"
  end
  -- มีทั้งคู่: ทดสอบจริงแบบกู้คืนค่าเดิมเสมอ (คลิปบอร์ดของผู้ใช้ต้องไม่ถูกทำลาย)
  local okBackup, backup = pcall(get)
  local payload = "TheVoider-clipboard-probe"
  local okSet, err = pcall(set, payload)
  if not okSet then
    return false, "setclipboard เรียกพัง: " .. tostring(err)
  end
  local _, back = pcall(get)
  if okBackup then pcall(set, backup) end -- คืนคลิปบอร์ดเดิมเสมอ
  if back == payload then
    return true, "set+get round-trip ผ่านจริง (คืนคลิปบอร์ดเดิมแล้ว)"
  end
  return true, "set เรียกได้ แต่ get ไม่ตรง (ใช้ได้ทาง export อย่างเดียว)"
end

local function probeTask(env)
  local task = resolve(env, "task")
  if type(task) ~= "table" then
    return false, "ไม่มี task library"
  end
  local ok, err = pcall(function()
    assert(type(task.spawn) == "function", "ไม่มี task.spawn")
    assert(type(task.wait) == "function", "ไม่มี task.wait")
    local ran = false
    task.spawn(function() ran = true end)
    assert(ran, "task.spawn รันฟังก์ชันจริงไม่ได้")
  end)
  if ok then
    return true, "task.spawn รันฟังก์ชันได้จริง + task.wait มีครบ"
  end
  return false, "task library พัง: " .. tostring(err)
end

local function probeCrypto(env)
  local forms = {}
  local crypto = resolve(env, "crypto")
  if type(crypto) == "table" and type(crypto.hash) == "function" then
    table.insert(forms, { "crypto.hash(algo, s)", function(s) return crypto.hash("sha256", s) end })
    table.insert(forms, { "crypto.hash(s, algo)", function(s) return crypto.hash(s, "sha256") end })
  end
  local syn = resolve(env, "syn")
  if type(syn) == "table" and type(syn.crypt) == "table" and type(syn.crypt.hash) == "function" then
    table.insert(forms, { "syn.crypt.hash(algo, s)", function(s) return syn.crypt.hash("sha256", s) end })
    table.insert(forms, { "syn.crypt.hash(s, algo)", function(s) return syn.crypt.hash(s, "sha256") end })
  end
  if #forms == 0 then
    return false, "ไม่มี crypto API ที่รู้จัก (hot update จะใช้การตรวจระดับ 2: version+size+marker)"
  end
  for _, f in ipairs(forms) do
    local name, fn = f[1], f[2]
    local ok, digest = pcall(fn, Capability.KAT_INPUT)
    if ok and type(digest) == "string" and #digest == 64 then
      if digest:lower() == Capability.KAT_DIGEST then
        return true, name .. " ผ่าน Known-Answer Test (SHA-256 ถูกต้องจริง)"
      end
      return false, name .. " ตอบ 64-hex แต่ digest ไม่ตรง KAT — ใช้ SHA-256 จริงไม่ได้ (ตรวจระดับ 2 แทน)"
    end
  end
  return false, "crypto API มีชื่อแต่เรียกใช้จริงไม่ได้ (ตรวจระดับ 2 แทน)"
end

-- ---------------------------------------------------------------------------
-- API
-- ---------------------------------------------------------------------------

--- รัน probe ทั้ง 8 — คืน Capability Report { [name] = {supported, detail} }
function Capability:Probe()
  local env = self.env
  local probes = {
    DRAWING = function() return probeDrawing(env) end,
    HOOK = function() return probeHook(env) end,
    HTTP = function() return probeHttp(env, self.httpProbeUrl) end,
    FILEIO = function() return probeFileio(env) end,
    INPUT = function() return probeInput(env) end,
    CLIPBOARD = function() return probeClipboard(env) end,
    TASK = function() return probeTask(env) end,
    CRYPTO = function() return probeCrypto(env) end,
  }
  local report = {}
  for _, name in ipairs(Capability.NAMES) do
    local ok, supported, detail = pcall(probes[name])
    if not ok then
      supported, detail = false, "probe รันเองพัง (ไม่ลาม): " .. tostring(supported)
    end
    report[name] = { supported = supported == true, detail = tostring(detail) }
  end
  self.report = report
  return report
end

--- ฟีเจอร์ต้องเช็คก่อนเปิดเสมอ — คืน (supported, detail)
function Capability:Has(name)
  if not self.report then
    self:Probe()
  end
  local r = self.report[name]
  if r == nil then
    return false, "ไม่รู้จัก capability ชื่อ " .. tostring(name)
  end
  return r.supported == true, r.detail
end

function Capability:Report()
  if not self.report then
    self:Probe()
  end
  return self.report
end

--- สรุปบรรทัดละชิ้นสำหรับ Developer Diagnostics (§8.4) + release notes
function Capability:Summary()
  local lines = {}
  for _, n in ipairs(Capability.NAMES) do
    local r = self:Report()[n]
    table.insert(lines, ("%s = %s (%s)"):format(n, r.supported and "SUPPORTED" or "OFF", r.detail))
  end
  return lines
end

return Capability

  end)();
  __TV_PACKAGES['capability'] = __m;
end
-- ==== package: registry (core/runtime/registry.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/registry.lua
-- Resource Registry — ตัวครอบเดียว สี่ชนิด (แผน freeze v2.1 §3.2 ข้อ 2, hardening #2)
--
--   Runtime.Spawn(name, fn)          task/loop          (เดิม Task Registry)
--   Runtime.Connect(signal, fn)      event connection   (เดิม Connection Registry)
--   Runtime.NewRender(kind, props)   Drawing/Instance   (ใหม่ v2.1)
--   Runtime.Temp(obj, disposer)      ทรัพยากรชั่วคราว   (ใหม่ v2.1)
--
-- กฎเหล็ก (§3.4): หลัง Module:Destroy() จบ ทรัพยากรทั้ง 4 ชนิดของโมดูลนั้น
-- ต้องเท่ากับ 0 รวมทุกชนิด — มี assertion ตรวจอัตโนมัติใน debug build
-- hot update (§3.6 ขั้น VERIFY) ตรวจทั้ง 4 ชนิดก่อนสลับรุ่น: orphan > 0 = ABORT
--
-- ความเป็นเจ้าของ (ownership): ทรัพยากรผูกกับ "owner" ที่กำหนดผ่าน Runtime.Scope
-- ทุกการจองต้องอยู่ใน Scope ของโมดูล — ของที่หลุดจากระบบ = นับเป็น orphan ของ "_unscoped"
--
-- สัญญาของ loop task: fn(ctx) ต้องเรียก ctx.ShouldRun() ทุกรอบ (คืน false = ถูกสั่งหยุด)
-- ผลพลอยได้: ทุกครั้งที่ ShouldRun() คืน true = heartbeat 1 ครั้งของโมดูลผู้เป็นเจ้า
-- (โมดูลที่ loop ยังเดินอยู่ = ยังหายใจ — watchdog ใช้ตรวจโมดูลตาย/ค้างโดยอัตโนมัติ)
-- ============================================================================

local Registry = {}
Registry.__index = Registry

local unpack = table.unpack or unpack

Registry.KIND_KEYS = { "tasks", "connections", "renders", "temps" }

function Registry.new(ctx)
  ctx = ctx or {}
  -- NoKey-VoltCompat v1c: executor sandboxes (Volt) hide chunk-written /
  -- injected globals from rawget(_G) - add plain env reads + getgenv
  local function __tv_gv(name)
    local ok, g = pcall(getgenv)
    if ok and type(g) == "table" then return g[name] end
    return nil
  end
  local self = setmetatable({
    clock = ctx.clock or os.clock,
    task = ctx.task or rawget(_G, "task") or task or __tv_gv("task"),
    drawing = ctx.drawing or rawget(_G, "Drawing") or drawing or __tv_gv("Drawing"),
    instance = ctx.instance or rawget(_G, "Instance") or instance or __tv_gv("Instance"),
    debug = ctx.debug or false,
    boundary = nil,   -- ติดตั้งภายหลังโดย init.lua
    watchdog = nil,   -- ติดตั้งภายหลังโดย init.lua
    currentOwner = nil,
    items = {},       -- handle ทุกตัวที่ยังมีชีวิต (เรียงตามเวลาสร้าง)
    counts = { tasks = 0, connections = 0, renders = 0, temps = 0 },
  }, Registry)
  return self
end

function Registry:SetBoundary(b) self.boundary = b end
function Registry:SetWatchdog(w) self.watchdog = w end

--- กำหนด "ผู้เป็นเจ้า" ของทุกทรัพยากรที่จองภายใน fn (ซ้อนกันได้ คืนค่าเดิมหลังจบ)
function Registry:Scope(owner, fn)
  local prev = self.currentOwner
  self.currentOwner = owner
  local results = { pcall(fn) }
  self.currentOwner = prev
  if not results[1] then
    error(results[2], 0)
  end
  return unpack(results, 2)
end

function Registry:Owner()
  return self.currentOwner
end

function Registry:_owner()
  if self.currentOwner then return self.currentOwner end
  if self.debug then
    print("[The Voider][Registry] WARNING: จองทรัพยากรนอก Scope — นับเป็น '_unscoped' (ต้องแก้เป็น Runtime.Scope)")
  end
  return "_unscoped"
end

function Registry:_beat(owner)
  if self.watchdog then
    self.watchdog:Beat(owner)
  end
end

function Registry:_add(h)
  table.insert(self.items, h)
  self.counts[h.kindKey] = self.counts[h.kindKey] + 1
end

function Registry:_remove(h)
  for i, item in ipairs(self.items) do
    if item == h then
      table.remove(self.items, i)
      self.counts[h.kindKey] = math.max(0, self.counts[h.kindKey] - 1)
      return true
    end
  end
  return false
end

-- ---------------------------------------------------------------------------
-- 1) Tasks — Runtime.Spawn(name, fn)
-- ---------------------------------------------------------------------------

--- จอง task/loop — fn(ctx) โดย ctx = { Name, ShouldRun(), Beat(), Wait(t) }
-- thread จบเอง (one-shot หรือ loop ครบ) = deregister อัตโนมัติ (ไม่ใช่ orphan)
-- error ภายใน fn = Error Boundary จับ + thread จบ + deregister (watchdog เห็น stall ต่อไป)
function Registry:Spawn(name, fn)
  if type(fn) ~= "function" then
    error("Runtime.Spawn(name, fn): fn ต้องเป็น function", 2)
  end
  if not self.task then
    error("Runtime.Spawn: ไม่มี task library (ctx.task)", 2)
  end
  local owner = self:_owner()
  local reg = self

  local h = {
    __registry_handle = true,
    kindKey = "tasks",
    kind = "task",
    name = name or "unnamed",
    owner = owner,
    released = false,
    cancelled = false,
    createdAt = self.clock(),
    lastBeatAt = self.clock(),
  }

  local ctx = {
    Name = h.name,
    -- เรียกทุกตั้งรอบของ loop: คืน false = ถูกสั่งหยุด (ต้องออกจาก loop ทันที)
    ShouldRun = function()
      if h.cancelled then return false end
      h.lastBeatAt = reg.clock()
      reg:_beat(owner)
      return true
    end,
    -- รายงานหายใจด้วยตนเอง (โมดูลที่ไม่ใช่ loop เช่น event-driven เรียกเองใน handler ได้)
    Beat = function()
      if h.cancelled then return end
      h.lastBeatAt = reg.clock()
      reg:_beat(owner)
    end,
    Wait = function(t)
      return reg.task.wait(t)
    end,
  }
  h.ctx = ctx

  h.Release = function()
    reg:_releaseTask(h)
  end
  h.Cancel = h.Release

  -- ลงทะเบียนก่อน spawn: กัน race ที่ thread จบสนิทภายใน spawn() ก่อนที่ _add จะทำงาน
  self:_add(h)

  h.thread = self.task.spawn(function()
    local bnd = reg.boundary
    if bnd then
      bnd:Guard(owner, function()
        return fn(ctx)
      end)
    else
      pcall(fn, ctx)
    end
    -- จบแบบธรรมชาติ (return/error ที่โดนจับแล้ว) → deregister อัตโนมัติ
    h.released = true
    reg:_remove(h)
  end)

  return h
end

function Registry:_releaseTask(h)
  if h.released then return end
  h.cancelled = true
  h.released = true
  if self.task and self.task.cancel and h.thread then
    pcall(self.task.cancel, h.thread)
  end
  self:_remove(h)
end

-- ---------------------------------------------------------------------------
-- 2) Connections — Runtime.Connect(signal, fn)
-- ---------------------------------------------------------------------------

--- จอง event connection — handler รันภายใต้ Error Boundary ของ owner เสมอ
function Registry:Connect(signal, fn)
  if type(fn) ~= "function" then
    error("Runtime.Connect(signal, fn): fn ต้องเป็น function", 2)
  end
  if type(signal) ~= "table" and type(signal) ~= "userdata" then
    error("Runtime.Connect(signal, fn): signal ต้องมี :Connect", 2)
  end
  local owner = self:_owner()
  local reg = self

  local h = {
    __registry_handle = true,
    kindKey = "connections",
    kind = "connection",
    name = (type(signal) == "table" and signal.Name) or "signal",
    owner = owner,
    released = false,
  }

  -- entry point ของโมดูล = รันใต้ boundary (error ใน handler ต้องไม่ลามไป handler อื่น)
  local wrapped = function(...)
    local bnd = reg.boundary
    if bnd then
      return bnd:Guard(owner, fn, ...)
    end
    return fn(...)
  end

  local ok, conn = pcall(function()
    return signal:Connect(wrapped)
  end)
  if not ok then
    error("Runtime.Connect: signal:Connect ล้มเหลว: " .. tostring(conn), 2)
  end
  h.conn = conn

  h.Release = function()
    if h.released then return end
    h.released = true
    if conn and type(conn.Disconnect) == "function" then
      pcall(conn.Disconnect, conn)
    end
    reg:_remove(h)
  end
  h.Disconnect = h.Release

  self:_add(h)
  return h
end

-- ---------------------------------------------------------------------------
-- 3) Render Objects — Runtime.NewRender(kind, props)
-- ---------------------------------------------------------------------------

--- จอง Drawing/Instance สำหรับ ESP/FOV circle/overlay
--- kind รูปแบบที่ 1: ชื่อ Drawing class เช่น "Line" "Circle" "Text" "Square" "Image"
--           → Drawing.new(kind) แล้ว apply props ทุกตัว
-- kind รูปแบบที่ 2: "Instance"
--           → props.Class = ชื่อ class, props.Props = {…} ตั้งค่า, props ที่เหลือ (เช่น Parent) ตั้งตรง
-- ถ้าไม่มี library / สร้างไม่ได้: คืน nil + reason (graceful — ผู้เรียกต้องเช็ค capability ก่อนเปิดฟีเจอร์ §3.2)
function Registry:NewRender(kind, props)
  props = props or {}
  local owner = self:_owner()
  local obj, why

  if kind == "Instance" then
    local cls = props.Class
    if not self.instance then
      why = "ไม่มี Instance library"
    elseif type(cls) ~= "string" then
      why = "props.Class จำเป็นสำหรับ kind='Instance'"
    else
      local ok, res = pcall(self.instance.new, cls)
      if ok then
        obj = res
      else
        why = ("Instance.new(%s) ล้มเหลว: %s"):format(tostring(cls), tostring(res))
      end
    end
  else
    if not self.drawing then
      why = "ไม่มี Drawing library (DRAWING capability ปิด)"
    else
      local ok, res = pcall(self.drawing.new, kind)
      if ok then
        obj = res
      else
        why = ("Drawing.new(%s) ล้มเหลว: %s"):format(tostring(kind), tostring(res))
      end
    end
  end

  if not obj then
    if self.debug then
      print(("[The Voider][Registry] NewRender(%s) ใช้ไม่ได้: %s"):format(tostring(kind), tostring(why)))
    end
    return nil, why
  end

  local okApply, applyErr = pcall(function()
    if kind == "Instance" then
      for k, v in pairs(props.Props or {}) do
        obj[k] = v
      end
      for k, v in pairs(props) do
        if k ~= "Class" and k ~= "Props" then
          obj[k] = v
        end
      end
    else
      for k, v in pairs(props) do
        obj[k] = v
      end
    end
  end)
  if not okApply then
    pcall(function()
      if type(obj.Remove) == "function" then obj:Remove()
      elseif type(obj.Destroy) == "function" then obj:Destroy() end
    end)
    return nil, "ตั้งค่า props ไม่ได้: " .. tostring(applyErr)
  end

  local reg = self
  local h = {
    __registry_handle = true,
    kindKey = "renders",
    kind = "render",
    name = tostring(kind),
    owner = owner,
    obj = obj,
    released = false,
  }
  h.Release = function()
    if h.released then return end
    h.released = true
    pcall(function()
      if type(obj.Remove) == "function" then
        obj:Remove()
      elseif type(obj.Destroy) == "function" then
        obj:Destroy()
      end
    end)
    reg:_remove(h)
  end
  h.Remove = h.Release
  h.Destroy = h.Release

  self:_add(h)
  return h
end

-- ---------------------------------------------------------------------------
-- 4) Temporary Resources — Runtime.Temp(obj [, disposer])
-- ---------------------------------------------------------------------------

--- จองทรัพยากรชั่วคราว (tween/timer/อ็อบเจ็กต์ที่ต้องคืน)
-- วิธีคืน: disposer(obj) ถ้าให้มา | obj() ถ้า obj เป็น function
--          | obj:Disconnect() / obj:Destroy() / obj:Remove() ตามลำดับที่หาเจอ
function Registry:Temp(obj, disposer)
  local owner = self:_owner()
  local reg = self

  local h = {
    __registry_handle = true,
    kindKey = "temps",
    kind = "temp",
    name = (type(obj) == "table" and obj.Name) or "temp",
    owner = owner,
    obj = obj,
    released = false,
  }
  h.Release = function()
    if h.released then return end
    h.released = true
    pcall(function()
      if type(disposer) == "function" then
        disposer(obj)
      elseif type(obj) == "function" then
        obj()
      elseif type(obj) == "table" then
        if type(obj.Disconnect) == "function" then obj:Disconnect()
        elseif type(obj.Destroy) == "function" then obj:Destroy()
        elseif type(obj.Remove) == "function" then obj:Remove() end
      end
    end)
    reg:_remove(h)
  end

  self:_add(h)
  return h
end

-- ---------------------------------------------------------------------------
-- ตรวจนับ / คืนทรัพยากร / ตรวจ orphan
-- ---------------------------------------------------------------------------

--- สรุปจำนวนทรัพยากร (owner = nil → ทั้งหมด) — {tasks, connections, renders, temps, total}
function Registry:Snapshot(owner)
  local snap = { tasks = 0, connections = 0, renders = 0, temps = 0, total = 0 }
  for _, h in ipairs(self.items) do
    if owner == nil or h.owner == owner then
      snap[h.kindKey] = snap[h.kindKey] + 1
      snap.total = snap.total + 1
    end
  end
  return snap
end

--- รายชื่อทรัพยากรที่ค้างอยู่ (ใช้ใน Diagnostics + รายงาน orphan)
function Registry:List(owner)
  local out = {}
  for _, h in ipairs(self.items) do
    if owner == nil or h.owner == owner then
      table.insert(out, ("%s:%s(%s)"):format(h.kind, h.name, h.owner))
    end
  end
  return out
end

--- คืนทรัพยากรของ owner (nil = ทั้งหมด) — คืนตารางจำนวนที่ปล่อยไป
function Registry:Release(owner)
  local released = { tasks = 0, connections = 0, renders = 0, temps = 0, total = 0 }
  for i = #self.items, 1, -1 do
    local h = self.items[i]
    if owner == nil or h.owner == owner then
      if h.Release then
        h.Release()
      end
      released[h.kindKey] = released[h.kindKey] + 1
      released.total = released.total + 1
    end
  end
  return released
end

--- ตรวจ orphan ของ owner (nil = ทั้งหมด) — คืน (ok, snapshot)
function Registry:VerifyZero(owner)
  local snap = self:Snapshot(owner)
  snap.ok = snap.total == 0
  return snap.ok, snap
end

--- ใช้ตอน hot update VERIFY (§3.6 ขั้น 8): นับเฉพาะของ "โมดูล"
-- (ของ Runtime เอง owner ขึ้นต้นด้วย "Runtime." ยกเว้น — TEARDOWN ทำลายโมดูลก่อน
--  ส่วน Runtime ถูกปิดท้ายตามลำดับ dependency graph §3.10)
function Registry:ModuleTotals()
  local snap = { tasks = 0, connections = 0, renders = 0, temps = 0, total = 0, owners = {} }
  for _, h in ipairs(self.items) do
    local isRuntime = type(h.owner) == "string" and h.owner:sub(1, 8) == "Runtime."
    if not isRuntime then
      snap[h.kindKey] = snap[h.kindKey] + 1
      snap.total = snap.total + 1
      snap.owners[h.owner] = (snap.owners[h.owner] or 0) + 1
    end
  end
  return snap
end

return Registry

  end)();
  __TV_PACKAGES['registry'] = __m;
end
-- ==== package: boundary (core/runtime/boundary.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/boundary.lua
-- Error Boundary (แผน freeze v2.1 §3.2 ข้อ 3)
--
-- entry point ทุกตัวของโมดูลรันภายใต้ boundary:
--   - error ถูกจับ (ลามไม่ได้ — ระบบที่เหลือเดินต่อ)
--   - นับ error ต่อโมดูล (ให้ watchdog ใช้ตัดสิน)
--   - บันทึก log พร้อม stack trace (DiagnosticsService ดึงไปแสดง/export รอบหน้า)
--   - แจ้ง subscriber (ModuleManager/Notification รอบหน้า) = "ปิดเฉพาะโมดูลนั้น + แจ้งผู้ใช้"
--
-- นโยบาย "ปิดโมดูลไหน" อยู่ที่ผู้ฟัง (ModuleManager ของ Foundation รอบถัดไป)
-- Boundary เองเป็นเครื่องจับ-นับ-แจ้ง ให้บริสุทธิ์ต่อทุกโมดูล
-- ============================================================================

local Boundary = {}
Boundary.__index = Boundary

local unpack = table.unpack or unpack

function Boundary.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    clock = ctx.clock or os.clock,
    debug = ctx.debug or false,
    counters = {},   -- [owner] = จำนวน error สะสม
    records = {},    -- log ล่าสุด (ring buffer)
    listeners = {},  -- รายการ callback(owner, record)
    maxRecords = ctx.maxRecords or 200,
  }, Boundary)
  return self
end

--- ลงทะเบียนผู้ฟัง error — คืนรหัสตำแหน่ง (ใช้ถอดภายหลังได้)
function Boundary:On(cb)
  table.insert(self.listeners, cb)
  return #self.listeners
end

function Boundary:Off(index)
  self.listeners[index] = nil
end

--- ตัวนับ error รายโมดูล (watchdog ใช้ตัดสิน + §5.1: error counter ต้องชน session log 100%)
function Boundary:Count(owner)
  return self.counters[owner] or 0
end

function Boundary:Counters()
  return self.counters
end

--- log ล่าสุด (Diagnostics อ่านไป export)
function Boundary:Records()
  return self.records
end

function Boundary:Reset(owner)
  if owner then
    self.counters[owner] = 0
  else
    self.counters = {}
  end
end

--- บันทึก error 1 ครั้ง + แจ้งผู้ฟังทุกตน (ผู้ฟังพังเองไม่มีทางลามมาที่ boundary)
function Boundary:_record(owner, err)
  local stack = tostring(err)
  if debug and debug.traceback then
    stack = debug.traceback(tostring(err), 2)
  end
  self.counters[owner] = (self.counters[owner] or 0) + 1
  local rec = {
    owner = owner,
    err = tostring(err),
    stack = stack,
    time = self.clock(),
    count = self.counters[owner],
  }
  table.insert(self.records, rec)
  if #self.records > self.maxRecords then
    table.remove(self.records, 1)
  end
  for _, cb in ipairs(self.listeners) do
    local okCb, cbErr = pcall(cb, owner, rec)
    if not okCb and self.debug then
      print(("[The Voider][ErrorBoundary] listener error: %s"):format(tostring(cbErr)))
    end
  end
  return rec
end

--- รัน fn ภายใต้ boundary — คืน (true, ผลลัพธ์...) หรือ (false, record)
function Boundary:Guard(owner, fn, ...)
  local results = { pcall(fn, ...) }
  local ok = table.remove(results, 1)
  if ok then
    return true, unpack(results)
  end
  local rec = self:_record(owner, results[1])
  return false, rec
end

return Boundary

  end)();
  __TV_PACKAGES['boundary'] = __m;
end
-- ==== package: watchdog (core/runtime/watchdog.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/watchdog.lua
-- Watchdog (แผน freeze v2.1 §3.2 ข้อ 4)
--
-- โมดูลทุกตัวต้อง "รายงานหายใจ" ตามรอบที่ตนประกาศ (เช่น โมดูล per-frame = ทุกวินาที)
-- - loop task ที่จองผ่าน Runtime.Spawn หายใจอัตโนมัติทุกครั้งที่เรียก ctx.ShouldRun()
-- - โมดูล event-driven เรียก Runtime.Beat(owner) เองใน handler
--
-- โมดูลเงียบเกิน threshold → พยายาม restart 1 ครั้ง → ยังเงียบ = ปิด + แจ้งผู้ใช้
-- กัน infinite restart ด้วย exponential backoff (รอบที่พังซ้ำ threshold แรมเป็น 2 เท่า)
-- ============================================================================

local Watchdog = {}
Watchdog.__index = Watchdog

function Watchdog.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    clock = ctx.clock or os.clock,
    checkInterval = ctx.checkInterval or 0.25, -- รอบเช็คของ monitor เอง
    stallFactor = ctx.stallFactor or 3,        -- เงียบเกิน period x นี้ = นับเป็น stall
    maxRestarts = ctx.maxRestarts or 1,        -- restart ได้ 1 ครั้ง (แผน §3.2 ข้อ 4)
    maxBackoff = ctx.maxBackoff or 32,         -- เพดาน backoff (2^n)
    registry = nil,
    boundary = nil,
    entries = {},     -- [owner] = entry ที่กำลังเฝ้า
    history = {},     -- [owner] = ตัวคูณ backoff สะสม (กัน register-พัง-register วนไม่รู้จบ)
    monitorHandle = nil,
    running = false,
  }, Watchdog)
  return self
end

function Watchdog:SetRegistry(r) self.registry = r end
function Watchdog:SetBoundary(b) self.boundary = b end

--- ลงทะเบียนโมดูลเพื่อเฝ้าหายใจ
-- opts = { period, stallFactor, maxRestarts, onRestart=function(owner, n), onDisable=function(owner, reason, entry) }
function Watchdog:Register(owner, opts)
  opts = opts or {}
  local mult = self.history[owner] or 1
  self.entries[owner] = {
    owner = owner,
    period = opts.period or 1,
    stallFactor = opts.stallFactor or self.stallFactor,
    maxRestarts = opts.maxRestarts or self.maxRestarts,
    onRestart = opts.onRestart,
    onDisable = opts.onDisable,
    lastBeat = self.clock(),
    restartCount = 0,
  }
  return self.entries[owner]
end

--- รายงานหายใจ 1 ครั้ง (เรียกจาก Runtime.Spawn อัตโนมัติ หรือโมดูลเรียกเอง)
function Watchdog:Beat(owner)
  local e = self.entries[owner]
  if e then
    e.lastBeat = self.clock()
  end
end

function Watchdog:Unregister(owner)
  self.entries[owner] = nil
end

function Watchdog:Entry(owner)
  return self.entries[owner]
end

--- threshold ปัจจุบันของ entry = period x stallFactor x backoff สะสม x 2^restartCount
function Watchdog:_threshold(e)
  local mult = self.history[e.owner] or 1
  return e.period * e.stallFactor * mult * (2 ^ e.restartCount)
end

function Watchdog:_runGuarded(fn)
  if self.boundary then
    return self.boundary:Guard("Runtime.Watchdog", fn)
  end
  local ok, err = pcall(fn)
  return ok, err
end

--- ปิดโมดูล + จำ backoff + แจ้งผู้ฟัง (No Silent Degradation — onDisable ต้องแจ้งผู้ใช้)
function Watchdog:_disable(e, reason)
  self.entries[e.owner] = nil
  self.history[e.owner] = math.min((self.history[e.owner] or 1) * 2, self.maxBackoff)
  local entry = e
  self:_runGuarded(function()
    if entry.onDisable then
      entry.onDisable(entry.owner, reason, entry)
    end
  end)
end

--- เช็คทุก entry 1 รอบ (เรียกโดย monitor loop)
function Watchdog:_check(now)
  for owner, e in pairs(self.entries) do
    local elapsed = now - e.lastBeat
    if elapsed > self:_threshold(e) then
      if e.restartCount < e.maxRestarts then
        -- พยายาม restart 1 ครั้งก่อน (แผน: restart หนึ่งครั้ง → ยังเงียบ = ปิด)
        e.restartCount = e.restartCount + 1
        e.lastBeat = now
        local entry = e
        local ok = self:_runGuarded(function()
          if entry.onRestart then
            entry.onRestart(entry.owner, entry.restartCount)
          end
        end)
        if not ok then
          -- restart callback พังเอง = รีสตาร์ทไม่ได้จริง → ไปทางปิดทันที (ไม่ลาม)
          self:_disable(e, "restart-failed")
        end
      else
        self:_disable(e, "stalled-after-restart")
      end
    end
  end
end

--- เริ่ม monitor loop (จองผ่าน registry = โมดูลของ Runtime เอง owner="Runtime.Watchdog")
function Watchdog:Start()
  if self.running or not self.registry then
    return self
  end
  self.running = true
  local wd = self
  local reg = self.registry
  self.monitorHandle = reg:Scope("Runtime.Watchdog", function()
    return reg:Spawn("WatchdogMonitor", function(ctx)
      while ctx.ShouldRun() do
        wd:_check(wd.clock())
        reg.task.wait(wd.checkInterval)
      end
    end)
  end)
  return self
end

--- หยุด monitor + คืนทรัพยากรของตัวเอง (orphan = 0 เช่นกัน)
function Watchdog:Stop()
  self.running = false
  if self.monitorHandle then
    self.monitorHandle.Release()
    self.monitorHandle = nil
  end
end

return Watchdog

  end)();
  __TV_PACKAGES['watchdog'] = __m;
end
-- ==== package: shutdown (core/runtime/shutdown.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/shutdown.lua
-- Shutdown Manager (แผน freeze v2.1 §3.2 ข้อ 5 + §3.10 hardening #7)
--
-- ลำดับปิดที่ถูกต้องเสมอ: ลำดับของโมดูลมาจาก Dependency Graph (graph.lua)
-- ซึ่งเป็น source of truth เดียวกับลำดับ Init() แต่ "กลับด้านเป๊ะ ๆ"
-- (ไม่ใช่ logic แยกอีกชุด — แก้ graph ที่เดียว ทั้งสองฝั่งเปลี่ยนตามอัตโนมัติ)
--
-- ใช้ 3 ที่: hot update TEARDOWN (§3.6 ขั้น 7) / unload ปกติ / ปุ่ม "ปิดสคริปต์" จาก UI
--
-- หลักเหล็กของรอบนี้ (§3.6 F1): Shutdown "ห้าม force-clean"
-- - หน้าที่ของ Shutdown = เรียก hook Disable/Destroy ตามลำดับ + ตรวจนับ orphan + รายงาน
-- - โมดูลเป็นคนคืนทรัพยากรของตัวเองใน Destroy (§3.4) — ค้างเกิน 0 = รายงานให้ผู้เรียก
--   ไป ABORT/ROLLBACK (hot update) — เลิกวิธี force-clean แล้วไปต่อถาวร
-- ============================================================================

local Shutdown = {}
Shutdown.__index = Shutdown

function Shutdown.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    boundary = nil,
    registry = nil,
    order = {},       -- init order (ชื่อ node ตาม graph.lua)
    hooks = {},       -- [name] = { Disable = fn?, Destroy = fn? }
    lastReport = nil,
  }, Shutdown)
  return self
end

function Shutdown:SetBoundary(b) self.boundary = b end
function Shutdown:SetRegistry(r) self.registry = r end

--- ตั้งลำดับจาก graph (initOrder) — Shutdown จะเรียงกลับด้านเอง
function Shutdown:Configure(initOrder)
  self.order = {}
  for _, n in ipairs(initOrder) do
    table.insert(self.order, n)
  end
  return self
end

--- ลงทะเบียน hook ปิดของ node (ใครมี lifecycle ครบจึงมี hook — node ที่ยังไม่มีโค้ดข้ามได้)
function Shutdown:Register(name, hooks)
  self.hooks[name] = hooks or {}
  return self
end

function Shutdown:Unregister(name)
  self.hooks[name] = nil
end

function Shutdown:_callHook(name, hookName, fn)
  if self.boundary then
    return (self.boundary:Guard(name, fn))
  end
  return (pcall(fn))
end

function Shutdown:_orphanNames()
  local out = {}
  if not (self.registry and self.lastReport) then return out end
  for _, row in ipairs(self.lastReport.rows) do
    if not row.ok then
      for _, desc in ipairs(self.registry:List(row.name)) do
        table.insert(out, desc)
      end
    end
  end
  return out
end

--- รันการปิดทั้งระบบ:
--   pass 1: Disable ทุก node (กลับลำดับ init)
--   pass 2: Destroy ทุก node (กลับลำดับ init) + ตรวจ orphan ต่อ node
-- คืน report = { rows, orphans, ok, order }
-- opts.assertZero = true (debug build) → orphan > 0 = error ทันที (assert อัตโนมัติ §3.4)
function Shutdown:Run(opts)
  opts = opts or {}
  local report = { rows = {}, orphans = 0, ok = true, order = {} }

  -- pass 1: Disable ทั้งหมด (กลับลำดับ)
  for i = #self.order, 1, -1 do
    local name = self.order[i]
    table.insert(report.order, name)
    local hooks = self.hooks[name]
    if hooks and type(hooks.Disable) == "function" then
      self:_callHook(name, "Disable", hooks.Disable)
    end
  end

  -- pass 2: Destroy ทั้งหมด (กลับลำดับ) + ตรวจ orphan ราย node
  for i = #self.order, 1, -1 do
    local name = self.order[i]
    local hooks = self.hooks[name]
    if hooks then
      if type(hooks.Destroy) == "function" then
        self:_callHook(name, "Destroy", hooks.Destroy)
      end
      local snap = { tasks = 0, connections = 0, renders = 0, temps = 0, total = 0 }
      if self.registry then
        snap = self.registry:Snapshot(name)
      end
      local row = { name = name, orphan = snap, ok = snap.total == 0 }
      table.insert(report.rows, row)
      report.orphans = report.orphans + snap.total
      if snap.total > 0 then
        report.ok = false
      end
    end
  end

  self.lastReport = report

  if opts.assertZero and report.orphans > 0 then
    error(("[The Voider][Shutdown] ORPHAN > 0 หลัง TEARDOWN (ห้าม force-clean — ต้อง ABORT/ROLLBACK): %s")
      :format(table.concat(self:_orphanNames(), ", ")), 0)
  end

  return report
end

return Shutdown

  end)();
  __TV_PACKAGES['shutdown'] = __m;
end
-- ==== package: init (core/runtime/init.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/init.lua
-- Runtime Layer assembler (แผน freeze v2.1 §3.2) — ประกอบ 5 องค์ประกอบเป็น Runtime เดียว
--
-- ลำดับโหลด (build/runner รับประกัน): registry → boundary → watchdog → shutdown
-- → capability → preflight → graph → init (ไฟล์นี้)
--
-- ใช้งาน:
--   local RuntimeLib = __TV_PACKAGES.init
--   local R = RuntimeLib.new({ clock = ..., task = task })
--   R:Bootstrap()            -- probe capability + เปิด watchdog monitor + อ่าน graph
--   R.Spawn(...) R.Connect(...) R.NewRender(...) R.Temp(...)   -- ลายเซ็นตามแผน §3.2
--   R.ShutdownAll()          -- ปิดตาม graph + คืนทุกอย่าง (orphan ต้อง 0)
-- ============================================================================

local P = __TV_PACKAGES
local Registry = P.registry
local Boundary = P.boundary
local Watchdog = P.watchdog
local ShutdownManager = P.shutdown
local Capability = P.capability
local Preflight = P.preflight
local Graph = P.graph

local RuntimeLib = {}

RuntimeLib.version = "0.1.0"

-- loader ใช้ก่อนโหลด core (§3.2 ข้อ 0) — build จะ embed preflight ลง loader.lua
RuntimeLib.Preflight = Preflight

function RuntimeLib.new(ctx)
  ctx = ctx or {}

  local boundary = Boundary.new(ctx)
  local registry = Registry.new(ctx)
  local watchdog = Watchdog.new(ctx)
  local shutdown = ShutdownManager.new(ctx)
  local capability = Capability.new(ctx)

  -- เชื่อมองค์ประกอบเข้าหากัน (registry → boundary/watchdog, watchdog → registry/boundary)
  registry:SetBoundary(boundary)
  registry:SetWatchdog(watchdog)
  watchdog:SetRegistry(registry)
  watchdog:SetBoundary(boundary)
  shutdown:SetBoundary(boundary)
  shutdown:SetRegistry(registry)

  local R = {}

  R.version = RuntimeLib.version
  R.ctx = ctx
  R.Graph = Graph
  R.Registry = registry
  R.Boundary = boundary
  R.Watchdog = watchdog
  R.Shutdown = shutdown
  R.Capability = capability

  -- ---- API ตามแผน §3.2 (ลายเซ็นตรงเป๊ะ) ------------------------------

  R.Spawn = function(name, fn)
    return registry:Spawn(name, fn)
  end
  R.Connect = function(signal, fn)
    return registry:Connect(signal, fn)
  end
  R.NewRender = function(kind, props)
    return registry:NewRender(kind, props)
  end
  R.Temp = function(obj, disposer)
    return registry:Temp(obj, disposer)
  end

  -- ---- ความเป็นเจ้าของ / หายใจ ------------------------------------------

  R.Scope = function(owner, fn)
    return registry:Scope(owner, fn)
  end
  R.Owner = function()
    return registry:Owner()
  end
  R.Beat = function(owner)
    watchdog:Beat(owner)
  end

  -- ---- ตรวจนับ / คืนทรัพยากร / ตรวจ orphan ------------------------------

  R.Snapshot = function(owner)
    return registry:Snapshot(owner)
  end
  R.List = function(owner)
    return registry:List(owner)
  end
  R.Release = function(owner)
    return registry:Release(owner)
  end
  R.ReleaseAll = function()
    return registry:Release(nil)
  end
  R.VerifyZero = function(owner)
    return registry:VerifyZero(owner)
  end
  -- ใช้ตอน hot update VERIFY (§3.6 ขั้น 8) — นับเฉพาะของโมดูล (ไม่รวม Runtime.*)
  R.ModuleTotals = function()
    return registry:ModuleTotals()
  end

  -- ---- lifecycle ของ Runtime ทั้งชุด -------------------------------------

  -- เรียกครั้งเดียวหลังสร้าง: probe capability 8 ตัว + เปิด watchdog monitor
  -- + ตั้งลำดับ shutdown จาก Dependency Graph (SSOT เดียว §3.10)
  R.Bootstrap = function()
    capability:Probe()
    watchdog:Start()
    if Graph and Graph.initOrder then
      shutdown:Configure(Graph.initOrder)
    end
    return R
  end

  -- ปิดทุกอย่างตามลำดับ graph: hook ของโมดูล (Disable→Destroy กลับลำดับ init)
  -- แล้วปิด runtime เองเป็นท้ายสุด + คืนทรัพยากรทุกชิ้น — จบแล้ว orphan ต้องเท่ากับ 0
  R.ShutdownAll = function(opts)
    local report = shutdown:Run(opts)
    watchdog:Stop()
    registry:Release(nil)
    return report
  end

  return R
end

return RuntimeLib

  end)();
  __TV_PACKAGES['init'] = __m;
end
-- ==== package: json (core/foundation/json.lua) ====
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
  __TV_PACKAGES['json'] = __m;
end
-- ==== package: services (core/foundation/services.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/foundation/services.lua
-- Service Registry — Direct Services (แผน freeze v2.1 §3.5)
--
--   hot path (target query, prediction, camera state, combat state, คำนวณ
--   per-frame) เรียกตรงผ่าน service interface — ไม่ผ่าน event
--
--   กฎคู่ของ Services (§3.5):
--     (1) Service = สำหรับ "query" ที่ตอบเร็ว ไม่มี side effect แฝง
--         → Define() บังคับว่าทุก field ต้องเป็น function เท่านั้น
--     (2) ถ้าการทำงานนั้นเปลี่ยน state ที่โมดูลอื่นสนใจ → ต้องประกาศผ่าน
--         Event Bus เสมอ (service ไม่แจ้งเอง = ใครก็ไม่พลาด event)
--
--   ผู้ใช้จริง: L4 Shared Services (TargetService, PredictionService,
--   CameraService, CombatStateService) จะ Define ที่นี่ในเฟสถัด ๆ ไป
-- ============================================================================

local Services = {}
Services.__index = Services

Services.VERSION = "0.2.0"

function Services.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    services = {},  -- [name] = interface table (function เท่านั้น)
    order = {},     -- ชื่อตามลำดับ Define (แสดงใน Diagnostics สม่ำเสมอ)
    history = {},   -- บันทึกการ Define/Replace (audit ตอน hot update)
  }, Services)
  return self
end

--- ลงทะเบียน service — iface ต้องเป็น table ที่ทุก field เป็น function
--- opts.replace = true → อนุญาตแทนที่ของเดิม (ใช้ตอน hot update รุ่นใหม่)
function Services:Define(name, iface, opts)
  opts = opts or {}
  if type(name) ~= "string" or #name == 0 then
    error("Services:Define(name, iface): name ต้องเป็น string ไม่ว่าง", 2)
  end
  if type(iface) ~= "table" then
    error(("Services:Define(%s): iface ต้องเป็น table"):format(name), 2)
  end
  for k, v in pairs(iface) do
    if type(v) ~= "function" then
      error(("Services:Define(%s): field '%s' ต้องเป็น function — service เป็น query-only (§3.5 กฎ 1)")
        :format(name, tostring(k)), 2)
    end
  end
  local existed = self.services[name] ~= nil
  if existed and not opts.replace then
    error(("Services:Define(%s): ชื่อนี้มีอยู่แล้ว — ใช้ opts.replace = true เพื่อแทนที่ (hot update)")
      :format(name), 2)
  end
  if not existed then
    table.insert(self.order, name)
  end
  self.services[name] = iface
  table.insert(self.history, {
    op = existed and "replace" or "define",
    name = name,
    at = os.clock(),
  })
  if #self.history > 100 then
    table.remove(self.history, 1)
  end
  return self
end

--- ถอน service (TEARDOWN ของผู้ให้บริการ)
function Services:Undefine(name)
  if self.services[name] == nil then
    return false
  end
  self.services[name] = nil
  for i, n in ipairs(self.order) do
    if n == name then
      table.remove(self.order, i)
      break
    end
  end
  table.insert(self.history, { op = "undefine", name = name, at = os.clock() })
  return true
end

--- ดึง service — คืน iface หรือ nil (hot path ต้องไม่ error — เช็ค nil เอง)
function Services:Get(name)
  return self.services[name]
end

--- ดึง service แบบบังคับ — ไม่มี = error ชัดเจนพร้อมรายชื่อที่มีจริง
--- (ใช้ตอน Init ของโมดูลเพื่อ fail-fast ตาม dependency graph)
function Services:MustGet(name)
  local svc = self.services[name]
  if not svc then
    local avail = #self.order > 0 and table.concat(self.order, ", ") or "(ไม่มีเลย)"
    error(("Services:MustGet(%s): service นี้ยังไม่ถูก Define — ที่มีอยู่: %s"):format(name, avail), 2)
  end
  return svc
end

--- รายชื่อ service ทั้งหมดเรียงตามลำดับ Define
function Services:List()
  local out = {}
  for i, n in ipairs(self.order) do
    out[i] = n
  end
  return out
end

--- สถิติ (Diagnostics §8.4)
function Services:Stats()
  return { count = #self.order }
end

return Services

  end)();
  __TV_PACKAGES['services'] = __m;
end
-- ==== package: eventbus (core/foundation/eventbus.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/foundation/eventbus.lua
-- Event Bus (แผน freeze v2.1 §3.5 — ช่องทางสื่อสารความถี่ต่ำ-กลาง)
--
--   ใช้สำหรับ: Lifecycle (โมดูลเปิด/ปิด/พัง) / Notification / Config change /
--   Cross-module signal ทั่วไป (เป้าตาย, กำลังสลับเซิร์ฟเวอร์)
--   ส่วน hot path (per-frame query) ต้องเรียก Direct Service (services.lua) เท่านั้น
--
--   + §3.6 FREEZE/RESUME (hot update ขั้น 4/9):
--       Freeze()  → event ใหม่เข้าคิวพร้อม metadata 5 ช่อง
--                   (generation, timestamp, type, replayable, payload)
--       Resume()  → replay ตาม Replay Policy:
--         "drop"       Transient (เหตุการณ์เก่า เกิดแล้วเกิดเลย) → ทิ้งทั้งหมด
--                      โมดูลรุ่นใหม่ re-derive สถานะจาก Game Adapter เอง
--         "replay"     State/Config (สถานะที่ยังมีผล) → replay เรียง timestamp
--                      (ลำดับเดิม = last-write-wins โดยธรรมชาติ)
--         "idempotent" ทำซ้ำได้ผลเดิม → replay ปลอดภัย
--
--   + CR-REPLAY-001 (อนุมัติโดยเจ้าของโปรเจกต์ 1 ตุลาคม 2026 — ตัวเลือก ข):
--       คิวระหว่าง freeze ต้องข้าม generation ได้ตาม §3.6 ดั้งเดิม:
--         ExportQueue() → สำเนาคิวทั้งหมดพร้อม payload (deep clone) —
--           orchestrator (update.lua) เรียกจาก bus รุ่นเก่าก่อน TEARDOWN
--         ImportQueue(events) → รับเข้าคิวของ bus รุ่นปลายทาง (ต้อง frozen)
--           โดย policy ถูกตัดสินใหม่ตาม Declare ของรุ่นปลายทาง แล้ว replay
--           ตอน Resume — Transient DROP / State-Config REPLAY (LWW) /
--           Idempotent REPLAY / สถานะโลกจริง DROP + re-derive จาก Adapter
--
--   ความปลอดภัย:
--     - subscriber callback รันภายใต้ Error Boundary ของ "เจ้าของ subscription"
--       (พังเองไม่ลามไปคนอื่น §3.2 ข้อ 3)
--     - subscription = temporary resource ใน Resource Registry (ผ่าน Runtime.Temp)
--       → Module:Destroy() คืนของครบ orphan=0 อัตโนมัติ (§3.4)
--     - event ที่ยังไม่ Declare = policy "drop" (safe default) + นับ undeclared
--       ให้ Diagnostics เห็น (จับ typo ของชื่อ event)
-- ============================================================================

local Bus = {}
Bus.__index = Bus

Bus.POLICIES = { drop = true, replay = true, idempotent = true }

Bus.VERSION = "0.3.0"

-- deep clone ค่าที่ serialize ได้ (payload ของ event ต้องเป็น plain table เท่านั้น)
local function deepClone(v)
  if type(v) ~= "table" then return v end
  local out = {}
  for k, val in pairs(v) do
    out[k] = deepClone(val)
  end
  return out
end

-- ตรวจว่า payload "replay ได้" จริง: ห้าม function/userdata/thread ฝังอยู่
-- (ข้าม generation = ต้องไม่ผูกอะไรที่มีชีวิตของรุ่นเก่าติดมาด้วย)
local function replayablePayload(p)
  if p == nil then return true end
  if type(p) ~= "table" then return true end -- string/number/boolean ใช้ได้
  for k, v in pairs(p) do
    if type(k) ~= "string" and type(k) ~= "number" then return false end
    local tv = type(v)
    if tv == "function" or tv == "userdata" or tv == "thread" then return false end
    if tv == "table" and not replayablePayload(v) then return false end
  end
  return true
end

function Bus.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    clock = ctx.clock or os.clock,
    registry = ctx.registry,   -- Resource Registry (ไม่มี = โหมด standalone เช่น L1)
    boundary = ctx.boundary,   -- Error Boundary (ไม่มี = pcall ธรรมดา)
    hostOwner = ctx.owner or "EventBus", -- ชื่อ node ตาม dependency graph
    declared = {},   -- [evtType] = policy
    subs = {},       -- [evtType] = { {type, fn, owner, handle?} ... } (เรียงสมัคร)
    frozen = false,
    generation = 0,
    pendingGeneration = nil,
    queue = {},      -- event ค้างระหว่าง freeze (เรียงเวลา)
    stats = {
      published = 0, dispatched = 0, queued = 0, droppedOnResume = 0,
      undeclared = 0, subscriberErrors = 0,
      imported = 0,     -- CR-REPLAY-001: event ที่รับข้าม generation (ImportQueue)
      importDropped = 0, -- CR-REPLAY-001: event ข้าม generation ที่ถูกทิ้ง (payload ไม่ replay ได้)
    },
    _pubTimes = {},  -- timestamp ของ publish ล่าสุด (นับ events/sec)
  }, Bus)
  return self
end

--- ประกาศชนิด event + นโยบาย replay (ควร Declare ตอน init ก่อน Publish ครั้งแรก)
-- policy: "drop" | "replay" | "idempotent" — event ที่ไม่เคย Declare = "drop"
function Bus:Declare(evtType, policy)
  if type(evtType) ~= "string" or #evtType == 0 then
    error("Bus:Declare(evtType, policy): evtType ต้องเป็น string ไม่ว่าง", 2)
  end
  if not Bus.POLICIES[policy] then
    error(("Bus:Declare(%s): policy ต้องเป็น drop|replay|idempotent (ได้ %s)")
      :format(tostring(evtType), tostring(policy)), 2)
  end
  self.declared[evtType] = policy
  return self
end

--- ถอดการประกาศ (ใช้ตอน TEARDOWN ของผู้ประกาศ)
function Bus:Undeclare(evtType)
  self.declared[evtType] = nil
  return self
end

function Bus:Policy(evtType)
  return self.declared[evtType]
end

-- ---- subscription ----------------------------------------------------------

function Bus:_off(sub)
  local list = self.subs[sub.type]
  if not list then return end
  for i, s in ipairs(list) do
    if s == sub then
      table.remove(list, i)
      return true
    end
  end
  return false
end

--- สมัครรับ event — คืน handle ที่ Release() ได้ (และถ้ามี registry
--- จะถูกนับเป็น temporary resource ของ owner ปัจจุบันจนกว่าจะคืน — orphan ตรวจได้)
function Bus:On(evtType, fn)
  if type(fn) ~= "function" then
    error(("Bus:On(%s, fn): fn ต้องเป็น function"):format(tostring(evtType)), 2)
  end
  local owner
  if self.registry then
    owner = self.registry:Owner() or self.hostOwner
  else
    owner = self.hostOwner
  end
  local sub = { type = evtType, fn = fn, owner = owner }
  self.subs[evtType] = self.subs[evtType] or {}
  table.insert(self.subs[evtType], sub)

  if self.registry then
    -- §3.4: subscription เป็นทรัพยากรของโมดูลผู้สมัคร — Release ตาม owner อัตโนมัติ
    local h = self.registry:Temp(sub, function()
      self:_off(sub)
    end)
    sub.handle = h
    return h
  end
  -- โหมดไม่มี registry: handle เบา ๆ ที่ Off เองได้
  sub.Release = function() self:_off(sub) end
  sub.Off = sub.Release
  return sub
end

-- ---- publish ---------------------------------------------------------------

--- ส่ง event (payload ตารางธรรมดาเท่านั้น — ห้ามผูก userdata เพราะต้อง replay ได้)
-- คืน: จำนวน subscriber ที่รับ (หรือ 0 + "QUEUED" เมื่ออยู่ในช่วง freeze)
function Bus:Publish(evtType, payload)
  local policy = self.declared[evtType]
  if not policy then
    policy = "drop"
    self.stats.undeclared = self.stats.undeclared + 1
  end
  local evt = {
    generation = self.generation,
    timestamp = self.clock(),
    type = evtType,
    replayable = policy,
    payload = payload,
  }

  local pt = self._pubTimes
  table.insert(pt, evt.timestamp)
  if #pt > 256 then table.remove(pt, 1) end
  self.stats.published = self.stats.published + 1

  if self.frozen then
    table.insert(self.queue, evt)
    self.stats.queued = self.stats.queued + 1
    return 0, "QUEUED"
  end
  return self:_dispatch(evt)
end

function Bus:_dispatch(evt)
  local list = self.subs[evt.type]
  if not list or #list == 0 then return 0 end
  -- snapshot รายชื่อก่อนเดิน (subscriber อาจ Off ตัวเองกลาง dispatch)
  local targets = {}
  for _, s in ipairs(list) do
    table.insert(targets, s)
  end
  local n = 0
  for _, s in ipairs(targets) do
    n = n + 1
    local ok
    if self.boundary then
      -- error ของ subscriber = ของเจ้าของ subscription (ไม่ลามไป publisher)
      ok = self.boundary:Guard(s.owner, function()
        s.fn(evt.payload, evt)
      end)
    else
      ok = pcall(function()
        s.fn(evt.payload, evt)
      end)
    end
    if not ok then
      self.stats.subscriberErrors = self.stats.subscriberErrors + 1
    end
  end
  self.stats.dispatched = self.stats.dispatched + n
  return n
end

-- ---- freeze / resume (hot update §3.6 ขั้น 4 / 9) ---------------------------

--- หยุด dispatch — event ใหม่เข้าคิวพร้อม metadata
--- generation ที่ส่งมา = เลขรุ่นใหม่ของระบบ (จะใช้ตอน Resume)
function Bus:Freeze(generation)
  self.frozen = true
  self.pendingGeneration = generation or (self.generation + 1)
  return self
end

--- เปิด dispatch ใหม่ + เล่น event ในคิวตาม Replay Policy
--- คืน { replayed, dropped, total }
function Bus:Resume(generation)
  self.generation = generation or self.pendingGeneration or (self.generation + 1)
  self.pendingGeneration = nil
  self.frozen = false
  local q = self.queue
  self.queue = {}
  local replayed, dropped = 0, 0
  -- คิวเรียง timestamp อยู่แล้ว (insert เรียง) → replay = last-write-wins ตามลำดับเวลาจริง
  for _, evt in ipairs(q) do
    if evt.replayable == "drop" then
      dropped = dropped + 1
    else
      replayed = replayed + 1
      self:_dispatch(evt)
    end
  end
  self.stats.droppedOnResume = self.stats.droppedOnResume + dropped
  return { replayed = replayed, dropped = dropped, total = #q }
end

--- ล้างคิวทิ้งทั้งหมดโดยไม่ replay — ใช้เมื่อผู้ใช้งาน bus โดยตรงต้องการทิ้งคิว
--- อย่างชัดเจนเอง (หลัง CR-REPLAY-001: orchestrator ของ update ใช้
--- Export/Import + Resume แทน — replay ตาม policy ทั้งสอง path สำเร็จ/ย้อนรุ่น)
function Bus:DropQueue()
  local n = #self.queue
  self.queue = {}
  self.frozen = false
  self.stats.droppedOnResume = self.stats.droppedOnResume + n
  return n
end

--- สำเนาคิวปัจจุบัน (Diagnostics / ตรวจ state ระหว่าง hot update)
--- CR-REPLAY-001: คืนครบ 5 ช่องรวม payload (เดิมไม่คืน payload จึง replay
--- ข้าม generation ไม่ได้ — รากปัญหาของ CR) — payload เป็นอ้างอิงตารางจริง
--- ของคิว: ใช้อ่าน/ตรวจเท่านั้น ห้ามแก้ (จะแก้ = ใช้ ExportQueue ที่ clone ให้)
function Bus:Queue()
  local out = {}
  for i, evt in ipairs(self.queue) do
    out[i] = {
      generation = evt.generation,
      timestamp = evt.timestamp,
      type = evt.type,
      replayable = evt.replayable,
      payload = evt.payload,
    }
  end
  return out
end

--- CR-REPLAY-001 (§3.6 ตามคำตัดสินเจ้าของ 1 ตุลาคม 2026): ส่งออกคิวทั้งหมด
--- พร้อม payload แบบ deep clone เพื่อข้าม generation — orchestrator
--- (update.lua) เรียกจาก bus รุ่นเก่าหลัง TEARDOWN เสร็จ (คิวนิ่งแล้ว) แล้ว
--- Import เข้า bus ของระบบปลายทาง (รุ่นใหม่ หรือรุ่นเดิมกรณี rollback)
--- ไม่ล้างคิวเดิม (bus รุ่นเก่าจะตายตาม TEARDOWN อยู่แล้ว)
function Bus:ExportQueue()
  local out = {}
  for i, evt in ipairs(self.queue) do
    out[i] = {
      generation = evt.generation,
      timestamp = evt.timestamp,
      type = evt.type,
      replayable = evt.replayable,
      payload = deepClone(evt.payload),
    }
  end
  return out
end

--- CR-REPLAY-001: รับ event ที่ export จาก bus รุ่นอื่นเข้าคิวของ bus นี้
--- กฎสำคัญ:
---   - ใช้ได้เฉพาะขณะ frozen — event ถูก replay ตาม policy ตอน Resume เท่านั้น
---   - policy ตัดสินใหม่ตาม Declare ของ "bus ปลายทาง" (รุ่นปลายทางเป็นเจ้าของ
---     คำตอบ): ชนิดที่รุ่นนี้ไม่ Declare = drop (safe default เหมือน Publish)
---     + นับ undeclared ให้ Diagnostics เห็น
---   - payload ต้อง replay ได้ (plain — ห้าม function/userdata/thread):
---     ไม่ใช่ = drop + นับ importDropped (ห้ามผูกของมีชีวิตข้ามรุ่น)
---   - event ที่รับเข้ามาถูกแทรก "ก่อน" คิวเดิมของ bus นี้ (เกิดก่อน event
---     ที่เกิดระหว่าง MIGRATE) → replay เรียงเวลาจริงทั้งคิว last-write-wins
---   - generation/timestamp เก็บค่าอนุมมัยของ event ต้นทางไว้ตามจริง
--- คืน { accepted, dropped, total }
function Bus:ImportQueue(events)
  if not self.frozen then
    error("Bus:ImportQueue(events): ใช้ได้เฉพาะขณะ frozen — event จะถูก "
      .. "replay ตาม policy ตอน Resume เท่านั้น (CR-REPLAY-001 §3.6)", 2)
  end
  if events == nil then events = {} end
  if type(events) ~= "table" then
    error("Bus:ImportQueue(events): events ต้องเป็น table จาก ExportQueue", 2)
  end
  local accepted, dropped = 0, 0
  local imported = {}
  for _, src in ipairs(events) do
    if type(src) ~= "table" or type(src.type) ~= "string" or #src.type == 0 then
      dropped = dropped + 1
    elseif not replayablePayload(src.payload) then
      dropped = dropped + 1
      self.stats.importDropped = self.stats.importDropped + 1
    else
      local policy = self.declared[src.type]
      if not policy then
        policy = "drop"
        self.stats.undeclared = self.stats.undeclared + 1
      end
      if policy == "drop" then
        dropped = dropped + 1
      else
        accepted = accepted + 1
        imported[#imported + 1] = {
          generation = src.generation,
          timestamp = src.timestamp,
          type = src.type,
          replayable = policy,
          payload = src.payload,
        }
      end
    end
  end
  if #imported > 0 then
    -- แทรกข้างหน้าคิวเดิม: event ข้าม generation เกิดก่อน (timestamp เก่ากว่า)
    local merged = {}
    for _, e in ipairs(imported) do merged[#merged + 1] = e end
    for _, e in ipairs(self.queue) do merged[#merged + 1] = e end
    self.queue = merged
    self.stats.imported = self.stats.imported + accepted
  end
  return { accepted = accepted, dropped = dropped, total = #events }
end

-- ---- สถิติ (DiagnosticsService §8.4) ----------------------------------------

function Bus:Stats()
  local now = self.clock()
  local cutoff = now - 1.0
  local perSec = 0
  for i = #self._pubTimes, 1, -1 do
    if self._pubTimes[i] >= cutoff then
      perSec = perSec + 1
    else
      break
    end
  end
  local subscribers = 0
  for _, list in pairs(self.subs) do
    subscribers = subscribers + #list
  end
  local declaredCount = 0
  for _ in pairs(self.declared) do
    declaredCount = declaredCount + 1
  end
  return {
    subscribers = subscribers,
    declared = declaredCount,
    published = self.stats.published,
    dispatched = self.stats.dispatched,
    queued = #self.queue,
    frozen = self.frozen,
    generation = self.generation,
    perSec = perSec,
    undeclared = self.stats.undeclared,
    subscriberErrors = self.stats.subscriberErrors,
    droppedOnResume = self.stats.droppedOnResume,
    imported = self.stats.imported,       -- CR-REPLAY-001
    importDropped = self.stats.importDropped, -- CR-REPLAY-001
  }
end

--- ปิด event bus ทั้งตัว (TEARDOWN ของ node "EventBus") — ถอด subscriber ทุกตัว
--- (subscription handles ใน registry จะกลายเป็น no-op เพราะ _off หาไม่เจอแล้ว)
--- CR-REPLAY-001: "ไม่ล้างคิว" — event ที่ค้างในคิวต้องรอดพ้น Shutdown ของ
--- bus รุ่นเก่า เพื่อให้ orchestrator ExportQueue ข้าม generation ไป replay ตาม
--- policy ได้ (Idempotent เช่น config:saved ที่ hook ปล่อยตอนถอดระบบก็ต้อง replay)
--- bus ที่ Shutdown แล้วไม่มี subscriber — replay ภายหลังเป็น no-op ปลอดภัย
function Bus:Shutdown()
  self.subs = {}
  self.frozen = false
  return true
end

return Bus

  end)();
  __TV_PACKAGES['eventbus'] = __m;
end
-- ==== package: migration (core/foundation/migration.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/foundation/migration.lua
-- Migration Service — ลูกโซ่ migration ทีละเวอร์ชัน (แผน freeze v2.1 §3.7)
--
--   migrations[1] = v1→v2, migrations[2] = v2→v3, ...
--   โหลด config เก่าเข้ามาแล้วไล่รันทีละขั้นจนถึงเวอร์ชันปัจจุบัน — ห้ามข้ามขั้น
--
--   หลักการ "config ของผู้ใช้คือของมีค่า — ห้ามทิ้ง" (§3.7):
--     key เก่าที่เลิกใช้ ต้องเก็บค่าไว้ใน cfg._legacy[oldPath] ด้วย Migration.Keep()
--     เพื่อให้กู้คืน/ตรวจสอบย้อนหลังได้เสมอ
--
--   คุณสมบัติที่การใช้งานจริงต้องได้ (และมี L1 พิสูจน์):
--     - ลูกโซ่หลายขั้น v1→v2→v3 รันเรียงถูกต้อง ห้ามข้ามขั้น (ขั้นขาด = error ชัด)
--     - idempotent: Run() ซ้ำกับ config ที่เป็นรุ่นล่าสุดแล้ว = no-op เป๊ะ ๆ
--     - ข้อมูลสำคัญไม่หาย: ค่าที่เปลี่ยนชื่อ key ต้องยังอยู่ + เก็บ legacy ครบ
-- ============================================================================

local Migration = {}
Migration.__index = Migration

Migration.VERSION = "0.2.0"

function Migration.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    steps = {},       -- [fromV] = fn(cfg) → cfg
    clock = ctx.clock or os.clock,
    lastRun = nil,    -- รายงานรอบล่าสุด { from, to, steps = {fromV...}, ms }
  }, Migration)
  return self
end

--- ลงทะเบียนขั้น migration: จาก schemaVersion = fromV เป็น fromV + 1
--- fn(cfg) แก้/ย้าย/เติม field แล้วคืน cfg (แก้ in-place หรือคืนตารางใหม่ก็ได้)
function Migration:Register(fromV, fn)
  if type(fromV) ~= "number" or fromV < 1 or math.floor(fromV) ~= fromV then
    error("Migration:Register(fromV, fn): fromV ต้องเป็นจำนวนเต็มบวก", 2)
  end
  if type(fn) ~= "function" then
    error(("Migration:Register(%d, fn): fn ต้องเป็น function"):format(fromV), 2)
  end
  if self.steps[fromV] then
    error(("Migration:Register(%d): ขั้นนี้ลงทะเบียนซ้ำ (v%d→v%d มีแล้ว)"):format(fromV, fromV, fromV + 1), 2)
  end
  self.steps[fromV] = fn
  return self
end

--- เวอร์ชันสูงสุดที่ migrate ไปได้จากขั้นที่ลงทะเบียนครบ (target ของ Run)
function Migration:Latest()
  -- หา fromV สูงสุด แล้ว +1 — ถ้าไม่มีขั้นเลย = 1 (ยังไม่มี migration)
  local maxFrom = 0
  for fromV in pairs(self.steps) do
    if fromV > maxFrom then maxFrom = fromV end
  end
  return maxFrom + 1
end

--- รายการขั้นที่ลงทะเบียน (เรียง) — ใช้ตรวจว่าลูกโซ่ต่อเนื่อง
function Migration:Steps()
  local out = {}
  local froms = {}
  for fromV in pairs(self.steps) do
    table.insert(froms, fromV)
  end
  table.sort(froms)
  for _, fromV in ipairs(froms) do
    table.insert(out, ("v%d→v%d"):format(fromV, fromV + 1))
  end
  return out
end

--- helper สำหรับ step: เก็บค่า key เก่าไว้ใน cfg._legacy[oldPath] (ห้ามทิ้ง §3.7)
function Migration.Keep(cfg, oldPath, value)
  if value == nil then return cfg end
  cfg._legacy = cfg._legacy or {}
  cfg._legacy[oldPath] = value
  return cfg
end

--- รันลูกโซ่ migration จาก cfg.schemaVersion จนถึง targetV (default = Latest)
--- - ห้ามข้ามขั้น: ขั้นไหนไม่ได้ลงทะเบียน = error ทันที (พร้อมระบุขั้นที่ขาด)
--- - idempotent: schemaVersion >= target แล้ว = คืน cfg เดิมไม่แตะ
--- - cfg.schemaVersion ไม่ใช่ตัวเลข = error (ไฟล์เสีย — ผู้เรียกจัด fallback)
--- คืน: cfg รุ่นใหม่ (ตารางเดิมถ้า no-op)
function Migration:Run(cfg, targetV)
  if type(cfg) ~= "table" then
    error("Migration:Run(cfg): cfg ต้องเป็น table", 2)
  end
  targetV = targetV or self:Latest()
  local from = cfg.schemaVersion
  if type(from) ~= "number" then
    error(("Migration:Run: cfg.schemaVersion ไม่ใช่ตัวเลข (ได้ %s) — config เสีย")
      :format(tostring(from)), 2)
  end
  if from >= targetV then
    self.lastRun = { from = from, to = from, steps = {}, noop = true, ms = 0 }
    return cfg
  end

  local t0 = self.clock()
  local ran = {}
  local v = from
  while v < targetV do
    local step = self.steps[v]
    if not step then
      error(("Migration:Run: ขั้น v%d→v%d ไม่ได้ลงทะเบียน — ห้ามข้ามขั้น (§3.7) ลงทะเบียนก่อน: %s")
        :format(v, v + 1, table.concat(self:Steps(), ", ")), 2)
    end
    local ok, result = pcall(step, cfg)
    if not ok then
      error(("Migration:Run: ขั้น v%d→v%d พัง: %s"):format(v, v + 1, tostring(result)), 2)
    end
    cfg = result or cfg
    if type(cfg) ~= "table" then
      error(("Migration:Run: ขั้น v%d→v%d คืนค่าไม่ใช่ table"):format(v, v + 1), 2)
    end
    cfg.schemaVersion = v + 1
    table.insert(ran, v)
    v = v + 1
  end
  self.lastRun = {
    from = from, to = targetV, steps = ran, noop = false,
    ms = (self.clock() - t0) * 1000,
  }
  return cfg
end

--- รายงานรอบล่าสุด (Diagnostics ตรวจเวลา migration ต่อขั้น)
function Migration:LastRun()
  return self.lastRun
end

return Migration

  end)();
  __TV_PACKAGES['migration'] = __m;
end
-- ==== package: config (core/foundation/config.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/foundation/config.lua
-- Config Service (แผน freeze v2.1 §3.7) — config ของผู้ใช้คือของมีค่า
--
--   โครงสร้างทุกไฟล์: { schemaVersion, profile = {...}, settings = {...} }
--   พื้นที่เก็บ: FILEIO ของ executor ถ้ามี (thevoider/config.json)
--               ไม่มี = หน่วยความจำ (สถานะเดียวกับ "ไม่ persist" — ต้องแจ้งผู้ใช้)
--
--   Fallback เมื่อไฟล์เสีย (§3.7): parse ไม่ผ่าน / migrate ไม่ผ่าน
--     → สำรองไฟล์เก่าเป็น .bak พร้อม timestamp → โหลด default
--     → แจ้งผู้ใช้ผ่าน Event Bus ("notify:user") + เปิดโหลด .bak คืนได้ (ListBackups)
--
--   เหตุการณ์ที่ประกาศ (Declare ตอน Init):
--     config:changed  (replay)     — Set() เปลี่ยนค่า { path, value }
--     config:replaced (replay)     — Replace() ทั้งก้อน (hot update/rollback)
--     config:loaded   (idempotent) — โหลด/เริ่มระบบเสร็จ { source }
--     config:saved    (idempotent) — Save() สำเร็จ { at }
--     notify:user     (idempotent) — ข้อความถึงผู้ใช้ { level, key, params }
--
--   migration จริงตัวแรก (§3.7): v1→v2 ย้าย settings.Aimbot.FOV →
--   settings.VoidAim.fov + เก็บค่าเก่าไว้ใน _legacy (ห้ามทิ้ง)
-- ============================================================================

local P = __TV_PACKAGES
local JsonLib = P.json

local Config = {}
Config.__index = Config

Config.VERSION = "0.2.0"

Config.CURRENT_SCHEMA_VERSION = 2

Config.FILE_PREFIX = "thevoider/config"

-- ---- default ---------------------------------------------------------------

function Config.Default()
  return {
    schemaVersion = Config.CURRENT_SCHEMA_VERSION,
    profile = {
      name = "หลัก",
      createdAt = os.time(),
      updatedAt = os.time(),
    },
    settings = {
      VoidAim = { mode = "EZ", fov = 120 }, -- โครงตาม §3.7 (โมดูลจริงมาเฟส 2)
      i18n = { lang = "th" },
      Keybinds = {},
    },
  }
end

-- ---- helpers ----------------------------------------------------------------

local function deepClone(v)
  if type(v) ~= "table" then return v end
  local out = {}
  for k, val in pairs(v) do
    out[k] = deepClone(val)
  end
  return out
end

local function splitPath(path)
  local parts = {}
  for seg in string.gmatch(path, "[^.]+") do
    parts[#parts + 1] = seg
  end
  if #parts == 0 then
    error(("Config: path %q ว่าง"):format(tostring(path)), 3)
  end
  return parts
end

-- path สองระดับตามโครง §3.7:
--   "schemaVersion" / "profile.*" / "settings.*" / "_legacy" → ระดับบนสุดของ config
--   "VoidAim.fov" / "i18n.lang" / "Keybinds.toggle"       → อยู่ใต้ cfg.settings เสมอ
-- (โมดูลไม่ต้องเขียน "settings." นำหน้า — แต่โครงไฟล์ยังตรงแผน §3.7)
local RESERVED_TOP = {
  schemaVersion = true,
  profile = true,
  settings = true,
  _legacy = true,
}

local function resolveForGet(cfg, path)
  local parts = splitPath(path)
  if RESERVED_TOP[parts[1]] then
    return cfg, parts
  end
  return (type(cfg.settings) == "table") and cfg.settings or {}, parts
end

local function resolveForSet(cfg, path)
  local parts = splitPath(path)
  if RESERVED_TOP[parts[1]] then
    return cfg, parts
  end
  if type(cfg.settings) ~= "table" then
    cfg.settings = {}
  end
  return cfg.settings, parts
end

-- ---- constructors ------------------------------------------------------------

-- storage แบบไฟล์ executor (FILEIO)
local function fileStorage(path)
  local readFileFn = rawget(_G, "readfile")
  local writeFileFn = rawget(_G, "writefile")
  local isFileFn = rawget(_G, "isfile")
  return {
    kind = "file",
    path = path,
    exists = function() return isFileFn and isFileFn(path) or false end,
    read = function()
      if not readFileFn then return nil, "ไม่มี readfile" end
      local ok, content = pcall(readFileFn, path)
      if not ok then return nil, tostring(content) end
      return content
    end,
    write = function(content)
      if not writeFileFn then return false, "ไม่มี writefile" end
      local ok, err = pcall(writeFileFn, path, content)
      if not ok then return false, tostring(err) end
      return true
    end,
  }
end

-- storage แบบหน่วยความจำ (ทดสอบ / executor ไม่มี FILEIO)
local function memoryStorage()
  local mem = {}
  return {
    kind = "memory",
    exists = function() return mem.data ~= nil end,
    read = function()
      if mem.data == nil then return nil, "ยังไม่เคยเขียน" end
      return mem.data
    end,
    write = function(content)
      mem.data = content
      return true
    end,
  }
end

function Config.new(ctx)
  ctx = ctx or {}
  local storage
  if ctx.storage then
    storage = ctx.storage
  elseif rawget(_G, "readfile") and rawget(_G, "writefile") and rawget(_G, "isfile") then
    storage = fileStorage(ctx.path or (Config.FILE_PREFIX .. ".json"))
  else
    storage = memoryStorage()
  end
  local self = setmetatable({
    clock = ctx.clock or os.clock,
    time = ctx.time or os.time,
    bus = ctx.bus,                 -- Event Bus (ส่ง config:changed / notify:user)
    migration = ctx.migration,     -- Migration Service
    storage = storage,
    cfg = nil,                     -- ตาราง config ปัจจุบัน (แก้หลัง Load)
    status = "not-loaded",         -- not-loaded | default | file | migrated | corrupted | migration-failed
    loadInfo = nil,                -- รายละเอียดรอบโหลดล่าสุด
    dirty = false,
    backups = {},                  -- รายการ .bak ที่สร้าง [{ name, at }]
  }, Config)
  self:_registerMigrations()
  return self
end

-- ---- migration จริงตัวแรก (§3.7: Aimbot.FOV → VoidAim.fov) -------------------

function Config:_registerMigrations()
  local m = self.migration
  if not m then return end
  -- v1 → v2: ย้ายชื่อชั่วคราวระหว่างพัฒนา "Aimbot.FOV" → "VoidAim.fov"
  m:Register(1, function(cfg)
    cfg.settings = cfg.settings or {}
    cfg.settings.VoidAim = cfg.settings.VoidAim or {}
    local old = cfg.settings.Aimbot
    if type(old) == "table" and old.FOV ~= nil then
      -- ห้ามเขียนทับค่าใหม่ถ้ามีอยู่แล้ว (last config wins)
      if cfg.settings.VoidAim.fov == nil then
        cfg.settings.VoidAim.fov = old.FOV
      end
      -- ห้ามทิ้ง (§3.7): เก็บของเก่าไว้ใน _legacy เสมอ
      self.migration.Keep(cfg, "settings.Aimbot", old)
    end
    cfg.settings.Aimbot = nil
    return cfg
  end)
end

-- ---- internal ----------------------------------------------------------------

function Config:_notify(level, key, params)
  if self.bus then
    self.bus:Publish("notify:user", { level = level, key = key, params = params or {} })
  end
end

function Config:_backupCorrupt(content, why)
  -- สำรองไฟล์เสียเป็น .bak พร้อม timestamp ก่อนทำอย่างอื่น (§3.7)
  local name = ("%s.corrupt-%d.bak"):format(self.storage.path or "memory", self.time())
  table.insert(self.backups, { name = name, at = self.time(), reason = tostring(why), kind = "corrupt" })
  if #self.backups > 10 then
    table.remove(self.backups, 1)
  end
  -- หมายเหตุ: storage แบบไฟล์จริงเขียน .bak ผ่าน writefile ถ้ามี
  local writeFileFn = rawget(_G, "writefile")
  if self.storage.kind == "file" and writeFileFn and type(content) == "string" then
    pcall(writeFileFn, name, content)
  end
end

-- ---- API หลัก ------------------------------------------------------------------

--- โหลด config — ลำดับ: ไฟล์ (→ decode → migrate) → default เมื่อเสีย
--- คืน { status, migratedFrom?, error? } — ไม่มีทาง error ยกเละ (ทุก path ได้ config ใช้ได้)
function Config:Load()
  -- อ่านไฟล์
  local content, readErr = self.storage.read()
  if content == nil then
    self.cfg = Config.Default()
    self.status = "default"
    self.loadInfo = { status = self.status, reason = tostring(readErr) }
    self:_notify("info", "notify.config.default", {})
    return self.loadInfo
  end

  -- decode
  local ok, decoded = pcall(JsonLib.decode, content)
  if not ok or type(decoded) ~= "table" then
    self:_backupCorrupt(content, decoded)
    self.cfg = Config.Default()
    self.status = "corrupted"
    self.loadInfo = { status = self.status, error = tostring(decoded) }
    self:_notify("warn", "notify.config.corrupted", { backup = self.backups[#self.backups] and self.backups[#self.backups].name or "" })
    return self.loadInfo
  end

  -- migrate สู่รุ่นปัจจุบัน (ห้ามข้ามขั้น — ขั้นขาด = error = fallback)
  local migratedFrom
  if self.migration and type(decoded.schemaVersion) == "number"
      and decoded.schemaVersion < Config.CURRENT_SCHEMA_VERSION then
    local okM, migrated = pcall(self.migration.Run, self.migration, decoded, Config.CURRENT_SCHEMA_VERSION)
    if not okM then
      self:_backupCorrupt(content, migrated)
      self.cfg = Config.Default()
      self.status = "migration-failed"
      self.loadInfo = { status = self.status, error = tostring(migrated) }
      self:_notify("warn", "notify.config.migration_failed", {})
      return self.loadInfo
    end
    decoded = migrated
    migratedFrom = true
  end

  -- เติม field ที่หาย (default merge แบบตื้น: เฉพาะระดับบน + settings รายโมดูล)
  decoded.profile = decoded.profile or Config.Default().profile
  decoded.settings = decoded.settings or {}
  self.cfg = decoded
  self.status = migratedFrom and "migrated" or "file"
  self.loadInfo = { status = self.status, migratedFrom = migratedFrom }
  self:_notify("info", "notify.config.loaded", { source = self.status })
  if self.bus then
    self.bus:Publish("config:loaded", { source = self.status })
  end
  return self.loadInfo
end

--- บันทึก config ลง storage — คืน (true) หรือ (false, err)
function Config:Save()
  if not self.cfg then
    return false, "ยังไม่ได้ Load()"
  end
  self.cfg.profile.updatedAt = self.time()
  local okEnc, encoded = pcall(JsonLib.encode, self.cfg)
  if not okEnc then
    return false, ("เข้ารหัสไม่ผ่าน: %s"):format(tostring(encoded))
  end
  local okW, errW = self.storage.write(encoded)
  if not okW then
    return false, ("เขียนไฟล์ไม่ผ่าน: %s"):format(tostring(errW))
  end
  self.dirty = false
  if self.bus then
    self.bus:Publish("config:saved", { at = self.time() })
  end
  return true
end

--- อ่านค่าตาม path — คืน (value) หรือ (nil) — path ระดับโมดูล (เช่น "VoidAim.fov")
--- อยู่ใต้ settings อัตโนมัติ ส่วนระดับบนสุด (schemaVersion/profile/...) อ่านตรง
function Config:Get(path)
  if not self.cfg then
    error("Config:Get: ยังไม่ได้ Load()", 2)
  end
  local cur, parts = resolveForGet(self.cfg, path)
  for _, seg in ipairs(parts) do
    if type(cur) ~= "table" then return nil end
    cur = cur[seg]
  end
  return cur
end

--- ตั้งค่า + ประกาศ config:changed — opts.save = true → Save ทันที
function Config:Set(path, value, opts)
  if not self.cfg then
    error("Config:Set: ยังไม่ได้ Load()", 2)
  end
  local cur, parts = resolveForSet(self.cfg, path)
  for i = 1, #parts - 1 do
    local seg = parts[i]
    if type(cur[seg]) ~= "table" then
      cur[seg] = {}
    end
    cur = cur[seg]
  end
  cur[parts[#parts]] = value
  self.dirty = true
  if self.bus then
    self.bus:Publish("config:changed", { path = path, value = value })
  end
  if opts and opts.save then
    return self:Save()
  end
  return true
end

--- สำเนา config ทั้งก้อน (สำหรับ Rollback Snapshot configState §3.6)
function Config:Data()
  if not self.cfg then return nil end
  return deepClone(self.cfg)
end

--- แทนที่ config ทั้งก้อน (hot update MIGRATE สำเร็จ / rollback กลับรุ่นเก่า)
--- cfg ต้องเป็น table ที่ schemaVersion = ปัจจุบันแล้ว
function Config:Replace(cfg)
  if type(cfg) ~= "table" then
    error("Config:Replace(cfg): cfg ต้องเป็น table", 2)
  end
  if cfg.schemaVersion ~= Config.CURRENT_SCHEMA_VERSION then
    error(("Config:Replace: schemaVersion ต้องเป็น %d (ได้ %s) — migrate ก่อน")
      :format(Config.CURRENT_SCHEMA_VERSION, tostring(cfg.schemaVersion)), 2)
  end
  self.cfg = deepClone(cfg)
  self.dirty = true
  if self.bus then
    self.bus:Publish("config:replaced", {})
  end
  return true
end

--- สถานะการ persist — Diagnostics แสดงเตือนเมื่อ "ไม่ persist"
function Config:StorageKind()
  return self.storage.kind
end

--- รายการ backup ที่สร้างไว้ (แท็บ Setup จะให้โหลดคืน — เฟส 1)
function Config:ListBackups()
  local out = {}
  for _, b in ipairs(self.backups) do
    table.insert(out, { name = b.name, at = b.at, reason = b.reason })
  end
  return out
end

--- ปิด node (TEARDOWN) — Save ถ้า dirty และ persist ได้ (พยายามเก็บของผู้ใช้เสมอ)
function Config:Shutdown()
  if self.dirty then
    local ok, err = pcall(self.Save, self)
    if not ok then
      self:_notify("warn", "notify.config.save_failed", { error = tostring(err) })
    end
  end
  return true
end

return Config

  end)();
  __TV_PACKAGES['config'] = __m;
end
-- ==== package: i18n (core/foundation/i18n.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/foundation/i18n.lua
-- I18n Service (แผน freeze v2.1 §5.3 — ไทย/อังกฤษ + key coverage 100%)
--
--   T(key, params)     แปล key → ข้อความภาษาปัจจุบัน + interpolate {ชื่อ}
--   Set(lang)          สลับภาษา + ประกาศ "i18n:changed" (UI ฟังเพื่อ render ใหม่)
--   AddTable(lang, t)  โมดูล/UI เติมคำศัพท์ภายหลัง (เฟส 1+)
--   Coverage()         ตรวจ key ครบทุกภาษาไหม — เกณฑ์ DoD เฟส 1: 100% ห้ามตกหล่น
--
--   fallback: ภาษาปัจจุบัน → ภาษาหลัก (th) → คืน key เปล่า (เห็นชัดว่าหาย —
--   ไม่เงียบ §3.9 ข้อ 5) + Coverage() จับได้ทันที
-- ============================================================================

local I18n = {}
I18n.__index = I18n

I18n.VERSION = "0.2.0"

I18n.DEFAULT_LANG = "th"
I18n.LANGS = { "th", "en" }

-- คำศัพท์ของ Foundation + Adapter (รอบนี้) — โมดูลเติมเองผ่าน AddTable ภายหลัง
local BASE = {
  -- การแจ้งเตือน config (§3.7)
  ["notify.config.default"] = {
    th = "เริ่มต้นด้วยค่าตั้งต้น (ยังไม่มีไฟล์ config)",
    en = "Starting with default settings (no config file yet)",
  },
  ["notify.config.corrupted"] = {
    th = "ไฟล์ config เสีย — สำรองเป็น {backup} แล้ว ใช้ค่าตั้งต้นชั่วคราว",
    en = "Config file corrupted — backed up as {backup}, using defaults for now",
  },
  ["notify.config.migration_failed"] = {
    th = "ย้าย config ข้ามเวอร์ชันไม่สำเร็จ — สำรองไฟล์เก่าแล้ว ใช้ค่าตั้งต้น",
    en = "Config migration failed — old file backed up, using defaults",
  },
  ["notify.config.loaded"] = {
    th = "โหลด config สำเร็จ ({source})",
    en = "Config loaded ({source})",
  },
  ["notify.config.save_failed"] = {
    th = "บันทึก config ไม่สำเร็จ: {error}",
    en = "Failed to save config: {error}",
  },
  -- การแจ้งเตือน adapter (§3.3 กฎ 3)
  ["notify.adapter.degraded"] = {
    th = "Adapter {name} เสื่อมบางส่วน — ฟีเจอร์ที่เกี่ยวข้องปิดตัวเองชั่วคราว รออัปเดต The Voider",
    en = "Adapter {name} partially degraded — related features disabled until The Voider update",
  },
  ["notify.adapter.dead"] = {
    th = "Adapter {name} ใช้ไม่ได้ ({reason}) — รออัปเดต The Voider",
    en = "Adapter {name} unavailable ({reason}) — waiting for The Voider update",
  },
  -- keybind
  ["notify.keybind.conflict"] = {
    th = "คีย์ {key} ถูกใช้โดย \"{action}\" อยู่แล้ว — ปลดผูกเดิมก่อนจึงจะใช้ซ้ำได้",
    en = "Key {key} is already bound to \"{action}\" — unbind it first",
  },
  ["notify.keybind.restored"] = {
    th = "โหลดคีย์ลัด {count} รายการจาก config",
    en = "Restored {count} keybindings from config",
  },
  -- ชื่อ adapter (แสดงใน Diagnostics §8.4)
  ["adapter.player"] = { th = "ผู้เล่น", en = "Player" },
  ["adapter.character"] = { th = "ตัวละคร", en = "Character" },
  ["adapter.combat"] = { th = "ต่อสู้", en = "Combat" },
  ["adapter.camera"] = { th = "กล้อง", en = "Camera" },
  ["adapter.input"] = { th = "อินพุต", en = "Input" },
  ["adapter.world"] = { th = "โลก", en = "World" },
  -- สถานะระบบ (Diagnostics §8.4)
  ["diag.status.ok"] = { th = "ครบ", en = "OK" },
  ["diag.status.degraded"] = { th = "เสื่อมบางส่วน", en = "Degraded" },
  ["diag.status.dead"] = { th = "ตาย", en = "Dead" },
}

function I18n.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    bus = ctx.bus,
    lang = ctx.lang or I18n.DEFAULT_LANG,
    tables = {},   -- [lang] = { [key] = string }
  }, I18n)
  for _, lang in ipairs(I18n.LANGS) do
    self.tables[lang] = {}
  end
  -- ใส่คำศัพท์พื้นฐาน
  for key, entry in pairs(BASE) do
    for lang, text in pairs(entry) do
      self.tables[lang][key] = text
    end
  end
  return self
end

--- เติมคำศัพท์ (โมดูล/UI เรียกตอน Init ของตัวเอง — key ซ้ำ = เขียนทับของเดิม
--- เพราะโมดูลเป็นเจ้าของ key ของตัวเอง)
function I18n:AddTable(lang, t)
  if type(lang) ~= "string" then
    error("I18n:AddTable(lang, t): lang ต้องเป็น string", 2)
  end
  if type(t) ~= "table" then
    error(("I18n:AddTable(%s, t): t ต้องเป็น table { [key] = ข้อความ }"):format(lang), 2)
  end
  self.tables[lang] = self.tables[lang] or {}
  for k, v in pairs(t) do
    if type(v) ~= "string" then
      error(("I18n:AddTable(%s): key %s ต้องมีค่าเป็น string"):format(lang, tostring(k)), 2)
    end
    self.tables[lang][k] = v
  end
  return self
end

--- ภาษาปัจจุบัน
function I18n:Lang()
  return self.lang
end

--- มีภาษานี้หรือไม่ (ใช้ตรวจค่าจาก config ก่อน Set)
function I18n:Has(lang)
  return self.tables[lang] ~= nil
end

--- ภาษาที่มี
function I18n:Available()
  local out = {}
  for lang in pairs(self.tables) do
    out[#out + 1] = lang
  end
  table.sort(out)
  return out
end

--- สลับภาษา + ประกาศให้ UI render ใหม่
function I18n:Set(lang)
  if not self.tables[lang] then
    error(("I18n:Set(%s): ไม่มีภาษานี้ (มี: %s)"):format(tostring(lang), table.concat(self:Available(), ", ")), 2)
  end
  self.lang = lang
  if self.bus then
    self.bus:Publish("i18n:changed", { lang = lang })
  end
  return self
end

local function interpolate(text, params)
  if not params then return text end
  return (text:gsub("{(%w+)}", function(name)
    local v = params[name]
    if v == nil then return "{" .. name .. "}" end
    return tostring(v)
  end))
end

--- แปล key → ข้อความ (fallback: ภาษาปัจจุบัน → th → key เปล่า)
function I18n:T(key, params)
  local cur = self.tables[self.lang]
  local def = self.tables[I18n.DEFAULT_LANG]
  local text = (cur and cur[key]) or (def and def[key]) or key
  return interpolate(text, params)
end

--- แปลแบบระบุภาษา (ใช้น้อย — เช่น Export Diagnostics อยากได้สองภาษา)
function I18n:TIn(lang, key, params)
  local t = self.tables[lang]
  local def = self.tables[I18n.DEFAULT_LANG]
  local text = (t and t[key]) or (def and def[key]) or key
  return interpolate(text, params)
end

--- ตรวจความครอบคลุมของ key ทุกภาษา (DoD เฟส 1: 100%)
--- คืน { total = จำนวน key รวม, [lang] = { missing = n, keys = { ... } } }
function I18n:Coverage()
  -- union ของ key ทุกภาษา
  local union = {}
  local total = 0
  for _, lang in ipairs(self:Available()) do
    for k in pairs(self.tables[lang]) do
      if not union[k] then
        union[k] = true
        total = total + 1
      end
    end
  end
  local out = { total = total, complete = true }
  for _, lang in ipairs(self:Available()) do
    local missing = {}
    for k in pairs(union) do
      if self.tables[lang][k] == nil then
        missing[#missing + 1] = k
      end
    end
    table.sort(missing)
    out[lang] = { missing = #missing, keys = missing }
    if #missing > 0 then
      out.complete = false
    end
  end
  return out
end

return I18n

  end)();
  __TV_PACKAGES['i18n'] = __m;
end
-- ==== package: keybind (core/foundation/keybind.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/foundation/keybind.lua
-- Keybind Service (แผน freeze v2.1 §5.3) — คีย์ลัด + `Trigger` path เดียวกับคีย์จริง
-- [CR-PC-ONLY 1 ต.ค. 2026] เดิมระบุ "ปุ่มลัดมือถือ" — ปรับคำตาม dependencies.md v1.6
--
--   Bind(action, key)      ผูกคีย์ → action (ตรวจชนก่อนเสมอ + บันทึกลง config)
--   Unbind(action)         ปลดผูก
--   OnAction(action, fn)   สมัครฟัง action (subscription ผ่าน Resource Registry —
--                          orphan=0 อัตโนมัติเมื่อ module Destroy §3.4)
--   Trigger(action)        จำลองการกด (ปุ่ม UI ใช้ API เดียวกับคีย์จริง)
--   AttachInput(adapter)   ต่อกับ InputAdapter — เรียกหลัง adapter พร้อม
--                          (KeybindService อยู่ L2, InputAdapter อยู่ L3 ตาม graph
--                          — จึงต่อกันที่ runtime ไม่ใช่ตอน init ตาม SSOT §3.10)
--
--   เหตุการณ์: keybind:changed (replay) { action, key } — keybind เป็น state
--   ของผู้ใช้ → replay ระหว่าง hot update (§3.6)
-- ============================================================================

local Keybind = {}
Keybind.__index = Keybind

Keybind.VERSION = "0.2.0"

Keybind.CONFIG_PATH = "Keybinds"

function Keybind.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    clock = ctx.clock or os.clock,
    bus = ctx.bus,
    config = ctx.config,       -- ConfigService (บันทึก/โหลด Keybinds)
    registry = ctx.registry,   -- Resource Registry (optional — subscription เป็น temp)
    boundary = ctx.boundary,   -- Error Boundary (optional)
    hostOwner = ctx.owner or "KeybindService",
    input = nil,               -- InputAdapter (AttachInput ภายหลัง)
    _inputSub = nil,           -- handle ของ OnInput
    keyToAction = {},          -- [keyCode] = action
    actionToKey = {},          -- [action] = keyCode
    listeners = {},            -- [action] = { {fn, owner, handle?} ... }
  }, Keybind)
  return self
end

-- ---- internal ----------------------------------------------------------------

function Keybind:_offListener(action, item)
  local list = self.listeners[action]
  if not list then return end
  for i, x in ipairs(list) do
    if x == item then
      table.remove(list, i)
      return true
    end
  end
  return false
end

function Keybind:_persist(action, key)
  if not self.config then return end
  if key then
    self.config:Set(("%s.%s"):format(Keybind.CONFIG_PATH, action), key, { save = true })
  else
    self.config:Set(("%s.%s"):format(Keybind.CONFIG_PATH, action), nil, { save = true })
  end
end

function Keybind:_dispatch(action)
  local list = self.listeners[action]
  if not list or #list == 0 then return 0 end
  local targets = {}
  for _, x in ipairs(list) do
    targets[#targets + 1] = x
  end
  local n = 0
  for _, x in ipairs(targets) do
    n = n + 1
    if self.boundary then
      self.boundary:Guard(x.owner, function()
        x.fn(action)
      end)
    else
      pcall(x.fn, action)
    end
  end
  return n
end

-- ---- attach input (หลัง InputAdapter พร้อม — L3) ------------------------------

--- ต่อกับ InputAdapter — ฟัง input แบบ "กดลง" เพื่อ trigger action
--- (hold ตรวจผ่าน IsKeyDown ของ adapter เอง)
function Keybind:AttachInput(inputAdapter)
  if self.input then
    error("Keybind:AttachInput: ต่อ InputAdapter แล้ว (ห้ามต่อซ้ำ)", 2)
  end
  if not inputAdapter or type(inputAdapter.OnInput) ~= "function" then
    error("Keybind:AttachInput(inputAdapter): ต้องเป็น InputAdapter (มี OnInput)", 2)
  end
  self.input = inputAdapter
  -- subscription ของตัว KeybindService เอง — จองใน Scope ชื่อ node
  -- เพื่อให้ connection ตกเป็น resource ของ "KeybindService" ตาม graph
  -- (Shutdown ตรวจ orphan ราย node ได้ตรงตัว §3.10)
  local attach = function()
    self._inputSub = inputAdapter:OnInput(function(input)
      if input and input.state == "down" and input.key then
        local action = self.keyToAction[input.key]
        if action then
          self:_dispatch(action)
        end
      end
    end)
  end
  if self.registry then
    self.registry:Scope(self.hostOwner, attach)
  else
    attach()
  end
  return self
end

-- ---- binding -------------------------------------------------------------------

--- ผูกคีย์ → action — คืน (true) หรือ (false, { conflictedWith = action })
--- คีย์ที่ถูกใช้แล้ว = ปฏิเสธ (ไม่เขียนทับเงียบ ๆ) + แจ้งเตือนผู้ใช้
function Keybind:Bind(action, key)
  if type(action) ~= "string" or #action == 0 then
    error("Keybind:Bind(action, key): action ต้องเป็น string ไม่ว่าง", 2)
  end
  if type(key) ~= "string" or #key == 0 then
    error(("Keybind:Bind(%s, key): key ต้องเป็น string ไม่ว่าง (เช่น \"LeftControl\")"):format(action), 2)
  end
  local owner = self.keyToAction[key]
  if owner and owner ~= action then
    if self.bus then
      self.bus:Publish("notify:user", {
        level = "warn",
        key = "notify.keybind.conflict",
        params = { key = key, action = owner },
      })
    end
    return false, { conflictedWith = owner }
  end
  -- ถ้า action นี้ผูกคีย์อื่นอยู่ → ปลดคีย์เก่าก่อน (action ย้ายคีย์ได้)
  local oldKey = self.actionToKey[action]
  if oldKey and oldKey ~= key then
    self.keyToAction[oldKey] = nil
  end
  self.keyToAction[key] = action
  self.actionToKey[action] = key
  self:_persist(action, key)
  if self.bus then
    self.bus:Publish("keybind:changed", { action = action, key = key })
  end
  return true
end

--- ปลดผูก action
function Keybind:Unbind(action)
  local key = self.actionToKey[action]
  if not key then
    return false
  end
  self.keyToAction[key] = nil
  self.actionToKey[action] = nil
  self:_persist(action, nil)
  if self.bus then
    self.bus:Publish("keybind:changed", { action = action, key = nil })
  end
  return true
end

--- คีย์ปัจจุบันของ action
function Keybind:KeyOf(action)
  return self.actionToKey[action]
end

--- action ทั้งหมด (เรียง — ให้ UI วาดรายการ)
function Keybind:Actions()
  local out = {}
  for action in pairs(self.actionToKey) do
    out[#out + 1] = action
  end
  table.sort(out)
  return out
end

--- โหลด binding ทั้งหมดจาก config (เรียกครั้งเดียวตอน bootstrap หลัง Config:Load)
function Keybind:LoadFromConfig()
  if not self.config then return 0 end
  local bindings = self.config:Get(Keybind.CONFIG_PATH)
  if type(bindings) ~= "table" then return 0 end
  local n = 0
  for action, key in pairs(bindings) do
    if type(action) == "string" and type(key) == "string" then
      local existing = self.keyToAction[key]
      if existing and existing ~= action then
        -- ข้อมูลเก่าชนกันเอง — เอารายการแรกตามลำดับ sort (deterministic)
        -- แล้วรายงาน ไม่เงียบ (§3.9 ข้อ 5)
        if action < existing then
          self.keyToAction[existing] = nil
        else
          key = nil
        end
      end
      if key then
        self.keyToAction[key] = action
        self.actionToKey[action] = key
        n = n + 1
      end
    end
  end
  if n > 0 and self.bus then
    self.bus:Publish("notify:user", {
      level = "info",
      key = "notify.keybind.restored",
      params = { count = n },
    })
  end
  return n
end

-- ---- listener --------------------------------------------------------------------

--- สมัครฟัง action — คืน handle ที่ Release ได้ (ผ่าน registry ถ้ามี — orphan=0)
function Keybind:OnAction(action, fn)
  if type(fn) ~= "function" then
    error(("Keybind:OnAction(%s, fn): fn ต้องเป็น function"):format(tostring(action)), 2)
  end
  local owner
  if self.registry then
    owner = self.registry:Owner() or self.hostOwner
  else
    owner = self.hostOwner
  end
  local item = { fn = fn, owner = owner }
  self.listeners[action] = self.listeners[action] or {}
  table.insert(self.listeners[action], item)
  if self.registry then
    local h = self.registry:Temp(item, function()
      self:_offListener(action, item)
    end)
    item.handle = h
    return h
  end
  item.Release = function()
    self:_offListener(action, item)
  end
  return item
end

--- จำลองการกด action (ปุ่ม UI ใช้ — path เดียวกับคีย์จริง)
function Keybind:Trigger(action)
  return self:_dispatch(action)
end

--- สถานะ (Diagnostics)
function Keybind:Stats()
  local actions = 0
  for _ in pairs(self.actionToKey) do
    actions = actions + 1
  end
  local listeners = 0
  for _, list in pairs(self.listeners) do
    listeners = listeners + #list
  end
  return {
    actions = actions,
    listeners = listeners,
    inputAttached = self.input ~= nil,
  }
end

--- ข้อมูลอินพุตปัจจุบัน (query-only) — KeybindService เป็น L2 เดียวที่ถือ
--- InputAdapter แบบ runtime attachment (§3.10) — [CR-PC-ONLY 1 ต.ค. 2026]
--- เดิมมี MobileLayout เป็นผู้เรียก (ตรวจอุปกรณ์ทัชอย่างเดียว) ตัดออกจาก
--- scope แล้ว — API นี้คงไว้ (Foundation ผ่าน gate + PC จอสัมผัสยังใช้ได้)
--- ปัจจุบันผู้เรียก = เทส PC-only guard (qa/l1_unit/test_ui.lua) เท่านั้น
--- คืน { attached, touchEnabled, keyboardEnabled } — ค่าที่หาไม่ได้ = nil
--- (ผู้ใช้ต้อง fallback เอง — ไม่เดาเงียบ ๆ)
function Keybind:InputInfo()
  local info = {
    attached = self.input ~= nil,
    touchEnabled = nil,
    keyboardEnabled = nil,
  }
  if self.input then
    local okT, touch = pcall(function() return self.input:TouchEnabled() end)
    if okT and touch ~= nil then info.touchEnabled = touch == true end
    local okK, kb = pcall(function() return self.input:KeyboardEnabled() end)
    if okK and kb ~= nil then info.keyboardEnabled = kb == true end
  end
  return info
end

--- ปิด node (TEARDOWN) — ถอด subscription ของ input + ล้าง listener
--- (handles ใน registry เป็น no-op หลังจากนี้)
function Keybind:Shutdown()
  if self._inputSub and self._inputSub.Release then
    pcall(function() self._inputSub:Release() end)
    self._inputSub = nil
  end
  self.listeners = {}
  self.input = nil
  return true
end

return Keybind

  end)();
  __TV_PACKAGES['keybind'] = __m;
end
-- ==== package: diagnostics (core/foundation/diagnostics.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/foundation/diagnostics.lua
-- Developer Diagnostics — รุ่นแรก (แผน freeze v2.1 §8.4 + §5.3)
--
--   เกณฑ์ของรอบนี้ (เจ้าของโปรเจกต์กำหนด): "Diagnostics ต้องใช้งานได้ก่อน
--   feature ใหญ่" — เมื่อฟีเจอร์หลักเริ่มมีปัญหา ต้องเห็นหลักฐานจาก runtime
--   ทันที แทนการเดาว่าเป็น adapter / resource / scheduler / config
--
--   สิ่งที่ดูได้แล้วรุ่นนี้ (ตามตาราง §8.4):
--     Registry   จำนวน resource ทั้ง 4 ชนิด สด ๆ (task/connection/render/temp)
--     Event Bus  subscribers / events/sec / คิวค้าง / undeclared
--     Services   จำนวน Direct Service ที่ลงทะเบียน
--     Keybind    actions / listeners / input ต่อแล้วหรือยัง
--     ระบบ       Capability Report (8 ตัว), Adapter Health (6 API),
--                เวลา startup / config load / hot update ล่าสุด, boundary errors
--     หน่วยความจำ gcinfo (ถ้าสภาพแวดล้อมมี) — กราฟย้อนหลังผ่าน Sample()
--     เฟรม       Begin/End(name) — ต้นทุนต่อโมดูล min/avg/max (โมดูลเรียกเอง)
--     เครื่องมือ  Export() → ข้อความรายงานครบ + stack trace ล่าสุด
--
--   ที่ยังมาในเฟสถัดไป: กราฟ memory 15 นาทีแบบวาดจริง + FPS จาก render loop
--   (เฟส 1 UI) + ESP objects / Macro queue (เฟส 2-3 เมื่อโมดูลมีจริง)
-- ============================================================================

local Diag = {}
Diag.__index = Diag

Diag.VERSION = "0.2.0"

Diag.MAX_SAMPLES = 180 -- 15 นาที ณ ช่วง sample 5 วินาที

function Diag.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    clock = ctx.clock or os.clock,
    time = ctx.time or os.time,
    bus = ctx.bus,               -- Event Bus (อ่าน Stats)
    registry = ctx.registry,     -- Resource Registry (นับ 4 ชนิดสด)
    boundary = ctx.boundary,     -- Error Boundary (records + counters)
    capability = ctx.capability, -- CapabilityDetection (Report)
    services = ctx.services,     -- Service Registry (Stats)
    keybind = ctx.keybind,       -- KeybindService (Stats)
    i18n = nil,                  -- ต่อภายหลังผ่าน SetI18n (labels ตอน Export)
    fpsProvider = ctx.fpsProvider, -- optional: function() → FPS (มาในเฟส 1)
    samples = {},                -- ring buffer ย้อนหลัง
    timers = {},                 -- [name] = { count, total, min, max, openAt }
    marks = {},                  -- [name] = ค่าล่าสุด (startupMs ฯลฯ)
    adapterHealth = nil,         -- รายงานล่าสุดจาก AdapterSelfProbe
    startedAt = nil,
  }, Diag)
  return self
end

--- ต่อ i18n หลังพร้อม (labels ของ Export)
function Diag:SetI18n(i18n)
  self.i18n = i18n
  return self
end

--- ต่อ keybind/service หลังพร้อม (สร้างพร้อมกันทั้งชุดใน foundation init)
function Diag:SetSources(services, keybind)
  self.services = services
  self.keybind = keybind
  return self
end

--- ต่อ FPS provider (เฟส 1 UI §8.4 "FPS จริง" — HUD วัดจาก frame task
--- แล้วต่อเข้ามาให้ Snapshot/Export เห็นค่า) — additive รุ่นนี้
function Diag:SetFpsProvider(fn)
  if fn ~= nil and type(fn) ~= "function" then
    error("Diag:SetFpsProvider(fn): fn ต้องเป็น function หรือ nil", 2)
  end
  self.fpsProvider = fn
  return self
end

--- อนุกรม sample ย้อนหลัง (สำเนา) — กราฟ memory 15 นาที §8.4
--- (เฟส 1 UI นำไปวาดจริงในแผง Diagnostics เต็มรูปแบบ)
function Diag:MemorySeries()
  local out = {}
  for i, s in ipairs(self.samples) do
    out[i] = {
      at = s.at,
      memoryKb = s.memoryKb,
      registry = s.registry,
      busQueued = s.busQueued,
      busPerSec = s.busPerSec,
    }
  end
  return out
end

function Diag:SetAdapterHealth(report)
  self.adapterHealth = report
  return self
end

-- ---- per-module frame timer (§8.4 "ต้นทุนต่อโมดูล") ---------------------------

--- เริ่มจับเวลาชื่อโมดูล — คู่กับ End(name) เสมอ (โมดูลเรียกใน Update(dt) ของตัวเอง)
function Diag:Begin(name)
  local t = self.timers[name]
  if not t then
    t = { count = 0, total = 0, min = math.huge, max = 0, openAt = nil }
    self.timers[name] = t
  end
  t.openAt = self.clock()
end

--- จบจับเวลา — คืน ms ของรอบนี้
function Diag:End(name)
  local t = self.timers[name]
  if not t or not t.openAt then
    return nil
  end
  local ms = (self.clock() - t.openAt) * 1000
  t.openAt = nil
  t.count = t.count + 1
  t.total = t.total + ms
  if ms < t.min then t.min = ms end
  if ms > t.max then t.max = ms end
  return ms
end

-- ---- ตัวชี้วัดเหตุการณ์ -----------------------------------------------------------

--- บันทึก metric จุดเหตุการณ์: startupMs / configLoadMs / hotUpdateMs / ...
function Diag:Mark(name, value)
  self.marks[name] = value
  return self
end

function Diag:MarkStartup(ms)
  self.startedAt = self.time()
  return self:Mark("startupMs", ms)
end

-- ---- sampling (ย้อนหลัง / กราฟ memory รอบหน้า) ----------------------------------

--- เก็บภาพสถานะ 1 ชุดลง ring buffer (เรียกเป็นระยะจาก heartbeat ของระบบ)
function Diag:Sample()
  local snap = self:Collect()
  table.insert(self.samples, {
    at = snap.time,
    memoryKb = snap.memoryKb,
    registry = snap.registry,
    busQueued = snap.bus.queued,
    busPerSec = snap.bus.perSec,
  })
  if #self.samples > Diag.MAX_SAMPLES then
    table.remove(self.samples, 1)
  end
  return #self.samples
end

--- รวบรวมสถานะปัจจุบันทุก section (ใช้ทั้ง Sample / Snapshot / Export)
function Diag:Collect()
  local memoryKb
  if type(gcinfo) == "function" then
    memoryKb = gcinfo()
  elseif type(collectgarbage) == "function" then
    local ok, v = pcall(collectgarbage, "count")
    if ok and type(v) == "number" then memoryKb = v end
  end

  local registryCounts = { tasks = 0, connections = 0, renders = 0, temps = 0, total = 0 }
  if self.registry then
    registryCounts = self.registry:Snapshot()
  end

  local busStats = { subscribers = 0, perSec = 0, queued = 0, published = 0 }
  if self.bus then
    busStats = self.bus:Stats()
  end

  local serviceStats = { count = 0 }
  if self.services then
    serviceStats = self.services:Stats()
  end

  local keybindStats = { actions = 0, listeners = 0, inputAttached = false }
  if self.keybind then
    keybindStats = self.keybind:Stats()
  end

  local boundaryCounters = {}
  local boundaryRecords = {}
  if self.boundary then
    boundaryCounters = self.boundary:Counters()
    boundaryRecords = self.boundary:Records()
  end

  local fps
  if type(self.fpsProvider) == "function" then
    local ok, v = pcall(self.fpsProvider)
    if ok and type(v) == "number" then fps = v end
  end

  return {
    time = self.time(),
    memoryKb = memoryKb,
    fps = fps,
    registry = registryCounts,
    bus = busStats,
    services = serviceStats,
    keybind = keybindStats,
    boundaryCounters = boundaryCounters,
    boundaryErrorTotal = #boundaryRecords,
    capability = self.capability and self.capability:Report() or nil,
    adapterHealth = self.adapterHealth,
    marks = self.marks,
    timers = self.timers,
    uptimeSec = self.startedAt and (self.time() - self.startedAt) or 0,
  }
end

--- สำเนาสถานะปัจจุบัน (ใช้ตรวจค่าจากโค้ด/เทส)
function Diag:Snapshot()
  return self:Collect()
end

--- จำนวน sample ที่เก็บไว้ (ตรวจว่า sampling เดินจริง)
function Diag:SampleCount()
  return #self.samples
end

-- ---- export (เครื่องมือหลักของ §8.4) ----------------------------------------------

local function fmtMs(v)
  if v == nil then return "-" end
  return ("%.2f ms"):format(v)
end

local function fmtKb(v)
  if v == nil then return "-" end
  return ("%.0f KB"):format(v)
end

--- รายงานทั้งหมดเป็นข้อความ — ส่งให้ทีมได้ทันทีเมื่อมีบั๊ก
--- (พร้อม stack trace ล่าสุดจาก Error Boundary)
function Diag:Export()
  local s = self:Collect()
  local lines = {}
  local function add(fmt, ...)
    lines[#lines + 1] = fmt:format(...)
  end
  local function label(key, fallback)
    if self.i18n then
      return self.i18n:T(key)
    end
    return fallback
  end

  add("===== The Voider — Diagnostics Export =====")
  add("เวลา: %s | uptime: %ds | version: %s", tostring(s.time), s.uptimeSec, Diag.VERSION)

  -- Registry
  add("-- Registry (ทั้ง 4 ชนิด — ควรกลับเป็น 0 หลังปิดโมดูล)")
  add("   task=%d connection=%d render=%d temp=%d (total=%d)",
    s.registry.tasks, s.registry.connections, s.registry.renders, s.registry.temps, s.registry.total)

  -- Event Bus
  add("-- Event Bus")
  add("   subscribers=%d events/sec=%d คิวค้าง=%d (frozen=%s) published=%s undeclared=%d subscriberErrors=%d",
    s.bus.subscribers, s.bus.perSec, s.bus.queued, tostring(s.bus.frozen), tostring(s.bus.published), s.bus.undeclared, s.bus.subscriberErrors)

  -- Services
  add("-- Direct Services: %d รายการ", s.services.count)

  -- Keybind
  add("-- Keybind: actions=%d listeners=%d input=%s",
    s.keybind.actions, s.keybind.listeners, s.keybind.inputAttached and "attached" or "ยังไม่ต่อ")

  -- เฟรม / หน่วยความจำ
  add("-- เฟรม/หน่วยความจำ")
  add("   memory=%s fps=%s", fmtKb(s.memoryKb), s.fps and ("%.0f"):format(s.fps) or "n/a (เฟส 1)")
  local timerNames = {}
  for name in pairs(s.timers) do
    timerNames[#timerNames + 1] = name
  end
  table.sort(timerNames)
  if #timerNames > 0 then
    for _, name in ipairs(timerNames) do
      local t = s.timers[name]
      if t.count > 0 then
        add("   [%s] n=%d min=%s avg=%s max=%s", name, t.count,
          fmtMs(t.min), fmtMs(t.total / t.count), fmtMs(t.max))
      end
    end
  else
    add("   (ยังไม่มีโมดูลลงทะเบียนจับเวลา)")
  end

  -- ระบบ
  add("-- ระบบ")
  add("   startup=%s configLoad=%s hotUpdate=%s",
    fmtMs(s.marks.startupMs), fmtMs(s.marks.configLoadMs), fmtMs(s.marks.hotUpdateMs))
  if s.capability then
    local parts = {}
    local names = {}
    for n in pairs(s.capability) do names[#names + 1] = n end
    table.sort(names)
    for _, n in ipairs(names) do
      parts[#parts + 1] = ("%s=%s"):format(n, s.capability[n].supported and "Y" or "N")
    end
    add("   capability: %s", table.concat(parts, " "))
  else
    add("   capability: (ยังไม่ probe)")
  end
  if s.adapterHealth then
    add("   adapter: %s", s.adapterHealth.summary or "(ไม่มีสรุป)")
    local apiNames = {}
    for n in pairs(s.adapterHealth.adapters or {}) do
      apiNames[#apiNames + 1] = n
    end
    table.sort(apiNames)
    for _, n in ipairs(apiNames) do
      local a = s.adapterHealth.adapters[n]
      add("     - %s: %s%s", n, a.status, a.deadMethods and #a.deadMethods > 0
        and (" (ตาย: %s)"):format(table.concat(a.deadMethods, ",")) or "")
    end
  else
    add("   adapter: (ยังไม่ probe)")
  end

  -- Error Boundary
  add("-- Error Boundary: errors ล่าสุด %d รายการ", s.boundaryErrorTotal)
  local counters = {}
  for owner in pairs(s.boundaryCounters) do
    counters[#counters + 1] = owner
  end
  table.sort(counters)
  for _, owner in ipairs(counters) do
    add("   [%s] %d ครั้ง", owner, s.boundaryCounters[owner])
  end
  if self.boundary then
    local recs = self.boundary:Records()
    for i = math.max(1, #recs - 4), #recs do
      local r = recs[i]
      if r then
        add("   • %s: %s", tostring(r.owner), tostring(r.err))
      end
    end
  end

  add("===== จบรายงาน — แนบไฟล์นี้กับรายงานบั๊กเสมอ =====")
  return table.concat(lines, "\n")
end

--- Export + คัดลอกลง clipboard ถ้าสภาพแวดล้อมมี (คืนข้อความเสมอ)
function Diag:ExportToClipboard()
  local text = self:Export()
  local setClip = rawget(_G, "setclipboard")
  if type(setClip) == "function" then
    pcall(setClip, text)
    return text, true
  end
  return text, false
end

--- ปิด node (TEARDOWN) — ล้าง ring buffer (resource ทั้งหมดของ Diag อยู่ใน memory เท่านั้น)
function Diag:Shutdown()
  self.samples = {}
  return true
end

return Diag

  end)();
  __TV_PACKAGES['diagnostics'] = __m;
end
-- ==== package: foundation (core/foundation/init.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/foundation/init.lua
-- Foundation Layer assembler (แผน freeze v2.1 §3.5 + §3.7 + §8.4 + §3.10)
--
-- ประกอบ L2 ทั้งหมดตามลำดับ dependency graph:
--   EventBus → ConfigService → MigrationService → I18nService
--   → KeybindService → DiagnosticsService
--   (+ ServiceRegistry เป็น infrastructure ไม่แยก node ใน graph)
--
-- SSOT enforcement (§3.10): ตอนสร้างตรวจว่าชื่อ node ที่ layer นี้ดูแล
-- อยู่ใน Graph.initOrder ครบทุกตัว — ชื่อไม่ตรง = error ทันที
-- (กันไฟล์ graph กับโค้ดคลาดเคลื่อนกันแบบเงียบ ๆ)
--
-- ใช้งาน:
--   local F = FoundationLib.new({ runtime = R })
--   F:Bootstrap()          -- โหลด config + ภาษา + keybind + Diagnostics เริ่มทำงาน
--   F.Bus / F.Config / F.Migration / F.I18n / F.Keybind / F.Diag / F.Services
--   -- ปิดระบบทั้งหมดผ่าน R.ShutdownAll() (hook ของแต่ละ node ลงทะเบียนแล้ว)
-- ============================================================================

local P = __TV_PACKAGES
local ServicesLib = P.services
local BusLib = P.eventbus
local ConfigLib = P.config
local MigrationLib = P.migration
local I18nLib = P.i18n
local KeybindLib = P.keybind
local DiagLib = P.diagnostics

local FoundationLib = {}
FoundationLib.version = "0.2.0"

-- ชื่อ node ตาม dependency graph (ต้องตรง dependencies.md §3 พอดี — SSOT §3.10)
FoundationLib.NODES = {
  "EventBus",
  "ConfigService",
  "MigrationService",
  "I18nService",
  "KeybindService",
  "DiagnosticsService",
}

-- เหตุการณ์ระดับระบบทั้งหมด (Declare ครั้งเดียวที่นี่ — โมดูลเพิ่มของตัวเองภายหลังได้)
-- policy ตาม Replay Policy §3.6: config/keybind/i18n = state → replay,
-- notify/loaded/saved/ready = idempotent → replay ได้ปลอดภัย
FoundationLib.SYSTEM_EVENTS = {
  { "config:changed",  "replay" },
  { "config:replaced", "replay" },
  { "config:loaded",   "idempotent" },
  { "config:saved",    "idempotent" },
  { "i18n:changed",    "replay" },
  { "keybind:changed", "replay" },
  { "adapter:health",  "replay" },
  { "system:ready",    "idempotent" },
  { "notify:user",     "idempotent" },
  { "module:state",    "idempotent" },
}

function FoundationLib.new(ctx)
  ctx = ctx or {}
  local R = ctx.runtime
  if not R or not R.Registry or not R.Boundary or not R.Graph or not R.Shutdown then
    error("FoundationLib.new({ runtime = R }): ต้องส่ง Runtime ครบ (Registry/Boundary/Graph/Shutdown)", 2)
  end

  -- ---- SSOT check: node ของ foundation ต้องอยู่ใน graph ครบ ----------------
  local inGraph = {}
  for _, n in ipairs(R.Graph.initOrder) do
    inGraph[n] = true
  end
  for _, n in ipairs(FoundationLib.NODES) do
    if not inGraph[n] then
      error(("Foundation: node %q ไม่อยู่ใน dependency graph (dependencies.md) — "
        .. "โค้ดกับ SSOT คลาดเคลื่อน แก้ที่ dependencies.md ก่อน (§3.10)"):format(n), 2)
    end
  end

  local F = {}
  F.version = FoundationLib.version
  F.runtime = R

  -- ---- สร้างตามลำดับ (provider ก่อน consumer ตาม graph) ---------------------
  F.Services = ServicesLib.new()

  F.Bus = BusLib.new({
    registry = R.Registry,
    boundary = R.Boundary,
    owner = "EventBus",
  })

  F.Migration = MigrationLib.new({})

  F.Config = ConfigLib.new({
    bus = F.Bus,
    migration = F.Migration,
  })

  F.I18n = I18nLib.new({ bus = F.Bus })

  F.Keybind = KeybindLib.new({
    bus = F.Bus,
    config = F.Config,
    registry = R.Registry,
    boundary = R.Boundary,
    owner = "KeybindService",
  })

  F.Diag = DiagLib.new({
    bus = F.Bus,
    registry = R.Registry,
    boundary = R.Boundary,
    capability = R.Capability,
  })
  F.Diag:SetSources(F.Services, F.Keybind)
  F.Diag:SetI18n(F.I18n)

  -- ---- Declare ระบบ events --------------------------------------------------
  for _, ev in ipairs(FoundationLib.SYSTEM_EVENTS) do
    F.Bus:Declare(ev[1], ev[2])
  end

  -- ---- Direct Services ที่ foundation ให้เอง (query-only §3.5) ---------------
  -- โมดูลเรียกตรงผ่าน context ที่ได้รับตอน Init — ไม่ผ่าน bus (hot path เช่นแปลข้อความ)
  F.Services:Define("I18n", {
    T = function(key, params) return F.I18n:T(key, params) end,
    Lang = function() return F.I18n:Lang() end,
  })
  F.Services:Define("Config", {
    Get = function(path) return F.Config:Get(path) end,
    StorageKind = function() return F.Config:StorageKind() end,
  })
  F.Services:Define("Diagnostics", {
    Snapshot = function() return F.Diag:Snapshot() end,
    Export = function() return F.Diag:Export() end,
    -- เฟส 1 UI (§8.4 เครื่องมือ Export): คัดลอกลง clipboard ถ้ามี
    ExportToClipboard = function() return F.Diag:ExportToClipboard() end,
    -- เฟส 1 UI (§8.4 กราฟ memory 15 นาที): อนุกรม sample ย้อนหลัง
    MemorySeries = function() return F.Diag:MemorySeries() end,
  })

  -- ---- Shutdown hooks ตาม node (TEARDOWN = Init กลับด้าน §3.10) ---------------
  R.Shutdown:Register("EventBus", {
    Destroy = function()
      F.Bus:Shutdown()
    end,
  })
  R.Shutdown:Register("ConfigService", {
    -- เก็บของผู้ใช้เสมอ: Save ถ้า dirty (§3.7)
    Destroy = function()
      F.Config:Shutdown()
    end,
  })
  R.Shutdown:Register("KeybindService", {
    Destroy = function()
      F.Keybind:Shutdown()
    end,
  })
  R.Shutdown:Register("DiagnosticsService", {
    Destroy = function()
      F.Diag:Shutdown()
    end,
  })
  -- MigrationService / I18nService: ไม่ถือ resource ภายนอก — ไม่ลงทะเบียน hook
  -- (Shutdown Manager ข้าม node ไม่มี hook อัตโนมัติ)

  -- ---- Bootstrap ---------------------------------------------------------------

  function F:Bootstrap()
    local t0 = os.clock()
    -- 1) config ก่อนทุกอย่าง (ภาษา + keybind อยู่ในนั้น)
    local tc = os.clock()
    local loadInfo = F.Config:Load()
    F.Diag:Mark("configLoadMs", (os.clock() - tc) * 1000)

    -- 2) ภาษาจาก config
    local lang = F.Config:Get("i18n.lang")
    if lang and F.I18n:Has(lang) then
      F.I18n:Set(lang)
    end

    -- 3) keybind จาก config (ยังไม่ attach input — รอ adapter พร้อม L3)
    F.Keybind:LoadFromConfig()

    -- 4) เริ่ม Diagnostics + sample แรก
    F.Diag:MarkStartup((os.clock() - t0) * 1000)
    F.Diag:Sample()
    F.Bus:Publish("system:ready", {
      version = F.version,
      configSource = loadInfo.status,
    })
    return F
  end

  return F
end

return FoundationLib

  end)();
  __TV_PACKAGES['foundation'] = __m;
end
-- ==== package: adapter_common (core/adapter/_common.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/adapter/_common.lua
-- helper กลางของ Game Adapter ทั้ง 6 (แผน freeze v2.1 §3.3)
--
-- หลักการ "ประตูเดียวสู่เกม": ไฟล์ใน core/adapter/* เท่านั้นที่แตะ game
-- object ได้ — โมดูลชั้นบน (L4+) เรียก interface เหล่านี้เท่านั้น
-- (บังคับด้วย build/tools/lint_adapter.py ทุก build)
--
-- error code มาตรฐานที่ adapter คืน (ตาราง err = { code, message }):
--   GONE    โครงสร้างเกมหาย (เกมอัปเดต) → กระทบ health → ฟีเจอร์ที่พึ่งปิดตัวเอง
--   ERROR   ผิดพลาดอื่น (ค่าผิด ฯลฯ)
--   PENDING ยังไม่ทำจริงรอบนี้ (ระบุเฟสที่จะมาตามแผน — โปร่งใส ไม่แอบอ้าง §3.9)
-- ============================================================================

local Common = {}

Common.VERSION = "0.2.0"

--- คืน error object มาตรฐาน
function Common.err(code, message)
  return { code = code, message = tostring(message) }
end

--- เรียก fn แบบปลอดภัย — คืน (true, ...) หรือ (false, { code, message })
--- error ของการเข้าถึงเกม (เช่น GetService ตาย / property หาย) = ERROR
--- (การ "หาไม่เจอ" แบบธรรมดา ผู้เรียกต้องคืน GONE เองตามบริบท)
function Common.safe(fn, ...)
  local results = { pcall(fn, ...) }
  local ok = table.remove(results, 1)
  if ok then
    return true, table.unpack(results)
  end
  return false, Common.err("ERROR", results[1])
end

--- เข้าถึง service ของเกมผ่าน env — ตาย/ไม่มี = GONE (เกมอัปเดต)
--- คืน (true, service) หรือ (false, err)
function Common.service(env, name)
  if not env or not env.game then
    return false, Common.err("GONE", "ไม่มี game environment")
  end
  local ok, svc = Common.safe(function()
    return env.game:GetService(name)
  end)
  if not ok then
    return false, Common.err("GONE", ("service %s ใช้ไม่ได้: %s"):format(name, svc.message))
  end
  if svc == nil then
    return false, Common.err("GONE", ("service %s คืน nil"):format(name))
  end
  return true, svc
end

--- normalize ชื่อคีย์/enum → string ธรรมดา
--- รับ: "E" (stub/สตริงตรง) หรือ Enum.KeyCode.E (production — tostring = "Enum.KeyCode.E")
function Common.keyName(v)
  if v == nil then return nil end
  if type(v) == "string" then return v end
  local s = tostring(v)
  local last = s:match("([^%.]+)$")
  return last or s
end

--- สร้างรายงาน probe ของ adapter จากผลทดสอบรายเมธอด
--- results = { [methodName] = true | { code = ..., message = ... } }
--- คืน { status, ok, dead, deadMethods, detail }
function Common.healthFromResults(results, methodNames)
  local deadMethods = {}
  local okCount, deadCount = 0, 0
  for _, name in ipairs(methodNames) do
    local r = results[name]
    if r == true then
      okCount = okCount + 1
    else
      deadCount = deadCount + 1
      deadMethods[#deadMethods + 1] = name
    end
  end
  local status
  if deadCount == 0 then
    status = "ok"
  elseif okCount == 0 then
    status = "dead"
  else
    status = "degraded"
  end
  return {
    status = status,
    ok = okCount,
    dead = deadCount,
    deadMethods = deadMethods,
    detail = results,
  }
end

return Common

  end)();
  __TV_PACKAGES['adapter_common'] = __m;
end
-- ==== package: adapter_player (core/adapter/player.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/adapter/player.lua
-- Player Adapter (แผน freeze v2.1 §3.3) — local player, สถิติ, team, bounty, crew
--
-- หนึ่งใน 6 ประตูเดียวสู่เกม — โมดูลชั้นบนห้ามแตะ Players service โดยตรง
-- ทุกเมธอดคืน (ผลลัพธ์) เมื่อสำเร็จ หรือ (nil, err = { code, message }) เมื่อพัง
-- เกมอัปเดตทำให้โครงสร้างหาย = code "GONE" → Self-Probe เห็น → ฟีเจอร์ที่
-- พึ่ง API นั้นปิดตัวเอง + แจ้งผู้ใช้ (§3.3 กฎ 3)
-- ============================================================================

local Common = __TV_PACKAGES.adapter_common

local PlayerAdapter = {}
PlayerAdapter.__index = PlayerAdapter

PlayerAdapter.NODE = "PlayerAdapter"
PlayerAdapter.VERSION = "0.2.0"

-- รายชื่อเมธอดสาธารณะ (probe ใช้ตรวจครบ)
PlayerAdapter.METHODS = {
  "GetLocalPlayer", "GetBounty", "GetLevel", "GetTeam", "GetStats",
}

function PlayerAdapter.new(ctx)
  ctx = ctx or {}
  return setmetatable({
    env = ctx.env, -- { game = game } — ประตูเดียว (production: real, L1/L2: stub)
    health = nil,
  }, PlayerAdapter)
end

-- ---- internal -----------------------------------------------------------------

--- หา leaderstats ของ player (เกมจริงเป็น child, stub รองรับทั้ง field)
local function findStats(player)
  if type(player) ~= "table" then return nil end
  if player.leaderstats ~= nil then return player.leaderstats end
  if type(player.FindFirstChild) == "function" then
    return player:FindFirstChild("leaderstats")
  end
  return nil
end

--- อ่าน IntValue ใน leaderstats
local function readStat(player, statName)
  local stats = findStats(player)
  if not stats then
    return nil, Common.err("GONE", "leaderstats หาย (เกมอัปเดต?)")
  end
  local node = stats
  if type(stats.FindFirstChild) == "function" then
    node = stats:FindFirstChild(statName)
  end
  if not node or node.Value == nil then
    return nil, Common.err("GONE", ("leaderstats.%s หาย"):format(statName))
  end
  return node.Value
end

-- ---- API ------------------------------------------------------------------------

function PlayerAdapter:GetLocalPlayer()
  local ok, players = Common.service(self.env, "Players")
  if not ok then return nil, players end
  local lp = players.LocalPlayer
  if lp == nil then
    return nil, Common.err("GONE", "LocalPlayer ยังไม่โหลด/หาย")
  end
  return lp
end

function PlayerAdapter:GetBounty(player)
  player = player or self:GetLocalPlayer()
  if player == nil then return nil, Common.err("GONE", "ไม่มี player") end
  return readStat(player, "Bounty")
end

function PlayerAdapter:GetLevel(player)
  player = player or self:GetLocalPlayer()
  if player == nil then return nil, Common.err("GONE", "ไม่มี player") end
  return readStat(player, "Level")
end

function PlayerAdapter:GetTeam(player)
  player = player or self:GetLocalPlayer()
  if player == nil then return nil, Common.err("GONE", "ไม่มี player") end
  if player.Team == nil then
    return nil, Common.err("GONE", "Team หาย")
  end
  return player.Team
end

--- ข้อมูลรวมของ player — { name, userId, team, bounty, level }
function PlayerAdapter:GetStats(player)
  player = player or self:GetLocalPlayer()
  if player == nil then return nil, Common.err("GONE", "ไม่มี player") end
  local bounty, bErr = readStat(player, "Bounty")
  local level, lErr = readStat(player, "Level")
  if bounty == nil then return nil, bErr end
  if level == nil then return nil, lErr end
  return {
    name = player.Name,
    userId = player.UserId,
    team = player.Team,
    bounty = bounty,
    level = level,
  }
end

-- ---- self-probe (§3.3 กฎ 2) ------------------------------------------------------

function PlayerAdapter:Probe()
  local results = {}
  -- แต่ละเมธอด: เรียกจริงครั้งเดียว — ok = ได้ค่ากลับ (ไม่ error และไม่ GONE)
  local lp, lpErr = self:GetLocalPlayer()
  results.GetLocalPlayer = (lp ~= nil) and true or lpErr
  if lp then
    local v1, e1 = self:GetBounty(lp)
    results.GetBounty = (v1 ~= nil) and true or e1
    local v2, e2 = self:GetLevel(lp)
    results.GetLevel = (v2 ~= nil) and true or e2
    local v3, e3 = self:GetTeam(lp)
    results.GetTeam = (v3 ~= nil) and true or e3
    local v4, e4 = self:GetStats(lp)
    results.GetStats = (v4 ~= nil) and true or e4
  else
    local skip = Common.err("GONE", "ข้าม — ไม่มี LocalPlayer")
    results.GetBounty = skip
    results.GetLevel = skip
    results.GetTeam = skip
    results.GetStats = skip
  end
  self.health = Common.healthFromResults(results, PlayerAdapter.METHODS)
  return self.health
end

return PlayerAdapter

  end)();
  __TV_PACKAGES['adapter_player'] = __m;
end
-- ==== package: adapter_character (core/adapter/character.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/adapter/character.lua
-- Character Adapter (แผน freeze v2.1 §3.3) — humanoid, อวัยวะ, state, VFX
-- ============================================================================

local Common = __TV_PACKAGES.adapter_common

local CharacterAdapter = {}
CharacterAdapter.__index = CharacterAdapter

CharacterAdapter.NODE = "CharacterAdapter"
CharacterAdapter.VERSION = "0.2.0"

CharacterAdapter.METHODS = {
  "GetCharacter", "GetRoot", "IsAlive", "GetState", "GetMoveDirection",
}

function CharacterAdapter.new(ctx)
  ctx = ctx or {}
  return setmetatable({
    env = ctx.env,
    playerAdapter = ctx.playerAdapter, -- ใช้ GetLocalPlayer (ไม่แตะ Players เองซ้ำ)
    health = nil,
  }, CharacterAdapter)
end

-- ---- internal -----------------------------------------------------------------

local function findChild(model, name)
  if type(model) ~= "table" then return nil end
  if type(model.FindFirstChild) == "function" then
    return model:FindFirstChild(name)
  end
  return model[name]
end

local function humanoidOf(self, player)
  player = player or self.playerAdapter:GetLocalPlayer()
  if player == nil then return nil, Common.err("GONE", "ไม่มี player") end
  local char = player.Character
  if not char then
    return nil, Common.err("GONE", "Character ยังไม่โหลด/หาย")
  end
  local hum = findChild(char, "Humanoid")
  if not hum then
    return nil, Common.err("GONE", "Humanoid หาย (เกมอัปเดต?)")
  end
  return hum, char, player
end

-- ---- API ------------------------------------------------------------------------

function CharacterAdapter:GetCharacter(player)
  player = player or self.playerAdapter:GetLocalPlayer()
  if player == nil then return nil, Common.err("GONE", "ไม่มี player") end
  local char = player.Character
  if not char then
    return nil, Common.err("GONE", "Character ยังไม่โหลด/หาย")
  end
  return char
end

function CharacterAdapter:GetRoot(player)
  local char = self:GetCharacter(player)
  if not char then return nil, Common.err("GONE", "Character ยังไม่โหลด/หาย") end
  local root = findChild(char, "HumanoidRootPart")
  if not root then
    return nil, Common.err("GONE", "HumanoidRootPart หาย")
  end
  return root
end

function CharacterAdapter:IsAlive(player)
  local hum, humErr = humanoidOf(self, player)
  if not hum then return nil, humErr end
  return (hum.Health or 0) > 0
end

--- สถานะรวม: { alive, health, maxHealth, state }
--- state = ชื่อสถานะ humanoid normalize เป็น string ("Running"/"Freefall"/...)
function CharacterAdapter:GetState(player)
  local hum, humErr = humanoidOf(self, player)
  if not hum then return nil, humErr end
  local state = "Unknown"
  if type(hum.GetState) == "function" then
    local ok, s = Common.safe(hum.GetState, hum)
    if ok and s ~= nil then
      state = Common.keyName(s)
    end
  end
  return {
    alive = (hum.Health or 0) > 0,
    health = hum.Health or 0,
    maxHealth = hum.MaxHealth or 100,
    state = state,
  }
end

--- ทิศทางการเคลื่อนที่ (Vector3) — ใช้โดย PredictionService ภายหลัง (เฟส 2)
function CharacterAdapter:GetMoveDirection(player)
  local hum, humErr = humanoidOf(self, player)
  if not hum then return nil, humErr end
  local md = hum.MoveDirection
  if md == nil then
    return nil, Common.err("GONE", "Humanoid.MoveDirection หาย")
  end
  return md
end

-- ---- self-probe -------------------------------------------------------------------

function CharacterAdapter:Probe()
  local results = {}
  local c, e1 = self:GetCharacter()
  results.GetCharacter = (c ~= nil) and true or e1
  local r, e2 = self:GetRoot()
  results.GetRoot = (r ~= nil) and true or e2
  local a, e3 = self:IsAlive()
  results.IsAlive = (a ~= nil) and true or e3
  local s, e4 = self:GetState()
  results.GetState = (s ~= nil) and true or e4
  local m, e5 = self:GetMoveDirection()
  results.GetMoveDirection = (m ~= nil) and true or e5
  self.health = Common.healthFromResults(results, CharacterAdapter.METHODS)
  return self.health
end

return CharacterAdapter

  end)();
  __TV_PACKAGES['adapter_character'] = __m;
end
-- ==== package: adapter_combat (core/adapter/combat.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/adapter/combat.lua
-- Combat Adapter (แผน freeze v2.1 §3.3) — อาวุธ, สกิล, cooldown, remote, M1
--
-- ขอบเขตรอบ "โครงแรกระดับพื้นฐาน" (§5.3):
--   ✅ หาอาวุธที่ถือ (Tool ใน Character)
--   ✅ ส่งสกิลผ่าน remote ของเกม (FireSkill = ส่งต่อ RemoteEvent จริง)
--   ✅ สำรวจ remote ที่รู้จัก (GetRemotes — ใช้โดย Self-Probe)
--   ⏸ cooldown รายสกิล = PENDING (ต้องอ่านค่าจากโครงสร้างเกมจริง — จะทำพร้อม
--      Behavioral Matrix ของ VoidAim/CombatCore เฟส 2-3 ตามกติกา §4.5)
-- ============================================================================

local Common = __TV_PACKAGES.adapter_common

local CombatAdapter = {}
CombatAdapter.__index = CombatAdapter

CombatAdapter.NODE = "CombatAdapter"
CombatAdapter.VERSION = "0.2.0"

CombatAdapter.METHODS = {
  "GetEquippedWeapon", "FireSkill", "GetRemotes",
}

function CombatAdapter.new(ctx)
  ctx = ctx or {}
  return setmetatable({
    env = ctx.env,
    playerAdapter = ctx.playerAdapter,
    characterAdapter = ctx.characterAdapter,
    health = nil,
  }, CombatAdapter)
end

-- ---- internal -----------------------------------------------------------------

--- โครงสร้าง remote ที่รู้จัก (เกมอัปเดตเปลี่ยนชื่อ = แก้จุดเดียวที่นี่ §3.3)
local KNOWN_REMOTE_PATHS = {
  { storage = "ReplicatedStorage", parent = "Remotes", name = "Skill" },
  { storage = "ReplicatedStorage", parent = "Remotes", name = "RemoteEvent" },
}

local function findRemotes(self)
  local ok, rs = Common.service(self.env, "ReplicatedStorage")
  if not ok then return nil, rs end
  local found = {}
  for _, spec in ipairs(KNOWN_REMOTE_PATHS) do
    local parent = rs
    if spec.parent and type(rs.FindFirstChild) == "function" then
      parent = rs:FindFirstChild(spec.parent)
    end
    if parent and type(parent.FindFirstChild) == "function" then
      local remote = parent:FindFirstChild(spec.name)
      if remote then
        found[#found + 1] = ("%s/%s/%s"):format(spec.storage, spec.parent or "-", spec.name)
      end
    end
  end
  return found
end

-- ---- API ------------------------------------------------------------------------

--- อาวุธที่ถืออยู่ — { name } หรือ nil ถ้ามือเปล่า (มือเปล่าไม่ใช่ error)
--- พังจริง (character/tool หายเพราะเกมอัปเดต) = (nil, err)
function CombatAdapter:GetEquippedWeapon(player)
  local char, charErr = self.characterAdapter:GetCharacter(player)
  if not char then
    return nil, charErr
  end
  -- Tool แรกที่เจอใน Character = อาวุธที่ถือ (ตามพฤติกรรม Roblox)
  if type(char.GetChildren) == "function" then
    local ok, children = Common.safe(char.GetChildren, char)
    if not ok then return nil, children end
    for _, child in ipairs(children or {}) do
      if child.ClassName == "Tool" then
        return { name = child.Name }
      end
    end
  end
  return nil -- มือเปล่า (ค่าปกติ ไม่ใช่ error)
end

--- หา RemoteEvent "Skill" — คืน (remote) หรือ (nil, err)
function CombatAdapter:_findSkillRemote()
  local ok, rs = Common.service(self.env, "ReplicatedStorage")
  if not ok then return nil, rs end
  local remotes = nil
  if type(rs.FindFirstChild) == "function" then
    remotes = rs:FindFirstChild("Remotes")
  end
  if not remotes then
    return nil, Common.err("GONE", "ReplicatedStorage.Remotes หาย (เกมอัปเดต?)")
  end
  local remote = nil
  if type(remotes.FindFirstChild) == "function" then
    remote = remotes:FindFirstChild("Skill")
  end
  if not remote or type(remote.FireServer) ~= "function" then
    return nil, Common.err("GONE", "Remote Skill หาย (เกมอัปเดต?)")
  end
  return remote
end

--- ส่งสกิลผ่าน remote ของเกม — abstraction ของการส่ง remote เท่านั้น
--- (ไม่มี logic เลือกเป้า/ช่วงเวลา (timing) — นั่นเป็นของโมดูลชั้นบนหลังผ่าน Matrix §4.5)
function CombatAdapter:FireSkill(skill)
  if type(skill) ~= "string" or #skill == 0 then
    return false, Common.err("ERROR", "FireSkill(skill): skill ต้องเป็น string ไม่ว่าง")
  end
  local remote, rErr = self:_findSkillRemote()
  if not remote then
    return false, rErr
  end
  local okFire, fired = Common.safe(remote.FireServer, remote, skill)
  if not okFire then
    return false, fired
  end
  return true
end

--- cooldown รายสกิล — ยังไม่มีแหล่งค่าจริงในเกมให้อ่าน (โครงแรก)
--- คืน (nil, { code = "PENDING", ... }) อย่างชัดเจน — ไม่แอบอ้างว่าใช้ได้ (§3.9 ข้อ 5)
function CombatAdapter:GetSkillCooldown(skill)
  return nil, Common.err("PENDING",
    ("cooldown ของสกิล %q ยังไม่มีแหล่งอ่านจริง — ทำพร้อม Behavioral Matrix เฟส 2-3")
      :format(tostring(skill)))
end

--- รายชื่อ remote ที่มองเห็น (Self-Probe + Diagnostics)
function CombatAdapter:GetRemotes()
  local found = findRemotes(self)
  if not found then
    return nil, Common.err("GONE", "ReplicatedStorage ใช้ไม่ได้")
  end
  return found
end

-- ---- self-probe -------------------------------------------------------------------

function CombatAdapter:Probe()
  local results = {}
  -- มือเปล่า = nil ไม่ใช่ error → probe ใช้ "เรียกแล้วไม่พัง + err ไม่ใช่ nil"
  local w, wErr = self:GetEquippedWeapon()
  results.GetEquippedWeapon = (w ~= nil or wErr == nil) and true or wErr
  -- ตรวจโครงสร้างของ remote โดยไม่ยิงจริง (ไม่สร้าง traffic ขยะในเกมจริง)
  local remote, rErr = self:_findSkillRemote()
  results.FireSkill = (remote ~= nil) and true or rErr
  local remotes, rrErr = self:GetRemotes()
  results.GetRemotes = (remotes ~= nil) and true or rrErr
  self.health = Common.healthFromResults(results, CombatAdapter.METHODS)
  return self.health
end

return CombatAdapter

  end)();
  __TV_PACKAGES['adapter_combat'] = __m;
end
-- ==== package: adapter_camera (core/adapter/camera.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/adapter/camera.lua
-- Camera Adapter (แผน freeze v2.1 §3.3) — ตำแหน่ง/ทิศ/FOV กล้อง, ล็อกกล้อง
-- ============================================================================

local Common = __TV_PACKAGES.adapter_common

local CameraAdapter = {}
CameraAdapter.__index = CameraAdapter

CameraAdapter.NODE = "CameraAdapter"
CameraAdapter.VERSION = "0.2.0"

CameraAdapter.METHODS = {
  "GetPosition", "GetLookVector", "GetFOV",
}

function CameraAdapter.new(ctx)
  ctx = ctx or {}
  return setmetatable({
    env = ctx.env,
    health = nil,
  }, CameraAdapter)
end

-- ---- internal -----------------------------------------------------------------

function CameraAdapter:_camera()
  local ok, ws = Common.service(self.env, "Workspace")
  if not ok then return nil, ws end
  local cam = ws.CurrentCamera
  if not cam then
    return nil, Common.err("GONE", "CurrentCamera หาย")
  end
  return cam
end

-- ---- API ------------------------------------------------------------------------

function CameraAdapter:GetPosition()
  local cam, err = self:_camera()
  if not cam then return nil, err end
  local cframe = cam.CFrame
  if not cframe or cframe.Position == nil then
    return nil, Common.err("GONE", "Camera.CFrame หาย")
  end
  return cframe.Position
end

function CameraAdapter:GetLookVector()
  local cam, err = self:_camera()
  if not cam then return nil, err end
  local cframe = cam.CFrame
  if not cframe or cframe.LookVector == nil then
    return nil, Common.err("GONE", "Camera.CFrame.LookVector หาย")
  end
  return cframe.LookVector
end

function CameraAdapter:GetFOV()
  local cam, err = self:_camera()
  if not cam then return nil, err end
  if cam.FieldOfView == nil then
    return nil, Common.err("GONE", "Camera.FieldOfView หาย")
  end
  return cam.FieldOfView
end

--- ล็อกกล้องไปที่เป้า — กลไกจริงมาเฟส 2 (VoidAim) ตามกติกา §4.5
--- รอบนี้คืน PENDING ชัดเจน ไม่แอบอ้างว่าทำงาน (§3.9 ข้อ 5)
function CameraAdapter:SetLock(target)
  return false, Common.err("PENDING", "SetLock จะมาพร้อม VoidAim เฟส 2 (Behavioral Matrix ผ่านรีวิวก่อน)")
end

--- แปลงพิกัดโลก → หน้าจอ — ใช้โดย ESP เฟส 2 (รอบนี้ PENDING เหมือนกัน)
function CameraAdapter:WorldToScreen(point)
  return nil, Common.err("PENDING", "WorldToScreen จะมาพร้อม Void ESP เฟส 2")
end

-- ---- self-probe -------------------------------------------------------------------

function CameraAdapter:Probe()
  local results = {}
  local p, e1 = self:GetPosition()
  results.GetPosition = (p ~= nil) and true or e1
  local l, e2 = self:GetLookVector()
  results.GetLookVector = (l ~= nil) and true or e2
  local f, e3 = self:GetFOV()
  results.GetFOV = (f ~= nil) and true or e3
  self.health = Common.healthFromResults(results, CameraAdapter.METHODS)
  return self.health
end

return CameraAdapter

  end)();
  __TV_PACKAGES['adapter_camera'] = __m;
end
-- ==== package: adapter_input (core/adapter/input.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/adapter/input.lua
-- Input Adapter (แผน freeze v2.1 §3.3) — คีย์บอร์ด/เมาส์/ทัชมือถือ
--
-- OnInput(callback) = จุดต่อเดียวของ input ทั้งระบบ:
--   callback({ key = "LeftControl", state = "down"|"up", inputType = "Keyboard"|"Mouse"|"Touch" })
--   subscription เป็น connection ใน Resource Registry ของผู้สมัคร
--   (เรียกใน Scope ของโมดูล — Destroy แล้วคืนอัตโนมัติ orphan=0 §3.4)
-- ============================================================================

local Common = __TV_PACKAGES.adapter_common

local InputAdapter = {}
InputAdapter.__index = InputAdapter

InputAdapter.NODE = "InputAdapter"
InputAdapter.VERSION = "0.2.0"

InputAdapter.METHODS = {
  "IsKeyDown", "OnInput", "KeyboardEnabled", "TouchEnabled",
}

function InputAdapter.new(ctx)
  ctx = ctx or {}
  return setmetatable({
    env = ctx.env,
    runtime = ctx.runtime, -- R (OnInput ใช้ R.Connect — registry นับ connection)
    health = nil,
  }, InputAdapter)
end

-- ---- internal -----------------------------------------------------------------

local INPUT_TYPE_NAMES = {
  Keyboard = "Keyboard",
  MouseButton1 = "Mouse", MouseButton2 = "Mouse", MouseButton3 = "Mouse",
  Touch = "Touch",
}

local function normalizeInput(inputObj, state)
  if type(inputObj) ~= "table" then return nil end
  local rawType = inputObj.UserInputType
  local inputType = "Unknown"
  if type(rawType) == "string" then
    inputType = INPUT_TYPE_NAMES[rawType] or rawType
  elseif rawType ~= nil then
    inputType = INPUT_TYPE_NAMES[tostring(rawType)] or Common.keyName(rawType)
  end
  return {
    key = Common.keyName(inputObj.KeyCode),
    state = state,
    inputType = inputType,
    processed = inputObj.UserInputState == "Processed" or false,
  }
end

-- ---- API ------------------------------------------------------------------------

function InputAdapter:IsKeyDown(key)
  if type(key) ~= "string" then
    return false, Common.err("ERROR", "IsKeyDown(key): key ต้องเป็น string")
  end
  local ok, uis = Common.service(self.env, "UserInputService")
  if not ok then return false, uis end
  if type(uis.IsKeyDown) ~= "function" then
    return false, Common.err("GONE", "UserInputService.IsKeyDown หาย")
  end
  local okDown, down = Common.safe(uis.IsKeyDown, uis, key)
  if not okDown then return false, down end
  return down == true
end

function InputAdapter:KeyboardEnabled()
  local ok, uis = Common.service(self.env, "UserInputService")
  if not ok then return nil, uis end
  return uis.KeyboardEnabled == true
end

function InputAdapter:TouchEnabled()
  local ok, uis = Common.service(self.env, "UserInputService")
  if not ok then return nil, uis end
  return uis.TouchEnabled == true
end

--- สมัครรับ input ทั้งหมด (down + up) — คืน connection handle (Registry)
function InputAdapter:OnInput(callback)
  if type(callback) ~= "function" then
    error("InputAdapter:OnInput(callback): callback ต้องเป็น function", 2)
  end
  local ok, uis = Common.service(self.env, "UserInputService")
  if not ok then
    return nil, ok and nil or uis
  end
  local began, ended = uis.InputBegan, uis.InputEnded
  if not began or not ended then
    return nil, Common.err("GONE", "UserInputService.InputBegan/InputEnded หาย")
  end
  local R = self.runtime
  if not R or not R.Connect then
    error("InputAdapter:OnInput: ต้องมี runtime (R.Connect) — สร้าง adapter ผ่าน adapter init", 2)
  end
  -- connection เป็นของผู้สมัคร (Scope ปัจจุบัน) — Module:Destroy → คืนอัตโนมัติ
  local h1 = R.Connect(began, function(inputObj)
    callback(normalizeInput(inputObj, "down"))
  end)
  local h2 = R.Connect(ended, function(inputObj)
    callback(normalizeInput(inputObj, "up"))
  end)
  -- รวมเป็น handle เดียว: Release = ปลดทั้งคู่
  return {
    Release = function()
      h1.Release()
      h2.Release()
    end,
    Disconnect = function()
      h1.Release()
      h2.Release()
    end,
  }
end

-- ---- self-probe -------------------------------------------------------------------

function InputAdapter:Probe()
  local results = {}
  local d, e1 = self:IsKeyDown("UnknownKey")
  results.IsKeyDown = (d == false and e1 == nil) and true or e1
  -- OnInput ตรวจโครงสร้างโดยไม่สมัครจริง (กัน connection ขยะจาก probe)
  local ok, uis = Common.service(self.env, "UserInputService")
  if ok and uis.InputBegan and uis.InputEnded then
    results.OnInput = true
  else
    results.OnInput = ok or uis
  end
  local kb, e2 = self:KeyboardEnabled()
  results.KeyboardEnabled = (kb ~= nil) and true or e2
  local tc, e3 = self:TouchEnabled()
  results.TouchEnabled = (tc ~= nil) and true or e3
  self.health = Common.healthFromResults(results, InputAdapter.METHODS)
  return self.health
end

return InputAdapter

  end)();
  __TV_PACKAGES['adapter_input'] = __m;
end
-- ==== package: adapter_world (core/adapter/world.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/adapter/world.lua
-- World Adapter (แผน freeze v2.1 §3.3) — entities ในฉาก, ระยะทาง,
-- raycast/line-of-sight, server info
-- ============================================================================

local Common = __TV_PACKAGES.adapter_common

local WorldAdapter = {}
WorldAdapter.__index = WorldAdapter

WorldAdapter.NODE = "WorldAdapter"
WorldAdapter.VERSION = "0.2.0"

WorldAdapter.METHODS = {
  "GetPlayers", "GetOthers", "GetServerInfo", "RaycastClear", "GetDistance",
}

function WorldAdapter.new(ctx)
  ctx = ctx or {}
  return setmetatable({
    env = ctx.env,
    playerAdapter = ctx.playerAdapter,
    health = nil,
  }, WorldAdapter)
end

-- ---- API ------------------------------------------------------------------------

--- ผู้เล่นทั้งหมดในเซิร์ฟเวอร์ (รวม local)
function WorldAdapter:GetPlayers()
  local ok, players = Common.service(self.env, "Players")
  if not ok then return nil, players end
  if type(players.GetPlayers) ~= "function" then
    return nil, Common.err("GONE", "Players.GetPlayers หาย")
  end
  local okList, list = Common.safe(players.GetPlayers, players)
  if not okList then return nil, list end
  return list or {}
end

--- ผู้เล่นอื่น (ไม่รวม local) — ใช้บ่อยโดย TargetService (เฟส 2)
function WorldAdapter:GetOthers()
  local list, err = self:GetPlayers()
  if list == nil then return nil, err end
  local lp = self.playerAdapter:GetLocalPlayer()
  local out = {}
  for _, p in ipairs(list) do
    if p ~= lp then
      out[#out + 1] = p
    end
  end
  return out
end

--- ข้อมูลเซิร์ฟเวอร์ — { jobId, playerCount }
function WorldAdapter:GetServerInfo()
  local list, err = self:GetPlayers()
  if list == nil then return nil, err end
  local jobId = ""
  if self.env and self.env.game and self.env.game.JobId then
    jobId = tostring(self.env.game.JobId)
  end
  return {
    jobId = jobId,
    playerCount = #list,
  }
end

--- raycast จาก from → to — คืน true = ทางโล่ง (ไม่มีอะไรบัง)
function WorldAdapter:RaycastClear(from, to)
  if type(from) ~= "table" or type(to) ~= "table" then
    return nil, Common.err("ERROR", "RaycastClear(from, to): ต้องเป็น Vector3 ทั้งคู่")
  end
  local ok, ws = Common.service(self.env, "Workspace")
  if not ok then return nil, ws end
  if type(ws.Raycast) ~= "function" then
    return nil, Common.err("GONE", "Workspace.Raycast หาย")
  end
  local direction = to - from
  local okCast, hit = Common.safe(ws.Raycast, ws, from, direction)
  if not okCast then return nil, hit end
  return hit == nil
end

--- ระยะทางระหว่างจุดสองจุด (helper คำนวณ — ไม่แตะเกม)
function WorldAdapter:GetDistance(a, b)
  if type(a) ~= "table" or type(b) ~= "table" then
    return nil, Common.err("ERROR", "GetDistance(a, b): ต้องเป็น Vector3 ทั้งคู่")
  end
  if a.Position ~= nil then a = a.Position end
  if b.Position ~= nil then b = b.Position end
  local d = a - b
  if d.Magnitude == nil then
    return nil, Common.err("ERROR", "คำนวณระยะไม่ได้ (Vector3 ผิดรูป)")
  end
  return d.Magnitude
end

-- ---- self-probe -------------------------------------------------------------------

function WorldAdapter:Probe()
  local results = {}
  local list, e1 = self:GetPlayers()
  results.GetPlayers = (list ~= nil) and true or e1
  local others, e2 = self:GetOthers()
  results.GetOthers = (others ~= nil) and true or e2
  local info, e3 = self:GetServerInfo()
  results.GetServerInfo = (info ~= nil) and true or e3
  -- raycast ตรวจด้วยจุดจำลองใกล้ตัว (ไม่ยิงไกล — ไม่กระทบเกมจริง)
  local v = Vector3 and Vector3.new(0, 0, 0)
  if v then
    local clear, e4 = self:RaycastClear(v, v)
    results.RaycastClear = (clear ~= nil) and true or e4
  else
    results.RaycastClear = Common.err("ERROR", "ไม่มี Vector3 (stub เท่านั้น)")
  end
  local dOk, dErr
  if v then
    local dd, de = self:GetDistance(v, v)
    dOk, dErr = dd, de
  end
  results.GetDistance = (dOk ~= nil) and true or dErr
  self.health = Common.healthFromResults(results, WorldAdapter.METHODS)
  return self.health
end

return WorldAdapter

  end)();
  __TV_PACKAGES['adapter_world'] = __m;
end
-- ==== package: adapter_probe (core/adapter/probe.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/adapter/probe.lua
-- Adapter Self-Probe (แผน freeze v2.1 §3.3 กฎ 2 + §3.10)
--
-- หน้าที่:
--   1) probe adapter ทั้ง 6 → Adapter Health report:
--      ครบ (ok) / เสื่อมบางส่วน (degraded — ระบุ method ที่ตาย) / ตาย (dead)
--   2) "สายตาย" — node ไหนตาย → กระทบ consumer ตัวไหนบ้าง (อ่านจาก
--      dependency graph SSOT — ไม่มี logic คู่ซ้ำ §3.10)
--   3) ประกาศผลผ่าน Event Bus ("adapter:health") + แจ้งผู้ใช้เมื่อเสื่อม
--      (No Silent Degradation §3.9 ข้อ 5 — ฟีเจอร์ที่พึ่ง API ตายต้องบอกผู้ใช้)
--   4) ส่งรายงานให้ DiagnosticsService (§8.4)
--
-- เรียกซ้ำได้ (idempotent): hot update ขั้น ADAPTER PROBE (§3.6 ขั้น 11)
-- เรียกตัวเดิมอีกครั้งเพื่อพิสูจน์ว่ารุ่นใหม่เห็นเกมครบก่อนเป็น active
-- ============================================================================

local Probe = {}
Probe.__index = Probe

Probe.NODE = "AdapterSelfProbe"
Probe.VERSION = "0.2.0"

function Probe.new(ctx)
  ctx = ctx or {}
  return setmetatable({
    adapters = ctx.adapters or {}, -- { PlayerAdapter = adapter, ... } (6 ตัว)
    graph = ctx.graph,             -- graph.lua (deps ใช้คำนวณสายตาย)
    bus = ctx.bus,
    i18n = ctx.i18n,
    diagnostics = ctx.diagnostics,
    time = ctx.time or os.time,
    lastReport = nil,
  }, Probe)
end

-- ---- internal -----------------------------------------------------------------

--- consumer ทางตรงของ node (ใครประกาศ dep บน node นี้ใน graph)
local function directConsumers(graph, nodeName)
  local out = {}
  if not graph or not graph.deps then return out end
  for consumer, deps in pairs(graph.deps) do
    for _, d in ipairs(deps) do
      if d == nodeName then
        out[#out + 1] = consumer
        break
      end
    end
  end
  table.sort(out)
  return out
end

local function compactHealth(health)
  return {
    status = health.status,
    ok = health.ok,
    dead = health.dead,
    deadMethods = health.deadMethods,
  }
end

-- ---- probe หลัก -------------------------------------------------------------------

--- รัน probe ทั้ง 6 + สรุป + แจ้ง — เรียกซ้ำกี่ครั้งก็ได้ (รายงานล่าสุดทับเก่า)
function Probe:Probe()
  local report = {
    probedAt = self.time(),
    adapters = {},
    impacted = {},     -- [node ที่ตาย/เสื่อม] = { consumers = {...}, deadMethods }
    status = "ok",
    summary = "",
  }

  local anyDegraded, anyDead = false, false
  local degradedNames, deadNames = {}, {}

  for name, adapter in pairs(self.adapters) do
    local health = adapter:Probe()
    report.adapters[name] = compactHealth(health)
    if health.status == "ok" then
      -- สบายดี
    elseif health.status == "dead" then
      anyDead = true
      deadNames[#deadNames + 1] = name
      report.impacted[name] = {
        consumers = directConsumers(self.graph, name),
        deadMethods = health.deadMethods,
      }
    else
      anyDegraded = true
      degradedNames[#degradedNames + 1] = name
      report.impacted[name] = {
        consumers = directConsumers(self.graph, name),
        deadMethods = health.deadMethods,
      }
    end
  end

  -- สรุปสถานะรวม
  if anyDead then
    report.status = "dead"
  elseif anyDegraded then
    report.status = "degraded"
  end
  table.sort(degradedNames)
  table.sort(deadNames)
  if report.status == "ok" then
    report.summary = "Adapter ครบทั้ง 6 API"
  else
    local parts = {}
    for _, n in ipairs(deadNames) do
      parts[#parts + 1] = ("%s ตาย"):format(n)
    end
    for _, n in ipairs(degradedNames) do
      local dm = report.adapters[n].deadMethods
      parts[#parts + 1] = ("%s เสื่อม (%s)"):format(n, table.concat(dm, ","))
    end
    report.summary = "Adapter มีปัญหา: " .. table.concat(parts, "; ")
  end

  self.lastReport = report

  -- ส่ง Diagnostics (§8.4 — แผง "ระบบ: Adapter Health 6 API")
  if self.diagnostics then
    self.diagnostics:SetAdapterHealth(report)
  end

  -- ประกาศผล (adapter:health = replay — เป็นสถานะที่ยังมีผล §3.6)
  if self.bus then
    self.bus:Publish("adapter:health", {
      status = report.status,
      summary = report.summary,
      adapters = report.adapters,
      impacted = report.impacted,
    })
    -- แจ้งผู้ใช้เมื่อไม่ครบ (No Silent Degradation)
    for _, n in ipairs(deadNames) do
      self.bus:Publish("notify:user", {
        level = "warn",
        key = "notify.adapter.dead",
        params = { name = n, reason = table.concat(report.adapters[n].deadMethods, ", ") },
      })
    end
    for _, n in ipairs(degradedNames) do
      self.bus:Publish("notify:user", {
        level = "warn",
        key = "notify.adapter.degraded",
        params = { name = n },
      })
    end
  end

  return report
end

--- รายงานล่าสุด (ไม่ probe ใหม่ — ใช้ตอน Diagnostics/UI ดึงข้อมูล)
function Probe:LastReport()
  return self.lastReport
end

return Probe

  end)();
  __TV_PACKAGES['adapter_probe'] = __m;
end
-- ==== package: adapter (core/adapter/init.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/adapter/init.lua
-- Game Adapter Layer assembler (แผน freeze v2.1 §3.3 + §3.10)
--
-- ประกอบ L3 ทั้งหมดตามลำดับ dependency graph:
--   PlayerAdapter → CharacterAdapter → CombatAdapter → CameraAdapter
--   → InputAdapter → WorldAdapter → AdapterSelfProbe
--
-- "ประตูเดียวสู่เกม" (§3.3 กฎ 1): env (game/workspace) ถูกห่อไว้ที่นี่เท่านั้น
-- โมดูลชั้นบนเข้าถึงเกมผ่าน adapter interface เท่านั้น — บังคับด้วย
-- build/tools/lint_adapter.py ทุก build
--
-- ใช้งาน:
--   local A = AdapterLib.new({ runtime = R, foundation = F })
--   A:Bootstrap()   -- Self-Probe + ต่อ Keybind เข้า InputAdapter
--   A.Player / A.Character / A.Combat / A.Camera / A.Input / A.World
--   A.SelfProbe:Probe()  -- re-probe ได้ (hot update ขั้น ADAPTER PROBE §3.6)
-- ============================================================================

local P = __TV_PACKAGES
local Common = P.adapter_common
local PlayerAdapterLib = P.adapter_player
local CharacterAdapterLib = P.adapter_character
local CombatAdapterLib = P.adapter_combat
local CameraAdapterLib = P.adapter_camera
local InputAdapterLib = P.adapter_input
local WorldAdapterLib = P.adapter_world
local SelfProbeLib = P.adapter_probe

local AdapterLib = {}
AdapterLib.version = "0.2.0"

-- ชื่อ node ตาม dependency graph (SSOT §3.10)
AdapterLib.NODES = {
  "PlayerAdapter",
  "CharacterAdapter",
  "CombatAdapter",
  "CameraAdapter",
  "InputAdapter",
  "WorldAdapter",
  "AdapterSelfProbe",
}

function AdapterLib.new(ctx)
  ctx = ctx or {}
  local R = ctx.runtime
  local F = ctx.foundation
  if not R or not R.Registry or not R.Graph then
    error("AdapterLib.new({ runtime = R }): ต้องส่ง Runtime ครบ (Registry/Graph)", 2)
  end
  if not F or not F.Keybind or not F.Diag or not F.Bus then
    error("AdapterLib.new({ foundation = F }): ต้องส่ง Foundation ครบ (Keybind/Diag/Bus)", 2)
  end

  -- ---- SSOT check: node ของ adapter ต้องอยู่ใน graph ครบ --------------------
  local inGraph = {}
  for _, n in ipairs(R.Graph.initOrder) do
    inGraph[n] = true
  end
  for _, n in ipairs(AdapterLib.NODES) do
    if not inGraph[n] then
      error(("Adapter: node %q ไม่อยู่ใน dependency graph (dependencies.md) — "
        .. "โค้ดกับ SSOT คลาดเคลื่อน แก้ที่ dependencies.md ก่อน (§3.10)"):format(n), 2)
    end
  end

  -- env ของเกม — จุดเดียวที่แตะ global game/workspace (production);
  -- L1/L2 ส่ง ctx.env เป็น stub แทน
  local env = ctx.env or { game = game, workspace = workspace }

  local A = {}
  A.version = AdapterLib.version
  A.runtime = R
  A.foundation = F
  A.env = env

  -- ---- สร้างตามลำดับ (ตามตาราง graph §3) ------------------------------------
  A.Player = PlayerAdapterLib.new({ env = env })

  A.Character = CharacterAdapterLib.new({
    env = env,
    playerAdapter = A.Player,
  })

  A.Combat = CombatAdapterLib.new({
    env = env,
    playerAdapter = A.Player,
    characterAdapter = A.Character,
  })

  A.Camera = CameraAdapterLib.new({ env = env })

  A.Input = InputAdapterLib.new({
    env = env,
    runtime = R,
  })

  A.World = WorldAdapterLib.new({
    env = env,
    playerAdapter = A.Player,
  })

  A.SelfProbe = SelfProbeLib.new({
    adapters = {
      PlayerAdapter = A.Player,
      CharacterAdapter = A.Character,
      CombatAdapter = A.Combat,
      CameraAdapter = A.Camera,
      InputAdapter = A.Input,
      WorldAdapter = A.World,
    },
    graph = R.Graph,
    bus = F.Bus,
    i18n = F.I18n,
    diagnostics = F.Diag,
  })

  -- ---- Bootstrap ----------------------------------------------------------------

  function A:Bootstrap()
    -- 1) Self-Probe ครั้งแรก (§3.3 กฎ 2): ทดสอบ instance/property/remote ที่รู้จัก
    --    → Adapter Health → Diagnostics + แจ้งผู้ใช้เมื่อไม่ครบ
    A.SelfProbe:Probe()

    -- 2) ต่อ Keybind เข้า InputAdapter (KeybindService รอ attach ตั้งแต่ L2)
    F.Keybind:AttachInput(A.Input)

    return A
  end

  --- re-probe ทั้ง 6 (hot update ขั้น ADAPTER PROBE §3.6 ขั้น 11)
  --- คืน report — ใช้ตัดสินว่า release ใหม่ active ได้หรือยัง (atomic rule R3)
  function A:Reprobe()
    return A.SelfProbe:Probe()
  end

  return A
end

return AdapterLib

  end)();
  __TV_PACKAGES['adapter'] = __m;
end
-- ==== package: ui_backend (core/ui/_backend.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/ui/_backend.lua
-- GUI Backend (เฟส 1 UI Framework — แผน freeze v2.1 §3.8 + §8.2 + §3.9 #4)
--
-- util ภายในของชั้น UI (ไม่แยก node ตามกติกา dependencies.md —
-- เทียบเท่า adapter/_common.lua / foundation/services.lua)
--
-- หลักการ 3 ข้อ (บังคับโดย lint_adapter.py + Resource Registry):
--   1) ทุก Instance สร้างผ่าน Runtime.NewRender("Instance", ...) เท่านั้น
--      (§3.9 #4 Everything Registered) — ตกเป็น resource ของ "owner"
--      ตาม Registry:Scope ของโหนดผู้เรียกขณะสร้าง
--   2) ทุก callback (คลิก/แตะ/ลาก) ต่อผ่าน Runtime.Connect — connection
--      นับเป็น resource ของโหนดผู้เรียกเช่นกัน
--   3) root ของ UI ทั้งหมด = ctx.guiRoot ที่ผู้สร้างส่งมา หรือ gethui()
--      ของ executor (global ของ executor ไม่ใช่ game service — นอกประตู
--      §3.3 ซึ่งว่าด้วย game object) ถ้าไม่มี = UI ปิดตัวเองแบบ graceful
--      + แจ้ง plain text ครั้งเดียว (No Silent Degradation §3.9 #5)
--      — ระบบที่เหลือเดินต่อ ไม่สัญญา UI ในสถานการณ์ที่เปิดไม่ได้ (ตามแบบ
--      Bootstrap Preflight §3.2 ข้อ 0)
--
-- ไม่ใช้ TweenService/GuiService/CoreGui โดยตรง (ชื่อเหล่านี้ผ่าน lint ไม่ได้)
-- — animation ทำด้วย task สั้น ๆ ของ registry เอง (§8.2 "0.15 วินาที")
-- ============================================================================

local Backend = {}
Backend.__index = Backend

Backend.VERSION = "0.1.0"

-- input ของ GUI signal: รับทั้ง stub (string) และ production (Enum.*.Name)
local DRAG_INPUTS = { MouseButton1 = true, Touch = true }

local function inputTypeName(u)
  if u == nil then return nil end
  if type(u) == "table" then return u.Name end
  if type(u) == "string" then return u end
  return tostring(u)
end

local function isDragInput(u)
  return DRAG_INPUTS[inputTypeName(u)] == true
end

function Backend.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    runtime = ctx.runtime,
    logger = ctx.logger,
    clock = ctx.clock or os.clock,
    root = nil,
    available = false,
    reason = nil,
    _fadeTokens = setmetatable({}, { __mode = "k" }),
  }, Backend)

  -- root resolution: ผู้เรียกส่งมา → gethui() ของ executor → ไม่มี = degraded
  local root = ctx.guiRoot
  if root == nil then
    local g = rawget(_G, "gethui")
    if type(g) == "function" then
      local ok, r = pcall(g)
      if ok and r ~= nil then
        root = r
      end
    end
  end

  if root ~= nil and self.runtime and self.runtime.NewRender then
    self.root = root
    self.available = true
  else
    self.reason = root == nil
      and "ไม่พบขอบเขต GUI (gethui) ของ executor"
      or "ไม่มี Runtime.NewRender"
    if self.logger then
      self.logger("warn", ("UI ปิดตัวเองชั่วคราว: %s — ระบบอื่นเดินต่อตามปกติ")
        :format(self.reason))
    end
  end
  return self
end

--- สร้าง instance ใต้ parent (default = root) — ต้องเรียกภายใน
--- Registry:Scope("<NodeName>", ...) ของโหนดผู้เป็นเจ้าเสมอ
--- คืน handle ของ registry (มี .obj / .Release) หรือ nil + reason (degraded)
-- NoKey-VoltCompat v1c: black-hole object (writes no-op, reads nil) so the
-- 40+ `.obj` call sites across Notification/Hub/HUD can never crash boot
local __TV_NULL_OBJ = setmetatable({}, {
  __newindex = function() end,
})
function Backend:_nullHandle(reason)
  if self.logger then
    self.logger("warn", ("VoltCompat: UI handle ใช้ไม่ได้ (%s) - ใช้ null handle แทน (UI อาจไม่แสดงผล)")
      :format(tostring(reason)))
  end
  return {
    obj = __TV_NULL_OBJ,
    Release = function() end,
    Remove = function() end,
    Destroy = function() end,
    __tv_null = true,
  }
end
function Backend:Create(class, props, parent)
  if not self.available then
    return self:_nullHandle(self.reason or "UI unavailable")
  end
  props = props or {}
  parent = parent or self.root
  local handle, why2 = self.runtime.NewRender("Instance", {
    Class = class,
    Props = props,
    Parent = parent,
  })
  if not handle then
    return self:_nullHandle("NewRender ล้มเหลว: " .. tostring(why2))
  end
  return handle
end

--- ตั้งค่า property ภายหลัง (ไม่ใช่การจอง resource — เช่นอัปเดต Text/สี)
function Backend:Apply(handle, props)
  local obj = handle and handle.obj or handle
  if not obj or type(props) ~= "table" then return false end
  for k, v in pairs(props) do
    obj[k] = v
  end
  return true
end

--- ต่อ callback เข้า signal ของ instance (MouseButton1Click / InputBegan /
--- MouseEnter / ...) — ผ่าน Runtime.Connect ทั้งหมด
function Backend:OnSignal(handle, signalName, fn)
  local obj = handle and handle.obj or handle
  if not self.runtime or not self.runtime.Connect then
    error("Backend:OnSignal: ต้องมี runtime (R.Connect)", 2)
  end
  local sig = obj and obj[signalName]
  if not sig then
    return nil, ("signal %s ไม่มีบน instance นี้"):format(tostring(signalName))
  end
  return self.runtime.Connect(sig, fn)
end

--- ปุ่ม/แถวที่แตะได้ (คลิกเมาส์ + ทัชรวมอยู่ใน MouseButton1Click)
function Backend:OnClick(handle, fn)
  return self:OnSignal(handle, "MouseButton1Click", fn)
end

--- animation นุ่ม 0.15 วินาที (§8.2): แทรก property จาก from → to
--- ใช้ task ชั่วคราวของ registry — จบเองตามเวลา = deregister อัตโนมัติ
--- (ไม่มี orphan) — fade ใหม่บน obj เดิมยกเลิก fade เก่า
function Backend:Fade(handle, prop, from, to, dur, onDone)
  if not self.available then return nil, self.reason end
  local obj = handle and handle.obj or handle
  if not obj then return nil, "ไม่มี instance" end
  dur = dur or 0.15
  local token = {}
  self._fadeTokens[obj] = token
  local backend = self
  backend.runtime.Spawn(("fade:%s"):format(tostring(prop)), function(ctx)
    local t0 = backend.clock()
    while true do
      if not ctx.ShouldRun() then return end
      if backend._fadeTokens[obj] ~= token then return end -- โดน fade ใหม่แทน
      local elapsed = backend.clock() - t0
      local a = math.min(1, elapsed / dur)
      obj[prop] = from + (to - from) * a
      if a >= 1 then
        obj[prop] = to
        if type(onDone) == "function" then onDone(obj) end
        return
      end
      ctx.Wait(0.016)
    end
  end)
  return true
end

--- ลากย้าย: จับที่ grip (เช่นแถบหัว) แล้วเลื่อน rootFrame ตาม pointer
--- — ใช้ signal ของ instance เอง (InputBegan/InputChanged/InputEnded)
--- กรองเฉพาะ MouseButton1/Touch (§8.3 ลากย้ายได้ ทั้งเมาส์และนิ้ว)
--- opts.onDragEnd() เรียกเมื่อปล่อย (ใช้บันทึกตำแหน่งลง config)
--- คืน { conns = { handle, ... } }
function Backend:MakeDraggable(rootHandle, gripHandle, opts)
  opts = opts or {}
  local root = rootHandle and rootHandle.obj or rootHandle
  local grip = gripHandle and gripHandle.obj or gripHandle
  local conns = {}
  local dragging = false

  conns[#conns + 1] = self:OnSignal(grip, "InputBegan", function(input)
    if not isDragInput(input and input.UserInputType) then return end
    dragging = true
  end)
  conns[#conns + 1] = self:OnSignal(root, "InputChanged", function(input)
    if not dragging then return end
    if not isDragInput(input and input.UserInputType) then return end
    local d = input and input.Input and input.Input.Delta
    if not d then return end
    local pos = root.Position
    if not pos or not pos.X then return end
    root.Position = UDim2.new(
      pos.X.Scale, pos.X.Offset + (d.X or 0),
      pos.Y.Scale, pos.Y.Offset + (d.Y or 0))
  end)
  local function stop()
    if dragging and type(opts.onDragEnd) == "function" then
      opts.onDragEnd()
    end
    dragging = false
  end
  conns[#conns + 1] = self:OnSignal(grip, "InputEnded", stop)
  conns[#conns + 1] = self:OnSignal(root, "InputEnded", stop)

  return { conns = conns, dragging = function() return dragging end }
end

return Backend

  end)();
  __TV_PACKAGES['ui_backend'] = __m;
end
-- ==== package: ui_theme (core/ui/theme.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/ui/theme.lua
-- ThemeEngine (เฟส 1 UI Framework — แผน freeze v2.1 §8.1 + §8.2 + §5.4)
--
-- node L6 ตาม dependency graph: ThemeEngine | palette Void Neon | deps: —
-- (ไม่มี dependency ใด ๆ ตาม SSOT — เป็น pure token source:
-- ไม่ใช้ bus/config/registry จึงไม่มี edge เพิ่ม)
--
-- สิ่งที่ให้:
--   palette ตาม §8.1 เป๊ะ (ดำหลุมดำ/ดำน้ำเงินเข้ม/ม่วงนีออน/ไล่สี/ฟ้านีออน/
--   ขาวนวล/เทาหม่น/เขียวมรกต/แดงหลังคา) + เหลืองอำพัน (ระดับ warn ของ toast)
--   accent 4 ตัวตาม §8.2 "Dark-only + ปรับ accent ได้ (ม่วง/ฟ้า/ชมพู/เขียว)"
--   layout constants: TOUCH_MIN = 44 (ความสูงปุ่มมาตรฐานของ UI ทั้งหมด —
--   [CR-PC-ONLY] เดิมเป็น gate ทัช ≥ 44px ของ DoD §5.4 ฉบับเก่า ตอนนี้คงไว้
--   เป็นมาตรฐานปุ่ม PC) + ตัวเลข typography/spacing/radius
--   animation 0.15 วินาที (§8.2) + glass โปร่งแสง 12% (§8.2)
--
-- การเปลี่ยน accent = SetAccent(name) + Subscribe(fn) แจ้งผู้สนใจ
-- (node อื่น render ใหม่เอง — ThemeEngine ไม่รู้จักใคร)
-- ความคงทนของค่า accent เป็นหน้าที่ของ Hub ผ่าน ConfigService (ตาม graph
-- Hub→ConfigService) ไม่ใช่ของ ThemeEngine
-- ============================================================================

local ThemeEngine = {}
ThemeEngine.__index = ThemeEngine

ThemeEngine.NODE = "ThemeEngine"
ThemeEngine.VERSION = "0.1.0"

-- ---- palette §8.1 (คงเดิมจาก v1.0 — ห้ามเลื่อน เปลี่ยนแปลงผ่านเจ้าของ) ------
local BASE = {
  bg        = { 0x0A, 0x0A, 0x14 }, -- ดำหลุมดำ     #0A0A14 พื้นหลัง hub/HUD
  card      = { 0x12, 0x12, 0x1F }, -- ดำน้ำเงินเข้ม #12121F การ์ด/แท็บ
  border    = { 0x7C, 0x3A, 0xED }, -- ม่วงนีออน     #7C3AED เส้นขอบ 1px
  accentA   = { 0xA8, 0x55, 0xF7 }, -- ม่วงไล่แสง    #A855F7
  accentB   = { 0x63, 0x66, 0xF1 }, -- → #6366F1     ปุ่มหลัก/toggle เปิด/หัวข้อ
  hilite    = { 0x22, 0xD3, 0xEE }, -- ฟ้านีออน      #22D3EE ไฮไลต์/ลิงก์/สถิติ
  text      = { 0xE5, 0xE7, 0xEB }, -- ขาวนวล       #E5E7EB ข้อความหลัก
  textDim   = { 0x9C, 0xA3, 0xAF }, -- เทาหม่น      #9CA3AF คำอธิบาย/ค่าปิด
  on        = { 0x34, 0xD3, 0x99 }, -- เขียวมรกต    #34D399 สถานะเปิด/สำเร็จ
  danger    = { 0xF8, 0x71, 0x71 }, -- แดงหลังคา    #F87171 ปิด/อันตราย
  warn      = { 0xFB, 0xBF, 0x24 }, -- เหลืองอำพัน  #FBBF24 ระดับ warn ของ toast
}

-- ---- accent 4 ตัว (§8.2) — เปลี่ยนเฉพาะชุด border/accentA/accentB ---------
ThemeEngine.ACCENTS = {
  purple = { border = { 0x7C, 0x3A, 0xED }, accentA = { 0xA8, 0x55, 0xF7 }, accentB = { 0x63, 0x66, 0xF1 } },
  cyan   = { border = { 0x22, 0xD3, 0xEE }, accentA = { 0x22, 0xD3, 0xEE }, accentB = { 0x08, 0x91, 0xB2 } },
  pink   = { border = { 0xF4, 0x72, 0xB6 }, accentA = { 0xF4, 0x72, 0xB6 }, accentB = { 0xEC, 0x48, 0x99 } },
  green  = { border = { 0x34, 0xD3, 0x99 }, accentA = { 0x34, 0xD3, 0x99 }, accentB = { 0x05, 0x96, 0x69 } },
}
ThemeEngine.DEFAULT_ACCENT = "purple"

-- ---- layout constants (DoD เฟส 1 + §8.2/§8.3) --------------------------------
ThemeEngine.LAYOUT = {
  TOUCH_MIN = 44,     -- ความสูงปุ่มมาตรฐานของ UI ทั้งหมด (เดิม: gate ทัช §5.4 — คงค่าไว้ตาม CR-PC-ONLY)
  TAB_W = 116,       -- แท็บซ้ายเดสก์ท็อป
  TAB_H = 44,        -- สูงแท็บ (= TOUCH_MIN — มาตรฐานปุ่ม)
  HUB_W = 560,       -- ความกว้าง hub ตอนเปิดเต็ม
  HUB_H = 420,
  HEADER_H = 44,     -- แถบหัว (ลากย้ายได้ §8.3)
  PAD = 12,
  GAP = 8,
  RADIUS = 10,
  STROKE = 1,        -- เส้นขอบเรือง 1px §8.2
  FONT_SIZE = 14,
  FONT_TITLE = 18,
  FONT_MONO = 13,    -- ตัวเลขสถิติ mono §8.2
  LINE_H = 20,
}

ThemeEngine.ANIM = {
  FAST = 0.15,       -- §8.2 "นุ่มแต่ไม่เยอะ — 0.15 วินาที"
}

ThemeEngine.GLASS = {
  CARD_ALPHA = 0.12, -- การ์ดโปร่งแสง ~12% §8.2
}

-- ---- toast levels (Notification) --------------------------------------------
ThemeEngine.TOAST_LEVELS = { info = "hilite", success = "on", warn = "warn", error = "danger" }

local function rgb(t)
  return Color3.fromRGB(t[1], t[2], t[3])
end

function ThemeEngine.new()
  local self = setmetatable({
    accent = ThemeEngine.DEFAULT_ACCENT,
    subs = {},       -- รายการผู้สนใจการเปลี่ยน accent
    tokens = nil,    -- สร้างครั้งแรกตอน Get()
  }, ThemeEngine)
  return self
end

--- ชื่อ accent ปัจจุบัน
function ThemeEngine:Accent()
  return self.accent
end

--- รายชื่อ accent ที่เลือกได้ (เรียงตามตัวอักษร — ให้ UI วาดปุ่ม)
function ThemeEngine:ListAccents()
  local out = {}
  for k in pairs(ThemeEngine.ACCENTS) do out[#out + 1] = k end
  table.sort(out)
  return out
end

--- ตาราง token รวม (palette §8.1 + accent ที่เลือก + layout/anim/glass)
--- คืนตารางเดิมตัวเดียว (ไม่ clone ทุกเรียก — เป็น hot path) —
--- ผู้ใช้อย่าเขียนตรง ๆ ให้ถือเป็น read-only
function ThemeEngine:Get()
  if not self.tokens then
    self:_build()
  end
  return self.tokens
end

function ThemeEngine:_build()
  local acc = ThemeEngine.ACCENTS[self.accent] or ThemeEngine.ACCENTS[ThemeEngine.DEFAULT_ACCENT]
  local t = {
    -- สี §8.1 (accent ชุดที่เลือกแทนที่ 3 ช่อง)
    bg = rgb(BASE.bg),
    card = rgb(BASE.card),
    border = rgb(acc.border),
    accentA = rgb(acc.accentA),
    accentB = rgb(acc.accentB),
    hilite = rgb(BASE.hilite),
    text = rgb(BASE.text),
    textDim = rgb(BASE.textDim),
    on = rgb(BASE.on),
    danger = rgb(BASE.danger),
    warn = rgb(BASE.warn),
    -- สีตามชื่อบทบาท (สะดวก)
    bgRGB = BASE.bg,
    cardRGB = BASE.card,
    -- สีที่ใช้บ่อยของ toast ตาม level
    toastColor = {},
    -- layout/anim/glass
    layout = ThemeEngine.LAYOUT,
    anim = ThemeEngine.ANIM,
    glass = ThemeEngine.GLASS,
  }
  for level, role in pairs(ThemeEngine.TOAST_LEVELS) do
    t.toastColor[level] = t[role]
  end
  self.tokens = t
  return t
end

--- เปลี่ยน accent (invalid = ปฏิเสธ ไม่เดาเงียบ ๆ) + แจ้งผู้สมัครทุกตัว
function ThemeEngine:SetAccent(name)
  if ThemeEngine.ACCENTS[name] == nil then
    return false, { code = "UNSUPPORTED", message = ("accent %q ไม่มี (มี: %s)")
      :format(tostring(name), table.concat(self:ListAccents(), ", ")) }
  end
  if self.accent == name then
    return true -- ไม่มีอะไรเปลี่ยน — ไม่ปลุกผู้ใช้
  end
  self.accent = name
  self:_build()
  for _, cb in ipairs(self.subs) do
    cb(name)
  end
  return true
end

--- สมัครรับการเปลี่ยน accent — คืน function ถอนการสมัคร
function ThemeEngine:Subscribe(fn)
  if type(fn) ~= "function" then
    error("ThemeEngine:Subscribe(fn): fn ต้องเป็น function", 2)
  end
  self.subs[#self.subs + 1] = fn
  local subs = self.subs
  return function()
    for i, f in ipairs(subs) do
      if f == fn then
        table.remove(subs, i)
        return true
      end
    end
    return false
  end
end

-- [CR-PC-ONLY 1 ต.ค. 2026] ThemeEngine:TouchSize() ถูกตัดออก — เป็น helper
-- ของ gate ทัช ≥ 44px ฉบับเดิม (DoD §5.4 เดิม) ซึ่งเปลี่ยนเป็น PC-only แล้ว
-- และไม่มีผู้เรียกเหลืออยู่ — ปุ่มทั้ง UI ใช้ค่า LAYOUT.TOUCH_MIN ตรง ๆ

return ThemeEngine

  end)();
  __TV_PACKAGES['ui_theme'] = __m;
end
-- ==== package: ui_hub (core/ui/hub.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/ui/hub.lua
-- Main Hub (เฟส 1 UI Framework — แผน freeze v2.1 §5.4 + §8.3 + §8.4)
--
-- node L6 ตาม dependency graph: Hub | แท็บ 8 โมดูล + ค้นหา(P1) |
-- deps: ConfigService, I18nService (โมดูล L5 ยังไม่มีในเฟสนี้ — แท็บของ
-- โมดูลแสดงสถานะ "จะพร้อมในเฟส N" ตาม roadmap แบบโปร่งใส §3.9 PENDING
-- ไม่ใช่ซ่อนเงียบ ๆ)
--
-- โครงตาม §8.3: แถบหัว (ลากย้ายได้ + สถานะระบบสด) / แถบค้นหา (พื้นที่
-- สงวน P1 — แสดง placeholder แต่ยังไม่มีพฤติกรรม) / แท็บซ้าย 8 โมดูล +
-- Setup / เนื้อหาขวา
--
-- Setup tab: ภาษา (th/en — เขียน config i18n.lang) + สีเน้น 4 ตัว (§8.2 —
-- ผ่าน callback ของ assembler → ThemeEngine + config + fanout ทุก node)
-- + เครื่องมือนักพัฒนา
--
-- Developer Diagnostics เต็มรูปแบบ (§8.4) — แผงลับเปิดได้ 2 ทาง:
-- แตะโลโก้ 5 ครั้ง (ช่วงห่าง ≤ 2 วิ) หรือปุ่มจากแท็บ Setup
-- ข้อมูลจาก Direct Service "Diagnostics" (ambient §3.5 — ตามแบบ
-- bundle selftest ที่ใช้ Services:MustGet) : Snapshot/MemorySeries/
-- ExportToClipboard + กราฟ memory วาดจริง (แท่งตามอนุกรม sample)
-- ESP objects / Macro = "—" (ยังไม่มีโมดูล — PENDING โปร่งใส)
--
-- ความคงทน (§3.7 config เป็นของผู้ใช้): ui.hub.open / ui.hub.pos /
-- ui.accent / i18n.lang — ผ่าน ConfigService (declared dep ของ node นี้)
-- ============================================================================

local Hub = {}
Hub.__index = Hub

Hub.NODE = "Hub"
Hub.VERSION = "0.1.0"

--- แท็บทั้งหมด — 8 โมดูลตาม graph L5 + Setup (§8.3)
--- phase = เฟสที่โมดูลนั้นจะมีของจริงตาม roadmap §5.2 (0 = มีเนื้อหาเดี๋ยวนี้)
Hub.TABS = {
  { key = "aim",    name = "Aim",    icon = "⭐", phase = 2, order = 1 },
  { key = "esp",    name = "ESP",    icon = "👁", phase = 2, order = 2 },
  { key = "macro",  name = "Macro",  icon = "🎹", phase = 3, order = 3 },
  { key = "combat", name = "Combat", icon = "⚔",  phase = 3, order = 4 },
  { key = "race",   name = "Race",   icon = "🧬", phase = 4, order = 5 },
  { key = "fruit",  name = "Fruit",  icon = "🍎", phase = 4, order = 6 },
  { key = "move",   name = "Move",   icon = "🏃", phase = 4, order = 7 },
  { key = "hop",    name = "Hop",    icon = "🛰",  phase = 4, order = 8 },
  { key = "setup",  name = "Setup",  icon = "⚙",  phase = 0, order = 9 },
}

Hub.LOGO_TAPS = 5       -- §8.4: แตะโลโก้ 5 ครั้ง = เปิดแผง Diagnostics
Hub.TAP_WINDOW = 2.0    -- ช่วงห่างระหว่างแตะ (วิ) — เกิน = เริ่มนับใหม่

Hub.I18N = {
  th = {
    ["ui.hub.title"] = "THE VOIDER",
    ["ui.hub.search"] = "🔍 ค้นหาฟีเจอร์…",
    ["ui.hub.version"] = "v{v}",
    ["ui.hub.status.ready"] = "ระบบพร้อม",
    ["ui.hub.status.degraded"] = "Adapter เสื่อม — รออัปเดต The Voider",
    ["ui.hub.tab.aim"] = "⭐ Aim",
    ["ui.hub.tab.esp"] = "👁 ESP",
    ["ui.hub.tab.macro"] = "🎹 Macro",
    ["ui.hub.tab.combat"] = "⚔ Combat",
    ["ui.hub.tab.race"] = "🧬 Race",
    ["ui.hub.tab.fruit"] = "🍎 Fruit",
    ["ui.hub.tab.move"] = "🏃 Move",
    ["ui.hub.tab.hop"] = "🛰 Hop",
    ["ui.hub.tab.setup"] = "⚙ Setup",
    ["ui.hub.coming"] = "โมดูล {name} จะพร้อมใช้ในเฟส {phase} ตาม roadmap",
    ["ui.hub.coming.sub"] = "ยังไม่มีการตั้งค่าให้แสดงในเฟสนี้ (§แผน 5.2)",
    ["ui.setup.lang"] = "ภาษา / Language",
    ["ui.setup.lang.th"] = "ไทย",
    ["ui.setup.lang.en"] = "English",
    ["ui.setup.accent"] = "สีเน้น (accent)",
    ["ui.setup.accent.err"] = "ไม่รองรับสีนี้",
    ["ui.accent.purple"] = "ม่วง",
    ["ui.accent.cyan"] = "ฟ้า",
    ["ui.accent.pink"] = "ชมพู",
    ["ui.accent.green"] = "เขียว",
    ["ui.setup.tools"] = "เครื่องมือนักพัฒนา",
    ["ui.setup.diag.open"] = "เปิดแผง Diagnostics",
    ["ui.setup.diag.export"] = "Export Diagnostics",
    ["ui.diag.exported"] = "คัดลอกรายงานแล้ว ({n} ตัวอักษร)",
    ["ui.diag.export.console"] = "ไม่มี clipboard — พิมพ์รายงานออกคอนโซลแล้ว",
    ["ui.diag.close"] = "✕ ปิด",
    ["ui.diag.frame"] = "เฟรม",
    ["ui.diag.memory"] = "หน่วยความจำ (กราฟ 15 นาทีล่าสุด)",
    ["ui.diag.registry"] = "Registry (4 ชนิด — ต้องกลับเป็น 0 หลังปิดโมดูล)",
    ["ui.diag.bus"] = "Event Bus",
    ["ui.diag.objects"] = "วัตถุ ESP",
    ["ui.diag.macro"] = "Macro",
    ["ui.diag.system"] = "ระบบ",
    ["ui.diag.pending"] = "— (ยังไม่มีโมดูลในเฟสนี้)",
  },
  en = {
    ["ui.hub.title"] = "THE VOIDER",
    ["ui.hub.search"] = "🔍 Search features…",
    ["ui.hub.version"] = "v{v}",
    ["ui.hub.status.ready"] = "System ready",
    ["ui.hub.status.degraded"] = "Adapter degraded — waiting for The Voider update",
    ["ui.hub.tab.aim"] = "⭐ Aim",
    ["ui.hub.tab.esp"] = "👁 ESP",
    ["ui.hub.tab.macro"] = "🎹 Macro",
    ["ui.hub.tab.combat"] = "⚔ Combat",
    ["ui.hub.tab.race"] = "🧬 Race",
    ["ui.hub.tab.fruit"] = "🍎 Fruit",
    ["ui.hub.tab.move"] = "🏃 Move",
    ["ui.hub.tab.hop"] = "🛰 Hop",
    ["ui.hub.tab.setup"] = "⚙ Setup",
    ["ui.hub.coming"] = "The {name} module arrives in phase {phase} per the roadmap",
    ["ui.hub.coming.sub"] = "No settings to show in this phase yet (plan §5.2)",
    ["ui.setup.lang"] = "ภาษา / Language",
    ["ui.setup.lang.th"] = "ไทย",
    ["ui.setup.lang.en"] = "English",
    ["ui.setup.accent"] = "Accent color",
    ["ui.setup.accent.err"] = "Unsupported accent",
    ["ui.accent.purple"] = "Purple",
    ["ui.accent.cyan"] = "Cyan",
    ["ui.accent.pink"] = "Pink",
    ["ui.accent.green"] = "Green",
    ["ui.setup.tools"] = "Developer tools",
    ["ui.setup.diag.open"] = "Open Diagnostics panel",
    ["ui.setup.diag.export"] = "Export Diagnostics",
    ["ui.diag.exported"] = "Report copied ({n} chars)",
    ["ui.diag.export.console"] = "No clipboard — report printed to console",
    ["ui.diag.close"] = "✕ Close",
    ["ui.diag.frame"] = "Frame",
    ["ui.diag.memory"] = "Memory (graph: last 15 min)",
    ["ui.diag.registry"] = "Registry (4 kinds — must return to 0 after module close)",
    ["ui.diag.bus"] = "Event Bus",
    ["ui.diag.objects"] = "ESP objects",
    ["ui.diag.macro"] = "Macro",
    ["ui.diag.system"] = "System",
    ["ui.diag.pending"] = "— (no module in this phase yet)",
  },
}

function Hub.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    runtime = ctx.runtime,
    backend = ctx.backend,
    config = ctx.config,     -- ConfigService (declared dep)
    i18n = ctx.i18n,         -- I18nService (declared dep)
    services = ctx.services, -- Service Registry (ambient §3.5 — อ่าน Diagnostics)
    tokens = ctx.tokens,
    clock = ctx.clock or os.clock,
    version = ctx.version or "0.0.0",
    accents = ctx.accents or { "purple" },
    accent = ctx.accent or "purple",
    setAccent = ctx.setAccent, -- callback ของ assembler (ThemeEngine+config+fanout)
    built = false,
    visible = true,
    currentTab = "setup",
    tabBtns = {},            -- [key] = { h, order }
    contents = {},            -- [key] = handle (เนื้อหาของแต่ละแท็บ)
    langBtns = {},            -- [lang] = { h }
    accentBtns = {},          -- [name] = { h }
    elems = {},               -- [name] = handle
    graphBars = {},
    logoTaps = 0,
    lastTapAt = 0,
    panelOpen = false,
    feedback = { h = nil, text = "" },
    styling = { cards = {}, strokes = {}, textMain = {}, textDim = {}, hilite = {} },
  }, Hub)
  if self.i18n then
    self.i18n:AddTable("th", Hub.I18N.th)
    self.i18n:AddTable("en", Hub.I18N.en)
  end
  return self
end

-- ---- helpers -----------------------------------------------------------------

local function fmtMs(v)
  if v == nil then return "-" end
  return ("%.2f"):format(v)
end

function Hub:_T(key, params)
  if self.i18n then return self.i18n:T(key, params) end
  return key
end

function Hub:_svc()
  -- Direct Service "Diagnostics" (ambient §3.5) — ไม่มี = คืน nil (ไม่เดา)
  if self.services and self.services.Get then
    return self.services:Get("Diagnostics")
  end
  return nil
end

--- บันทึกตำแหน่ง hub ปัจจุบันลง config (§3.7 — ของผู้ใช้ ห้ามทิ้ง)
function Hub:_savePos()
  if not (self.config and self.mainH and self.mainH.obj) then return end
  local pos = self.mainH.obj.Position
  if not pos or not pos.X then return end
  self.config:Set("ui.hub.pos", {
    x = pos.X.Offset,
    y = pos.Y.Offset,
  }, { save = true })
end

function Hub:_saveOpen(v)
  if self.config then
    self.config:Set("ui.hub.open", v, { save = true })
  end
end

-- ---- สร้าง UI ครั้งเดียว -------------------------------------------------------

function Hub:Render()
  if self.built then return true end
  if not self.backend.available then
    return false, self.backend.reason
  end
  local R = self.runtime
  R.Scope(Hub.NODE, function()
    local tk = self.tokens or {}
    local L = tk.layout or {}
    local glass = tk.glass and (1 - tk.glass.CARD_ALPHA) or 0.88
    local S = self.styling
    local BE = self.backend

    -- ตำแหน่ง/สถานะเปิดจาก config (§3.7 — ผู้ใช้เป็นเจ้าของ)
    local pos = self.config and self.config:Get("ui.hub.pos") or nil
    local posX = (type(pos) == "table" and type(pos.x) == "number") and pos.x or 0
    local posY = (type(pos) == "table" and type(pos.y) == "number") and pos.y or -40
    local open = self.config and self.config:Get("ui.hub.open")
    if open == nil then open = true end
    if open == false then self.visible = false end

    self.gui = BE:Create("ScreenGui", { Name = "TVHub", DisplayOrder = 70, ResetOnSpawn = false })

    -- ปุ่มลอยเปิด hub (โผล่เฉพาะเมื่อ hub ถูกย่อ) — 44px (DoD §5.4)
    self.elems.pill = BE:Create("TextButton", {
      Name = "OpenPill",
      AnchorPoint = UDim2.new(0, 0, 0, 0),
      Position = UDim2.new(0, 16, 0, 16),
      Size = UDim2.new(0, L.TOUCH_MIN or 44, 0, L.TOUCH_MIN or 44),
      BackgroundColor3 = tk.card, BackgroundTransparency = glass,
      Text = "🕳", TextSize = 22, Font = Enum.Font.GothamBold,
      TextColor3 = tk.text, AutoButtonColor = false,
      Visible = not self.visible,
    }, self.gui.obj)
    S.cards[#S.cards + 1] = self.elems.pill
    BE:OnClick(self.elems.pill, function() self:SetVisible(true) end)

    -- หน้าต่างหลัก
    self.mainH = BE:Create("Frame", {
      Name = "Hub",
      AnchorPoint = UDim2.new(0.5, 0, 0.5, 0),
      Position = UDim2.new(0.5, posX, 0.5, posY),
      Size = UDim2.new(0, L.HUB_W or 560, 0, L.HUB_H or 420),
      BackgroundColor3 = tk.bg,
      BackgroundTransparency = 0.02,
      Visible = self.visible,
    }, self.gui.obj)
    S.cards[#S.cards + 1] = self.mainH
    BE:Create("UICorner", { CornerRadius = UDim.new(0, L.RADIUS or 10) }, self.mainH.obj)
    local mainStroke = BE:Create("UIStroke", {
      Color = tk.border, Thickness = L.STROKE or 1, Transparency = 0.25,
    }, self.mainH.obj)
    S.strokes[#S.strokes + 1] = mainStroke

    -- แถบหัว: โลโก้ (แตะ 5 ครั้ง = แผง Diagnostics §8.4) + เวอร์ชัน + สถานะ + ย่อ
    self.elems.header = BE:Create("Frame", {
      Name = "Header",
      Position = UDim2.new(0, 0, 0, 0),
      Size = UDim2.new(1, 0, 0, L.HEADER_H or 44),
      BackgroundColor3 = tk.card, BackgroundTransparency = glass,
    }, self.mainH.obj)
    S.cards[#S.cards + 1] = self.elems.header
    self.elems.logo = BE:Create("TextButton", {
      Name = "Logo",
      Position = UDim2.new(0, 12, 0, 0),
      Size = UDim2.new(0, 190, 1, 0),
      BackgroundTransparency = 1,
      Text = "🕳 " .. self:_T("ui.hub.title"),
      Font = Enum.Font.GothamBold, TextSize = L.FONT_TITLE or 18,
      TextColor3 = tk.text, TextXAlignment = Enum.TextXAlignment.Left,
      AutoButtonColor = false,
    }, self.elems.header.obj)
    S.textMain[#S.textMain + 1] = self.elems.logo
    self.elems.version = BE:Create("TextLabel", {
      Name = "Version",
      Position = UDim2.new(0, 206, 0, 0),
      Size = UDim2.new(0, 70, 1, 0),
      BackgroundTransparency = 1,
      Text = self:_T("ui.hub.version", { v = self.version }),
      Font = Enum.Font.Gotham, TextSize = L.FONT_SIZE or 14,
      TextColor3 = tk.textDim, TextXAlignment = Enum.TextXAlignment.Left,
    }, self.elems.header.obj)
    S.textDim[#S.textDim + 1] = self.elems.version
    self.elems.statusDot = BE:Create("Frame", {
      Name = "StatusDot",
      AnchorPoint = UDim2.new(1, 0, 0.5, 0),
      Position = UDim2.new(1, -110, 0.5, 0),
      Size = UDim2.new(0, 10, 0, 10),
      BackgroundColor3 = tk.on, BorderSizePixel = 0,
    }, self.elems.header.obj)
    self.elems.statusText = BE:Create("TextLabel", {
      Name = "StatusText",
      AnchorPoint = UDim2.new(1, 0, 0.5, 0),
      Position = UDim2.new(1, -60, 0.5, 0),
      Size = UDim2.new(0, 48, 0, L.LINE_H or 20),
      BackgroundTransparency = 1,
      Text = self:_T("ui.hub.status.ready"),
      Font = Enum.Font.Gotham, TextSize = 12,
      TextColor3 = tk.textDim, TextXAlignment = Enum.TextXAlignment.Right,
    }, self.elems.header.obj)
    S.textDim[#S.textDim + 1] = self.elems.statusText
    self.elems.minBtn = BE:Create("TextButton", {
      Name = "Minimize",
      AnchorPoint = UDim2.new(1, 0, 0, 0),
      Position = UDim2.new(1, -8, 0, 0),
      Size = UDim2.new(0, L.TOUCH_MIN or 44, 0, L.HEADER_H or 44),
      BackgroundTransparency = 1,
      Text = "—", Font = Enum.Font.GothamBold, TextSize = 20,
      TextColor3 = tk.textDim, AutoButtonColor = false,
    }, self.elems.header.obj)
    BE:OnClick(self.elems.minBtn, function() self:SetVisible(false) end)

    -- แถบค้นหา — พื้นที่สงวน P1 (§5.4 "พื้นที่สำหรับค้นหา P1")
    -- แสดง placeholder แต่ไม่มีพฤติกรรมในเฟสนี้ (ห้ามเพิ่ม feature เงียบ ๆ §4.5)
    self.elems.search = BE:Create("TextBox", {
      Name = "Search",
      Position = UDim2.new(0, 12, 0, (L.HEADER_H or 44) + 8),
      Size = UDim2.new(1, -24, 0, L.TOUCH_MIN or 44),
      BackgroundColor3 = tk.card, BackgroundTransparency = glass,
      Text = self:_T("ui.hub.search"),
      TextEditable = false, ClearTextOnFocus = false,
      Font = Enum.Font.Gotham, TextSize = L.FONT_SIZE or 14,
      TextColor3 = tk.textDim,
      TextXAlignment = Enum.TextXAlignment.Left,
    }, self.mainH.obj)
    S.cards[#S.cards + 1] = self.elems.search
    S.textDim[#S.textDim + 1] = self.elems.search

    -- แท็บซ้าย (8 โมดูล + Setup ตาม §8.3)
    local railTop = (L.HEADER_H or 44) + 8 + (L.TOUCH_MIN or 44) + 10
    self.elems.rail = BE:Create("Frame", {
      Name = "Tabs",
      Position = UDim2.new(0, 12, 0, railTop),
      Size = UDim2.new(0, L.TAB_W or 116, 1, -(railTop + 12)),
      BackgroundTransparency = 1,
    }, self.mainH.obj)
    self.elems.railList = BE:Create("UIListLayout", {
      Name = "List", Padding = UDim.new(0, L.GAP or 8),
      SortOrder = Enum.SortOrder.LayoutOrder,
    }, self.elems.rail.obj)
    for _, tab in ipairs(Hub.TABS) do
      local h = BE:Create("TextButton", {
        Name = "Tab_" .. tab.key,
        Size = UDim2.new(1, 0, 0, L.TAB_H or 44),
        LayoutOrder = tab.order,
        BackgroundTransparency = 1,
        Text = self:_T("ui.hub.tab." .. tab.key),
        Font = Enum.Font.GothamMedium, TextSize = L.FONT_SIZE or 14,
        TextColor3 = tk.textDim, AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
      }, self.elems.rail.obj)
      self.tabBtns[tab.key] = { h = h, order = tab.order }
      BE:OnClick(h, function() self:SwitchTab(tab.key) end)
    end

    -- เนื้อหาขวา
    self.elems.content = BE:Create("Frame", {
      Name = "Content",
      AnchorPoint = UDim2.new(1, 0, 0, 0),
      Position = UDim2.new(1, -12, 0, railTop),
      Size = UDim2.new(1, -((L.TAB_W or 116) + 36), 1, -(railTop + 12)),
      BackgroundTransparency = 1,
    }, self.mainH.obj)

    -- เนื้อหาแท็บโมดูล: empty-state โปร่งใส (§3.9 PENDING)
    for _, tab in ipairs(Hub.TABS) do
      if tab.phase > 0 then
        local c = BE:Create("Frame", {
          Name = "Content_" .. tab.key,
          Size = UDim2.new(1, 0, 1, 0),
          BackgroundTransparency = 1, Visible = false,
        }, self.elems.content.obj)
        local big = BE:Create("TextLabel", {
          Name = "Icon",
          AnchorPoint = UDim2.new(0.5, 0, 0, 0),
          Position = UDim2.new(0.5, 0, 0, 24),
          Size = UDim2.new(0, 64, 0, 64),
          BackgroundTransparency = 1, Text = tab.icon,
          Font = Enum.Font.GothamBold, TextSize = 44, TextColor3 = tk.textDim,
        }, c.obj)
        S.textDim[#S.textDim + 1] = big
        local t1 = BE:Create("TextLabel", {
          Name = "Coming",
          AnchorPoint = UDim2.new(0.5, 0, 0, 0),
          Position = UDim2.new(0.5, 0, 0, 108),
          Size = UDim2.new(1, -32, 0, L.LINE_H or 20),
          BackgroundTransparency = 1,
          Text = self:_T("ui.hub.coming", { name = tab.name, phase = tab.phase }),
          Font = Enum.Font.Gotham, TextSize = L.FONT_SIZE or 14, TextColor3 = tk.text,
        }, c.obj)
        S.textMain[#S.textMain + 1] = t1
        local t2 = BE:Create("TextLabel", {
          Name = "ComingSub",
          AnchorPoint = UDim2.new(0.5, 0, 0, 0),
          Position = UDim2.new(0.5, 0, 0, 132),
          Size = UDim2.new(1, -32, 0, L.LINE_H or 20),
          BackgroundTransparency = 1,
          Text = self:_T("ui.hub.coming.sub"),
          Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = tk.textDim,
        }, c.obj)
        S.textDim[#S.textDim + 1] = t2
        self.contents[tab.key] = c
      end
    end

    -- เนื้อหาแท็บ Setup
    self:_buildSetup(tk, L, glass)

    -- ลากย้ายที่แถบหัว + บันทึกตำแหน่งเมื่อปล่อย (§3.7)
    BE:MakeDraggable(self.mainH, self.elems.header, {
      onDragEnd = function() self:_savePos() end,
    })

    -- แผง Diagnostics เต็มรูปแบบ (§8.4) — สร้างไว้ซ่อน
    self:_buildDiagPanel(tk, L, glass)

    -- โลโก้ 5 แตะ → เปิดแผง
    BE:OnClick(self.elems.logo, function() self:_logoTap() end)

    -- โพลล์ 1 วิ: สถานะหัว (สด) + รีเฟรชแผงถ้าเปิดอยู่ (§8.4 "แสดงสด ๆ")
    self.runtime.Spawn("hub:poll", function(ctx)
      while true do
        if not ctx.ShouldRun() then return end
        ctx.Wait(1)
        if not ctx.ShouldRun() then return end
        if self.built then
          if self.visible then self:RefreshStatus() end
          if self.panelOpen then self:RefreshPanel() end
        end
      end
    end)
  end)
  self.built = true
  self:SwitchTab(self.currentTab)
  return true
end

-- ---- แท็บ Setup -----------------------------------------------------------------

function Hub:_buildSetup(tk, L, glass)
  local BE = self.backend
  local S = self.styling
  local c = BE:Create("Frame", {
    Name = "Content_setup",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1, Visible = false,
  }, self.elems.content.obj)
  self.contents.setup = c

  local function sectionLabel(name, textKey, y)
    local h = BE:Create("TextLabel", {
      Name = name,
      Position = UDim2.new(0, 4, 0, y),
      Size = UDim2.new(1, -8, 0, L.LINE_H or 20),
      BackgroundTransparency = 1,
      Text = self:_T(textKey),
      Font = Enum.Font.GothamBold, TextSize = L.FONT_SIZE or 14,
      TextColor3 = tk.hilite, TextXAlignment = Enum.TextXAlignment.Left,
    }, c.obj)
    S.hilite[#S.hilite + 1] = h
    return h
  end
  local function actionBtn(name, textKey, x, y, w)
    local h = BE:Create("TextButton", {
      Name = name,
      Position = UDim2.new(0, x, 0, y),
      Size = UDim2.new(0, w, 0, L.TOUCH_MIN or 44),
      BackgroundColor3 = tk.card, BackgroundTransparency = glass,
      Text = self:_T(textKey),
      Font = Enum.Font.GothamMedium, TextSize = L.FONT_SIZE or 14,
      TextColor3 = tk.text, AutoButtonColor = false,
    }, c.obj)
    S.cards[#S.cards + 1] = h
    S.textMain[#S.textMain + 1] = h
    BE:Create("UICorner", { CornerRadius = UDim.new(0, L.RADIUS or 10) }, h.obj)
    return h
  end

  -- ภาษา
  sectionLabel("LangTitle", "ui.setup.lang", 12)
  self.langBtns.th = actionBtn("LangTh", "ui.setup.lang.th", 4, 40, 96)
  self.langBtns.en = actionBtn("LangEn", "ui.setup.lang.en", 108, 40, 110)
  BE:OnClick(self.langBtns.th, function()
    if self.config then self.config:Set("i18n.lang", "th", { save = true }) end
    if self.i18n then
      self.i18n:Set("th")
      self:RerenderTexts() -- Hub ไม่มี bus เป็น dep — เรียกเองหลังเปลี่ยน (§3.10)
    end
    self:_restyleLangBtns()
  end)
  BE:OnClick(self.langBtns.en, function()
    if self.config then self.config:Set("i18n.lang", "en", { save = true }) end
    if self.i18n then
      self.i18n:Set("en")
      self:RerenderTexts()
    end
    self:_restyleLangBtns()
  end)

  -- สีเน้น (§8.2) — ผ่าน callback ของ assembler (ThemeEngine + config + fanout)
  sectionLabel("AccentTitle", "ui.setup.accent", 104)
  local ax = 4
  for _, name in ipairs(self.accents) do
    local h = actionBtn("Accent_" .. name, "ui.accent." .. name, ax, 132, 96)
    self.accentBtns[name] = h
    ax = ax + 104
    BE:OnClick(h, function() self:TrySetAccent(name) end)
  end

  -- เครื่องมือนักพัฒนา (§8.4)
  sectionLabel("ToolsTitle", "ui.setup.tools", 196)
  local openBtn = actionBtn("DiagOpen", "ui.setup.diag.open", 4, 224, 220)
  local exportBtn = actionBtn("DiagExport", "ui.setup.diag.export", 232, 224, 200)
  BE:OnClick(openBtn, function() self:OpenPanel() end)
  BE:OnClick(exportBtn, function() self:DoExport() end)

  -- ป้ายผลลัพธ์ (export/accent error)
  local fb = BE:Create("TextLabel", {
    Name = "Feedback",
    Position = UDim2.new(0, 4, 0, 280),
    Size = UDim2.new(1, -8, 0, L.LINE_H or 20),
    BackgroundTransparency = 1,
    Text = "", Font = Enum.Font.Gotham, TextSize = 12,
    TextColor3 = tk.textDim, TextXAlignment = Enum.TextXAlignment.Left,
  }, c.obj)
  self.feedback.h = fb
  S.textDim[#S.textDim + 1] = fb
end

--- เปลี่ยน accent ผ่าน assembler — ไม่สำเร็จ = แจ้งในป้าย (ไม่เดาเงียบ ๆ)
function Hub:TrySetAccent(name)
  if type(self.setAccent) ~= "function" then
    self:_feedback(self:_T("ui.setup.accent.err"))
    return false
  end
  local ok, err = self.setAccent(name)
  if ok then
    self.accent = name
    self:_restyleAccentBtns()
    self:_feedback("")
    return true
  end
  self:_feedback(self:_T("ui.setup.accent.err") .. " (" .. tostring(name) .. ")")
  return false, err
end

function Hub:_feedback(text)
  self.feedback.text = text
  if self.feedback.h and self.feedback.h.obj then
    self.feedback.h.obj.Text = text
  end
end

-- ---- แผง Diagnostics เต็มรูปแบบ (§8.4) -----------------------------------------

function Hub:_buildDiagPanel(tk, L, glass)
  local BE = self.backend
  local S = self.styling

  self.elems.panel = BE:Create("Frame", {
    Name = "DiagPanel",
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = tk.bg,
    BackgroundTransparency = 0.02,
    Visible = false, ZIndex = 50,
  }, self.mainH.obj)
  S.cards[#S.cards + 1] = self.elems.panel

  local close = BE:Create("TextButton", {
    Name = "Close",
    AnchorPoint = UDim2.new(1, 0, 0, 0),
    Position = UDim2.new(1, -8, 0, 6),
    Size = UDim2.new(0, L.TOUCH_MIN or 44, 0, L.TOUCH_MIN or 44),
    BackgroundTransparency = 1, ZIndex = 51,
    Text = self:_T("ui.diag.close"),
    Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = tk.textDim,
    AutoButtonColor = false,
  }, self.elems.panel.obj)
  BE:OnClick(close, function() self:ClosePanel() end)

  local function row(name, titleKey, y, h)
    local t = BE:Create("TextLabel", {
      Name = name .. "Title",
      Position = UDim2.new(0, 16, 0, y),
      Size = UDim2.new(1, -32, 0, L.LINE_H or 20),
      BackgroundTransparency = 1, ZIndex = 51,
      Text = self:_T(titleKey),
      Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = tk.hilite,
      TextXAlignment = Enum.TextXAlignment.Left,
    }, self.elems.panel.obj)
    S.hilite[#S.hilite + 1] = t
    local v = BE:Create("TextLabel", {
      Name = name .. "Value",
      Position = UDim2.new(0, 16, 0, y + (L.LINE_H or 20)),
      Size = UDim2.new(1, -32, 0, h or (L.LINE_H or 20)),
      BackgroundTransparency = 1, ZIndex = 51,
      Text = "-", Font = Enum.Font.Gotham, TextSize = L.FONT_MONO or 13,
      TextColor3 = tk.text, TextXAlignment = Enum.TextXAlignment.Left,
    }, self.elems.panel.obj)
    S.textMain[#S.textMain + 1] = v
    return v
  end

  self.pRows = {
    frame = row("Frame", "ui.diag.frame", 12, 40),
    memory = row("Memory", "ui.diag.memory", 76, 18),
    registry = row("Registry", "ui.diag.registry", 114, 18),
    bus = row("Bus", "ui.diag.bus", 152, 18),
    objects = row("Objects", "ui.diag.objects", 190, 18),
    macro = row("Macro", "ui.diag.macro", 228, 18),
    system = row("System", "ui.diag.system", 266, 74),
  }

  -- กราฟ memory วาดจริง (§8.4 "กราฟย้อนหลัง 15 นาที ตรวจด้วยตาได้เลย")
  self.elems.graph = BE:Create("Frame", {
    Name = "MemGraph",
    Position = UDim2.new(0, 16, 0, 118),
    Size = UDim2.new(1, -32, 0, 58),
    BackgroundColor3 = tk.card, BackgroundTransparency = 0.6, ZIndex = 51,
  }, self.elems.panel.obj)
  S.cards[#S.cards + 1] = self.elems.graph
  BE:Create("UIListLayout", {
    Name = "Bars",
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding = UDim.new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder,
  }, self.elems.graph.obj)

  -- ปุ่ม Export ในแผง (เครื่องมือ §8.4)
  local ex = BE:Create("TextButton", {
    Name = "Export",
    Position = UDim2.new(0, 16, 1, -56),
    Size = UDim2.new(0, 210, 0, L.TOUCH_MIN or 44),
    BackgroundColor3 = tk.card, BackgroundTransparency = glass, ZIndex = 51,
    Text = self:_T("ui.setup.diag.export"),
    Font = Enum.Font.GothamMedium, TextSize = L.FONT_SIZE or 14,
    TextColor3 = tk.text, AutoButtonColor = false,
  }, self.elems.panel.obj)
  S.cards[#S.cards + 1] = ex
  S.textMain[#S.textMain + 1] = ex
  BE:OnClick(ex, function() self:DoExport() end)
  local fb = BE:Create("TextLabel", {
    Name = "PanelFeedback",
    Position = UDim2.new(0, 236, 1, -56),
    Size = UDim2.new(1, -252, 0, L.TOUCH_MIN or 44),
    BackgroundTransparency = 1, ZIndex = 51,
    Text = "", Font = Enum.Font.Gotham, TextSize = 12,
    TextColor3 = tk.textDim, TextXAlignment = Enum.TextXAlignment.Left,
  }, self.elems.panel.obj)
  self.panelFeedback = { h = fb }
  S.textDim[#S.textDim + 1] = fb
end

function Hub:_logoTap()
  local now = self.clock()
  if now - self.lastTapAt > Hub.TAP_WINDOW then
    self.logoTaps = 1
  else
    self.logoTaps = self.logoTaps + 1
  end
  self.lastTapAt = now
  if self.logoTaps >= Hub.LOGO_TAPS then
    self.logoTaps = 0
    self:OpenPanel()
  end
end

function Hub:OpenPanel()
  if not (self.built and self.elems.panel and self.elems.panel.obj) then
    return false, "hub ยังไม่ถูกสร้าง"
  end
  self.panelOpen = true
  self.elems.panel.obj.Visible = true
  self:RefreshPanel()
  return true
end

function Hub:ClosePanel()
  self.panelOpen = false
  if self.elems.panel and self.elems.panel.obj then
    self.elems.panel.obj.Visible = false
  end
  -- คืนแท่งกราฟ (handle ทุกตัว — กัน orphan สะสมข้ามการเปิด)
  for _, h in ipairs(self.graphBars) do
    if h.Release then h.Release() end
  end
  self.graphBars = {}
  return true
end

--- อัปเดตแผงจาก Direct Service "Diagnostics" (สด ๆ §8.4)
function Hub:RefreshPanel()
  if not self.panelOpen then return end
  local svc = self:_svc()
  if not svc then return end
  local snap = svc.Snapshot()
  if not snap then return end

  -- เฟรม: FPS + ต้นทุนต่อโมดูล (min/avg/max)
  local fpsTxt = snap.fps and ("%d"):format(snap.fps) or "-"
  local lines = { ("FPS %s"):format(fpsTxt) }
  local names = {}
  for n in pairs(snap.timers or {}) do names[#names + 1] = n end
  table.sort(names)
  for _, n in ipairs(names) do
    local t = snap.timers[n]
    if t and t.count and t.count > 0 then
      lines[#lines + 1] = ("  [%s] n=%d avg=%sms max=%sms"):format(
        n, t.count, fmtMs(t.total / t.count), fmtMs(t.max))
    end
  end
  self.pRows.frame.obj.Text = table.concat(lines, "\n")

  -- หน่วยความจำ
  self.pRows.memory.obj.Text = snap.memoryKb
    and ("ใช้ปัจจุบัน %.0f KB (แท่ง = sample ย้อนหลัง)"):format(snap.memoryKb)
    or "ใช้ปัจจุบัน - (สภาพแวดล้อมนี้ไม่รายงาน)"

  -- Registry 4 ชนิด (สด ๆ — ต้องกลับเป็น 0 หลังปิดโมดูล)
  local r = snap.registry or { tasks = 0, connections = 0, renders = 0, temps = 0 }
  self.pRows.registry.obj.Text = ("task %d · connection %d · render %d · temp %d (total %d)")
    :format(r.tasks, r.connections, r.renders, r.temps, r.total or 0)

  -- Event Bus
  local b = snap.bus or { perSec = 0, queued = 0 }
  self.pRows.bus.obj.Text = ("events/sec %d · คิวค้าง %d · subscribers %d")
    :format(b.perSec or 0, b.queued or 0, b.subscribers or 0)

  -- ESP objects / Macro: ยังไม่มีโมดูล (PENDING โปร่งใส §3.9)
  self.pRows.objects.obj.Text = self:_T("ui.diag.pending")
  self.pRows.macro.obj.Text = self:_T("ui.diag.pending")

  -- ระบบ: capability + adapter + เวลา
  local sys = {}
  if snap.capability then
    local parts = {}
    local caps = {}
    for n in pairs(snap.capability) do caps[#caps + 1] = n end
    table.sort(caps)
    for _, n in ipairs(caps) do
      parts[#parts + 1] = ("%s=%s"):format(n, snap.capability[n].supported and "Y" or "N")
    end
    sys[#sys + 1] = "capability: " .. table.concat(parts, " ")
  end
  if snap.adapterHealth then
    local nApi = (snap.adapterHealth.adapters and #snap.adapterHealth.adapters) or 0
    sys[#sys + 1] = ("adapter: %s%s"):format(
      snap.adapterHealth.summary or "-",
      nApi > 0 and string.format(" (%d API)", nApi) or "")
  else
    sys[#sys + 1] = "adapter: (ยังไม่ probe)"
  end
  local m = snap.marks or {}
  sys[#sys + 1] = ("startup %sms · config load %sms · hot update %sms"):format(
    fmtMs(m.startupMs), fmtMs(m.configLoadMs), fmtMs(m.hotUpdateMs))
  sys[#sys + 1] = ("uptime %ds"):format(snap.uptimeSec or 0)
  self.pRows.system.obj.Text = table.concat(sys, "\n")

  -- กราฟ memory วาดจริง — สร้าง/คืนแท่งใน Scope ของ node นี้เสมอ
  self:_renderMemGraph(svc)
end

function Hub:_renderMemGraph(svc)
  local series = svc.MemorySeries and svc.MemorySeries() or {}
  -- คืนของเก่าก่อน (handle ทุกตัวของกราฟเดิม)
  for _, h in ipairs(self.graphBars) do
    if h.Release then h.Release() end
  end
  self.graphBars = {}
  if #series == 0 then return end

  self.runtime.Scope(Hub.NODE, function()
    local tk = self.tokens or {}
    local maxMem = 1
    local startAt = math.max(1, #series - 59) -- แท่งสูงสุด 60 อัน (15 นาที @ 5 วิ/sample ย่อ)
    for i = startAt, #series do
      local s = series[i]
      if s.memoryKb and s.memoryKb > maxMem then maxMem = s.memoryKb end
    end
    for i = startAt, #series do
      local s = series[i]
      local mem = s.memoryKb or 0
      local h = math.max(2, math.floor((mem / maxMem) * 54 + 0.5))
      local bar = self.backend:Create("Frame", {
        Name = "Bar",
        Size = UDim2.new(0, 3, 0, h),
        BackgroundColor3 = tk.accentA or nil,
        BorderSizePixel = 0, ZIndex = 52,
        LayoutOrder = #self.graphBars + 1,
      }, self.elems.graph.obj)
      self.graphBars[#self.graphBars + 1] = bar
    end
  end)
end

--- Export Diagnostics (§8.4 เครื่องมือ) — คัดลอก หรือพิมพ์คอนโซลเมื่อไม่มี clipboard
function Hub:DoExport()
  local svc = self:_svc()
  if not svc then
    self:_feedback("Diagnostics service ไม่พร้อม")
    return false
  end
  local text, ok
  if svc.ExportToClipboard then
    text, ok = svc.ExportToClipboard()
  else
    text = svc.Export()
    ok = false
  end
  text = text or ""
  if ok then
    self:_feedback(self:_T("ui.diag.exported", { n = #text }))
  else
    -- No Silent Degradation: ไม่มี clipboard = พิมพ์ออกคอนโซลให้คัดลอกเอง
    print(text)
    self:_feedback(self:_T("ui.diag.export.console"))
  end
  return true
end

--- สถานะหัว: จุด + ข้อความ (สดจาก Diagnostics — โพลล์ 1 วิ)
function Hub:RefreshStatus()
  if not self.built then return end
  local svc = self:_svc()
  local status = "ok"
  if svc then
    local snap = svc.Snapshot()
    if snap and snap.adapterHealth and snap.adapterHealth.status then
      status = snap.adapterHealth.status
    end
  end
  local dotColor = (status == "ok" and self.tokens and self.tokens.on)
    or (status == "degraded" and self.tokens and self.tokens.warn)
    or (self.tokens and self.tokens.danger)
  if self.elems.statusDot and self.elems.statusDot.obj then
    self.elems.statusDot.obj.BackgroundColor3 = dotColor
  end
  if self.elems.statusText and self.elems.statusText.obj then
    self.elems.statusText.obj.Text = self:_T(status == "ok"
      and "ui.hub.status.ready" or "ui.hub.status.degraded")
  end
end

-- ---- แท็บ ---------------------------------------------------------------------

function Hub:SwitchTab(key)
  if not self.built then return false end
  if not self.contents[key] then return false end
  self.currentTab = key
  for k, c in pairs(self.contents) do
    if c and c.obj then
      c.obj.Visible = (k == key)
    end
  end
  self:_restyleTabs()
  return true
end

function Hub:_restyleTabs()
  local tk = self.tokens or {}
  for k, btn in pairs(self.tabBtns) do
    if btn.h and btn.h.obj then
      if k == self.currentTab then
        btn.h.obj.BackgroundTransparency = 0.72
        btn.h.obj.BackgroundColor3 = tk.accentB or nil
        btn.h.obj.TextColor3 = tk.text or nil
      else
        btn.h.obj.BackgroundTransparency = 1
        btn.h.obj.TextColor3 = tk.textDim or nil
      end
    end
  end
end

function Hub:_restyleAccentBtns()
  local tk = self.tokens or {}
  for name, h in pairs(self.accentBtns) do
    if h and h.obj then
      if name == self.accent then
        h.obj.BackgroundTransparency = 0.72
        h.obj.BackgroundColor3 = tk.accentB or nil
        h.obj.TextColor3 = tk.text or nil
      else
        h.obj.BackgroundTransparency = 0.88
        h.obj.BackgroundColor3 = tk.card or nil
        h.obj.TextColor3 = tk.textDim or nil
      end
    end
  end
end

function Hub:_restyleLangBtns()
  local tk = self.tokens or {}
  local cur = self.i18n and self.i18n:Lang() or "th"
  for lang, h in pairs(self.langBtns) do
    if h and h.obj then
      if lang == cur then
        h.obj.BackgroundTransparency = 0.72
        h.obj.BackgroundColor3 = tk.accentB or nil
        h.obj.TextColor3 = tk.text or nil
      else
        h.obj.BackgroundTransparency = 0.88
        h.obj.BackgroundColor3 = tk.card or nil
        h.obj.TextColor3 = tk.textDim or nil
      end
    end
  end
end

-- ---- มองเห็น/ไม่มองเห็น (DoD: เปิด-ปิด-เปิด 20 รอบ orphan 0) ------------------

function Hub:SetVisible(v)
  if not self.built then return false end
  self.visible = v == true
  if self.mainH and self.mainH.obj then
    self.mainH.obj.Visible = self.visible
  end
  if self.elems.pill and self.elems.pill.obj then
    -- [CR-PC-ONLY] เดิมซ่อน pill ในโหมดมือถือ (MobileLayout มีปุ่มลัดลอยของตัวเอง)
    -- ตัด MobileLayout แล้ว pill จึงแสดงทุกครั้งที่ hub ถูกย่อ
    self.elems.pill.obj.Visible = not self.visible
  end
  if not self.visible and self.panelOpen then
    self:ClosePanel()
  end
  self:_saveOpen(self.visible)
  return true
end

function Hub:Toggle()
  return self:SetVisible(not self.visible)
end

-- [CR-PC-ONLY 1 ต.ค. 2026] Hub:SetLayoutMode / Hub:LayoutMode ถูกตัดออก
-- (เดิมถูกเรียกโดย MobileLayout ตาม edge ใน graph — node นั้นถูกตัดจาก scope
-- ตาม dependencies.md v1.6) UI เหลือเลย์เอาต์ desktop เดียวตาม layout
-- constants ของ ThemeEngine — อุปกรณ์ทัชอย่างเดียวก็ได้เลย์เอาต์นี้เหมือนกัน
-- ---- แปลทั้งหมดใหม่ (เปลี่ยนภาษา — DoD ห้ามข้อความค้างภาษาเดิม) ---------------

function Hub:RerenderTexts()
  if not self.built then return end
  local L = (self.tokens and self.tokens.layout) or {}
  if self.elems.logo and self.elems.logo.obj then
    self.elems.logo.obj.Text = "🕳 " .. self:_T("ui.hub.title")
  end
  if self.elems.version and self.elems.version.obj then
    self.elems.version.obj.Text = self:_T("ui.hub.version", { v = self.version })
  end
  if self.elems.search and self.elems.search.obj then
    self.elems.search.obj.Text = self:_T("ui.hub.search")
  end
  for _, tab in ipairs(Hub.TABS) do
    local btn = self.tabBtns[tab.key]
    if btn and btn.h and btn.h.obj then
      btn.h.obj.Text = self:_T("ui.hub.tab." .. tab.key)
    end
    if tab.phase > 0 and self.contents[tab.key] then
      local c = self.contents[tab.key]
      local coming = c.obj and c.obj:FindFirstChild("Coming")
      local sub = c.obj and c.obj:FindFirstChild("ComingSub")
      if coming then
        coming.Text = self:_T("ui.hub.coming", { name = tab.name, phase = tab.phase })
      end
      if sub then
        sub.Text = self:_T("ui.hub.coming.sub")
      end
    end
  end
  if self.feedback.h and self.feedback.h.obj then
    -- ป้ายผลลัพธ์ไม่ต้องแปลซ้ำ (เป็นผลลัพธ์ล่าสุด — ว่างได้)
    self.feedback.h.obj.Text = self.feedback.text
  end
  self:RefreshStatus()
  if self.panelOpen then self:RefreshPanel() end
end

-- ---- theme -----------------------------------------------------------------

function Hub:ApplyTheme(tokens)
  self.tokens = tokens
  if not self.built then return self end
  local S = self.styling
  for _, h in ipairs(S.cards) do
    if h and h.obj then h.obj.BackgroundColor3 = tokens.card end
  end
  for _, h in ipairs(S.strokes) do
    if h and h.obj then h.obj.Color = tokens.border end
  end
  for _, h in ipairs(S.textMain) do
    if h and h.obj then h.obj.TextColor3 = tokens.text end
  end
  for _, h in ipairs(S.textDim) do
    if h and h.obj then h.obj.TextColor3 = tokens.textDim end
  end
  for _, h in ipairs(S.hilite) do
    if h and h.obj then h.obj.TextColor3 = tokens.hilite end
  end
  self:_restyleTabs()
  self:_restyleAccentBtns()
  self:_restyleLangBtns()
  self:RefreshStatus()
  return self
end

-- ---- สถานะ / ปิด ------------------------------------------------------------

function Hub:Stats()
  return {
    built = self.built,
    visible = self.visible,
    tab = self.currentTab,
    panelOpen = self.panelOpen,
    accent = self.accent,
  }
end

function Hub:Shutdown()
  if self.runtime and self.runtime.Release then
    self.runtime.Release(Hub.NODE)
  end
  self.graphBars = {}
  self.built = false
  self.panelOpen = false
  return true
end

return Hub

  end)();
  __TV_PACKAGES['ui_hub'] = __m;
end
-- ==== package: ui_hud (core/ui/hud.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/ui/hud.lua
-- HUD (เฟส 1 UI Framework — แผน freeze v2.1 §5.4 + §8.3 + §9.1)
--
-- node L6 ตาม dependency graph: HUD | FPS/uptime/สถานะ + Diagnostics ย่อ
-- | deps: DiagnosticsService, EventBus
--
--   แถบลอยลากย้ายได้ (§5.4 "HUD เต็มรูปแบบ (ลากย้าย + FPS + uptime)")
--   + จุดสถานะสด (§8.3: Adapter Health + คิว Event Bus)
--   + ไดอักนอสติกย่อ: แตะแถบ → ขยายดูตัวเลข Registry/Event Bus สด
--     (ดูแบบเต็มที่แท็บ Setup → Diagnostics ของ Hub)
--
--   FPS: วัดจาก frame task ของ node นี้ (task.wait ≈ 1 เฟรมทั้งใน
--   production และ virtual-time ของเทส) → EMA → ต่อเข้า Diagnostics
--   ผ่าน SetFpsProvider (§8.4 "FPS จริง")
--   ต้นทุน UI render ต่อเฟรม วัดด้วย timer ชื่อ "ui" ของ Diagnostics
--   (DoD §5.4: ≤ 0.5 ms/frame ใน test env — ตัวเลขออกที่ Export/แผงเต็ม)
--
--   อัปเดตหนัก (Snapshot) เกิดเฉพาะเมื่อแผงย่อเปิดอยู่จริง (§9 งบ)
--   ป้าย FPS/uptime อัปเดต 4 ครั้ง/วิ — ไม่ใช่ทุกเฟรม
-- ============================================================================

local HUD = {}
HUD.__index = HUD

HUD.NODE = "HUD"
HUD.VERSION = "0.1.0"

HUD.I18N = {
  th = {
    ["ui.hud.fps"] = "FPS {v}",
    ["ui.hud.online.sec"] = "ออนไลน์ {v} วิ",
    ["ui.hud.online.min"] = "ออนไลน์ {v} นาที",
    ["ui.hud.online.hr"] = "ออนไลน์ {v} ชม.",
    ["ui.hud.dot.adapter"] = "Adapter",
    ["ui.hud.mini.registry"] = "Registry: task {t} · conn {c} · render {r} · temp {tp}",
    ["ui.hud.mini.bus"] = "Event Bus: {eps}/วิ · คิวค้าง {q}",
    ["ui.hud.mini.adapter"] = "Adapter: {status}",
    ["ui.hud.mini.fullhint"] = "ดูแบบเต็ม: แท็บ Setup → Diagnostics",
  },
  en = {
    ["ui.hud.fps"] = "FPS {v}",
    ["ui.hud.online.sec"] = "Online {v}s",
    ["ui.hud.online.min"] = "Online {v}m",
    ["ui.hud.online.hr"] = "Online {v}h",
    ["ui.hud.dot.adapter"] = "Adapter",
    ["ui.hud.mini.registry"] = "Registry: task {t} · conn {c} · render {r} · temp {tp}",
    ["ui.hud.mini.bus"] = "Event Bus: {eps}/sec · queued {q}",
    ["ui.hud.mini.adapter"] = "Adapter: {status}",
    ["ui.hud.mini.fullhint"] = "Full view: Setup tab → Diagnostics",
  },
}

function HUD.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    runtime = ctx.runtime,
    backend = ctx.backend,
    bus = ctx.bus,          -- EventBus (declared dep)
    diag = ctx.diag,        -- DiagnosticsService (declared dep)
    i18n = ctx.i18n,        -- แปลป้าย (ตามแบบ probe.lua ที่ถือ F.I18n ตรง ๆ)
    tokens = ctx.tokens,
    clock = ctx.clock or os.clock,
    built = false,
    fpsEMA = nil,
    uptime = 0,
    updateAcc = 0,
    lastAdapter = nil,      -- สรุปล่าสุดจาก adapter:health
    labels = {},            -- [name] = handle ของป้าย (รีเรนเดอร์ภาษา/theme)
    dots = {},
    miniVisible = false,
  }, HUD)
  if self.i18n then
    self.i18n:AddTable("th", HUD.I18N.th)
    self.i18n:AddTable("en", HUD.I18N.en)
  end
  return self
end

-- ---- ตัวช่วยภายใน ---------------------------------------------------------------

local STATUS_COLOR = { ok = "on", degraded = "warn", dead = "danger" }

function HUD:_statusColor(status)
  local role = STATUS_COLOR[status or "ok"] or "on"
  return self.tokens and self.tokens[role] or nil
end

--- ข้อความ uptime ตามช่วงเวลา (วิ/นาที/ชม.)
function HUD:_uptimeText()
  local s = math.floor(self.uptime + 0.5)
  if self.i18n == nil then return tostring(s) end
  if s < 60 then
    return self.i18n:T("ui.hud.online.sec", { v = s })
  elseif s < 3600 then
    return self.i18n:T("ui.hud.online.min", { v = math.floor(s / 60) })
  end
  return self.i18n:T("ui.hud.online.hr", { v = math.floor(s / 3600) })
end

-- ---- สร้าง UI + frame task ครั้งเดียว ------------------------------------------

function HUD:Render()
  if self.built then return true end
  if not self.backend.available then
    return false, self.backend.reason
  end
  local R = self.runtime
  R.Scope(HUD.NODE, function()
    local tk = self.tokens or {}
    local L = tk.layout or {}
    local glass = tk.glass and (1 - tk.glass.CARD_ALPHA) or 0.88

    self.gui = self.backend:Create("ScreenGui", {
      Name = "TVHud", DisplayOrder = 50, ResetOnSpawn = false,
    })
    self.bar = self.backend:Create("Frame", {
      Name = "Bar",
      AnchorPoint = UDim2.new(0.5, 0, 1, 0),
      Position = UDim2.new(0.5, 0, 1, -76),
      Size = UDim2.new(0, 360, 0, L.TOUCH_MIN or 44), -- แถบแตะได้ ≥ 44 (DoD §5.4)
      BackgroundColor3 = tk.card,
      BackgroundTransparency = glass,
    }, self.gui.obj)
    self.backend:Create("UICorner", { CornerRadius = UDim.new(0, L.RADIUS or 10) }, self.bar.obj)
    self.backend:Create("UIStroke", {
      Color = tk.border, Thickness = L.STROKE or 1, Transparency = 0.35,
    }, self.bar.obj)
    self.backend:Create("UIListLayout", {
      Name = "Row",
      FillDirection = Enum.FillDirection.Horizontal,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      VerticalAlignment = Enum.VerticalAlignment.Center,
      Padding = UDim.new(0, L.GAP or 8),
      SortOrder = Enum.SortOrder.LayoutOrder,
    }, self.bar.obj)

    -- จุดสถานะ adapter (สดจาก adapter:health — replay policy §3.6)
    self.dots.adapter = self.backend:Create("Frame", {
      Name = "DotAdapter",
      LayoutOrder = 1,
      Size = UDim2.new(0, 10, 0, 10),
      BackgroundColor3 = self:_statusColor("ok"),
      BorderSizePixel = 0,
    }, self.bar.obj)
    self.labels.fps = self.backend:Create("TextLabel", {
      Name = "Fps", LayoutOrder = 2,
      BackgroundTransparency = 1,
      Size = UDim2.new(0, 90, 1, 0),
      Font = Enum.Font.GothamMedium,
      Text = self.i18n and self.i18n:T("ui.hud.fps", { v = 0 }) or "FPS 0",
      TextSize = L.FONT_MONO or 13,
      TextColor3 = tk.text,
    }, self.bar.obj)
    self.labels.uptime = self.backend:Create("TextLabel", {
      Name = "Uptime", LayoutOrder = 3,
      BackgroundTransparency = 1,
      Size = UDim2.new(0, 110, 1, 0),
      Font = Enum.Font.GothamMedium,
      Text = self:_uptimeText(),
      TextSize = L.FONT_MONO or 13,
      TextColor3 = tk.textDim,
    }, self.bar.obj)
    self.labels.adapter = self.backend:Create("TextLabel", {
      Name = "Adapter", LayoutOrder = 4,
      BackgroundTransparency = 1,
      Size = UDim2.new(0, 130, 1, 0),
      Font = Enum.Font.GothamMedium,
      Text = "Adapter: ok",
      TextSize = L.FONT_MONO or 13,
      TextColor3 = tk.textDim,
    }, self.bar.obj)

    -- แผงย่อ (ไดอักนอสติกย่อ §8.3 — ซ่อนไว้ กดแถบเพื่อเปิด)
    self.mini = self.backend:Create("Frame", {
      Name = "Mini",
      AnchorPoint = UDim2.new(0.5, 0, 1, 0),
      Position = UDim2.new(0.5, 0, 0, 52),
      Size = UDim2.new(1, 0, 0, 118),
      BackgroundColor3 = tk.card,
      BackgroundTransparency = glass,
      Visible = false,
    }, self.bar.obj)
    self.backend:Create("UICorner", { CornerRadius = UDim.new(0, L.RADIUS or 10) }, self.mini.obj)
    self.labels.miniRegistry = self.backend:Create("TextLabel", {
      Name = "MiniRegistry", LayoutOrder = 1,
      BackgroundTransparency = 1,
      Position = UDim2.new(0, 12, 0, 10),
      Size = UDim2.new(1, -24, 0, L.LINE_H or 20),
      Font = Enum.Font.Gotham,
      Text = "-", TextSize = L.FONT_MONO or 13, TextColor3 = tk.text,
      TextXAlignment = Enum.TextXAlignment.Left,
    }, self.mini.obj)
    self.labels.miniBus = self.backend:Create("TextLabel", {
      Name = "MiniBus", LayoutOrder = 2,
      BackgroundTransparency = 1,
      Position = UDim2.new(0, 12, 0, 34),
      Size = UDim2.new(1, -24, 0, L.LINE_H or 20),
      Font = Enum.Font.Gotham,
      Text = "-", TextSize = L.FONT_MONO or 13, TextColor3 = tk.text,
      TextXAlignment = Enum.TextXAlignment.Left,
    }, self.mini.obj)
    self.labels.miniAdapter = self.backend:Create("TextLabel", {
      Name = "MiniAdapter", LayoutOrder = 3,
      BackgroundTransparency = 1,
      Position = UDim2.new(0, 12, 0, 58),
      Size = UDim2.new(1, -24, 0, L.LINE_H or 20),
      Font = Enum.Font.Gotham,
      Text = "-", TextSize = L.FONT_MONO or 13, TextColor3 = tk.text,
      TextXAlignment = Enum.TextXAlignment.Left,
    }, self.mini.obj)
    self.labels.miniHint = self.backend:Create("TextLabel", {
      Name = "MiniHint", LayoutOrder = 4,
      BackgroundTransparency = 1,
      Position = UDim2.new(0, 12, 0, 88),
      Size = UDim2.new(1, -24, 0, L.LINE_H or 20),
      Font = Enum.Font.Gotham,
      Text = self.i18n and self.i18n:T("ui.hud.mini.fullhint") or "-",
      TextSize = L.FONT_SIZE or 14, TextColor3 = tk.hilite,
      TextXAlignment = Enum.TextXAlignment.Left,
    }, self.mini.obj)

    -- แตะแถบ = สลับแผงย่อ / ลากที่แถบ = ย้ายตำแหน่ง (§5.4 ลากย้ายได้)
    self.backend:OnClick(self.bar, function()
      self.miniVisible = not self.miniVisible
      if self.mini and self.mini.obj then
        self.mini.obj.Visible = self.miniVisible
      end
      if self.miniVisible then
        self:RefreshMini() -- เปิด moment นี้เลย ไม่รอรอบ 0.25 วิ
      end
    end)
    self.drag = self.backend:MakeDraggable(self.bar, self.bar)

    -- สมัครรับ event (declared dep: EventBus)
    self.bus:On("adapter:health", function(p)
      self.lastAdapter = p
      self:RefreshAdapterDot()
    end)
    self.bus:On("i18n:changed", function()
      self:RerenderTexts()
    end)

    -- frame task ของ node นี้ (owner = "HUD") — วัด FPS + uptime + อัปเดตป้าย 4 ครั้ง/วิ
    self.runtime.Spawn("hud:frame", function(ctx)
      local clock = self.clock
      while true do
        if not ctx.ShouldRun() then return end
        local t0 = clock()
        ctx.Wait() -- ≈ 1 เฟรม (VT: 0.03 วิ / production: ~1/60 วิ)
        local dt = clock() - t0
        if dt > 0 then
          local instFps = 1 / dt
          if self.fpsEMA == nil then
            self.fpsEMA = instFps
          else
            self.fpsEMA = self.fpsEMA * 0.85 + instFps * 0.15
          end
          self.uptime = self.uptime + dt
        end
        self.updateAcc = self.updateAcc + dt
        if self.updateAcc >= 0.25 then
          self.updateAcc = 0
          -- ต้นทุน UI render ต่อเฟรม → timer "ui" ของ Diagnostics (DoD §5.4)
          if self.diag then self.diag:Begin("ui") end
          self:Update()
          if self.diag then self.diag:End("ui") end
        end
      end
    end)

    -- ต่อ FPS เข้า Diagnostics (§8.4 "FPS จริง" — แสดงใน Snapshot/Export)
    if self.diag then
      self.diag:SetFpsProvider(function()
        if self.fpsEMA == nil then return nil end
        return math.floor(self.fpsEMA + 0.5)
      end)
    end
  end)
  self.built = true
  return true
end

-- ---- อัปเดตป้าย (เบา — เรียก 4 ครั้ง/วิ จาก frame task) ----------------------

function HUD:Update()
  if not self.built then return end
  local fps = self.fpsEMA and math.floor(self.fpsEMA + 0.5) or 0
  if self.labels.fps and self.labels.fps.obj then
    self.labels.fps.obj.Text = self.i18n
      and self.i18n:T("ui.hud.fps", { v = fps }) or ("FPS " .. fps)
  end
  if self.labels.uptime and self.labels.uptime.obj then
    self.labels.uptime.obj.Text = self:_uptimeText()
  end
  if self.miniVisible then
    self:RefreshMini()
  end
end

--- จุด adapter ตามสถานะล่าสุด (ok=เขียว/degraded=เหลือง/dead=แดง §8.1)
function HUD:RefreshAdapterDot()
  local status = self.lastAdapter and self.lastAdapter.status or "ok"
  if self.dots.adapter and self.dots.adapter.obj then
    self.dots.adapter.obj.BackgroundColor3 = self:_statusColor(status)
  end
  if self.labels.adapter and self.labels.adapter.obj and self.i18n then
    local name = self.i18n:T("ui.hud.dot.adapter")
    self.labels.adapter.obj.Text = ("%s: %s"):format(name, status)
  end
end

--- แผงย่อ: ตัวเลขสดจาก Diagnostics + Event Bus (หนัก — เรียกเฉพาะตอนเปิด)
function HUD:RefreshMini()
  if not self.built or not self.miniVisible then return end
  local snap = self.diag and self.diag:Snapshot() or nil
  local busStats = self.bus and self.bus:Stats() or { perSec = 0, queued = 0 }
  if self.labels.miniRegistry and self.labels.miniRegistry.obj and snap then
    local r = snap.registry or { tasks = 0, connections = 0, renders = 0, temps = 0 }
    self.labels.miniRegistry.obj.Text = self.i18n and self.i18n:T("ui.hud.mini.registry", {
      t = r.tasks, c = r.connections, r = r.renders, tp = r.temps,
    }) or "-"
  end
  if self.labels.miniBus and self.labels.miniBus.obj then
    self.labels.miniBus.obj.Text = self.i18n and self.i18n:T("ui.hud.mini.bus", {
      eps = busStats.perSec or 0, q = busStats.queued or 0,
    }) or "-"
  end
  if self.labels.miniAdapter and self.labels.miniAdapter.obj then
    local status = self.lastAdapter and self.lastAdapter.status or "ok"
    self.labels.miniAdapter.obj.Text = self.i18n
      and self.i18n:T("ui.hud.mini.adapter", { status = status }) or "-"
  end
end

--- แปลป้ายทั้งหมดใหม่ (เปลี่ยนภาษา — DoD ห้ามข้อความค้างภาษาเดิม)
function HUD:RerenderTexts()
  if not self.built then return end
  self:Update()
  self:RefreshAdapterDot()
  if self.labels.miniHint and self.labels.miniHint.obj and self.i18n then
    self.labels.miniHint.obj.Text = self.i18n:T("ui.hud.mini.fullhint")
  end
  if self.miniVisible then
    self:RefreshMini()
  end
end

-- ---- theme -----------------------------------------------------------------

function HUD:ApplyTheme(tokens)
  self.tokens = tokens
  if not self.built then return self end
  local L = tokens.layout or {}
  if self.bar and self.bar.obj then
    self.bar.obj.BackgroundColor3 = tokens.card
  end
  if self.mini and self.mini.obj then
    self.mini.obj.BackgroundColor3 = tokens.card
  end
  for _, key in ipairs({ "fps" }) do
    if self.labels[key] and self.labels[key].obj then
      self.labels[key].obj.TextColor3 = tokens.text
    end
  end
  if self.labels.uptime and self.labels.uptime.obj then
    self.labels.uptime.obj.TextColor3 = tokens.textDim
  end
  self:RefreshAdapterDot()
  return self
end

-- ---- สถานะ / ปิด ------------------------------------------------------------

function HUD:Stats()
  return {
    built = self.built,
    fps = self.fpsEMA and math.floor(self.fpsEMA + 0.5) or nil,
    uptimeSec = self.uptime,
    miniVisible = self.miniVisible,
  }
end

function HUD:Shutdown()
  -- ถอน fps provider ก่อน (Diagnostics จะได้ไม่ชี้มาที่เราหลังปิด)
  if self.diag then
    self.diag:SetFpsProvider(nil)
  end
  if self.runtime and self.runtime.Release then
    self.runtime.Release(HUD.NODE)
  end
  self.built = false
  self.labels = {}
  self.dots = {}
  return true
end

return HUD

  end)();
  __TV_PACKAGES['ui_hud'] = __m;
end
-- ==== package: ui_notify (core/ui/notify.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/ui/notify.lua
-- Notification (เฟส 1 UI Framework — แผน freeze v2.1 §8.2 + §3.5 + §5.4)
--
-- node L6 ตาม dependency graph: Notification | แจ้งเตือนภาษาไทย
-- (No Silent Degradation) | deps: EventBus, I18nService
--
--   ฟัง "notify:user" จาก Event Bus (payload { level, key, params } หรือ
--   { level, text }) → toast 4 อันล่าสุด + TTL 5 วิ + แตะปิดได้
--   สีตาม level: info/hilite · success/on · warn/warn · error/danger (§8.1)
--   เปลี่ยนภาษา → แปล toast ที่ยังเปิดอยู่ใหม่ทั้งหมด (DoD: ห้ามข้อความ
--   ค้างภาษาเดิม)
--
--   UI ไม่ available (ไม่มี gui root): ยังรับ event และพิมพ์ plain text
--   ตามแบบ §3.2 ข้อ 0 — ไม่เงียบ (§3.9 #5)
--
-- กฎ resource: ทุก instance/connection/task สร้างภายใต้ Scope("Notification")
-- เสมอ — รวมที่ตอน bus dispatch (Push ต้องเปิด Scope เอง) และการปิด
-- toast รายตัวปล่อย handle ทุกตัวของ toast นั้น (พ่อถูกทำลาย cascade
-- ลูกในเกมจริง แต่ handle ของลูกต้องคืนระบบเอง — ไม่งั้นนับเป็น orphan)
-- ============================================================================

local Notification = {}
Notification.__index = Notification

Notification.NODE = "Notification"
Notification.VERSION = "0.1.0"

Notification.MAX_TOASTS = 4   -- เกิน = ปิดอันเก่าสุดทันที (บันทึกใน stats)
Notification.TTL = 5          -- วินาที แล้วหายเอง
Notification.WIDTH = 280
Notification.HEIGHT = 48      -- ≥ 44 (ความสูงปุ่มมาตรฐาน — คลิกปิดได้)

Notification.LEVELS = { info = true, success = true, warn = true, error = true }

-- i18n keys ของ node นี้ (เจ้าของ key เอง — ตามแบบ i18n.lua)
Notification.I18N = {
  th = {
    ["ui.notify.plain.prefix"] = "แจ้งเตือน",
  },
  en = {
    ["ui.notify.plain.prefix"] = "Notice",
  },
}

function Notification.new(ctx)
  ctx = ctx or {}
  local self = setmetatable({
    runtime = ctx.runtime,
    backend = ctx.backend,
    bus = ctx.bus,        -- EventBus (declared dep)
    i18n = ctx.i18n,      -- I18nService (declared dep)
    tokens = ctx.tokens,
    toasts = {},          -- ลำดับจากเก่า → ใหม่
    gui = nil,
    holder = nil,
    built = false,
    stats = { total = 0, droppedOldest = 0, plainText = 0 },
  }, Notification)
  if self.i18n then
    self.i18n:AddTable("th", Notification.I18N.th)
    self.i18n:AddTable("en", Notification.I18N.en)
  end
  return self
end

-- ---- helpers -------------------------------------------------------------------

--- ข้อความของ payload (key → แปลผ่าน i18n / text → ตรง ๆ / ไม่มี = หลุดโปร่งใส)
function Notification:TextOf(p)
  if p == nil then return "(no payload)" end
  if type(p.text) == "string" then return p.text end
  if type(p.key) == "string" and self.i18n then
    return self.i18n:T(p.key, p.params)
  end
  return "(no text)"
end

--- สีของ level จาก token ปัจจุบัน
function Notification:LevelColor(level)
  local t = self.tokens
  if t and t.toastColor and t.toastColor[level] then
    return t.toastColor[level]
  end
  return nil, "ยังไม่มี theme token"
end

-- ---- สร้าง UI ครั้งเดียว -------------------------------------------------------

function Notification:Render()
  -- 1) subscribe ก่อนเสมอ — แม้ไม่มี GUI (degraded) เพราะการแจ้งเตือน
  --    ห้ามหายเงียบ ๆ (§3.9 #5): event ที่มาถึงตอนไม่มี UI จะถูกพิมพ์เป็น
  --    plain text ตามแบบ §3.2 ข้อ 0
  if not self.subscribed then
    local R = self.runtime
    R.Scope(Notification.NODE, function()
      self.bus:On("notify:user", function(p)
        self:Push(p)
      end)
      self.bus:On("i18n:changed", function()
        self:Retranslate()
      end)
    end)
    self.subscribed = true
  end

  if not self.backend.available then
    return false, self.backend.reason
  end
  if self.built then return true end
  local R = self.runtime
  R.Scope(Notification.NODE, function()
    local tk = self.tokens
    self.gui = self.backend:Create("ScreenGui", {
      Name = "TVNotify",
      DisplayOrder = 90,
      ResetOnSpawn = false,
    })
    self.holder = self.backend:Create("Frame", {
      Name = "Holder",
      AnchorPoint = UDim2.new(1, 0, 0, 0),
      Position = UDim2.new(1, -16, 0, 20),
      Size = UDim2.new(0, Notification.WIDTH, 1, -40),
      BackgroundTransparency = 1,
    }, self.gui.obj)
    self.backend:Create("UIListLayout", {
      Name = "List",
      Padding = UDim.new(0, 8),
      SortOrder = Enum.SortOrder.LayoutOrder,
      HorizontalAlignment = Enum.HorizontalAlignment.Right,
    }, self.holder.obj)
  end)
  self.built = true
  return true
end

-- ---- รับการแจ้งเตือน -----------------------------------------------------------

--- push ตรง (ใช้ในเทส/อนาคต) — รูปเดียวกับ event บน bus
function Notification:Push(p)
  p = p or {}
  local level = Notification.LEVELS[p.level] and p.level or "info"
  self.stats.total = self.stats.total + 1

  if not self.built then
    -- UI ไม่มี — plain text ตามแบบ §3.2 ข้อ 0 (ไม่เงียบ §3.9 #5)
    self.stats.plainText = self.stats.plainText + 1
    local prefix = self.i18n and self.i18n:T("ui.notify.plain.prefix") or "Notice"
    print(("[The Voider][%s] %s"):format(prefix, self:TextOf(p)))
    return false, "UI unavailable"
  end

  -- เกินโควต้า → ปิดอันเก่าสุดทันที
  while #self.toasts >= Notification.MAX_TOASTS do
    self:Dismiss(self.toasts[1])
    self.stats.droppedOldest = self.stats.droppedOldest + 1
  end

  local R = self.runtime
  R.Scope(Notification.NODE, function()
    local tk = self.tokens
    local tkLayout = tk and tk.layout or { PAD = 12, RADIUS = 10, STROKE = 1 }
    local glass = tk and (1 - tk.glass.CARD_ALPHA) or 0.88

    local entry = {
      level = level,
      key = type(p.key) == "string" and p.key or nil,
      params = type(p.params) == "table" and p.params or nil,
      text = type(p.text) == "string" and p.text or nil,
      handles = {},
      alive = { true },
    }
    local text = self:TextOf(p)

    -- ปุ่มทั้ง toast (คลิก = ปิด) — สูง 48 ≥ 44 (ปุ่มมาตรฐาน — CR-PC-ONLY: เดิมอ้าง gate ทัช §5.4)
    local btn = self.backend:Create("TextButton", {
      Name = "Toast",
      Size = UDim2.new(1, 0, 0, Notification.HEIGHT),
      BackgroundColor3 = tk and tk.card or nil,
      BackgroundTransparency = glass,
      Text = "",
      AutoButtonColor = false,
      LayoutOrder = #self.toasts + 1,
    }, self.holder.obj)
    entry.handles[#entry.handles + 1] = btn

    local bar = self.backend:Create("Frame", {
      Name = "LevelBar",
      BackgroundColor3 = self:LevelColor(level),
      BorderSizePixel = 0,
      Position = UDim2.new(0, 0, 0, 0),
      Size = UDim2.new(0, 4, 1, 0),
    }, btn.obj)
    entry.handles[#entry.handles + 1] = bar

    local label = self.backend:Create("TextLabel", {
      Name = "Text",
      BackgroundTransparency = 1,
      Position = UDim2.new(0, 14, 0, 0),
      Size = UDim2.new(1, -22, 1, 0),
      Font = Enum.Font.Gotham,
      Text = text,
      TextSize = tkLayout.FONT_SIZE or 14,
      TextColor3 = tk and tk.text or nil,
      TextWrapped = true,
      TextXAlignment = Enum.TextXAlignment.Left,
      TextYAlignment = Enum.TextYAlignment.Center,
    }, btn.obj)
    entry.handles[#entry.handles + 1] = label
    entry.label = label -- หยิบป้ายแบบเจาะจง (handles ยาวไม่คงที่)

    -- ตกแต่ง + connection เก็บ handle ด้วย: การปิด toast รายตัวต้องคืน
    -- "ทุก" resource ของ toast นั้น — ลูกถูกทำลาย cascade ไปกับพ่อในเกม
    -- จริง แต่ handle ใน Registry ต้องคืนเอง ไม่งั้นนับเป็น orphan สะสม
    entry.handles[#entry.handles + 1] = self.backend:Create("UICorner",
      { CornerRadius = UDim.new(0, tkLayout.RADIUS or 10) }, btn.obj)
    entry.handles[#entry.handles + 1] = self.backend:Create("UIStroke", {
      Color = tk and tk.border or nil,
      Thickness = tkLayout.STROKE or 1,
      Transparency = 0.35,
    }, btn.obj)

    local clickConn = self.backend:OnClick(btn, function()
      self:Dismiss(entry)
    end)
    if clickConn then
      entry.handles[#entry.handles + 1] = clickConn
    end

    -- โผล่เข้ามาแบบนุ่ม 0.15 วิ (§8.2) — task จบเอง = deregister เอง
    self.backend:Fade(btn, "BackgroundTransparency", glass, math.min(1, glass + 0.35), tk and tk.anim.FAST or 0.15)

    -- TTL: หายเองเมื่อครบเวลา (task ชั่วคราว — ยกเลิกได้ทั้งจากการปิดเอง
    -- และจาก Registry:Release ตอน TEARDOWN)
    local alive = entry.alive
    self.runtime.Spawn("toast:ttl", function(ctx)
      ctx.Wait(Notification.TTL)
      if not ctx.ShouldRun() then return end
      if not alive[1] then return end
      self:Dismiss(entry)
    end)

    table.insert(self.toasts, entry)
  end)
  return true
end

--- ปิด toast รายตัว — ปล่อย handle ทุกตัวของ entry (กัน orphan จาก cascade)
function Notification:Dismiss(entry)
  if not entry or not entry.alive then return false end
  entry.alive[1] = false
  for i = #self.toasts, 1, -1 do
    if self.toasts[i] == entry then
      table.remove(self.toasts, i)
    end
  end
  for _, h in ipairs(entry.handles) do
    if h and h.Release then h.Release() end
  end
  entry.handles = {}
  return true
end

--- แปล toast ที่ยังเปิดอยู่ใหม่ทั้งหมด (เปลี่ยนภาษา — DoD ห้ามค้างภาษาเดิม)
function Notification:Retranslate()
  for _, entry in ipairs(self.toasts) do
    local label = entry.label
    if label and label.obj and entry.key then
      label.obj.Text = self:TextOf({ key = entry.key, params = entry.params })
    end
  end
end

-- ---- theme -----------------------------------------------------------------

function Notification:ApplyTheme(tokens)
  self.tokens = tokens
  if not self.built then return self end
  for _, entry in ipairs(self.toasts) do
    local btn = entry.handles[1]
    local bar = entry.handles[2]
    local label = entry.label
    if btn and btn.obj then
      btn.obj.BackgroundColor3 = tokens.card
    end
    if bar and bar.obj then
      bar.obj.BackgroundColor3 = self:LevelColor(entry.level)
    end
    if label and label.obj then
      label.obj.TextColor3 = tokens.text
    end
  end
  return self
end

-- ---- สถานะ / ปิด ------------------------------------------------------------

function Notification:Stats()
  return {
    active = #self.toasts,
    total = self.stats.total,
    droppedOldest = self.stats.droppedOldest,
    plainText = self.stats.plainText,
    built = self.built,
  }
end

--- ปิด node (TEARDOWN) — Registry คืน resource ทั้งหมดของ owner นี้
--- (render/connection/temp รวม ttl task) แล้วล้างสถานะ
function Notification:Shutdown()
  if self.runtime and self.runtime.Release then
    self.runtime.Release(Notification.NODE)
  end
  for _, e in ipairs(self.toasts) do
    if e.alive then e.alive[1] = false end
  end
  self.toasts = {}
  self.built = false
  return true
end

return Notification

  end)();
  __TV_PACKAGES['ui_notify'] = __m;
end
-- ==== package: ui (core/ui/init.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/ui/init.lua
-- UI Layer assembler (เฟส 1 — แผน freeze v2.1 §3.8 + §3.10)
--
-- ประกอบ L6 ทั้งหมดตามลำดับ dependency graph:
--   ThemeEngine → Hub → HUD → Notification
--
-- [CR-PC-ONLY 1 ต.ค. 2026] node MobileLayout ถูกตัดออกจาก graph
--   (dependencies.md v1.6: 39→38 node) — PC/Desktop only บน Volt —
--   อุปกรณ์ทัชอย่างเดียวก็ได้เลย์เอาต์ desktop เดิม (PC-only guard
--   ใน qa/l1_unit/test_ui.lua กันถอยหลัง)
--
-- SSOT enforcement (§3.10): ตรวจว่าชื่อ node ที่ layer นี้ดูแลอยู่ใน
-- Graph.initOrder ครบทุกตัว — ไม่ตรง = error ทันที (แบบเดียวกับ
-- foundation/adapter)
--
-- จุดต่อของชั้นนี้ (composition root — วิธีเดียวกับ foundation/init.lua
-- ที่ถือ service ทั้งชุดแล้วส่งต่อ):
--   Backend    root จาก ctx.guiRoot หรือ gethui() — ไม่มี = graceful
--              disable + แจ้ง plain text (§3.2 ข้อ 0 pattern)
--   ThemeEngine ถูกอ่าน/สั่งเฉพาะที่นี่ — node อื่นรับ "token" และ
--              callback จาก assembler (ไม่ต้องเพิ่ม edge ใน graph)
--              เปลี่ยน accent = SetAccent + เขียน config + fanout
--              ApplyTheme ให้ทุก node ตามลำดับ graph
--   i18n       Hub/Notification = declared dep ตรง; HUD รับ F.I18n ตามแบบ
--              probe.lua (แปลป้าย); ข้อมูลแผง Diagnostics ผ่าน Direct
--              Service "Diagnostics" (ambient §3.5 — ตามแบบ bundle selftest)
--
-- ใช้งาน:
--   local U = UiLib.new({ runtime = R, foundation = F, version = "0.7.0" })
--   U:Bootstrap()   -- Render ทุก node (resource ลง Scope ของ node ตัวเอง)
--   U.Theme / U.Backend / U.Hub / U.HUD / U.Notify
--   -- ปิดทั้งชุดผ่าน R.ShutdownAll() (hook ลงทะเบียนครบตามชื่อ node)
-- ============================================================================

local P = __TV_PACKAGES
local BackendLib = P.ui_backend
local ThemeLib = P.ui_theme
local HubLib = P.ui_hub
local HudLib = P.ui_hud
local NotifyLib = P.ui_notify

local UiLib = {}
UiLib.version = "0.1.0"

-- ชื่อ node ตาม dependency graph (SSOT §3.10) — MobileLayout ตัดออกตาม CR-PC-ONLY
UiLib.NODES = {
  "ThemeEngine",
  "Hub",
  "HUD",
  "Notification",
}

function UiLib.new(ctx)
  ctx = ctx or {}
  local R = ctx.runtime
  local F = ctx.foundation
  if not R or not R.Registry or not R.Graph or not R.Shutdown then
    error("UiLib.new({ runtime = R }): ต้องส่ง Runtime ครบ (Registry/Graph/Shutdown)", 2)
  end
  if not F or not F.Config or not F.I18n or not F.Bus
    or not F.Keybind or not F.Diag or not F.Services then
    error("UiLib.new({ foundation = F }): ต้องส่ง Foundation ครบ "
      .. "(Config/I18n/Bus/Keybind/Diag/Services)", 2)
  end

  -- ---- SSOT check: node ของ UI ต้องอยู่ใน graph ครบ ------------------------
  local inGraph = {}
  for _, n in ipairs(R.Graph.initOrder) do
    inGraph[n] = true
  end
  for _, n in ipairs(UiLib.NODES) do
    if not inGraph[n] then
      error(("UI: node %q ไม่อยู่ใน dependency graph (dependencies.md) — "
        .. "โค้ดกับ SSOT คลาดเคลื่อน แก้ที่ dependencies.md ก่อน (§3.10)"):format(n), 2)
    end
  end

  local U = {}
  U.version = UiLib.version
  U.runtime = R
  U.foundation = F

  local logger = ctx.logger or function(level, msg)
    local w = (level == "warn" or level == "error")
      and (type(warn) == "function" and warn or print)
      or print
    w(("[The Voider][UI][%s] %s"):format(level, msg))
  end

  -- 1) Backend — root resolution (gethui ของ executor / ctx.guiRoot ของเทส)
  U.Backend = BackendLib.new({
    runtime = R,
    guiRoot = ctx.guiRoot,
    logger = logger,
    clock = ctx.clock,
  })

  -- 2) ThemeEngine + accent จาก config (§3.7 ของผู้ใช้ — ห้ามทิ้ง)
  U.Theme = ThemeLib.new()
  do
    local saved = F.Config:Get("ui.accent")
    if type(saved) == "string" and #saved > 0 then
      local ok = U.Theme:SetAccent(saved)
      if not ok then
        -- ค่าเก่าไม่รองรับ (เช่น config จากอนาคต) — กลับ default + แจ้ง + เขียนกลับ
        logger("warn", ("accent %q ใน config ไม่รองรับ — ใช้ %s แทน")
          :format(saved, U.Theme:Accent()))
        F.Config:Set("ui.accent", U.Theme:Accent(), { save = true })
      end
    end
  end

  -- รายการ node ที่ได้รับ ApplyTheme (fanout ตามลำดับ graph)
  local themeConsumers = {}

  -- เปลี่ยน accent ผ่านจุดเดียว: theme + config + fanout ทุก node
  local function setAccent(name)
    local ok, err = U.Theme:SetAccent(name)
    if not ok then
      return false, err
    end
    F.Config:Set("ui.accent", name, { save = true })
    local tokens = U.Theme:Get()
    for _, node in ipairs(themeConsumers) do
      if node and node.ApplyTheme then
        node:ApplyTheme(tokens)
      end
    end
    return true
  end

  -- 3) สร้าง node ตามลำดับ graph (ThemeEngine แล้ว → Hub ต้องการ token)
  local tokens = U.Theme:Get()

  U.Hub = HubLib.new({
    runtime = R,
    backend = U.Backend,
    config = F.Config,
    i18n = F.I18n,
    services = F.Services,
    tokens = tokens,
    clock = ctx.clock,
    version = ctx.version,
    accents = U.Theme:ListAccents(),
    accent = U.Theme:Accent(),
    setAccent = setAccent,
  })

  U.HUD = HudLib.new({
    runtime = R,
    backend = U.Backend,
    bus = F.Bus,
    diag = F.Diag,
    i18n = F.I18n,
    tokens = tokens,
    clock = ctx.clock,
  })

  U.Notify = NotifyLib.new({
    runtime = R,
    backend = U.Backend,
    bus = F.Bus,
    i18n = F.I18n,
    tokens = tokens,
  })

  themeConsumers = { U.Hub, U.HUD, U.Notify }

  -- 4) (ถอดออกภายหลังการตรวจสอบ) เดิมวาง subscriber i18n:changed ระดับชั้น
  --    ไว้ใต้ Scope("EventBus") — ผิดหลัก orphan ราย node (§3.10): ทรัพยากร
  --    จะตกเป็นของ "EventBus" แล้ว row นั้นเห็น orphan > 0 ตอน TEARDOWN
  --    ทางที่ถูกตาม graph: Notification/HUD ฟัง i18n:changed เองใน Scope ของ
  --    ตัวเอง (ทั้งคู่มี EventBus เป็น declared dep) ส่วน Hub ไม่มี bus เป็น
  --    dep — Hub เป็นผู้กดปุ่มเปลี่ยนภาษาเอง จึงเรียก RerenderTexts เองหลัง Set

  -- 5) Shutdown hooks ตามชื่อ node (TEARDOWN = Init กลับด้าน §3.10)
  -- ThemeEngine: pure (ไม่ถือ resource) — ไม่มี hook (Shutdown ข้ามให้เอง)
  R.Shutdown:Register("Hub", {
    Destroy = function() U.Hub:Shutdown() end,
  })
  R.Shutdown:Register("HUD", {
    Destroy = function() U.HUD:Shutdown() end,
  })
  R.Shutdown:Register("Notification", {
    Destroy = function() U.Notify:Shutdown() end,
  })

  -- 6) Bootstrap — Notification subscribe เสมอ (แม้ degraded — ห้ามเงียบ
  --    §3.9 #5) ส่วน node ที่ต้องมี GUI เรนเดอร์เฉพาะเมื่อ backend พร้อม
  --    (คืน false+reason — ผู้ใช้ถูกแจ้งจาก Backend แล้ว)
  function U:Bootstrap()
    U.Notify:Render()
    if not U.Backend.available then
      return U
    end
    U.Hub:Render()
    U.HUD:Render()
    -- สำหรับเฟส 2+: โมดูลต่าง ๆ จะ Render เนื้อหาในแท็บของตัวเองผ่าน
    -- U.Hub ตอนนี้ (ยังไม่มี L5 ในเฟส 1)
    return U
  end

  return U
end

return UiLib

  end)();
  __TV_PACKAGES['ui'] = __m;
end
-- ==== package: bundle (core/runtime/bundle.lua) ====
do
  local __m = (function()
-- ============================================================================
-- The Voider — core/runtime/bundle.lua
-- System Bundle Entry — จุดเข้าเดียวของ "the-voider.lua" ที่ build ประกอบ
-- (แผน freeze v2.1 §3.8: ตัวส่งมอบจริงคือไฟล์เดียว ประกอบโดย build)
--
-- เมื่อ loader รัน bundle (loadstring → exec) → execFn() เรียก Bundle.Entry:
--   สร้าง Runtime → Foundation → Adapter ตาม dependency graph → Bootstrap
--   → อ่าน __TV_BUNDLE_RUN (source+manifest ที่ loader เก็บไว้ก่อน execute)
--   → host:register({system, source, manifest}) ให้ update orchestrator จัดการ
--
-- สัญญา system handle (สิ่งที่ update.lua ต้องการ — ทั้งหมดคือ interface
-- สาธารณะเดิมของ Runtime/Foundation/Adapter ไม่มีการแตะภายใน):
--   {
--     version, releaseId,
--     runtime, foundation, adapter,
--     bus, config, migration, shutdown, registry, boundary, watchdog, diag,
--     probe,           -- AdapterSelfProbe object: :Probe() / :LastReport()
--     providers,        -- ลำดับ { {name, Serialize(sys), Apply(sys, oldState)} }
--     selfChecks,       -- ลำดับ { {name, fn(sys, ctx) → (ok, detail)} }
--   }
--
-- state providers (moduleStates ของ Rollback Snapshot §3.6):
--   เฟส 0 ยังไม่มี feature module → production bundle ส่ง providers = {}
--   (ไม่สร้างล่วงหน้า — กลไกถูกพิสูจน์ด้วย fixture ใน L2 เท่านั้น)
--   โมดูลจริงจะมาหลัง Behavioral Matrix ผ่านรีวิว (กติกา §4.5)
--
-- SELFCHECK ชุดย่อยของแต่ละระบบ (§3.6 ขั้น 12: watchdog heartbeat + version
-- report + L1 self-test ชุดย่อ) ติดตั้งเป็น default — release ใดจะเพิ่ม
-- check ของตัวเองก็ได้ (selfChecks ใน spec ต่อท้าย)
-- ============================================================================

local P = __TV_PACKAGES
local RuntimeLib = P.init
local FoundationLib = P.foundation
local AdapterLib = P.adapter
local UiLib = P.ui
local JsonLib = P.json

local Bundle = {}

Bundle.VERSION = "0.3.0"

-- ---- default selfChecks (ติดตั้งทุกระบบ) -------------------------------------

local function defaultSelfChecks(sys, spec)
  local ConfigLib = P.config
  local checks = {}

  checks[#checks + 1] = {
    name = "bus-active",
    fn = function(s)
      local stats = s.bus:Stats()
      if stats.frozen then return false, "bus ยัง frozen อยู่ (RESUME ไม่สำเร็จ?)" end
      return true, nil
    end,
  }

  checks[#checks + 1] = {
    name = "bus-generation",
    fn = function(s, ctx)
      if not ctx or not ctx.generation then return true, "ไม่มี generation เป้าหมาย — ข้าม" end
      local gen = s.bus:Stats().generation
      if gen ~= ctx.generation then
        return false, ("generation ไม่ตรง (อยากได้ %d ได้ %d)"):format(ctx.generation, gen)
      end
      return true, nil
    end,
  }

  checks[#checks + 1] = {
    name = "config-schema",
    fn = function(s)
      local v = s.config:Get("schemaVersion")
      local want = ConfigLib and ConfigLib.CURRENT_SCHEMA_VERSION or 2
      if v ~= want then
        return false, ("schemaVersion = %s ไม่ตรงปัจจุบัน (%s)"):format(tostring(v), tostring(want))
      end
      return true, nil
    end,
  }

  checks[#checks + 1] = {
    name = "diag-sampling",
    fn = function(s)
      local n = s.diag:SampleCount()
      if not n or n < 1 then return false, "Diagnostics ยังไม่ sampling เลย" end
      return true, nil
    end,
  }

  checks[#checks + 1] = {
    name = "probe-ran",
    fn = function(s)
      local r = s.probe:LastReport()
      if not r then return false, "Adapter Self-Probe ยังไม่เคยรัน" end
      return true, nil
    end,
  }

  checks[#checks + 1] = {
    name = "watchdog-heartbeat",
    fn = function(s, ctx)
      -- ทุก entry ที่ลงทะเบียนต้องหายใจใหม่พอ (เฟส 0 มักไม่มี entry = ผ่านตามจริง)
      local now = os.clock()
      for owner, e in pairs(s.watchdog.entries or {}) do
        local threshold = (e.period or 1) * (e.stallFactor or 3)
        if now - (e.lastBeat or 0) > threshold then
          return false, ("watchdog: %s เงียบเกิน threshold"):format(tostring(owner))
        end
      end
      return true, nil
    end,
  }

  checks[#checks + 1] = {
    name = "version-report",
    fn = function(s, ctx)
      if ctx and ctx.manifest and ctx.manifest.version then
        if s.version ~= ctx.manifest.version then
          return false, ("version ของระบบ (%s) ไม่ตรง manifest (%s)")
            :format(s.version, ctx.manifest.version)
        end
      end
      return true, s.version
    end,
  }

  checks[#checks + 1] = {
    name = "selftest-mini",
    fn = function(s)
      -- L1 self-test ชุดย่อ 3 ข้อ (จริง รันบนระบบตัวเอง):
      local enc = JsonLib.encode({ ok = 1, list = { 2, 3 } })
      local dec = JsonLib.decode(enc)
      if dec.ok ~= 1 or dec.list[2] ~= 3 then
        return false, "json roundtrip ไม่ผ่าน"
      end
      local hit = {}
      s.runtime.Scope("SelfTestMini", function()
        s.bus:On("selftest:ping", function(p) hit[#hit + 1] = p end)
      end)
      s.bus:Declare("selftest:ping", "idempotent")
      s.bus:Publish("selftest:ping", { n = 1 })
      if #hit ~= 1 then
        return false, "bus pub/sub ไม่ผ่าน"
      end
      local t = s.foundation.Services:MustGet("I18n").T("notify.adapter.dead", { name = "probe" })
      if type(t) ~= "string" or #t == 0 then
        return false, "i18n แปลไม่ได้"
      end
      return true, "json+bus+i18n ผ่าน"
    end,
  }

  return checks
end

-- ---- Build ---------------------------------------------------------------------

-- spec = {
--   version, releaseId,        [บังคับ]
--   runtime = {...},           -- ส่งต่อให้ RuntimeLib.new (clock/task/drawing/instance/debug)
--   env = {...},               -- ส่งต่อให้ AdapterLib (nil = เกมจริงตาม adapter เดิม)
--   guiRoot = <instance>,      -- ส่งต่อให้ UI (nil = gethui ของ executor / ไม่มี = graceful)
--   providers = {...},         -- state providers เพิ่มเติม (production เฟส 0 = {})
--   selfChecks = {...},        -- เพิ่มหลัง default
--   onAssembly = fn(sys),      -- hook หลังประกอบ+boot เสร็จ (ใช้ใน fixture เท่านั้น)
--   boot = true|false,         -- false = ไม่ boot (ส่งต่อให้ผู้เรียกเรียก sys:boot() เอง)
-- }
function Bundle.Build(spec)
  spec = spec or {}
  if type(spec.version) ~= "string" or #spec.version == 0 then
    error("Bundle.Build: spec.version ต้องเป็น string ไม่ว่าง", 2)
  end
  if type(spec.releaseId) ~= "string" or #spec.releaseId == 0 then
    error("Bundle.Build: spec.releaseId ต้องเป็น string ไม่ว่าง", 2)
  end

  local sys = {}

  -- 1) Runtime (L1) ตามลำดับ graph — Bootstrap ภายใน
  local R = RuntimeLib.new(spec.runtime or {})
  R:Bootstrap()
  sys.runtime = R

  -- 2) Foundation (L2)
  local F = FoundationLib.new({ runtime = R })
  F:Bootstrap()
  sys.foundation = F

  -- 3) Game Adapter (L3) — ประตูเดียวสู่เกม (§3.3)
  local A = AdapterLib.new({
    runtime = R,
    foundation = F,
    env = spec.env,
  })
  A:Bootstrap()
  sys.adapter = A

  -- 3.5) UI (L6 เฟส 1) — หลัง adapter ตามลำดับ graph (L4/L5 ยังไม่มี
  --      ในเฟสนี้ตาม roadmap §5.2; พอมีจริงจะแทรกตามลำดับ initOrder)
  local Ui = UiLib.new({
    runtime = R,
    foundation = F,
    version = spec.version,
    guiRoot = spec.guiRoot,
    clock = (spec.runtime or {}).clock,
    env = spec.env,
  })
  Ui:Bootstrap()
  sys.ui = Ui

  -- 4) ส่วนประกอบของ update domain (handle ตามสัญญา)
  sys.version = spec.version
  sys.releaseId = spec.releaseId
  sys.bus = F.Bus
  sys.config = F.Config
  sys.migration = F.Migration
  sys.shutdown = R.Shutdown
  sys.registry = R.Registry
  sys.boundary = R.Boundary
  sys.watchdog = R.Watchdog
  sys.diag = F.Diag
  sys.probe = A.SelfProbe

  -- 5) state providers (เฟส 0 production = ไม่มี; ตัวเพิ่มจาก spec ต่อท้าย)
  sys.providers = {}
  for _, pr in ipairs(spec.providers or {}) do
    if type(pr) ~= "table" or type(pr.name) ~= "string"
      or type(pr.Serialize) ~= "function" or type(pr.Apply) ~= "function" then
      error(("Bundle.Build: provider %s ไม่ครบสัญญา (name/Serialize/Apply)"):format(tostring(pr and pr.name)), 2)
    end
    sys.providers[#sys.providers + 1] = pr
  end

  -- 6) selfChecks = default + ของ spec
  sys.selfChecks = defaultSelfChecks(sys, spec)
  for _, c in ipairs(spec.selfChecks or {}) do
    if type(c) ~= "table" or type(c.name) ~= "string" or type(c.fn) ~= "function" then
      error(("Bundle.Build: selfCheck %s ไม่ครบสัญญา (name/fn)"):format(tostring(c and c.name)), 2)
    end
    sys.selfChecks[#sys.selfChecks + 1] = c
  end

  -- 7) hook ของ fixture (หลังประกอบ+boot เสร็จ)
  if type(spec.onAssembly) == "function" then
    spec.onAssembly(sys)
  end

  return sys
end

-- ---- Entry: จุดที่ loader เรียกตอน execute bundle ------------------------------

-- host (สร้างโดย loader_main) ต้องมี host.register(record)
-- loader ตั้ง _G.__TV_BUNDLE_RUN = { source, manifest } ก่อน execute
function Bundle.Entry(host, spec)
  local sys = Bundle.Build(spec)

  local run = rawget(_G, "__TV_BUNDLE_RUN")
  if host and type(host.register) == "function" then
    host.register({
      system = sys,
      source = run and run.source or nil,
      manifest = run and run.manifest or nil,
    })
  end
  return sys
end

return Bundle

  end)();
  __TV_PACKAGES['bundle'] = __m;
end

-- ==== entry (สัญญาของ loader: _G.__TV_HOST + _G.__TV_BUNDLE_RUN) ====
local Bundle = __TV_PACKAGES.bundle
return Bundle.Entry(rawget(_G, "__TV_HOST"), {
  version = '0.7.0',
  releaseId = 'r2026-10-01-16',
})
