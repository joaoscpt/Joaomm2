-- Joao Hub V6 - Tween Puro - Sem TP - Não volta mais
getgenv().JoaoHub = { AFK = false, Speed = 250, Height = 25 }

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
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    part.CFrame = hrp.CFrame -- começa da onde você tá, não do zero
    local dist = (hrp.Position - cf.Position).Magnitude
    local time = dist / getgenv().JoaoHub.Speed
    if time < 0.5 then time = 0.5 end
    tweening = true
    local tw = TW:Create(part, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = cf})
    tw:Play()
    -- enquanto tweena, vai colando seu boneco no part
    repeat task.wait()
        pcall(function()
            hrp.CFrame = part.CFrame
            hrp.Velocity = Vector3.new(0,0,0)
            for _,v in pairs(lp.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end)
    until (part.Position - cf.Position).Magnitude < 5 or not getgenv().JoaoHub.AFK
    tweening = false
end

local Quests = {
    {0, "Bandit", "BanditQuest1", 1, CFrame.new(1060,16,1547), CFrame.new(1140,16,1630)},
    {10, "Monkey", "JungleQuest", 1, CFrame.new(-1602,36,152), CFrame.new(-1445,39,40)},
    {60, "Pirate", "BuggyQuest1", 1, CFrame.new(-1141,4,3831), CFrame.new(-1200,4,3850)},
    {120, "Desert Bandit", "DesertQuest", 1, CFrame.new(896,6,4390), CFrame.new(930,6,4470)},
    {700, "Raider", "Area1Quest", 1, CFrame.new(-427,72,1835), CFrame.new(-600,72,1900)},
    {800, "Mercenary", "Area1Quest", 2, CFrame.new(-427,72,1835), CFrame.new(-700,72,2000)},
    {900, "Swan Pirate", "Area2Quest", 1, CFrame.new(634,73,918), CFrame.new(700,73,1000)},
    {1100, "Marine Lieutenant", "MarineQuest3", 1, CFrame.new(-2441,73,-3219), CFrame.new(-2600,73,-3300)},
    {1200, "Marine Captain", "MarineQuest3", 2, CFrame.new(-2441,73,-3219), CFrame.new(-2700,73,-3400)},
    {1250, "Zombie", "ZombieQuest", 1, CFrame.new(-5497,48,-795), CFrame.new(-5600,48,-800)},
    {1300, "Vampire", "ZombieQuest", 2, CFrame.new(-5497,48,-795), CFrame.new(-5800,48,-900)},
    {1302, "Snow Trooper", "SnowMountainQuest", 1, CFrame.new(608,401,-5370), CFrame.new(600,400,-5300)},
    {1325, "Winter Warrior", "SnowMountainQuest", 2, CFrame.new(608,401,-5370), CFrame.new(650,400,-5400)},
    {1350, "Lab Subordinate", "IceSideQuest", 1, CFrame.new(-5803,82,-3043), CFrame.new(-5900,82,-3100)},
    {1500, "Pirate Millionaire", "PiratePortQuest", 1, CFrame.new(-290,44,5580), CFrame.new(-400,44,5600)},
}

function GetQuest()
    local lvl = lp.Data.Level.Value
    local best = Quests[1]
    for _,q in ipairs(Quests) do if lvl >= q[1] then best = q end end
    return best
end

task.spawn(function()
    while task.wait(0.3) do
        if getgenv().JoaoHub.AFK then
            pcall(function()
                local q = GetQuest()
                if not lp.PlayerGui.Main.Quest.Visible then
                    Go(q[5]) task.wait(0.5)
                    RS.Remotes.CommF_:InvokeServer("StartQuest", q[3], q[4])
                else
                    local found = false
                    for _,mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob.Name == q[2] and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            found = true
                            Go(mob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().JoaoHub.Height, 0))
                            for _,v in pairs(workspace.Enemies:GetChildren()) do if v.Name == q[2] then pcall(function() v.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame v.Humanoid.WalkSpeed = 0 end) end end
                            for _,t in pairs(lp.Character:GetChildren()) do if t:IsA("Tool") then t:Activate() end end
                            break
                        end
                    end
                    if not found then Go(q[6]) end
                end
            end)
        end
    end
end)

if CoreGui:FindFirstChild("JoaoHub_Open") then CoreGui:FindFirstChild("JoaoHub_Open"):Destroy() end
local sg = Instance.new("ScreenGui", CoreGui) sg.Name = "JoaoHub_Open"
local b = Instance.new("TextButton", sg) b.Size = UDim2.new(0,100,0,50) b.Position = UDim2.new(0.05,0,0.3,0) b.Text = "Joao Hub" b.BackgroundColor3 = Color3.fromRGB(20,20,20) b.TextColor3 = Color3.new(1,1,1) b.TextScaled = true Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
b.MouseButton1Click:Connect(function() VIM:SendKeyEvent(true, Enum.KeyCode.End, false, game) task.wait() VIM:SendKeyEvent(false, Enum.KeyCode.End, false, game) end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({Title = "Joao Hub",SubTitle = "V6 TWEEN PURO",TabWidth = 160,Size = UDim2.fromOffset(480,300),Theme = "Dark",MinimizeKey = Enum.KeyCode.End})
local Tab = Window:AddTab({Title = "AFK", Icon = ""})
Tab:AddToggle("AFK", {Title = "Auto Farm Tween", Default = false}):OnChanged(function(v) getgenv().JoaoHub.AFK = v end)
Tab:AddSlider("Speed", {Title = "Tween Speed (max 300)", Default = 250, Min = 50, Max = 300, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.Speed = v end)
Tab:AddSlider("Height", {Title = "Altura em cima do mob", Default = 25, Min = 5, Max = 50, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.Height = v end)
