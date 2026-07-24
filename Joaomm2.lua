-- LocalScript para Muscle Legends - Auto Clicker & Fast Tools
-- Cole em StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Configurações
local CONFIG = {
    AutoClickEnabled = false,
    ClickSpeed = 0.01, -- Velocidade do clique (menor = mais rápido)
    ReachDistance = 50, -- Distância para detectar pesos
    ToggleKey = Enum.KeyCode.F2, -- F2 para ativar/desativar
    TeleportKey = Enum.KeyCode.F3, -- F3 para menu de teleportação
    AutoEquipKey = Enum.KeyCode.F4, -- F4 para auto-equipar
}

local isAutoClicking = CONFIG.AutoClickEnabled
local lastClickTime = 0
local selectedGym = "Main" -- Gym selecionado para teleporte

-- Função para obter peso mais próximo
local function getNearestWeight()
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local workspace = game:GetService("Workspace")
    local nearestWeight = nil
    local shortestDistance = CONFIG.ReachDistance
    
    -- Procurar por objetos de treino (pesos, barras, etc)
    for _, part in pairs(workspace:GetChildren()) do
        -- Procurar em pastas de treino
        if part:IsA("Model") or part:IsA("Folder") then
            for _, child in pairs(part:GetDescendants()) do
                if child:IsA("BasePart") then
                    local name = child.Name:lower()
                    -- Detectar nomes comuns de pesos/equipamentos
                    if name:match("weight") or name:match("bar") or name:match("barbell") or 
                       name:match("dumbbell") or name:match("equipment") or name:match("bench") or
                       name:match("bar%d") or name:match("w%d") or child.Name:match("%d") then
                        
                        local distance = (child.Position - humanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestWeight = child
                        end
                    end
                end
            end
        end
    end
    
    return nearestWeight
end

-- Função para clicar em um objeto
local function clickObject(object)
    if not object then return end
    
    mouse.Target = object
    mouse.Hit = object.CFrame
    
    -- Simular clique
    local inputObject = {
        KeyCode = Enum.KeyCode.Unknown,
        UserInputType = Enum.UserInputType.MouseButton1,
    }
    
    UserInputService:FireEvent("InputBegan", inputObject)
    task.wait(0.001)
    UserInputService:FireEvent("InputEnded", inputObject)
end

-- Função alternativa: usar RemoteEvents se o jogo tiver
local function tryRemoteClick(object)
    if not object then return end
    
    -- Procurar por RemoteEvents no ReplicatedStorage ou ServerScriptService
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    for _, remote in pairs(replicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            -- Tentar chamar com o objeto clicado
            if remote:IsA("RemoteEvent") then
                pcall(function()
                    remote:FireServer(object)
                end)
            else
                pcall(function()
                    remote:InvokeServer(object)
                end)
            end
        end
    end
end

-- Função para auto-treino
local function autoTrain()
    if not isAutoClicking then return end
    
    local currentTime = tick()
    if currentTime - lastClickTime < CONFIG.ClickSpeed then
        return
    end
    
    lastClickTime = currentTime
    
    local nearestWeight = getNearestWeight()
    if nearestWeight then
        clickObject(nearestWeight)
        tryRemoteClick(nearestWeight)
    end
end

-- Função para criar UI de controle
local function createControlUI()
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MuscleLegendsFastTools"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 180)
    mainFrame.Position = UDim2.new(0, 15, 0, 70)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 100, 0)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "⚡ FAST TOOLS"
    titleLabel.BorderSizePixel = 0
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleLabel
    
    -- Botão Auto-Click
    local autoClickButton = Instance.new("TextButton")
    autoClickButton.Name = "AutoClickButton"
    autoClickButton.Size = UDim2.new(1, -10, 0, 35)
    autoClickButton.Position = UDim2.new(0, 5, 0, 35)
    autoClickButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
    autoClickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoClickButton.Font = Enum.Font.GothamBold
    autoClickButton.TextSize = 13
    autoClickButton.Text = "🖱️ AUTO-CLICK: OFF"
    autoClickButton.Parent = mainFrame
    
    local autoClickCorner = Instance.new("UICorner")
    autoClickCorner.CornerRadius = UDim.new(0, 8)
    autoClickCorner.Parent = autoClickButton
    
    autoClickButton.MouseButton1Click:Connect(function()
        isAutoClicking = not isAutoClicking
        if isAutoClicking then
            autoClickButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            autoClickButton.Text = "🖱️ AUTO-CLICK: ON"
        else
            autoClickButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
            autoClickButton.Text = "🖱️ AUTO-CLICK: OFF"
        end
    end)
    
    -- Botão Auto-Equip
    local autoEquipButton = Instance.new("TextButton")
    autoEquipButton.Name = "AutoEquipButton"
    autoEquipButton.Size = UDim2.new(1, -10, 0, 35)
    autoEquipButton.Position = UDim2.new(0, 5, 0, 75)
    autoEquipButton.BackgroundColor3 = Color3.fromRGB(150, 100, 150)
    autoEquipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoEquipButton.Font = Enum.Font.GothamBold
    autoEquipButton.TextSize = 13
    autoEquipButton.Text = "⚙️ AUTO-EQUIP: OFF"
    autoEquipButton.Parent = mainFrame
    
    local autoEquipCorner = Instance.new("UICorner")
    autoEquipCorner.CornerRadius = UDim.new(0, 8)
    autoEquipCorner.Parent = autoEquipButton
    
    autoEquipButton.MouseButton1Click:Connect(function()
        -- Lógica para auto-equipar melhores itens
        autoEquipBestItems()
    end)
    
    -- Label de instruções
    local instructionLabel = Instance.new("TextLabel")
    instructionLabel.Size = UDim2.new(1, -10, 0, 35)
    instructionLabel.Position = UDim2.new(0, 5, 0, 120)
    instructionLabel.BackgroundTransparency = 1
    instructionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    instructionLabel.TextSize = 10
    instructionLabel.Font = Enum.Font.Gotham
    instructionLabel.Text = "F2: Auto-Click\nF3: Teleporte\nF4: Auto-Equip"
    instructionLabel.TextXAlignment = Enum.TextXAlignment.Left
    instructionLabel.Parent = mainFrame
    
    return screenGui, autoClickButton, autoEquipButton
end

-- Função para auto-equipar
function autoEquipBestItems()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    -- Procurar por ferramentas/equipamentos no backpack
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") or tool:IsA("Accessory") then
            -- Equipar a ferramenta
            if tool:FindFirstChild("Handle") then
                tool.Parent = player.Character
            end
        end
    end
end

-- Função para teleportar
local function showTeleportMenu()
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Verificar se já existe um menu
    if playerGui:FindFirstChild("TeleportMenu") then
        playerGui.TeleportMenu:Destroy()
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TeleportMenu"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 200)
    frame.Position = UDim2.new(0.5, -100, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    -- Procurar spawns/rooms do mapa
    local workspace = game:GetService("Workspace")
    local spawns = {}
    
    for _, part in pairs(workspace:FindFirstChild("Spawns") and workspace.Spawns:GetChildren() or {}) do
        table.insert(spawns, {name = part.Name, position = part.Position})
    end
    
    if #spawns == 0 then
        for _, part in pairs(workspace:GetChildren()) do
            if part.Name:match("Gym") or part.Name:match("Room") or part.Name:match("Area") then
                table.insert(spawns, {name = part.Name, position = part.Position})
            end
        end
    end
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = frame
    
    -- Criar botões de teleporte
    for i, spawn in ipairs(spawns) do
        if i > 5 then break end -- Limitar a 5 opções
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 30)
        button.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 35)
        button.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 12
        button.Text = spawn.name
        button.Parent = frame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(spawn.position + Vector3.new(0, 3, 0))
            end
            screenGui:Destroy()
        end)
    end
end

-- Eventos de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == CONFIG.ToggleKey then
        isAutoClicking = not isAutoClicking
    elseif input.KeyCode == CONFIG.TeleportKey then
        showTeleportMenu()
    elseif input.KeyCode == CONFIG.AutoEquipKey then
        autoEquipBestItems()
    end
end)

-- Reconectar ao respawnar
player.CharacterAdded:Connect(function(newCharacter)
    print("✅ Novo personagem detectado!")
end)

-- Loop de atualização
RunService.RenderStepped:Connect(function()
    autoTrain()
end)

-- Criar UI
print("⚡ Muscle Legends Fast Tools ativado!")
print("F2: Alternar Auto-Click")
print("F3: Menu de Teleporte")
print("F4: Auto-Equip")

createControlUI()
