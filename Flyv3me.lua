-- 🚀 УЛУЧШЕННЫЙ Mobile Fly + Noclip
-- Для Arceus X, Hydrogen, Delta и других мобильных executors

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local Flying = false
local Noclip = false
local FlySpeed = 70
local MaxSpeed = 200

local BV = Instance.new("BodyVelocity")
BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
BV.Velocity = Vector3.new(0,0,0)

local BG = Instance.new("BodyGyro")
BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
BG.P = 12500

-- Красивый GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileFlyPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 170, 0, 280)
MainFrame.Position = UDim2.new(0, 15, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 18)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "🚀 Fly Pro"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопки
local function CreateButton(name, posY, color, text)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.88, 0, 0, 48)
    Btn.Position = UDim2.new(0.06, 0, 0, posY)
    Btn.BackgroundColor3 = color
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.TextSize = 16
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Parent = MainFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 14)
    Corner.Parent = Btn
    
    return Btn
end

local ToggleFly = CreateButton("ToggleFly", 55, Color3.fromRGB(0, 170, 100), "ВКЛЮЧИТЬ ПОЛЁТ")
local ToggleNoclip = CreateButton("ToggleNoclip", 110, Color3.fromRGB(100, 100, 255), "Noclip: OFF")
local SpeedUp = CreateButton("SpeedUp", 165, Color3.fromRGB(70, 70, 80), "▲ Скорость +10")
local SpeedDown = CreateButton("SpeedDown", 220, Color3.fromRGB(70, 70, 80), "▼ Скорость -10")

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.9, 0, 0, 30)
Status.Position = UDim2.new(0.05, 0, 0, 240)
Status.BackgroundTransparency = 1
Status.Text = "Готов"
Status.TextColor3 = Color3.fromRGB(150, 255, 150)
Status.TextSize = 14
Status.Font = Enum.Font.Gotham
Status.Parent = MainFrame

-- Логика полёта
local Connection = nil

local function UpdateFly()
    if not Flying then return end
    local Camera = Workspace.CurrentCamera
    local MoveDir = Camera.CFrame.LookVector * 0.7  -- основной вперёд
    
    -- Дополнительное управление (если клавиатура подключена)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then MoveDir = MoveDir + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then MoveDir = MoveDir - Vector3.new(0,1,0) end
    
    if MoveDir.Magnitude > 0 then
        MoveDir = MoveDir.Unit
    end
    
    BV.Velocity = MoveDir * FlySpeed
    BG.CFrame = Camera.CFrame
end

local function StartFly()
    Flying = true
    BV.Parent = RootPart
    BG.Parent = RootPart
    Humanoid.PlatformStand = true
    
    ToggleFly.Text = "ВЫКЛЮЧИТЬ ПОЛЁТ"
    ToggleFly.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    Status.Text = "Полёт: АКТИВЕН"
    
    if Connection then Connection:Disconnect() end
    Connection = RunService.RenderStepped:Connect(UpdateFly)
end

local function StopFly()
    Flying = false
    if Connection then Connection:Disconnect() end
    BV.Parent = nil
    BG.Parent = nil
    if Humanoid then Humanoid.PlatformStand = false end
    
    ToggleFly.Text = "ВКЛЮЧИТЬ ПОЛЁТ"
    ToggleFly.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    Status.Text = "Полёт: Выкл"
end

-- Noclip
local function ToggleNoclipFunc()
    Noclip = not Noclip
    ToggleNoclip.Text = "Noclip: " .. (Noclip and "ON" or "OFF")
    ToggleNoclip.BackgroundColor3 = Noclip and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 255)
    
    if Noclip then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- Кнопки
ToggleFly.MouseButton1Click:Connect(function()
    if Flying then StopFly() else StartFly() end
end)

ToggleNoclip.MouseButton1Click:Connect(ToggleNoclipFunc)

SpeedUp.MouseButton1Click:Connect(function()
    FlySpeed = math.min(FlySpeed + 10, MaxSpeed)
    Status.Text = "Скорость: " .. FlySpeed
end)

SpeedDown.MouseButton1Click:Connect(function()
    FlySpeed = math.max(FlySpeed - 10, 10)
    Status.Text = "Скорость: " .. FlySpeed
end)

-- Авто-обновление при респавне
LocalPlayer.CharacterAdded:Connect(function(New)
    Character = New
    Humanoid = New:WaitForChild("Humanoid")
    RootPart = New:WaitForChild("HumanoidRootPart")
    if Flying then
        wait(0.5)
        StartFly()
    end
end)

Humanoid.Died:Connect(StopFly)

print("✅ Улучшенный Mobile Fly Pro загружен!")
print("Перетаскивай окно за заголовок")
