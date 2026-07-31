-- Joao Hub - Blox Fruits V1 | Até 2800 | Sea 1/2/3
getgenv().JoaoHub = { AutoFarm = false, TweenSpeed = 150, Height = 25, Bring = true, KillAura = true }

local Players = game:GetService("Players")
local TW = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

local PlaceId = game.PlaceId
local Sea1, Sea2, Sea3 = 2753915549, 4442272183, 7449423635

local Quests = {
    -- SEA 1
    {Level = 0, Mob = "Bandit", Quest = "BanditQuest1", QNum = 1, Mon = "Bandit", Pos = CFrame.new(1060, 16, 1547)},
    {Level = 10, Mob = "Monkey", Quest = "JungleQuest", QNum = 1, Mon = "Monkey", Pos = CFrame.new(-1602, 36, 152)},
    {Level = 30, Mob = "Gorilla", Quest = "JungleQuest", QNum = 2, Mon = "Gorilla", Pos = CFrame.new(-1200, 6, -520)},
    {Level = 60, Mob = "Pirate", Quest = "BuggyQuest1", QNum = 1, Mon = "Pirate", Pos = CFrame.new(-1141, 4, 3831)},
    {Level = 75, Mob = "Brute", Quest = "BuggyQuest1", QNum = 2, Mon = "Brute", Pos = CFrame.new(-1141, 4, 3831)},
    {Level = 90, Mob = "Desert Bandit", Quest = "DesertQuest", QNum = 1, Mon = "Desert Bandit", Pos = CFrame.new(896, 6, 4390)},
    {Level = 100, Mob = "Desert Officer", Quest = "DesertQuest", QNum = 2, Mon = "Desert Officer", Pos = CFrame.new(896, 6, 4390)},
    {Level = 120, Mob = "Snow Bandit", Quest = "SnowQuest", QNum = 1, Mon = "Snow Bandit", Pos = CFrame.new(1386, 87, -1298)},
    {Level = 130, Mob = "Snowman", Quest = "SnowQuest", QNum = 2, Mon = "Snowman", Pos = CFrame.new(1386, 87, -1298)},
    {Level = 150, Mob = "Chief Petty Officer", Quest = "MarineQuest2", QNum = 1, Mon = "Chief Petty Officer", Pos = CFrame.new(-5039, 28, 4324)},
    {Level = 175, Mob = "Sky Bandit", Quest = "SkyQuest", QNum = 1, Mon = "Sky Bandit", Pos = CFrame.new(-4841, 717, -2623)},
    {Level = 190, Mob = "Dark Master", Quest = "SkyQuest", QNum = 2, Mon = "Dark Master", Pos = CFrame.new(-4841, 717, -2623)},
    {Level = 225, Mob = "Prisoner", Quest = "PrisonerQuest", QNum = 1, Mon = "Prisoner", Pos = CFrame.new(5308, 2, 474)},
    {Level = 250, Mob = "Dangerous Prisoner", Quest = "PrisonerQuest", QNum = 2, Mon = "Dangerous Prisoner", Pos = CFrame.new(5308, 2, 474)},
    {Level = 300, Mob = "Toga Warrior", Quest = "ColosseumQuest", QNum = 1, Mon = "Toga Warrior", Pos = CFrame.new(-1427, 7, -3018)},
    -- SEA 2
    {Level = 700, Mob = "Raider", Quest = "Area1Quest", QNum = 1, Mon = "Raider", Pos = CFrame.new(-427, 72, 1835)},
    {Level = 775, Mob = "Mercenary", Quest = "Area1Quest", QNum = 2, Mon = "Mercenary", Pos = CFrame.new(-427, 72, 1835)},
    {Level = 875, Mob = "Swan Pirate", Quest = "Area2Quest", QNum = 1, Mon = "Swan Pirate", Pos = CFrame.new(634, 73, 918)},
    {Level = 950, Mob = "Factory Staff", Quest = "Area2Quest", QNum = 2, Mon = "Factory Staff", Pos = CFrame.new(634, 73, 918)},
    {Level = 1000, Mob = "Marine Lieutenant", Quest = "MarineQuest3", QNum = 1, Mon = "Marine Lieutenant", Pos = CFrame.new(-2441, 73, -3219)},
    {Level = 1100, Mob = "Marine Captain", Quest = "MarineQuest3", QNum = 2, Mon = "Marine Captain", Pos = CFrame.new(-2441, 73, -3219)},
    {Level = 1200, Mob = "Zombie", Quest = "ZombieQuest", QNum = 1, Mon = "Zombie", Pos = CFrame.new(-5497, 48, -795)},
    {Level = 1300, Mob = "Vampire", Quest = "ZombieQuest", QNum = 2, Mon = "Vampire", Pos = CFrame.new(-5497, 48, -795)},
    {Level = 1425, Mob = "Snow Trooper", Quest = "SnowMountainQuest", QNum = 1, Mon = "Snow Trooper", Pos = CFrame.new(608, 401, -5370)},
    {Level = 1450, Mob = "Winter Warrior", Quest = "SnowMountainQuest", QNum = 2, Mon = "Winter Warrior", Pos = CFrame.new(608, 401, -5370)},
    -- SEA 3 até 2800
    {Level = 1500, Mob = "Pirate Millionaire", Quest = "PiratePortQuest", QNum = 1, Mon = "Pirate Millionaire", Pos = CFrame.new(-290, 44, 5580)},
    {Level = 1575, Mob = "Pistol Billionaire", Quest = "PiratePortQuest", QNum = 2, Mon = "Pistol Billionaire", Pos = CFrame.new(-290, 44, 5580)},
    {Level = 1700, Mob = "Dragon Crew Warrior", Quest = "AmazonQuest", QNum = 1, Mon = "Dragon Crew Warrior", Pos = CFrame.new(5834, 52, -1107)},
    {Level = 1800, Mob = "Dragon Crew Archer", Quest = "AmazonQuest", QNum = 2, Mon = "Dragon Crew Archer", Pos = CFrame.new(5834, 52, -1107)},
    {Level = 1900, Mob = "Female Islander", Quest = "AmazonQuest2", QNum = 1, Mon = "Female Islander", Pos = CFrame.new(5446, 601, 750)},
    {Level = 2000, Mob = "Giant Islander", Quest = "AmazonQuest2", QNum = 2, Mon = "Giant Islander", Pos = CFrame.new(5446, 601, 750)},
    {Level = 2100, Mob = "Marine Commodore", Quest = "MarineTreeIsland", QNum = 1, Mon = "Marine Commodore", Pos = CFrame.new(2180, 27, -6733)},
    {Level = 2200, Mob = "Marine Rear Admiral", Quest = "MarineTreeIsland", QNum = 2, Mon = "Marine Rear Admiral", Pos = CFrame.new(2180, 27, -6733)},
    {Level = 2350, Mob = "Fishman Raider", Quest = "DeepForestIsland3", QNum = 1, Mon = "Fishman Raider", Pos = CFrame.new(-10581, 330, -8760)},
    {Level = 2400, Mob = "Fishman Captain", Quest = "DeepForestIsland3", QNum = 2, Mon = "Fishman Captain", Pos = CFrame.new(-10581, 330, -8760)},
    {Level = 2500, Mob = "Forest Pirate", Quest = "DeepForestIsland", QNum = 1, Mon = "Forest Pirate", Pos = CFrame.new(-13234, 331, -7631)},
    {Level = 2550, Mob = "Mythological Pirate", Quest = "DeepForestIsland", QNum = 2, Mon = "Mythological Pirate", Pos = CFrame.new(-13234, 331, -7631)},
    {Level = 2650, Mob = "Jungle Pirate", Quest = "DeepForestIsland2", QNum = 1, Mon = "Jungle Pirate", Pos = CFrame.new(-12680, 389, -10171)},
    {Level = 2700, Mob = "Musketeer Pirate", Quest = "DeepForestIsland2", QNum = 2, Mon = "Musketeer Pirate", Pos = CFrame.new(-12680, 389, -10171)},
    {Level = 2800, Mob = "Stone", Quest = "HauntedQuest1", QNum = 1, Mon = "Stone", Pos = CFrame.new(-5543, 313, -2974)},
}

function GetQuest()
    local lvl = lp.Data.Level.Value
    local best = Quests[1]
    for _,q in pairs(Quests) do if lvl >= q.Level then best = q end end
    return best
end

local TweenPart = Instance.new("Part", workspace) TweenPart.Anchored = true TweenPart.CanCollide = false TweenPart.Transparency = 1 TweenPart.Size = Vector3.new(1,1,1)
local shouldTween = false
function TweenTo(cf)
    shouldTween = true
    local hrp = lp.Character.HumanoidRootPart
    local dist = (hrp.Position - cf.Position).Magnitude
    local info = TweenInfo.new(dist/getgenv().JoaoHub.TweenSpeed, Enum.EasingStyle.Linear)
    local tw = TW:Create(TweenPart, info, {CFrame = cf})
    tw:Play() tw.Completed:Wait() shouldTween = false
end

task.spawn(function()
    while task.wait() do
        if shouldTween and lp.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lp.Character.HumanoidRootPart
            if (hrp.Position - TweenPart.Position).Magnitude <= 100 then hrp.CFrame = TweenPart.CFrame end
            for _,v in pairs(lp.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

function BringMobs(monName, pos)
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == monName and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - pos.Position).Magnitude < 300 then
            v.HumanoidRootPart.CFrame = pos
            v.HumanoidRootPart.CanCollide = false
            v.Humanoid.WalkSpeed = 0
            v.Humanoid.JumpPower = 0
            if v:FindFirstChild("Humanoid") then v.Humanoid:ChangeState(11) end
        end
    end
end

task.spawn(function()
    while task.wait() do
        if getgenv().JoaoHub.AutoFarm then
            pcall(function()
                local q = GetQuest()
                -- pega missão
                if not lp.PlayerGui.Main.Quest.Visible then
                    TweenTo(q.Pos) task.wait(0.5)
                    RS.Remotes.RigControllerEvent:FireServer("WeaponChange", q.Quest)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q.Quest, q.QNum)
                else
                    -- vai pros mobs
                    local mob = workspace.Enemies:FindFirstChild(q.Mon) or workspace.Enemies:FindFirstChild(q.Mob)
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        local above = mob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().JoaoHub.Height, 0)
                        TweenTo(above)
                        BringMobs(q.Mon, mob.HumanoidRootPart.CFrame)
                        -- kill aura hyper rápido
                        if getgenv().JoaoHub.KillAura then
                            for _,t in pairs(lp.Character:GetChildren()) do if t:IsA("Tool") then for i=1,10 do t:Activate() end end end
                            VIM:SendKeyEvent(true, "Z", false, game) VIM:SendKeyEvent(false, "Z", false, game)
                        end
                    else
                        TweenTo(q.Pos * CFrame.new(math.random(-10,10), 0, math.random(-10,10)))
                    end
                end
            end)
        end
    end
end)

-- UI
if CoreGui:FindFirstChild("JoaoHub_Open") then CoreGui:FindFirstChild("JoaoHub_Open"):Destroy() end
local SG = Instance.new("ScreenGui") SG.Name = "JoaoHub_Open" SG.Parent = CoreGui
local Btn = Instance.new("TextButton") Btn.Size = UDim2.new(0, 90, 0, 45) Btn.Position = UDim2.new(0.05, 0, 0.25, 0) Btn.BackgroundColor3 = Color3.fromRGB(20,20,20) Btn.Text = "Joao Hub" Btn.TextColor3 = Color3.new(1,1,1) Btn.TextScaled = true Btn.Font = Enum.Font.GothamBold Btn.Parent = SG Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)
Btn.MouseButton1Click:Connect(function() VIM:SendKeyEvent(true, Enum.KeyCode.End, false, game) task.wait() VIM:SendKeyEvent(false, Enum.KeyCode.End, false, game) end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({Title = "Joao Hub",SubTitle = "Blox Fruits - Até 2800",TabWidth = 160,Size = UDim2.fromOffset(580, 460),Theme = "Dark",MinimizeKey = Enum.KeyCode.End})
local Tabs = { Main = Window:AddTab({Title = "⚔️ Auto Farm", Icon = ""}) }
Tabs.Main:AddToggle("Farm", {Title = "Auto Farm Level - Todas missões 1-2800", Default = false}):OnChanged(function(v) getgenv().JoaoHub.AutoFarm = v end)
Tabs.Main:AddSlider("Speed", {Title = "Tween Speed", Default = 150, Min = 50, Max = 300, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.TweenSpeed = v end)
Tabs.Main:AddSlider("Height", {Title = "Altura em cima do mob", Default = 25, Min = 5, Max = 50, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.Height = v end)
Tabs.Main:AddToggle("Bring", {Title = "Bring Mobs - Juntar todos", Default = true}):OnChanged(function(v) getgenv().JoaoHub.Bring = v end)
Tabs.Main:AddToggle("Aura", {Title = "Kill Aura - Soco hyper rápido 2 em 2", Default = true}):OnChanged(function(v) getgenv().JoaoHub.KillAura = v end)
