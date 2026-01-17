-- ScriptLoader V3 - Core Init
-- Super Global Environment with Metatable

------------- Anti-Reexecute -------------

if GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Super Global Environment already loaded")
end

------------- Game Load -------------

if not game:IsLoaded() then
    game.Loaded:Wait()
end

------------- Super Global Setup ---

-- Fallback chain for environment lookup
local function getRootEnvironment()
    return (getgenv and getgenv()) or _G or shared or {}
end

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

-- Metatable for GG with __index and __newindex
local GG_Meta = {
    -- Read: GG → _G → getgenv() fallback chain
    __index = function(self, key)
        -- First check internal storage
        if GG_Internal[key] ~= nil then
            return GG_Internal[key]
        end

        -- Then check root environment
        local root = getRootEnvironment()
        if rawget(root, key) ~= nil then
            return rawget(root, key)
        end

        -- Service auto-loading (lazy load services)
        local service = game:GetService(key)
        if service then
            GG_Internal[key] = service
            return service
        end

        return nil
    end,

    -- Write: Store internally, protect critical keys
    __newindex = function(self, key, value)
        -- Protect critical keys from being overwritten
        if ProtectedKeys[key] then
            warn(`[ScriptLoader V3] Protected key "{key}" cannot be overwritten`)
            return
        end

        -- Store in internal storage
        GG_Internal[key] = value
    end,

    -- Pair/iteration support
    __pairs = function(self)
        local root = getRootEnvironment()
        local merged = {}

        -- Merge internal storage
        for k, v in GG_Internal do
            merged[k] = v
        end

        -- Merge root environment (internal takes precedence)
        for k, v in rawget(root, "_G") or rawget(root) or {} do
            if merged[k] == nil then
                merged[k] = v
            end
        end

        return next, merged, nil
    end,

    -- Tostring for debugging
    __tostring = function(self)
        return "GG<ScriptLoaderV3>"
    end,
}

-- Create GG with metatable
GG = (getgenv and getgenv()) or _G or shared or {}

-- Apply metatable to GG
setmetatable(GG, GG_Meta)

------------- Core Assignment -------------

GG.GG = GG
GG_Maou_init_loaded = true

------------- OBF Fixer -------------

GG.LPH_NO_VIRTUALIZE = function(...)
    return ...
end

GG.IB_NO_VIRTUALIZE = function(...)
    return ...
end

------------- Export -------------

return GG
