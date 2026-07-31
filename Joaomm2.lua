-- Joao Hub V8 - Kill Aura REAL - Bate de verdade
getgenv().JoaoHub = { AFK = false, Speed = 250, Height = 25, Weapon = "Melee" }

local Players = game:GetService("Players")
local TW = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local VIM = game:GetService("VirtualInputManager")
local VU = game:GetService("VirtualUser")
local lp = Players.LocalPlayer
lp.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)

local part = Instance.new("Part", workspace) part.Anchored = true part.CanCollide = false part.Transparency = 1 part.Size = Vector3.new(1,1,1)
function Go(cf)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    part.CFrame = hrp.CFrame
    local dist = (hrp.Position - cf.Position).Magnitude
    local tw = TW:Create(part, TweenInfo.new(dist/getgenv().JoaoHub.Speed, Enum.EasingStyle.Linear), {CFrame = cf})
    tw:Play()
    repeat task.wait() pcall(function() hrp.CFrame = part.CFrame hrp.Velocity = Vector3.new(0,0,0) for _,v in pairs(lp.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end end) until (part.Position - cf.Position).Magnitude < 8 or not getgenv().JoaoHub.AFK
end

function Equip()
    pcall(function()
        local typeW = getgenv().JoaoHub.Weapon
        local backpack = lp.Backpack
        local char = lp.Character
        if char:FindFirstChildOfClass("Tool") then return end -- já tem ferramenta
        for _,tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if typeW == "Melee" and (tool.ToolTip == "Melee" or tool.Name:find("Combat") or tool.Name:find("Electric") or tool.Name:find("Elétrico")) then char.Humanoid:EquipTool(tool) return end
                if typeW == "Sword" and tool.ToolTip == "Sword" then char.Humanoid:EquipTool(tool) return end
            end
        end
    end)
end

-- KILL AURA SEPARADO QUE BATE DE VERDADE
task.spawn(function()
    while task.wait(0.08) do
        if getgenv().JoaoHub.AFK then
            pcall(function()
                Equip()
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                for _,mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 and (hrp.Position - mob.HumanoidRootPart.Position).Magnitude < 70 then
                        -- METODO REAL QUE FUNCIONA NO BLOX ATUAL
                        for i=1,6 do
                            RS.Remotes.RigControllerEvent:FireServer("Hit", {mob}, 1, "")
                            VIM:SendMouseButtonEvent(0,0,0,true,game,1)
                            VIM:SendMouseButtonEvent(0,0,0,false,game,1)
                            local tool = lp.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end)
        end
    end
end)

local Quests = {
    {1250, "Zombie", "ZombieQuest", 1, CFrame.new(-5497,48,-795), CFrame.new(-5600,48,-800)},
    {1300, "Vampire", "ZombieQuest", 2, CFrame.new(-5497,48,-795), CFrame.new(-5800,48,-900)},
    {1302, "Snow Trooper", "SnowMountainQuest", 1, CFrame.new(608,401,-5370), CFrame.new(600,400,-5300)},
    {1325, "Winter Warrior", "SnowMountainQuest", 2, CFrame.new(608,401,-5370), CFrame.new(650,400,-5400)},
    {1350, "Lab Subordinate", "IceSideQuest", 1, CFrame.new(-5803,82,-3043), CFrame.new(-5900,82,-3100)},
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
                    Go(q[5]) task.wait(0.8)
                    RS.Remotes.CommF_:InvokeServer("StartQuest", q[3], q[4])
                else
                    local found = false
                    for _,mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob.Name == q[2] and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            found = true
                            Go(mob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().JoaoHub.Height, 0))
                            for _,v in pairs(workspace.Enemies:GetChildren()) do if v.Name == q[2] then pcall(function() v.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame v.Humanoid.WalkSpeed = 0 end) end end
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
local Window = Fluent:CreateWindow({Title = "Joao Hub",SubTitle = "V8 KILL AURA REAL",TabWidth = 160,Size = UDim2.fromOffset(520,380),Theme = "Dark",MinimizeKey = Enum.KeyCode.End})
local Tab = Window:AddTab({Title = "AFK", Icon = ""})
Tab:AddToggle("AFK", {Title = "Auto Farm + Kill Aura", Default = false}):OnChanged(function(v) getgenv().JoaoHub.AFK = v end)
Tab:AddDropdown("Weapon", {Title = "Arma", Values = {"Melee", "Sword"}, Default = 1}):OnChanged(function(v) getgenv().JoaoHub.Weapon = v end)
Tab:AddSlider("Speed", {Title = "Tween Speed MAX 300", Default = 250, Min = 50, Max = 300, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.Speed = v end)
Tab:AddSlider("Height", {Title = "Altura em cima do mob", Default = 25, Min = 5, Max = 50, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.Height = v end)
