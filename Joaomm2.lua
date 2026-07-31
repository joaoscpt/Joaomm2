-- Joao Hub V4 - Universal AFK SEM ERRO - 1 botão só
getgenv().JoaoHub = { AFK = false, Speed = 275, Height = 20 }

local Players = game:GetService("Players")
local TW = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local VIM = game:GetService("VirtualInputManager")
local VU = game:GetService("VirtualUser")
local lp = Players.LocalPlayer

lp.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)

local part = Instance.new("Part", workspace) part.Anchored = true part.CanCollide = false part.Transparency = 1 part.Size = Vector3.new(1,1,1)
local tweening = false

function Go(cf)
    pcall(function()
        tweening = true
        local hrp = lp.Character.HumanoidRootPart
        local d = (hrp.Position - cf.Position).Magnitude
        local tw = TW:Create(part, TweenInfo.new(d/getgenv().JoaoHub.Speed, Enum.EasingStyle.Linear), {CFrame = cf})
        tw:Play() tw.Completed:Wait() tweening = false
    end)
end

task.spawn(function() while task.wait() do if tweening then pcall(function() lp.Character.HumanoidRootPart.CFrame = part.CFrame for _,v in pairs(lp.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end end) end end end)

-- TABELA UNIVERSAL 1-2800 ATUALIZADA
local Quests = {
    {"Bandit", "BanditQuest1", 1, CFrame.new(1060,16,1547)}, {"Monkey", "JungleQuest", 1, CFrame.new(-1602,36,152)},
    {"Gorilla", "JungleQuest", 2, CFrame.new(-1602,36,152)}, {"Pirate", "BuggyQuest1", 1, CFrame.new(-1141,4,3831)},
    {"Brute", "BuggyQuest1", 2, CFrame.new(-1141,4,3831)}, {"Desert Bandit", "DesertQuest", 1, CFrame.new(896,6,4390)},
    {"Desert Officer", "DesertQuest", 2, CFrame.new(896,6,4390)}, {"Snow Bandit", "SnowQuest", 1, CFrame.new(1386,87,-1298)},
    {"Snowman", "SnowQuest", 2, CFrame.new(1386,87,-1298)}, {"Chief Petty Officer", "MarineQuest2", 1, CFrame.new(-5039,28,4324)},
    {"Sky Bandit", "SkyQuest", 1, CFrame.new(-4841,717,-2623)}, {"Dark Master", "SkyQuest", 2, CFrame.new(-4841,717,-2623)},
    {"Prisoner", "PrisonerQuest", 1, CFrame.new(5308,2,474)}, {"Dangerous Prisoner", "PrisonerQuest", 2, CFrame.new(5308,2,474)},
    {"Toga Warrior", "ColosseumQuest", 1, CFrame.new(-1427,7,-3018)}, {"Gladiator", "ColosseumQuest", 2, CFrame.new(-1427,7,-3018)},
    {"Raider", "Area1Quest", 1, CFrame.new(-427,72,1835)}, {"Mercenary", "Area1Quest", 2, CFrame.new(-427,72,1835)},
    {"Swan Pirate", "Area2Quest", 1, CFrame.new(634,73,918)}, {"Factory Staff", "Area2Quest", 2, CFrame.new(634,73,918)},
    {"Marine Lieutenant", "MarineQuest3", 1, CFrame.new(-2441,73,-3219)}, {"Marine Captain", "MarineQuest3", 2, CFrame.new(-2441,73,-3219)},
    {"Zombie", "ZombieQuest", 1, CFrame.new(-5497,48,-795)}, {"Vampire", "ZombieQuest", 2, CFrame.new(-5497,48,-795)},
    {"Snow Trooper", "SnowMountainQuest", 1, CFrame.new(608,401,-5370)}, {"Winter Warrior", "SnowMountainQuest", 2, CFrame.new(608,401,-5370)},
    {"Lab Subordinate", "IceSideQuest", 1, CFrame.new(-5803,82,-3043)}, {"Horned Warrior", "IceSideQuest", 2, CFrame.new(-5803,82,-3043)},
    {"Pirate Millionaire", "PiratePortQuest", 1, CFrame.new(-290,44,5580)}, {"Pistol Billionaire", "PiratePortQuest", 2, CFrame.new(-290,44,5580)},
    {"Dragon Crew Warrior", "AmazonQuest", 1, CFrame.new(5834,52,-1107)}, {"Dragon Crew Archer", "AmazonQuest", 2, CFrame.new(5834,52,-1107)},
    {"Female Islander", "AmazonQuest2", 1, CFrame.new(5446,601,750)}, {"Giant Islander", "AmazonQuest2", 2, CFrame.new(5446,601,750)},
    {"Marine Commodore", "MarineTreeIsland", 1, CFrame.new(2180,27,-6733)}, {"Marine Rear Admiral", "MarineTreeIsland", 2, CFrame.new(2180,27,-6733)},
    {"Fishman Raider", "DeepForestIsland3", 1, CFrame.new(-10581,330,-8760)}, {"Fishman Captain", "DeepForestIsland3", 2, CFrame.new(-10581,330,-8760)},
    {"Forest Pirate", "DeepForestIsland", 1, CFrame.new(-13234,331,-7631)}, {"Mythological Pirate", "DeepForestIsland", 2, CFrame.new(-13234,331,-7631)},
    {"Jungle Pirate", "DeepForestIsland2", 1, CFrame.new(-12680,389,-10171)}, {"Musketeer Pirate", "DeepForestIsland2", 2, CFrame.new(-12680,389,-10171)},
    {"Stone", "HauntedQuest1", 1, CFrame.new(-5543,313,-2974)},
}

function GetQuest()
    local lvl = lp.Data.Level.Value
    local q = Quests[1]
    local idx = math.floor(lvl / 25) + 1
    if idx > #Quests then idx = #Quests end
    if Quests[idx] then return Quests[idx] else return q end
end

task.spawn(function()
    while task.wait(0.2) do
        if getgenv().JoaoHub.AFK then
            pcall(function()
                local myQ = GetQuest()
                local hasQuest = lp.PlayerGui.Main.Quest.Visible

                if not hasQuest then
                    Go(myQ[4]) task.wait(0.5)
                    RS.Remotes.CommF_:InvokeServer("StartQuest", myQ[2], myQ[3])
                else
                    local found = false
                    for _,mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob.Name == myQ[1] and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            found = true
                            local pos = mob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().JoaoHub.Height, 0)
                            Go(pos)
                            -- BRING + KILL AURA JUNTO SEM ERRO
                            for _,v in pairs(workspace.Enemies:GetChildren()) do if v.Name == myQ[1] then pcall(function() v.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame v.Humanoid.WalkSpeed = 0 end) end end
                            for _,t in pairs(lp.Character:GetChildren()) do if t:IsA("Tool") then t:Activate() end end
                            break
                        end
                    end
                    if not found then Go(myQ[4] * CFrame.new(math.random(-20,20),0,math.random(-20,20))) end
                end
            end)
        end
    end
end)

-- UI 1 BOTÃO
if CoreGui:FindFirstChild("JoaoHub_Open") then CoreGui:FindFirstChild("JoaoHub_Open"):Destroy() end
local sg = Instance.new("ScreenGui", CoreGui) sg.Name = "JoaoHub_Open"
local b = Instance.new("TextButton", sg) b.Size = UDim2.new(0,100,0,50) b.Position = UDim2.new(0.05,0,0.3,0) b.Text = "Joao Hub" b.BackgroundColor3 = Color3.fromRGB(20,20,20) b.TextColor3 = Color3.new(1,1,1) b.TextScaled = true Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
b.MouseButton1Click:Connect(function() VIM:SendKeyEvent(true, Enum.KeyCode.End, false, game) task.wait() VIM:SendKeyEvent(false, Enum.KeyCode.End, false, game) end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({Title = "Joao Hub",SubTitle = "V4 AFK SEM ERRO",TabWidth = 160,Size = UDim2.fromOffset(480, 300),Theme = "Dark",MinimizeKey = Enum.KeyCode.End})
local Tab = Window:AddTab({Title = "AFK", Icon = ""})
Tab:AddToggle("AFK", {Title = "Auto Farm Level - Deixar a noite toda", Default = false}):OnChanged(function(v) getgenv().JoaoHub.AFK = v end)
Tab:AddSlider("Speed", {Title = "Tween Speed (max 300)", Default = 275, Min = 50, Max = 300, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.Speed = v end)
Tab:AddSlider("Height", {Title = "Altura em cima do mob", Default = 20, Min = 5, Max = 40, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.Height = v end)
