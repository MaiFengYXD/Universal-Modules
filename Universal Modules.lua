--[[

$$\      $$\ $$$$$$$$\                              ~
$$$\    $$$ |$$  _____|                              
$$$$\  $$$$ |$$ |       $$$$$$\   $$$$$$\   $$$$$$\  
$$\$$\$$ $$ |$$$$$\    $$  __$$\ $$  __$$\ $$  __$$\ 
$$ \$$$  $$ |$$  __|   $$$$$$$$ |$$$$$$$$ |$$$$$$$$ |
$$ |\$  /$$ |$$ |      $$   ____|$$   ____|$$   ____|
$$ | \_/ $$ |$$ |      \$$$$$$$\ \$$$$$$$\ \$$$$$$$\ 
\__|     \__|\__|       \_______| \_______| \_______| 

Universal Modules | MaiFengYXD
Alpha Edidtion 1  | CC0-1.0 license

# This Version was Last Edited on 2025/2/25 #
# You are Free to Fully Operate the Source Code #

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
Mouse = Speaker:GetMouse()
CurrentFPS = getfpscap() or 240
TargetFPS = CurrentFPS
AntiKickEnabled = false
Rivals = (game.PlaceId == 17625359962 and true) or false
Weaponry = (game.PlaceId == 3297964905 and true) or false
VFly = false
Flying = false
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
            print(AFKTimer)
            if AFKTimer >= AFKTime then
                print("Anti AFKed Once")
                if AFKMousemoverel then
                    mousemoverel(-1, -1)
                    Heartbeat:Wait()
                    mousemoverel(1, 1)
                    AFKTimer = 0
                elseif AFKMousemoveabs then
                    local MousePos = Mouse.Position
                    mousemoveabs(0, 0)
                    Heartbeat:Wait()
                    mousemoveabs(MousePos.X, MousePos.Y)
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

function UniversalModules.AntiAFKValue(Number)
    AFKTime = Number
end

function UniversalModules.AntiAFKOption(Option)
    if Option == "1" then
        AFKMousemoverel = true
        AFKMousemoveabs = false
        AFKMouseClick1 = false
        AFKMouseClick2 = false
    elseif Option == "2" then
        AFKMousemoverel = false
        AFKMousemoveabs = true
        AFKMouseClick1 = false
        AFKMouseClick2 = false
    elseif Option == "3" then
        AFKMousemoverel = false
        AFKMousemoveabs = false
        AFKMouseClick1 = true
        AFKMouseClick2 = false
    elseif Option == "4" then
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
        CurrentFPS = getfpscap() or 240
        setfpscap(TargetFPS)
    else
        setfpscap(CurrentFPS)
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
            if Self == Speaker and Method:lower() == "kick" and AntiKickEnabled then
                return error("Expected ':' not '.' calling member function Kick", 2)
            end
            return Index(Self, Method)
        end)
        NameCall = hookmetamethod(game, "__namecall", function(Self, ...)
            if Self == Speaker and getnamecallmethod():lower() == "kick" and AntiKickEnabled then
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
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        CurrentWalkSpeed = Humanoid.WalkSpeed
        if Humanoid then
            Humanoid.WalkSpeed = ModedWalkSpeed
        end
        LockConnections.WS = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            Humanoid.WalkSpeed = ModedWalkSpeed
        end)
        LockConnections.WSCA = Speaker.CharacterAdded:Connect(function(Character)
            local Humanoid = Character:WaitForChild("Humanoid")
            if Humanoid then
                Humanoid.WalkSpeed = ModedWalkSpeed
            end
            LockConnections.WS = (LockConnections.WS and LockConnections.WS:Disconnect()) or Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
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
end

--|| Jump Power Function ||--

function UniversalModules.JumpPower(Enabled)
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        if not Humanoid.UseJumpPower then
            Humanoid.UseJumpPower = true
            NotUsingJumpPower = true
        end
        CurrentJumpPower = Humanoid.JumpPower
        if Humanoid then
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
                Humanoid.JumpPower = ModedJumpPower
            end
            LockConnections.JP = (LockConnections.JP and LockConnections.JP:Disconnect()) or Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                Humanoid.UseJumpPower = true
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
end

--|| Gravity Function ||--

function UniversalModules.Gravity(Enabled)
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
end

--|| Noclip Function ||--

function UniversalModules.Noclip(Enabled)
    if Enabled then
        NoclipParts = {}
        LockConnections.NC = (LockConnections.NC and LockConnections.NC:Disconnect()) or Stepped:Connect(function()
            local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
            for _, Part in pairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") and Part.CanCollide then
                    Part.CanCollide = false
                    if not table.find(NoclipParts, Part) then
                        table.insert(NoclipParts, Part)
                    end
                end
            end
        end)
    else
        if LockConnections.NC then
            LockConnections.NC:Disconnect()
            LockConnections.NC = nil
        end
        for _, Part in pairs(NoclipParts) do
            Part.CanCollide = true
        end
        NoclipParts = {}
    end
end

function UniversalModules.VehicleNoclip(Enabled)
    if Enabled then
        VNoclipParts = {}
        LockConnections.VNC = (LockConnections.VNC and LockConnections.VNC:Disconnect()) or Stepped:Connect(function(Delta)
            local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
            local Humanoid = Character:WaitForChild("Humanoid")
            if Humanoid.SeatPart then
                local Seat = Humanoid.SeatPart
                local VehicleModel = Seat.Parent
                if VehicleModel.ClassName == "Model" then
                    UniversalModules.Noclip(true)
                    for _, Part in pairs(VehicleModel:GetDescendants()) do
                        if Part:IsA("BasePart") and Part.CanCollide then
                            Part.CanCollide = false
                            if not table.find(VNoclipParts, Part) then
                                table.insert(VNoclipParts, Part)
                            end
                        end
                    end
                elseif VehicleModel.ClassName ~= "Model" then
                    VehicleModel = VehicleModel.Parent
                end
            end
        end)
    else
        if LockConnections.VNC then
            LockConnections.VNC:Disconnect()
            LockConnections.VNC = nil
        end
        for _, Part in pairs(VNoclipParts) do
            Part.CanCollide = true
        end
        VNoclipParts = {}
    end
end

--|| Fly Function ||--

function UniversalModules.Fly(Enabled)
    if Enabled then
        local Character = Speaker.Character or Speaker.CharacterAdded:Wait()
        Flying = true
        local RootPart = Character:WaitForChild("HumanoidRootPart")
        local Control = (QEFly and {W = 0, S = 0, A = 0, D = 0, Q = 0, E = 0}) or {W = 0, S = 0, A = 0, D = 0, LeftShift = 0, Space = 0}
        local FlyKeyDown = nil
        local FlyKeyUp = nil
        local FlyVelocity = Instance.new("BodyVelocity")
        FlyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        FlyVelocity.Velocity = 0
        FlyVelocity.Parent = RootPart
        if UseFlyGyro then
            local FlyGyro = Instance.new("BodyGyro")
            FlyGyro.P = 9e4
            FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            FlyGyro.CFrame = Camera.CFrame
            FlyGyro.Parent = RootPart
        end
        local UIP = UserInputService
        if UIP:IsKeyDown(Enum.KeyCode.W) then
            Control.W = 1
        end
        if UIP:IsKeyDown(Enum.KeyCode.S) then
            Control.S = 1
        end
        if UIP:IsKeyDown(Enum.KeyCode.A) then
            Control.A = 1
        end
        if UIP:IsKeyDown(Enum.KeyCode.D) then
            Control.D = 1
        end
        if QEFly and UIP:IsKeyDown(Enum.KeyCode.Q) then
            Control.Q = 1
        elseif UIP:IsKeyDown(Enum.KeyCode.LeftShift) then
            Control.LeftShift = 1
        end
        if QEFly and UIP:IsKeyDown(Enum.KeyCode.E) then
            Control.E = 1
        elseif UIP:IsKeyDown(Enum.KeyCode.Space) then
            Control.Space = 1
        end
        LockConnections.Fly = Stepped:Connect(function()
            local MoveDirection = Vector3.new(0, 0, 0)
            if not VFly and not SitFly then
                Character:FindFirstChild("Humanoid").PlatformStand = true
            elseif SitFly then
                Character:FindFirstChild("Humanoid").Sit = true
            end
            if Control.W == 1 then
                MoveDirection = MoveDirection + Camera.CFrame.LookVector
            end
            if Control.S == 1 then
                MoveDirection = MoveDirection - Camera.CFrame.LookVector
            end
            if Control.A == 1 then
                MoveDirection = MoveDirection - Camera.CFrame.RightVector
            end
            if Control.D == 1 then
                MoveDirection = MoveDirection + Camera.CFrame.RightVector
            end
            if Control.Q == 1 or Control.LeftShift == 1 then
                MoveDirection = MoveDirection - Vector3.new(0, VerticalFlySpeedMultipiler, 0)
            end
            if Control.E == 1 or Control.Space == 1 then
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
                Control.W = 1
            elseif Key == "s" then
                Control.S = 1
            elseif Key == "a" then
                Control.A = 1
            elseif Key == "d" then
                Control.D = 1
            elseif QEFly and Key == "q" then
                Control.Q = 1
            elseif QEFly and Key == "e" then
                Control.E = 1
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
                Control.W = 0
            elseif Key == "s" then
                Control.S = 0
            elseif Key == "a" then
                Control.A = 0
            elseif Key == "d" then
                Control.D = 0
            elseif QEFly and Key == "q" then
                Control.Q = 0
            elseif QEFly and Key == "e" then
                Control.E = 0
            end
        end)
        NonQEFlyKeyDown = not QEFly and UIP.InputBegan:Connect(function(Key)
            if Key.KeyCode == Enum.KeyCode.LeftShift then
                Control.LeftShift = 1
            elseif Key.KeyCode == Enum.KeyCode.Space then
                Control.Space = 1
            end
            if UseFlyGyro then
                pcall(function()
                    Camera.CameraType = Enum.CameraType.Track
                end)
            end
        end)
        NonQEFlyKeyUp = not QEFly and UIP.InputEnded:Connect(function(Key)
            if Key.KeyCode == Enum.KeyCode.LeftShift then
                Control.LeftShift = 0
            elseif Key.KeyCode == Enum.KeyCode.Space then
                Control.Space = 0
            end
        end)
    else
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
        local Character = Speaker.Character
        if Character then
            local RootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChild("Humanoid")
            Humanoid.PlatformStand = false
            Humanoid.Sit = false
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

return UniversalModules
