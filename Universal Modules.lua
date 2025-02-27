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
Version | 0.0.7f (Stable)

# Project Started on 2024-11-13 #
# This Version was Last Edited on 2025-02-27 #

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
ModedCameraOffset = Camera.CameraSubject.CameraOffset or Vector3.new(0, 0, 0)

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
CurrentWalkSpeed = Speaker.Character:FindFirstChild("Humanoid").WalkSpeed or 16
CurrentJumpPower = Speaker.Character:FindFirstChild("Humanoid").JumpPower or 50
CurrentGravity = Workspace.Gravity
CurrentVoid = Workspace.FallenPartsDestroyHeight

--// Moded Game Mechanics \\--
ModedWalkSpeed = CurrentWalkSpeed
ModedJumpPower = CurrentJumpPower
ModedGravity = CurrentGravity

--// AFK Settings \\--
AFKMouseClick1 = false
AFKMouseClick2 = false
AFKMousemoveabs = false
AFKMousemoverel = true
AFKTime = 60
AFKTimes = 0

--// Mouse and Target FPS \\--
Mouse = Speaker:GetMouse()
UniversalModules.CurrentFPS = getfpscap() or 240
TargetFPS = UniversalModules.CurrentFPS

--// Flying Mode \\--
VFly = false
UniversalModules.Flying = false
SitFly = false
QEFly = true
UseFlyGyro = true
StopFlyOnDied = true
FlySpeed = 30
VerticalFlySpeedMultipiler = 1

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
    HipHeightChange = Enabled
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        CurrentHipHeight = Humanoid.HipHeight
        Humanoid.HipHeight = ModedHipHeight
        LockConnections.HH = Humanoid:GetPropertyChangedSignal("HipHeight"):Connect(function()
            Humanoid.HipHeight = ModedHipHeight
        end)
        LockConnections.HHCA = Speaker.CharacterAdded:Connect(function(Character)
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
    if HipHeightChange then
        local Character = Speaker.Character
        if Character then
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.HipHeight = ModedHipHeight
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
            if QEFly and FlyControl.Q == 1 or not QEFly and FlyControl.LeltShift == 1 then
                MoveDirection = MoveDirection - Vector3.new(0, VerticalFlySpeedMultipiler, 0)
            end
            if QEFly and FlyControl.E == 1 or not QEFly and FlyControl.Space == 1 then
                MoveDirection = MoveDirection + Vector3.new(0, VerticalFlySpeedMultipiler, 0)
            end
            FlyVelocity.Velocity = MoveDirection * FlySpeed
            if UseFlyGyro then
                FlyGyro.CFrame = Camera.CFrame
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
        end
        repeat
            wait(0.016)
        until Lighting.Ambient == CurrentAmbient or Lighting.Brightness == CurrentBrightness or Lighting.ClockTime == CurrentClockTime or Lighting.OutdoorAmbient == CurrentOutdoorAmbient
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

--|| Technology Function ||--

function UniversalModules.Technology(Enabled)
    TechnologyChange = Enabled
    if Enabled then
        CurrentTechnology = Lighting.Technology
        Lighting.Technology = ModedTechnology
        LockConnections.T = (LockConnections.T and LockConnections.T:Disconnect()) or Lighting:GetPropertyChangedSignal("Technology"):Connect(function()
            Lighting.Technology = ModedTechnology
        end)
    else
        LockConnections.T = LockConnections.T and LockConnections.T:Disconnect()
        Lighting.Technology = CurrentTechnology
    end
end

function UniversalModules.TechnologyValue(Technology)
    ModedTechnology = Technology
    if TechnologyChange then
        Lighting.Technology = ModedTechnology
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

--|| Speaker Died Connection ||--

LockConnections.SpeakerDied = Speaker.CharacterRemoving:Connect(function()
    if StopFlyOnDied then
        FlyToggle:SetValue(false)
    end
    local Character = Speaker.CharacterAdded:Wait()
    if Character:WaitForChild("HumanoidRootPart") and not StopFlyOnDied and UniversalModules.Flying then
        FlyToggle:SetValue(false)
        Heartbeat:Wait()
        FlyToggle:SetValue(true)
    end
end)

--|| Exit Function ||--

function UniversalModules:Exit()
    pcall(function()
        UniversalModules.AntiAFK(false)
        UniversalModules.FPSCap(false)
        UniversalModules.WalkSpeed(false)
        UniversalModules.JumpPower(false)
        UniversalModules.Gravity(false)
        UniversalModules.Noclip(false)
        UniversalModules.VehicleNoclip(false)
        UniversalModules.AntiVoid(false)
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
