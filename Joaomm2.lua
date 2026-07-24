-- LocalScript para Muscle Legends - Dashboard de Stats
-- Cole em StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configurações
local CONFIG = {
    UpdateInterval = 0.5,
    ToggleKey = Enum.KeyCode.F1, -- Pressionar F1 para mostrar/esconder
    ShowOnStart = true,
    AutoFarmEnabled = false,
}

-- Variáveis de controle
local isDashboardVisible = CONFIG.ShowOnStart
local isAutoFarming = CONFIG.AutoFarmEnabled
local lastUpdate = 0
local playerStats = {
    Level = 0,
    Strength = 0,
    Money = 0,
    Experience = 0,
    MaxHealth = 0,
}

-- Função para obter stats do jogador
local function getPlayerStats()
    local stats = {
        Level = 0,
        Strength = 0,
        Money = 0,
        Experience = 0,
        MaxHealth = humanoid.MaxHealth or 100,
    }
    
    -- Procurar valores/stats no personagem ou backpack
    if character:FindFirstChild("Stats") then
        local statsFolder = character.Stats
        if statsFolder:FindFirstChild("Level") then
            stats.Level = statsFolder.Level.Value
        end
        if statsFolder:FindFirstChild("Strength") then
            stats.Strength = statsFolder.Strength.Value
        end
        if statsFolder:FindFirstChild("Experience") then
            stats.Experience = statsFolder.Experience.Value
        end
    end
    
    -- Procurar moeda
    if player:FindFirstChild("leaderstats") then
        local leaderstats = player.leaderstats
        if leaderstats:FindFirstChild("Money") then
            stats.Money = leaderstats.Money.Value
        end
        if leaderstats:FindFirstChild("Level") then
            stats.Level = leaderstats.Level.Value
        end
    end
    
    return stats
end

-- Função para criar o Dashboard
local function createDashboard()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MuscleLegendsDashboard"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal (redondeado)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0, 15, 0, 15)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Adicionar cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Adicionar stroke/borda
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 200, 255)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Cabeçalho
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Size = UDim2.new(1, 0, 0, 50)
    headerFrame.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = headerFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "💪 MUSCLE LEGENDS"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerFrame
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.Text = "✕"
    closeButton.Parent = headerFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        isDashboardVisible = false
    end)
    
    -- Container de stats
    local statsContainer = Instance.new("Frame")
    statsContainer.Name = "StatsContainer"
    statsContainer.Size = UDim2.new(1, -20, 1, -70)
    statsContainer.Position = UDim2.new(0, 10, 0, 55)
    statsContainer.BackgroundTransparency = 1
    statsContainer.Parent = mainFrame
    
    -- UIListLayout para organizar stats
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = statsContainer
    
    -- Função para criar um stat item
    local function createStatItem(name, value, layoutOrder)
        local statFrame = Instance.new("Frame")
        statFrame.Name = name .. "Frame"
        statFrame.Size = UDim2.new(1, 0, 0, 50)
        statFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        statFrame.BorderSizePixel = 0
        statFrame.LayoutOrder = layoutOrder
        statFrame.Parent = statsContainer
        
        local statCorner = Instance.new("UICorner")
        statCorner.CornerRadius = UDim.new(0, 8)
        statCorner.Parent = statFrame
        
        -- Nome do stat
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(0, 150, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Text = name
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = statFrame
        
        -- Valor do stat
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "ValueLabel"
        valueLabel.Size = UDim2.new(0, 150, 1, 0)
        valueLabel.Position = UDim2.new(1, -155, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        valueLabel.TextSize = 16
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Text = tostring(value)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = statFrame
        
        return valueLabel
    end
    
    -- Criar items de stats
    local levelLabel = createStatItem("📊 Level", playerStats.Level, 1)
    local strengthLabel = createStatItem("💪 Força", playerStats.Strength, 2)
    local moneyLabel = createStatItem("💵 Moeda", playerStats.Money, 3)
    local healthLabel = createStatItem("❤️ Saúde", humanoid.Health, 4)
    
    -- Frame inferior com botões
    local bottomFrame = Instance.new("Frame")
    bottomFrame.Name = "BottomFrame"
    bottomFrame.Size = UDim2.new(1, 0, 0, 45)
    bottomFrame.Position = UDim2.new(0, 0, 1, -45)
    bottomFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    bottomFrame.BorderSizePixel = 0
    bottomFrame.Parent = mainFrame
    
    local bottomCorner = Instance.new("UICorner")
    bottomCorner.CornerRadius = UDim.new(0, 12)
    bottomCorner.Parent = bottomFrame
    
    -- Botão de Auto-Farm
    local farmButton = Instance.new("TextButton")
    farmButton.Name = "FarmButton"
    farmButton.Size = UDim2.new(1, -10, 0, 35)
    farmButton.Position = UDim2.new(0, 5, 0, 5)
    farmButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    farmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmButton.Font = Enum.Font.GothamBold
    farmButton.TextSize = 14
    farmButton.Text = "🤖 Auto-Farm: OFF"
    farmButton.Parent = bottomFrame
    
    local farmCorner = Instance.new("UICorner")
    farmCorner.CornerRadius = UDim.new(0, 8)
    farmCorner.Parent = farmButton
    
    farmButton.MouseButton1Click:Connect(function()
        isAutoFarming = not isAutoFarming
        if isAutoFarming then
            farmButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            farmButton.Text = "🤖 Auto-Farm: ON"
        else
            farmButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            farmButton.Text = "🤖 Auto-Farm: OFF"
        end
    end)
    
    return screenGui, {
        LevelLabel = levelLabel,
        StrengthLabel = strengthLabel,
        MoneyLabel = moneyLabel,
        HealthLabel = healthLabel,
        MainFrame = mainFrame,
        FarmButton = farmButton
    }
end

-- Função para atualizar dashboard
local function updateDashboard(dashboardLabels)
    playerStats = getPlayerStats()
    
    if dashboardLabels.LevelLabel then
        dashboardLabels.LevelLabel.Text = tostring(playerStats.Level)
    end
    if dashboardLabels.StrengthLabel then
        dashboardLabels.StrengthLabel.Text = string.format("%.0f", playerStats.Strength)
    end
    if dashboardLabels.MoneyLabel then
        dashboardLabels.MoneyLabel.Text = string.format("%,d", math.floor(playerStats.Money))
    end
    if dashboardLabels.HealthLabel then
        dashboardLabels.HealthLabel.Text = string.format("%.0f/%.0f", humanoid.Health, humanoid.MaxHealth)
    end
end

-- Função para auto-farm (simples)
local function autoFarm()
    if not isAutoFarming or not character or not humanoid or humanoid.Health <= 0 then
        return
    end
    
    -- Procurar NPCs ou equipamentos para treinar
    local workspace = game:GetService("Workspace")
    
    -- Aqui você pode adicionar lógica customizada do jogo
    -- Por exemplo: clicar em equipamentos, interagir com NPCs, etc
end

-- Inicializar
print("✅ Muscle Legends Dashboard iniciado!")
print("Pressione F1 para mostrar/esconder o dashboard")

local screenGui, dashboardLabels = createDashboard()

-- Conectar eventos de input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == CONFIG.ToggleKey then
        isDashboardVisible = not isDashboardVisible
        dashboardLabels.MainFrame.Visible = isDashboardVisible
    end
end)

-- Conectar atualização de personagem
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    print("Novo personagem detectado!")
end)

-- Loop de atualização
RunService.RenderStepped:Connect(function()
    local currentTime = tick()
    
    if currentTime - lastUpdate < CONFIG.UpdateInterval then
        return
    end
    
    lastUpdate = currentTime
    
    if isDashboardVisible then
        updateDashboard(dashboardLabels)
    end
    
    autoFarm()
end)
