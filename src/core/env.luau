---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/init.luau" as GG

-- ScriptLoader V3 - Core Env
-- Phase 1: Roblox Game API Services (OBFED)
-- Phase 2: Executor API Environment (OBFED)

------------- Super Global Environment -------------
GG = GG or (function()
    if getgenv then
        return getgenv().GG
    elseif _G then
        return _G.GG
    elseif shared then
        return shared.GG
    else
        return false
    end
end)()

if not GG then
    return warn("[ScriptLoader V3] GG environment not found")
end

------------- Anti-Reexecute -------------

if not GG.GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Super Global Environment not yet load")
end

if GG.GG_Maou_env_loaded then
    return warn("[ScriptLoader V3] Environment already loaded")
end

--============= PHASE 1: SERVICE SETUP =============--

------------- Service Obfuscation Map -------------

-- Format: [ObfuscatedName] = "RealServiceName"
local ServiceMap = {
    -- Core Services
    P = "Players",
    W = "Workspace",
    L = "Lighting",
    RS = "ReplicatedStorage",
    SS = "ServerStorage",
    SP = "StarterPlayer",
    SG = "StarterGui",
    SC = "StarterCharacterScripts",
    SPe = "StarterPlayerScripts",

    -- Network/Data Services
    HS = "HttpService",
    DS = "DataStoreService",
    MS = "MessagingService",
    MMS = "MemoryStoreService",
    AS = "AssetService",
    IS = "InsertService",

    -- UI/Input Services
    GuiS = "GuiService",
    UIS = "UserInputService",
    ViM = "VirtualInputManager",
    CS = "ContextActionService",
    CoS = "ControllerService",
    GaS = "GamepadService",
    KbdS = "KeyboardService",
    MouS = "MouseService",
    HapS = "HapticService",
    NotS = "NotificationService",

    -- Game Services
    TS = "TweenService",
    RSer = "RunService",

    -- Localization
    LS = "LocalizationService",
    LoS = "LogService",

    -- Marketplace
    MaS = "MarketplaceService",
    GaPS = "GamePassService",
    BaS = "BadgeService",

    -- Social
    FrS = "FriendService",
    GrS = "GroupService",

    -- Avatar
    AvES = "AvatarEditorService",

    -- Pathfinding
    PathS = "PathfindingService",

    -- Physics
    PPS = "ProximityPromptService",
    JS = "JointsService",

    -- Audio
    AudS = "AudioService",

    -- Other
    ColS = "CollectionService",
    ConS = "ConfigService",
    ChaS = "ChangeHistoryService",
    DrS = "DraggerService",
    Deb = "Debris",
}

------------- Service Loader -------------

local cr = GG.cr or function(...)
    return ...
end

local function LoadService(obfName: string, realName: string): boolean
    local service = GG.gS(realName)
    if service then
        GG[obfName] = cr(service) or service
        return true
    end
    return false
end

------------- Environment Initialization -------------

local function InitServices()
    local loadedCount = 0
    local failedServices = {}
    local tble = GG.tble or table

    for obfName, realName in ServiceMap do
        if LoadService(obfName, realName) then
            loadedCount += 1
        else
            tble.insert(failedServices, realName)
        end
    end

    if #failedServices > 0 then
        warn(`[ScriptLoader V3] Failed to load services: {tble.concat(failedServices, ", ")}`)
    end

    return loadedCount
end

local serviceCount = InitServices()

------------- Special Mappings -------------

if GG.P then
    GG.selff = GG.P.LocalPlayer
    GG.cmdm = GG.P.LocalPlayer:GetMouse()
end

if GG.W then
    GG.Cam = GG.W.CurrentCamera
end

--============= PHASE 2: EXECUTOR API =============--

------------- Environment Functions (Safe) -------------

local pcalle = GG.pcalle or pcall
local tble = GG.tble or table
local tostring = GG.tostring or tostring
local type = type

-- getgenv: Get global environment (safe)
GG.ggv = function()
    local suc, res = pcalle(getgenv)
    return suc and res or _G or shared
end

-- getrenv: Get Roblox environment (safe)
GG.grenv = function()
    local suc, res = pcalle(getrenv)
    if suc then return res end
    -- Fallback
    local s2, r2 = pcalle(getfenv, 0)
    return s2 and r2 or getfenv(0)
end

-- getgc: Get garbage collection (safe)
GG.ggc = function(filter: boolean?)
    local suc, res = pcalle(getgc)
    if suc then
        if filter == nil then return res end
        -- Filter results
        local filtered = {}
        for _, v in res do
            if type(v) == (filter and "table" or "function") then
                tble.insert(filtered, v)
            end
        end
        return filtered
    end
    return {}
end

------------- Closure Functions (Safe) -------------

-- hookfunction: Hook a function (safe)
GG.hf = function(old, new)
    local suc, res = pcalle(hookfunction, old, new)
    return suc and res or old
end

-- newcclosure: Create new C closure (safe)
GG.ncc = function(f)
    local suc, res = pcalle(newcclosure, f)
    return suc and res or f
end

-- newlclosure: Create new Lua closure (safe)
GG.nlm = function(f)
    local suc, res = pcalle(newlclosure, f)
    return suc and res or f
end

-- islclosure: Check if Lua closure (safe)
GG.ilc = function(f)
    if islclosure then
        local suc, res = pcalle(islclosure, f)
        if suc then return res end
    end
    return type(f) == "function" and debug.getinfo(f).what == "Lua"
end

-- iscclosure: Check if C closure (safe)
GG.icc = function(f)
    if iscclosure then
        local suc, res = pcalle(iscclosure, f)
        if suc then return res end
    end
    return type(f) == "function" and debug.getinfo(f).what == "C"
end

-- isexecutorclosure / checkcaller: Check if executor made (safe)
GG.iec = function()
    local suc, res = pcalle(isexecutorclosure or checkcaller)
    return suc and res or true
end

------------- Debug Functions -------------

-- getupvalues: Get all upvalues (safe)
GG.guv = function(f)
    local suc, res = pcalle(getupvalues or debug.getupvalues, f)
    return suc and res or {}
end

-- getupvalue: Get single upvalue (safe)
GG.gu = function(f, i)
    local suc, res = pcalle(getupvalue or debug.getupvalue, f, i)
    return suc and res or nil
end

-- setupvalue: Set upvalue (safe)
GG.su = function(f, i, v)
    local suc, res = pcalle(setupvalue or debug.setupvalue, f, i, v)
    return suc and res or false
end

-- getconstants: Get constants (safe)
GG.gcon = function(f)
    local suc, res = pcalle(getconstants or debug.getconstants, f)
    return suc and res or {}
end

-- getconstant: Get single constant (safe)
GG.gc = function(f, i)
    local suc, res = pcalle(getconstant or debug.getconstant, f, i)
    return suc and res or nil
end

-- setconstant: Set constant (safe)
GG.sc = function(f, i, v)
    local suc, res = pcalle(setconstant or debug.setconstant, f, i, v)
    return suc and res or false
end

-- getproto: Get prototype (safe)
GG.gp = function(f, i)
    local suc, res = pcalle(getproto or debug.getproto, f, i)
    return suc and res or nil
end

-- getprotos: Get all prototypes (safe)
GG.gps = function(f)
    local suc, res = pcalle(getprotos or debug.getprotos, f)
    return suc and res or {}
end

-- getstack: Get stack (safe)
GG.gs = function(f, i)
    local suc, res = pcalle(getstack or debug.getstack, f, i)
    return suc and res or {}
end

-- setstack: Set stack (safe)
GG.ss = function(f, i, v)
    local suc, res = pcalle(setstack or debug.setstack, f, i, v)
    return suc and res or false
end

------------- Signal Functions -------------

-- getconnections: Get signal connections (safe)
GG.gcxc = function(sig)
    local suc, res = pcalle(getconnections, sig)
    return suc and res or {}
end

-- firesignal: Fire a signal (safe)
GG.fs = function(sig, ...)
    pcalle(firesignal, sig, ...)
end

------------- Input Functions -------------

-- keypress / keyrelease (safe)
GG.kp = function(kc)
    pcalle(keypress, kc)
end
GG.kr = function(kc)
    pcalle(keyrelease, kc)
end

-- Mouse functions (safe)
GG.m1c = function() pcalle(mouse1click) end
GG.m1p = function() pcalle(mouse1press) end
GG.m1r = function() pcalle(mouse1release) end
GG.m2c = function() pcalle(mouse2click) end
GG.m2p = function() pcalle(mouse2press) end
GG.m2r = function() pcalle(mouse2release) end
GG.mms = function(px) pcalle(mousescroll, px) end
GG.mmr = function(x, y) pcalle(mousemoverel, x, y) end

------------- File Functions (Safe) -------------

GG.rf = function(p)
    local suc, res = pcalle(readfile, p)
    return suc and res or nil
end
GG.wf = function(p, c)
    pcalle(writefile, p, c)
end
GG.mf = function(p)
    pcalle(makefolder, p)
end
GG.ef = function(p)
    local suc, res = pcalle(existsfile, p)
    return suc and res or false
end
GG.delf = function(p)
    pcalle(delfile, p)
end

------------- Crypt Functions (Safe) -------------

-- Base64
GG.b64e = function(s)
    local suc, res = pcalle(base64encode, s)
    if suc then return res end
    -- Fallback to HttpService
    local hs = GG.HS
    if hs then
        local s2, r2 = pcalle(function() return hs:EncodeBase64(s) end)
        if s2 then return r2 end
    end
    return s
end
GG.b64d = function(s)
    local suc, res = pcalle(base64decode, s)
    if suc then return res end
    -- Fallback to HttpService
    local hs = GG.HS
    if hs then
        local s2, r2 = pcalle(function() return hs:DecodeBase64(s) end)
        if s2 then return r2 end
    end
    return s
end

------------- Misc Functions (Safe) -------------

-- loadstring
GG.ls = function(s, cn)
    local suc, res = pcalle(loadstring, s, cn)
    return suc and res or nil
end

-- identifyexecutor
GG.ide = function()
    local suc, res = pcalle(identifyexecutor)
    return suc and res or "Unknown"
end

------------- Mark Loaded -------------

GG.GG_Maou_env_loaded = true

------------- Export -------------

return {
    ServiceMap = ServiceMap,
    LoadService = LoadService,
    InitServices = InitServices,
    LoadedCount = serviceCount,
}
