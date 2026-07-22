-- Joao mm2 - LocalScript com Rayfield
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
   Name = "Joao mm2",
   LoadingTitle = "Joao mm2",
   LoadingSubtitle = "by Joao",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local ESPTab = Window:CreateTab("ESP", 4483362458)
local FarmTab = Window:CreateTab("Farm", 4483362458)

local LP = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local Speed = 25 -- velocidade padrão
local AutoCollect = false
local ESPOn = false

-- FUNÇÃO ROLE
local function GetRole(p)
    if not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Revolver") or p.Backpack:FindFirstChild("Revolver") then return "Sheriff" end
    return "Innocent"
end

-- ESP - Xerife Azul, Inocente Verde, Assassino Vermelho
ESPTab:CreateToggle({
   Name = "ESP Jogadores",
   CurrentValue = false,
   Flag = "ESPJoao",
   Callback = function(v)
       ESPOn = v
       if not v then
           for _,p in pairs(game.Players:GetPlayers()) do
               if p.Character and p.Character:FindFirstChild("JoaoESP") then p.Character.JoaoESP:Destroy() end
           end
       end
   end,
})

task.spawn(function()
    while task.wait(0.7) do
        if ESPOn then
            for _,p in pairs(game.Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    if p.Character:FindFirstChild("JoaoESP") then p.Character.JoaoESP:Destroy() end
                    local role = GetRole(p)
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Name = "JoaoESP"
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    if role == "Innocent" then
                        hl.FillColor = Color3.fromRGB(0,255,0) -- VERDE
                    elseif role == "Sheriff" then
                        hl.FillColor = Color3.fromRGB(0,120,255) -- AZUL
                    else
                        hl.FillColor = Color3.fromRGB(255,0,0) -- VERMELHO
                    end
                end
            end
        end
    end
end)

-- FARM - Velocidade que você escreve
FarmTab:CreateInput({
   Name = "Velocidade Tween",
   PlaceholderText = "Ex: 25, 50, 100",
   RemoveTextAfterFocusLost = false,
   Callback = function(txt)
       local num = tonumber(txt)
       if num then Speed = num end
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Coletar Moeda com Tween",
   CurrentValue = false,
   Flag = "AutoCoinJoao",
   Callback = function(v)
       AutoCollect = v
   end,
})

local function TweenTo(pos)
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local HRP = char.HumanoidRootPart
    local dist = (HRP.Position - pos).Magnitude
    local tempo = dist / Speed
    if tempo < 0.15 then tempo = 0.15 end
    local tween = TweenService:Create(HRP, TweenInfo.new(tempo, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos + Vector3.new(0,2,0))})
    tween:Play()
    tween.Completed:Wait()
end

task.spawn(function()
    while task.wait(0.2) do
        if AutoCollect then
            pcall(function()
                local CC = workspace:FindFirstChild("CoinContainer", true)
                if not CC then return end
                for _, coin in pairs(CC:GetChildren()) do
                    if not AutoCollect then break end
                    if coin.Name == "Coin_Server" and coin:IsA("BasePart") then
                        TweenTo(coin.Position)
                        task.wait(0.1)
                    end
                end
            end)
        end
    end
end)

FarmTab:CreateButton({
   Name = "Bring Gun Drop",
   Callback = function()
       for _,v in pairs(workspace:GetDescendants()) do
           if v.Name == "GunDrop" then v.CFrame = LP.Character.HumanoidRootPart.CFrame end
       end
   end,
})
