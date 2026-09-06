--[[
    🔥 BLOX FRUITS AUTO FARM - VERSÃO CORRIGIDA
    - Pega missão automaticamente
    - Vai até os NPCs da missão
    - Ataca até matar
    - Troca de ilha automaticamente
    - Interface com botão flutuante
    - Modo Debug para identificar problemas
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BLOXFRUITS_AUTO"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ========== ESTADO ==========
local state = {
    AutoFarm = false,
    CurrentIsland = 1,
    TargetNPC = nil,
    Farming = false,
    Debug = true, -- Mude para false se quiser menos mensagens
}

-- ========== BOLINHA FLUTUANTE ==========
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
frame.Size = UDim2.new(0, 350, 0, 270)
frame.Position = UDim2.new(0.5, -175, 0.5, -135)
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

-- Fechar
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
end)

-- Minimizar (Menu)
local menuBtn = Instance.new("TextButton")
menuBtn.Size = UDim2.new(0, 30, 0, 30)
menuBtn.Position = UDim2.new(1, -70, 0, 8)
menuBtn.BackgroundTransparency = 1
menuBtn.Text = "⌂"
menuBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
menuBtn.TextSize = 20
menuBtn.Font = Enum.Font.GothamBold
menuBtn.Parent = frame
menuBtn.MouseButton1Click:Connect(function()
    frame.Size = frame.Size == UDim2.new(0, 350, 0, 45) and UDim2.new(0, 350, 0, 270) or UDim2.new(0, 350, 0, 45)
end)

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0, 55)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Desligado"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame

-- Nível
local levelLabel = Instance.new("TextLabel")
levelLabel.Size = UDim2.new(0.9, 0, 0, 25)
levelLabel.Position = UDim2.new(0.05, 0, 0, 90)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "Nível: " .. tostring(LocalPlayer.Data.Level.Value)
levelLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
levelLabel.TextScaled = true
levelLabel.Font = Enum.Font.Gotham
levelLabel.Parent = frame

-- Ilha
local islandLabel = Instance.new("TextLabel")
islandLabel.Size = UDim2.new(0.9, 0, 0, 25)
islandLabel.Position = UDim2.new(0.05, 0, 0, 120)
islandLabel.BackgroundTransparency = 1
islandLabel.Text = "Ilha: Jungle"
islandLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
islandLabel.TextScaled = true
islandLabel.Font = Enum.Font.Gotham
islandLabel.Parent = frame

-- Debug Label
local debugLabel = Instance.new("TextLabel")
debugLabel.Size = UDim2.new(0.9, 0, 0, 20)
debugLabel.Position = UDim2.new(0.05, 0, 0, 150)
debugLabel.BackgroundTransparency = 1
debugLabel.Text = "Debug: Aguardando..."
debugLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
debugLabel.TextScaled = true
debugLabel.Font = Enum.Font.Gotham
debugLabel.Parent = frame

-- Botão Iniciar/Parar
local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0.8, 0, 0, 40)
btnToggle.Position = UDim2.new(0.1, 0, 0, 185)
btnToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
btnToggle.BorderSizePixel = 0
btnToggle.Text = "▶ INICIAR AUTO FARM"
btnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
btnToggle.TextScaled = true
btnToggle.Font = Enum.Font.GothamBold
btnToggle.Parent = frame

-- ========== DADOS DAS ILHAS (ATUALIZADO) ==========
local islands = {
    {name = "Jungle", levelMin = 1, levelMax = 15, npcName = "Bandit", spawn = Vector3.new(-1200, 25, 2800), questNPC = "Quest Giver"},
    {name = "Pirate Village", levelMin = 15, levelMax = 40, npcName = "Pirate", spawn = Vector3.new(-600, 15, 900), questNPC = "Quest Giver"},
    {name = "Desert", levelMin = 40, levelMax = 75, npcName = "Desert Bandit", spawn = Vector3.new(1000, 20, 2000), questNPC = "Quest Giver"},
    {name = "Snow Island", levelMin = 75, levelMax = 120, npcName = "Snow Bandit", spawn = Vector3.new(-3000, 100, 6000), questNPC = "Quest Giver"},
    {name = "Marine Fortress", levelMin = 120, levelMax = 200, npcName = "Marine", spawn = Vector3.new(2000, 30, -3000), questNPC = "Quest Giver"},
    {name = "Sky Islands", levelMin = 200, levelMax = 300, npcName = "Sky Bandit", spawn = Vector3.new(-4000, 300, 8000), questNPC = "Quest Giver"},
    {name = "Dragon Island", levelMin = 300, levelMax = 500, npcName = "Dragon", spawn = Vector3.new(5000, 50, 5000), questNPC = "Quest Giver"},
    {name = "Sea of Treats", levelMin = 500, levelMax = 750, npcName = "Candy", spawn = Vector3.new(-5000, 10, -5000), questNPC = "Quest Giver"},
    {name = "Graveyard", levelMin = 750, levelMax = 1000, npcName = "Zombie", spawn = Vector3.new(6000, 80, -4000), questNPC = "Quest Giver"},
    {name = "Frozen Village", levelMin = 1000, levelMax = 1500, npcName = "Frozen Bandit", spawn = Vector3.new(-7000, 150, 8000), questNPC = "Quest Giver"},
}

-- ========== FUNÇÕES DE LOG ==========
local function log(msg)
    if state.Debug then
        print("[AutoFarm] " .. msg)
        debugLabel.Text = "Debug: " .. msg
    end
end

-- ========== FUNÇÕES DE UTILIDADE ==========
local function getCurrentIsland()
    local level = LocalPlayer.Data.Level.Value
    for i, island in ipairs(islands) do
        if level >= island.levelMin and level <= island.levelMax then
            return i, island
        end
    end
    return #islands, islands[#islands]
end

-- Encontra NPCs vivos pelo nome
local function findNPCsByName(name)
    local npcs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find(name:lower()) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            table.insert(npcs, v)
        end
    end
    return npcs
end

-- Encontra o NPC mais próximo
local function getNearestNPC(name)
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local npcs = findNPCsByName(name)
    local nearest = nil
    local shortest = math.huge
    for _, npc in pairs(npcs) do
        local npcHrp = npc:FindFirstChild("HumanoidRootPart")
        if npcHrp then
            local dist = (npcHrp.Position - hrp.Position).Magnitude
            if dist < shortest then
                shortest = dist
                nearest = npc
            end
        end
    end
    return nearest
end

-- ========== PEGAR MISSÃO ==========
local function acceptQuest()
    local island = islands[state.CurrentIsland]
    if not island then return false end

    -- Procura o NPC de missão na ilha
    local questNPC = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("quest") and v:FindFirstChild("Humanoid") then
            questNPC = v
            break
        end
    end

    if not questNPC then
        log("NPC de missão não encontrado!")
        return false
    end

    -- Tenta interagir com ClickDetector
    local detector = questNPC:FindFirstChild("ClickDetector")
    if detector then
        log("Usando ClickDetector para pegar missão...")
        detector:FireClick(LocalPlayer.Character)
        return true
    end

    -- Tenta com ProximityPrompt
    local prompt = questNPC:FindFirstChild("ProximityPrompt")
    if prompt then
        log("Usando ProximityPrompt para pegar missão...")
        prompt:Fire()
        return true
    end

    -- Tenta encontrar um botão de aceitar na GUI
    local playerGui = LocalPlayer.PlayerGui
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("Frame") and gui.Name:lower():find("quest") then
            local accept = gui:FindFirstChild("AcceptButton") or gui:FindFirstChild("Accept")
            if accept and accept:IsA("TextButton") then
                log("Clicando no botão Aceitar...")
                accept:FireServer()
                return true
            end
        end
    end

    log("Nenhum método de interação com missão encontrado.")
    return false
end

-- ========== MOVIMENTAÇÃO ==========
local function walkTo(position)
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return false end

    hum:MoveTo(position)
    -- Aguarda até chegar perto (distância < 5)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        while (hrp.Position - position).Magnitude > 5 and state.AutoFarm do
            RunService.Heartbeat:Wait()
            hum:MoveTo(position)
        end
    end
    return true
end

-- ========== ATAQUE ==========
local function attackNPC(npc)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local npcHrp = npc:FindFirstChild("HumanoidRootPart")
    if not npcHrp then return end

    local dist = (npcHrp.Position - hrp.Position).Magnitude
    if dist > 8 then
        walkTo(npcHrp.Position)
        return
    end

    -- Tenta usar a ferramenta atual (combate)
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        log("Atacando com " .. tool.Name)
        tool:Activate()
        task.wait(0.1)
        tool:Deactivate()
        return
    end

    -- Se não tiver ferramenta, tenta usar o mouse para clicar no NPC (ataque corpo a corpo)
    log("Atacando corpo a corpo...")
    local pos, onScreen = Camera:WorldToScreenPoint(npcHrp.Position)
    if onScreen then
        Mouse.Move(Vector2.new(pos.X, pos.Y))
        Mouse.Button1Down()
        task.wait(0.05)
        Mouse.Button1Up()
    end
end

-- ========== AUTO FARM PRINCIPAL ==========
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
    log("Iniciando Auto Farm na ilha " .. island.name)

    farmConnection = RunService.Heartbeat:Connect(function()
        if not state.AutoFarm then return end

        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            statusLabel.Text = "Status: Aguardando respawn..."
            log("Personagem morto, aguardando...")
            return
        end

        -- Atualiza nível e ilha
        local level = LocalPlayer.Data.Level.Value
        levelLabel.Text = "Nível: " .. tostring(level)

        local idx, island = getCurrentIsland()
        if idx ~= state.CurrentIsland then
            state.CurrentIsland = idx
            islandLabel.Text = "Ilha: " .. island.name
            log("Trocando para ilha " .. island.name)
            walkTo(island.spawn)
            return
        end

        -- Verifica se tem missão ativa (procura pela GUI de missão)
        local hasQuest = false
        for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if v:IsA("Frame") and v.Name:lower():find("quest") then
                hasQuest = true
                break
            end
        end

        if not hasQuest then
            statusLabel.Text = "Status: Pegando missão..."
            log("Tentando pegar missão...")
            if acceptQuest() then
                log("Missão aceita!")
            else
                log("Falha ao pegar missão, tentando novamente...")
            end
            return
        end

        -- Procura NPCs para atacar
        local npcName = island.npcName
        local npc = getNearestNPC(npcName)
        if npc then
            state.TargetNPC = npc
            statusLabel.Text = "Status: Atacando " .. npc.Name
            log("Atacando " .. npc.Name)
            attackNPC(npc)
        else
            statusLabel.Text = "Status: Procurando NPCs..."
            log("Nenhum NPC encontrado, movendo para spawn...")
            walkTo(island.spawn)
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
    log("Auto Farm desligado.")
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
        log("GUI aberta.")
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if state.AutoFarm then
        log("Personagem renasceu, continuando farm...")
        startAutoFarm()
    end
end)

-- Atualiza nível periodicamente
RunService.Heartbeat:Connect(function()
    if frame.Visible then
        levelLabel.Text = "Nível: " .. tostring(LocalPlayer.Data.Level.Value)
    end
end)

print("✅ BLOX FRUITS AUTO FARM carregado! Clique na bolinha vermelha.")
print("🔧 Modo Debug ativado - veja os logs no console.")
