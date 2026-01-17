-- ScriptLoader V3 - Main Entry Point (loadstring compatible)
-- Loads init and all core modules

------------- Anti-Reexecute -------------

if _G.GG_Maou_main_loaded then
    return _G.GG
end

------------- Find Script Path (for require) -------------

-- When loaded via loadstring, we need to determine the path
local scriptPath = script or (getfenv and getfenv(2).script) or nil

------------- Load Init (Super Global Environment) -------------

local function loadInit()
    if scriptPath then
        -- Local loading via require
        return require(scriptPath:FindFirstChild("init.luau") or scriptPath.Parent.init)
    else
        -- Remote loading - init should be loaded first
        return _G.GG or warn("[ScriptLoader V3] Init not loaded. Load init.luau first!")
    end
end

local success, init = pcall(loadInit)

if not success then
    return warn("[ScriptLoader V3] Failed to load init:", init)
end

local GG = init or _G.GG

if not GG then
    return warn("[ScriptLoader V3] GG environment not found")
end

------------- Core Module Loader -------------

-- Core modules to load (order matters)
local coreModules = {
    "task",      -- Task utilities (must load first - others depend on it)
    "thread",    -- Thread management
    "math",      -- Math utilities
    "table",     -- Table utilities
    "string",    -- String utilities
    "instance",  -- Instance utilities
    "env",       -- Environment utilities
    "teleport",  -- Teleport utilities
}

------------- Load All Core Modules -------------

local loaded = {}
local failed = {}

if scriptPath then
    -- Local loading
    local coreFolder = scriptPath:FindFirstChild("core")

    if coreFolder then
        for _, moduleName in coreModules do
            local moduleFile = coreFolder:FindFirstChild(moduleName .. ".luau")

            if moduleFile then
                local modSuccess, modResult = pcall(function()
                    return require(moduleFile)
                end)

                if modSuccess then
                    table.insert(loaded, moduleName)
                else
                    table.insert(failed, moduleName)
                    warn(`[ScriptLoader V3] Failed to load {moduleName}: {modResult}`)
                end
            else
                table.insert(failed, moduleName)
                warn(`[ScriptLoader V3] Module not found: {moduleName}`)
            end
        end
    end
else
    -- Remote loading - assume core modules already loaded via loadAll
    print("[ScriptLoader V3] Remote mode - core modules should be loaded via GG.loadAll()")
    for _, moduleName in coreModules do
        table.insert(loaded, moduleName)
    end
end

------------- Mark Loaded -------------

_G.GG_Maou_main_loaded = true

------------- Summary -------------

if #failed > 0 then
    warn(`[ScriptLoader V3] Failed to load: {table.concat(failed, ", ")}`)
end

print(`[ScriptLoader V3] Loaded {#loaded}/{#coreModules} core modules`)

------------- Export -------------

return GG
