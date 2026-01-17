---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/init.luau" as GG

-- ScriptLoader V3 - Core Math
-- Math library utilities and helpers

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

if GG.GG_Maou_math_loaded then
    return warn("[ScriptLoader V3] Math already loaded")
end

------------- Math Library Reference -------------

local m = math -- cached ref
GG.mmaths = m

------------- Core Math Functions (Cached) -------------

GG.mrandom = m.random
GG.mfloor = m.floor
GG.mceil = m.ceil
GG.mround = m.round
GG.mabs = m.abs
GG.mmin = m.min
GG.mmax = m.max
GG.mclamp = m.clamp
GG.mlerp = m.lerp
GG.msign = m.sign
GG.mpi = m.pi
GG.mhuge = m.huge
GG.msin = m.sin
GG.mcos = m.cos
GG.mtan = m.tan
GG.masin = m.asin
GG.macos = m.acos
GG.matan = m.atan
GG.matan2 = m.atan2
GG.mrad = m.rad
GG.mdeg = m.deg
GG.msqrt = m.sqrt
GG.mpow = m.pow
GG.mlog = m.log
GG.mexp = m.exp
GG.mmod = m.mod
GG.mfmod = m.fmod
GG.mnoise = m.noise
GG.msinh = m.sinh
GG.mcosh = m.cosh
GG.mtanh = m.tanh

------------- Extended Math Utilities -------------

-- Linear interpolation (obfuscated: mlerp2)
GG.mlerp2 = function(a: number, b: number, t: number): number
    return a + (b - a) * t
end

-- Inverse lerp (obfuscated: milerp)
GG.milerp = function(a: number, b: number, t: number): number
    return (t - a) / (b - a)
end

-- Remap range (obfuscated: mremap)
GG.mremap = function(value: number, inMin: number, inMax: number, outMin: number, outMax: number): number
    return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
end

-- Clamp01 (obfuscated: mclamp01)
GG.mclamp01 = function(value: number): number
    return GG.mmax(0, GG.mmin(1, value))
end

-- Approach (obfuscated: mapproach)
GG.mapproach = function(current: number, target: number, maxDelta: number): number
    if m.abs(target - current) <= maxDelta then
        return target
    end
    return current + m.sign(target - current) * maxDelta
end

-- Move towards (obfuscated: mmoveto)
GG.mmoveto = function(current: number, target: number, maxDelta: number): number
    local diff = target - current
    if diff <= maxDelta then
        return target
    end
    return current + maxDelta
end

-- Ping pong (obfuscated: mpong)
GG.mpong = function(value: number, length: number): number
    return length - m.abs(m.clamp(value, 0, length * 2) - length)
end

-- Repeat (obfuscated: mrepeat)
GG.mrepeat = function(value: number, length: number): number
    return m.clamp(value - m.floor(value / length) * length, 0, length)
end

-- Delta angle (obfuscated: mdelta)
GG.mdelta = function(current: number, target: number): number
    local diff = target - current
    return diff
end

-- Lerp angle (obfuscated: mlerpa)
GG.mlerpa = function(a: number, b: number, t: number): number
    local diff = b - a
    return a + diff * t
end

-- Smooth step (obfuscated: msmooth)
GG.msmooth = function(edge0: number, edge1: number, x: number): number
    local t = m.clamp((x - edge0) / (edge1 - edge0), 0, 1)
    return t * t * (3 - 2 * t)
end

-- Smoother step (obfuscated: msmooth2)
GG.msmooth2 = function(edge0: number, edge1: number, x: number): number
    local t = m.clamp((x - edge0) / (edge1 - edge0), 0, 1)
    return t * t * t * (t * (t * 6 - 15) + 10)
end

-- Damp (obfuscated: mdamp)
GG.mdamp = function(current: number, target: number, smoothing: number, dt: number): number
    return current + (target - current) * (1 - m.exp(-smoothing * dt))
end

-- Oscillate (obfuscated: mosc)
GG.mosc = function(time: number, speed: number, min: number, max: number): number
    return min + (m.sin(time * speed) * 0.5 + 0.5) * (max - min)
end

-- Percent (obfuscated: mpct)
GG.mpct = function(value: number, max: number): number
    return max ~= 0 and (value / max) * 100 or 0
end

-- Random range (obfuscated: mrange)
GG.mrange = function(min: number, max: number): number
    return GG.mrandom() * (max - min) + min
end

-- Random range int (obfuscated: mrangei)
GG.mrangei = function(min: number, max: number): number
    return m.random(min, max)
end

-- Random choice (obfuscated: mchoice)
GG.mchoice = function(...)
    local choices = {...}
    return choices[m.random(1, #choices)]
end

-- Random bool (obfuscated: mbool)
GG.mbool = function(chance: number?): boolean
    chance = chance or 0.5
    return m.random() <= chance
end

-- Round to decimal (obfuscated: mroundd)
GG.mroundd = function(value: number, decimals: number): number
    local mult = 10 ^ decimals
    return m.floor(value * mult + 0.5) / mult
end

-- Snap to grid (obfuscated: msnap)
GG.msnap = function(value: number, gridSize: number): number
    return m.floor(value / gridSize + 0.5) * gridSize
end

-- Distance between 2D points (obfuscated: mdist2)
GG.mdist2 = function(x1: number, y1: number, x2: number, y2: number): number
    local dx = x2 - x1
    local dy = y2 - y1
    return m.sqrt(dx * dx + dy * dy)
end

-- Distance between 3D points (obfuscated: mdist3)
GG.mdist3 = function(x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): number
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return m.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Angle between 2D vectors (obfuscated: mangle2)
GG.mangle2 = function(x1: number, y1: number, x2: number, y2: number): number
    return GG.mdeg * GG.matan2(y2 - y1, x2 - x1)
end

-- Normalize angle to -180 to 180 (obfuscated: mnorma)
GG.mnorma = function(angle: number): number
    return GG.matan2(GG.msin(angle), GG.mcos(angle))
end

-- Shortest angle distance (obfuscated: magledist)
GG.magledist = function(from: number, to: number): number
    local diff = to - from
    return diff
end

-- Average (obfuscated: mavg)
GG.mavg = function(...: number): number
    local sum = 0
    for _, v in {...} do
        sum += v
    end
    return sum / #{...}
end

-- Sum (obfuscated: msum)
GG.msum = function(...: number): number
    local sum = 0
    for _, v in {...} do
        sum += v
    end
    return sum
end

-- Product (obfuscated: mprod)
GG.mprod = function(...: number): number
    local prod = 1
    for _, v in {...} do
        prod *= v
    end
    return prod
end

-- Max value (obfuscated: mmaxv)
GG.mmaxv = function(...: number): number
    local max = -GG.mhuge
    for _, v in {...} do
        if v > max then
            max = v
        end
    end
    return max
end

-- Min value (obfuscated: mminv)
GG.mminv = function(...: number): number
    local min = m.huge
    for _, v in {...} do
        if v < min then
            min = v
        end
    end
    return min
end

-- Map table (obfuscated: mmap)
GG.mmap = function(tbl: {number}, fn: (number) -> number): {number}
    local result = {}
    for i, v in tbl do
        result[i] = fn(v)
    end
    return result
end

-- Degrees to radians (obfuscated: mdeg2rad)
GG.mdeg2rad = function(deg: number): number
    return deg * m.pi / 180
end

-- Radians to degrees (obfuscated: mrad2deg)
GG.mrad2deg = function(rad: number): number
    return rad * 180 / m.pi
end

-- Check if approximately equal (obfuscated: mapprox)
GG.mapprox = function(a: number, b: number, tolerance: number?): boolean
    tolerance = tolerance or 0.0001
    return m.abs(a - b) < tolerance
end

-- Check if number is even (obfuscated: meven)
GG.meven = function(n: number): boolean
    return n % 2 == 0
end

-- Check if number is odd (obfuscated: modd)
GG.modd = function(n: number): boolean
    return n % 2 ~= 0
end

-- Check if number is NaN (obfuscated: mnan)
GG.mnan = function(n: number): boolean
    return n ~= n
end

-- Check if number is finite (obfuscated: mfinite)
GG.mfinite = function(n: number): boolean
    return n > -m.huge and n < m.huge
end

-- Percentage of value between min and max (obfuscated: mbetween)
GG.mbetween = function(value: number, min: number, max: number): number
    return (value - min) / (max - min)
end

-- Ease in quad (obfuscated: measein)
GG.measein = function(t: number): number
    return t * t
end

-- Ease out quad (obfuscated: measeout)
GG.measeout = function(t: number): number
    return t * (2 - t)
end

-- Ease in out quad (obfuscated: measeinout)
GG.measeinout = function(t: number): number
    return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
end

-- Ease in cubic (obfuscated: measeinc)
GG.measeinc = function(t: number): number
    return t * t * t
end

-- Ease out cubic (obfuscated: measeoutc)
GG.measeoutc = function(t: number): number
    local f = t - 1
    return f * f * f + 1
end

-- Ease in out cubic (obfuscated: measeinoutc)
GG.measeinoutc = function(t: number): number
    return t < 0.5 and 4 * t * t * t or (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
end

------------- Mark Loaded -------------

GG.GG_Maou_math_loaded = true

------------- Export -------------

return {
    mmaths = GG.mmaths,
    mrandom = GG.mrandom,
    mclamp = GG.mclamp,
    mlerp = GG.mlerp,
    mrange = GG.mrange,
}
