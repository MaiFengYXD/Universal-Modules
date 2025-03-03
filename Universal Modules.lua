--[[

$$\      $$\ $$$$$$$$\                              ~
$$$\    $$$ |$$  _____|                              
$$$$\  $$$$ |$$ |       $$$$$$\   $$$$$$\   $$$$$$\  
$$\$$\$$ $$ |$$$$$\    $$  __$$\ $$  __$$\ $$  __$$\ 
$$ \$$$  $$ |$$  __|   $$$$$$$$ |$$$$$$$$ |$$$$$$$$ |
$$ |\$  /$$ |$$ |      $$   ____|$$   ____|$$   ____|
$$ | \_/ $$ |$$ |      \$$$$$$$\ \$$$$$$$\ \$$$$$$$\ 
\__|     \__|\__|       \_______| \_______| \_______| 

Creator | MaiFengYXD
License | CC0-1.0
Version | 0.0.8 (Stable)

# Project Started on 2024-11-13 #
# This Version was Last Edited on 2025-03-02 #

Issues Report on Github or https://discord.gg/YBQUd8X8PK
QQ: 3607178523

]]--



--|| Variables ||--

--// Services and Modules \\--
UniversalModules = {}
LockConnections = {}
Cloneref = cloneref or function(x) return x end
Workspace = Cloneref(game:GetService("Workspace"))
Players = Cloneref(game:GetService("Players"))
RunService = Cloneref(game:GetService("RunService"))
UserInputService = Cloneref(game:GetService("UserInputService"))
Lighting = Cloneref(game:GetService("Lighting"))
Heartbeat = RunService.Heartbeat
Stepped = RunService.Stepped

--// Movement and Camera Settings \\--
Speaker = Players.LocalPlayer
Humanoid = Speaker.Character:FindFirstChild("Humanoid")
Camera = Workspace.CurrentCamera

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
AFKTime = 60
AFKTimes = 0

--// Mouse and Target FPS \\--
FPSOK, FPSFAILD = pcall(function()
    UniversalModules.CurrentFPS = getfpscap()
end)
if FPSFAILD then
    UniversalModules.CurrentFPS = 240
end

Mouse = Speaker:GetMouse()
TargetFPS = UniversalModules.CurrentFPS

--// Flying Mode \\--
UniversalModules.Flying = false
VFly = false
SitFly = false
QEFly = true
UseFlyGyro = true
StopFlyOnDied = true
UseUpVector = true
FlySpeed = 30
VerticalFlySpeedMultipiler = 1

--// Fling Settings \\--
InvisibleRunning = false
Flinging = false
WalkFlinging = false
InvisFlinging = false
InvisFlinged = false

--// Game Flag \\--
Weaponry = (game.PlaceId == 3297964905 and true) or false

--|| AntiAFK Function ||--

function UniversalModules.AntiAFK(Enabled)
    AntiAFKEnabled = Enabled
    if Enabled then
        local function ResetTimer()
            AFKTimer = 0
        end
        ResetTimer()
        AFKConnectionBegan = UserInputService.InputBegan:Connect(ResetTimer)
        AFKConnectionChanged = UserInputService.InputChanged:Connect(ResetTimer)
        AFKConnectionEnded = UserInputService.InputEnded:Connect(ResetTimer)
        while AntiAFKEnabled do
            wait(0.5)
            AFKTimer = AFKTimer + 0.5
            if AFKTimer >= AFKTime then
                AFKTimes = AFKTimes + 1
                if AntiAFKNotifyEnabled then
                    Library:Notify((GlobalText.AntiAFKNotify .. AFKTimes .. GlobalText.AntiAFKNotify2), 3)
                end
                if AFKMousemoverel then
                    mousemoverel(0, -5)
                    Heartbeat:Wait()
                    mousemoverel(0, 5)
                    ResetTimer()
                elseif AFKMousemoveabs then
                    local MousePos = Vector2.new(Mouse.X, Mouse.Y)
                    mousemoveabs(0, 0)
                    Heartbeat:Wait()
                    mousemoveabs(MousePos)
                    ResetTimer()
                elseif AFKMouseClick1 then
                    mouse1press()
                    Heartbeat:Wait()
                    mouse1release()
                    ResetTimer()
                else
                    mouse2press()
                    Heartbeat:Wait()
                    mouse2release()
                    ResetTimer()
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

function UniversalModules.AntiKick()
    if hookmetamethod then
        local Index
        local NameCall
        Index = hookmetamethod(game, "__index", function(Self, Method)
            if Self == Speaker and Method:lower() == "kick" then
                return error("Expected ':' not '.' calling member function Kick", 2)
            end
            return Index(Self, Method)
        end)
        NameCall = hookmetamethod(game, "__namecall", function(Self, ...)
            if Self == Speaker and getnamecallmethod():lower() == "kick" then
                return
            end
            return NameCall(Self, ...)
        end)
    else
        Library:Notify(GlobalText.CantAntiKick, 5)
        return warn(GlobalText.CantAntiKick)
    end
end

--|| Walk Speed Function ||--

function UniversalModules.WalkSpeed(Enabled)
    WalkSpeedChange = Enabled
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        if Humanoid then
            CurrentWalkSpeed = Humanoid.WalkSpeed
            Humanoid.WalkSpeed = ModedWalkSpeed
        end
        LockConnections.WS = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            Humanoid.WalkSpeed = ModedWalkSpeed
        end)
        LockConnections.WSCA = Speaker.CharacterAdded:Connect(function(Character)
            local Humanoid = Character:WaitForChild("Humanoid")
            if Humanoid then
                CurrentWalkSpeed = Humanoid.WalkSpeed
                Humanoid.WalkSpeed = ModedWalkSpeed
            end
            LockConnections.WS = (LockConnections.WS and LockConnections.WS:Disconnect()) or Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                Humanoid.WalkSpeed = ModedWalkSpeed
            end)
        end)
    else
        LockConnections.WS = LockConnections.WS and LockConnections.WS:Disconnect()
        LockConnections.WSCA = LockConnections.WSCA and LockConnections.WSCA:Disconnect()
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = CurrentWalkSpeed
            end
        end
    end
end

function UniversalModules.WalkSpeedValue(Number)
    ModedWalkSpeed = Number
    if WalkSpeedChange then
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = ModedWalkSpeed
            end
        end
    end
end

--|| Tp Walk Function ||--

function UniversalModules.TPWalk(Enabled)
    TPWalk = Enabled
    if Enabled then
        LockConnections.TPW = (LockConnections.TPW and LockConnections.TPW:Disconnect()) or Heartbeat:Connect(function(Delta)
            local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
            local Humanoid = Character:WaitForChild("Humanoid")
            if Humanoid.MoveDirection.Magnitude > 0 then
                Character:TranslateBy(Humanoid.MoveDirection * TPWalkSpeed * Delta)
            end
        end)
    else
        LockConnections.TPW = LockConnections.TPW and LockConnections.TPW:Disconnect()
    end
end

function UniversalModules.TPWalkValue(Number)
    TPWalkSpeed = Number
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
        if Humanoid then
            CurrentJumpPower = Humanoid.JumpPower
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = ModedJumpPower
        end
        LockConnections.JP = Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = ModedJumpPower
        end)
        LockConnections.JPCA = Speaker.CharacterAdded:Connect(function(Character)
            local Humanoid = Character:WaitForChild("Humanoid")
            if not Humanoid.UseJumpPower then
                Humanoid.UseJumpPower = true
                NotUsingJumpPower = true
            end
            if Humanoid then
                Humanoid.UseJumpPower = true
                CurrentJumpPower = Humanoid.JumpPower
                Humanoid.JumpPower = ModedJumpPower
            end
            LockConnections.JP = (LockConnections.JP and LockConnections.JP:Disconnect()) or Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = ModedJumpPower
            end)
        end)
    else
        LockConnections.JP = LockConnections.JP and LockConnections.JP:Disconnect()
        LockConnections.JPCA = LockConnections.JPCA and LockConnections.JPCA:Disconnect()
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.JumpPower = CurrentJumpPower
                if NotUsingJumpPower then
                    Humanoid.UseJumpPower = false
                end
            end
        end
    end
end

function UniversalModules.JumpPowerValue(Number)
    ModedJumpPower = Number
    if JumpPowerChange then
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.JumpPower = ModedJumpPower
            end
        end
    end
end

--|| Gravity Function ||--

function UniversalModules.Gravity(Enabled)
    GravityChange = Enabled
    if Enabled then
        CurrentGravity = Workspace.Gravity
        Workspace.Gravity = ModedGravity
        LockConnections.G = Workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
            Workspace.Gravity = ModedGravity
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

--|| Hip Height Function ||--

function UniversalModules.HipHeight(Enabled)
    HipHeight = Enabled
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        CurrentHipHeight = Humanoid.HipHeight
        Humanoid.HipHeight = ModedHipHeight
        LockConnections.HH = Humanoid:GetPropertyChangedSignal("HipHeight"):Connect(function()
            Humanoid.HipHeight = ModedHipHeight
        end)
        LockConnections.HHCA = Speaker.CharacterAdded:Connect(function(Character)
            if not DoHipHeightAfterMeRespawn then
                HipHeightToggle:SetValue(false)
                return
            end
            local Humanoid = Character:WaitForChild("Humanoid")
            CurrentHipHeight = Humanoid.HipHeight
            Humanoid.HipHeight = ModedHipHeight
            LockConnections.HH = (LockConnections.HH and LockConnections.HH:Disconnect()) or Humanoid:GetPropertyChangedSignal("HipHeight"):Connect(function()
                Humanoid.HipHeight = ModedHipHeight
            end)
        end)
    else
        LockConnections.HH = LockConnections.HH and LockConnections.HH:Disconnect()
        LockConnections.HHCA = LockConnections.HHCA and LockConnections.HHCA:Disconnect()
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.HipHeight = CurrentHipHeight or 0
            end
        end
    end
end

function UniversalModules.HipHeightValue(Number)
    ModedHipHeight = Number
    if HipHeight then
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.HipHeight = ModedHipHeight
            end
        end
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
        LockConnections.MSA = Humanoid:GetPropertyChangedSignal("MaxSlopeAngle"):Connect(function()
            Humanoid.MaxSlopeAngle = ModedMaxSlopeAngle
        end)
        LockConnections.MSACA = Speaker.CharacterAdded:Connect(function(Character)
            local Humanoid = Character:WaitForChild("Humanoid")
            CurrentMaxSlopeAngle = Humanoid.MaxSlopeAngle
            Humanoid.MaxSlopeAngle = ModedMaxSlopeAngle
            LockConnections.MSA = (LockConnections.MSA and LockConnections.MSA:Disconnect()) or Humanoid:GetPropertyChangedSignal("MaxSlopeAngle"):Connect(function()
                Humanoid.MaxSlopeAngle = ModedMaxSlopeAngle
            end)
        end)
    else
        LockConnections.MSA = LockConnections.MSA and LockConnections.MSA:Disconnect()
        LockConnections.MSACA = LockConnections.MSACA and LockConnections.MSACA:Disconnect()
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.MaxSlopeAngle = CurrentMaxSlopeAngle or 2.25
            end
        end
    end
end

function UniversalModules.MaxSlopeAngleValue(Number)
    ModedMaxSlopeAngle = Number
    if MaxSlopeAngle then
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.MaxSlopeAngle = ModedMaxSlopeAngle
            end
        end
    end
end

--|| Noclip Function ||--

function UniversalModules.Noclip(Enabled)
    if Enabled then
        NoclipParts = {}
        LockConnections.NC = (LockConnections.NC and LockConnections.NC:Disconnect()) or Stepped:Connect(function()
            local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
            for i,v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                    if not table.find(NoclipParts, v) then
                        table.insert(NoclipParts, v)
                    end
                end
            end
        end)
    else
        LockConnections.NC = LockConnections.NC and LockConnections.NC:Disconnect()
        for i,v in pairs(NoclipParts) do
            v.CanCollide = true
        end
        NoclipParts = {}
    end
end

function UniversalModules.VehicleNoclip(Enabled)
    if Enabled then
        VNoclipNotified = false
        VNoclipParts = {}
        LockConnections.VNC = (LockConnections.VNC and LockConnections.VNC:Disconnect()) or Stepped:Connect(function(Delta)
            local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
            local Humanoid = Character:WaitForChild("Humanoid")
            if Humanoid.SeatPart then
                local Seat = Humanoid.SeatPart
                local VehicleModel = Seat.Parent
                if VehicleModel.ClassName == "Model" then
                    NoclipToggle:SetValue(true)
                    for i,v in pairs(VehicleModel:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide then
                            v.CanCollide = false
                            if not table.find(VNoclipParts, v) then
                                table.insert(VNoclipParts, v)
                            end
                        end
                    end
                    VNocliping = true
                    if not VNoclipNotified then
                        VNoclipNotified = true
                        Library:Notify(GlobalText.VehicleNoclipNotify, 5)
                    end
                elseif VehicleModel.ClassName ~= "Model" then
                    VehicleModel = VehicleModel.Parent
                end
            else
                VNoclipNotified = false
                VNocliping = false
            end
        end)
    else
        LockConnections.VNC = LockConnections.VNC and LockConnections.VNC:Disconnect()
        for i,v in pairs(VNoclipParts) do
            v.CanCollide = true
        end
        VNoclipParts = {}
    end
end

--|| Anti Void ||--

function UniversalModules.AntiVoid(Enabled)
    if Enabled then
        CurrentVoid = Workspace.FallenPartsDestroyHeight
        Workspace.FallenPartsDestroyHeight = (0 / 0)
        LockConnections.V = Workspace:GetPropertyChangedSignal("FallenPartsDestroyHeight"):Connect(function()
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
        Spin = Instance.new("BodyAngularVelocity")
        Spin.Name = "Spin"
        Spin.Parent = Character and Character:WaitForChild("HumanoidRootPart")
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, (SpinSpeed or 5), 0)
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

--|| Fly Function ||--

FlyControl = {W = 0, S = 0, A = 0, D = 0, Q = 0, E = 0, LeltShift = 0, Space = 0}

Mouse.KeyDown:Connect(function(Key)
    local Keyl = Key:lower()
    if Keyl == "w" then
        FlyControl.W = 1
    elseif Keyl == "s" then
        FlyControl.S = 1
    elseif Keyl == "a" then
        FlyControl.A = 1
    elseif Keyl == "d" then
        FlyControl.D = 1
    elseif QEFly and Keyl == "q" then
        FlyControl.Q = 1
    elseif QEFly and Keyl == "e" then
        FlyControl.E = 1
    end
    if UseFlyGyro and UniversalModules.Flying then
        pcall(function()
            Camera.CameraType = Enum.CameraType.Track
        end)
    end
end)

Mouse.KeyUp:Connect(function(Key)
    local Keyl = Key:lower()
    if Keyl == "w" then
        FlyControl.W = 0
    elseif Keyl == "s" then
        FlyControl.S = 0
    elseif Keyl == "a" then
        FlyControl.A = 0
    elseif Keyl == "d" then
        FlyControl.D = 0
    elseif QEFly and Keyl == "q" then
        FlyControl.Q = 0
    elseif QEFly and Keyl == "e" then
        FlyControl.E = 0
    end
end)

UserInputService.InputBegan:Connect(function(Key)
    if Key.KeyCode == Enum.KeyCode.LeftShift then
        FlyControl.LeltShift = 1
    elseif Key.KeyCode == Enum.KeyCode.Space then
        FlyControl.Space = 1
    end
    if UseFlyGyro and UniversalModules.Flying then
        pcall(function()
            Camera.CameraType = Enum.CameraType.Track
        end)
    end
end)

UserInputService.InputEnded:Connect(function(Key)
    if Key.KeyCode == Enum.KeyCode.LeftShift then
        FlyControl.LeltShift = 0
    elseif Key.KeyCode == Enum.KeyCode.Space then
        FlyControl.Space = 0
    end
end)

function UniversalModules.Fly(Enabled)
    UniversalModules.Flying = Enabled
    if Enabled then
        if Weaponry then
            Library:Notify(GlobalText.WeaponryCheck, 5)
            return warn(GlobalText.WeaponryCheck)
        end
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local RootPart = Character:WaitForChild("HumanoidRootPart")
        FlyVelocity = Instance.new("BodyVelocity")
        FlyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        FlyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyVelocity.Parent = RootPart
        if UseFlyGyro then
            FlyGyro = Instance.new("BodyGyro")
            FlyGyro.P = 9e4
            FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            FlyGyro.CFrame = Camera.CFrame
            FlyGyro.Parent = RootPart
        end
        LockConnections.Fly = (LockConnections.Fly and LockConnections.Fly:Disconnect()) or Stepped:Connect(function()
            local MoveDirection = Vector3.new(0, 0, 0)
            local Humanoid = Character:WaitForChild("Humanoid")
            if Humanoid.Health == 0 then
                return
            end
            local RootPart = Humanoid.RootPart
            if not VFly and not SitFly then
                Humanoid.PlatformStand = true
            elseif VFly and not SitFly then
                Humanoid.PlatformStand = false
                if not Humanoid.SeatPart then
                    Humanoid.Sit = false
                end
            elseif not VFly and SitFly then
                Humanoid.PlatformStand = false
                Humanoid.Sit = true
            end
            if FlyControl.W == 1 then
                MoveDirection = MoveDirection + Camera.CFrame.LookVector
            end
            if FlyControl.S == 1 then
                MoveDirection = MoveDirection - Camera.CFrame.LookVector
            end
            if FlyControl.A == 1 then
                MoveDirection = MoveDirection - Camera.CFrame.RightVector
            end
            if FlyControl.D == 1 then
                MoveDirection = MoveDirection + Camera.CFrame.RightVector
            end
            if UseUpVector then
                if QEFly and FlyControl.Q == 1 or not QEFly and FlyControl.LeltShift == 1 then
                    MoveDirection = MoveDirection - RootPart.CFrame.UpVector * VerticalFlySpeedMultipiler
                end
                if QEFly and FlyControl.E == 1 or not QEFly and FlyControl.Space == 1 then
                    MoveDirection = MoveDirection + RootPart.CFrame.UpVector * VerticalFlySpeedMultipiler
                end
            else
                if QEFly and FlyControl.Q == 1 or not QEFly and FlyControl.LeltShift == 1 then
                    MoveDirection = MoveDirection - Vector3.new(0, VerticalFlySpeedMultipiler, 0)
                end
                if QEFly and FlyControl.E == 1 or not QEFly and FlyControl.Space == 1 then
                    MoveDirection = MoveDirection + Vector3.new(0, VerticalFlySpeedMultipiler, 0)
                end
            end
            FlyVelocity.Velocity = MoveDirection * FlySpeed
            if UseFlyGyro then
                FlyGyro.CFrame = Camera.CoordinateFrame
            end
        end)
    else
        if LockConnections.Fly then
            LockConnections.Fly:Disconnect()
            LockConnections.Fly = nil
        end
        if NonQEFlyKeyDown or NonQEFlyKeyUp then
            NonQEFlyKeyDown:Disconnect()
            NonQEFlyKeyUp:Disconnect()
            NonQEFlyKeyDown = nil
            NonQEFlyKeyUp = nil
        end
        local Character = Speaker.Character
        if Character then
            FlyGyro = FlyGyro and FlyGyro:Destroy()
            FlyVelocity = FlyVelocity and FlyVelocity:Destroy()
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.PlatformStand = false
                if not Humanoid.SeatPart then
                    Humanoid.Sit = false
                end
            end
        end
    end
end

--|| Click to Move Function ||--

function UniversalModules.ClickToMove(Enabled)
    if Enabled then
        CurrentMovement = Speaker.DevComputerMovementMode
        Speaker.DevComputerMovementMode = Enum.DevComputerMovementMode.ClickToMove
        LockConnections.CTM = (LockConnections.CTM and LockConnections.CTM:Disconnect()) or Speaker:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
            Speaker.DevComputerMovementMode = Enum.DevComputerMovementMode.ClickToMove
        end)
    else
        LockConnections.CTM = LockConnections.CTM and LockConnections.CTM:Disconnect()
        Speaker.DevComputerMovementMode = CurrentMovement
    end
end

--|| FOV Function ||--

function UniversalModules.FOV(Enabled)
    FOVChange = Enabled
    if Enabled then
        CurrentFOV = Camera.FieldOfView
        Camera.FieldOfView = ModedFOV
        LockConnections.FOV = (LockConnections.FOV and LockConnections.FOV:Disconnect()) or Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            Camera.FieldOfView = ModedFOV
        end)
    else
        LockConnections.FOV = LockConnections.FOV and LockConnections.FOV:Disconnect()
        Camera.FieldOfView = CurrentFOV
    end
end

function UniversalModules.FOVValue(Number)
    ModedFOV = Number
    if FOVChange then
        Camera.FieldOfView = ModedFOV
    end
end

--|| Max Zoom Function ||--

function UniversalModules.MaxZoom(Enabled)
    MaxZoomChange = Enabled
    if Enabled then
        CurrentMaxZoom = Speaker.CameraMaxZoomDistance
        Speaker.CameraMaxZoomDistance = ModedMaxZoom
        LockConnections.MZ = (LockConnections.MZ and LockConnections.MZ:Disconnect()) or Speaker:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
            Speaker.CameraMaxZoomDistance = ModedMaxZoom
        end)
    else
        LockConnections.MZ = LockConnections.MZ and LockConnections.MZ:Disconnect()
        Speaker.CameraMaxZoomDistance = CurrentMaxZoom
    end
end

function UniversalModules.MaxZoomValue(Number)
    ModedMaxZoom = Number
    if MaxZoomChange then
        Speaker.CameraMaxZoomDistance = ModedMaxZoom
    end
end

--|| Min Zoom Function ||--

function UniversalModules.MinZoom(Enabled)
    MinZoomChange = Enabled
    if Enabled then
        CurrentMinZoom = Speaker.CameraMinZoomDistance
        Speaker.CameraMinZoomDistance = ModedMinZoom
        LockConnections.MiZ = (LockConnections.MiZ and LockConnections.MiZ:Disconnect()) or Speaker:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
            Speaker.CameraMinZoomDistance = ModedMinZoom
        end)
    else
        LockConnections.MiZ = LockConnections.MiZ and LockConnections.MiZ:Disconnect()
        Speaker.CameraMinZoomDistance = CurrentMinZoom
    end
end

function UniversalModules.MinZoomValue(Number)
    ModedMinZoom = Number
    if MinZoomChange then
        Speaker.CameraMinZoomDistance = ModedMinZoom
    end
end

--|| Unlock Third Person Function ||--

function UniversalModules.UnlockThirdPerson(Enabled)
    if Enabled then
        CurrentCameraMode = Speaker.CameraMode
        Speaker.CameraMode = Enum.CameraMode.Classic
        LockConnections.UTP = (LockConnections.UTP and LockConnections.UTP:Disconnect()) or Speaker:GetPropertyChangedSignal("CameraMode"):Connect(function()
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
        LockConnections.CNC = (LockConnections.CNC and LockConnections.CNC:Disconnect()) or Speaker:GetPropertyChangedSignal("DevCameraOcclusionMode"):Connect(function()
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
        LockConnections.ASL = (LockConnections.ASL and LockConnections.ASL:Disconnect()) or Speaker:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
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
        LockConnections.AFCM = (LockConnections.AFCM and LockConnections.AFCM:Disconnect()) or Speaker:GetPropertyChangedSignal("DevComputerCameraMode"):Connect(function()
            Speaker.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.Classic
        end)
        LockConnections.AFCMM = (LockConnections.AFCMM and LockConnections.AFCMM:Disconnect()) or Speaker:GetPropertyChangedSignal("DevTouchCameraMode"):Connect(function()
            Speaker.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.Classic
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
        Speaker.GameplayPaused = true
    end
end

--|| Camera Offset Function ||--

function UniversalModules.CameraOffset(Enabled)
    if Enabled then
        pcall(function()
            CurrentCameraOffset = Workspace.CurrentCamera.CameraSubject.CameraOffset
        end)
        pcall(function()
            ModedCameraOffset = CurrentCameraOffset
        end)
        LockConnections.CO = (LockConnections.CO and LockConnections.CO:Disconnect()) or Stepped:Connect(function()
            pcall(function()
                Workspace.CurrentCamera.CameraSubject.CameraOffset = ModedCameraOffset
            end)
        end)
    else
        LockConnections.CO = LockConnections.CO and LockConnections.CO:Disconnect()
        pcall(function()
            Workspace.CurrentCamera.CameraSubject.CameraOffset = CurrentCameraOffset or Vector3.new(0, 0, 0)
        end)
    end
end

function UniversalModules.CameraOffsetValue(X, Y, Z)
    ModedCameraOffset = Vector3.new(X, Y, Z)
end

--|| Full Bright Function ||--

function UniversalModules.FullBright(Enabled)
    FullBrightChange = Enabled
    if Enabled then
        if AmbientChange or BrightnessChange or ClockTimeChange or OutdoorAmbientChange then
            AmbientColorToggle:SetValue(false)
            BrightnessToggle:SetValue(false)
            ClockTimeToggle:SetValue(false)
            OutdoorAmbientToggle:SetValue(false)
            wait(.1)
        end
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
        LockConnections.FB = {
            A = Lighting:GetPropertyChangedSignal("Ambient"):Connect(FB),
            B = Lighting:GetPropertyChangedSignal("Brightness"):Connect(FB),
            C = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(FB),
            O = Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(FB)
        }
    else
        for i,v in pairs(LockConnections.FB) do
            v:Disconnect()
        end
        Lighting.Ambient = CurrentAmbient
        Lighting.Brightness = CurrentBrightness
        Lighting.ClockTime = CurrentClockTime
        Lighting.OutdoorAmbient = CurrentOutdoorAmbient
    end
end

--|| Full Dark Function (?) ||--

function UniversalModules.FullDark(Enabled)
    FullDarkChange = Enabled
    if Enabled then
        CurrentExposureCompensation = Lighting.ExposureCompensation
        Lighting.ExposureCompensation = -100
        LockConnections.FD = (LockConnections.FD and LockConnections.FD:Disconnect()) or Lighting:GetPropertyChangedSignal("ExposureCompensation"):Connect(function()
            Lighting.ExposureCompensation = -100
        end)
    else
        LockConnections.FD = LockConnections.FD and LockConnections.FD:Disconnect()
        Lighting.ExposureCompensation = CurrentExposureCompensation or 0
    end
end

--|| Day Function (Super Full Bright) ||--

function UniversalModules.Day(Enabled)
    DayChange = Enabled
    if Enabled then
        local function Day()
            Sky = Instance.new("Sky")
            Sky.Name = "SuperFB"
            Sky.Parent = Lighting
        end
        Day()
        LockConnections.SFB = (LockConnections.SFB and LockConnections.SFB:Disconnect()) or Lighting.DescendantAdded:Connect(function(Instance)
            if Instance.ClassName == "Sky" and Instance.Name ~= "SuperFB" then
                Sky:Destroy()
                Day()
            end
        end)
    else
        LockConnections.SFB = LockConnections.SFB and LockConnections.SFB:Disconnect()
        Sky = Sky and Sky:Destroy()
    end
end

--|| No Atmosphere Function ||--

function UniversalModules.NoAtmosphere(Enabled)
    NoAtmosphereChange = Enabled
    if Enabled then
        repeat
            wait(0.016)
        until Lighting:FindFirstChildOfClass("Atmosphere")
        local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        CurrentAtmosphereDensity = Atmosphere.Density
        Atmosphere.Density = 0
        LockConnections.NA = (LockConnections.NA and LockConnections.NA:Disconnect()) or Atmosphere:GetPropertyChangedSignal("Density"):Connect(function()
            Atmosphere.Density = 0
        end)
        LockConnections.NAA = (LockConnections.NAA and LockConnections.NAA:Disconnect()) or Lighting.DescendantAdded:Connect(function(Instance)
            if Instance.ClassName == "Atmosphere" then
                Instance.Density = 0
            end
        end)
    else
        LockConnections.NA = LockConnections.NA and LockConnections.NA:Disconnect()
        LockConnections.NAA = LockConnections.NAA and LockConnections.NAA:Disconnect()
        local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if Atmosphere then
            Atmosphere.Density = CurrentAtmosphereDensity
        end
    end
end

--|| No Depth Of Field Function ||--

function UniversalModules.NoDepthOfField(Enabled)
    NoDepthOfFieldChange = Enabled
    if Enabled then
        repeat
            wait(0.016)
        until Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
        local DepthOfFieldEffect = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
        CurrentDepthOfField = DepthOfFieldEffect.Enabled
        DepthOfFieldEffect.Enabled = false
        LockConnections.NDOF = (LockConnections.NDOF and LockConnections.NDOF:Disconnect()) or DepthOfFieldEffect:GetPropertyChangedSignal("Enabled"):Connect(function()
            DepthOfFieldEffect.Enabled = false
        end)
        LockConnections.NDOFA = (LockConnections.NDOFA and LockConnections.NDOFA:Disconnect()) or Lighting.DescendantAdded:Connect(function(Instance)
            if Instance.ClassName == "DepthOfFieldEffect" then
                Instance.Enabled = false
            end
        end)
    else
        LockConnections.NDOF = LockConnections.NDOF and LockConnections.NDOF:Disconnect()
        LockConnections.NDOFA = LockConnections.NDOFA and LockConnections.NDOFA:Disconnect()
        local DepthOfFieldEffect = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
        if DepthOfFieldEffect then
            DepthOfFieldEffect.Enabled = CurrentDepthOfField
        end
    end
end

--|| No Blur Function ||--

function UniversalModules.NoBlur(Enabled)
    NoBlurChange = Enabled
    if Enabled then
        repeat
            wait(0.016)
        until Lighting:FindFirstChildOfClass("BlurEffect")
        local BlurEffect = Lighting:FindFirstChildOfClass("BlurEffect")
        CurrentBlur = BlurEffect.Enabled
        BlurEffect.Enabled = false
        LockConnections.NB = (LockConnections.NB and LockConnections.NB:Disconnect()) or BlurEffect:GetPropertyChangedSignal("Enabled"):Connect(function()
            BlurEffect.Enabled = false
        end)
        LockConnections.NBA = (LockConnections.NBA and LockConnections.NBA:Disconnect()) or Lighting.DescendantAdded:Connect(function(Instance)
            if Instance.ClassName == "BlurEffect" then
                Instance.Enabled = false
            end
        end)
    else
        LockConnections.NB = LockConnections.NB and LockConnections.NB:Disconnect()
        LockConnections.NBA = LockConnections.NBA and LockConnections.NBA:Disconnect()
        local BlurEffect = Lighting:FindFirstChildOfClass("BlurEffect")
        if BlurEffect then
            BlurEffect.Enabled = CurrentBlur
        end
    end
end

--|| No Bloom Function ||--

function UniversalModules.NoBloom(Enabled)
    NoBloomChange = Enabled
    if Enabled then
        repeat
            wait(0.016)
        until Lighting:FindFirstChildOfClass("BloomEffect")
        local BloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")
        CurrentBloom = BloomEffect.Enabled
        BloomEffect.Enabled = false
        LockConnections.NBL = (LockConnections.NBL and LockConnections.NBL:Disconnect()) or BloomEffect:GetPropertyChangedSignal("Enabled"):Connect(function()
            BloomEffect.Enabled = false
        end)
        LockConnections.NBLA = (LockConnections.NBLA and LockConnections.NBLA:Disconnect()) or Lighting.DescendantAdded:Connect(function(Instance)
            if Instance.ClassName == "BloomEffect" then
                Instance.Enabled = false
            end
        end)
    else
        LockConnections.NBL = LockConnections.NBL and LockConnections.NBL:Disconnect()
        LockConnections.NBLA = LockConnections.NBLA and LockConnections.NBLA:Disconnect()
        local BloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")
        if BloomEffect then
            BloomEffect.Enabled = CurrentBloom
        end
    end
end

--|| Ambient Function ||--

function UniversalModules.Ambient(Enabled)
    if Enabled then
        AmbientChange = true
        repeat
            wait(0.016)
        until not FullBrightChange
        Heartbeat:Wait()
        CurrentAmbient = Lighting.Ambient
        Lighting.Ambient = ModedAmbient
        LockConnections.A = (LockConnections.A and LockConnections.A:Disconnect()) or Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
            CurrentAmbient = Lighting.Ambient
            Lighting.Ambient = ModedAmbient
        end)
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
            wait(0.016)
        until not FullBrightChange
        Heartbeat:Wait()
        CurrentBrightness = Lighting.Brightness
        Lighting.Brightness = ModedBrightness
        LockConnections.B = (LockConnections.B and LockConnections.B:Disconnect()) or Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
            Lighting.Brightness = ModedBrightness
        end)
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
            wait(0.016)
        until not FullBrightChange
        Heartbeat:Wait()
        CurrentClockTime = Lighting.ClockTime
        Lighting.ClockTime = ModedClockTime
        LockConnections.CT = (LockConnections.CT and LockConnections.CT:Disconnect()) or Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
            Lighting.ClockTime = ModedClockTime
        end)
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
            wait(0.016)
        until not FullBrightChange
        Heartbeat:Wait()
        CurrentOutdoorAmbient = Lighting.OutdoorAmbient
        Lighting.OutdoorAmbient = ModedOutdoorAmbient
        LockConnections.OA = (LockConnections.OA and LockConnections.OA:Disconnect()) or Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function()
            Lighting.OutdoorAmbient = ModedOutdoorAmbient
        end)
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
        LockConnections.CSB = (LockConnections.CSB and LockConnections.CSB:Disconnect()) or Lighting:GetPropertyChangedSignal("ColorShift_Bottom"):Connect(function()
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
        LockConnections.CST = (LockConnections.CST and LockConnections.CST:Disconnect()) or Lighting:GetPropertyChangedSignal("ColorShift_Top"):Connect(function()
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
        LockConnections.DS = (LockConnections.DS and LockConnections.DS:Disconnect()) or Lighting:GetPropertyChangedSignal("EnvironmentDiffuseScale"):Connect(function()
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
        LockConnections.SS = (LockConnections.SS and LockConnections.SS:Disconnect()) or Lighting:GetPropertyChangedSignal("EnvironmentSpecularScale"):Connect(function()
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
        LockConnections.SSf = (LockConnections.SSf and LockConnections.SSf:Disconnect()) or Lighting:GetPropertyChangedSignal("ShadowSoftness"):Connect(function()
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
        LockConnections.GL = (LockConnections.GL and LockConnections.GL:Disconnect()) or Lighting:GetPropertyChangedSignal("GeographicLatitude"):Connect(function()
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
    local Position = Camera.CFrame
    local Character = Speaker.Character
    if not Character then
        Library:Notify(GlobalText.NoCharacterWarn, 5)
        return warn(GlobalText.NoCharacterWarn)
    end
    local Humanoid = Character and Character:WaitForChild("Humanoid")
    local CloneHumanoid = Humanoid:Clone()
    CloneHumanoid.Parent = Character
    Speaker.Character = nil
    CloneHumanoid:SetStateEnabled(CloneHumanoid, 15, false)
    CloneHumanoid:SetStateEnabled(CloneHumanoid, 1, false)
    CloneHumanoid:SetStateEnabled(CloneHumanoid, 0, false)
    CloneHumanoid.BreakJointsOnDeath = true
    Humanoid = Humanoid:Destroy()
    Speaker.Character = Character
    Camera.CameraSubject = CloneHumanoid
    Camera.CFrame = wait() and Position
    CloneHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    local Script = Character:FindFirstChild(Character, "Animate")
    if Script then
        Script.Disabled = true
        wait()
        Script.Disabled = false
    end
    CloneHumanoid.Health = CloneHumanoid.MaxHealth
    Library:Notify(GlobalText.GodSuccess, 5)
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
    --// Credit to AmokahFox @V3rmillion \\--
    local Character = Speaker.Character
    if not Character then
        Library:Notify(GlobalText.NoCharacterWarn, 5)
        InvisibleRunning = false
        return warn(GlobalText.NoCharacterWarn)
    end
    Character.Archivable = true
    local IsInvis = false
    local IsRunning = true
    local InvisibleCharacter = Character:Clone()
    InvisibleCharacter.Parent = Lighting
	AntiVoidToggle:SetValue(true)
	InvisibleCharacter.Name = ""
	
    for i,v in pairs(InvisibleCharacter:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Name == "HumanoidRootPart" then
                v.Transparency = 1
            else
                v.Transparency = InvisibleTransparency
            end
        end
    end
    
    function InvisRespawn()
        IsRunning = false
		if IsInvis == true then
			pcall(function()
				Speaker.Character = Character
				wait()
				Character.Parent = Workspace
				Character:WaitForChild("Humanoid"):Destroy()
				IsInvis = false
				InvisibleCharacter.Parent = nil
				invisRunning = false
			end)
		elseif IsInvis == false then
			pcall(function()
				Speaker.Character = Character
				wait()
				Character.Parent = Workspace
				Character:WaitForChild("Humanoid"):Destroy()
				TurnVisible()
			end)
		end
    end

    LockConnections.InvisDied = InvisibleCharacter:WaitForChild("Humanoid").Died:Connect(function()
        Respawn()
        LockConnections.InvisDied:Disconnect()
    end)

    if IsInvis == true then
        return
    end
	IsInvis = true
	CF = workspace.CurrentCamera.CFrame
	local CF1 = Speaker.Character.HumanoidRootPart.CFrame
	Character:MoveTo(Vector3.new(0,math.pi*1000000,0))
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	wait(.2)
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	InvisibleCharacter = InvisibleCharacter
	Character.Parent = Lighting
	InvisibleCharacter.Parent = workspace
	InvisibleCharacter.HumanoidRootPart.CFrame = CF1
	Speaker.Character = InvisibleCharacter
    Camera.Subject = Speaker.Character:FindFirstChild("Humanoid")
	Camera.CameraType = "Custom"
    Speaker.CameraMode = "Classic"
	Speaker.Character.Animate.Disabled = true
    wait()
	Speaker.Character.Animate.Disabled = false

    function TurnVisible()
		if IsInvis == false then
            return
        end
		InvisDied:Disconnect()
		CF = workspace.CurrentCamera.CFrame
		Character = Character
		local CF1 = Speaker.Character.HumanoidRootPart.CFrame
		Character.HumanoidRootPart.CFrame = CF1
		InvisibleCharacter:Destroy()
		Speaker.Character = Character
		Character.Parent = Workspace
		IsInvis = false
		Speaker.Character.Animate.Disabled = true
        wait()
		Speaker.Character.Animate.Disabled = false
		LockConnections.InvisDied = Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
			Respawn()
			LockConnections.InvisDied:Disconnect()
		end)
		invisRunning = false
	end
    Library:Notify(GlobalText.InvisSuccess, 5)
end

function UniversalModules.Visible()
    TurnVisible()
end

--|| Fling Function ||--

function UniversalModules.Fling(Enabled)
    if Enabled then
        Flinging = false
        if InvisFlinging then
            Library:Notify(GlobalText.InvisFlingWarn, 5)
            return warn(GlobalText.InvisFlingWarn)
        end
        if not Speaker.Character then
            Library:Notify(GlobalText.NoCharacterWarn, 5)
            return warn(GlobalText.NoCharacterWarn)
        end
        if WalkFlinging then
            WalkFlingToggle:SetValue(false)
            Heartbeat:Wait()
        end
        if Spining then
            SpinToggle:SetValue(false)
        end
        local Character = Speaker.Character
        for i,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
            end
        end
        NoclipToggle:SetValue(true)
        FlingBAV = Instance.new("BodyAngularVelocity")
        FlingBAV.Name = "Fling"
        FlingBAV.Parent = Character and Character:WaitForChild("HumanoidRootPart")
        FlingBAV.AngularVelocity = Vector3.new(0, 99999, 0)
        FlingBAV.MaxTorque = Vector3.new(0, math.huge, 0)
        FlingBAV.P = math.huge
        local Children = Character:GetChildren()
        for i,v in next, Children do
            if v:IsA("BasePart") then
                v.CanCollide = false
                v.Massless = true
                v.Velocity = Vector3.new(0, 0, 0)
            end
        end
        Flinging = true
        LockConnections.FlingDied = Character:WaitForChild("Humanoid").Died:Connect(function()
            FlingToggle:SetValue(false)
        end)
        repeat
            FlingBAV.AngularVelocity = Vector3.new(0, 99999, 0)
            wait(.2)
            FlingBAV.AngularVelocity = Vector3.new(0, 0, 0)
            wait(.1)
        until not Flinging
    else
        Flinging = false
        LockConnections.FlingDied = LockConnections.FlingDied and LockConnections.FlingDied:Disconnect()
        local Character = Speaker.Character
        if not Character or not Character.HumanoidRootPart then
            return
        end
        FlingBAV = FlingBAV and FlingBAV:Destroy()
        for i,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
            end
        end
    end
end

--|| Walk Fling Function ||--

function UniversalModules.WalkFling(Enabled)
    if Enabled then
        WalkFlinging = false
        if InvisFlinging then
            Library:Notify(GlobalText.InvisFlingWarn, 5)
            return warn(GlobalText.InvisFlingWarn)
        end
        if not Speaker.Character then
            Library:Notify(GlobalText.NoCharacterWarn, 5)
            return warn(GlobalText.NoCharacterWarn)
        end
        if Flinging then
            FlingToggle:SetValue(false)
            Heartbeat:Wait()
        end
        if Spining then
            SpinToggle:SetValue(false)
        end
        local Humanoid = Speaker.Character:WaitForChild("Humanoid")
        LockConnections.WalkFlingDied = Humanoid and Humanoid.Died:Connect(function()
            WalkFlingToggle:SetValue(false)
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
            RootPart.Velocity = Velocity * 10000 + Vector3.new(0, 10000, 0)
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
        WalkFlinging = false
        LockConnections.WalkFlingDied = LockConnections.WalkFlingDied and LockConnections.WalkFlingDied:Disconnect()
    end
end

--|| InvisFling Function ||--

function UniversalModules.InvisFling()
    if InvisFlinging or InvisFlinged then
        Library:Notify(GlobalText.InvisFlingWarn, 5)
        return warn(GlobalText.InvisFlingWarn)
    end
    if Spining then
        SpinToggle:SetValue(false)
    end
    InvisFlinging = true
    WalkFlingToggle:SetValue(false)
    FlingToggle:SetValue(false)
    FlyToggle:SetValue(false)
    local Character = Speaker.Character
    if not Character then
        Library:Notify(GlobalText.NoCharacterWarn, 5)
        return warn(GlobalText.NoCharacterWarn)
    end
    local Model = Instance.new("Model")
    Model.Parent = Character
    local Torso = Instance.new("Part")
    Torso.Name = "Torso"
    Torso.CanCollide = false
    Torso.Anchored = true
    local Head = Instance.new("Part")
    Head.Name = "Head"
    Head.CanCollide = false
    Head.Anchored = true
    Head.Parent = Model
    local Humanoid = Instance.new("Humanoid")
    Humanoid.Name = "Humanoid"
    Humanoid.Parent = Model
    Torso.Position = Vector3.new(0, 9999, 0)
    Speaker.Character = Model
    wait()
    Speaker.Character = Character
    wait()
    local Humanoid = Instance.new("Humanoid")
    Head:Clone()
    Humanoid.Parent = Character
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    for i,v in pairs(Character:GetChildren()) do
        if v ~= RootPart and v.Name ~= "Humanoid" then
            v:Destroy()
        end
    end
    RootPart.Transparency = 0
    RootPart.Color = Color3.new(1, 1, 1)
    LockConnections.InvisFling = Stepped:Connect(function()
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character:FindFirstChild("HumanoidRootPart").CanCollide = false
        else
            LockConnections.InvisFling:Disconnect()
        end
    end)
    FlyToggle:SetValue(true)
    Camera.CameraSubject = RootPart
    local BT = Instance.new("BodyThrust")
    BT.Parent = RootPart
    BT.Force = Vector3.new(99999, 99999*10, 99999)
    BT.Location = RootPart.Position
    InvisFlinged = true
end

--|| Anti Fling Function ||--

function UniversalModules.AntiFling(Enabled)
    if Enabled then
        LockConnections.AntiFling = (LockConnections.AntiFling and LockConnections.AntiFling:Disconnect()) or Stepped:Connect(function()
            for i,v in pairs(Players:GetPlayers()) do
                if v ~= Speaker and v.Character then
                    for i,v in pairs(v.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        LockConnections.AntiFling = LockConnections.AntiFling and LockConnections.AntiFling:Disconnect()
    end
end

--|| Speaker Died Connection ||--

LockConnections.SpeakerDied = Speaker.CharacterRemoving:Connect(function()
    if InvisFlinged then
        InvisFlinged = false
        InvisFlinging = false
    end
    if StopFlyOnDied then
        FlyToggle:SetValue(false)
    end
    local Character = Speaker.CharacterAdded:Wait()
    if Character:WaitForChild("HumanoidRootPart") and not StopFlyOnDied and UniversalModules.Flying then
        FlyToggle:SetValue(false)
        Heartbeat:Wait()
        FlyToggle:SetValue(true)
    end
    if Spining then
        SpinToggle:SetValue(false)
        Heartbeat:Wait()
        SpinToggle:SetValue(true)
    end
end)

--|| Exit Function ||--

function UniversalModules:Exit()
    pcall(function()
        UniversalModules.AntiAFK(false)
        UniversalModules.FPSCap(false)
        UniversalModules.WalkSpeed(false)
        UniversalModules.TPWalk(false)
        UniversalModules.JumpPower(false)
        UniversalModules.Gravity(false)
        UniversalModules.HipHeight(false)
        UniversalModules.MaxSlopeAngle(false)
        UniversalModules.Noclip(false)
        UniversalModules.VehicleNoclip(false)
        UniversalModules.AntiVoid(false)
        UniversalModules.Spin(false)
        UniversalModules.Fly(false)
        UniversalModules.ClickToMove(false)
        UniversalModules.FOV(false)
        UniversalModules.MaxZoom(false)
        UniversalModules.MinZoom(false)
        UniversalModules.UnlockThirdPerson(false)
        UniversalModules.CameraNoclip(false)
        UniversalModules.AllowShiftLock(false)
        UniversalModules.AntiFollowCameraMode(false)
        UniversalModules.AntiGameplayPaused(false)
        UniversalModules.CameraOffset(false)
        UniversalModules.FullBright(false)
        UniversalModules.FullDark(false)
        UniversalModules.Day(false)
        UniversalModules.NoAtmosphere(false)
        UniversalModules.NoDepthOfField(false)
        UniversalModules.NoBlur(false)
        UniversalModules.NoBloom(false)
        UniversalModules.Ambient(false)
        UniversalModules.Brightness(false)
        UniversalModules.ClockTime(false)
        UniversalModules.OutdoorAmbient(false)
        UniversalModules.ColorShiftBottom(false)
        UniversalModules.ColorShiftTop(false)
        UniversalModules.DiffuseScale(false)
        UniversalModules.SpecularScale(false)
        UniversalModules.ShadowSoftness(false)
        UniversalModules.Technology(false)
        UniversalModules.GeographicLatitude(false)
        UniversalModules.Visible()
        UniversalModules.Fling(false)
        UniversalModules.WalkFling(false)
        UniversalModules.AntiFling(false)
        for i,v in pairs(LockConnections) do
            if typeof(v) == "RBXScriptConnection" then
                v:Disconnect()
            elseif typeof(v) == "table" then
                for i2,v2 in pairs(v) do
                    if typeof(v2) == "RBXScriptConnection" then
                        v2:Disconnect()
                    end
                end
            end
        end
    end)
end

--|| Return Table ||--

return UniversalModules
