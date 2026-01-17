---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/core/init.luau" as GG

-- ScriptLoader V3 - Core Thread
-- Thread management and parallel execution utilities

------------- Anti-Reexecute -------------

if not GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Init not loaded")
end

if GG_Maou_thread_loaded then
    return warn("[ScriptLoader V3] Thread already loaded")
end

------------- Library References -------------

local tk = task -- cached ref
local co = coroutine -- cached ref
GG.thr = { -- thread registry
    active = {},   -- active threads by key
    cleanup = {},  -- threads pending cleanup
}

------------- SECTION 1: Task Thread Manager -------------

-- Kill thread by key (obfuscated: thkill)
GG.thkill = function(key: string): boolean
    local registry = GG.thr
    local thread = registry.active[key]

    if thread then
        local success = pcall(function()
            tk.cancel(thread)
        end)
        registry.active[key] = nil
        return success
    end

    return false
end

-- Kill all threads (obfuscated: thkillall)
GG.thkillall = function(): number
    local registry = GG.thr
    local count = 0

    for key, thread in registry.active do
        pcall(tk.cancel, thread)
        registry.active[key] = nil
        count += 1
    end

    return count
end

-- Spawn managed thread (obfuscated: thspawn)
-- If key exists, kills old thread before spawning new one
GG.thspawn = function(key: string, fn: () -> ()): boolean
    local registry = GG.thr

    -- Kill existing thread with same key
    if registry.active[key] then
        pcall(tk.cancel, registry.active[key])
        registry.active[key] = nil
    end

    -- Spawn new thread
    local thread = tk.spawn(function()
        GG.safeCall(fn, `thspawn[{key}]`)
        registry.active[key] = nil
    end)

    registry.active[key] = thread
    return true
end

-- Check if thread exists (obfuscated: thexists)
GG.thexists = function(key: string): boolean
    return GG.thr.active[key] ~= nil
end

-- Get active thread count (obfuscated: thcount)
GG.thcount = function(): number
    local count = 0
    for _ in GG.thr.active do
        count += 1
    end
    return count
end

-- List all active thread keys (obfuscated: thlist)
GG.thlist = function(): {string}
    local keys = {}
    for key in GG.thr.active do
        table.insert(keys, key)
    end
    return keys
end

-- Deferred spawn with key (obfuscated: thdefer)
GG.thdefer = function(key: string, fn: () -> ()): boolean
    local registry = GG.thr

    if registry.active[key] then
        pcall(tk.cancel, registry.active[key])
        registry.active[key] = nil
    end

    local thread = tk.defer(function()
        GG.safeCall(fn, `thdefer[{key}]`)
        registry.active[key] = nil
    end)

    registry.active[key] = thread
    return true
end

-- Delayed spawn with key (obfuscated: thdelay)
GG.thdelay = function(key: string, delay: number, fn: () -> ()): boolean
    local registry = GG.thr

    if registry.active[key] then
        pcall(tk.cancel, registry.active[key])
        registry.active[key] = nil
    end

    local thread = tk.spawn(function()
        tk.wait(delay)
        GG.safeCall(fn, `thdelay[{key}]`)
        registry.active[key] = nil
    end)

    registry.active[key] = thread
    return true
end

-- Interval with key (obfuscated: thinterval)
GG.thinterval = function(key: string, interval: number, fn: () -> boolean?): () -> ()
    local registry = GG.thr
    local running = true

    -- Kill existing
    if registry.active[key] then
        pcall(tk.cancel, registry.active[key])
        registry.active[key] = nil
    end

    local thread = tk.spawn(function()
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
        registry.active[key] = nil
    end)

    registry.active[key] = thread

    return function()
        running = false
        if registry.active[key] then
            pcall(tk.cancel, registry.active[key])
            registry.active[key] = nil
        end
    end
end

------------- SECTION 2: Coroutine Parallel Execution -------------

-- Coroutine status (obfuscated: cstatus)
GG.cstatus = function(co)
    return co.status(co)
end

-- Create coroutine (obfuscated: ccreate)
GG.ccreate = function(fn: () -> any): thread
    return co.create(fn)
end

-- Resume coroutine (obfuscated: cresume)
GG.cresume = function(co: thread, ...): boolean, any
    return co.resume(co, ...)
end

-- Yield coroutine (obfuscated: cyield)
GG.cyield = function(...): any
    return co.yield(...)
end

-- Wrap function as coroutine (obfuscated: cwrap)
GG.cwrap = function(fn: () -> any): (...any) -> ...any
    return co.wrap(fn)
end

-- Get coroutine running (obfuscated: crunning)
GG.crunning = function(): thread?
    return co.running()
end

-- Check if is coroutine (obfuscated: cis)
GG.cis = function(co): boolean
    return co.status(co) ~= nil
end

-- Parallel execute - run multiple functions and wait for all (obfuscated: cparallel)
GG.cparallel = function(...: () -> any): {...any}
    local tasks = {...}
    local coroutines = {}
    local results = {}

    -- Create coroutines
    for i, fn in tasks do
        coroutines[i] = co.create(function()
            GG.safeCall(function()
                results[i] = {fn()}
            end, `cparallel[{i}]`)
        end)
    end

    -- Resume all
    for _, coro in coroutines do
        local success = co.resume(coro)
        if success and co.status(coro) ~= "dead" then
            -- Wait for completion
            while co.status(coro) ~= "dead" do
                tk.wait()
            end
        end
    end

    return table.unpack(results)
end

-- Parallel execute with key management (obfuscated: cparallelkey)
-- Kills old threads with same key group before spawning new batch
GG.cparallelkey = function(keyGroup: string, ...: () -> any): {...any}
    local registry = GG.thr

    -- Kill existing threads in group
    if registry.cleanup[keyGroup] then
        for _, oldThread in registry.cleanup[keyGroup] do
            pcall(tk.cancel, oldThread)
        end
    end

    local tasks = {...}
    local threads = {}
    local results = {}
    local count = #tasks
    local completed = 0

    -- Create thread group
    registry.cleanup[keyGroup] = {}

    -- Spawn each task
    for i, fn in tasks do
        threads[i] = tk.spawn(function()
            GG.safeCall(function()
                results[i] = {fn()}
            end, `cparallelkey[{keyGroup}][{i}]`)
            completed += 1
        end)
        table.insert(registry.cleanup[keyGroup], threads[i])
    end

    -- Wait for all to complete
    while completed < count do
        tk.wait()
    end

    -- Cleanup registry
    registry.cleanup[keyGroup] = nil

    return table.unpack(results)
end

-- Race coroutines - returns first to complete (obfuscated: crace)
GG.crace = function(...: () -> any): any
    local tasks = {...}
    local coroutines = {}
    local finished = false
    local result = nil

    for i, fn in tasks do
        coroutines[i] = co.create(function()
            if not finished then
                finished = true
                result = fn()
            end
        end)
    end

    -- Start race
    for _, coro in coroutines do
        if not finished then
            co.resume(coro)
        end
    end

    return result
end

-- Worker pool - run function across multiple coroutines (obfuscated: cpool)
GG.cpool = function(fn: (any) -> any, data: {any}, workers: number?): {any}
    workers = workers or 4
    local results = {}
    local queue = {}
    local active = 0
    local index = 1

    -- Fill queue
    for i, item in data do
        queue[i] = item
    end

    -- Worker function
    local function worker()
        while active > 0 and index <= #queue do
            local i = index
            local item = queue[i]
            index = i + 1

            if item then
                GG.safeCall(function()
                    results[i] = {fn(item)}
                end, `cpool[{i}]`)
            end
        end
        active -= 1
    end

    -- Spawn workers
    active = workers
    for _ = 1, workers do
        co.create(worker)
        co.resume(coroutine.running())
    end

    return results
end

------------- Mark Loaded -------------

GG_Maou_thread_loaded = true

------------- Export -------------

return {
    thr = GG.thr,
    thkill = GG.thkill,
    thkillall = GG.thkillall,
    thspawn = GG.thspawn,
    thexists = GG.thexists,
    thcount = GG.thcount,
    thlist = GG.thlist,
    cparallel = GG.cparallel,
    cparallelkey = GG.cparallelkey,
    crace = GG.crace,
    cpool = GG.cpool,
}
