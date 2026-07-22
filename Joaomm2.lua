-- Joao mm2 V5 - Fix Fling + TP seguro
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Window = Rayfield:CreateWindow({
   Name = "Joao mm2",
   LoadingTitle = "Joao mm2 V5",
   LoadingSubtitle = "Fling fix + TP seguro",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local FarmTab = Window:CreateTab("Farm", 4483362458)
local CombatTab = Window:CreateTab("Combate", 4483362458)
local OpsTab = Window:CreateTab("Ops", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)

local LP = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Speed = 35
local AutoCoin = false
local ESPOn = false
local Bringing = false

local function GetRole(p)
    if not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Character:FindFirstChild("Revolver") then return "Sheriff" end
    if p==LP then
        if p.Backpack:FindFirstChild("Knife") then return "Murderer" end
        if p.Backpack:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Revolver") then return "Sheriff" end
    end
    return "Innocent"
end

task.spawn(function()
    while task.wait() do
        if AutoCoin or Bringing then
            pcall(function()
                for _,v in pairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then v.CanCollide=false end
                end
            end)
        end
    end
end)

local function TweenTo(pos, altura, tempoMax)
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not HRP or not pos or pos.Y < -30 then return end
    local dist = (HRP.Position - pos).Magnitude
    local tempo = dist / Speed
    if tempo < 0.15 then tempo = 0.15 end
    if tempoMax and tempo > tempoMax then tempo = tempoMax end
    local tw = TweenService:Create(HRP, TweenInfo.new(tempo, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos + Vector3.new(0, altura or 3, 0))})
    tw:Play() tw.Completed:Wait()
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

-- FARM
FarmTab:CreateInput({ Name="Velocidade", PlaceholderText="35 ideal", RemoveTextAfterFocusLost=false, Callback=function(txt) local n=tonumber(txt) if n then Speed=n end end, })
FarmTab:CreateToggle({ Name="Auto Coletar Moeda", CurrentValue=false, Flag="AC", Callback=function(v) AutoCoin=v end, })

task.spawn(function()
    while task.wait(0.15) do
        if AutoCoin then
            pcall(function()
                local coins = GetSortedCoins()
                for _,data in ipairs(coins) do
                    if not AutoCoin then break end
                    local coin = data.c
                    if not coin or not coin.Parent then continue end
                    local HRP = LP.Character.HumanoidRootPart
                    local dist = (HRP.Position - coin.Position).Magnitude
                    if dist > 10 then
                        -- vai de tween até perto
                        TweenTo(coin.Position, 4, 2)
                    else
                        -- chegou no stud seguro, da TP direto pra coletar sem kick
                        HRP.CFrame = coin.CFrame
                        task.wait(0.05)
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

-- OPS FLING FIX - flinga o alvo não você
local function FlingTarget(target)
    if not target or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    Bringing=true
    local HRP = LP.Character.HumanoidRootPart
    local THRP = target.Character.HumanoidRootPart
    local Old = HRP.CFrame
    -- gira forte
    local bv = Instance.new("BodyAngularVelocity")
    bv.AngularVelocity = Vector3.new(0, 9999, 0)
    bv.MaxTorque = Vector3.new(0, 9999, 0)
    bv.P = 9999
    bv.Parent = HRP
    -- cola no alvo e flinga o alvo
    for i=1,12 do
        HRP.CFrame = THRP.CFrame * CFrame.new(0,0,0.6)
        THRP.AssemblyAngularVelocity = Vector3.new(0, 10000, 0)
        THRP.AssemblyLinearVelocity = Vector3.new(0, 9000, 0) + Vector3.new(math.random(-20,20),0,math.random(-20,20))
        task.wait(0.06)
    end
    bv:Destroy()
    HRP.Velocity = Vector3.new(0,0,0)
    HRP.RotVelocity = Vector3.new(0,0,0)
    HRP.CFrame = Old
    Bringing=false
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
            local char=LP.Character local gun=char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
            if not gun then char.Humanoid:EquipTool(LP.Backpack:FindFirstChild("Gun") or LP.Backpack:FindFirstChild("Revolver")) task.wait(0.2) gun=char:FindFirstChild("Gun") or char:FindFirstChild("Revolver") end
            if not gun then return end
            local murder=nil for _,pl in pairs(Players:GetPlayers()) do if GetRole(pl)=="Murderer" and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then murder=pl break end end
            if not murder then return end
            for _,r in pairs(game.ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and r.Name:lower():find("shoot") then pcall(function() r:FireServer(murder.Character.HumanoidRootPart.Position) end) end end
            gun:Activate()
        end)
    end)
end

CombatTab:CreateToggle({ Name="Tiro Inteligente", CurrentValue=false, Flag="Smart", Callback=function(v) if v then CreateSmartButton() else if SmartGui then SmartGui:Destroy() end end end, })
CombatTab:CreateButton({ Name="Tween Arma e Volta", Callback=function() task.spawn(function() local HRP=LP.Character.HumanoidRootPart local Old=HRP.CFrame Bringing=true for _,o in pairs(workspace:GetDescendants()) do if o.Name=="GunDrop" and o:IsA("BasePart") then TweenTo(o.Position,2,2) task.wait(0.2) HRP.CFrame=Old break end end Bringing=false end) end, })
CombatTab:CreateButton({ Name="Matar Todos [Assassino]", Callback=function() if GetRole(LP)~="Murderer" then return end Bringing=true local knife=LP.Character:FindFirstChild("Knife") or LP.Backpack:FindFirstChild("Knife") if knife then LP.Character.Humanoid:EquipTool(knife) end for _,p in pairs(Players:GetPlayers()) do if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame=LP.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,-2) task.wait(0.2) end end Bringing=false end, })
