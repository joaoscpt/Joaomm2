-- Joao mm2 V2 FIX
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Window = Rayfield:CreateWindow({
   Name = "Joao mm2",
   LoadingTitle = "Joao mm2 V2",
   LoadingSubtitle = "Fix paredes + Smart Shot",
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
local SmartOn = false
local Bringing = false

local function GetRole(p)
    if not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Revolver") or p.Backpack:FindFirstChild("Revolver") then return "Sheriff" end
    return "Innocent"
end

-- ANTI-PAREDE / NOCLIP
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

local function TweenTo(pos, voltaAltura)
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local HRP = char.HumanoidRootPart
    local dist = (HRP.Position - pos).Magnitude
    local tempo = dist / Speed
    if tempo < 0.2 then tempo = 0.2 end
    -- sobe um pouco pra não bugar na parede
    local target = CFrame.new(pos + Vector3.new(0, voltaAltura or 3, 0))
    local tw = TweenService:Create(HRP, TweenInfo.new(tempo, Enum.EasingStyle.Linear), {CFrame = target})
    tw:Play()
    tw.Completed:Wait()
end

-- FARM
FarmTab:CreateInput({
   Name = "Velocidade Tween",
   PlaceholderText = "25 lento, 50 rapido, 100 turbo",
   RemoveTextAfterFocusLost = false,
   Callback = function(txt) local n=tonumber(txt) if n then Speed=n end end,
})

FarmTab:CreateToggle({
   Name = "Auto Coletar Moeda [Tween Fix Parede]",
   CurrentValue = false,
   Flag = "ACoin",
   Callback = function(v) AutoCoin = v end,
})

FarmTab:CreateToggle({
   Name = "Tween Arma e Volta",
   CurrentValue = false,
   Flag = "TweenGun",
   Callback = function(v)
       if not v then return end
       task.spawn(function()
           pcall(function()
               local HRP = LP.Character.HumanoidRootPart
               local OldPos = HRP.CFrame
               Bringing = true
               for _,obj in pairs(workspace:GetDescendants()) do
                   if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                       TweenTo(obj.Position, 2)
                       task.wait(0.4)
                       -- volta pra posição antiga
                       TweenTo(OldPos.Position, 2)
                       break
                   end
               end
               Bringing = false
           end)
       end)
   end,
})

task.spawn(function()
    while task.wait(0.3) do
        if AutoCoin then
            pcall(function()
                local CC = workspace:FindFirstChild("CoinContainer", true)
                if not CC then return end
                for _,coin in pairs(CC:GetChildren()) do
                    if not AutoCoin then break end
                    if coin.Name == "Coin_Server" and coin:IsA("BasePart") and coin.Parent then
                        TweenTo(coin.Position, 4)
                        task.wait(0.1)
                    end
                end
            end)
        end
    end
end)

-- ESP
ESPTab:CreateToggle({
   Name = "ESP Colorido",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(v)
       ESPOn=v
       if not v then for _,p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("JoaoESP") then p.Character.JoaoESP:Destroy() end end end
   end,
})
task.spawn(function()
    while task.wait(0.8) do
        if ESPOn then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LP and p.Character and not p.Character:FindFirstChild("JoaoESP") then
                    local r=GetRole(p) local hl=Instance.new("Highlight",p.Character) hl.Name="JoaoESP" hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop hl.FillTransparency=0.6
                    if r=="Innocent" then hl.FillColor=Color3.fromRGB(0,255,0) elseif r=="Sheriff" then hl.FillColor=Color3.fromRGB(0,120,255) else hl.FillColor=Color3.fromRGB(255,0,0) end
                end
            end
        end
    end
end)

-- COMBATE - TIRO INTELIGENTE
local SmartGui
local function CreateSmartButton()
    if SmartGui then SmartGui:Destroy() end
    local UI = gethui and gethui() or LP.PlayerGui
    SmartGui = Instance.new("ScreenGui", UI) SmartGui.Name="SmartShot"
    local Btn = Instance.new("TextButton", SmartGui) Btn.Size=UDim2.new(0,75,0,75) Btn.Position=UDim2.new(0.8,0,0.6,0) Btn.Text="TIRO" Btn.TextScaled=true Btn.BackgroundColor3=Color3.fromRGB(255,0,0) Btn.TextColor3=Color3.new(1,1,1) Btn.Active=true Btn.Draggable=true Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function()
        pcall(function()
            local char = LP.Character
            if not char then return end
            local gun = char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
            if not gun then return end
            if GetRole(LP) ~= "Sheriff" then return end
            local murder = nil
            for _,p in pairs(Players:GetPlayers()) do if GetRole(p)=="Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then murder=p break end end
            if not murder then return end
            -- verifica se tá visível
            local origin = char.HumanoidRootPart.Position
            local targetPos = murder.Character.HumanoidRootPart.Position
            local params = RaycastParams.new() params.FilterDescendantsInstances={char} params.FilterType=Enum.RaycastFilterType.Blacklist
            local ray = workspace:Raycast(origin, targetPos-origin, params)
            if ray and ray.Instance and not ray.Instance:IsDescendantOf(murder.Character) then return end
            -- mira e atira
            char.HumanoidRootPart.CFrame = CFrame.lookAt(origin, targetPos)
            task.wait(0.06)
            gun:Activate()
            -- tenta remote também pra garantir
            for _,r in pairs(game.ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and r.Name:lower():find("shoot") then
                    r:FireServer(targetPos)
                end
            end
        end)
    end)
end

CombatTab:CreateToggle({
   Name = "Tiro Inteligente [Flutuante]",
   CurrentValue = false,
   Flag = "SmartShot",
   Callback = function(v)
       SmartOn=v
       if v then CreateSmartButton() else if SmartGui then SmartGui:Destroy() end end
   end,
})
