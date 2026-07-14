-- 🟢 Fly Script для Мобильных Executors (Arceus X, Hydrogen, Delta и т.д.)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local Flying = false
local FlySpeed = 60
local MaxSpeed = 180

local BV = Instance.new("BodyVelocity")
BV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
BV.Velocity = Vector3.new(0,0,0)

local BG = Instance.new("BodyGyro")
BG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
BG.P = 12500

-- GUI для телефона
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 140, 0, 220)
Frame.Position = UDim2.new(0, 20, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.4
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Mobile Fly"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.Text = "ВКЛЮЧИТЬ FLY"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0, 12)
Corner2.Parent = ToggleBtn

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 110)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Скорость: " .. FlySpeed
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.TextSize = 15
SpeedLabel.Parent = Frame

-- Функции
local Connection = nil

local function StartFly()
    Flying = true
    BV.Parent = RootPart
    BG.Parent = RootPart
    Humanoid.PlatformStand = true
    
    ToggleBtn.Text = "ВЫКЛЮЧИТЬ FLY"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    
    Connection = RunService.RenderStepped:Connect(function()
        if not Flying then return end
        
        local Camera = workspace.CurrentCamera
        local MoveDir = Vector3.new(0, 0, 0)
        
        -- Управление с камеры (стандартно для мобильных)
        if UserInputService.TouchEnabled then
            -- Для мобильных обычно используют движение камеры + кнопки
            MoveDir = Camera.CFrame.LookVector * 0.8 -- основной вперёд
        end
        
        -- Дополнительно: вверх/вниз
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.ButtonA) then
            MoveDir = MoveDir + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            MoveDir = MoveDir - Vector3.new(0,1,0)
        end
        
        if MoveDir.Magnitude > 0 then
            MoveDir = MoveDir.Unit
        end
        
        BV.Velocity = MoveDir * FlySpeed
        BG.CFrame = Camera.CFrame
    end)
end

local function StopFly()
    Flying = false
    if Connection then Connection:Disconnect() end
    BV.Parent = nil
    BG.Parent = nil
    if Humanoid then Humanoid.PlatformStand = false end
    
    ToggleBtn.Text = "ВКЛЮЧИТЬ FLY"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
end

-- Переключатель
ToggleBtn.MouseButton1Click:Connect(function()
    if Flying then
        StopFly()
    else
        StartFly()
    end
end)

-- Изменение скорости (тап по кнопкам можно добавить, но пока колёсико/кнопки)
print("📱 Mobile Fly загружен!")
print("Нажми кнопку на экране для включения")

-- Авто-выключение при смерти
LocalPlayer.CharacterAdded:Connect(function(new)
    Character = new
    Humanoid = new:WaitForChild("Humanoid")
    RootPart = new:WaitForChild("HumanoidRootPart")
end)

Humanoid.Died:Connect(StopFly)
