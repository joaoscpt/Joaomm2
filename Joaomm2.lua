-- Joao mm2 V7 - FIX VOID + FIX KICK
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Window = Rayfield:CreateWindow({
   Name = "Joao mm2",
   LoadingTitle = "Joao mm2 V7",
   LoadingSubtitle = "Fling + Coin sem kick",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local FarmTab = Window:CreateTab("Farm", 4483362458)
local CombatTab = Window:CreateTab("Combate", 4483362458)
local OpsTab = Window:CreateTab("Ops", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)

local LP = game.Players.LocalPlayer
local Players = game:GetService("Players")

local Speed = 35
local AutoCoin = false
local ESPOn = false

local function GetRole(p)
    if not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife", true) or p:FindFirstChild("Knife", true) then return "Murderer" end
    if p.Character:FindFirstChild("Gun", true) or p.Character:FindFirstChild("Revolver", true) or p:FindFirstChild("Gun", true) then return "Sheriff" end
    return "Innocent"
end

local function GetSortedCoins()
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return {} end
    local CC = workspace:FindFirstChild("CoinContainer", true)
    if not CC then return {} end
    local list = {}
    for _,coin in pairs(CC:GetChildren()) do
        if coin.Name=="Coin_Server" and coin:IsA("BasePart") and coin.Parent and coin.Position.Y > -15 then
            local d = (HRP.Position - coin.Position).Magnitude
            if d < 300 then table.insert(list, {c=coin, dist=d}) end
        end
    end
    table.sort(list, function(a,b) return a.dist < b.dist end)
    return list
end

-- FARM - AGORA PUXA A MOEDA PRA VOCÊ, SEM TP, SEM KICK
FarmTab:CreateInput({ Name="Velocidade", PlaceholderText="0.1 rapido 0.2 normal", RemoveTextAfterFocusLost=false, Callback=function(txt) local n=tonumber(txt) if n then Speed=n end end, })
FarmTab:CreateToggle({ Name="Auto Coletar Moeda", CurrentValue=false, Flag="AC", Callback=function(v) AutoCoin=v end, })

task.spawn(function()
    while task.wait(0.12) do
        if AutoCoin then
            pcall(function()
                local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not HRP then return end
                local coins = GetSortedCoins()
                for _,data in ipairs(coins) do
                    if not AutoCoin then break end
                    local coin = data.c
                    if coin and coin.Parent then
                        -- PUXA A MOEDA PRA DENTRO DE VOCÊ, NÃO VOCÊ PRA MOEDA
                        coin.CFrame = HRP.CFrame
                        task.wait(Speed or 0.12)
                    end
                end
            end)
        end
    end
end)

-- ESP
ESPTab:CreateToggle({ Name="ESP", CurrentValue=false, Flag="ESP", Callback=function(v) ESPOn=v if not v then for _,p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("JoaoESP") then p.Character.JoaoESP:Destroy() end end end end, })
task.spawn(function()
    while task.wait(0.5) do
        if ESPOn then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local role=GetRole(p)
                    local hl=p.Character:FindFirstChild("JoaoESP")
                    if not hl then hl=Instance.new("Highlight",p.Character) hl.Name="JoaoESP" hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop hl.FillTransparency=0.5 hl.OutlineTransparency=0 end
                    if role=="Innocent" then hl.FillColor=Color3.fromRGB(0,255,0) elseif role=="Sheriff" then hl.FillColor=Color3.fromRGB(0,120,255) else hl.FillColor=Color3.fromRGB(255,0,0) end
                end
            end
        end
    end
end)

-- OPS - FLING NOVO QUE NÃO TE JOGA PRO VOID
local function FlingTarget(target)
    if not target or not target.Character then return end
    local THRP = target.Character:FindFirstChild("HumanoidRootPart")
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not THRP or not HRP then return end
    local Old = HRP.CFrame
    -- chega perto pra pegar posse
    HRP.CFrame = THRP.CFrame * CFrame.new(0,0,2)
    task.wait(0.2)
    for i=1,12 do
        pcall(function()
            THRP.AssemblyLinearVelocity = Vector3.new(0, 9000, 0)
            THRP.AssemblyAngularVelocity = Vector3.new(9999, 9999)
            THRP.Velocity = Vector3.new(0, 9000, 0)
        end)
        task.wait(0.07)
    end
    HRP.CFrame = Old
    HRP.Velocity = Vector3.new(0,0,0)
    HRP.AssemblyLinearVelocity = Vector3.new(0,0,0)
end

OpsTab:CreateButton({ Name="Fling Xerife", Callback=function() for _,p in pairs(Players:GetPlayers()) do if GetRole(p)=="Sheriff" then FlingTarget(p) break end end end, })
OpsTab:CreateButton({ Name="Fling Assassino", Callback=function() for _,p in pairs(Players:GetPlayers()) do if GetRole(p)=="Murderer" then FlingTarget(p) break end end end, })

-- COMBATE
local SmartGui
local function CreateSmartButton()
    if SmartGui then SmartGui:Destroy() end
    local UI = gethui and gethui() or LP.PlayerGui
    SmartGui = Instance.new("ScreenGui", UI) SmartGui.Name="SmartShot"
    local Btn = Instance.new("TextButton", SmartGui) Btn.Size=UDim2.new(0,75,0,75) Btn.Position=UDim2.new(0.8,0,0.5,0) Btn.Text="TIRO" Btn.TextScaled=true Btn.BackgroundColor3=Color3.fromRGB(255,0,0) Btn.TextColor3=Color3.new(1,1,1) Btn.Active=true Btn.Draggable=true Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function()
        pcall(function()
            local char=LP.Character
            local gun=char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
            if not gun then char.Humanoid:EquipTool(LP.Backpack:FindFirstChild("Gun") or LP.Backpack:FindFirstChild("Revolver")) task.wait(0.2) gun=char:FindFirstChild("Gun") or char:FindFirstChild("Revolver") end
            if not gun then return end
            local murder=nil for _,pl in pairs(Players:GetPlayers()) do if GetRole(pl)=="Murderer" and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then murder=pl break end end
            if not murder then return end
            local target=murder.Character.HumanoidRootPart.Position
            for _,r in pairs(game.ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and r.Name:lower()=="shoot" then pcall(function() r:FireServer(target) end) end end
            gun:Activate()
        end)
    end)
end

CombatTab:CreateToggle({ Name="Tiro Inteligente", CurrentValue=false, Flag="Smart", Callback=function(v) if v then CreateSmartButton() else if SmartGui then SmartGui:Destroy() end end end, })
CombatTab:CreateButton({ Name="Tween Arma e Volta", Callback=function() task.spawn(function() local HRP=LP.Character.HumanoidRootPart local Old=HRP.CFrame for _,o in pairs(workspace:GetDescendants()) do if o.Name=="GunDrop" and o:IsA("BasePart") then o.CFrame=HRP.CFrame task.wait(0.2) break end end end) end, })
CombatTab:CreateButton({ Name="Matar Todos [Assassino]", Callback=function() if GetRole(LP)~="Murderer" then return end local knife=LP.Character:FindFirstChild("Knife") or LP.Backpack:FindFirstChild("Knife") if knife then LP.Character.Humanoid:EquipTool(knife) end for _,p in pairs(Players:GetPlayers()) do if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame=LP.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,-2) task.wait(0.2) end end end, })
