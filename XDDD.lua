local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinBtn = Instance.new("TextButton")
local OpenBtn = Instance.new("TextButton")

local connections = {}
local settings = {
    speedOn = false,
    brakeOn = false,
    extraDownforce = false,
    accelPower = 0.6, 
    maxSpeed = 160
}

local PCD_MULTIPLIER = 4.05 

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 10)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 480) -- Zwiększone pod napis
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Title.Text = "PCD HYPER-SONIC [X]"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold

-- Systemowe
CloseBtn.Parent = MainFrame; CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 2); CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MinBtn.Parent = MainFrame; MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -65, 0, 2); MinBtn.Text = "_"; MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
OpenBtn.Parent = ScreenGui; OpenBtn.Size = UDim2.new(0, 100, 0, 30); OpenBtn.Position = UDim2.new(0, 10, 0, 10); OpenBtn.Text = "[ OTWÓRZ ]"; OpenBtn.Visible = false

CloseBtn.MouseButton1Click:Connect(function() for _, c in pairs(connections) do c:Disconnect() end ScreenGui:Destroy() end)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

local function MakeToggle(name, pos, callback)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.8, 0, 0, 30); b.Position = pos; b.Font = Enum.Font.GothamBold; b.TextColor3 = Color3.new(1, 1, 1)
    local s = false
    local function up()
        b.Text = name .. (s and ": ON" or ": OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        callback(s)
    end
    b.MouseButton1Click:Connect(function() s = not s up() end)
    up()
end

MakeToggle("TURBO + AUTO-DOCISK", UDim2.new(0.1, 0, 0.1, 0), function(v) settings.speedOn = v end)
MakeToggle("EKSTRA DOCISK", UDim2.new(0.1, 0, 0.18, 0), function(v) settings.extraDownforce = v end)
MakeToggle("HAMOWANIE (S)", UDim2.new(0.1, 0, 0.26, 0), function(v) settings.brakeOn = v end)

local function MakeSlider(name, pos, isPower)
    local lab = Instance.new("TextLabel", MainFrame)
    lab.Position = pos; lab.Size = UDim2.new(1, 0, 0, 20); lab.TextColor3 = Color3.new(1, 1, 1); lab.BackgroundTransparency = 1
    lab.Text = isPower and name..": 0.6" or name..": 160"

    local bg = Instance.new("TextButton", MainFrame)
    bg.Position = pos + UDim2.new(0.1, 0, 0, 22); bg.Size = UDim2.new(0.8, 0, 0, 10); bg.BackgroundColor3 = Color3.fromRGB(50, 50, 50); bg.Text = ""

    local f = Instance.new("Frame", bg)
    f.Size = UDim2.new(isPower and 0.03 or 0.1, 0, 1, 0); f.BackgroundColor3 = isPower and Color3.new(1, 0.5, 0) or Color3.new(0, 1, 0.5); f.BorderSizePixel = 0

    bg.MouseButton1Down:Connect(function()
        local con
        con = game:GetService("RunService").RenderStepped:Connect(function()
            if not game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then con:Disconnect() else
                local x = math.clamp((game:GetService("UserInputService"):GetMouseLocation().X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                f.Size = UDim2.new(x, 0, 1, 0)
                if isPower then
                    settings.accelPower = 0.1 + (x * 19.9)
                    lab.Text = name .. ": " .. math.floor(settings.accelPower * 10) / 10
                else
                    settings.maxSpeed = math.floor(130 + (x * 870))
                    lab.Text = name .. ": " .. settings.maxSpeed
                end
            end
        end)
    end)
end

MakeSlider("MOC TURBO", UDim2.new(0, 0, 0.40, 0), true)
MakeSlider("LIMIT KM/H", UDim2.new(0, 0, 0.55, 0), false)

-- OPIS OPTYMALNYCH USTAWIEŃ
local WarnBox = Instance.new("Frame", MainFrame)
WarnBox.Size = UDim2.new(0.9, 0, 0, 80); WarnBox.Position = UDim2.new(0.05, 0, 0.78, 0)
WarnBox.BackgroundColor3 = Color3.fromRGB(40, 0, 0); WarnBox.BorderSizePixel = 1

local WarnText = Instance.new("TextLabel", WarnBox)
WarnText.Size = UDim2.new(1, -10, 1, -10); WarnText.Position = UDim2.new(0, 5, 0, 5)
WarnText.BackgroundTransparency = 1; WarnText.TextColor3 = Color3.new(1, 0.8, 0); WarnText.Font = Enum.Font.GothamBold
WarnText.TextSize = 12; WarnText.TextWrapped = true
WarnText.Text = "OPTYMALNA PREDKOSC ABY NIE DOSTAC BANA PO 1 SEK:\n\nMOC TURBO: 0.6\nMAX KM/H: 160"

-- FIZYKA
connections.Loop = game:GetService("RunService").Heartbeat:Connect(function()
    local p = game.Players.LocalPlayer
    local s = p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.SeatPart
    if s and s:IsA("VehicleSeat") then
        local u = game:GetService("UserInputService")
        local speed = s.AssemblyLinearVelocity.Magnitude * 3.6 / PCD_MULTIPLIER
        
        if settings.speedOn and u:IsKeyDown(Enum.KeyCode.W) and not u:GetFocusedTextBox() then
            if speed < settings.maxSpeed then
                local boost = (settings.accelPower * 0.4) + ((settings.maxSpeed - speed) / 2000)
                s.AssemblyLinearVelocity = s.AssemblyLinearVelocity + (s.CFrame.LookVector * boost)
            else
                local targetVel = (settings.maxSpeed * PCD_MULTIPLIER) / 3.6
                s.AssemblyLinearVelocity = s.CFrame.LookVector * targetVel
            end
            s.AssemblyLinearVelocity = s.AssemblyLinearVelocity + Vector3.new(0, -0.4, 0)
        end
        
        if settings.extraDownforce then
            s.AssemblyLinearVelocity = s.AssemblyLinearVelocity + Vector3.new(0, -1.5, 0)
        end

        if settings.brakeOn and u:IsKeyDown(Enum.KeyCode.S) and not u:GetFocusedTextBox() then
            s.AssemblyLinearVelocity = s.AssemblyLinearVelocity * 0.965
        end
    end
end)