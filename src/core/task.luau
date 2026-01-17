---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/init.luau" as GG

-- ScriptLoader V3 - Core Task
-- Task library utilities and helpers

------------- Anti-Reexecute -------------

if not GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Init not loaded")
end

if GG_Maou_task_loaded then
    return warn("[ScriptLoader V3] Task already loaded")
end

------------- Task Library Reference -------------

local tk = task -- cached ref
GG.tk = tk

------------- Core Task Functions (Cached) -------------

GG.twait = tk.wait
GG.tspawn = tk.spawn
GG.tdefer = tk.defer
GG.tdelay = tk.delay
GG.tcancel = tk.cancel
GG.tdesyn = tk.desynchronize
GG.tsyn = tk.synchronize
GG.tyield = tk.yield or coroutine.yield

------------- Extended Task Utilities -------------

-- Wait with condition (obfuscated: twaitif)
GG.twaitif = function(condition: () -> boolean, timeout: number?): boolean
    local start = tick()
    timeout = timeout or 30

    while tick() - start < timeout do
        if condition() then
            return true
        end
        tk.wait(0.1)
    end

    return false
end

-- Wait for child (obfuscated: twaitchild)
GG.twaitchild = function(parent: Instance, name: string, timeout: number?): Instance?
    local suc, res = pcall(function()
        return parent:WaitForChild(name, timeout or 5)
    end)
    return suc and res or nil
end

-- Wait for property (obfuscated: twaitprop)
GG.twaitprop = function(instance: Instance, prop: string, timeout: number?): any
    local start = tick()
    timeout = timeout or 5

    local suc, res = pcall(function()
        return instance[prop]
    end)

    if suc and res ~= nil then
        return res
    end

    while tick() - start < timeout do
        local s2, r2 = pcall(function()
            return instance[prop]
        end)
        if s2 and r2 ~= nil then
            return r2
        end
        tk.wait(0.1)
    end

    return nil
end

-- Repeat function (obfuscated: trepeat)
GG.trepeat = function(times: number, fn: () -> ())
    for i = 1, times do
        fn(i)
    end
end

-- Loop with delay (obfuscated: tloop)
GG.tloop = function(interval: number, fn: () -> boolean?, duration: number?)
    local start = tick()
    duration = duration or GG.mhuge

    while tick() - start < duration do
        local result = fn()
        if result == false then
            break
        end
        tk.wait(interval)
    end
end

-- Debounce (obfuscated: tdebounce)
GG.tdebounce = function(delay: number): () -> ()
    local running = false
    return function(...)
        if running then
            return
        end
        running = true
        tk.spawn(function()
            tk.wait(delay)
            running = false
        end)
        return ...
    end
end

-- Throttle (obfuscated: tthrottle)
GG.tthrottle = function(delay: number): () -> ()
    local last = 0
    return function(...)
        local now = tick()
        if now - last >= delay then
            last = now
            return ...
        end
    end
end

-- Delayed call (obfuscated: tafter)
GG.tafter = function(delay: number, fn: () -> ())
    tk.spawn(function()
        tk.wait(delay)
        fn()
    end)
end

-- Interval (obfuscated: tinterval)
GG.tinterval = function(interval: number, fn: () -> boolean?): () -> ()
    local running = true

    tk.spawn(function()
        while running do
            tk.wait(interval)
            if not running then
                break
            end
            local result = fn()
            if result == false then
                break
            end
        end
    end)

    return function()
        running = false
    end
end

-- Parallel spawn (obfuscated: tparallel)
GG.tparallel = function(...: () -> ())
    local tasks = {...}

    for _, fn in tasks do
        tk.spawn(fn)
    end
end

-- Sync spawn (obfuscated: tsync)
GG.tsync = function(fn: () -> ())
    tk.desynchronize()
    fn()
    tk.synchronize()
end

-- Wrap with timeout (obfuscated: ttimeout)
GG.ttimeout = function(fn: () -> any, timeout: number): (boolean, any)
    local success, result = false, nil

    local thread = tk.spawn(function()
        result = fn()
        success = true
    end)

    tk.wait(timeout)

    if not success then
        tk.cancel(thread)
        return false, "timeout"
    end

    return true, result
end

-- Race multiple functions (obfuscated: trace)
GG.trace = function(...: () -> any): any
    local tasks = {...}
    local finished = false
    local result = nil

    local function wrap(fn)
        return function()
            if not finished then
                finished = true
                result = fn()
            end
        end
    end

    for _, fn in tasks do
        tk.spawn(wrap(fn))
    end

    while not finished do
        tk.wait(0.01)
    end

    return result
end

------------- Mark Loaded -------------

GG_Maou_task_loaded = true

------------- Export -------------

return {
    tk = GG.tk,
    twait = GG.twait,
    tspawn = GG.tspawn,
    tdefer = GG.tdefer,
}
