---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/init.luau" as GG

-- ScriptLoader V3 - Core Player
-- LocalPlayer and Players utilities

------------- Anti-Reexecute -------------

if not GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Init not loaded")
end

if GG_Maou_player_loaded then
    return warn("[ScriptLoader V3] Player already loaded")
end

--============= SECTION 1: LOCAL PLAYER =============--

------------- LocalPlayer Reference -------------

GG.LP = GG.P and GG.P.LocalPlayer
GG.selff = GG.LP  -- Alias

------------- Character Access -------------

-- Get character (obfuscated: gC)
GG.gC = function(): Model?
    return GG.LP and GG.LP.Character
end

-- Get character or wait (obfuscated: gCW)
GG.gCW = function(): Model
    return GG.LP and (GG.LP.Character or GG.LP.CharacterAdded:Wait())
end

-- WaitFor character load (obfuscated: wC)
GG.wC = function(): Model
    return GG.LP.CharacterAdded:Wait()
end

------------- Character Parts -------------

-- Get Humanoid (obfuscated: gH)
GG.gH = function(): Humanoid?
    local char = GG.gC()
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Get HumanoidRootPart (obfuscated: gHRP)
GG.gHRP = function(): BasePart?
    local char = GG.gC()
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- Get RootPart (RootJoint or Root) (obfuscated: gR)
GG.gR = function(): Instance?
    local char = GG.gC()
    if char then
        return char:FindFirstChild("RootJoint") or char:FindFirstChild("Root")
    end
    return nil
end

-- Get HumanoidRootPart (alias) (obfuscated: gRP)
GG.gRP = GG.gHRP

-- Get Torso (obfuscated: gT)
GG.gT = function(): BasePart?
    local char = GG.gC()
    if char then
        return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    end
    return nil
end

-- Get Head (obfuscated: gHe)
GG.gHe = function(): BasePart?
    local char = GG.gC()
    if char then
        return char:FindFirstChild("Head")
    end
    return nil
end

-- Get Left Arm (obfuscated: gLA)
GG.gLA = function(): BasePart?
    local char = GG.gC()
    if char then
        return char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand")
    end
    return nil
end

-- Get Right Arm (obfuscated: gRA)
GG.gRA = function(): BasePart?
    local char = GG.gC()
    if char then
        return char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
    end
    return nil
end

-- Get Left Leg (obfuscated: gLL)
GG.gLL = function(): BasePart?
    local char = GG.gC()
    if char then
        return char:FindFirstChild("Left Leg")
    end
    return nil
end

-- Get Right Leg (obfuscated: gRL)
GG.gRL = function(): BasePart?
    local char = GG.gC()
    if char then
        return char:FindFirstChild("Right Leg")
    end
    return nil
end

-- Get all body parts (obfuscated: gParts)
GG.gParts = function(): {BasePart}
    local parts = {}
    local char = GG.gC()
    if char then
        for _, v in char:GetChildren() do
            if v:IsA("BasePart") then
                table.insert(parts, v)
            end
        end
    end
    return parts
end

------------- Character State -------------

-- Check if alive (obfuscated: isAlive)
GG.isAlive = function(): boolean
    local hum = GG.gH()
    return hum ~= nil and hum.Health > 0
end

-- Get health (obfuscated: gHP)
GG.gHP = function(): number
    local hum = GG.gH()
    return hum and hum.Health or 0
end

-- Get max health (obfuscated: gMaxHP)
GG.gMaxHP = function(): number
    local hum = GG.gH()
    return hum and hum.MaxHealth or 0
end

-- Get health percentage (obfuscated: gHPP)
GG.gHPP = function(): number
    local hum = GG.gH()
    if hum then
        return (hum.Health / hum.MaxHealth) * 100
    end
    return 0
end

-- Get walkspeed (obfuscated: gWS)
GG.gWS = function(): number
    local hum = GG.gH()
    return hum and hum.WalkSpeed or 0
end

-- Get jump power (obfuscated: gJP)
GG.gJP = function(): number
    local hum = GG.gH()
    return hum and hum.JumpPower or 0
end

-- Get position (obfuscated: gPos)
GG.gPos = function(): Vector3
    local hrp = GG.gHRP()
    return hrp and hrp.Position or Vector3.zero
end

-- Get CFrame (obfuscated: gCF)
GG.gCF = function(): CFrame
    local hrp = GG.gHRP()
    return hrp and hrp.CFrame or CFrame.new()
end

------------- Tools & Equipment -------------

-- Get backpack (obfuscated: gBP)
GG.gBP = function(): Backpack?
    return GG.LP and GG.LP:FindFirstChild("Backpack")
end

-- Get character tools (obfuscated: gCTools)
GG.gCTools = function(): {Tool}
    local tools = {}
    local char = GG.gC()
    if char then
        for _, v in char:GetChildren() do
            if v:IsA("Tool") then
                table.insert(tools, v)
            end
        end
    end
    return tools
end

-- Get all tools (backpack + character) (obfuscated: gATools)
GG.gATools = function(): {Tool}
    local tools = GG.gCTools()
    local bp = GG.gBP()
    if bp then
        for _, v in bp:GetChildren() do
            if v:IsA("Tool") then
                table.insert(tools, v)
            end
        end
    end
    return tools
end

-- Find tool by name (obfuscated: fTool)
GG.fTool = function(name: string): Tool?
    local tools = GG.gATools()
    for _, tool in tools do
        if tool.Name == name then
            return tool
        end
    end
    return nil
end

-- Equip tool (obfuscated: eTool)
GG.eTool = function(tool: Tool): boolean
    local hum = GG.gH()
    if hum then
        -- Check if already equipped
        local char = GG.gC()
        if tool.Parent == char then
            return true
        end
        hum:EquipTool(tool)
        return true
    end
    return false
end

-- Equip tool by name (obfuscated: eToolName)
GG.eToolName = function(name: string): boolean
    local tool = GG.fTool(name)
    if tool then
        return GG.eTool(tool)
    end
    return false
end

-- Unequip current tool (obfuscated: uTool)
GG.uTool = function()
    local hum = GG.gH()
    if hum then
        hum:UnequipTools()
    end
end

-- Unequip all tools (obfuscated: uTools)
GG.uTools = function()
    local hum = GG.gH()
    if hum then
        hum:UnequipTools()
    end
end

------------- Camera & Mouse -------------

-- Get camera (obfuscated: gCam)
GG.gCam = function(): Camera
    return workspace.CurrentCamera
end

-- Get mouse (obfuscated: gM)
GG.gM = function(): Mouse
    return GG.LP and GG.LP:GetMouse()
end

-- Get mouse hit (obfuscated: gMHit)
GG.gMHit = function(): Instance?
    local mouse = GG.gM()
    return mouse and mouse.Hit
end

-- Get mouse target (obfuscated: gMTarget)
GG.gMTarget = function(): Instance?
    local mouse = GG.gM()
    return mouse and mouse.Target
end

--============= SECTION 2: MULTIPLAYER =============--

------------- Players Reference -------------

GG.Players = game:GetService("Players")

------------- Player Finding -------------

-- Get player by name (obfuscated: gP)
GG.gP = function(name: string): Player?
    for _, player in GG.Players:GetPlayers() do
        if player.Name == name or player.DisplayName == name then
            return player
        end
    end
    return nil
end

-- Get player by userId (obfuscated: gPId)
GG.gPId = function(userId: number): Player?
    for _, player in GG.Players:GetPlayers() do
        if player.UserId == userId then
            return player
        end
    end
    return nil
end

-- Get player by DisplayName (obfuscated: gPDN)
GG.gPDN = function(displayName: string): Player?
    for _, player in GG.Players:GetPlayers() do
        if player.DisplayName == displayName then
            return player
        end
    end
    return nil
end

-- Get all players except self (obfuscated: gPOthers)
GG.gPOthers = function(): {Player}
    local others = {}
    for _, player in GG.Players:GetPlayers() do
        if player ~= GG.LP then
            table.insert(others, player)
        end
    end
    return others
end

-- Get player count (obfuscated: gPCount)
GG.gPCount = function(): number
    return #GG.Players:GetPlayers()
end

------------- Character Utilities (Multiplayer) -------------

-- Get player character (obfuscated: gPC)
GG.gPC = function(player: Player): Model?
    return player and player.Character
end

-- Get player Humanoid (obfuscated: gPH)
GG.gPH = function(player: Player): Humanoid?
    local char = GG.gPC(player)
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Get player HRP (obfuscated: gPHRP)
GG.gPHRP = function(player: Player): BasePart?
    local char = GG.gPC(player)
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- Check if player alive (obfuscated: isPAlive)
GG.isPAlive = function(player: Player): boolean
    local hum = GG.gPH(player)
    return hum ~= nil and hum.Health > 0
end

-- Get player health (obfuscated: gPHP)
GG.gPHP = function(player: Player): number
    local hum = GG.gPH(player)
    return hum and hum.Health or 0
end

------------- Distance Utilities -------------

-- Get distance to player (obfuscated: gDistP)
GG.gDistP = function(player: Player): number
    local myHRP = GG.gHRP()
    local theirHRP = GG.gPHRP(player)

    if myHRP and theirHRP then
        return (theirHRP.Position - myHRP.Position).Magnitude
    end
    return math.huge
end

-- Get distance between two players (obfuscated: gDistPP)
GG.gDistPP = function(player1: Player, player2: Player): number
    local hrp1 = GG.gPHRP(player1)
    local hrp2 = GG.gPHRP(player2)

    if hrp1 and hrp2 then
        return (hrp2.Position - hrp1.Position).Magnitude
    end
    return math.huge
end

-- Get distance to position (obfuscated: gDistPos)
GG.gDistPos = function(position: Vector3): number
    local myHRP = GG.gHRP()
    if myHRP then
        return (position - myHRP.Position).Magnitude
    end
    return math.huge
end

-- Get nearest player (obfuscated: gNP)
GG.gNP = function(): (Player?, number?)
    local myHRP = GG.gHRP()
    if not myHRP then
        return nil, math.huge
    end

    local nearest, nearestDist = nil, math.huge

    for _, player in GG.Players:GetPlayers() do
        if player ~= GG.LP then
            local dist = GG.gDistP(player)
            if dist < nearestDist then
                nearestDist = dist
                nearest = player
            end
        end
    end

    return nearest, nearestDist
end

-- Get nearest player to position (obfuscated: gNPPos)
GG.gNPPos = function(position: Vector3, ignorePlayer: Player?): (Player?, number?)
    local nearest, nearestDist = nil, math.huge

    for _, player in GG.Players:GetPlayers() do
        if player ~= (ignorePlayer or GG.LP) then
            local theirHRP = GG.gPHRP(player)
            if theirHRP then
                local dist = (theirHRP.Position - position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = player
                end
            end
        end
    end

    return nearest, nearestDist
end

-- Get players in range (obfuscated: gPInRange)
GG.gPInRange = function(range: number): {Player}
    local inRange = {}
    local myHRP = GG.gHRP()

    if not myHRP then
        return inRange
    end

    for _, player in GG.Players:GetPlayers() do
        if player ~= GG.LP then
            local dist = GG.gDistP(player)
            if dist <= range then
                table.insert(inRange, player)
            end
        end
    end

    return inRange
end

-- Get players out of range (obfuscated: gPOutRange)
GG.gPOutRange = function(range: number): {Player}
    local outRange = {}
    local myHRP = GG.gHRP()

    if not myHRP then
        return outRange
    end

    for _, player in GG.Players:GetPlayers() do
        if player ~= GG.LP then
            local dist = GG.gDistP(player)
            if dist > range then
                table.insert(outRange, player)
            end
        end
    end

    return outRange
end

------------- Teleport (Multiplayer) -------------

-- Teleport to player (obfuscated: tToP)
GG.tToP = function(targetPlayer: Player)
    local myHRP = GG.gHRP()
    local theirHRP = GG.gPHRP(targetPlayer)

    if myHRP and theirHRP then
        myHRP.CFrame = theirHRP.CFrame
    end
end

-- Teleport to player CFrame (obfuscated: tToPCF)
GG.tToPCF = function(targetPlayer: Player)
    local myHRP = GG.gHRP()
    local theirHRP = GG.gPHRP(targetPlayer)

    if myHRP and theirHRP then
        myHRP.CFrame = CFrame.new(theirHRP.Position + theirHRP.CFrame.LookVector * 3, theirHRP.Position)
    end
end

-- Teleport behind player (obfuscated: tBehindP)
GG.tBehindP = function(targetPlayer: Player, distance: number?)
    distance = distance or 5
    local theirHRP = GG.gPHRP(targetPlayer)

    if theirHRP then
        local behindCF = theirHRP.CFrame * CFrame.new(0, 0, distance)
        local myHRP = GG.gHRP()
        if myHRP then
            myHRP.CFrame = behindCF
        end
    end
end

-- Bring player to you (obfuscated: bPToMe)
GG.bPToMe = function(targetPlayer: Player)
    local myHRP = GG.gHRP()
    local theirHRP = GG.gPHRP(targetPlayer)

    if myHRP and theirHRP then
        theirHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, 3)
    end
end

------------- Team Utilities -------------

-- Get player team (obfuscated: gPTeam)
GG.gPTeam = function(player: Player): Team
    return player and player.Team
end

-- Get team color (obfuscated: gPTeamColor)
GG.gPTeamColor = function(player: Player): BrickColor
    return player and player.TeamColor
end

-- Is on same team (obfuscated: isSameTeam)
GG.isSameTeam = function(player: Player): boolean
    return player.Team == GG.LP.Team
end

-- Get teammates (obfuscated: gTeamMates)
GG.gTeamMates = function(): {Player}
    local myTeam = GG.LP.Team
    local teammates = {}

    for _, player in GG.Players:GetPlayers() do
        if player.Team == myTeam then
            table.insert(teammates, player)
        end
    end

    return teammates
end

-- Get enemies (obfuscated: gEnemies)
GG.gEnemies = function(): {Player}
    local myTeam = GG.LP.Team
    local enemies = {}

    for _, player in GG.Players:GetPlayers() do
        if player.Team ~= myTeam then
            table.insert(enemies, player)
        end
    end

    return enemies
end

------------- Mark Loaded -------------

GG_Maou_player_loaded = true

------------- Export -------------

return {
    LP = GG.LP,
    gC = GG.gC,
    gH = GG.gH,
    gHRP = GG.gHRP,
    gNP = GG.gNP,
}
