-- LocalScript para Murder Mystery 2 - Detector de Papéis
-- Cole este script em StarterPlayer > StarterCharacterScripts ou StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Configurações
local CONFIG = {
    UpdateInterval = 0.5, -- Atualiza a cada 0.5 segundos
    ShowNotifications = true,
    NotificationDuration = 3,
}

-- Variáveis globais
local myRole = "unknown"
local lastUpdate = 0
local roleChanged = false

-- Função para detectar o papel do jogador
local function detectMyRole()
    local newRole = "unknown"
    
    -- Método 1: Verificar objetos/valores no personagem
    if character:FindFirstChild("Knife") then
        newRole = "Murderer"
    elseif character:FindFirstChild("Gun") then
        newRole = "Sheriff"
    else
        newRole = "Innocent"
    end
    
    -- Método 2: Verificar tags do HumaoidRootPart
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local roleTag = humanoidRootPart:FindFirstChild("Role")
        if roleTag and roleTag:IsA("StringValue") then
            newRole = roleTag.Value
        end
    end
    
    -- Verificar se o papel mudou
    if newRole ~= myRole then
        roleChanged = true
        myRole = newRole
        return true
    end
    
    return false
end

-- Função para detectar papéis de outros jogadores
local function detectOtherRoles()
    local roles = {}
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local otherRole = "Unknown"
            
            -- Verificar armas
            if otherChar:FindFirstChild("Knife") then
                otherRole = "Murderer"
            elseif otherChar:FindFirstChild("Gun") then
                otherRole = "Sheriff"
            else
                otherRole = "Innocent"
            end
            
            roles[otherPlayer.Name] = otherRole
        end
    end
    
    return roles
end

-- Função para exibir notificação
local function showNotification(title, text, duration)
    duration = duration or CONFIG.NotificationDuration
    
    if CONFIG.ShowNotifications then
        -- Se há o serviço de notificações (algumas versões do Roblox)
        local success, err = pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = duration,
            })
        end)
    end
end

-- Função para criar interface de papéis
local function createRoleUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RoleDetectorUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 150)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Adicionar canto arredondado (UICorner)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "MM2 - Detector de Papéis"
    titleLabel.Parent = mainFrame
    
    -- Label do meu papel
    local myRoleLabel = Instance.new("TextLabel")
    myRoleLabel.Name = "MyRoleLabel"
    myRoleLabel.Size = UDim2.new(1, -10, 0, 35)
    myRoleLabel.Position = UDim2.new(0, 5, 0, 35)
    myRoleLabel.BackgroundTransparency = 1
    myRoleLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    myRoleLabel.TextScaled = true
    myRoleLabel.Font = Enum.Font.Gotham
    myRoleLabel.Text = "Seu papel: Aguardando..."
    myRoleLabel.Parent = mainFrame
    
    -- Label de outros papéis
    local othersLabel = Instance.new("TextLabel")
    othersLabel.Name = "OthersLabel"
    othersLabel.Size = UDim2.new(1, -10, 0, 35)
    othersLabel.Position = UDim2.new(0, 5, 0, 75)
    othersLabel.BackgroundTransparency = 1
    othersLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    othersLabel.TextScaled = true
    othersLabel.Font = Enum.Font.Gotham
    othersLabel.TextSize = 12
    othersLabel.Text = "Jogadores: Detectando..."
    othersLabel.Parent = mainFrame
    
    return screenGui, myRoleLabel, othersLabel
end

-- Função principal de update
local function update()
    local currentTime = tick()
    
    if currentTime - lastUpdate < CONFIG.UpdateInterval then
        return
    end
    
    lastUpdate = currentTime
    
    -- Detectar meu papel
    if detectMyRole() then
        print("Papel alterado para: " .. myRole)
        showNotification("MM2 Detector", "Seu papel: " .. myRole, 2)
    end
    
    -- Detectar papéis dos outros
    local otherRoles = detectOtherRoles()
    
    -- Atualizar UI se existir
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        local roleUI = playerGui:FindFirstChild("RoleDetectorUI")
        if roleUI then
            local myRoleLabel = roleUI.MainFrame:FindFirstChild("MyRoleLabel")
            local othersLabel = roleUI.MainFrame:FindFirstChild("OthersLabel")
            
            if myRoleLabel then
                -- Colorir baseado no papel
                if myRole == "Murderer" then
                    myRoleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    myRoleLabel.Text = "🔪 Seu papel: ASSASSINO"
                elseif myRole == "Sheriff" then
                    myRoleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
                    myRoleLabel.Text = "🔫 Seu papel: XERIFE"
                else
                    myRoleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    myRoleLabel.Text = "👤 Seu papel: INOCENTE"
                end
            end
            
            if othersLabel then
                local roleText = "Papéis dos outros:\n"
                local count = 0
                for playerName, role in pairs(otherRoles) do
                    if count < 3 then -- Mostrar apenas 3 primeiros
                        roleText = roleText .. playerName .. ": " .. role .. "\n"
                        count = count + 1
                    end
                end
                
                if count == 0 then
                    roleText = "Nenhum outro jogador detectado"
                end
                
                othersLabel.Text = roleText
            end
        end
    end
end

-- Função para monitorar mudanças de personagem
local function onCharacterRespawned(newCharacter)
    character = newCharacter
    myRole = "unknown"
    roleChanged = true
    print("Personagem respawned, detectando novo papel...")
end

-- Inicialização
print("MM2 Role Detector iniciado!")
print("Seu papel atual: " .. myRole)

-- Criar UI
local screenGui, myRoleLabel, othersLabel = createRoleUI()

-- Conectar eventos
if player.Character then
    player.CharacterAdded:Connect(onCharacterRespawned)
end

-- Loop de atualização
RunService.RenderStepped:Connect(update)

-- Notificação de script carregado
showNotification("MM2 Detector", "Script de detecção de papéis ativado!", 2)
