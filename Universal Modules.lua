--[[

$$\      $$\ $$$$$$$$\                              ~
$$$\    $$$ |$$  _____|                              
$$$$\  $$$$ |$$ |       $$$$$$\   $$$$$$\   $$$$$$\  
$$\$$\$$ $$ |$$$$$\    $$  __$$\ $$  __$$\ $$  __$$\ 
$$ \$$$  $$ |$$  __|   $$$$$$$$ |$$$$$$$$ |$$$$$$$$ |
$$ |\$  /$$ |$$ |      $$   ____|$$   ____|$$   ____|
$$ | \_/ $$ |$$ |      \$$$$$$$\ \$$$$$$$\ \$$$$$$$\ 
\__|     \__|\__|       \_______| \_______| \_______| 

Creator |    MaiFengYXD or MikeFeng
License |       CC0-1.0
Version | Stable 0.0.9f

# Project Started on 2024-11-13 #
# This Version was Last Edited on 2025-03-21 #

Issues Report on Github or https://discord.gg/YBQUd8X8PK
QQ: 3607178523

]]--



--|| Variables ||--

--// Services and Modules \\--
UniversalModules = {}
LockConnections = {}
local Cloneref, Compare = cloneref or function(...) return ... end, compareinstances or function(A, B) return A == B end
local Workspace = Cloneref(game:GetService("Workspace"))
local Players = Cloneref(game:GetService("Players"))
local RunService = Cloneref(game:GetService("RunService"))
local UserInputService = Cloneref(game:GetService("UserInputService"))
local Lighting = Cloneref(game:GetService("Lighting"))
local GuiService = Cloneref(game:GetService("GuiService"))
local ProximityPromptService = Cloneref(game:GetService("ProximityPromptService"))
local ContextActionService = Cloneref(game:GetService("ContextActionService"))
local Heartbeat = RunService.Heartbeat
local RenderStepped = RunService.RenderStepped
local Stepped = RunService.Stepped
local Inf, Unloaded = (1 / 0) -- In Luau: (1 / 0) is 7.8x faster than math.huge in 100000000 loops.

--// Movement and Camera Settings \\--
local Speaker = Players.LocalPlayer
local Humanoid = Speaker.Character and Speaker.Character:FindFirstChild("Humanoid")
local Camera = Workspace.CurrentCamera
LockConnections.CC = (LockConnections.CC and LockConnections.CC:Disconnect()) or Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

--// Current Camera Series \\--
CurrentMovement = Speaker.DevComputerMovementMode
CurrentFOV = Camera.FieldOfView
CurrentMaxZoom = Speaker.CameraMaxZoomDistance
CurrentMinZoom = Speaker.CameraMinZoomDistance
CurrentCameraMode = Speaker.CameraMode
CurrentCameraOcclusionMode = Speaker.DevCameraOcclusionMode
CurrentShiftLock = Speaker.DevEnableMouseLock
CurrentCameraModePC = Speaker.DevComputerCameraMode
CurrentCameraModeMobile = Speaker.DevTouchCameraMode
CurrentCameraSubject = Camera.CameraSubject

--// Moded Camera Series \\--
ModedFOV = CurrentFOV
ModedMaxZoom = CurrentMaxZoom
ModedMinZoom = CurrentMinZoom

--// Current Lighting Series \\--
CurrentAmbient = Lighting.Ambient
CurrentBrightness = Lighting.Brightness
CurrentClockTime = Lighting.ClockTime
CurrentOutdoorAmbient = Lighting.OutdoorAmbient
CurrentColorShiftBottom = Lighting.ColorShift_Bottom
CurrentColorShiftTop = Lighting.ColorShift_Top
CurrentDiffuseScale = Lighting.EnvironmentDiffuseScale
CurrentSpecularScale = Lighting.EnvironmentSpecularScale
CurrentShadowSoftness = Lighting.ShadowSoftness
CurrentFogEnd = Lighting.FogEnd
CurrentFogStart = Lighting.FogStart
CurrentTechnology = Lighting.Technology
CurrentGeographicLatitude = Lighting.GeographicLatitude

--// Moded Lighting Series \\--
ModedAmbient = CurrentAmbient
ModedBrightness = CurrentBrightness
ModedClockTime = CurrentClockTime
ModedOutdoorAmbient = CurrentOutdoorAmbient
ModedColorShiftBottom = CurrentColorShiftBottom
ModedColorShiftTop = CurrentColorShiftTop
ModedDiffuseScale = CurrentDiffuseScale
ModedSpecularScale = CurrentSpecularScale
ModedShadowSoftness = CurrentShadowSoftness
ModedTechnology = CurrentTechnology
ModedGeographicLatitude = CurrentGeographicLatitude

--// Game Mechanics \\--
CurrentWalkSpeed = Speaker and Humanoid and Humanoid.WalkSpeed or 16
CurrentJumpPower = Speaker and Humanoid and Humanoid.JumpPower or 50
CurrentMaxSlopeAngle = Speaker and Humanoid and Humanoid.MaxSlopeAngle or 89
CurrentHipHeight = Speaker and Humanoid and Humanoid.HipHeight or 2.25
PlayerCurrentScale = Speaker and Speaker.Character and Speaker.Character:GetScale() or 1
PlayerTargetScale = PlayerCurrentScale
CurrentGravity = Workspace.Gravity
CurrentVoid = Workspace.FallenPartsDestroyHeight

--// Moded Game Mechanics \\--
ModedWalkSpeed = CurrentWalkSpeed
ModedJumpPower = CurrentJumpPower
ModedGravity = CurrentGravity
ModedMaxSlopeAngle = CurrentMaxSlopeAngle
ModedHipHeight = CurrentHipHeight
TPWalkSpeed = 10

--// AFK Settings \\--
AFKMouseClick1 = false
AFKMouseClick2 = false
AFKMousemoveabs = false
AFKMousemoverel = true
AFKTime = 15
AFKTimes = 0

--// Mouse and Target FPS \\--
FPSOK, FPSFAILD = pcall(function()
    UniversalModules.CurrentFPS = getfpscap()
end)
if FPSFAILD then
    UniversalModules.CurrentFPS = 240
end

local Mouse = Speaker:GetMouse()
TargetFPS = UniversalModules.CurrentFPS

--// Flying Mode \\--
UniversalModules.Flying = false
VFly = false
SitFly = false
LeftControlDown = false
QEFly = true
UseFlyGyro = true
StopFlyOnDied = true
UseUpVector = true
SmoothGyro = true
SmartFly = true
SmoothGyroValue = 500
FlySpeed = 32
VerticalFlySpeedMultiplier = 1

--// Constraints Fly Configure \\--
UseConstraintsFly = false
LookToCamera = true
ConstraintsAcceleration = 7.5
ConstraintsMaxSpeed = 32
ConstraintsTurnSpeed = 6
ConstraintsResponsiveness = 100
ConstraintsFlyingState = 18

--// Fling Settings \\--
InvisibleRunning = false
Flinging = false
WalkFlinging = false
InvisFlinging = false
InvisFlinged = false
AntiFlingMethod = 3
AntiFlingNoclipParts = {}

--// Identify Device \\--
local Device = GuiService:IsTenFootInterface() and "Console" or UserInputService.TouchEnabled and not UserInputService.MouseEnabled and "Mobile" or "PC"

--// Game Flag \\--
local Weaponry = game.PlaceId == 3297964905

--|| Environment Test ||--

local Hook = hookfunction or replaceclosure
if not (getgenv().MFeeeLoaded or getgenv().MFeeeLoading) then
    CanHookMM = pcall(function()
        local Object = setmetatable({}, {
            __index = newcclosure(function()
                return false
            end),
            __metatable = "Locked!"
        })
        local Reference = hookmetamethod(Object, "__index", function()
            return true
        end)
        assert(Object.Test == true and Reference() == false)
    end)

    CanFirePP = pcall(function()
        local Prompt = Instance.new("ProximityPrompt", Workspace)
        Prompt.Triggered:Once(function()
            Prompt = Prompt:Destroy() or true
        end)
        fireproximityprompt(Prompt)
        assert(task.wait(.1) and Prompt)
    end)

    CanGetCons = pcall(function()
        local Types = {
            Enabled = "boolean",
            ForeignState = "boolean",
            LuaConnection = "boolean",
            Function = "function",
            Thread = "thread",
            Fire = "function",
            Defer = "function",
            Disconnect = "function",
            Disable = "function",
            Enable = "function",
        }
        local Bindable = Instance.new("BindableEvent")
        Bindable.Event:Once(function() end)
        local Connection = GetConnections(Bindable.Event)[1]
        for i, v in pairs(Types) do
            assert(Connection[i] ~= nil and type(Connection[i]) == v)
        end
    end)

    CanGetNM = pcall(function()
        pcall(function()
            game:MFeee()
        end)
        assert(getnamecallmethod() == "MFeee")
    end)

    CanHookFunc = pcall(function()
        local function Original()
            return true
        end
        local Reference = Hook(Original, function()
            return false
        end)
        assert(Original() == false and Reference() == true and Original ~= Reference)
    end)

    CanCP = pcall(function()
        local Part = Instance.new("Part")
        local Clone = Cloneref(Part)
        assert(Part ~= Clone, GlobalText.EnvTestFail.CP1)
        assert(Compare(Part, Clone), GlobalText.EnvTestFail.CP2)
    end)

    CanIDCC = pcall(function()
        assert(not iscclosure(print) and iscclosure(function() end))
    end)

    CanNewCC = pcall(function()
        local function Original()
            return true
        end
        local Closure = newcclosure(Original)
        assert(Closure() == true and Original ~= Closure and iscclosure(Closure))
    end)
end
local NewCC = CanNewCC and newcclosure or function(Function) return Function end

--|| Easing Functions ||--

local function CubicEaseIn(Time)
    local Time = math.max(0, math.min(1, Time))
    return Time ^ 3
end

local function CubicEaseOut(Time)
    local Time = math.max(0, math.min(1, Time))
    return 1 - (1 - Time) ^ 3
end

local function CubicEaseInOut(Time)
    local Time = math.max(0, math.min(1, Time))
    return (Time < 0.5 and 4 * Time ^ 3) or (1 - (-2 * Time + 2) ^ 3 / 2)
end

local function QuarticEaseIn(Time)
    local Time = math.max(0, math.min(1, Time))
    return Time ^ 4
end

local function QuarticEaseOut(Time)
    local Time = math.max(0, math.min(1, Time))
    return 1 - (1 - Time) ^ 4
end

local function QuarticEaseInOut(Time)
    local Time = math.max(0, math.min(1, Time))
    return (Time < 0.5 and 8 * Time ^ 4) or( 1 - (-2 * Time + 2) ^ 4 / 2)
end

local function Linear(Time)
    local Time = math.max(0, math.min(1, Time))
    return Time
end

function EasingSelector(ModeString)
    if ModeString == "CubicEaseIn" then
        EasingMode = CubicEaseIn
    elseif ModeString == "CubicEaseOut" then
        EasingMode = CubicEaseOut
    elseif ModeString == "CubicEaseInOut" then
        EasingMode = CubicEaseInOut
    elseif ModeString == "QuarticEaseIn" then
        EasingMode = QuarticEaseIn
    elseif ModeString == "QuarticEaseOut" then
        EasingMode = QuarticEaseOut
    elseif ModeString == "QuarticEaseInOut" then
        EasingMode = QuarticEaseInOut
    else
        EasingMode = Linear
    end
end

EasingMode = QuarticEaseOut
EasingDuration = 1
NoEasingAnimator = false

--|| Animator Functions ||--

--// FOV Animator \\--
local DoorsMainGame = {fovtarget = 5}
local function FOVAnimator(StartValue, EndValue)
    if NoEasingAnimator then
        Camera.FieldOfView = EndValue
        FOVAnimating = false
        return
    end
    local StartTime = tick()
    FOVAnimating = true
    RunService:UnbindFromRenderStep("FOVAnimator")
    RunService:BindToRenderStep("FOVAnimator", 200, function()
        local ElapsedTime = tick() - StartTime
        if ElapsedTime >= EasingDuration then
            Camera.FieldOfView = EndValue
            FOVAnimating = false
            RunService:UnbindFromRenderStep("FOVAnimator")
        end
        local Progress = ElapsedTime / EasingDuration
        local EasedProgress = EasingMode(Progress)
        local FOVAnimatedValue = StartValue + (EndValue - StartValue) * EasedProgress
        Camera.FieldOfView = FOVAnimatedValue
        DoorsMainGame.fovtarget = FOVAnimatedValue
    end)
end

--// Camera Offset Animator \\--
local CameraOffsetInstance = Camera:FindFirstChild("AdminCameraOffset") or Instance.new("Vector3Value", Camera)
ModedCameraOffset = Vector3.new()

local function CameraOffsetAnimator(StartValue, EndValue)
    if NoEasingAnimator then
        CameraOffsetInstance.Value = EndValue
        CameraOffsetAnimating = false
        return
    end
    local StartTime = tick()
    CameraOffsetAnimating = true
    RunService:UnbindFromRenderStep("CameraOffsetAnimator")
    RunService:BindToRenderStep("CameraOffsetAnimator", 200, function()
        local ElapsedTime = tick() - StartTime
        if ElapsedTime >= EasingDuration then
            CameraOffsetInstance.Value = EndValue
            CameraOffsetAnimating = false
            RunService:UnbindFromRenderStep("CameraOffsetAnimator")
        end
        local Progress = ElapsedTime / EasingDuration
        local EasedProgress = EasingMode(Progress)
        local OffsetAnimatedValue = StartValue + (EndValue - StartValue) * EasedProgress
        CameraOffsetInstance.Value = OffsetAnimatedValue
    end)
end

--// Player Scale Animator \\--
local function PlayerScaleAnimator(StartValue, EndValue)
    if NoEasingAnimator then
        Speaker.Character:ScaleTo(EndValue)
        PlayerScaling = false
        return
    end
    local StartTime = tick()
    PlayerScaling = true
    RunService:UnbindFromRenderStep("PlayerScaleAnimator")
    RunService:BindToRenderStep("PlayerScaleAnimator", 200, function()
        local ElapsedTime = tick() - StartTime
        if ElapsedTime >= EasingDuration then
            Speaker.Character:ScaleTo(EndValue)
            PlayerScaling = false
            RunService:UnbindFromRenderStep("PlayerScaleAnimator")
        end
        local Progress = ElapsedTime / EasingDuration
        local EasedProgress = EasingMode(Progress)
        local ScaleAnimatedValue = StartValue + (EndValue - StartValue) * EasedProgress
        Speaker.Character:ScaleTo(ScaleAnimatedValue)
    end)
end

--// Camera Zoom Animator \\--
local function CameraZoomAnimator(StartValue, EndValue, MaxorMin)
    if NoEasingAnimator then
        if MaxorMin == "Max" then
            Speaker.CameraMaxZoomDistance = EndValue
            MaxCameraZooming = false
        else
            Speaker.CameraMinZoomDistance = EndValue
            MinCameraZooming = false
        end
        return
    end
    if MaxorMin == "Max" then
        local StartTime = tick()
        MaxCameraZooming = true
        RunService:UnbindFromRenderStep("CameraMaxZoomAnimator")
        RunService:BindToRenderStep("CameraMaxZoomAnimator", 200, function()
            local ElapsedTime = tick() - StartTime
            if ElapsedTime >= EasingDuration then
                Speaker.CameraMaxZoomDistance = EndValue
                MaxCameraZooming = false
                RunService:UnbindFromRenderStep("CameraMaxZoomAnimator")
            end
            local Progress = ElapsedTime / EasingDuration
            local EasedProgress = EasingMode(Progress)
            local ZoomAnimatedValue = StartValue + (EndValue - StartValue) * EasedProgress
            Speaker.CameraMaxZoomDistance = ZoomAnimatedValue
        end)
    else
        local StartTime = tick()
        MinCameraZooming = true
        RunService:UnbindFromRenderStep("CameraMinZoomAnimator")
        RunService:BindToRenderStep("CameraMinZoomAnimator", 200, function()
            local ElapsedTime = tick() - StartTime
            if ElapsedTime >= EasingDuration then
                Speaker.CameraMinZoomDistance = EndValue
                MinCameraZoomin = false
                RunService:UnbindFromRenderStep("CameraMinZoomAnimator")
            end
            local Progress = ElapsedTime / EasingDuration
            local EasedProgress = EasingMode(Progress)
            local ZoomAnimatedValue = StartValue + (EndValue - StartValue) * EasedProgress
            Speaker.CameraMinZoomDistance = ZoomAnimatedValue
        end)
    end
end

--|| AntiAFK Function ||--

function UniversalModules.AntiAFK(Enabled)
    if Enabled then
        if CanGetCons and AntiIdle then
            for _, Connection in pairs(GetConnections(Speaker.Idled)) do
                if Connection["Disable"] then
                    Connection["Disable"](Connection)
                elseif Connection["Disconnect"] then
                    Connection["Disconnect"](Connection)
                end
            end
        else
            local function ResetTimer()
                AFKTimer = 0
            end
            ResetTimer()
            AFKConnectionBegan = UserInputService.InputBegan:Connect(ResetTimer)
            AFKConnectionChanged = UserInputService.InputChanged:Connect(ResetTimer)
            AFKConnectionEnded = UserInputService.InputEnded:Connect(ResetTimer)
            while AntiAFKEnabled do
                task.wait(0.5)
                AFKTimer = AFKTimer + 0.5
                if AFKTimer >= AFKTime then
                    AFKTimes = AFKTimes + 1
                    if AntiAFKNotifyEnabled then
                        NotifySound((GlobalText.AntiAFKNotify .. AFKTimes .. GlobalText.AntiAFKNotify2), 3)
                    end
                    math.randomseed(tick())
                    if AFKMousemoverel then
                        local Random = Vector2.new(math.random(-5, 5), math.random(-5, 5))
                        if MouseMoveRel then
                            MouseMoveRel(Random)
                            Heartbeat:Wait()
                            MouseMoveRel(-Random)
                        elseif mousemoverel then
                            mousemoverel(Random)
                            Heartbeat:Wait()
                            mousemoverel(-Random)
                        end
                        ResetTimer()
                    elseif AFKMousemoveabs then
                        local Random = Vector2.new(math.random(0, Camera.ViewportSize.X), math.random(0, Camera.ViewportSize.Y))
                        local MousePos = Vector2.new(Mouse.X, Mouse.Y)
                        if MouseMoveAbs then
                            MouseMoveAbs(Random)
                            Heartbeat:Wait()
                            MouseMoveAbs(MousePos)
                        elseif mousemoveabs then
                            mousemoveabs(Random)
                            Heartbeat:Wait()
                            mousemoveabs(MousePos)
                        end
                        ResetTimer()
                    elseif AFKMouseClick1 then
                        if Mouse1Press then
                            Mouse1Press()
                            Heartbeat:Wait()
                            Mouse1Release()
                        elseif mouse1press then
                            mouse1press()
                            Heartbeat:Wait()
                            mouse1release()
                        end
                        ResetTimer()
                    else
                        if Mouse2Press then
                            Mouse2Press()
                            Heartbeat:Wait()
                            Mouse2Release()
                        elseif mouse2press then
                            mouse2press()
                            Heartbeat:Wait()
                            mouse2release()
                        end
                        ResetTimer()
                    end
                end
            end
        end
    else
        AFKConnectionBegan = AFKConnectionBegan and AFKConnectionBegan:Disconnect()
        AFKConnectionChanged = AFKConnectionChanged and AFKConnectionChanged:Disconnect()
        AFKConnectionEnded = AFKConnectionEnded and AFKConnectionEnded:Disconnect()
        AFKTimer = 0
    end
end

function UniversalModules.UseAntiAFKNotify(Enabled)
    AntiAFKNotifyEnabled = Enabled
end

function UniversalModules.AntiAFKValue(Number)
    AFKTime = Number
end

function UniversalModules.AntiAFKMethod(Method)
    if Method == "1" then
        AFKMousemoverel = true
        AFKMousemoveabs = false
        AFKMouseClick1 = false
        AFKMouseClick2 = false
    elseif Method == "2" then
        AFKMousemoverel = false
        AFKMousemoveabs = true
        AFKMouseClick1 = false
        AFKMouseClick2 = false
    elseif Method == "3" then
        AFKMousemoverel = false
        AFKMousemoveabs = false
        AFKMouseClick1 = true
        AFKMouseClick2 = false
    elseif Method == "4" then
        AFKMousemoverel = false
        AFKMousemoveabs = false
        AFKMouseClick1 = false
        AFKMouseClick2 = true
    end
end

--|| FPS Cap Function ||--

function UniversalModules.FPSCap(Enabled)
    FPSCapEnabled = Enabled
    if Enabled then
        UniversalModules.CurrentFPS = getfpscap() or 240
        setfpscap(TargetFPS)
    else
        setfpscap(UniversalModules.CurrentFPS)
    end
end

function UniversalModules.FPSCapValue(Number)
    TargetFPS = Number
    if FPSCapEnabled then
        setfpscap(TargetFPS)
    end
end

--|| AntiKick Function ||--

local AntiKickCount = 0
AntiKickNotify = false
function UniversalModules.AntiKick(Enabled)
    local OldNameCall, OldFunction
    AntiKickActivated = Enabled
    if Enabled then
        local function AntiKickedOnce()
            AntiKickCount += 1
            if AntiKickNotify then
                NotifySound(GlobalText.AntiKickedOnce .. tostring(AntiKickCount) .. GlobalText.AntiAFKNotify2, 5)
            end
        end
        if not (CanHookMM and CanGetNM and CanHookFunc) then
            NotifySound(GlobalText.CantAntiKick, 5)
            AntiKickActivated = false
            return warn(GlobalText.CantAntiKick)
        end
        if not CanCP then
            NotifySound(GlobalText.AntiKickMayNotWork, 5)
            warn(GlobalText.AntiKickMayNotWork)
        end
        if not CanCC then
            NotifySound(GlobalText.AntiKickMayNotWork2, 5)
            warn(GlobalText.AntiKickMayNotWork2)
        end
        if CanHookMM and CanGetNM then
            OldNameCall = hookmetamethod(game, "__namecall", NewCC(function(...)
                local self, Message = ...
                local Method = getnamecallmethod()
                if AntiKickActivated and Compare(self, Speaker) and string.gsub(Method, "^%l", string.upper) == "Kick" then
                    return AntiKickedOnce()
                end
                return OldNameCall(...)
            end))
        end
        if CanHookFunc then
            OldFunction = Hook(Speaker.Kick, NewCC(function(...)
                local self, Message = ...
                if AntiKickActivated and Compare(self, Speaker) then
                    return AntiKickedOnce()
                end
                return OldFunction(...)
            end))
        end
    else
        if OldNameCall and CanHookMM then
            pcall(function()
                hookmetamethod(game, "__namecall", OldNameCall)
            end)
        end
        if OldFunction and CanHookFunc then
            pcall(function()
                Hook(Speaker.Kick, OldFunction)
            end)
        end
    end
end

--|| Walk Speed Function ||--

function UniversalModules.WalkSpeed(Enabled)
    WalkSpeedChange = Enabled
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        CurrentWalkSpeed = Humanoid.WalkSpeed
        Humanoid.WalkSpeed = PlayerScaled and PlayerTargetScale * ModedWalkSpeed or ModedWalkSpeed
        LockConnections.WS = (LockConnections.WS and LockConnections.WS:Disconnect()) or Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function(Speed)
            Humanoid.WalkSpeed = PlayerScaled and PlayerTargetScale * ModedWalkSpeed or ModedWalkSpeed
        end)
        LockConnections.WSCA = (LockConnections.WSCA and LockConnections.WSCA:Disconnect()) or Speaker.CharacterAdded:Connect(function(Character)
            local Humanoid = Character:WaitForChild("Humanoid")
            CurrentWalkSpeed = Humanoid.WalkSpeed
            Humanoid.WalkSpeed = PlayerScaled and PlayerTargetScale * ModedWalkSpeed or ModedWalkSpeed
            LockConnections.WS = (LockConnections.WS and LockConnections.WS:Disconnect()) or Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function(Speed)
                Humanoid.WalkSpeed = PlayerScaled and PlayerTargetScale * ModedWalkSpeed or ModedWalkSpeed
            end)
        end)
    else
        LockConnections.WS = LockConnections.WS and LockConnections.WS:Disconnect()
        LockConnections.WSCA = LockConnections.WSCA and LockConnections.WSCA:Disconnect()
        pcall(function()
            Speaker.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = CurrentWalkSpeed
        end)
    end
end

function UniversalModules.WalkSpeedValue(Number)
    ModedWalkSpeed = Number
    if WalkSpeedChange then
        pcall(function()
            Speaker.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = PlayerScaled and PlayerTargetScale * ModedWalkSpeed or ModedWalkSpeed
        end)
    end
end

--|| Tp Walk Function ||--

function UniversalModules.TPWalk(Enabled)
    TPWalk = Enabled
    if Enabled then
        LockConnections.TPW = (LockConnections.TPW and LockConnections.TPW:Disconnect()) or Heartbeat:Connect(function(Delta)
            local Character = Speaker.Character
            local Humanoid = Character and Character:WaitForChild("Humanoid")
            if Humanoid and Humanoid.MoveDirection.Magnitude > 0 then
                Character:TranslateBy(PlayerScaled and (PlayerTargetScale * Humanoid.MoveDirection * TPWalkSpeed * Delta) or (Humanoid.MoveDirection * TPWalkSpeed * Delta))
            end
        end)
    else
        LockConnections.TPW = LockConnections.TPW and LockConnections.TPW:Disconnect()
    end
end

function UniversalModules.TPWalkValue(Number)
    TPWalkSpeed = Number
end

--|| No Acceleration Function ||--

function UniversalModules.NoAcceleration(Enabled)
    local CurrentPhysical
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local RootPart = Character:WaitForChild("HumanoidRootPart")
        CurrentPhysical = RootPart.CustomPhysicalProperties
        RootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
        LockConnections.NAC = (LockConnections.NAC and LockConnections.NAC:Disconnect()) or RootPart:GetPropertyChangedSignal("CustomPhysicalProperties"):Connect(function(Accel)
            RootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
        end)
        LockConnections.NACA = (LockConnections.NACA and LockConnections.NACA:Disconnect()) or Speaker.CharacterAdded:Connect(function(Character)
            local RootPart = Character:WaitForChild("HumanoidRootPart")
            CurrentPhysical = RootPart.CustomPhysicalProperties
            RootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
            LockConnections.NAC = (LockConnections.NAC and LockConnections.NAC:Disconnect()) or RootPart:GetPropertyChangedSignal("CustomPhysicalProperties"):Connect(function(Accel)
                RootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
            end)
        end)
    else
        LockConnections.NAC = LockConnections.NAC and LockConnections.NAC:Disconnect()
        LockConnections.NACA = LockConnections.NACA and LockConnections.NACA:Disconnect()
        pcall(function()
            Speaker.Character.HumanoidRootPart.CustomPhysicalProperties = CurrentPhysical or PhysicalProperties.new(0.7, 0.3, 0.5)
        end)
    end
end

--|| Jump Power Function ||--

function UniversalModules.JumpPower(Enabled)
    JumpPowerChange = Enabled
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        if not Humanoid.UseJumpPower then
            Humanoid.UseJumpPower = true
            NotUsingJumpPower = true
        end
        CurrentJumpPower = Humanoid.JumpPower
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = PlayerScaled and PlayerTargetScale * ModedJumpPower or ModedJumpPower
        LockConnections.JP = (LockConnections.JP and LockConnections.JP:Disconnect()) or Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function(JumpPower)
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = PlayerScaled and PlayerTargetScale * ModedJumpPower or ModedJumpPower
        end)
        LockConnections.JPJP = (LockConnections.JPJP and LockConnections.JPJP:Disconnect()) or Humanoid:GetPropertyChangedSignal("UseJumpPower"):Connect(function(Enabled)
            Humanoid.UseJumpPower = true
        end)
        LockConnections.JPCA = (LockConnections.JPCA and LockConnections.JPCA:Disconnect()) or Speaker.CharacterAdded:Connect(function(Character)
            local Humanoid = Character:WaitForChild("Humanoid")
            if not Humanoid.UseJumpPower then
                Humanoid.UseJumpPower = true
                NotUsingJumpPower = true
            end
            if Humanoid then
                Humanoid.UseJumpPower = true
                CurrentJumpPower = Humanoid.JumpPower
                Humanoid.JumpPower = PlayerScaled and PlayerTargetScale * ModedJumpPower or ModedJumpPower
            end
            LockConnections.JP = (LockConnections.JP and LockConnections.JP:Disconnect()) or Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function(JumpPower)
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = PlayerScaled and PlayerTargetScale * ModedJumpPower or ModedJumpPower
            end)
            LockConnections.JPJP = (LockConnections.JPJP and LockConnections.JPJP:Disconnect()) or Humanoid:GetPropertyChangedSignal("UseJumpPower"):Connect(function(Enabled)
                Humanoid.UseJumpPower = true
            end)
        end)
    else
        LockConnections.JP = LockConnections.JP and LockConnections.JP:Disconnect()
        LockConnections.JPJP = LockConnections.JPJP and LockConnections.JPJP:Disconnect()
        LockConnections.JPCA = LockConnections.JPCA and LockConnections.JPCA:Disconnect()
        pcall(function()
            local Humanoid = Speaker.Character:FindFirstChildOfClass("Humanoid")
            Humanoid.JumpPower = CurrentJumpPower
            Humanoid.UseJumpPower = not NotUsingJumpPower
        end)            
    end
end

function UniversalModules.JumpPowerValue(Number)
    ModedJumpPower = Number
    if JumpPowerChange then
        pcall(function()
            Speaker.Character:FindFirstChildOfClass("Humanoid").JumpPower = PlayerScaled and PlayerTargetScale * ModedJumpPower or ModedJumpPower
        end)
    end
end

--|| Gravity Function ||--

function UniversalModules.Gravity(Enabled)
    GravityChange = Enabled
    if Enabled then
        CurrentGravity = Workspace.Gravity
        Workspace.Gravity = ModedGravity
        LockConnections.G = Workspace:GetPropertyChangedSignal("Gravity"):Connect(function(Gravity)
            if Gravity ~= ModedGravity then
                CurrentGravity = Gravity
                Workspace.Gravity = ModedGravity
            end
        end)
    else
        LockConnections.G = LockConnections.G and LockConnections.G:Disconnect()
        Workspace.Gravity = CurrentGravity
    end
end

function UniversalModules.GravityValue(Number)
    ModedGravity = Number
    if GravityChange then
        Workspace.Gravity = ModedGravity
    end
end

--|| Anti Falling Down Function ||--

function UniversalModules.AntiFallingDown(Enabled)
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        local function Change()
            Humanoid:ChangeState(2)
            Humanoid:SetStateEnabled(0, false)
            Humanoid:SetStateEnabled(1, false)
        end
        Change()
        LockConnections.AFD = (LockConnections.AFD and LockConnections.AFD:Disconnect()) or Humanoid.StateChanged:Connect(function(State)
            if State.Value == 0 and not UniversalModules.Flying then
                Change()
            end
        end)
        LockConnections.AFDP = (LockConnections.AFDP and LockConnections.AFDP:Disconnect()) or Humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
            if not UniversalModules.Flying then
                Humanoid.PlatformStand = false
            end
        end)
        LockConnections.AFDCA = (LockConnections.AFDCA and LockConnections.AFDCA:Disconnect()) or Speaker.CharacterAdded:Connect(function(Character)
            local Humanoid = Character:WaitForChild("Humanoid")
            LockConnections.AFD = (LockConnections.AFD and LockConnections.AFD:Disconnect()) or Humanoid.StateChanged:Connect(function(State)
                if State.Value == 0 and not UniversalModules.Flying then
                    Change()
                end
            end)
            LockConnections.AFDP = (LockConnections.AFDP and LockConnections.AFDP:Disconnect()) or Humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
                if not UniversalModules.Flying then
                    Humanoid.PlatformStand = false
                end
            end)
        end)
    else
        LockConnections.AFD = LockConnections.AFD and LockConnections.AFD:Disconnect()
        LockConnections.AFDP = LockConnections.AFDP and LockConnections.AFDP:Disconnect()
        LockConnections.AFDCA = LockConnections.AFDCA and LockConnections.AFDCA:Disconnect()
        Humanoid:SetStateEnabled(0, true)
        Humanoid:SetStateEnabled(1, true)
        Humanoid:ChangeState(18)
    end
end

--|| Proximity Prompts Functions ||--

--// Search and Store Prompts \\--
local OriginalPrompts = {
    Instance = {},
    HoldDuration = {},
    MaxActivationDistance = {},
    RequiresLineOfSight = {}
}

for _, Prompt in pairs(Workspace:GetDescendants()) do
    if Prompt:IsA("ProximityPrompt") then
        OriginalPrompts.Instance[Prompt] = Prompt
        OriginalPrompts.HoldDuration[Prompt] = Prompt.HoldDuration
        OriginalPrompts.MaxActivationDistance[Prompt] = Prompt.MaxActivationDistance
        OriginalPrompts.RequiresLineOfSight[Prompt] = Prompt.RequiresLineOfSight
    end
end

LockConnections.Prompts = {
    HoldDuration = {},
    MaxActivationDistance = {},
    RequiresLineOfSight = {}
}

--// Prompts Added and Removing \\--
LockConnections.OnDescendantAdded = Workspace.DescendantAdded:Connect(function(Descendant)
    if Descendant:IsA("ProximityPrompt") then
        OriginalPrompts.Instance[Descendant] = Descendant
        OriginalPrompts.HoldDuration[Descendant] = Descendant.HoldDuration
        OriginalPrompts.MaxActivationDistance[Descendant] = Descendant.MaxActivationDistance
        OriginalPrompts.RequiresLineOfSight[Descendant] = Descendant.RequiresLineOfSight
        if InstantPromptHold then
            Descendant.HoldDuration = 0
            LockConnections.Prompts.HoldDuration[Descendant] = (LockConnections.Prompts.HoldDuration[Descendant] and LockConnections.Prompts.HoldDuration[Descendant]:Disconnect()) or Descendant:GetPropertyChangedSignal("HoldDuration"):Connect(function(HoldDuration)
                if HoldDuration ~= 0 then
                    OriginalPrompts.HoldDuration[Descendant] = HoldDuration
                    Descendant.HoldDuration = 0
                end
            end)
        end
        if MaxActivationDistance then
            Descendant.MaxActivationDistance = Descendant.MaxActivationDistance * MaxActivationDistanceMultiplier
            LockConnections.Prompts.MaxActivationDistance[Descendant] = (LockConnections.Prompts.MaxActivationDistance[Descendant] and LockConnections.Prompts.MaxActivationDistance[Descendant]:Disconnect()) or Descendant:GetPropertyChangedSignal("MaxActivationDistance"):Connect(function(Distance)
                if Distance ~= OriginalPrompts.MaxActivationDistance[Descendant] * MaxActivationDistanceMultiplier then
                    OriginalPrompts.MaxActivationDistance[Descendant] = Distance
                    Descendant.MaxActivationDistance = OriginalPrompts.MaxActivationDistance[Descendant] * MaxActivationDistanceMultiplier
                end
            end)
        end
        if RequiresLineOfSight then
            Descendant.RequiresLineOfSight = false
            LockConnections.Prompts.RequiresLineOfSight[Descendant] = (LockConnections.Prompts.RequiresLineOfSight[Descendant] and LockConnections.Prompts.RequiresLineOfSight[Descendant]:Disconnect()) or Descendant:GetPropertyChangedSignal("RequiresLineOfSight"):Connect(function(Enabled)
                if Enabled then
                    OriginalPrompts.RequiresLineOfSight[Prompt] = true
                    Prompt.RequiresLineOfSight = false
                else
                    OriginalPrompts.RequiresLineOfSight[Prompt] = false
                end
            end)
        end
    end
end)

LockConnections.OnDescendantRemoving = Workspace.DescendantRemoving:Connect(function(Descendant)
    if Descendant:IsA("ProximityPrompt") then
        OriginalPrompts.Instance[Descendant] = nil
        OriginalPrompts.HoldDuration[Descendant] = nil
        OriginalPrompts.MaxActivationDistance[Descendant] = nil
        OriginalPrompts.RequiresLineOfSight[Descendant] = nil
        LockConnections.Prompts.HoldDuration[Descendant] = LockConnections.Prompts.HoldDuration[Descendant] and LockConnections.Prompts.HoldDuration[Descendant]:Disconnect()
        LockConnections.Prompts.MaxActivationDistance[Descendant] = LockConnections.Prompts.MaxActivationDistance[Descendant] and LockConnections.Prompts.MaxActivationDistance[Descendant]:Disconnect()
        LockConnections.Prompts.RequiresLineOfSight[Descendant] = LockConnections.Prompts.RequiresLineOfSight[Descendant] and LockConnections.Prompts.RequiresLineOfSight[Descendant]:Disconnect()
    end
end)

--// Instant Prompt Function \\--
IPMethod = "FirePP"
function UniversalModules.InstantPrompt(Enabled)
    InstantPrompts = Enabled
    if CanFirePP and IPMethod == "FirePP" then
        InstantPromptFire = Enabled
        if Enabled then
            LockConnections.PromptBegan = ProximityPromptService.PromptButtonHoldBegan:Connect(function(Prompt)
                if not Options.AutoInteractionKeyPicker:GetState() then
                    fireproximityprompt(Prompt)
                end
            end)
            repeat
                Heartbeat:Wait()
            until not IPMethod == "FirePP" or not InstantPrompts
            InstantPromptFire = false
            LockConnections.PromptBegan = LockConnections.PromptBegan and LockConnections.PromptBegan:Disconnect()
        else
            LockConnections.PromptBegan = LockConnections.PromptBegan and LockConnections.PromptBegan:Disconnect()
        end
    elseif IPMethod == "HoldDuration" then
        InstantPromptHold = Enabled
        if Enabled then
            for _, Prompt in pairs(OriginalPrompts.Instance) do
                Prompt.HoldDuration = 0
                LockConnections.Prompts.HoldDuration[Prompt] = (LockConnections.Prompts.HoldDuration[Prompt] and LockConnections.Prompts.HoldDuration[Prompt]:Disconnect()) or Prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function(HoldDuration)
                    Prompt.HoldDuration = 0
                end)
            end
            repeat
                Heartbeat:Wait()
            until not IPMethod == "HoldDuration" or not InstantPrompts
        else
            for Prompt, _ in pairs(OriginalPrompts.Instance) do
                LockConnections.Prompts.HoldDuration[Prompt] = LockConnections.Prompts.HoldDuration[Prompt] and LockConnections.Prompts.HoldDuration[Prompt]:Disconnect()
                Prompt.HoldDuration = OriginalPrompts.HoldDuration[Prompt]
            end
        end
    end
end

--// Max Activation Function \\--
MaxActivationDistanceMultiplier = 1

function UniversalModules.MaxActivationDistance(Enabled)
    MaxActivationDistance = Enabled
    if Enabled then
        for _, Prompt in pairs(OriginalPrompts.Instance) do
            Prompt.MaxActivationDistance = Prompt.MaxActivationDistance * MaxActivationDistanceMultiplier
            LockConnections.Prompts.MaxActivationDistance[Prompt] = (LockConnections.Prompts.MaxActivationDistance[Prompt] and LockConnections.Prompts.MaxActivationDistance[Prompt]:Disconnect()) or Prompt:GetPropertyChangedSignal("MaxActivationDistance"):Connect(function(Distance)
                pcall(function()
                    Prompt.MaxActivationDistance = OriginalPrompts.MaxActivationDistance[Prompt] * MaxActivationDistanceMultiplier
                end)
            end)
        end
    else
        for Prompt, _ in pairs(OriginalPrompts.Instance) do
            LockConnections.Prompts.MaxActivationDistance[Prompt] = LockConnections.Prompts.MaxActivationDistance[Prompt] and LockConnections.Prompts.MaxActivationDistance[Prompt]:Disconnect()
            Prompt.MaxActivationDistance = OriginalPrompts.MaxActivationDistance[Prompt]
        end
    end
end

function UniversalModules.MaxActivationDistanceValue(Number)
    MaxActivationDistanceMultiplier = Number
    if MaxActivationDistance then
        for _, Prompt in pairs(OriginalPrompts.Instance) do
            pcall(function()
                Prompt.MaxActivationDistance = OriginalPrompts.MaxActivationDistance[Prompt] * MaxActivationDistanceMultiplier
            end)
        end
    end
end

--// Requires Line of Sight Function (Prompt Clip) \\--
function UniversalModules.RequiresLineOfSight(Enabled)
    RequiresLineOfSight = Enabled
    if Enabled then
        for _, Prompt in pairs(OriginalPrompts.Instance) do
            Prompt.RequiresLineOfSight = false
            LockConnections.Prompts.RequiresLineOfSight[Prompt] = (LockConnections.Prompts.RequiresLineOfSight[Prompt] and LockConnections.Prompts.RequiresLineOfSight[Prompt]:Disconnect()) or Prompt:GetPropertyChangedSignal("RequiresLineOfSight"):Connect(function(Enabled)
                Prompt.RequiresLineOfSight = false
            end)
        end
    else
        for Prompt, _ in pairs(OriginalPrompts.Instance) do
            LockConnections.Prompts.RequiresLineOfSight[Prompt] = LockConnections.Prompts.RequiresLineOfSight[Prompt] and LockConnections.Prompts.RequiresLineOfSight[Prompt]:Disconnect()
            Prompt.RequiresLineOfSight = OriginalPrompts.RequiresLineOfSight[Prompt]
        end
    end
end

--// Auto Interaction Function \\--
AIMethod = "Character"
task.spawn(function()
    repeat
        if AllowAutoInteraction and Options.AutoInteractionKeyPicker:GetState() then
            pcall(function()
                if AIMethod == "Character"then
                    for _, Prompt in pairs(OriginalPrompts.Instance) do
                        local MaxActivationDistance = Prompt.MaxActivationDistance
                        if (Speaker.Character:FindFirstChild("HumanoidRootPart").Position - Prompt.Parent.Position).Magnitude <= MaxActivationDistance then
                            fireproximityprompt(Prompt, MaxActivationDistance)
                        end
                    end
                else
                    for _, Gui in pairs(Speaker:FindFirstChildOfClass("PlayerGui"):GetChildren()) do
                        if Gui:IsA("ScreenGui") and Gui.Name == "ProximityPrompts" then
                            for _, PromptBillboard in pairs(Gui:GetChildren()) do
                                for _, Prompt in pairs(PromptBillboard.Adornee:GetDescendants()) do
                                    if Prompt:IsA("ProximityPrompt") then
                                        fireproximityprompt(Prompt, Prompt.MaxActivationDistance)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(AIInterval or 0.01)
    until Unloaded
end)

--|| Hip Height Function ||--

function UniversalModules.HipHeight(Enabled)
    HipHeight = Enabled
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        CurrentHipHeight = Humanoid.HipHeight
        Humanoid.HipHeight = PlayerScaled and PlayerTargetScale * ModedHipHeight or ModedHipHeight
        LockConnections.HH = Humanoid:GetPropertyChangedSignal("HipHeight"):Connect(function(HipHeight)
            Humanoid.HipHeight = PlayerScaled and PlayerTargetScale * ModedHipHeight or ModedHipHeight
        end)
        LockConnections.HHCA = Speaker.CharacterAdded:Connect(function(Character)
            if not DoHipHeightAfterMeRespawn then
                HipHeightToggle:SetValue(false)
                return
            end
            local Humanoid = Character:WaitForChild("Humanoid")
            CurrentHipHeight = Humanoid.HipHeight
            Humanoid.HipHeight = PlayerScaled and PlayerTargetScale * ModedHipHeight or ModedHipHeight
            LockConnections.HH = (LockConnections.HH and LockConnections.HH:Disconnect()) or Humanoid:GetPropertyChangedSignal("HipHeight"):Connect(function(HipHeight)
                Humanoid.HipHeight = PlayerScaled and PlayerTargetScale * ModedHipHeight or ModedHipHeight
            end)
        end)
    else
        LockConnections.HH = LockConnections.HH and LockConnections.HH:Disconnect()
        LockConnections.HHCA = LockConnections.HHCA and LockConnections.HHCA:Disconnect()
        pcall(function()
            Speaker.Character:FindFirstChildOfClass("Humanoid").HipHeight = CurrentHipHeight
        end)
    end
end

function UniversalModules.HipHeightValue(Number)
    ModedHipHeight = Number
    if HipHeight then
        pcall(function()
            Speaker.Character:FindFirstChildOfClass("Humanoid").HipHeight = PlayerScaled and PlayerTargetScale * ModedHipHeight or ModedHipHeight
        end)
    end
end

--|| Max Slope Angle Function ||--

function UniversalModules.MaxSlopeAngle(Enabled)
    MaxSlopeAngle = Enabled
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        CurrentMaxSlopeAngle = Humanoid.MaxSlopeAngle
        Humanoid.MaxSlopeAngle = ModedMaxSlopeAngle
        LockConnections.MSA = Humanoid:GetPropertyChangedSignal("MaxSlopeAngle"):Connect(function(MaxSlopeAngle)
            Humanoid.MaxSlopeAngle = ModedMaxSlopeAngle
        end)
        LockConnections.MSACA = Speaker.CharacterAdded:Connect(function(Character)
            local Humanoid = Character:WaitForChild("Humanoid")
            CurrentMaxSlopeAngle = Humanoid.MaxSlopeAngle
            Humanoid.MaxSlopeAngle = ModedMaxSlopeAngle
            LockConnections.MSA = (LockConnections.MSA and LockConnections.MSA:Disconnect()) or Humanoid:GetPropertyChangedSignal("MaxSlopeAngle"):Connect(function(MaxSlopeAngle)
                Humanoid.MaxSlopeAngle = ModedMaxSlopeAngle
            end)
        end)
    else
        LockConnections.MSA = LockConnections.MSA and LockConnections.MSA:Disconnect()
        LockConnections.MSACA = LockConnections.MSACA and LockConnections.MSACA:Disconnect()
        pcall(function()
            Speaker.Character:FindFirstChildOfClass("Humanoid").MaxSlopeAngle = CurrentMaxSlopeAngle
        end)
    end
end

function UniversalModules.MaxSlopeAngleValue(Number)
    ModedMaxSlopeAngle = Number
    if MaxSlopeAngle then
        pcall(function()
            Speaker.Character:FindFirstChildOfClass("Humanoid").MaxSlopeAngle = ModedMaxSlopeAngle
        end)
    end
end

--|| Player Scale Function ||--

function UniversalModules.PlayerScale(Enabled)
    PlayerScaled = Enabled
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        Character:WaitForChild("Humanoid")
        PlayerScaleAnimator(Character:GetScale(), PlayerTargetScale)
        RunService:UnbindFromRenderStep("PlayerScaleProtection")
        RunService:BindToRenderStep("PlayerScaleProtection", 300, function()
            if Character and Character:GetScale() ~= PlayerTargetScale and not PlayerScaling then
                Character:ScaleTo(PlayerTargetScale)
            end
        end)                
        LockConnections.PSCA = (LockConnections.PSCA and LockConnections.PSCA:Disconnect()) or Speaker.CharacterAdded:Connect(function(Character)
            Character:WaitForChild("Humanoid")
            PlayerScaleAnimator(Character:GetScale(), PlayerTargetScale)
            RunService:UnbindFromRenderStep("PlayerScaleProtection")
            RunService:BindToRenderStep("PlayerScaleProtection", 300, function()
                if Character and Character:GetScale() ~= PlayerTargetScale and not PlayerScaling then
                    Character:ScaleTo(PlayerTargetScale)
                end
            end)
        end)
    else
        RunService:UnbindFromRenderStep("PlayerScaleProtection")
        LockConnections.PSCA = LockConnections.PSCA and LockConnections.PSCA:Disconnect()
        pcall(function()
            PlayerScaleAnimator(Speaker.Character:GetScale(), PlayerCurrentScale)
        end)
    end
end

function UniversalModules.PlayerScaleValue(Number)
    PlayerTargetScale = Number
    if PlayerScaled then
        pcall(function()
            Speaker.Character:WaitForChild("Humanoid")
            PlayerScaleAnimator(Speaker.Character:GetScale(), PlayerTargetScale)
        end)
    end
end

--|| Noclip Function ||--

local NoclipParts = {}
function UniversalModules.Noclip(Enabled)
    if Enabled then
        NoclipParts = {}
        RunService:UnbindFromRenderStep("MFeeeNoclip")
        RunService:BindToRenderStep("MFeeeNoclip", 300, function()
            local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
            for _, Object in pairs(Character:GetDescendants()) do
                if Object:IsA("BasePart") and Object.CanCollide then
                    Object.CanCollide = false
                    if not table.find(NoclipParts, Object) then
                        table.insert(NoclipParts, Object)
                    end
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("MFeeeNoclip")
        for _, Object in pairs(NoclipParts) do
            pcall(function()
                Object.CanCollide = true
            end)
        end
        NoclipParts = {}
    end
end

local VNoclipParts = {}
function UniversalModules.VehicleNoclip(Enabled)
    if Enabled then
        local VNoclipNotified, VehicleModel, NoclipSetted = false
        VNoclipParts = {}
        RunService:UnbindFromRenderStep("MFeeeVNoclip")
        RunService:BindToRenderStep("MFeeeVNoclip", 300, function()
            local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
            local Humanoid = Character:WaitForChild("Humanoid")
            local Seat = Humanoid.SeatPart
            if Seat then
                VehicleModel = Seat.Parent
                if VehicleModel:IsA("Model") then
                    if not NoclipSetted then
                        NoclipSetted = true
                        NoclipToggle:SetValue(true)
                    end
                    for _, Object in pairs(VehicleModel:GetDescendants()) do
                        if Object:IsA("BasePart") and Object.CanCollide then
                            Object.CanCollide = false
                            if not table.find(VNoclipParts, Object) then
                                table.insert(VNoclipParts, Object)
                            end
                        end
                    end
                    VNocliping = true
                    if not VNoclipNotified then
                        VNoclipNotified = true
                        NotifySound(GlobalText.VehicleNoclipNotify, 5)
                    end
                else
                    VehicleModel = VehicleModel.Parent
                end
            else
                VNoclipNotified = false
                VNocliping = false
            end
        end)
    else
        RunService:UnbindFromRenderStep("MFeeeVNoclip")
        for _, Object in pairs(VNoclipParts) do
            pcall(function()
                Object.CanCollide = true
            end)
        end
        VNoclipParts = {}
    end
end

--|| Anti Void ||--

function UniversalModules.AntiVoid(Enabled)
    AntiVoid = Enabled
    if Enabled then
        CurrentVoid = Workspace.FallenPartsDestroyHeight
        Workspace.FallenPartsDestroyHeight = (0 / 0)
        LockConnections.V = (LockConnections.V and LockConnections.V:Disconnect()) or Workspace:GetPropertyChangedSignal("FallenPartsDestroyHeight"):Connect(function(DestroyHeight)
            Workspace.FallenPartsDestroyHeight = (0 / 0)
        end)
    else
        LockConnections.V = LockConnections.V and LockConnections.V:Disconnect()
        Workspace.FallenPartsDestroyHeight = CurrentVoid
    end
end

--|| Spin Function ||--

function UniversalModules.Spin(Enabled)
    Spining = Enabled
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        Spin = Instance.new("BodyAngularVelocity", Character and Character:WaitForChild("HumanoidRootPart"))
        Spin.Name = "AdminSpin"
        Spin.MaxTorque = Vector3.new(0, Inf, 0)
        Spin.AngularVelocity = Vector3.new(0, (SpinSpeed or 3), 0)
    else
        Spin = Spin and Spin:Destroy()
    end
end

function UniversalModules.SpinValue(Number)
    SpinSpeed = Number
    if Spining and Spin then
        Spin.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
    end
end

--|| Fly Functions ||--

--// Controls \\--
local FlyControl = {
    W = 0,
    S = 0,
    A = 0,
    D = 0,
    Q = 0,
    E = 0,
    Up = 0,
    Down = 0,
    Left = 0,
    Right = 0,
    LeftControl = 0,
    LeftShift = 0,
    Space = 0
}

local Typing = false

UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

UserInputService.InputBegan:Connect(function(Key)
    if not Typing then
        if Key.KeyCode == Enum.KeyCode.W then
            FlyControl.W = 1
        elseif Key.KeyCode == Enum.KeyCode.S then
            FlyControl.S = 1
        elseif Key.KeyCode == Enum.KeyCode.A then
            FlyControl.A = 1
        elseif Key.KeyCode == Enum.KeyCode.D then
            FlyControl.D = 1
        elseif Key.KeyCode == Enum.KeyCode.Q then
            FlyControl.Q = 1
        elseif Key.KeyCode == Enum.KeyCode.E then
            FlyControl.E = 1
        elseif Key.KeyCode == Enum.KeyCode.Up then
            FlyControl.Up = 1
        elseif Key.KeyCode == Enum.KeyCode.Down then
            FlyControl.Down = 1
        elseif Key.KeyCode == Enum.KeyCode.Left then
            FlyControl.Left = 1
        elseif Key.KeyCode == Enum.KeyCode.Right then
            FlyControl.Right = 1
        elseif Key.KeyCode == Enum.KeyCode.LeftControl then
            FlyControl.LeftControl = 1
        elseif Key.KeyCode == Enum.KeyCode.LeftShift then
            FlyControl.LeftShift = 1
        elseif Key.KeyCode == Enum.KeyCode.Space then
            FlyControl.Space = 1
        end
        if (UseFlyGyro or LookToCamera) and UniversalModules.Flying then
            pcall(function()
                Camera.CameraType = Enum.CameraType.Track
            end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(Key)
    if not Typing then
        if Key.KeyCode == Enum.KeyCode.W then
            FlyControl.W = 0
        elseif Key.KeyCode == Enum.KeyCode.S then
            FlyControl.S = 0
        elseif Key.KeyCode == Enum.KeyCode.A then
            FlyControl.A = 0
        elseif Key.KeyCode == Enum.KeyCode.D then
            FlyControl.D = 0
        elseif Key.KeyCode == Enum.KeyCode.Q then
            FlyControl.Q = 0
        elseif Key.KeyCode == Enum.KeyCode.E then
            FlyControl.E = 0
        elseif Key.KeyCode == Enum.KeyCode.Up then
            FlyControl.Up = 0
        elseif Key.KeyCode == Enum.KeyCode.Down then
            FlyControl.Down = 0
        elseif Key.KeyCode == Enum.KeyCode.Left then
            FlyControl.Left = 0
        elseif Key.KeyCode == Enum.KeyCode.Right then
            FlyControl.Right = 0
        elseif Key.KeyCode == Enum.KeyCode.LeftControl then
            FlyControl.LeftControl = 0
        elseif Key.KeyCode == Enum.KeyCode.LeftShift then
            FlyControl.LeftShift = 0
        elseif Key.KeyCode == Enum.KeyCode.Space then
            FlyControl.Space = 0
        end
    end
end)

--// Fly Function \\--
function UniversalModules.Fly(Enabled)
    UniversalModules.Flying = Enabled
    local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Humanoid.RootPart
    if Enabled then
        if UseConstraintsFly then
            local TargetVelocity = Vector3.new()
            local TargetCFrame = RootPart.CFrame
            LinearVelocity = Instance.new("LinearVelocity", RootPart)
            AlignOrientation = Instance.new("AlignOrientation", RootPart)
            AttachmentL = Instance.new("Attachment", RootPart)
            AttachmentA = Instance.new("Attachment", RootPart)
            AttachmentW = Instance.new("Attachment", Workspace.Terrain)
            LinearVelocity.Name = "AdminLinearVelocity"
            LinearVelocity.MaxForce = Inf
            LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            LinearVelocity.VectorVelocity = TargetVelocity
            LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
            LinearVelocity.Attachment0 = AttachmentL
            AlignOrientation.Name = "AdminAlignOrientation"
            AlignOrientation.MaxTorque = Inf
            AlignOrientation.Responsiveness = ConstraintsResponsiveness
            AlignOrientation.Attachment0 = AttachmentA
            AlignOrientation.Attachment1 = AttachmentW
            AttachmentL.Name = "AdminAttachment_LinearVelocity"
            AttachmentA.Name = "AdminAttachment_AlignOrientation"
            AttachmentW.Name = "AdminAttachment_World"
            LockConnections.Fly = (LockConnections.Fly and LockConnections.Fly:Disconnect()) or Heartbeat:Connect(function(DeltaTime)
                local MoveDirection = Vector3.new()
                if Humanoid and Humanoid.Health > 0 then
                    local NoChange;
                    if ConstraintsFlyingState ~= 18 then
                        Humanoid:ChangeState(ConstraintsFlyingState)
                        NoChange = true
                    else
                        if NoChange then
                            Humanoid:ChangeState(2)
                            NoChange = false
                        end
                        if SmartFly then
                            Humanoid.PlatformStand = not Humanoid.SeatPart and not Humanoid.Sit
                        else
                            if not VFly and not SitFly then
                                Humanoid.PlatformStand = true
                            elseif VFly and not SitFly then
                                Humanoid.PlatformStand = false
                                Humanoid.Sit = Humanoid.SeatPart and true or false
                            elseif not VFly and SitFly then
                                Humanoid.PlatformStand = false
                                Humanoid.Sit = true
                            end
                        end
                    end
                    local LookVector = Camera.CFrame.LookVector
                    local RightVector = Camera.CFrame.RightVector
                    local UpVector = Camera.CFrame.UpVector
                    if FlyControl.W == 1 or FlyControl.Up == 1 then
                        MoveDirection += LookVector
                    end
                    if FlyControl.S == 1 or FlyControl.Down == 1 then
                        MoveDirection -= LookVector
                    end
                    if FlyControl.A == 1 or FlyControl.Left == 1 then
                        MoveDirection -= RightVector
                    end
                    if FlyControl.D == 1 or FlyControl.Right == 1 then
                        MoveDirection += RightVector
                    end
                    local HorizontalDirection = Vector3.new(MoveDirection.X, 0, MoveDirection.Z)
                    if HorizontalDirection.Magnitude > 0 then
                        HorizontalDirection = HorizontalDirection.Unit
                        MoveDirection = Vector3.new(HorizontalDirection.X, MoveDirection.Y, HorizontalDirection.Z)
                    end
                    if UseUpVector then
                        if QEFly and FlyControl.Q == 1 or not QEFly and not LeftControlDown and FlyControl.LeftShift == 1 then
                            MoveDirection -= UpVector * VerticalFlySpeedMultiplier
                        elseif LeftControlDown and FlyControl.LeftControl == 1 then
                            MoveDirection -= UpVector * VerticalFlySpeedMultiplier
                        end
                        if QEFly and FlyControl.E == 1 or not QEFly and FlyControl.Space == 1 then
                            MoveDirection += UpVector * VerticalFlySpeedMultiplier
                        end
                    else
                        if QEFly and FlyControl.Q == 1 or not QEFly and not LeftControlDown and FlyControl.LeftShift == 1 then
                            MoveDirection -= Vector3.new(0, VerticalFlySpeedMultiplier, 0)
                        elseif LeftControlDown and FlyControl.LeftControl == 1 then
                            MoveDirection -= Vector3.new(0, VerticalFlySpeedMultiplier, 0)
                        end
                        if QEFly and FlyControl.E == 1 or not QEFly and FlyControl.Space == 1 then
                            MoveDirection += Vector3.new(0, VerticalFlySpeedMultiplier, 0)
                        end
                    end
                    if MoveDirection.Magnitude > 0 then
                        MoveDirection = MoveDirection.Unit
                    end
                    TargetVelocity = TargetVelocity:Lerp(MoveDirection * ConstraintsMaxSpeed, DeltaTime * ConstraintsAcceleration)
                    AlignOrientation.Responsiveness = ConstraintsResponsiveness
                    LinearVelocity.VectorVelocity = (PlayerScaled and PlayerTargetScale * TargetVelocity) or TargetVelocity
                    if LookToCamera then
                        AttachmentW.CFrame = Camera.CoordinateFrame
                    elseif TargetVelocity.Magnitude > 1 then
                        local FlatVelocity = Vector3.new(TargetVelocity.X, 0, TargetVelocity.Z)
                        if FlatVelocity.Magnitude > 1 then
                            local TargetLook = CFrame.lookAt(RootPart.Position, RootPart.Position + FlatVelocity)
                            TargetCFrame = TargetCFrame:Lerp(TargetLook, DeltaTime * ConstraintsTurnSpeed)
                            AttachmentW.CFrame = TargetCFrame
                        end
                    end
                end
            end)
        else
            FlyVelocity = Instance.new("BodyVelocity")
            FlyVelocity.Name = Weaponry and "EPIc_VELOCITY" or "AdminBodyVelocity"
            FlyVelocity.MaxForce = Vector3.new(Inf, Inf, Inf)
            FlyVelocity.Velocity = Vector3.new()
            FlyVelocity.Parent = RootPart
            if UseFlyGyro then
                FlyGyro = Instance.new("BodyGyro")
                FlyGyro.Name = Weaponry and "EPIc_VELOCITY" or "AdminBodyGyro"
                FlyGyro.P = 9e4
                FlyGyro.MaxTorque = Vector3.new(Inf, Inf, Inf)
                FlyGyro.CFrame = Camera.CFrame
                FlyGyro.Parent = RootPart
            end
            LockConnections.Fly = (LockConnections.Fly and LockConnections.Fly:Disconnect()) or Stepped:Connect(function()
                local MoveDirection = Vector3.new()
                if Humanoid and Humanoid.Health > 0 then
                    if SmartFly then
                        Humanoid.PlatformStand = not Humanoid.SeatPart and not Humanoid.Sit
                    else
                        if not VFly and not SitFly then
                            Humanoid.PlatformStand = true
                        elseif VFly and not SitFly then
                            Humanoid.PlatformStand = false
                            Humanoid.Sit = Humanoid.SeatPart and true or false
                        elseif not VFly and SitFly then
                            Humanoid.PlatformStand = false
                            Humanoid.Sit = true
                        end
                    end
                    local LookVector = Camera.CFrame.LookVector
                    local RightVector = Camera.CFrame.RightVector
                    local UpVector = Camera.CFrame.UpVector
                    if FlyControl.W == 1 or FlyControl.Up == 1 then
                        MoveDirection += LookVector
                    end
                    if FlyControl.S == 1 or FlyControl.Down == 1 then
                        MoveDirection -= LookVector
                    end
                    if FlyControl.A == 1 or FlyControl.Left == 1 then
                        MoveDirection -= RightVector
                    end
                    if FlyControl.D == 1 or FlyControl.Right == 1 then
                        MoveDirection += RightVector
                    end
                    if UseUpVector then
                        if QEFly and FlyControl.Q == 1 or not QEFly and not LeftControlDown and FlyControl.LeftShift == 1 then
                            MoveDirection -= UpVector * VerticalFlySpeedMultiplier
                        elseif LeftControlDown and FlyControl.LeftControl == 1 then
                            MoveDirection -= UpVector * VerticalFlySpeedMultiplier
                        end
                        if QEFly and FlyControl.E == 1 or not QEFly and FlyControl.Space == 1 then
                            MoveDirection += UpVector * VerticalFlySpeedMultiplier
                        end
                    else
                        if QEFly and FlyControl.Q == 1 or not QEFly and not LeftControlDown and FlyControl.LeftShift == 1 then
                            MoveDirection -= Vector3.new(0, VerticalFlySpeedMultiplier, 0)
                        elseif LeftControlDown and FlyControl.LeftControl == 1 then
                            MoveDirection -= Vector3.new(0, VerticalFlySpeedMultiplier, 0)
                        end
                        if QEFly and FlyControl.E == 1 or not QEFly and FlyControl.Space == 1 then
                            MoveDirection += Vector3.new(0, VerticalFlySpeedMultiplier, 0)
                        end
                    end
                    FlyVelocity.Velocity = (PlayerScaled and PlayerTargetScale * FlySpeed * MoveDirection) or FlySpeed * MoveDirection
                    if UseFlyGyro then
                        FlyGyro.CFrame = Camera.CoordinateFrame
                        FlyGyro.D = SmoothGyro and SmoothGyroValue or 500
                    end
                end
            end)
        end
        LockConnections.FlyDied = (LockConnections.FlyDied and LockConnections.FlyDied:Disconnect()) or Humanoid.Died:Connect(function()
            if StopFlyOnDied then
                FlyToggle:SetValue(false)
            end
        end)
    else
        LockConnections.Fly = LockConnections.Fly and LockConnections.Fly:Disconnect()
        LockConnections.FlyDied = LockConnections.FlyDied and LockConnections.FlyDied:Disconnect()
        LinearVelocity = LinearVelocity and LinearVelocity:Destroy()
        AlignOrientation = AlignOrientation and AlignOrientation:Destroy()
        AttachmentL = AttachmentL and AttachmentL:Destroy()
        AttachmentA = AttachmentA and AttachmentA:Destroy()
        AttachmentW = AttachmentW and AttachmentW:Destroy()
        FlyVelocity = FlyVelocity and FlyVelocity:Destroy()
        FlyGyro = FlyGyro and FlyGyro:Destroy()
        pcall(function()
            local Humanoid = Speaker.Character:FindFirstChildOfClass("Humanoid")
            StateValue = Humanoid:GetState().Value
            Humanoid:ChangeState((StateValue == 16 and 2) or (StateValue == 1 and 2) or 18)
            Humanoid.PlatformStand = false
            Humanoid.Sit = Humanoid.SeatPart and true or false
        end)
    end
end

--|| Free Camera Functions ||--

--// Free Camera Spring \\--
local Spring = {}
do
    Spring.__index = Spring
    function Spring.new(Frequency, Position)
        local self = setmetatable({}, Spring)
        self.Frequency = Frequency
        self.Position = Position
        self.Velocity = Position * 0
        return self
    end

    function Spring:Update(DeltaTime, Goal)
        local Frequency = self.Frequency * 2 * math.pi
        local Position0 = self.Position
        local Velocity0 = self.Velocity
        local Offset = Goal - Position0
        local Decay = math.exp(-Frequency * DeltaTime)
        local Position1 = Goal + (Velocity0 * DeltaTime - Offset * (Frequency * DeltaTime + 1)) * Decay
        local Velocity1 = (Frequency * DeltaTime * (Offset * Frequency - Velocity0) + Velocity0) * Decay
        self.Position = Position1
        self.Velocity = Velocity1
        return Position1
    end

    function Spring:Reset(Position)
        self.Position = Position
        self.Velocity = Position * 0
    end
end

local FreeCameraPosition = Vector3.new()
local FreeCameraRoot = Vector2.new()
local VelocitySpring = Spring.new(5, Vector3.new())
local PanningSpring = Spring.new(5, Vector2.new())
NavKeyboardSpeed = Vector3.new(0.5, 0.5, 0.5)
NavShiftMultiplier = 0.3
NavSpaceMultiplier = 2

--// Free Camera Input \\--
local FreeCameraInput = {}
do
    local Keyboard = {
        W = 0,
        A = 0,
        S = 0,
        D = 0,
        Q = 0,
        E = 0,
        Up = 0,
        Down = 0,
        LeftShift = 0,
        Space = 0
    }
    local Mouse = { Delta = Vector2.new() }
    local PanMouseSpeed = Vector2.new(1.2, 1.2) * (math.pi / 64)
    local NavAdjustSpeed = 0.8
    local NavSpeed = 1

    FreeCameraInput.Keypress1 = (FreeCameraInput.Keypress1 and FreeCameraInput.Keypress1:Disconnect()) or UserInputService.InputBegan:Connect(function(Input, Processed)
        if not Processed then
            Keyboard[Input.KeyCode.Name] = 1
        end
    end)

    FreeCameraInput.Keypress2 = (FreeCameraInput.Keypress2 and FreeCameraInput.Keypress2:Disconnect()) or UserInputService.InputEnded:Connect(function(Input)
        Keyboard[Input.KeyCode.Name] = 0
    end)

    function FreeCameraInput.Velocity(DeltaTime)
        NavSpeed = math.clamp(NavSpeed + DeltaTime * (Keyboard.Up - Keyboard.Down) * NavAdjustSpeed, 0.01, 4)
        local Shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
        local Space = UserInputService:IsKeyDown(Enum.KeyCode.Space)
        return Vector3.new(Keyboard.D - Keyboard.A, Keyboard.E - Keyboard.Q, Keyboard.S - Keyboard.W) * NavKeyboardSpeed * (NavSpeed * (Shift and NavShiftMultiplier or 1) * (Space and NavSpaceMultiplier or 1))
    end

    function FreeCameraInput.Panning(DeltaTime)
        local KMouse = Mouse.Delta * PanMouseSpeed
        Mouse.Delta = Vector2.new()
        return KMouse
    end

    function FreeCameraInput.Keypress(Action, State, Input)
        Keyboard[Input.KeyCode.Name] = State == Enum.UserInputState.Begin and 1 or 0
        return Enum.ContextActionResult.Sink
    end

    function FreeCameraInput.MousePanning(Action, State, Input)
        local Delta = Input.Delta
        Mouse.Delta = Vector2.new(-Delta.y, -Delta.x)
        return Enum.ContextActionResult.Sink
    end

    function FreeCameraInput.Zero(Table)
        for Key, Value in pairs(Table) do
            Table[Key] = Value * 0
        end
    end

    function FreeCameraInput.StartCapture()
        ContextActionService:BindActionAtPriority("FreecamKeyboard", FreeCameraInput.Keypress, false, 3000, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.LeftShift, Enum.KeyCode.Space)
        ContextActionService:BindActionAtPriority("FreecamMousePanning", FreeCameraInput.MousePanning, false, 3000, Enum.UserInputType.MouseMovement)
    end

    function FreeCameraInput.StopCapture()
        NavSpeed = 1
        FreeCameraInput.Zero(Keyboard)
        FreeCameraInput.Zero(Mouse)
        ContextActionService:UnbindAction("FreecamKeyboard")
        ContextActionService:UnbindAction("FreecamMousePanning")
    end
end

--// Step Free Camera Functions \\--
local function GetFocusDistance(CameraFrame)
    local ZNear = 0.1
    local Viewport = Camera.ViewportSize
    local ProjY = 2 * math.tan(math.rad(Camera.FieldOfView) / 2)
    local ProjX = Viewport.X / Viewport.Y * ProjY
    local FRameX = CameraFrame.RightVector
    local FRameY = CameraFrame.UpVector
    local FRameZ = CameraFrame.LookVector
    local MinVector = Vector3.new()
    local MinDistance = 512
    for X = 0, 1, 0.5 do
        for Y = 0, 1, 0.5 do
            local CX = (X - 0.5) * ProjX
            local CY = (Y - 0.5) * ProjY
            local Offset = FRameX * CX - FRameY * CY + FRameZ
            local Origin = CameraFrame.Position + Offset * ZNear
            local _, Hit = Workspace:FindPartOnRay(Ray.new(Origin, Offset.Unit * MinDistance))
            local Distance = (Hit - Origin).Magnitude
            if MinDistance > Distance then
                MinDistance = Distance
                MinVector = Offset.Unit
            end
        end
    end
    return FRameZ:Dot(MinVector) * MinDistance
end

--// Player State Store \\--
local PlayerState = {}
do
    PlayerState.MouseBehavior = ""
    PlayerState.MouseIconEnabled = ""
    PlayerState.CameraType = ""
    PlayerState.CameraFocus = ""
    PlayerState.CameraCFrame = ""
    PlayerState.CameraFieldOfView = ""

    function PlayerState.Push()
        PlayerState.CameraFieldOfView = Camera.FieldOfView
        Camera.FieldOfView = FOVChange and ModedFOV or CurrentFOV
        PlayerState.CameraType = Camera.CameraType
        Camera.CameraType = Enum.CameraType.Custom
        PlayerState.CameraCFrame = Camera.CFrame
        PlayerState.CameraFocus = Camera.Focus
        PlayerState.MouseIconEnabled = UserInputService.MouseIconEnabled
        UserInputService.MouseIconEnabled = true
        PlayerState.MouseBehavior = UserInputService.MouseBehavior
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end

    function PlayerState.Pop()
        Camera.FieldOfView = PlayerState.CameraFieldOfView
        Camera.CameraType = PlayerState.CameraType
        PlayerState.CameraType = nil
        Camera.CFrame = PlayerState.CameraCFrame
        PlayerState.CameraCFrame = nil
        Camera.Focus = PlayerState.CameraFocus
        PlayerState.CameraFocus = nil
        UserInputService.MouseIconEnabled = PlayerState.MouseIconEnabled
        PlayerState.MouseIconEnabled = nil
        UserInputService.MouseBehavior = PlayerState.MouseBehavior
        PlayerState.MouseBehavior = nil
    end
end

--// Free Camera Control Function \\--
function UniversalModules.FreeCamera(Enabled)
    if Enabled then
        if Spectating then
            SpectatePlayerToggle:SetValue(false)
            repeat
                Heartbeat:Wait()
            until not Spectating
        end
        if FreeCameraRunning then
            UniversalModules.FreeCamera(false)
            repeat
                Heartbeat:Wait()
            until not FreeCameraRunning
        end
        local CameraCFrame = Camera.CFrame
        CameraRot = Vector2.new()
        CameraPos = CameraCFrame.Position
        FreeCameraInput.StartCapture()
        VelocitySpring:Reset(Vector3.new())
        PanningSpring:Reset(Vector2.new())
        PlayerState.Push()
        FreeCameraRunning = true
        RunService:BindToRenderStep("Freecam", 200, function(DeltaTime)
            local Velocity = VelocitySpring:Update(DeltaTime, FreeCameraInput.Velocity(DeltaTime))
            local Panning = PanningSpring:Update(DeltaTime, FreeCameraInput.Panning(DeltaTime))
            local ZoomFactor = math.sqrt(math.tan(math.rad(70 / 2)) / math.tan(math.rad(Camera.FieldOfView) / 2))
            CameraRot = CameraRot + Panning * Vector2.new(0.75, 1) * 8 * (DeltaTime / ZoomFactor)
            CameraRot = Vector2.new(math.clamp(CameraRot.X, -math.rad(90), math.rad(90)), CameraRot.Y % (2 * math.pi))
            local CameraCFrame = CFrame.new(CameraPos) * CFrame.fromOrientation(CameraRot.X, CameraRot.Y, 0) * CFrame.new(Velocity * Vector3.new(1, 1, 1) * 64 * DeltaTime)
            CameraPos = CameraCFrame.Position
            Camera.CFrame = CameraCFrame
            Camera.Focus = CameraCFrame * CFrame.new(0, 0, -GetFocusDistance(CameraCFrame))
        end)
    else
        if not FreeCameraRunning then
            return
        end
        RunService:UnbindFromRenderStep("Freecam")
        PlayerState.Pop()
        FreeCameraInput.StopCapture()
        Camera.FieldOfView = FOVChange and ModedFOV or CurrentFOV
        FreeCameraRunning = false
    end
end

--|| Spectate Player Function ||--

function UniversalModules.SpectatePlayer(Enabled)
    if Enabled then
        Spectating = false
        FreeCameraToggle:SetValue(false)
        CurrentCameraSubject = Camera.CameraSubject
        Camera.CameraType = Enum.CameraType.Custom
        local Player = CameraPlayer:IsA("Instance") and CameraPlayer or Players:FindFirstChild(CameraPlayer)
        local Character = Player and Player.Character
        local Humanoid = Character and Character:WaitForChild("Humanoid")
        if Humanoid then
            Camera.CameraSubject = Humanoid
            LockConnections.SP = (LockConnections.SP and LockConnections.SP:Disconnect()) or Camera:GetPropertyChangedSignal("CameraSubject"):Connect(function(CameraSubject)
                Camera.CameraSubject = NewHumanoid
            end)
            LockConnections.SPCA = (LockConnections.SPCA and LockConnections.SPCA:Disconnect()) or Player.CharacterAdded:Connect(function(NewCharacter)
                local NewHumanoid = NewCharacter:WaitForChild("Humanoid")
                if NewHumanoid then
                    Camera.CameraSubject = NewHumanoid
                    LockConnections.SP = (LockConnections.SP and LockConnections.SP:Disconnect()) or Camera:GetPropertyChangedSignal("CameraSubject"):Connect(function(CameraSubject)
                        Camera.CameraSubject = NewHumanoid
                    end)
                end
            end)
            if USWCR then
                LockConnections.SPCR = (LockConnections.SPCR and LockConnections.SPCR:Disconnect()) or Player.CharacterRemoving:Connect(function()
                    SpectatePlayerToggle:SetValue(false)
                end)
            end
            LockConnections.SPPR = (LockConnections.SPPR and LockConnections.SPPR:Disconnect()) or Players.PlayerRemoving:Connect(function(LeavingPlayer)
                if LeavingPlayer == Player then
                    SpectatePlayerToggle:SetValue(false)
                end
            end)
            Spectating = true
        end
    else
        LockConnections.SP = LockConnections.SP and LockConnections.SP:Disconnect()
        LockConnections.SPCA = LockConnections.SPCA and LockConnections.SPCA:Disconnect()
        LockConnections.SPCR = LockConnections.SPCR and LockConnections.SPCR:Disconnect()
        LockConnections.SPPR = LockConnections.SPPR and LockConnections.SPPR:Disconnect()
        Camera.CameraSubject = CurrentCameraSubject or Speaker.Character and Speaker.Character:FindFirstChildOfClass("Humanoid")
        Spectating = false
    end
end

--|| Click to Move Function ||--

function UniversalModules.ClickToMove(Enabled)
    if Enabled then
        CurrentMovement = Speaker.DevComputerMovementMode
        Speaker.DevComputerMovementMode = Enum.DevComputerMovementMode.ClickToMove
        LockConnections.CTM = (LockConnections.CTM and LockConnections.CTM:Disconnect()) or Speaker:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function(MovementMode)
            Speaker.DevComputerMovementMode = Enum.DevComputerMovementMode.ClickToMove
        end)
    else
        LockConnections.CTM = LockConnections.CTM and LockConnections.CTM:Disconnect()
        Speaker.DevComputerMovementMode = CurrentMovement
    end
end

--|| FOV Functions ||--

if require and (game.PlaceId == 2440500124 or game.PlaceId == 16874352892 or game.PlaceId == 17045908353 or game.PlaceId == 16874821428 or game.PlaceId == 16992279648 or game.PlaceId == 138779629462354 or game.PlaceId == 16875079348) then
    local Temp
    Temp = Speaker.DescendantAdded:Connect(function(Descendant)
        if Descendant.Name == "Main_Game" and Descendant.Parent.Name == "Initiator" then
            pcall(function()
                DoorsMainGame = require(Descendant)
                Temp:Disconnect()
            end)
        end
    end)
end

function UniversalModules.FOV(Enabled)
    FOVChange = Enabled
    if Enabled then
        FOVAnimator(Camera.FieldOfView, ModedFOV or 70)
        DoorsMainGame.fovtarget = ModedFOV
        LockConnections.FOV = (LockConnections.FOV and LockConnections.FOV:Disconnect()) or Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function(NewFOV)
            if FOVAnimating then return end
            Camera.FieldOfView = ModedFOV
            DoorsMainGame.fovtarget = ModedFOV
        end)
    else
        LockConnections.FOV = LockConnections.FOV and LockConnections.FOV:Disconnect()
        FOVAnimator(Camera.FieldOfView, CurrentFOV or 70)
        DoorsMainGame.fovtarget = CurrentFOV
    end
end

function UniversalModules.FOVValue(Number)
    ModedFOV = Number
    if FOVChange then
        FOVAnimator(Camera.FieldOfView, ModedFOV)
        DoorsMainGame.fovtarget = ModedFOV
    end
end

--|| Max Zoom Function ||--

function UniversalModules.MaxZoom(Enabled)
    MaxZoomChange = Enabled
    if Enabled then
        CameraZoomAnimator(Speaker.CameraMaxZoomDistance, ModedMaxZoom or 128, "Max")
        LockConnections.MZ = (LockConnections.MZ and LockConnections.MZ:Disconnect()) or Speaker:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function(MaxZoom)
            if not MaxCameraZooming then
                Speaker.CameraMaxZoomDistance = ModedMaxZoom
            end
        end)
    else
        LockConnections.MZ = LockConnections.MZ and LockConnections.MZ:Disconnect()
        CameraZoomAnimator(Speaker.CameraMaxZoomDistance, CurrentMaxZoom or 128, "Max")
    end
end

function UniversalModules.MaxZoomValue(Number)
    ModedMaxZoom = Number
    if MaxZoomChange then
        CameraZoomAnimator(Speaker.CameraMaxZoomDistance, ModedMaxZoom, "Max")
    end
end

--|| Min Zoom Function ||--

function UniversalModules.MinZoom(Enabled)
    MinZoomChange = Enabled
    if Enabled then
        CameraZoomAnimator(Speaker.CameraMinZoomDistance, ModedMinZoom, "Min")
        LockConnections.MiZ = (LockConnections.MiZ and LockConnections.MiZ:Disconnect()) or Speaker:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function(MinZoom)
            if not MinCameraZooming then
                Speaker.CameraMinZoomDistance = ModedMinZoom
            end
        end)
    else
        LockConnections.MiZ = LockConnections.MiZ and LockConnections.MiZ:Disconnect()
        CameraZoomAnimator(Speaker.CameraMinZoomDistance, CurrentMinZoom, "Min")
    end
end

function UniversalModules.MinZoomValue(Number)
    ModedMinZoom = Number
    if MinZoomChange then
        CameraZoomAnimator(Speaker.CameraMinZoomDistance, ModedMinZoom, "Min")
    end
end

--|| Unlock Third Person Function ||--

function UniversalModules.UnlockThirdPerson(Enabled)
    if Enabled then
        CurrentCameraMode = Speaker.CameraMode
        Speaker.CameraMode = Enum.CameraMode.Classic
        LockConnections.UTP = (LockConnections.UTP and LockConnections.UTP:Disconnect()) or Speaker:GetPropertyChangedSignal("CameraMode"):Connect(function(CameraMode)
            Speaker.CameraMode = Enum.CameraMode.Classic
        end)
    else
        LockConnections.UTP = LockConnections.UTP and LockConnections.UTP:Disconnect()
        Speaker.CameraMode = CurrentCameraMode
    end
end

--|| Camera Noclip Function ||--

function UniversalModules.CameraNoclip(Enabled)
    if Enabled then
        CurrentCameraOcclusionMode = Speaker.DevCameraOcclusionMode
        Speaker.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        LockConnections.CNC = (LockConnections.CNC and LockConnections.CNC:Disconnect()) or Speaker:GetPropertyChangedSignal("DevCameraOcclusionMode"):Connect(function(OcclusionMode)
            Speaker.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        end)
    else
        LockConnections.CNC = LockConnections.CNC and LockConnections.CNC:Disconnect()
        Speaker.DevCameraOcclusionMode = CurrentCameraOcclusionMode
    end
end

--|| Allow Shift Lock Function ||--

function UniversalModules.AllowShiftLock(Enabled)
    if Enabled then
        CurrentShiftLock = Speaker.DevEnableMouseLock
        Speaker.DevEnableMouseLock = true
        LockConnections.ASL = (LockConnections.ASL and LockConnections.ASL:Disconnect()) or Speaker:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function(MouseLock)
            Speaker.DevEnableMouseLock = true
        end)
    else
        LockConnections.ASL = LockConnections.ASL and LockConnections.ASL:Disconnect()
        Speaker.DevEnableMouseLock = CurrentShiftLock
    end
end

--|| Anti Follow Camera Mode Function ||--

function UniversalModules.AntiFollowCameraMode(Enabled)
    if Enabled then
        CurrentCameraModePC = Speaker.DevComputerCameraMode
        CurrentCameraModeMobile = Speaker.DevTouchCameraMode
        Speaker.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.Classic
        Speaker.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.Classic
        LockConnections.AFCM = (LockConnections.AFCM and LockConnections.AFCM:Disconnect()) or Speaker:GetPropertyChangedSignal("DevComputerCameraMode"):Connect(function(CameraMode)
            Speaker.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.Classic
        end)
        LockConnections.AFCMM = (LockConnections.AFCMM and LockConnections.AFCMM:Disconnect()) or Speaker:GetPropertyChangedSignal("DevTouchCameraMode"):Connect(function(CameraMode)
            Speaker.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.Classic
        end)
    else
        LockConnections.AFCM = LockConnections.AFCM and LockConnections.AFCM:Disconnect()
        LockConnections.AFCMM = LockConnections.AFCMM and LockConnections.AFCMM:Disconnect()
        Speaker.DevComputerCameraMode = CurrentCameraModePC
        Speaker.DevTouchCameraMode = CurrentCameraModeMobile
    end
end

--|| Anti Gameplay Paused Function ||--

function UniversalModules.AntiGameplayPaused(Enabled)
    if Enabled then
        Speaker.GameplayPaused = false
        LockConnections.AGP = (LockConnections.AGP and LockConnections.AGP:Disconnect()) or Speaker:GetPropertyChangedSignal("GameplayPaused"):Connect(function()
            Speaker.GameplayPaused = false
        end)
    else
        LockConnections.AGP = LockConnections.AGP and LockConnections.AGP:Disconnect()
    end
end

--|| Fix Camera Function ||--

function UniversalModules.FixCamera()
    FreeCameraToggle:SetValue(false)
    SpectatePlayerToggle:SetValue(false)
    Heartbeat:Wait()
    Camera.CameraType = Enum.CameraType.Custom
    MaxZoomToggle:SetValue(false)
    MinZoomToggle:SetValue(false)
    Speaker.CameraMaxZoomDistance = 128
    Speaker.CameraMinZoomDistance = 0.5
    Speaker.CameraMode = Enum.CameraMode.Classic
    local Humanoid = Speaker.Character and Speaker.Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Camera.CameraSubject = Humanoid
    end
end

--|| Camera Offset Function ||--

RunService:BindToRenderStep("CameraOffset", 201, function()
    if CameraOffsetChange or CameraOffsetAnimating then
        Camera.CFrame = Camera.CFrame * CFrame.new(CameraOffsetInstance.Value)
    end
end)

function UniversalModules.CameraOffset(Enabled)
    CameraOffsetChange = Enabled
    if Enabled then
        CameraOffsetAnimator(CameraOffsetInstance.Value, ModedCameraOffset)
    else
        CameraOffsetAnimator(CameraOffsetInstance.Value, Vector3.new())
    end
end

function UniversalModules.CameraOffsetValue(X, Y, Z)
    local X = X or 0
    local Y = Y or 0
    local Z = Z or 0
    ModedCameraOffset = Vector3.new(X, Y, Z)
    if CameraOffsetChange then
        CameraOffsetAnimator(CameraOffsetInstance.Value, ModedCameraOffset)
    end
end

--|| Full Bright Function ||--

LockConnections.FB = {}
function UniversalModules.FullBright(Enabled)
    if Enabled then
        FullBrightChange = true
        if AmbientChange or BrightnessChange or ClockTimeChange or OutdoorAmbientChange then
            AmbientColorToggle:SetValue(false)
            BrightnessToggle:SetValue(false)
            ClockTimeToggle:SetValue(false)
            OutdoorAmbientToggle:SetValue(false)
            repeat
                Heartbeat:Wait()
            until not AmbientChange and not BrightnessChange and not ClockTimeChange and not OutdoorAmbientChange
            Heartbeat:Wait()
        end
        Stepped:Wait()
        CurrentAmbient = Lighting.Ambient
        CurrentBrightness = Lighting.Brightness
        CurrentClockTime = Lighting.ClockTime
        CurrentOutdoorAmbient = Lighting.OutdoorAmbient
        local function FB()
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        end
        FB()
        for _, Object in pairs(LockConnections.FB) do
            Object = typeof(Object) == "RBXScriptConnection" and Object:Disconnect()
        end
        LockConnections.FB = {
            A = Lighting:GetPropertyChangedSignal("Ambient"):Connect(FB),
            B = Lighting:GetPropertyChangedSignal("Brightness"):Connect(FB),
            C = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(FB),
            O = Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(FB)
        }
    else
        for _, Connection in pairs(LockConnections.FB) do
            Connection:Disconnect()
        end
        Lighting.Ambient = CurrentAmbient
        Lighting.Brightness = CurrentBrightness
        Lighting.ClockTime = CurrentClockTime
        Lighting.OutdoorAmbient = CurrentOutdoorAmbient
        FullBrightChange = false
    end
end

--|| Full Dark Function (?) ||--

function UniversalModules.FullDark(Enabled)
    FullDarkChange = Enabled
    if Enabled then
        CurrentExposureCompensation = Lighting.ExposureCompensation
        Lighting.ExposureCompensation = -Inf
        LockConnections.FD = (LockConnections.FD and LockConnections.FD:Disconnect()) or Lighting:GetPropertyChangedSignal("ExposureCompensation"):Connect(function(Exposure)
            Lighting.ExposureCompensation = -Inf
        end)
    else
        LockConnections.FD = LockConnections.FD and LockConnections.FD:Disconnect()
        Lighting.ExposureCompensation = CurrentExposureCompensation or 0
    end
end

--|| Full White Function (??) ||--

function UniversalModules.FullWhite(Enabled)
    FullWhiteChange = Enabled
    if Enabled then
        CurrentExposureCompensation = Lighting.ExposureCompensation
        Lighting.ExposureCompensation = Inf
        LockConnections.FW = (LockConnections.FW and LockConnections.FW:Disconnect()) or Lighting:GetPropertyChangedSignal("ExposureCompensation"):Connect(function(Exposure)
            Lighting.ExposureCompensation = Inf
        end)
    else
        LockConnections.FW = LockConnections.FW and LockConnections.FW:Disconnect()
        Lighting.ExposureCompensation = CurrentExposureCompensation or 0
    end
end

--|| Day Function (Super Full Bright) ||--

function UniversalModules.Day(Enabled)
    if Enabled then
        AdminSky = AdminSky and AdminSky:Destroy() or Instance.new("Sky", Lighting)
        LockConnections.DayR = (LockConnections.DayR and LockConnections.DayR:Disconnect()) or AdminSky:GetPropertyChangedSignal("Parent"):Connect(function(Parent)
            if Parent ~= Lighting then
                AdminSky = AdminSky and AdminSky:Destroy() or Instance.new("Sky", Lighting)
            end
        end)
        LockConnections.DayA = (LockConnections.DayA and LockConnections.DayA:Disconnect()) or Lighting.ChildAdded:Connect(function(Instance)
            if Instance ~= AdminSky then
                AdminSky = AdminSky and AdminSky:Destroy() or Instance.new("Sky", Lighting)
            end
        end)
    else
        LockConnections.DayR = LockConnections.DayR and LockConnections.DayR:Disconnect()
        LockConnections.DayA = LockConnections.DayA and LockConnections.DayA:Disconnect()
        AdminSky = AdminSky and AdminSky:Destroy()
    end
end

--|| No Atmosphere Function ||--

function UniversalModules.NoAtmosphere(Enabled)
    NoAtmosphereChange = Enabled
    if Enabled then
        repeat
            Heartbeat:Wait()
        until Lighting:FindFirstChildOfClass("Atmosphere") or not NoAtmosphereChange
        if NoAtmosphereChange then
            local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
            CurrentAtmosphereDensity = Atmosphere.Density
            Atmosphere.Density = 0
            LockConnections.NA = (LockConnections.NA and LockConnections.NA:Disconnect()) or Atmosphere:GetPropertyChangedSignal("Density"):Connect(function(Density)
                Atmosphere.Density = 0
            end)
            LockConnections.NAA = (LockConnections.NAA and LockConnections.NAA:Disconnect()) or Lighting.ChildAdded:Connect(function(Instance)
                if Instance:IsA("Atmosphere") then
                    Instance.Density = 0
                end
            end)
        end
    else
        LockConnections.NA = LockConnections.NA and LockConnections.NA:Disconnect()
        LockConnections.NAA = LockConnections.NAA and LockConnections.NAA:Disconnect()
        local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if Atmosphere and CurrentAtmosphereDensity then
            Atmosphere.Density = CurrentAtmosphereDensity
        end
    end
end

function UniversalModules.NoFog(Enabled)
    NoFogChange = Enabled
    if Enabled then
        CurrentFogEnd = Lighting.FogEnd
        CurrentFogStart = Lighting.FogStart
        Lighting.FogEnd = Inf
        Lighting.FogStart = Inf
        LockConnections.NF = (LockConnections.NF and LockConnections.NF:Disconnect()) or Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function(FogEnd)
            Lighting.FogEnd = Inf
        end)
        LockConnections.NF2 = (LockConnections.NF2 and LockConnections.NF2:Disconnect()) or Lighting:GetPropertyChangedSignal("FogStart"):Connect(function(FogStart)
            Lighting.FogEnd = Inf
        end)
    else
        LockConnections.NF = LockConnections.NF and LockConnections.NF:Disconnect()
        LockConnections.NF2 = LockConnections.NF2 and LockConnections.NF2:Disconnect()
        Lighting.FogEnd = CurrentFogEnd
        Lighting.FogStart = CurrentFogStart
    end
end

--|| No Depth Of Field Function ||--

function UniversalModules.NoDepthOfField(Enabled)
    NoDepthOfFieldChange = Enabled
    if Enabled then
        repeat
            Heartbeat:Wait()
        until Lighting:FindFirstChildOfClass("DepthOfFieldEffect") or not NoDepthOfFieldChange
        if NoDepthOfFieldChange then
            local DepthOfFieldEffect = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
            CurrentDepthOfField = DepthOfFieldEffect.Enabled
            DepthOfFieldEffect.Enabled = false
            LockConnections.NDOF = (LockConnections.NDOF and LockConnections.NDOF:Disconnect()) or DepthOfFieldEffect:GetPropertyChangedSignal("Enabled"):Connect(function(Enabled)
                DepthOfFieldEffect.Enabled = false
            end)
            LockConnections.NDOFA = (LockConnections.NDOFA and LockConnections.NDOFA:Disconnect()) or Lighting.ChildAdded:Connect(function(Instance)
                if Instance.ClassName == "DepthOfFieldEffect" then
                    Instance.Enabled = false
                end
            end)
        end
    else
        LockConnections.NDOF = LockConnections.NDOF and LockConnections.NDOF:Disconnect()
        LockConnections.NDOFA = LockConnections.NDOFA and LockConnections.NDOFA:Disconnect()
        local DepthOfFieldEffect = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
        if DepthOfFieldEffect and CurrentDepthOfField then
            DepthOfFieldEffect.Enabled = CurrentDepthOfField
        end
    end
end

--|| No Blur Function ||--

function UniversalModules.NoBlur(Enabled)
    NoBlurChange = Enabled
    if Enabled then
        repeat
            Heartbeat:Wait()
        until Lighting:FindFirstChildOfClass("BlurEffect")
        local BlurEffect = Lighting:FindFirstChildOfClass("BlurEffect") or not NoBlurChange
        if NoBlurChange then
            CurrentBlur = BlurEffect.Enabled
            BlurEffect.Enabled = false
            LockConnections.NB = (LockConnections.NB and LockConnections.NB:Disconnect()) or BlurEffect:GetPropertyChangedSignal("Enabled"):Connect(function(Enabled)
                BlurEffect.Enabled = false
            end)
            LockConnections.NBA = (LockConnections.NBA and LockConnections.NBA:Disconnect()) or Lighting.ChildAdded:Connect(function(Instance)
                if Instance.ClassName == "BlurEffect" then
                    Instance.Enabled = false
                end
            end)
        end
    else
        LockConnections.NB = LockConnections.NB and LockConnections.NB:Disconnect()
        LockConnections.NBA = LockConnections.NBA and LockConnections.NBA:Disconnect()
        local BlurEffect = Lighting:FindFirstChildOfClass("BlurEffect")
        if BlurEffect and CurrentBlur then
            BlurEffect.Enabled = CurrentBlur
        end
    end
end

--|| No Bloom Function ||--

function UniversalModules.NoBloom(Enabled)
    NoBloomChange = Enabled
    if Enabled then
        repeat
            Heartbeat:Wait()
        until Lighting:FindFirstChildOfClass("BloomEffect") or not NoBloomChange
        if NoBloomChange then
            local BloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")
            CurrentBloom = BloomEffect.Enabled
            BloomEffect.Enabled = false
            LockConnections.NBL = (LockConnections.NBL and LockConnections.NBL:Disconnect()) or BloomEffect:GetPropertyChangedSignal("Enabled"):Connect(function(Enabled)
                BloomEffect.Enabled = false
            end)
            LockConnections.NBLA = (LockConnections.NBLA and LockConnections.NBLA:Disconnect()) or Lighting.ChildAdded:Connect(function(Instance)
                if Instance.ClassName == "BloomEffect" then
                    Instance.Enabled = false
                end
            end)
        end
    else
        LockConnections.NBL = LockConnections.NBL and LockConnections.NBL:Disconnect()
        LockConnections.NBLA = LockConnections.NBLA and LockConnections.NBLA:Disconnect()
        local BloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")
        if BloomEffect and CurrentBloom then
            BloomEffect.Enabled = CurrentBloom
        end
    end
end

--|| Ambient Function ||--

function UniversalModules.Ambient(Enabled)
    if Enabled then
        AmbientChange = true
        repeat
            Heartbeat:Wait()
        until not FullBrightChange or not AmbientChange
        if AmbientChange then
            CurrentAmbient = Lighting.Ambient
            Lighting.Ambient = ModedAmbient
            LockConnections.A = (LockConnections.A and LockConnections.A:Disconnect()) or Lighting:GetPropertyChangedSignal("Ambient"):Connect(function(Color)
                Lighting.Ambient = ModedAmbient
            end)
        end
    else
        LockConnections.A = LockConnections.A and LockConnections.A:Disconnect()
        Lighting.Ambient = CurrentAmbient
        AmbientChange = false
    end
end

function UniversalModules.AmbientColor(Color)
    ModedAmbient = Color
    if AmbientChange then
        Lighting.Ambient = ModedAmbient
    end
end

--|| Brightness Function ||--

function UniversalModules.Brightness(Enabled)
    if Enabled then
        BrightnessChange = true
        repeat
            Heartbeat:Wait()
        until not FullBrightChange or not BrightnessChange
        if BrightnessChange then
            CurrentBrightness = Lighting.Brightness
            Lighting.Brightness = ModedBrightness
            LockConnections.B = (LockConnections.B and LockConnections.B:Disconnect()) or Lighting:GetPropertyChangedSignal("Brightness"):Connect(function(Value)
                Lighting.Brightness = ModedBrightness
            end)
        end
    else
        LockConnections.B = LockConnections.B and LockConnections.B:Disconnect()
        Lighting.Brightness = CurrentBrightness
        BrightnessChange = false
    end
end

function UniversalModules.BrightnessValue(Number)
    ModedBrightness = Number
    if BrightnessChange then
        Lighting.Brightness = ModedBrightness
    end
end

--|| ClockTime Function ||--

function UniversalModules.ClockTime(Enabled)
    if Enabled then
        ClockTimeChange = true
        repeat
            Heartbeat:Wait()
        until not FullBrightChange or not ClockTimeChange
        if ClockTimeChange then
            CurrentClockTime = Lighting.ClockTime
            Lighting.ClockTime = ModedClockTime
            LockConnections.CT = (LockConnections.CT and LockConnections.CT:Disconnect()) or Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function(Value)
                Lighting.ClockTime = ModedClockTime
            end)
        end
    else
        LockConnections.CT = LockConnections.CT and LockConnections.CT:Disconnect()
        Lighting.ClockTime = CurrentClockTime
        ClockTimeChange = false
    end
end

function UniversalModules.ClockTimeValue(Number)
    ModedClockTime = Number
    if ClockTimeChange then
        Lighting.ClockTime = ModedClockTime
    end
end

--|| Outdoor Ambient Function ||--

function UniversalModules.OutdoorAmbient(Enabled)
    if Enabled then
        OutdoorAmbientChange = true
        repeat
            Heartbeat:Wait()
        until not FullBrightChange or not OutdoorAmbientChange
        if OutdoorAmbientChange then
            CurrentOutdoorAmbient = Lighting.OutdoorAmbient
            Lighting.OutdoorAmbient = ModedOutdoorAmbient
            LockConnections.OA = (LockConnections.OA and LockConnections.OA:Disconnect()) or Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function(Color)
                Lighting.OutdoorAmbient = ModedOutdoorAmbient
            end)
        end
    else
        LockConnections.OA = LockConnections.OA and LockConnections.OA:Disconnect()
        Lighting.OutdoorAmbient = CurrentOutdoorAmbient
        OutdoorAmbientChange = false
    end
end

function UniversalModules.OutdoorAmbientColor(Color)
    ModedOutdoorAmbient = Color
    if OutdoorAmbientChange then
        Lighting.OutdoorAmbient = ModedOutdoorAmbient
    end
end

--|| Color Shift Bottom Function ||--

function UniversalModules.ColorShiftBottom(Enabled)
    ColorShiftBottomChange = Enabled
    if Enabled then
        CurrentColorShiftBottom = Lighting.ColorShift_Bottom
        Lighting.ColorShift_Bottom = ModedColorShiftBottom
        LockConnections.CSB = (LockConnections.CSB and LockConnections.CSB:Disconnect()) or Lighting:GetPropertyChangedSignal("ColorShift_Bottom"):Connect(function(Color)
            Lighting.ColorShift_Bottom = ModedColorShiftBottom
        end)
    else
        LockConnections.CSB = LockConnections.CSB and LockConnections.CSB:Disconnect()
        Lighting.ColorShift_Bottom = CurrentColorShiftBottom
    end
end

function UniversalModules.ColorShiftBottomColor(Color)
    ModedColorShiftBottom = Color
    if ColorShiftBottomChange then
        Lighting.ColorShift_Bottom = ModedColorShiftBottom
    end
end

--|| Color Shift Top Function ||--

function UniversalModules.ColorShiftTop(Enabled)
    ColorShiftTopChange = Enabled
    if Enabled then
        CurrentColorShiftTop = Lighting.ColorShift_Top
        Lighting.ColorShift_Top = ModedColorShiftTop
        LockConnections.CST = (LockConnections.CST and LockConnections.CST:Disconnect()) or Lighting:GetPropertyChangedSignal("ColorShift_Top"):Connect(function(Color)
            Lighting.ColorShift_Top = ModedColorShiftTop
        end)
    else
        LockConnections.CST = LockConnections.CST and LockConnections.CST:Disconnect()
        Lighting.ColorShift_Top = CurrentColorShiftTop
    end
end

function UniversalModules.ColorShiftTopColor(Color)
    ModedColorShiftTop = Color
    if ColorShiftTopChange then
        Lighting.ColorShift_Top = ModedColorShiftTop
    end
end

--|| Diffuse Scale Function ||--

function UniversalModules.DiffuseScale(Enabled)
    DiffuseScaleChange = Enabled
    if Enabled then
        CurrentDiffuseScale = Lighting.EnvironmentDiffuseScale
        Lighting.EnvironmentDiffuseScale = ModedDiffuseScale
        LockConnections.DS = (LockConnections.DS and LockConnections.DS:Disconnect()) or Lighting:GetPropertyChangedSignal("EnvironmentDiffuseScale"):Connect(function(Value)
            Lighting.EnvironmentDiffuseScale = ModedDiffuseScale
        end)
    else
        LockConnections.DS = LockConnections.DS and LockConnections.DS:Disconnect()
        Lighting.EnvironmentDiffuseScale = CurrentDiffuseScale or 0
    end
end

function UniversalModules.DiffuseScaleValue(Number)
    ModedDiffuseScale = Number
    if DiffuseScaleChange then
        Lighting.EnvironmentDiffuseScale = ModedDiffuseScale
    end
end

--|| Specular Scale Function ||--

function UniversalModules.SpecularScale(Enabled)
    SpecularScaleChange = Enabled
    if Enabled then
        CurrentSpecularScale = Lighting.EnvironmentSpecularScale
        Lighting.EnvironmentSpecularScale = ModedSpecularScale
        LockConnections.SS = (LockConnections.SS and LockConnections.SS:Disconnect()) or Lighting:GetPropertyChangedSignal("EnvironmentSpecularScale"):Connect(function(Value)
            Lighting.EnvironmentSpecularScale = ModedSpecularScale
        end)
    else
        LockConnections.SS = LockConnections.SS and LockConnections.SS:Disconnect()
        Lighting.EnvironmentSpecularScale = CurrentSpecularScale or 0
    end
end

function UniversalModules.SpecularScaleValue(Number)
    ModedSpecularScale = Number
    if SpecularScaleChange then
        Lighting.EnvironmentSpecularScale = ModedSpecularScale
    end
end

--|| Shadow Softness Function ||--

function UniversalModules.ShadowSoftness(Enabled)
    ShadowSoftnessChange = Enabled
    if Enabled then
        CurrentShadowSoftness = Lighting.ShadowSoftness
        Lighting.ShadowSoftness = ModedShadowSoftness
        LockConnections.SSf = (LockConnections.SSf and LockConnections.SSf:Disconnect()) or Lighting:GetPropertyChangedSignal("ShadowSoftness"):Connect(function(Value)
            Lighting.ShadowSoftness = ModedShadowSoftness
        end)
    else
        LockConnections.SSf = LockConnections.SSf and LockConnections.SSf:Disconnect()
        Lighting.ShadowSoftness = CurrentShadowSoftness or 0.5
    end
end

function UniversalModules.ShadowSoftnessValue(Number)
    ModedShadowSoftness = Number
    if ShadowSoftnessChange then
        Lighting.ShadowSoftness = ModedShadowSoftness
    end
end

--|| Geographic Latitude Function ||--

function UniversalModules.GeographicLatitude(Enabled)
    GeographicLatitudeChange = Enabled
    if Enabled then
        CurrentGeographicLatitude = Lighting.GeographicLatitude
        Lighting.GeographicLatitude = ModedGeographicLatitude
        LockConnections.GL = (LockConnections.GL and LockConnections.GL:Disconnect()) or Lighting:GetPropertyChangedSignal("GeographicLatitude"):Connect(function(Value)
            Lighting.GeographicLatitude = ModedGeographicLatitude
        end)
    else
        LockConnections.GL = LockConnections.GL and LockConnections.GL:Disconnect()
        Lighting.GeographicLatitude = CurrentGeographicLatitude
    end
end

function UniversalModules.GeographicLatitudeValue(Number)
    ModedGeographicLatitude = Number
    if GeographicLatitudeChange then
        Lighting.GeographicLatitude = ModedGeographicLatitude
    end
end

--|| God Function ||--

function UniversalModules.God()
    local Character = Speaker.Character
    if not Character then
        NotifySound(GlobalText.NoCharacterWarn, 5)
        return warn(GlobalText.NoCharacterWarn)
    end
    if FreeCameraRunning then
        FreeCameraToggle:SetValue(false)
    end
    if Spectating then
        SpectatePlayerToggle:SetValue(false)
    end
    Heartbeat:Wait()
    local Position = Camera.CFrame
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if Humanoid then
        local CloneHumanoid = Humanoid:Clone(Humanoid)
        CloneHumanoid.Parent = Character
        Speaker.Character = nil
        CloneHumanoid:SetStateEnabled(15, false)
        CloneHumanoid:SetStateEnabled(1, false)
        CloneHumanoid:SetStateEnabled(0, false)
        CloneHumanoid.BreakJointsOnDeath = false
        Humanoid = Humanoid:Destroy(Humanoid)
        Speaker.Character = Character
        Camera.CameraSubject = CloneHumanoid
        Camera.CFrame = Heartbeat:Wait() and Position
        CloneHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        local Script = Character:FindFirstChild("Animate")
        if Script then
            Script.Disabled = true
            Heartbeat:Wait()
            Script.Disabled = false
        end
        CloneHumanoid.Health = CloneHumanoid.MaxHealth
        NotifySound(GlobalText.GodSuccess, 5)
    end
end

--|| Invisible Function ||--

function UniversalModules.Invisible()
    if InvisibleRunning then
        return
    end
    if Spining then
        SpinToggle:SetValue(false)
    end
    InvisibleRunning = true
    local Character = Speaker.Character
    if not Character then
        NotifySound(GlobalText.NoCharacterWarn, 5)
        InvisibleRunning = false
        return warn(GlobalText.NoCharacterWarn)
    end
    Character.Archivable = true
    local IsInvis = false
    local InvisibleCharacter = Character:Clone()
    InvisibleCharacter.Parent = Lighting
    if not AntiVoid then
	    AntiVoidToggle:SetValue(true)
    end
	InvisibleCharacter.Name = Speaker.Name

    function UniversalModules.InvisTransparency()
        if not InvisibleRunning then
            return
        end
        for _, Object in pairs(InvisibleCharacter:GetDescendants()) do
            if Object:IsA("BasePart") then
                if Object.Name == "HumanoidRootPart" then
                    Object.Transparency = 1
                else
                    Object.Transparency = InvisibleTransparency or 0
                end
            end
        end
    end
    UniversalModules.InvisTransparency()

    function InvisRespawn()
		if IsInvis == true then
			pcall(function()
				Speaker.Character = Character
				Heartbeat:Wait()
				Character.Parent = Workspace
                Character:WaitForChild("HumanoidRootPart").Anchored = false
				IsInvis = false
				InvisibleCharacter = InvisibleCharacter and InvisibleCharacter:Destroy()
				invisRunning = false
			end)
		elseif IsInvis == false then
			pcall(function()
				Speaker.Character = Character
				Heartbeat:Wait()
				Character.Parent = Workspace
                Character:WaitForChild("HumanoidRootPart").Anchored = false
				TurnVisible()
			end)
		end
    end

    LockConnections.InvisDied = (LockConnections.InvisDied and LockConnections.InvisDied:Disconnect()) or InvisibleCharacter:WaitForChild("Humanoid").Died:Connect(function()
        InvisRespawn()
        LockConnections.InvisDied:Disconnect()
    end)

    if IsInvis == true then
        return
    end
	IsInvis = true
	CF = Camera.CFrame
    InvisibleCharacter = InvisibleCharacter
    local RootPart = Character:WaitForChild("HumanoidRootPart")
	local CF1 = RootPart.CFrame
	Camera.CameraType = Enum.CameraType.Scriptable
	Character:MoveTo(Vector3.new(0, math.pi * 1e6, 0))
    RootPart.Anchored = true
    UniversalModules.SpectatePlayer(false)
	task.wait(.1)
	Camera.CameraType = Enum.CameraType.Custom
	Character.Parent = Lighting
	InvisibleCharacter.Parent = workspace
	InvisibleCharacter.HumanoidRootPart.CFrame = CF1
	Speaker.Character = InvisibleCharacter
    Camera.CameraSubject = Speaker.Character:FindFirstChild("Humanoid")
	Camera.CameraType = "Custom"
    Speaker.CameraMode = "Classic"
    InvisibleCharacter:FindFirstChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	Speaker.Character.Animate.Disabled = true
    Heartbeat:Wait()
	Speaker.Character.Animate.Disabled = false

    function TurnVisible()
		if IsInvis == false then
            return
        end
		LockConnections.InvisDied = LockConnections.InvisDied and LockConnections.InvisDied:Disconnect()
		CF = Camera.CFrame
		Character = Character
		local CF1 = Speaker.Character.HumanoidRootPart.CFrame
		Character.HumanoidRootPart.CFrame = CF1
		InvisibleCharacter:Destroy()
		Speaker.Character = Character
		Character.Parent = Workspace
		IsInvis = false
		Speaker.Character.Animate.Disabled = true
        Heartbeat:Wait()
		Speaker.Character.Animate.Disabled = false
        Character:WaitForChild("HumanoidRootPart").Anchored = false
		LockConnections.InvisDied = Character:FindFirstChild("Humanoid").Died:Connect(function()
			InvisRespawn()
			LockConnections.InvisDied:Disconnect()
		end)
		InvisibleRunning = false
	end
    NotifySound(GlobalText.InvisSuccess, 5)
end

function UniversalModules.Visible()
    if InvisibleRunning then
        TurnVisible()
    end
end

--|| Fling Function ||--

function UniversalModules.Fling(Enabled)
    if Enabled then
        if Flinging then
            return
        end
        Flinging = false
        if not Speaker.Character then
            NotifySound(GlobalText.NoCharacterWarn, 5)
            return warn(GlobalText.NoCharacterWarn)
        end
        if WalkFlinging then
            UniversalModules.WalkFling(false)
        end
        if Spining then
            SpinToggle:SetValue(false)
        end
        local Character = Speaker.Character
        for _, Object in pairs(Character:GetDescendants()) do
            if Object:IsA("BasePart") then
                Object.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
            end
        end
        NoclipToggle:SetValue(true)
        FlingBAV = Instance.new("BodyAngularVelocity", Character and Character:WaitForChild("HumanoidRootPart"))
        FlingBAV.Name = "Fling"
        FlingBAV.AngularVelocity = Vector3.new(0, 1e5, 0)
        FlingBAV.MaxTorque = Vector3.new(0, Inf, 0)
        FlingBAV.P = Inf
        for _, Children in next, Character:GetChildren() do
            if Children:IsA("BasePart") then
                Children.CanCollide = false
                Children.Massless = true
                Children.Velocity = Vector3.new()
            end
        end
        Flinging = true
        LockConnections.FlingDied = Character:WaitForChild("Humanoid").Died:Connect(function()
            FlingToggle:SetValue(false)
        end)
        repeat
            if FlingBAV then
                FlingBAV.AngularVelocity = Vector3.new(0, 1e5, 0)
            end
            task.wait(.2)
            if FlingBAV then
                FlingBAV.AngularVelocity = Vector3.new()
            end
            task.wait(.1)
        until not Flinging
    else
        LockConnections.FlingDied = LockConnections.FlingDied and LockConnections.FlingDied:Disconnect()
        Flinging = false
        FlingBAV = FlingBAV and FlingBAV:Destroy()
        local Character = Speaker.Character
        if Character then
            for _, Object in pairs(Character:GetDescendants()) do
                if Object:IsA("BasePart") then
                    Object.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                end
            end
        end
    end
end

--|| Walk Fling Function ||--

function UniversalModules.WalkFling(Enabled)
    if Enabled then
        if WalkFlinging then
            return
        end
        WalkFlinging = false
        if not Speaker.Character then
            NotifySound(GlobalText.NoCharacterWarn, 5)
            return warn(GlobalText.NoCharacterWarn)
        end
        if Flinging then
            UniversalModules.Fling(false)
        end
        if Spining then
            SpinToggle:SetValue(false)
        end
        local Humanoid = Speaker.Character:WaitForChild("Humanoid")
        LockConnections.WalkFlingDied = Humanoid and Humanoid.Died:Connect(function()
            FlingToggle:SetValue(false)
        end)
        NoclipToggle:SetValue(true)
        WalkFlinging = true
        repeat
            Heartbeat:Wait()
            local Character = Speaker.Character
            local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            local Velocity = nil
            local Movement = 0.1
            while not (Character and Character.Parent and RootPart and RootPart.Parent) do
                Heartbeat:Wait()
                Character = Speaker.Character
                RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            end
            Velocity = RootPart.Velocity
            RootPart.Velocity = Velocity * 9e9 + Vector3.new(0, 9e9, 0)
            RenderStepped:Wait()
            if Character and Character.Parent and RootPart and RootPart.Parent then
                RootPart.Velocity = Velocity
            end
            Stepped:Wait()
            if Character and Character.Parent and RootPart and RootPart.Parent then
                RootPart.Velocity = Velocity + Vector3.new(0, Movement, 0)
                Movement = Movement * -1
            end
        until not WalkFlinging
    else
        LockConnections.WalkFlingDied = LockConnections.WalkFlingDied and LockConnections.WalkFlingDied:Disconnect()
        WalkFlinging = false
    end
end

--|| InvisFling Function ||--

function UniversalModules.InvisFling()
    if InvisFlinging or InvisFlinged then
        NotifySound(GlobalText.InvisFlingWarn, 5)
        return warn(GlobalText.InvisFlingWarn)
    end
    if Spining then
        SpinToggle:SetValue(false)
    end
    InvisFlinging = true
    FlingToggle:SetValue(false)
    FlyToggle:SetValue(false)
    UniversalModules.God()
    Heartbeat:Wait()
    Character = Speaker.Character
    if not Character then
        NotifySound(GlobalText.NoCharacterWarn, 5)
        return warn(GlobalText.NoCharacterWarn)
    end
    Model = Instance.new("Model", Character)
    Model.Name = Speaker.Name
    local Torso = Instance.new("Part")
    Torso.Name = "Torso"
    Torso.CanCollide = false
    Torso.Anchored = true
    local Head = Instance.new("Part", Model)
    Head.Name = "Head"
    Head.CanCollide = false
    Head.Anchored = true
    local Humanoid = Instance.new("Humanoid", Model)
    Humanoid.Name = "Humanoid"
    Torso.Position = Vector3.new(0, 9999, 0)
    Speaker.Character = Model
    Heartbeat:Wait()
    Speaker.Character = Character
    Heartbeat:Wait()
    local Humanoid = Instance.new("Humanoid", Character)
    Head:Clone()
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    for _, Children in pairs(Character:GetChildren()) do
        if Children ~= RootPart and Children.Name ~= "Humanoid" then
            Children:Destroy()
        end
    end
    RootPart.Transparency = 0
    RootPart.Color = Color3.new(1, 1, 1)
    LockConnections.InvisFling = (LockConnections.InvisFling and LockConnections.InvisFling:Disconnect()) or Stepped:Connect(function()
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character:FindFirstChild("HumanoidRootPart").CanCollide = false
        else
            LockConnections.InvisFling:Disconnect()
        end
    end)
    task.spawn(function()
        FlyToggle:SetValue(true)
        UniversalModules.SpectatePlayer(false)
        Camera.CameraSubject = RootPart
        FlingToggle:SetValue(false)
        FlingModeDropdown:SetValue(GlobalText.WalkFling)
        Heartbeat:Wait()
        FlingToggle:SetValue(true)
    end)
    InvisFlinged = true
    NotifySound(GlobalText.InvisFlingNotify, 5)
end

--|| Anti Fling Function ||--

AntiFlingNoclipParts = {}
function UniversalModules.AntiFling(Enabled)
    if Enabled then
        AntiFlingNoclipParts = {}
        LockConnections.AntiFling = (LockConnections.AntiFling and LockConnections.AntiFling:Disconnect()) or Stepped:Connect(function()
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= Speaker and Player.Character then
                    for _, Object in pairs(Player.Character:GetDescendants()) do
                        if Object:IsA("BasePart") then
                            if AntiFlingMethod == 1 and Object.CanCollide then
                                Object.CanCollide = false
                                if not table.find(AntiFlingNoclipParts, Object) then
                                    table.insert(AntiFlingNoclipParts, Object)
                                end
                            elseif AntiFlingMethod == 2 then
                                Object.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                                Object.Velocity = Vector3.new()
                            elseif AntiFlingMethod == 3 and Object.CanCollide then
                                Object.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                                Object.Velocity = Vector3.new()
                                Object.CanCollide = false
                                if not table.find(AntiFlingNoclipParts, Object) then
                                    table.insert(AntiFlingNoclipParts, Object)
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        LockConnections.AntiFling = LockConnections.AntiFling and LockConnections.AntiFling:Disconnect()
        for _, Object in pairs(AntiFlingNoclipParts) do
            Object.CanCollide = true
        end
        AntiFlingNoclipParts = {}
    end
end

--|| Swim Function ||--

function UniversalModules.Swim(Enabled)
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        GravityToggle:SetValue(false)
        if not Swimming and Humanoid then
            CurrentGravity = Workspace.Gravity
            Workspace.Gravity = 0
            local Enums = Enum.HumanoidStateType:GetEnumItems()
            table.remove(Enums, table.find(Enums, Enum.HumanoidStateType.None))
            for _, EnumItem in pairs(Enums) do
                Humanoid:SetStateEnabled(EnumItem, false)
            end
            Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            LockConnections.Swim = (LockConnections.Swim and LockConnections.Swim:Disconnect()) or Heartbeat:Connect(function()
                pcall(function()
                    Speaker.Character.HumanoidRootPart.Velocity = (Speaker.Character.Humanoid.MoveDirection ~= Vector3.new() or UserInputService:IsKeyDown(Enum.KeyCode.Space) and Speaker.Character.HumanoidRootPart.Velocity or Vector3.new())
                end)
            end)
            Swimming = true
        end
    else
        LockConnections.Swim = LockConnections.Swim and LockConnections.Swim:Disconnect()
        Workspace.Gravity = CurrentGravity
        Swimming = false
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                local Enums = Enum.HumanoidStateType:GetEnumItems()
                table.remove(Enums, table.find(Enums, Enum.HumanoidStateType.None))
                for _, EnumItem in pairs(Enums) do
                    Humanoid:SetStateEnabled(EnumItem, true)
                end
            end
        end
    end
end

--|| Animations ||--

--// Spasm \\--
function UniversalModules.Spasm(Enabled)
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        if Humanoid.RigType ~= 0 then
            NotifySound(GlobalText.R6Only, 5)
            return warn(GlobalText.R6Only)
        end
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://33796059"
        Spasm = Humanoid:LoadAnimation(Animation)
        Spasm:Play()
        Spasm:AdjustSpeed(SpasmSpeed or 99)
    else
        if Spasm then
            Spasm:Stop()
            Spasm:Destroy()
        end
    end
end

--// Head Throw \\--
function UniversalModules.HeadThrow()
    local Character = Speaker.Character
    if not Character then
        NotifySound(GlobalText.NoCharacterWarn, 5)
        return warn(GlobalText.NoCharacterWarn)
    end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then
        return
    end
    if Humanoid.RigType ~= 0 then
        NotifySound(GlobalText.R6Only, 5)
        return warn(GlobalText.R6Only)
    end
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://35154961"
    HeadThrow = Humanoid:LoadAnimation(Animation)
    HeadThrow:Play(0)
    HeadThrow:AdjustSpeed(1)
end

--// Lay Down \\--
function UniversalModules.LayDown()
    local Character = Speaker.Character
    if not Character then
        NotifySound(GlobalText.NoCharacterWarn, 5)
        return warn(GlobalText.NoCharacterWarn)
    end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then
        return
    end
    if Humanoid then
        Humanoid.Sit = true
        task.wait(.1)
        Humanoid.RootPart.CFrame = Humanoid.RootPart.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)
        for _, Object in pairs(Character:GetPlayingAnimationTracks()) do
            Object:Stop()
        end
    end
end

--// Carpet \\--
function UniversalModules.Carpet(Enabled)
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        if Humanoid.RigType ~= 0 then
            NotifySound(GlobalText.R6Only, 5)
            return warn(GlobalText.R6Only)
        end
        CarpetAnimation = Instance.new("Animation")
        CarpetAnimation.AnimationId = "rbxassetid://282574440"
        Carpet = Humanoid:LoadAnimation(CarpetAnimation)
        Carpet:Play(.1, 1, 1)
        LockConnections.CarpetDied = Humanoid.Died:Connect(function()
            Carpet:Stop()
            CarpetAnimation:Destroy()
            LockConnections.CarpetDied = LockConnections.CarpetDied and LockConnections.CarpetDied:Disconnect()
            LockConnections.CarpetLoop = LockConnections.CarpetLoop and LockConnections.CarpetLoop:Disconnect()
        end)
        if AnimationPlayer then
            local Player = Players:FindFirstChild(AnimationPlayer)
            local Character = Player and Player.Character
            if Player and Character then
                LockConnections.CarpetLoop = (LockConnections.CarpetLoop and LockConnections.CarpetLoop:Disconnect()) or Heartbeat:Connect(function()
                    pcall(function()
                        if Character.Humanoid.RigType ~= 0 then
                            Speaker.Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, -2, 0)
                        else
                            local LeftUpperLeg = Character:FindFirstChild("LeftUpperLeg")
                            local LeftLowerLeg = Character:FindFirstChild("LeftLowerLeg")
                            local LeftFoot = Character:FindFirstChild("LeftFoot")
                            local Offset = CFrame.new(0, -(LeftUpperLeg.Size.Y + LeftLowerLeg.Size.Y + LeftFoot.Size.Y), 0)
                            Speaker.Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * Offset
                        end
                    end)
                end)
            end
        end
    else
        if Carpet then
            LockConnections.CarpetDied = LockConnections.CarpetDied and LockConnections.CarpetDied:Disconnect()
            LockConnections.CarpetLoop = LockConnections.CarpetLoop and LockConnections.CarpetLoop:Disconnect()
            Carpet:Stop()
            CarpetAnimation:Destroy()
        end
    end
end

--// Rape \\--
function UniversalModules.Rape(Enabled)
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        RapeAnimation = Instance.new("Animation")
        RapeAnimation.AnimationId = (Humanoid.RigType == 0 and "rbxassetid://148840371") or "rbxassetid://5918726674"
        Rape = Humanoid:LoadAnimation(RapeAnimation)
        Rape:Play(.1, 1, 1)
        Rape:AdjustSpeed(RapeSpeed)
        LockConnections.RapeDied = Humanoid.Died:Connect(function()
            Rape:Stop()
            RapeAnimation:Destroy()
            LockConnections.RapeDied:Disconnect()
            LockConnections.RapeLoop = LockConnections.RapeLoop and LockConnections.RapeLoop:Disconnect()
        end)
        if AnimationPlayer then
            local Player = Players:FindFirstChild(AnimationPlayer)
            local Character = Player and Player.Character
            if Player and Character then
                LockConnections.RapeLoop = (LockConnections.RapeLoop and LockConnections.RapeLoop:Disconnect()) or Heartbeat:Connect(function()
                    pcall(function()
                        Speaker.Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1)
                    end)
                end)
            end
        end
    else
        if Rape then
            LockConnections.RapeDied = LockConnections.RapeDied and LockConnections.RapeDied:Disconnect()
            LockConnections.RapeLoop = LockConnections.RapeLoop and LockConnections.RapeLoop:Disconnect()
            Rape:Stop()
            RapeAnimation:Destroy()
        end
    end
end

--// Custom Animation \\--
function UniversalModules.CustomAnimation(AnimationID, Speed)
    local Character = Speaker.Character
    if not Character then
        NotifySound(GlobalText.NoCharacterWarn, 5)
        return warn(GlobalText.NoCharacterWarn)
    end
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if Humanoid then
        CustomAnimation = Instance.new("Animation")
        CustomAnimation.AnimationId = "rbxassetid://" .. AnimationID
        Custom = Humanoid:LoadAnimation(CustomAnimation)
        Custom:Play()
        Custom:AdjustSpeed(AnimationSpeed)
    end
end

--// Animation Speed \\--
function UniversalModules.LockAnimationSpeed(Enabled)
    if Enabled then
        LockConnections.AnimationSpeed = (LockConnections.AnimationSpeed and LockConnections.AnimationSpeed:Disconnect()) or RenderStepped:Connect(function()
            local Character = Speaker.Character
            local Humanoid = Character and Character:FindFirstChild("Humanoid")
            if Humanoid then
                for _, Object in next, Humanoid:GetPlayingAnimationTracks() do
                    Object:AdjustSpeed(AnimationSpeed)
                end
            end
        end)
    else
        LockConnections.AnimationSpeed = LockConnections.AnimationSpeed and LockConnections.AnimationSpeed:Disconnect()
    end
end

function UniversalModules.AnimationSpeed(Number)
    AnimationSpeed = Number
    local Character = Speaker.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if Humanoid then
        for _, Object in next, Humanoid:GetPlayingAnimationTracks() do
            Object:AdjustSpeed(AnimationSpeed or 1)
        end
    end
end

--// Disable Animations \\--
function UniversalModules.DisableAnimations(Enabled)
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Animate = Character:WaitForChild("Animate")
        if Animate then
            Animate.Disabled = true
        end
    else
        local Character = Speaker.Character
        local Animate = Character and Character:FindFirstChild("Animate")
        if Animate then
            Animate.Disabled = false
        end
    end
end

--// Freeze Animations \\--
function UniversalModules.FreezeAnimations(Enabled)
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        LockConnections.FZA = RenderStepped:Connect(function()
            for _, Object in pairs(Humanoid:GetPlayingAnimationTracks()) do
                Object:AdjustSpeed(0)
            end
        end)
    else
        LockConnections.FZA = LockConnections.FZA and LockConnections.FZA:Disconnect()
        local Character = Speaker.Character
        local Humanoid = Character and Character:FindFirstChild("Humanoid")
        if Humanoid then
            for _, Object in pairs(Humanoid:GetPlayingAnimationTracks()) do
                Object:AdjustSpeed(1)
            end
        end
    end
end

--// Copy Player's Animation \\--
function UniversalModules.CopyPlayerAnimation(Player)
    local Character = Speaker.Character
    if not Character then
        NotifySound(GlobalText.NoCharacterWarn, 5)
        return warn(GlobalText.NoCharacterWarn)
    end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then
        return
    end
    if AnimationPlayer then
        local Player = Players:FindFirstChild(AnimationPlayer)
        local Character = Player and Player.Character
        local PlayerHumanoid = Character and Character:FindFirstChild("Humanoid")
        if Player and Character and PlayerHumanoid then
            for _, Object in pairs(Humanoid:GetPlayingAnimationTracks()) do
                Object:Stop()
            end
            for _, Object in pairs(PlayerHumanoid:GetPlayingAnimationTracks()) do
                if not string.find(Object.Animation.AnimationId, "507768375") then
                    local Track = Humanoid:LoadAnimation(Object.Animation)
                    Track:Play(.1, 1, Object.Speed)
                    Track.TimePosition = Object.TimePosition
                    task.spawn(function()
                        Object.Stopped:Wait()
                        Track:Stop()
                        Track:Destroy()
                    end)
                    return
                end
            end
        end
    end
end

--|| Speaker Died Connection ||--

LockConnections.SpeakerDied = Speaker.CharacterRemoving:Connect(function()
    if InvisFlinged then
        InvisFlinged = false
        InvisFlinging = false
    end
    Speaker.CharacterAdded:Wait()
    if Spining then
        SpinToggle:SetValue(false)
        Heartbeat:Wait()
        SpinToggle:SetValue(true)
    end
    if Swimming then
        UniversalModules.Swim(false)
        Heartbeat:Wait()
        UniversalModules.Swim(true)
    end
    FlingToggle:SetValue(false)
    if UniversalModules.Flying and not StopFlyOnDied then
        UniversalModules.Fly(false)
        Heartbeat:Wait()
        UniversalModules.Fly(true)
    end
end)

--|| Exit Function ||--

function UniversalModules:Exit()
    NoEasingAnimator = true
    local Disconnect
    Disconnect = function(Object)
        if typeof(Object) == "RBXScriptConnection" then
            Object:Disconnect()
        elseif typeof(Object) == "table" then
            for _, Object2 in pairs(Object) do
                Disconnect(Object2)
            end
        end
    end
    Disconnect(LockConnections)
    Disconnect(FreeCameraInput)
    RunService:UnbindFromRenderStep("FOVAnimator")
    RunService:UnbindFromRenderStep("CameraOffsetAnimator")
    RunService:UnbindFromRenderStep("CameraMaxZoomAnimator")
    RunService:UnbindFromRenderStep("CameraMinZoomAnimator")
    RunService:UnbindFromRenderStep("PlayerScaleAnimator")
    RunService:UnbindFromRenderStep("CameraOffset")
    CameraOffsetInstance = CameraOffsetInstance and CameraOffsetInstance:Destroy()
    Unloaded = true
    setmetatable(UniversalModules, nil)
end

--|| Return Table ||--

return UniversalModules
