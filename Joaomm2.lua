-- Joao Hub V9 - Buddha Aura - Kill aura de verdade
getgenv().JoaoHub = { AFK = false, Speed = 250, Height = 20 }

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
    repeat task.wait() pcall(function() hrp.CFrame = part.CFrame hrp.Velocity = Vector3.new(0,0,0) end) until (part.Position - cf.Position).Magnitude < 8 or not getgenv().JoaoHub.AFK
end

-- AURA DA BUDDHA DESPERTADA - BATE EM ÁREA
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().JoaoHub.AFK then
            pcall(function()
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                -- Aumenta a hitbox da Buddha
                if lp.Character:FindFirstChild("HumanoidRootPart") then
                    for _,v in pairs(lp.Character:GetChildren()) do
                        if v:IsA("BasePart") and v.CanCollide == false then
                            -- deixa o corpo gigante pra aura pegar
                            if v.Name == "HumanoidRootPart" then
                                v.Size = Vector3.new(65,65,65)
                                v.Transparency = 1
                            end
                        end
                    end
                end
                -- Dano em área igual Buddha
                for _,mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and (hrp.Position - mob.HumanoidRootPart.Position).Magnitude < 65 then
                        -- 3 jeitos pra garantir o hit
                        RS.Remotes.RigControllerEvent:FireServer("Hit", {mob}, 1, "")
                        RS.Remotes.RigControllerEvent:FireServer("Hit", {mob}, 2, "")
                        firetouchinterest(hrp, mob.HumanoidRootPart, 0)
                        firetouchinterest(hrp, mob.HumanoidRootPart, 1)
                    end
                end
            end)
        end
    end
end)

local Quests = {
    {1302, "Snow Trooper", "SnowMountainQuest", 1, CFrame.new(608,401,-5370), CFrame.new(600,400,-5300)},
    {1325, "Winter Warrior", "SnowMountainQuest", 2, CFrame.new(608,401,-5370), CFrame.new(650,400,-5400)},
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
                    for _,mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob.Name == q[2] and mob.Humanoid.Health > 0 then
                            Go(mob.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().JoaoHub.Height, 0))
                            for _,v in pairs(workspace.Enemies:GetChildren()) do if v.Name == q[2] then pcall(function() v.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame v.Humanoid.WalkSpeed = 0 end) end end
                            break
                        end
                    end
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
local Window = Fluent:CreateWindow({Title = "Joao Hub",SubTitle = "V9 BUDDHA AURA",TabWidth = 160,Size = UDim2.fromOffset(480,320),Theme = "Dark",MinimizeKey = Enum.KeyCode.End})
local Tab = Window:AddTab({Title = "AFK", Icon = ""})
Tab:AddToggle("AFK", {Title = "Auto Farm + Buddha Aura", Default = false}):OnChanged(function(v) getgenv().JoaoHub.AFK = v end)
Tab:AddSlider("Speed", {Title = "Tween Speed MAX 300", Default = 250, Min = 50, Max = 300, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.Speed = v end)
Tab:AddSlider("Height", {Title = "Altura em cima do mob", Default = 20, Min = 5, Max = 50, Rounding = 0}):OnChanged(function(v) getgenv().JoaoHub.Height = v end)
