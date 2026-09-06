--[[
    🔥 GOD HUB - Blox Fruits Keyless
    100% Funcional
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GODHUB"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local state = {
    AutoFarm = false,
    KillAura = false,
    ESP = false,
    Fly = false,
    Noclip = false,
    Speed = 16,
    Jump = 50,
}

-- ========== BOLINHA ==========
local bolinha = Instance.new("ImageButton")
bolinha.Size = UDim2.new(0, 50, 0, 50)
bolinha.Position = UDim2.new(0, 10, 0, 100)
bolinha.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
bolinha.BorderSizePixel = 2
bolinha.BorderColor3 = Color3.fromRGB(255, 215, 0)
bolinha.Image = "rbxassetid://4483345998"
bolinha.ImageColor3 = Color3.fromRGB(255, 215, 0)
bolinha.ScaleType = Enum.ScaleType.Fit
bolinha.Parent = ScreenGui

-- ========== FRAME ==========
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 400)
frame.Position = UDim2.new(0.5, -190, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Parent = ScreenGui
frame.Active = true
frame.Draggable = true
frame.Visible = false

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
titulo.Text = "🔥 GOD HUB"
titulo.TextColor3 = Color3.fromRGB(255, 215, 0)
titulo.TextScaled = true
titulo.Font = Enum.Font.GothamBold
titulo.Parent = frame

local fechar = Instance.new("TextButton")
fechar.Size = UDim2.new(0, 30, 0, 30)
fechar.Position = UDim2.new(1, -35, 0, 5)
fechar.BackgroundTransparency = 1
fechar.Text = "✕"
fechar.TextColor3 = Color3.fromRGB(255, 0, 0)
fechar.TextSize = 20
fechar.Font = Enum.Font.GothamBold
fechar.Parent = frame
fechar.MouseButton1Click:Connect(function()
    frame.Visible = false
    bolinha.Visible = true
end)

local function createToggle(parent, text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = text .. (active and " [ON]" or " [OFF]")
        btn.BorderColor3 = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
        if callback then callback(active) end
    end)
    return btn
end

local function createSlider(parent, text, y, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 40)
    container.Position = UDim2.new(0.05, 0, 0, y)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    container.BorderSizePixel = 1
    container.BorderColor3 = Color3.fromRGB(60, 60, 60)
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = container

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.4, 0, 0, 8)
    slider.Position = UDim2.new(0.55, 0, 0.6, 0)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.BorderSizePixel = 0
    slider.Parent = container

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fill.BorderSizePixel = 0
    fill.Parent = slider

    local drag = Instance.new("TextButton")
    drag.Size = UDim2.new(0, 12, 0, 12)
    drag.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    drag.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    drag.BorderSizePixel = 0
    drag.Text = ""
    drag.Parent = slider

    local value = default
    local dragging = false
    local connection

    drag.MouseButton1Down:Connect(function()
        dragging = true
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                value = math.round((min + (max - min) * pos) * 10) / 10
                fill.Size = UDim2.new(pos, 0, 1, 0)
                drag.Position = UDim2.new(pos, -6, 0.5, -6)
                label.Text = text .. ": " .. tostring(value)
                if callback then callback(value) end
            end
        end)
    end)

    drag.MouseButton1Up:Connect(function()
        dragging = false
        if connection then connection:Disconnect() end
    end)
end

-- ========== AUTO FARM ==========
local farmConnection
local function startAutoFarm(active)
    state.AutoFarm = active
    if farmConnection then farmConnection:Disconnect() end
    if not active then return end

    farmConnection = RunService.Heartbeat:Connect(function()
        if not state.AutoFarm then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local target = nil
        local shortest = math.huge

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local npcHrp = v:FindFirstChild("HumanoidRootPart")
                if npcHrp then
                    local dist = (npcHrp.Position - hrp.Position).Magnitude
                    if dist < shortest and dist < 100 then
                        shortest = dist
                        target = v
                    end
                end
            end
        end

        if target then
            local npcHrp = target:FindFirstChild("HumanoidRootPart")
            if npcHrp then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum:MoveTo(npcHrp.Position)
                end
                -- Ataca
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    task.wait(0.1)
                    tool:Deactivate()
                end
            end
        end
    end)
end

-- ========== KILL AURA ==========
local killAuraConnection
local function startKillAura(active)
    state.KillAura = active
    if killAuraConnection then killAuraConnection:Disconnect() end
    if not active then return end

    killAuraConnection = RunService.Heartbeat:Connect(function()
        if not state.KillAura then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local npcHrp = v:FindFirstChild("HumanoidRootPart")
                if npcHrp and (npcHrp.Position - hrp.Position).Magnitude < 20 then
                    v.Humanoid.Health = 0
                end
            end
        end
    end)
end

-- ========== ESP ==========
local espConnection
local function startESP(active)
    state.ESP = active
    if espConnection then espConnection:Disconnect() end
    if not active then return end

    espConnection = RunService.RenderStepped:Connect(function()
        if not state.ESP then return end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                local h = v:FindFirstChild("ESP_Highlight")
                if not h then
                    h = Instance.new("Highlight")
                    h.Name = "ESP_Highlight"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.FillTransparency = 0.5
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.Parent = v
                end
            end
        end
    end)
end

-- ========== MOVIMENTO ==========
local function setSpeed(value)
    state.Speed = value
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end

local function setJump(value)
    state.Jump = value
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end

local function toggleFly(active)
    state.Fly = active
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = active
    end
end

local function toggleNoclip(active)
    state.Noclip = active
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not active
            end
        end
    end
end

-- ========== CRIAR ELEMENTOS ==========
createToggle(frame, "Auto Farm", 50, startAutoFarm)
createToggle(frame, "Kill Aura", 90, startKillAura)
createToggle(frame, "ESP", 130, startESP)
createToggle(frame, "Fly", 170, toggleFly)
createToggle(frame, "Noclip", 210, toggleNoclip)
createSlider(frame, "Speed", 255, 10, 100, 16, setSpeed)
createSlider(frame, "Jump", 300, 20, 200, 50, setJump)

-- ========== BOLINHA ==========
bolinha.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    bolinha.Visible = not frame.Visible
end)

print("✅ GOD HUB carregado! Clique na bolinha vermelha.")
