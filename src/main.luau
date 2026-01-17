-- ScriptLoader V3 - Main Entry Point
-- Loads init and all core modules

------------- Load Init (Super Global Environment) -------------

local success, init = pcall(function()
    return require(script.init)
end)

if not success then
    return warn("[ScriptLoader V3] Failed to load init:", init)
end

local GG = init or _G.GG

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

for _, moduleName in coreModules do
    local success, result = pcall(function()
        return require(script.core:FindFirstChild(moduleName .. ".luau"))
    end)

    if success then
        table.insert(loaded, moduleName)
    else
        table.insert(failed, moduleName)
        warn(`[ScriptLoader V3] Failed to load {moduleName}: {result}`)
    end
end

------------- Summary -------------

if #failed > 0 then
    warn(`[ScriptLoader V3] Failed to load: {table.concat(failed, ", ")}`)
end

print(`[ScriptLoader V3] Loaded {#loaded}/{#coreModules} core modules`)

------------- Export -------------

return GG
