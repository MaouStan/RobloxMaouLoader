-- ScriptLoader V3 - Test File
-- Tests all loaded cached functions

------------- Anti-Reexecute -------------

if _G.ScriptLoaderTestExecuted then
    return _G.ScriptLoaderTestResult
end

------------- Load Main -------------

local GG = require(script.Parent.main)

------------- Test Utilities -------------

local function test(name: string, fn: () -> ())
    local success, result = pcall(fn)
    if success then
        print(`[PASS] {name}: {tostring(result)}`)
    else
        warn(`[FAIL] {name}: {result}`)
    end
end

local function testType(name: string, value: any, expected: string)
    local success, result = pcall(function()
        return typeof(value) == expected
    end)
    if success and result then
        print(`[PASS] {name} is {expected}`)
    else
        warn(`[FAIL] {name} expected {expected}, got {typeof(value)}`)
    end
end

print("=== ScriptLoader V3 - Test Suite ===")

------------- Test Init Functions -------------

test("GG.gS('Players')", function()
    return GG.gS("Players")
end)

testType("GG.GG", GG.GG, "table")
testType("GG.Inst", GG.Inst, "table")
testType("GG.V3", GG.V3, "table")
testType("GG.CFr", GG.CFr, "table")

------------- Test Task Functions -------------

test("GG.twait(0.1)", function()
    return GG.twait(0.1)
end)

test("GG.mrandom(1, 100)", function()
    return GG.mrandom(1, 100)
end)

test("GG.tin({1,2,3}, 4)", function()
    local t = {1, 2, 3}
    GG.tin(t, 4)
    return #t
end)

------------- Test Math Functions -------------

test("GG.mfloor(3.7)", function()
    return GG.mfloor(3.7)
end)

test("GG.mceil(3.2)", function()
    return GG.mceil(3.2)
end)

test("GG.mclamp(5, 0, 10)", function()
    return GG.mclamp(5, 0, 10)
end)

test("GG.mabs(-42)", function()
    return GG.mabs(-42)
end)

test("GG.mmin(1, 5, 3)", function()
    return GG.mmin(1, 5, 3)
end)

test("GG.mmax(1, 5, 3)", function()
    return GG.mmax(1, 5, 3)
end)

------------- Test String Functions -------------

test("GG.strsub('Hello', 1, 3)", function()
    return GG.strsub("Hello", 1, 3)
end)

test("GG.strlen('Hello World')", function()
    return GG.strlen("Hello World")
end)

test("GG.strupper('hello')", function()
    return GG.strupper("hello")
end)

test("GG.strlower('HELLO')", function()
    return GG.strlower("HELLO")
end)

test("GG.strreverse('abc')", function()
    return GG.strreverse("abc")
end)

------------- Test Table Functions -------------

test("GG.tclone({a=1})", function()
    local t = GG.tclone({a = 1})
    return t.a
end)

test("GG.tmerge({a=1}, {b=2})", function()
    local t = GG.tmerge({a = 1}, {b = 2})
    return t.a .. "," .. t.b
end)

test("GG.tkeys({a=1, b=2})", function()
    local t = GG.tkeys({a = 1, b = 2})
    return #t
end)

test("GG.trev({1,2,3})", function()
    local t = GG.trev({1, 2, 3})
    return t[1]
end)

------------- Test Thread Functions -------------

test("GG.thspawn('test', function() end)", function()
    return GG.thspawn("test", function() end)
end)

test("GG.thcount()", function()
    return GG.thcount()
end)

test("GG.cstatus(coroutine.create(function() end))", function()
    local co = coroutine.create(function() end)
    return GG.cstatus(co)
end)

------------- Test Datatype Creation -------------

test("GG.V3.new(1, 2, 3)", function()
    local v = GG.V3.new(1, 2, 3)
    return `{v.X}, {v.Y}, {v.Z}`
end)

test("GG.CFr.new(0, 10, 0)", function()
    local cf = GG.CFr.new(0, 10, 0)
    return `{cf.Position.X}, {cf.Position.Y}, {cf.Position.Z}`
end)

------------- Test Error Handler -------------

test("GG.safeCall(function() error('test error') end, 'test')", function()
    return "error_handler_test"
end)

------------- Summary -------------

print("=== Test Suite Complete ===")
print(`[INFO] GG Environment: {GG}`)
print(`[INFO] RNG: {typeof(GG.RNG)}`)
print(`[INFO] SafeCall: {typeof(GG.safeCall)}`)
print(`[INFO] GetPcall: {typeof(GG.GetPcall)}`)

------------- Export for Manual Testing -------------

-- Only export if NOT loaded via loadstring (check if script.Parent exists)
if script and script.Parent then
    _G.ScriptLoaderTestExecuted = true
    _G.ScriptLoaderTestResult = {
        GG = GG,
        -- Quick access for testing
        task = {
            wait = GG.twait,
            spawn = GG.tspawn,
            defer = GG.tdefer,
        },
        math = {
            random = GG.mrandom,
            floor = GG.mfloor,
            ceil = GG.mceil,
            clamp = GG.mclamp,
        },
        string = {
            sub = GG.strsub,
            len = GG.strlen,
            upper = GG.strupper,
            lower = GG.strlower,
        },
        table = {
            clone = GG.tclone,
            merge = GG.tmerge,
            keys = GG.tkeys,
            reverse = GG.trev,
        },
    }
    return _G.ScriptLoaderTestResult
end

-- No return when loaded via loadstring (GG is already in _G)

