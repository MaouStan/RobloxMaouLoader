---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/init.luau" as GG

-- ScriptLoader V3 - Core String
-- String library utilities and helpers

------------- Anti-Reexecute -------------

if not GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Init not loaded")
end

if GG_Maou_string_loaded then
    return warn("[ScriptLoader V3] String already loaded")
end

------------- String Library Reference -------------

GG.str = string

------------- Core String Functions (Cached) -------------

GG.strsub = string.sub
GG.strfind = string.find
GG.strmatch = string.match
GG.strgmatch = string.gmatch
GG.strsplit = string.split
GG.strlen = string.len
GG.strlower = string.lower
GG.strupper = string.upper
GG.strrep = string.rep
GG.strgsub = string.gsub
GG.strformat = string.format
GG.strbyte = string.byte
GG.strchar = string.char
GG.strpack = string.pack
GG.strunpack = string.unpack
GG.strreverse = string.reverse
GG.strpacksize = string.packsize

------------- Extended String Utilities -------------

-- StartsWith check (obfuscated: sstarts)
GG.sstarts = function(str: string, prefix: string): boolean
    return string.sub(str, 1, #prefix) == prefix
end

-- EndsWith check (obfuscated: sends)
GG.sends = function(str: string, suffix: string): boolean
    return string.sub(str, -#suffix) == suffix
end

-- Contains check (obfuscated: scontains)
GG.scontains = function(str: string, sub: string): boolean
    return string.find(str, sub) ~= nil
end

-- Trim whitespace (obfuscated: strim)
GG.strim = function(str: string): string
    return string.match(str, "^%s*(.-)%s*$")
end

-- Trim left (obfuscated: striml)
GG.striml = function(str: string): string
    return string.match(str, "^%s*(.-)$")
end

-- Trim right (obfuscated: strimr)
GG.strimr = function(str: string): string
    return string.match(str, "^(.-)%s*$")
end

-- Split by pattern (obfuscated: ssplit)
GG.ssplit = function(str: string, delimiter: string): {string}
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    for match in string.gmatch(str, pattern) do
        table.insert(result, match)
    end
    return result
end

-- Split by length (obfuscated: schunk)
GG.schunk = function(str: string, chunkSize: number): {string}
    local result = {}
    for i = 1, #str, chunkSize do
        table.insert(result, string.sub(str, i, i + chunkSize - 1))
    end
    return result
end

-- To title case (obfuscated: stitle)
GG.stitle = function(str: string): string
    return string.gsub(str, "(%a)([%w']*)", function(first, rest)
        return string.upper(first) .. string.lower(rest)
    end)
end

-- To camel case (obfuscated: scamel)
GG.scamel = function(str: string): string
    return string.gsub(str, "_%a", function(match)
        return string.upper(string.sub(match, 2, 2))
    end)
end

-- To snake case (obfuscated: ssnake)
GG.ssnake = function(str: string): string
    return string.gsub(str, "%u", function(match)
        return "_" .. string.lower(match)
    end)
end

-- Reverse string (obfuscated: srev)
GG.srev = function(str: string): string
    local result = ""
    for i = #str, 1, -1 do
        result ..= string.sub(str, i, i)
    end
    return result
end

-- Count occurrences (obfuscated: scount)
GG.scount = function(str: string, pattern: string): number
    local count = 0
    for _ in string.gmatch(str, pattern) do
        count += 1
    end
    return count
end

-- Replace first occurrence (obfuscated: sreplace1)
GG.sreplace1 = function(str: string, old: string, new: string): string
    local start = string.find(str, old)
    if not start then
        return str
    end
    return string.sub(str, 1, start - 1) .. new .. string.sub(str, start + #old)
end

-- Truncate (obfuscated: strunc)
GG.strunc = function(str: string, maxLen: number, suffix: string?): string
    if #str <= maxLen then
        return str
    end
    suffix = suffix or "..."
    return string.sub(str, 1, maxLen - #suffix) .. suffix
end

-- Pad left (obfuscated: spadl)
GG.spadl = function(str: string, len: number, char: string?): string
    char = char or " "
    local padding = len - #str
    if padding <= 0 then
        return str
    end
    return string.rep(char, padding) .. str
end

-- Pad right (obfuscated: spadr)
GG.spadr = function(str: string, len: number, char: string?): string
    char = char or " "
    local padding = len - #str
    if padding <= 0 then
        return str
    end
    return str .. string.rep(char, padding)
end

-- Is empty (obfuscated: sempty)
GG.sempty = function(str: string): boolean
    return #string.gsub(str, "%s", "") == 0
end

-- Random string (obfuscated: srandom)
GG.srandom = function(length: number, charset: string?): string
    charset = charset or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local rand = GG.mrandom(1, #charset)
        result ..= string.sub(charset, rand, rand)
    end
    return result
end

-- UUID v4 generator (obfuscated: suuid)
GG.suuid = function(): string
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, "[xy]", function(c)
        local v = c == "x" and GG.mrandom(0, 15) or GG.mrandom(8, 11)
        return string.format("%x", v)
    end)
end

-- Base64 encode (safe wrapper) (obfuscated: sb64)
GG.sb64 = function(str: string): string
    local hs = GG.HS
    if hs then
        local suc, res = pcall(function()
            return hs:EncodeBase64(str)
        end)
        if suc then
            return res
        end
    end

    -- Fallback
    local b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    return (string.gsub(str, ".", function(x)
        local r, b = "", x:byte()
        for i = 8, 1, -1 do
            r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and "1" or "0")
        end
    end) .. "0000"):gsub("%d%d%d?%d?", function(x)
        if #x < 6 then
            return ""
        end
        local c = tonumber(x, 2)
        if c < 64 then
            return b64:sub(c + 1, c + 1)
        end
    end):gsub(".", function(x)
        if x == "=" then
            return ""
        end
        return x
    end)
end

-- Base64 decode (obfuscated: sfromb64)
GG.sfromb64 = function(str: string): string
    local hs = GG.HS
    if hs then
        local suc, res = pcall(function()
            return hs:DecodeBase64(str)
        end)
        if suc then
            return res
        end
    end
    return str  -- Fallback
end

-- Escape special characters (obfuscated: sescape)
GG.sescape = function(str: string): string
    local escapes = {
        ["\\"] = "\\\\",
        ["\""] = "\\\"",
        ["'"] = "\\'",
        ["\n"] = "\\n",
        ["\r"] = "\\r",
        ["\t"] = "\\t",
        ["\b"] = "\\b",
        ["\f"] = "\\f",
    }
    return string.gsub(str, ".", escapes)
end

-- Unescape special characters (obfuscated: sunescape)
GG.sunescape = function(str: string): string
    local unescapes = {
        ["\\\\"] = "\\",
        ["\\\""] = "\"",
        ["\\'"] = "'",
        ["\\n"] = "\n",
        ["\\r"] = "\r",
        ["\\t"] = "\t",
        ["\\b"] = "\b",
        ["\\f"] = "\f",
    }
    return string.gsub(str, "\\.", unescapes)
end

-- Word wrap (obfuscated: swrap)
GG.swrap = function(str: string, maxLen: number): {string}
    local words = string.split(str, " ")
    local lines = {}
    local current = ""

    for _, word in words do
        if #current + #word + 1 > maxLen then
            if #current > 0 then
                table.insert(lines, current)
            end
            current = word
        else
            if #current > 0 then
                current ..= " "
            end
            current ..= word
        end
    end

    if #current > 0 then
        table.insert(lines, current)
    end

    return lines
end

------------- Mark Loaded -------------

GG_Maou_string_loaded = true

------------- Export -------------

return {
    str = GG.str,
    ssplit = GG.ssplit,
    strim = GG.strim,
    scount = GG.scount,
}
