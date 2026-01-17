-- ScriptLoader V3 - Main Entry Point (loadstring only)
-- Loads init and all core modules via GG environment

------------- Anti-Reexecute -------------

if _G.GG_Maou_main_loaded then
    return _G.GG
end

------------- Get GG Environment (init must be loaded first) -------------

local GG = _G.GG

if not GG then
    return warn("[ScriptLoader V3] GG not found. Load init.luau first via loadstring!")
end

------------- Core Modules (for remote loading) -------------

-- Core modules list (order matters)
local coreModules = {
    "task",      -- Task utilities (must load first)
    "thread",    -- Thread management
    "math",      -- Math utilities
    "table",     -- Table utilities
    "string",    -- String utilities
    "instance",  -- Instance utilities
    "env",       -- Environment utilities
    "teleport",  -- Teleport utilities
}

------------- Load Core Modules from GitHub -------------

local baseUrl = "https://raw.githubusercontent.com/MaouStan/RobloxMaouLoader/refs/heads/master/src/core/"

local function loadModule(name: string): boolean
    local url = baseUrl .. name .. ".luau"

    local success, code = pcall(function()
        return game:HttpGet(url)
    end)

    if not success or not code then
        warn(`[ScriptLoader V3] Failed to fetch {name}.luau`)
        return false
    end

    local loadFn = loadstring(code)
    if not loadFn then
        warn(`[ScriptLoader V3] Failed to loadstring {name}.luau`)
        return false
    end

    local execSuccess, result = pcall(loadFn)
    if not execSuccess then
        warn(`[ScriptLoader V3] Failed to execute {name}.luau: {result}`)
        return false
    end

    return true
end

------------- Load All Modules -------------

local loaded = {}
local failed = {}

for _, moduleName in coreModules do
    if loadModule(moduleName) then
        table.insert(loaded, moduleName)
    else
        table.insert(failed, moduleName)
    end
end

------------- Mark Loaded -------------

_G.GG_Maou_main_loaded = true

------------- Summary -------------

if #failed > 0 then
    warn(`[ScriptLoader V3] Failed: {table.concat(failed, ", ")}`)
end

print(`[ScriptLoader V3] Loaded {#loaded}/{#coreModules} modules`)

------------- Export -------------

return GG
