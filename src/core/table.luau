---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/init.luau" as GG

-- ScriptLoader V3 - Core Table
-- Table utilities and helpers

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
    return warn("[ScriptLoader V3] Init not loaded")
end

if GG.GG_Maou_table_loaded then
    return warn("[ScriptLoader V3] Table already loaded")
end

------------- Table Library Reference -------------

local tbl = table -- cached ref
GG.tble = tbl

------------- Core Table Functions (Cached) -------------

-- Basic table operations (obfuscated)
GG.tin = tbl.insert
GG.trm = tbl.remove
GG.tcl = tbl.clear
GG.tfnd = tbl.find
GG.tsort = tbl.sort
GG.tconcat = tbl.concat
GG.tunpack = tbl.unpack
GG.tpack = tbl.pack
GG.tfreeze = tbl.freeze
GG.tisfrozen = tbl.isfrozen
GG.tmove = tbl.move
GG.tforeach = tbl.foreach
GG.tforeachi = tbl.foreachi

------------- Extended Table Utilities -------------

-- Clone table shallow (obfuscated: tclone)
GG.tclone = function(t: {[any]: any}): {[any]: any}
    local clone = {}
    for k, v in t do
        clone[k] = v
    end
    return clone
end

-- Clone table deep (obfuscated: tdeep)
GG.tdeep = function(t: {[any]: any}): {[any]: any}
    local clone = {}
    for k, v in t do
        if type(v) == "table" then
            clone[k] = GG.tdeep(v)
        else
            clone[k] = v
        end
    end
    return clone
end

-- Merge tables (obfuscated: tmerge)
GG.tmerge = function(...: {[any]: any}): {[any]: any}
    local result = {}
    for _, t in {...} do
        if type(t) == "table" then
            for k, v in t do
                result[k] = v
            end
        end
    end
    return result
end

-- Get table length safely (obfuscated: tlen)
GG.tlen = function(t: {[any]: any}): number
    local count = 0
    for _ in t do
        count += 1
    end
    return count
end

-- Check if table is empty (obfuscated: tempty)
GG.tempty = function(t: {[any]: any}): boolean
    return next(t) == nil
end

-- Get keys of table (obfuscated: tkeys)
GG.tkeys = function(t: {[any]: any}): {any}
    local keys = {}
    for k in t do
        GG.tin(keys, k)
    end
    return keys
end

-- Get values of table (obfuscated: tvals)
GG.tvals = function(t: {[any]: any}): {any}
    local vals = {}
    for _, v in t do
        GG.tin(vals, v)
    end
    return vals
end

-- Reverse array (obfuscated: trev)
GG.trev = function(t: {any}): {any}
    local rev = {}
    for i = #t, 1, -1 do
        GG.tin(rev, t[i])
    end
    return rev
end

-- Shuffle array (obfuscated: tshuf)
GG.tshuf = function(t: {any}): {any}
    local shuffled = GG.tclone(t)
    for i = #shuffled, 2, -1 do
        local j = GG.mrandom(1, i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    return shuffled
end

-- Map function over table (obfuscated: tmap)
GG.tmap = function(t: {any}, fn: (any, any) -> any): {any}
    local result = {}
    for k, v in t do
        result[k] = fn(v, k)
    end
    return result
end

-- Filter table (obfuscated: tfilter)
GG.tfilter = function(t: {any}, fn: (any, any) -> boolean): {any}
    local result = {}
    for k, v in t do
        if fn(v, k) then
            GG.tin(result, v)
        end
    end
    return result
end

-- Reduce table (obfuscated: treduce)
GG.treduce = function(t: {any}, fn: (any, any) -> any, init: any?): any
    local acc = init
    for i, v in t do
        if acc == nil then
            acc = v
        else
            acc = fn(acc, v)
        end
    end
    return acc
end

-- Find element by predicate (obfuscated: tfindif)
GG.tfindif = function(t: {any}, fn: (any, any) -> boolean): any?
    for k, v in t do
        if fn(v, k) then
            return v, k
        end
    end
    return nil
end

-- Check if table has value (obfuscated: thas)
GG.thas = function(t: {[any]: any}, value: any): boolean
    for _, v in t do
        if v == value then
            return true
        end
    end
    return false
end

-- Get table as string (obfuscated: tstr)
GG.tstr = function(t: {[any]: any}, indent: string?): string
    local result = {}
    local space = indent or ""

    for k, v in t do
        local key = type(k) == "string" and `"{k}"` or tostring(k)
        if type(v) == "table" then
            GG.tin(result, `    {space}{key} = {{{GG.tstr(v, space .. "    ")}}}`)
        else
            local val = type(v) == "string" and `"{v}"` or tostring(v)
            GG.tin(result, `    {space}{key} = {val}`)
        end
    end

    GG.tin(result, 1, "{")
    GG.tin(result, "}")

    return GG.tconcat(result, "\n")
end

-- Create table from range (obfuscated: trange)
GG.trange = function(from: number, to: number, step: number?): {number}
    local result = {}
    step = step or 1
    for i = from, to, step do
        GG.tin(result, i)
    end
    return result
end

-- Slice array (obfuscated: tslice)
GG.tslice = function(t: {any}, from: number, to: number?): {any}
    local result = {}
    to = to or #t
    for i = from, to do
        GG.tin(result, t[i])
    end
    return result
end

-- First N elements (obfuscated: tfirst)
GG.tfirst = function(t: {any}, n: number): {any}
    return GG.tslice(t, 1, n)
end

-- Last N elements (obfuscated: tlast)
GG.tlast = function(t: {any}, n: number): {any}
    return GG.tslice(t, #t - n + 1, #t)
end

-- Flatten table (obfuscated: tflat)
GG.tflat = function(t: {any}): {any}
    local result = {}
    local function flatten(x)
        if type(x) == "table" then
            for _, v in x do
                flatten(v)
            end
        else
            GG.tin(result, x)
        end
    end
    flatten(t)
    return result
end

-- Zip tables together (obfuscated: tzip)
GG.tzip = function(...: {any}): {any}
    local result = {}
    local tables = GG.tpack(...)
    local lenFn = function(t) return #t end
    local maxLen = GG.treduce(GG.tmap(tables, lenFn), math.max, 0)

    for i = 1, maxLen do
        local row = {}
        for _, t in tables do
            GG.tin(row, t[i])
        end
        GG.tin(result, row)
    end

    return result
end

-- Group by key (obfuscated: tgroup)
GG.tgroup = function(t: {any}, keyFn: (any) -> any): {[any]: {any}}
    local result = {}
    for _, v in t do
        local key = keyFn(v)
        if not result[key] then
            result[key] = {}
        end
        GG.tin(result[key], v)
    end
    return result
end

-- Count occurrences (obfuscated: tcount)
GG.tcount = function(t: {any}, value: any): number
    local count = 0
    for _, v in t do
        if v == value then
            count += 1
        end
    end
    return count
end

-- Unique values (obfuscated: tunique)
GG.tunique = function(t: {any}): {any}
    local seen = {}
    local result = {}
    for _, v in t do
        if not seen[v] then
            seen[v] = true
            GG.tin(result, v)
        end
    end
    return result
end

-- Sort by key (obfuscated: tsortby)
GG.tsortby = function(t: {any}, keyFn: (any) -> any): {any}
    local sorted = GG.tclone(t)
    GG.tsort(sorted, function(a, b)
        return keyFn(a) < keyFn(b)
    end)
    return sorted
end

-- Partition table (obfuscated: tpartition)
GG.tpartition = function(t: {any}, fn: (any) -> boolean): ({any}, {any})
    local matched, unmatched = {}, {}
    for _, v in t do
        if fn(v) then
            GG.tin(matched, v)
        else
            GG.tin(unmatched, v)
        end
    end
    return matched, unmatched
end

-- Pick keys from table (obfuscated: tpick)
GG.tpick = function(t: {[any]: any}, ...: any): {[any]: any}
    local result = {}
    for _, key in {...} do
        if t[key] ~= nil then
            result[key] = t[key]
        end
    end
    return result
end

-- Omit keys from table (obfuscated: tomit)
GG.tomit = function(t: {[any]: any}, ...: any): {[any]: any}
    local result = {}
    local omit = {}
    for _, key in {...} do
        omit[key] = true
    end
    for k, v in t do
        if not omit[k] then
            result[k] = v
        end
    end
    return result
end

------------- Mark Loaded -------------

GG.GG_Maou_table_loaded = true

------------- Export -------------

return {
    tin = GG.tin,
    trm = GG.trm,
    tclone = GG.tclone,
    tdeep = GG.tdeep,
    tmerge = GG.tmerge,
}
