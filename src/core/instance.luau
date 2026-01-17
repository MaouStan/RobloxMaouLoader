---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/init.luau" as GG

-- ScriptLoader V3 - Core Instance
-- Pre-load cache, utilities, and helpers

------------- Anti-Reexecute -------------

if not GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Init not loaded")
end

if GG_Maou_instance_loaded then
    return warn("[ScriptLoader V3] Instance already loaded")
end

------------- Super Global Environment -------------
GG = GG or (getgenv and getgenv().GG) or (_G and _G.GG) or (shared and shared.GG) or false

if not GG then
    return warn("[ScriptLoader V3] GG environment not found")
end

------------- Cache Storage -------------

GG.InstanceCache = {}
GG.AssetCache = {}

------------- Instance Creation Utilities -------------

-- Create instance with properties (obfuscated: nI)
GG.nI = function(className: string, properties: {[string]: any}?): Instance
    local inst = Instance.new(className)
    if properties then
        for prop, value in properties do
            inst[prop] = value
        end
    end
    return inst
end

-- Create and set parent (obfuscated: nIP)
GG.nIP = function(className: string, parent: Instance, properties: {[string]: any}?): Instance
    local inst = GG.nI(className, properties)
    inst.Parent = parent
    return inst
end

------------- WaitForChild Utilities (Safe) -------------

local pcalle = GG.pcalle or pcall

-- WaitForChild with timeout (obfuscated: wFC)
GG.wFC = function(parent: Instance, name: string, timeout: number?): Instance?
    local suc, res = pcalle(parent.WaitForChild, parent, name, timeout or 5)
    return suc and res or nil
end

-- WaitForChild recursively (obfuscated: wFCR)
GG.wFCR = function(parent: Instance, path: string, timeout: number?): Instance?
    local parts = string.split(path, ".")
    local current = parent

    for _, part in parts do
        current = GG.wFC(current, part, timeout)
        if not current then
            return nil
        end
    end

    return current
end

-- WaitForChild of class (obfuscated: wFCC)
GG.wFCC = function(parent: Instance, className: string, timeout: number?): Instance
    local found = parent:FindFirstChildWhichIsA(className, true)
    if found then
        return found
    end

    -- Wait with timeout
    local start = tick()
    timeout = timeout or 5

    while tick() - start < timeout do
        found = parent:FindFirstChildWhichIsA(className, true)
        if found then
            return found
        end
        GG.SecureEnv.twait(0.1)
    end

    return nil
end

------------- Find Utilities -------------

-- Find instances by name with depth flag (obfuscated: fA)
-- depth: 1 = children only, nil/unlimited = descendants
GG.fA = function(parent: Instance, name: string, depth: number?): {Instance}
    local found = {}
    local searchFunc = depth == 1 and parent.GetChildren or parent.GetDescendants

    for _, v in searchFunc(parent) do
        if v.Name == name then
            table.insert(found, v)
        end
    end
    return found
end

-- Find instances by class with depth flag (obfuscated: fAC)
-- depth: 1 = children only, nil/unlimited = descendants
GG.fAC = function(parent: Instance, className: string, depth: number?): {Instance}
    local found = {}
    local searchFunc = depth == 1 and parent.GetChildren or parent.GetDescendants

    for _, v in searchFunc(parent) do
        if v.ClassName == className then
            table.insert(found, v)
        end
    end
    return found
end

-- Find instances by IsA with depth flag (obfuscated: fIsA)
-- depth: 1 = children only, nil/unlimited = descendants
GG.fIsA = function(parent: Instance, className: string, depth: number?): {Instance}
    local found = {}
    local searchFunc = depth == 1 and parent.GetChildren or parent.GetDescendants

    for _, v in searchFunc(parent) do
        if v:IsA(className) then
            table.insert(found, v)
        end
    end
    return found
end

-- Find first descendant by path (obfuscated: fDP)
GG.fDP = function(parent: Instance, path: string): Instance?
    return parent:FindFirstChild(path, true)
end

-- Find first by class with depth (obfuscated: fFC)
GG.fFC = function(parent: Instance, className: string, depth: number?): Instance?
    local searchFunc = depth == 1 and parent.FindFirstChildOfClass or parent.FindFirstChildWhichIsA
    local recursive = depth ~= 1

    local found = searchFunc(parent, className, recursive)
    return found
end

------------- Character Utilities -------------

-- Get character (obfuscated: gC)
GG.gC = function(player: Player?): Model?
    player = player or GG.P and GG.P.LocalPlayer
    if player then
        return player.Character
    end
    return nil
end

-- WaitFor character (obfuscated: wC)
GG.wC = function(player: Player?): Model
    player = player or GG.P and GG.P.LocalPlayer
    if player then
        return player.CharacterAdded:Wait()
    end
    return nil
end

-- Get Humanoid (obfuscated: gH)
GG.gH = function(character: Model?): Humanoid?
    character = character or GG.gC()
    if character then
        local hum = character:FindFirstChildOfClass("Humanoid")
        return hum
    end
    return nil
end

-- Get HumanoidRootPart (obfuscated: gHRP)
GG.gHRP = function(character: Model?): BasePart?
    character = character or GG.gC()
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        return hrp
    end
    return nil
end

-- Get RootJoint (obfuscated: gRJ)
GG.gRJ = function(character: Model?): ObjectValue?
    character = character or GG.gC()
    if character then
        local root = character:FindFirstChild("RootJoint") or character:FindFirstChild("Root")
        return root
    end
    return nil
end

------------- Distance Utilities -------------

-- Get distance between instances (obfuscated: gD)
GG.gD = function(inst1: Instance, inst2: Instance): number
    local pos1 = inst1:IsA("BasePart") and inst1.Position
                or inst1:FindFirstChild("HumanoidRootPart")
                and inst1.HumanoidRootPart.Position
                or Vector3.zero
    local pos2 = inst2:IsA("BasePart") and inst2.Position
                or inst2:FindFirstChild("HumanoidRootPart")
                and inst2.HumanoidRootPart.Position
                or Vector3.zero
    return (pos1 - pos2).Magnitude
end

-- Get nearest player (obfuscated: gNP)
GG.gNP = function(): (Player?, number?)
    local selff = GG.selff or GG.P and GG.P.LocalPlayer
    if not selff or not selff.Character then
        return nil, math.huge
    end

    local myChar = selff.Character
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then
        return nil, math.huge
    end

    local nearest, nearestDist = nil, math.huge

    for _, player in GG.P:GetPlayers() do
        if player ~= selff and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - myHRP.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = player
                end
            end
        end
    end

    return nearest, nearestDist
end

-- Get nearest to position (obfuscated: gNP2)
GG.gNP2 = function(position: Vector3, ignorePlayer: Player?): (Player?, number?)
    local selff = GG.selff or GG.P and GG.P.LocalPlayer
    if not selff then
        return nil, math.huge
    end

    local nearest, nearestDist = nil, math.huge

    for _, player in GG.P:GetPlayers() do
        if player ~= (ignorePlayer or selff) and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = player
                end
            end
        end
    end

    return nearest, nearestDist
end

------------- Teleport Utilities -------------

-- Teleport to CFrame (obfuscated: tP)
GG.tP = function(character: Model, cf: CFrame)
    local hrp = GG.gHRP(character)
    if hrp then
        hrp.CFrame = cf
    end
end

-- Teleport to player (obfuscated: tPP)
GG.tPP = function(targetPlayer: Player)
    local selff = GG.selff or GG.P and GG.P.LocalPlayer
    if selff and selff.Character and targetPlayer.Character then
        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            GG.tP(selff.Character, targetHRP.CFrame)
        end
    end
end

-- Teleport to position (obfuscated: tPPos)
GG.tPPos = function(pos: Vector3)
    local selff = GG.selff or GG.P and GG.P.LocalPlayer
    if selff and selff.Character then
        GG.tP(selff.Character, CFrame.new(pos))
    end
end

------------- Tween Utilities -------------

-- Simple tween (obfuscated: sT)
GG.sT = function(instance: Instance, duration: number, goal: {[string]: any}): Tween?
    local ts = GG.TS
    if not ts then
        warn("[ScriptLoader V3] TweenService not found")
        return nil
    end

    local info = TweenInfo.new(duration)
    local tween = ts:Create(instance, info, goal)
    tween:Play()
    return tween
end

------------- Cache Management -------------

-- Cache instance by name (obfuscated: cI)
GG.cI = function(name: string, instance: Instance)
    GG.InstanceCache[name] = instance
end

-- Get cached instance (obfuscated: gCI)
GG.gCI = function(name: string): Instance?
    return GG.InstanceCache[name]
end

-- Clear cache (obfuscated: cCl)
GG.cCl = function()
    GG.InstanceCache = {}
end

------------- Misc Utilities -------------

-- Fire all ProximityPrompts in range (obfuscated: fPP)
GG.fPP = function(range: number?)
    range = range or 10
    local myHRP = GG.gHRP()
    if not myHRP then
        return
    end

    local prompts = GG.fAC(game.Workspace, "ProximityPrompt")
    for _, prompt in prompts do
        local part = prompt.Parent
        if part and part:IsA("BasePart") then
            local dist = (part.Position - myHRP.Position).Magnitude
            if dist <= range then
                prompt:Input()
            end
        end
    end
end

-- Refresh character (obfuscated: rC)
GG.rC = function()
    local selff = GG.selff or GG.P and GG.P.LocalPlayer
    if selff then
        local char = selff.Character
        selff.Character = nil
        if char then
            char:Destroy()
        end
    end
end

-- Set walkspeed (obfuscated: sWS)
GG.sWS = function(speed: number)
    local hum = GG.gH()
    if hum then
        hum.WalkSpeed = speed
    end
end

-- Set jump height (obfuscated: sJH)
GG.sJH = function(height: number)
    local hum = GG.gH()
    if hum then
        hum.JumpHeight = height
        hum.JumpPower = height
    end
end

-- Set all (walkspeed + jumppower) (obfuscated: sA)
GG.sA = function(ws: number, jp: number)
    local hum = GG.gH()
    if hum then
        hum.WalkSpeed = ws
        hum.JumpPower = jp
    end
end

------------- Mark Loaded -------------

GG_Maou_instance_loaded = true

------------- Export -------------

return {
    InstanceCache = GG.InstanceCache,
    AssetCache = GG.AssetCache,
}
