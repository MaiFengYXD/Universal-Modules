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
Version | 0.0.5f

# Project Started on 2024/11/13 #
# This Version was Last Edited on 2025/2/26 #

Issues Report on Github or https://discord.gg/YBQUd8X8PK
QQ: 3607178523

]]--



--|| Variables ||--

UniversalModules = {}
LockConnections = {}
Cloneref = cloneref or function(x) return x end
Workspace = Cloneref(game:GetService("Workspace"))
Players = Cloneref(game:GetService("Players"))
RunService = Cloneref(game:GetService("RunService"))
UserInputService = Cloneref(game:GetService("UserInputService"))
Heartbeat = RunService.Heartbeat
RenderStepped = RunService.RenderStepped
Stepped = RunService.Stepped
Speaker = Players.LocalPlayer
Camera = Workspace.CurrentCamera
AFKMouseClick1 = false
AFKMouseClick2 = false
AFKMousemoveabs = false
AFKMousemoverel = true
AFKTime = 60
AFKTimes = 0
Mouse = Speaker:GetMouse()
UniversalModules.CurrentFPS = getfpscap() or 240
TargetFPS = UniversalModules.CurrentFPS
CurrentWalkSpeed = Speaker.Character:FindFirstChild("Humanoid").WalkSpeed or 16
CurrentJumpPower = Speaker.Character:FindFirstChild("Humanoid").JumpPower or 50
CurrentGravity = Workspace.Gravity or 196.2
ModedWalkSpeed = CurrentWalkSpeed
ModedJumpPower = CurrentJumpPower
ModedGravity = CurrentGravity
CurrentVoid = Workspace.FallenPartsDestroyHeight
Rivals = (game.PlaceId == 17625359962 and true) or false
Weaponry = (game.PlaceId == 3297964905 and true) or false
VFly = false
UniversalModules.Flying = false
SitFly = false
QEFly = true
UseFlyGyro = true
FlySpeed = 30
VerticalFlySpeedMultipiler = 1

--|| AntiAFK Function ||--

function UniversalModules.AntiAFK(Enabled)
    AntiAFKEnabled = Enabled
    if Enabled then
        AFKTimer = 0
        AFKConnectionBegan = UserInputService.InputBegan:Connect(function()
            AFKTimer = 0
        end)
        AFKConnectionChanged = UserInputService.InputChanged:Connect(function()
            AFKTimer = 0
        end)
        AFKConnectionEnded = UserInputService.InputEnded:Connect(function()
            AFKTimer = 0
        end)
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
                    AFKTimer = 0
                elseif AFKMousemoveabs then
                    local MousePos = Vector2.new(Mouse.X, Mouse.Y)
                    mousemoveabs(0, 0)
                    Heartbeat:Wait()
                    mousemoveabs(MousePos)
                    AFKTimer = 0
                elseif AFKMouseClick1 then
                    mouse1press()
                    Heartbeat:Wait()
                    mouse1release()
                    AFKTimer = 0
                else
                    mouse2press()
                    Heartbeat:Wait()
                    mouse2release()
                    AFKTimer = 0
                end
            end
        end
    else
        if AFKConnectionBegan then
            AFKConnectionBegan:Disconnect()
            AFKConnectionBegan = nil
        end
        if AFKConnectionChanged then
            AFKConnectionChanged:Disconnect()
            AFKConnectionChanged = nil
        end
        if AFKConnectionEnded then
            AFKConnectionEnded:Disconnect()
            AFKConnectionEnded = nil
        end
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
            CurrentWalkSpeed = Humanoid.WalkSpeed
            Humanoid.WalkSpeed = ModedWalkSpeed
        end)
        LockConnections.WSCA = Speaker.CharacterAdded:Connect(function(Character)
            local Humanoid = Character:WaitForChild("Humanoid")
            if Humanoid then
                CurrentWalkSpeed = Humanoid.WalkSpeed
                Humanoid.WalkSpeed = ModedWalkSpeed
            end
            LockConnections.WS = (LockConnections.WS and LockConnections.WS:Disconnect()) or Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                CurrentWalkSpeed = Humanoid.WalkSpeed
                Humanoid.WalkSpeed = ModedWalkSpeed
            end)
        end)
    else
        if LockConnections.WS then
            LockConnections.WS:Disconnect()
            LockConnections.WS = nil
        end
        if LockConnections.WSCA then
            LockConnections.WSCA:Disconnect()
            LockConnections.WSCA = nil
        end
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
            CurrentJumpPower = Humanoid.JumpPower
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
                CurrentJumpPower = Humanoid.JumpPower
                Humanoid.JumpPower = ModedJumpPower
            end)
        end)
    else
        if LockConnections.JP then
            LockConnections.JP:Disconnect()
            LockConnections.JP = nil
        end
        if LockConnections.JPCA then
            LockConnections.JPCA:Disconnect()
            LockConnections.JPCA = nil
        end
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
        if LockConnections.G then
            LockConnections.G:Disconnect()
            LockConnections.G = nil
        end
        Workspace.Gravity = CurrentGravity
    end
end

function UniversalModules.GravityValue(Number)
    ModedGravity = Number
    if GravityChange then
        Workspace.Gravity = ModedGravity
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
        if LockConnections.NC then
            LockConnections.NC:Disconnect()
            LockConnections.NC = nil
        end
        for i,v in pairs(NoclipParts) do
            v.CanCollide = true
        end
        NoclipParts = {}
    end
end

function UniversalModules.VehicleNoclip(Enabled)
    if Enabled then
        VNoclipNotified2 = false
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
                if not VNoclipNotified2 then
                    VNoclipNotified2 = true
                    Library:Notify(GlobalText.VehicleNoclipNotify2, 5)
                end
            end
        end)
    else
        if LockConnections.VNC then
            LockConnections.VNC:Disconnect()
            LockConnections.VNC = nil
        end
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
            CurrentVoid = Workspace.FallenPartsDestroyHeight
            Workspace.FallenPartsDestroyHeight = (0 / 0)
        end)
    else
        if LockConnections.V then
            LockConnections.V:Disconnect()
            LockConnections.V = nil
        end
        Workspace.FallenPartsDestroyHeight = CurrentVoid
    end
end

--|| Fly Function ||--

function UniversalModules.Fly(Enabled)
    if Enabled then
        if Weaponry then
            Library:Notify(GlobalText.WeaponryCheck, 5)
            return warn(GlobalText.WeaponryCheck)
        end
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        UniversalModules.Flying = true
        local RootPart = Character:WaitForChild("HumanoidRootPart")
        FlyControl = (QEFly and {W = 0, S = 0, A = 0, D = 0, Q = 0, E = 0}) or {W = 0, S = 0, A = 0, D = 0, LeftShift = 0, Space = 0}
        local FlyKeyDown = nil
        local FlyKeyUp = nil
        local FlyVelocity = Instance.new("BodyVelocity")
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
        LockConnections.Fly = Stepped:Connect(function()
            local MoveDirection = Vector3.new(0, 0, 0)
            if not VFly and not SitFly then
                Character:FindFirstChild("Humanoid").PlatformStand = true
            elseif SitFly then
                Character:FindFirstChild("Humanoid").Sit = true
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
            if FlyControl.Q == 1 or FlyControl.LeftShift == 1 then
                MoveDirection = MoveDirection - Vector3.new(0, VerticalFlySpeedMultipiler, 0)
            end
            if FlyControl.E == 1 or FlyControl.Space == 1 then
                MoveDirection = MoveDirection + Vector3.new(0, VerticalFlySpeedMultipiler, 0)
            end
            FlyVelocity.Velocity = MoveDirection * FlySpeed
            if UseFlyGyro then
                FlyGyro.CFrame = Camera.CFrame
            end
        end)
        FlyKeyDown = Mouse.KeyDown:Connect(function(Key)
            local Key = Key:lower()
            if Key == "w" then
                FlyControl.W = 1
            elseif Key == "s" then
                FlyControl.S = 1
            elseif Key == "a" then
                FlyControl.A = 1
            elseif Key == "d" then
                FlyControl.D = 1
            elseif QEFly and Key == "q" then
                FlyControl.Q = 1
            elseif QEFly and Key == "e" then
                FlyControl.E = 1
            end
            if UseFlyGyro then
                pcall(function()
                    Camera.CameraType = Enum.CameraType.Track
                end)
            end
        end)
        FlyKeyUp = Mouse.KeyUp:Connect(function(Key)
            local Key = Key:lower()
            if Key == "w" then
                FlyControl.W = 0
            elseif Key == "s" then
                FlyControl.S = 0
            elseif Key == "a" then
                FlyControl.A = 0
            elseif Key == "d" then
                FlyControl.D = 0
            elseif QEFly and Key == "q" then
                FlyControl.Q = 0
            elseif QEFly and Key == "e" then
                FlyControl.E = 0
            end
        end)
        NonQEFlyKeyDown = not QEFly and UserInputService.InputBegan:Connect(function(Key)
            if Key.KeyCode == Enum.KeyCode.LeftShift then
                FlyControl.LeftShift = 1
            elseif Key.KeyCode == Enum.KeyCode.Space then
                FlyControl.Space = 1
            end
            if UseFlyGyro then
                pcall(function()
                    Camera.CameraType = Enum.CameraType.Track
                end)
            end
        end)
        NonQEFlyKeyUp = not QEFly and UserInputService.InputEnded:Connect(function(Key)
            if Key.KeyCode == Enum.KeyCode.LeftShift then
                FlyControl.LeftShift = 0
            elseif Key.KeyCode == Enum.KeyCode.Space then
                FlyControl.Space = 0
            end
        end)
    else
        UniversalModules.Flying = false
        if LockConnections.Fly then
            LockConnections.Fly:Disconnect()
            LockConnections.Fly = nil
        end
        if FlyKeyDown or FlyKeyUp then
            FlyKeyDown:Disconnect()
            FlyKeyUp:Disconnect()
            FlyKeyDown = nil
            FlyKeyUp = nil
        end
        if NonQEFlyKeyDown or NonQEFlyKeyUp then
            NonQEFlyKeyDown:Disconnect()
            NonQEFlyKeyUp:Disconnect()
            NonQEFlyKeyDown = nil
            NonQEFlyKeyUp = nil
        end
        FlyControl = nil
        local Character = Speaker.Character
        if Character then
            local RootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChild("Humanoid")
            if Humanoid then
                Humanoid.PlatformStand = false
                if not Humanoid.SeatPart then
                    Humanoid.Sit = false
                end
            end
            if RootPart then
                local BodyVelocity = RootPart:FindFirstChild("BodyVelocity")
                local BodyGyro = RootPart:FindFirstChild("BodyGyro")
                if BodyVelocity then
                    BodyVelocity:Destroy()
                end
                if BodyGyro then
                    BodyGyro:Destroy()
                end
            end
        end
    end
end

if UserInputService:IsKeyDown(Enum.KeyCode.W) and FlyControl then
    FlyControl.W = 1
end
if UserInputService:IsKeyDown(Enum.KeyCode.S) and FlyControl then
    FlyControl.S = 1
end
if UserInputService:IsKeyDown(Enum.KeyCode.A) and FlyControl then
    FlyControl.A = 1
end
if UserInputService:IsKeyDown(Enum.KeyCode.D) and FlyControl then
    FlyControl.D = 1
end
if QEFly and UserInputService:IsKeyDown(Enum.KeyCode.Q) and FlyControl then
    FlyControl.Q = 1
end
if QEFly and UserInputService:IsKeyDown(Enum.KeyCode.E) and FlyControl then
    FlyControl.E = 1
end
if not QEFly and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and FlyControl then
    FlyControl.LeftShift = 1
end
if not QEFly and UserInputService:IsKeyDown(Enum.KeyCode.Space) and FlyControl then
    FlyControl.Space = 1
end

--|| Speaker Died Connection ||--

LockConnections.SpeakerDied = Speaker.CharacterAdded:Connect(function(Character)
    if UniversalModules.Flying then
        FlyToggle:SetValue(false)
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
        for i,v in pairs(LockConnections) do
            if v then
                v:Disconnect()
            end
        end
    end)
end

--|| Return Table ||--

return UniversalModules
