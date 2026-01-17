---@import "D:/Cluade-V2/ψ/incubate/RobloxV2/Utils/ScriptLoader/src/core/init.luau" as GG

-- ScriptLoader V3 - Player Module
-- Player utilities: Fly, Noclip, and more

------------- Anti-Reexecute -------------

if not GG_Maou_init_loaded then
    return warn("[ScriptLoader V3] Init not loaded")
end

if not GG.PL then
    GG.PL = {} -- Player Module Namespace
end

if GG.PL.loaded then
    return warn("[ScriptLoader V3] Player Module already loaded")
end

------------- Services (Cached from GG) -------------

local Players = GG.gS("Players")
local RunService = GG.gS("RunService")
local UserInputService = GG.gS("UserInputService")
local Workspace = GG.Workspace or workspace

local LP = Players.LocalPlayer
local tk = GG.tk or task -- cached task from core/task.luau

------------- State -------------

GG.PL.state = {
    flying = false,
    flyingVehicle = false,
    noclip = false,
    flySpeed = 1,
    vFlySpeed = 1,
    qeFly = true,
}

------------- SECTION 1: NOCLIP -------------

local Noclipping = nil
local floatName = "ScriptLoaderFloat"

-- Noclip loop (obfuscated: noclipLoop)
local function noclipLoop()
    if GG.PL.state.noclip and LP.Character then
        for _, child in LP.Character:GetDescendants() do
            if child:IsA("BasePart") and child.CanCollide and child.Name ~= floatName then
                child.CanCollide = false
            end
        end
    end
end

-- Toggle noclip (obfuscated: toggleNoclip)
GG.PL.toggleNoclip = function(): boolean
    GG.PL.state.noclip = not GG.PL.state.noclip

    if GG.PL.state.noclip then
        -- Enable noclip
        if Noclipping then
            Noclipping:Disconnect()
        end
        Noclipping = RunService.Stepped:Connect(noclipLoop)
        return true
    else
        -- Disable noclip
        if Noclipping then
            Noclipping:Disconnect()
            Noclipping = nil
        end
        -- Restore collision
        if LP.Character then
            for _, child in LP.Character:GetDescendants() do
                if child:IsA("BasePart") then
                    child.CanCollide = true
                end
            end
        end
        return false
    end
end

-- Enable noclip (obfuscated: enableNoclip)
GG.PL.enableNoclip = function()
    if not GG.PL.state.noclip then
        GG.PL.toggleNoclip()
    end
end

-- Disable noclip (obfuscated: disableNoclip)
GG.PL.disableNoclip = function()
    if GG.PL.state.noclip then
        GG.PL.toggleNoclip()
    end
end

-- Check if noclip enabled (obfuscated: isNoclip)
GG.PL.isNoclip = function(): boolean
    return GG.PL.state.noclip
end

------------- SECTION 2: FLY -------------

local flyKeyDown = nil
local flyKeyUp = nil
local BodyGyro = nil
local BodyVelocity = nil

local function getRoot()
    local char = LP.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("RootPart") or char:FindFirstChild("Torso")
    end
    return nil
end

-- Start fly (obfuscated: startFly)
GG.PL.startFly = function(isVehicle: boolean?)
    isVehicle = isVehicle or false

    if GG.PL.state.flying then
        GG.PL.stopFly()
    end

    tk.wait()

    local char = LP.Character or LP.CharacterAdded:Wait()
    local root = getRoot()
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if not root then
        return warn("[ScriptLoader V3] No root part found")
    end

    -- Disconnect existing
    if flyKeyDown then
        flyKeyDown:Disconnect()
        flyKeyUp:Disconnect()
    end

    GG.PL.state.flying = true
    GG.PL.state.flyingVehicle = isVehicle

    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0
    local camera = Workspace.CurrentCamera

    -- Create body movers
    BodyGyro = GG.Inst.new("BodyGyro")
    BodyVelocity = GG.Inst.new("BodyVelocity")

    BodyGyro.P = 9e4
    BodyGyro.Parent = root
    BodyVelocity.Parent = root
    BodyGyro.MaxTorque = GG.V3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = root.CFrame
    BodyVelocity.Velocity = GG.V3.new(0, 0, 0)
    BodyVelocity.MaxForce = GG.V3.new(9e9, 9e9, 9e9)

    -- Fly loop
    tk.spawn(function()
        repeat
            tk.wait()
            camera = Workspace.CurrentCamera

            if not isVehicle and humanoid then
                humanoid.PlatformStand = true
            end

            if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                SPEED = 50
            elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                SPEED = 0
            end

            if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                BodyVelocity.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * GG.CFr.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
            elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                BodyVelocity.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * GG.CFr.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + lCONTROL.Q + lCONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
            else
                BodyVelocity.Velocity = GG.V3.new(0, 0, 0)
            end

            BodyGyro.CFrame = camera.CFrame
        until not GG.PL.state.flying
    end)

    -- Input handling
    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end

        local speed = isVehicle and GG.PL.state.vFlySpeed or GG.PL.state.flySpeed

        if input.KeyCode == Enum.KeyCode.W then
            CONTROL.F = speed
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL.B = -speed
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL.L = -speed
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL.R = speed
        elseif input.KeyCode == Enum.KeyCode.E and GG.PL.state.qeFly then
            CONTROL.Q = speed * 2
        elseif input.KeyCode == Enum.KeyCode.Q and GG.PL.state.qeFly then
            CONTROL.E = -speed * 2
        end
        pcall(function()
            camera.CameraType = Enum.CameraType.Track
        end)
    end)

    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.W then
            CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then
            CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then
            CONTROL.E = 0
        end
    end)
end

-- Stop fly (obfuscated: stopFly)
GG.PL.stopFly = function()
    GG.PL.state.flying = false
    GG.PL.state.flyingVehicle = false

    if flyKeyDown then
        flyKeyDown:Disconnect()
        flyKeyUp:Disconnect()
        flyKeyDown = nil
        flyKeyUp = nil
    end

    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end

    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end

    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end

    pcall(function()
        Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end)
end

-- Toggle fly (obfuscated: toggleFly)
GG.PL.toggleFly = function(isVehicle: boolean?): boolean
    isVehicle = isVehicle or false

    if GG.PL.state.flying then
        GG.PL.stopFly()
        return false
    else
        GG.PL.startFly(isVehicle)
        return true
    end
end

-- Set fly speed (obfuscated: setFlySpeed)
GG.PL.setFlySpeed = function(speed: number)
    GG.PL.state.flySpeed = speed
end

-- Set vehicle fly speed (obfuscated: setVFlySpeed)
GG.PL.setVFlySpeed = function(speed: number)
    GG.PL.state.vFlySpeed = speed
end

-- Set QE fly enabled (obfuscated: setQEFly)
GG.PL.setQEFly = function(enabled: boolean)
    GG.PL.state.qeFly = enabled
end

-- Check if flying (obfuscated: isFlying)
GG.PL.isFlying = function(): boolean
    return GG.PL.state.flying
end

------------- SECTION 3: UTILITY FUNCTIONS -------------

-- Teleport to position (obfuscated: tpTo)
GG.PL.tpTo = function(position: Vector3, offsetCFrame: CFrame?)
    local root = getRoot()
    if root then
        root.CFrame = offsetCFrame and CFrame.new(position) + offsetCFrame.Position or CFrame.new(position)
    end
end

-- Teleport to CFrame (obfuscated: tpToCF)
GG.PL.tpToCF = function(cframe: CFrame)
    local root = getRoot()
    if root then
        root.CFrame = cframe
    end
end

-- Teleport player to you (obfuscated: bringPlayer)
GG.PL.bringPlayer = function(targetPlayer: Player)
    local myRoot = getRoot()
    local targetChar = targetPlayer.Character
    local targetRoot = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso"))

    if myRoot and targetRoot then
        targetRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, 3)
    end
end

-- Set walk speed (obfuscated: setWS)
GG.PL.setWS = function(speed: number)
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

-- Set jump power (obfuscated: setJP)
GG.PL.setJP = function(power: number)
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = power
    end
end

-- Set jump height (obfuscated: setJH)
GG.PL.setJH = function(height: number)
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = false
        humanoid.JumpHeight = height
    end
end

-- Get all players except self (obfuscated: getOthers)
GG.PL.getOthers = function(): {Player}
    local others = {}
    for _, player in Players:GetPlayers() do
        if player ~= LP then
            table.insert(others, player)
        end
    end
    return others
end

-- Get nearest player (obfuscated: getNearest)
GG.PL.getNearest = function(): (Player?, number?)
    local myRoot = getRoot()
    if not myRoot then
        return nil, math.huge
    end

    local nearest, nearestDist = nil, math.huge

    for _, player in Players:GetPlayers() do
        if player ~= LP then
            local char = player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
            if root then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = player
                end
            end
        end
    end

    return nearest, nearestDist
end

-- Get players in range (obfuscated: getInRange)
GG.PL.getInRange = function(range: number): {Player}
    local inRange = {}
    local myRoot = getRoot()

    if not myRoot then
        return inRange
    end

    for _, player in Players:GetPlayers() do
        if player ~= LP then
            local char = player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
            if root then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist <= range then
                    table.insert(inRange, player)
                end
            end
        end
    end

    return inRange
end

------------- Character Added Cleanup -------------

LP.CharacterAdded:Connect(function(character)
    -- Re-enable noclip if it was active
    if GG.PL.state.noclip then
        tk.wait(0.5)
        for _, child in character:GetDescendants() do
            if child:IsA("BasePart") and child.Name ~= floatName then
                child.CanCollide = false
            end
        end
    end

    -- Stop fly if active
    if GG.PL.state.flying then
        GG.PL.stopFly()
    end
end)

------------- Mark Loaded -------------

GG.PL.loaded = true

------------- Export -------------

return {
    -- Noclip
    toggleNoclip = GG.PL.toggleNoclip,
    enableNoclip = GG.PL.enableNoclip,
    disableNoclip = GG.PL.disableNoclip,
    isNoclip = GG.PL.isNoclip,

    -- Fly
    startFly = GG.PL.startFly,
    stopFly = GG.PL.stopFly,
    toggleFly = GG.PL.toggleFly,
    setFlySpeed = GG.PL.setFlySpeed,
    setVFlySpeed = GG.PL.setVFlySpeed,
    setQEFly = GG.PL.setQEFly,
    isFlying = GG.PL.isFlying,

    -- Utility
    tpTo = GG.PL.tpTo,
    tpToCF = GG.PL.tpToCF,
    bringPlayer = GG.PL.bringPlayer,
    setWS = GG.PL.setWS,
    setJP = GG.PL.setJP,
    setJH = GG.PL.setJH,
    getOthers = GG.PL.getOthers,
    getNearest = GG.PL.getNearest,
    getInRange = GG.PL.getInRange,

    -- State
    state = GG.PL.state,
}
