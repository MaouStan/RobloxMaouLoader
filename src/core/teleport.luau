---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/init.luau" as GG

-- ScriptLoader V3 - Core Teleport
-- Safe teleport, tween teleport, and utilities

------------- Anti-Reexecute -------------

if not GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Init not loaded")
end

if GG_Maou_teleport_loaded then
    return warn("[ScriptLoader V3] Teleport already loaded")
end

------------- Core References -------------

local TS = GG.TS

------------- Helper: Calculate duration from speed -------------

local function getDurationFromSpeed(targetCF: CFrame, speed: number?): number
    local hrp = GG.gHRP()
    if not hrp then
        return 0.3
    end

    local distance = (targetCF.Position - hrp.Position).Magnitude
    speed = speed or 100  -- studs per second default

    return distance / math.max(speed, 1)
end

--============= SECTION 1: BASIC TELEPORT =============--

------------- Direct Teleport -------------

-- Teleport HRP to CFrame (obfuscated: tpCF)
GG.tpCF = function(cf: CFrame)
    local hrp = GG.gHRP()
    if hrp then
        hrp.CFrame = cf
    end
end

-- Teleport HRP to position (obfuscated: tpPos)
GG.tpPos = function(pos: Vector3)
    local hrp = GG.gHRP()
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
end

-- Teleport HRP to part (obfuscated: tpPart)
GG.tpPart = function(part: BasePart)
    if part then
        GG.tpCF(part.CFrame)
    end
end

-- Teleport HRP to model's primary part (obfuscated: tpModel)
GG.tpModel = function(model: Model)
    if model then
        local p = model.PrimaryPart
        if p then
            GG.tpCF(p.CFrame)
        end
    end
end

-- Teleport HRP to attachment/worldCFrame (obfuscated: tpAttach)
GG.tpAttach = function(attachment: Attachment)
    if attachment then
        GG.tpCF(attachment.WorldCFrame)
    end
end

-- Teleport HRP to position + offset (obfuscated: tpPosOff)
GG.tpPosOff = function(pos: Vector3, offset: Vector3?)
    offset = offset or Vector3.zero
    GG.tpPos(pos + offset)
end

--============= SECTION 2: SAFE TELEPORT =============--

------------- Safe Teleport with Checks -------------

-- Safe teleport (checks if alive, character exists) (obfuscated: stp)
GG.stp = function(cf: CFrame): boolean
    if not GG.isAlive() then
        return false
    end

    local hrp = GG.gHRP()
    if not hrp then
        return false
    end

    hrp.CFrame = cf
    return true
end

-- Safe teleport to part (obfuscated: stpPart)
GG.stpPart = function(part: BasePart): boolean
    if part and GG.isAlive() then
        return GG.stp(part.CFrame)
    end
    return false
end

-- Safe teleport to model (obfuscated: stpModel)
GG.stpModel = function(model: Model): boolean
    if model and model.PrimaryPart then
        return GG.stp(model.PrimaryPart.CFrame + Vector3.new(0, 3, 0))
    end
    return false
end

-- Safe teleport with offset (obfuscated: stpOff)
GG.stpOff = function(pos: Vector3, offset: Vector3?): boolean
    return GG.stp(CFrame.new(pos + (offset or Vector3.zero)))
end

-- Safe teleport with rotation (obfuscated: stpRot)
GG.stpRot = function(pos: Vector3, rotation: Vector3): boolean
    return GG.stp(CFrame.new(pos) * CFrame.Angles(rotation.X, rotation.Y, rotation.Z))
end

-- Safe teleport with lookAt (obfuscated: stpLook)
GG.stpLook = function(pos: Vector3, lookAt: Vector3): boolean
    local cf = CFrame.lookAt(pos, lookAt)
    return GG.stp(cf)
end

-- Safe teleport to player (obfuscated: stpP)
GG.stpP = function(player: Player): boolean
    local theirHRP = GG.gPHRP(player)
    if theirHRP and GG.isAlive() then
        return GG.stp(theirHRP.CFrame)
    end
    return false
end

-- Safe teleport behind player (obfuscated: stpBehindP)
GG.stpBehindP = function(player: Player, distance: number?): boolean
    distance = distance or 5
    local theirHRP = GG.gPHRP(player)

    if theirHRP and GG.isAlive() then
        local behindCF = theirHRP.CFrame * CFrame.new(0, 0, distance)
        return GG.stp(behindCF)
    end
    return false
end

-- Safe teleport in front of player (obfuscated: stpFrontP)
GG.stpFrontP = function(player: Player, distance: number?): boolean
    distance = distance or 5
    local theirHRP = GG.gPHRP(player)

    if theirHRP and GG.isAlive() then
        local frontCF = theirHRP.CFrame * CFrame.new(0, 0, -distance)
        return GG.stp(frontCF)
    end
    return false
end

--============= SECTION 3: TWEEN TELEPORT =============--

------------- Tweened Teleport -------------

-- Tween to CFrame by speed (obfuscated: tpTwe)
GG.tpTwe = function(cf: CFrame, speed: number?): Tween?
    local hrp = GG.gHRP()
    if not hrp or not TS then
        return nil
    end

    local duration = getDurationFromSpeed(cf, speed)
    local info = TweenInfo.new(duration, Enum.EasingStyle.Quad)
    local goals = {CFrame = cf}

    local tween = TS:Create(hrp, info, goals)
    tween:Play()
    return tween
end

-- Tween to position by speed (obfuscated: tpTwePos)
GG.tpTwePos = function(pos: Vector3, speed: number?): Tween?
    return GG.tpTwe(CFrame.new(pos), speed)
end

-- Tween to part by speed (obfuscated: tpTwePart)
GG.tpTwePart = function(part: BasePart, speed: number?): Tween?
    if part then
        return GG.tpTwe(part.CFrame + CFrame.new(0, 0, part.Size.Y / 2), speed)
    end
    return nil
end

-- Tween to player by speed (obfuscated: tpTweP)
GG.tpTweP = function(player: Player, speed: number?): Tween?
    local theirHRP = GG.gPHRP(player)
    if theirHRP then
        return GG.tpTwe(theirHRP.CFrame, speed)
    end
    return nil
end

-- Smooth teleport with easing by speed (obfuscated: sTP)
GG.sTP = function(cf: CFrame, speed: number?, easingStyle: Enum.EasingStyle?, easingDirection: Enum.EasingDirection?): Tween?
    local hrp = GG.gHRP()
    if not hrp or not TS then
        return nil
    end

    local duration = getDurationFromSpeed(cf, speed)
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out

    local info = TweenInfo.new(duration, easingStyle, easingDirection)
    local goals = {CFrame = cf}

    local tween = TS:Create(hrp, info, goals)
    tween:Play()
    return tween
end

------------- Awaited Tween Teleport -------------

-- Teleport and wait for completion by speed (obfuscated: tpAwait)
GG.tpAwait = function(cf: CFrame, speed: number?): boolean
    local tween = GG.sTP(cf, speed)
    if tween then
        tween.Completed:Wait()
        return true
    end
    return false
end

-- Tween to position and wait by speed (obfuscated: tpTwePosAwait)
GG.tpTwePosAwait = function(pos: Vector3, speed: number?): boolean
    return GG.tpAwait(CFrame.new(pos), speed)
end

-- Tween to part and wait by speed (obfuscated: tpTwePartAwait)
GG.tpTwePartAwait = function(part: BasePart, speed: number?): boolean
    if part then
        return GG.tpAwait(part.CFrame, speed)
    end
    return false
end

-- Tween to player and wait by speed (obfuscated: tpTwePAwait)
GG.tpTwePAwait = function(player: Player, speed: number?): boolean
    local theirHRP = GG.gPHRP(player)
    if theirHRP then
        return GG.tpAwait(theirHRP.CFrame, speed)
    end
    return false
end

--============= SECTION 4: UTILITY TELEPORTS =============--

------------- Special Teleport Types -------------

-- Blind teleport (instant, no checks) (obfuscated: bTP)
GG.bTP = function(cf: CFrame)
    GG.tpCF(cf)
end

-- Precise teleport (preserves rotation offset) (obfuscated: pTP)
GG.pTP = function(cf: CFrame)
    local hrp = GG.gHRP()
    if hrp then
        -- Preserve current rotation, only change position
        hrp.CFrame = CFrame.new(cf.Position, hrp.CFrame.LookVector, hrp.CFrame.UpVector)
    end
end

-- Relative teleport (offset from current) (obfuscated: rTP)
GG.rTP = function(offset: Vector3)
    local hrp = GG.gHRP()
    if hrp then
        hrp.CFrame = hrp.CFrame + offset
    end
end

-- Offset teleport (add position) (obfuscated: oTP)
GG.oTP = function(pos: Vector3)
    local hrp = GG.gHRP()
    if hrp then
        hrp.CFrame = hrp.CFrame + CFrame.new(pos)
    end
end

-- Rotate teleport (only change rotation) (obfuscated: rotTP)
GG.rotTP = function(rot: Vector3)
    local hrp = GG.gHRP()
    if hrp then
        hrp.CFrame = CFrame.new(hrp.Position, hrp.CFrame:ToWorldSpace(CFrame.Angles(rot)):ToEulerAngles())
    end
end

-- Look at teleport (face position) (obfuscated: lookTP)
GG.lookTP = function(target: Vector3)
    local hrp = GG.gHRP()
    if hrp then
        hrp.CFrame = CFrame.new(hrp.Position, target)
    end
end

-- Look at part teleport (obfuscated: lookTPart)
GG.lookTPart = function(part: Instance)
    if part then
        GG.lookTP(part.Position)
    end
end

------------- Waypoint Teleport -------------

-- Create waypoint system by speed (obfuscated: wpSys)
GG.wpSys = function(waypoints: {Vector3}, index: number, speed: number?): Tween?
    speed = speed or 100

    if index < 1 or index > #waypoints then
        return nil
    end

    return GG.tpTwePos(waypoints[index], speed)
end

-- Teleport through all waypoints by speed (obfuscated: wpAll)
GG.wpAll = function(waypoints: {Vector3}, speed: number?): boolean
    for i, wp in waypoints do
        local tween = GG.tpTwePos(wp, speed)
        if tween then
            tween.Completed:Wait()
        end
    end
    return true
end

------------- Loop Teleport -------------

-- Loop teleport (for bypassing some detections) (obfuscated: lTP)
GG.lTP = function(cf: CFrame, loops: number?): boolean
    loops = loops or 3
    for i = 1, loops do
        GG.tpCF(cf)
        wait()
    end
    return true
end

------------- Flash Teleport -------------

-- Flash teleport (teleport back and forth quickly) (obfuscated: flashTP)
GG.flashTP = function(targetCF: CFrame, delay: number?): boolean
    delay = delay or 0.1
    local hrp = GG.gHRP()
    if not hrp then
        return false
    end

    local originalCF = hrp.CFrame
    GG.tpCF(targetCF)
    wait(delay)
    GG.tpCF(originalCF)
    return true
end

------------- Mark Loaded -------------

GG_Maou_teleport_loaded = true

------------- Export -------------

return {
    tpCF = GG.tpCF,
    tpPos = GG.tpPos,
    tpPart = GG.tpPart,
    tpModel = GG.tpModel,
    stp = GG.stp,
    sTP = GG.sTP,
    tpAwait = GG.tpAwait,
}
