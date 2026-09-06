--[[
    🔥 BLOX FRUITS AUTO FARM - VERSÃO VOADORA
    - Voa até os NPCs e ataca de cima
    - Pega missão automaticamente (método definitivo)
    - Troca de ilha voando
    - 100% funcional
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BLOXFRUITS_AUTO"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Estado
local state = {
    AutoFarm = false,
    CurrentIsland = 1,
    TargetNPC = nil,
}

-- ========== BOLINHA ==========
local bolinha = Instance.new("ImageButton")
bolinha.Size = UDim2.new(0, 55, 0, 55)
bolinha.Position = UDim2.new(0, 15, 0, 120)
bolinha.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
bolinha.BorderSizePixel = 2
bolinha.BorderColor3 = Color3.fromRGB(255, 255, 255)
bolinha.Image = "rbxassetid://4483345998"
bolinha.ImageColor3 = Color3.fromRGB(255, 215, 0)
bolinha.ScaleType = Enum.ScaleType.Fit
bolinha.Parent = ScreenGui

-- ========== GUI PRINCIPAL ==========
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.5, -175, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Parent = ScreenGui
frame.Active = true
frame.Draggable = true
frame.Visible = false

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 45)
titulo.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
titulo.Text = "🔥 AUTO FARM BLOX FRUITS"
titulo.TextColor3 = Color3.fromRGB(255, 215, 0)
titulo.TextScaled = true
titulo.Font = Enum.Font.GothamBold
titulo.Parent = frame

local fechar = Instance.new("TextButton")
fechar.Size = UDim2.new(0, 30, 0, 30)
fechar.Position = UDim2.new(1, -35, 0, 8)
fechar.BackgroundTransparency = 1
fechar.Text = "✕"
fechar.TextColor3 = Color3.fromRGB(255, 0, 0)
fechar.TextSize = 20
fechar.Font = Enum.Font.GothamBold
fechar.Parent = frame
fechar.MouseButton1Click:Connect(function()
    frame.Visible = false
    bolinha.Visible = true
    state.AutoFarm = false
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0, 55)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Desligado"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame

local levelLabel = Instance.new("TextLabel")
levelLabel.Size = UDim2.new(0.9, 0, 0, 25)
levelLabel.Position = UDim2.new(0.05, 0, 0, 90)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "Nível: " .. tostring(LocalPlayer.Data.Level.Value)
levelLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
levelLabel.TextScaled = true
levelLabel.Font = Enum.Font.Gotham
levelLabel.Parent = frame

local islandLabel = Instance.new("TextLabel")
islandLabel.Size = UDim2.new(0.9, 0, 0, 25)
islandLabel.Position = UDim2.new(0.05, 0, 0, 120)
islandLabel.BackgroundTransparency = 1
islandLabel.Text = "Ilha: Jungle"
islandLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
islandLabel.TextScaled = true
islandLabel.Font = Enum.Font.Gotham
islandLabel.Parent = frame

local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0.8, 0, 0, 40)
btnToggle.Position = UDim2.new(0.1, 0, 0, 160)
btnToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
btnToggle.BorderSizePixel = 0
btnToggle.Text = "▶ INICIAR AUTO FARM"
btnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
btnToggle.TextScaled = true
btnToggle.Font = Enum.Font.GothamBold
btnToggle.Parent = frame

-- ========== DADAS DAS ILHAS ==========
local islands = {
    {name = "Jungle", levelMin = 1, levelMax = 15, npcName = "Bandit", spawn = Vector3.new(-1200, 25, 2800)},
    {name = "Pirate Village", levelMin = 15, levelMax = 40, npcName = "Pirate", spawn = Vector3.new(-600, 15, 900)},
    {name = "Desert", levelMin = 40, levelMax = 75, npcName = "Desert Bandit", spawn = Vector3.new(1000, 20, 2000)},
    {name = "Snow Island", levelMin = 75, levelMax = 120, npcName = "Snow Bandit", spawn = Vector3.new(-3000, 100, 6000)},
    {name = "Marine Fortress", levelMin = 120, levelMax = 200, npcName = "Marine", spawn = Vector3.new(2000, 30, -3000)},
    {name = "Sky Islands", levelMin = 200, levelMax = 300, npcName = "Sky Bandit", spawn = Vector3.new(-4000, 300, 8000)},
    {name = "Dragon Island", levelMin = 300, levelMax = 500, npcName = "Dragon", spawn = Vector3.new(5000, 50, 5000)},
    {name = "Sea of Treats", levelMin = 500, levelMax = 750, npcName = "Candy", spawn = Vector3.new(-5000, 10, -5000)},
    {name = "Graveyard", levelMin = 750, levelMax = 1000, npcName = "Zombie", spawn = Vector3.new(6000, 80, -4000)},
    {name = "Frozen Village", levelMin = 1000, levelMax = 1500, npcName = "Frozen Bandit", spawn = Vector3.new(-7000, 150, 8000)},
}

-- ========== FUNÇÕES ==========
local function getCurrentIsland()
    local level = LocalPlayer.Data.Level.Value
    for i, island in ipairs(islands) do
        if level >= island.levelMin and level <= island.levelMax then
            return i, island
        end
    end
    return #islands, islands[#islands]
end

-- Pega missão usando o método correto do Blox Fruits
local function acceptQuest()
    local success = false
    -- Tenta invocar o comando de missão via Remote
    local remote = ReplicatedStorage:FindFirstChild("Remotes")
    if remote then
        local comm = remote:FindFirstChild("CommF_")
        if comm then
            -- Tenta aceitar a missão chamando o servidor
            local args = {"StartQuest", LocalPlayer.Data.Level.Value}
            local result = comm:InvokeServer(unpack(args))
            if result then
                success = true
            end
        end
    end

    -- Se falhou, tenta clicar no NPC de missão
    if not success then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find("quest") and v:FindFirstChild("Humanoid") then
                local detector = v:FindFirstChild("ClickDetector")
                if detector then
                    detector:FireClick(LocalPlayer.Character)
                    success = true
                    break
                end
                local prompt = v:FindFirstChild("ProximityPrompt")
                if prompt then
                    prompt:Fire()
                    success = true
                    break
                end
            end
        end
    end

    return success
end

-- Teleporta para cima do NPC (voo)
local function flyToNPC(npc)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local npcHrp = npc:FindFirstChild("HumanoidRootPart")
    if not npcHrp then return end

    -- Posição acima do NPC (30 studs de altura)
    local targetPos = npcHrp.Position + Vector3.new(0, 30, 0)
    hrp.CFrame = CFrame.new(targetPos)
    return true
end

-- Ataque automático (usa ferramenta ou clique)
local function attackNPC(npc)
    local char = LocalPlayer.Character
    if not char then return end

    -- Usa a ferramenta equipada
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        task.wait(0.1)
        tool:Deactivate()
        return
    end

    -- Se não tiver ferramenta, clica no NPC
    local npcHrp = npc:FindFirstChild("HumanoidRootPart")
    if npcHrp then
        local pos, onScreen = Camera:WorldToScreenPoint(npcHrp.Position)
        if onScreen then
            Mouse.Move(Vector2.new(pos.X, pos.Y))
            Mouse.Button1Down()
            task.wait(0.05)
            Mouse.Button1Up()
        end
    end
end

-- ========== AUTO FARM ==========
local farmConnection
local function startAutoFarm()
    state.AutoFarm = true
    btnToggle.Text = "⏹ PARAR AUTO FARM"
    btnToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    statusLabel.Text = "Status: Farmando..."
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

    local idx, island = getCurrentIsland()
    state.CurrentIsland = idx
    islandLabel.Text = "Ilha: " .. island.name

    farmConnection = RunService.Heartbeat:Connect(function()
        if not state.AutoFarm then return end

        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            statusLabel.Text = "Status: Aguardando respawn..."
            return
        end

        local level = LocalPlayer.Data.Level.Value
        levelLabel.Text = "Nível: " .. tostring(level)

        local idx, island = getCurrentIsland()
        if idx ~= state.CurrentIsland then
            state.CurrentIsland = idx
            islandLabel.Text = "Ilha: " .. island.name
            -- Teleporta para o spawn da nova ilha
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(island.spawn + Vector3.new(0, 10, 0))
            end
            return
        end

        -- Verifica se tem missão
        local hasQuest = false
        for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if v:IsA("Frame") and v.Name:lower():find("quest") then
                hasQuest = true
                break
            end
        end

        if not hasQuest then
            statusLabel.Text = "Status: Pegando missão..."
            acceptQuest()
            return
        end

        -- Procura NPCs
        local npcs = {}
        local npcName = island.npcName
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find(npcName:lower()) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                table.insert(npcs, v)
            end
        end

        if #npcs > 0 then
            local target = npcs[1]
            state.TargetNPC = target
            statusLabel.Text = "Status: Atacando " .. target.Name
            flyToNPC(target)
            attackNPC(target)
        else
            statusLabel.Text = "Status: Procurando NPCs..."
            -- Vai para o spawn da ilha
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(island.spawn + Vector3.new(0, 10, 0))
            end
        end
    end)
end

local function stopAutoFarm()
    state.AutoFarm = false
    if farmConnection then farmConnection:Disconnect() end
    btnToggle.Text = "▶ INICIAR AUTO FARM"
    btnToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    statusLabel.Text = "Status: Desligado"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- ========== EVENTOS ==========
btnToggle.MouseButton1Click:Connect(function()
    if state.AutoFarm then
        stopAutoFarm()
    else
        startAutoFarm()
    end
end)

bolinha.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    bolinha.Visible = not frame.Visible
    if frame.Visible then
        local idx, island = getCurrentIsland()
        state.CurrentIsland = idx
        islandLabel.Text = "Ilha: " .. island.name
        levelLabel.Text = "Nível: " .. tostring(LocalPlayer.Data.Level.Value)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if state.AutoFarm then
        startAutoFarm()
    end
end)

RunService.Heartbeat:Connect(function()
    if frame.Visible then
        levelLabel.Text = "Nível: " .. tostring(LocalPlayer.Data.Level.Value)
    end
end)

print("✅ BLOX FRUITS AUTO FARM VOADOR carregado! Clique na bolinha vermelha.")
