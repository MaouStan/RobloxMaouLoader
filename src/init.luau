-- ScriptLoader V3 - Core Init
-- Super Global Environment with Metatable

local tmp = (getgenv and getgenv()) or _G or shared or false

if not tmp then
    return warn("[ScriptLoader V3] Global environment not found")
end

------------- Anti-Reexecute -------------
local tmpGG = GG or (getgenv and getgenv().GG) or (_G and _G.GG) or (shared and shared.GG) or false

if tmpGG and tmpGG.GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Super Global Environment already loaded")
end

------------- Game Load -------------

if not game:IsLoaded() then
    game.Loaded:Wait()
end

------------- Super Global Setup ---

-- Internal storage for GG values
local GG_Internal = {}

-- Protected keys that cannot be overwritten
local ProtectedKeys = {
    GG = true,
    _G = true,
    shared = true,
    script = true,
    game = true,
    workspace = true,
    Players = true,
    Lighting = true,
}

-- Metatable for GG with __index only
local GG_Meta = {
    -- Read: Check internal storage → service loading
    __index = function(self, key)
        -- Warning if accessed on nil GG
        if not self then
            warn("[ScriptLoader V3] WARNING: __index called on nil GG")
            return nil
        end

        -- First check internal storage
        local val = GG_Internal[key]
        if val ~= nil then
            return val
        end

        -- Service auto-loading (lazy load services)
        local success, service = pcall(function()
            return game:GetService(key)
        end)
        if success and service then
            GG_Internal[key] = service
            return service
        end

        -- Warning for not found keys
        warn(`[ScriptLoader V3] GG key not found: {key}`)

        -- Key not found (no warning to avoid spam)
        return nil
    end,

    -- Tostring for debugging
    __tostring = function(self)
        return "GG<ScriptLoaderV3>"
    end,
}

-- Create GG as separate table with global access
local ggTable = {}

-- Kick if executor doesn't support getgenv/_G
if not _G and not (getgenv and getgenv()) then
    error("[ScriptLoader V3] Executor not supported: _G/getgenv unavailable")
end

-- Apply metatable to GG table
setmetatable(ggTable, GG_Meta)

------------- Core Assignment -------------

-- Store GG in _G and getgenv for global access
GG = ggTable
_G.GG = ggTable
GG.GG = ggTable  -- Self-reference
if getgenv then
    getgenv().GG = ggTable
end
if shared then
    shared.GG = ggTable
end
GG.GG_Maou_init_loaded = true

------------- OBF Fixer -------------

GG.LPH_NO_VIRTUALIZE = function(...)
    return ...
end

GG.IB_NO_VIRTUALIZE = function(...)
    return ...
end

------------- Core Function Cloning -------------

-- Executor compatibility stubs
local clonefunction = clonefunction or function(...)
    return ...
end
local cloneref = cloneref or function(...)
    return ...
end

-- Clone core functions for security
GG.cfe = clonefunction  -- cfe = clonefunction
GG.cr = cloneref        -- cr = cloneref

-- Cloned Lua globals
GG.rawgetclone = clonefunction(rawget)
GG.pcalle = clonefunction(pcall)
GG.rawsetclone = clonefunction(rawset)

------------- Roblox Datatypes (Cached) -------------

GG.Col3 = Color3
GG.BCol = BrickColor
GG.Reg3 = Region3
GG.Inst = Instance
GG.UDim2 = UDim2
GG.Fnt = Font
GG.V2 = Vector2
GG.V3 = Vector3
GG.CFr = CFrame
GG.UDim = UDim
GG.Ray = Ray
GG.Face = Face
GG.Axes = Axes
GG.ColorSequence = ColorSequence
GG.NumberSequence = NumberSequence
GG.ColorSequenceKeypoint = ColorSequenceKeypoint
GG.NumberSequenceKeypoint = NumberSequenceKeypoint
GG.Rect = Rect

-- Async/utility
GG.coru = coroutine
GG.bff = buffer

------------- Conversion Utilities -------------

GG.tostring = tostring
GG.tos = tostring
GG.tonumber = tonumber
GG.ton = tonumber

------------- Legacy Functions -------------

GG.wait = wait
GG.delay = delay
GG.spawn = spawn
GG.tick = tick

------------- Random -------------

GG.RNew = Random.new
GG.RNG = Random.new()

------------- Obfuscated GetService -------------

-- gS = getService (cloned for security)
local gS_raw = clonefunction(game.GetService)
GG.gS = function(sN: string): any
    local suc, res = GG.pcalle(gS_raw, game, sN)
    return suc and res or nil
end

------------- Metatable Functions -------------

-- getrawmetatable: Get metatable bypassing __metatable
GG.grmt = getrawmetatable or debug.getmetatable

-- setrawmetatable: Set metatable bypassing __metatable
GG.srmt = setrawmetatable or function(obj, mt)
    return rawset(obj, "__metatable", nil) and setmetatable(obj, mt)
end

-- setreadonly: Set table read-only status
GG.sro = setreadonly or function()
    return false
end

-- isreadonly: Check if table is read-only
GG.ir = isreadonly or function()
    return false
end

------------- Debug Error Handler (Global) -------------

-- Detailed pcall error handler (replaces Scripts.GetPcall)
GG.GetPcall = function(err, context: string?)
    local trace = debug.traceback("", 10)
    local line = err:match(":(%d+):") or trace:match(":(%d+):") or "?"
    local time = os.date("%H:%M:%S")
    local ctx = context or "Global"

    warn(string.format([[
    ========================================
    ScriptLoader V3 - Error Handler
    ========================================
    Context: %s
    Time   : %s
    Line   : %s
    Error  : %s
    Trace  :
    %s
    ========================================
    ]], ctx, time, line, tostring(err), trace:gsub("\n", "\n  | ")))
end

-- Safe pcall wrapper with error handler (global)
GG.safeCall = function(fn: () -> any, context: string?): ...(any)
    local success, result = GG.pcalle(fn)
    if not success then
        GG.GetPcall(result, context)
    end
    return success, result
end

------------- Remote Core Loader -------------

-- Core modules list
GG.CoreModules = {
    "task",
    "thread",
    "math",
    "table",
    "string",
    "player",
    "instance",
    "env",
    "teleport",
}

-- Base GitHub URL for raw content
GG.GitHubRaw = "https://raw.githubusercontent.com/MaouStan/RobloxMaouLoader/refs/heads/master/src/core/"

-- Load single module from URL (obfuscated: loadMod)
GG.loadMod = function(name: string, baseUrl: string?): boolean
    baseUrl = baseUrl or GG.GitHubRaw
    local url = `${baseUrl}${name}.luau`

    local success, response = GG.pcalle(function()
        return game:HttpGet(url)
    end)

    if not success or not response then
        GG.GetPcall(`Failed to fetch ${name}.luau`, "loadMod")
        return false
    end

    -- Load and execute the module
    local loadFn = loadstring(response)
    if not loadFn then
        GG.GetPcall(`Failed to loadstring ${name}.luau`, "loadMod")
        return false
    end

    local execSuccess, result = GG.pcalle(loadFn)
    if not execSuccess then
        GG.GetPcall(result, `loadMod[${name}]`)
        return false
    end

    return true
end

-- Load all core modules (obfuscated: loadAll)
GG.loadAll = function(baseUrl: string?): {string}
    baseUrl = baseUrl or GG.GitHubRaw
    local loaded = {}
    local failed = {}

    for _, moduleName in GG.CoreModules do
        if GG.loadMod(moduleName, baseUrl) then
            table.insert(loaded, moduleName)
        else
            table.insert(failed, moduleName)
        end
    end

    -- Summary
    if #failed > 0 then
        warn(`[ScriptLoader V3] Failed to load: {table.concat(failed, ", ")}`)
    end

    return {
        loaded = loaded,
        failed = failed,
        count = #loaded,
        total = #GG.CoreModules,
    }
end

-- Quick loader - load all and return GG (obfuscated: quickLoad)
GG.quickLoad = function(baseUrl: string?): any
    local result = GG.loadAll(baseUrl)
    if result.count > 0 then
        print(`[ScriptLoader V3] Loaded {result.count}/{result.total} modules`)
    end
    return GG
end

------------- Export -------------

return GG
