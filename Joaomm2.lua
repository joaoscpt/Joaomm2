-- Joao mm2 V3 FIX ESP + SMART SHOT
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Window = Rayfield:CreateWindow({
   Name = "Joao mm2",
   LoadingTitle = "Joao mm2",
   LoadingSubtitle = "Fix ESP e Tiro",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local FarmTab = Window:CreateTab("Farm", 4483362458)
local CombatTab = Window:CreateTab("Combate", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)

local LP = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Speed = 30
local AutoCoin = false
local ESPOn = false
local Bringing = false

local function GetRole(p)
    if not p.Character then return "Innocent" end
    -- no MM2 no celular só da pra ver na Character, Backpack dos outros não aparece
    if p.Character:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Character:FindFirstChild("Revolver") then return "Sheriff" end
    -- se ainda não sacou a arma, tenta ver na backpack se for você mesmo
    if p == LP then
        if p.Backpack:FindFirstChild("Knife") then return "Murderer" end
        if p.Backpack:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Revolver") then return "Sheriff" end
    end
    return "Innocent"
end

-- Noclip pra não bugar na parede
task.spawn(function()
    while task.wait() do
        if AutoCoin or Bringing then
            pcall(function()
                for _,v in pairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
                end
            end)
        end
    end
end)

local function TweenTo(pos, altura)
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    local dist = (HRP.Position - pos).Magnitude
    local tempo = dist / Speed
    if tempo < 0.2 then tempo = 0.2 end
    local tw = TweenService:Create(HRP, TweenInfo.new(tempo, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos + Vector3.new(0, altura or 3, 0))})
    tw:Play() tw.Completed:Wait()
end

-- FARM
FarmTab:CreateInput({
   Name = "Velocidade",
   PlaceholderText = "25, 50, 100",
   RemoveTextAfterFocusLost = false,
   Callback = function(txt) local n=tonumber(txt) if n then Speed=n end end,
})

FarmTab:CreateToggle({
   Name = "Auto Coletar Moeda",
   CurrentValue = false,
   Flag = "AC",
   Callback = function(v) AutoCoin=v end,
})

task.spawn(function()
    while task.wait(0.3) do
        if AutoCoin then
            pcall(function()
                local CC = workspace:FindFirstChild("CoinContainer", true)
                if not CC then return end
                for _,coin in pairs(CC:GetChildren()) do
                    if not AutoCoin then break end
                    if coin.Name=="Coin_Server" and coin.Parent then
                        TweenTo(coin.Position, 4)
                        task.wait(0.1)
                    end
                end
            end)
        end
    end
end)

-- ESP SÓ "ESP"
ESPTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(v)
       ESPOn=v
       if not v then
           for _,p in pairs(Players:GetPlayers()) do
               if p.Character and p.Character:FindFirstChild("JoaoESP") then p.Character.JoaoESP:Destroy() end
           end
       end
   end,
})

task.spawn(function()
    while task.wait(0.5) do
        if ESPOn then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local role = GetRole(p)
                    local hl = p.Character:FindFirstChild("JoaoESP")
                    if not hl then
                        hl = Instance.new("Highlight", p.Character)
                        hl.Name = "JoaoESP"
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.FillTransparency = 0.5
                        hl.OutlineTransparency = 0
                    end
                    if role=="Innocent" then hl.FillColor=Color3.fromRGB(0,255,0)
                    elseif role=="Sheriff" then hl.FillColor=Color3.fromRGB(0,120,255)
                    else hl.FillColor=Color3.fromRGB(255,0,0) end
                end
            end
        end
    end
end)

-- COMBATE
local SmartGui
local function CreateSmartButton()
    if SmartGui then SmartGui:Destroy() end
    local UI = gethui and gethui() or LP.PlayerGui
    SmartGui = Instance.new("ScreenGui", UI) SmartGui.Name="SmartShot"
    local Btn = Instance.new("TextButton", SmartGui)
    Btn.Size=UDim2.new(0,75,0,75) Btn.Position=UDim2.new(0.8,0,0.5,0)
    Btn.Text="TIRO" Btn.TextScaled=true Btn.BackgroundColor3=Color3.fromRGB(255,0,0)
    Btn.TextColor3=Color3.new(1,1,1) Btn.Active=true Btn.Draggable=true
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function()
        pcall(function()
            local char = LP.Character
            if not char then return end
            local gun = char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
            if not gun then LP.Character.Humanoid:EquipTool(LP.Backpack:FindFirstChild("Gun") or LP.Backpack:FindFirstChild("Revolver")) task.wait(0.2) gun = char:FindFirstChild("Gun") or char:FindFirstChild("Revolver") end
            if not gun then return end
            local murder = nil
            for _,pl in pairs(Players:GetPlayers()) do
                if GetRole(pl)=="Murderer" and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then murder=pl break end
            end
            if not murder then return end
            local target = murder.Character.HumanoidRootPart.Position
            -- atira de verdade pelo remote
            for _,r in pairs(game.ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("shoot") or r.Name:lower():find("fire") or r.Name:lower():find("gun")) then
                    pcall(function() r:FireServer(target) end)
                    pcall(function() r:FireServer(murder.Character.HumanoidRootPart) end)
                    pcall(function() r:FireServer(target, target) end)
                end
            end
            gun:Activate()
        end)
    end)
end

CombatTab:CreateToggle({
   Name = "Tiro Inteligente",
   CurrentValue = false,
   Flag = "Smart",
   Callback = function(v)
       if v then CreateSmartButton() else if SmartGui then SmartGui:Destroy() end end
   end,
})

CombatTab:CreateButton({
   Name = "Tween Arma e Volta",
   Callback = function()
       task.spawn(function()
           local HRP = LP.Character.HumanoidRootPart
           local Old = HRP.CFrame
           Bringing = true
           for _,o in pairs(workspace:GetDescendants()) do
               if o.Name=="GunDrop" and o:IsA("BasePart") then
                   TweenTo(o.Position, 2)
                   task.wait(0.3)
                   TweenTo(Old.Position, 2)
                   break
               end
           end
           Bringing = false
       end)
   end,
})
