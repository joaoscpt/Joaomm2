-- ============================================================
-- 🔥 KILL AURA BLOX FRUITS | ATUALIZADO 2026 | UI GARANTIDA
-- LEVEL 1-2800 | DETECTA QUALQUER MISSÃO + BOSS
-- CORRIGIDO PRA ABRIR UI EM QUALQUER EXECUTOR MOBILE
-- ============================================================

-- 🔥 NÃO KICKA MAIS SE PlaceId DIFERIR (SÓ AVISA)
local BLOX_ID = 3260590327
if game.PlaceId ~= BLOX_ID then
    warn("AVISO: Você não está no Blox Fruits oficial!")
end

-- ============================================================
-- ✅ PRIMEIRO: CARREGA RAYFIELD COM 3 LINKS DE RESERVA
-- (ESSE ERA O PROBLEMA — O LINK ANTIGO CAIU NO CELULAR)
-- ============================================================
getgenv().SecureMode = true
local Rayfield = nil
local linksRayfield = {
    "https://raw.githubusercontent.com/SiriusMenu/Rayfield/main/source.lua",
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/zzerexx/Rayfield/main/Source.lua"
}

-- Tenta carregar cada link até um funcionar
for i, link in ipairs(linksRayfield) do
    local ok, res = pcall(function()
        return loadstring(game:HttpGet(link, true))()
    end)
    if ok and res then
        Rayfield = res
        warn("✅ Rayfield carregou pelo link "..i)
        break
    else
        warn("❌ Link "..i.." do Rayfield falhou: "..tostring(res))
    end
end

-- ============================================================
-- 🚨 UI DE EMERGÊNCIA SE RAYFIELD NÃO CARREGAR NENHUM LINK
-- (NUNCA MAIS FICA SEM NENHUMA JANELA)
-- ============================================================
local function criarUIFallback()
    local UIS = game:GetService("UserInputService")
    local gui = Instance.new("ScreenGui")
    gui.Parent = game.Players.LocalPlayer.PlayerGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.85, 0, 0.7, 0)
    frame.Position = UDim2.new(0.075, 0, 0.15, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

    local titulo = Instance.new("TextLabel")
    titulo.Size = UDim2.new(1,0,0,45)
    titulo.BackgroundColor3 = Color3.fromRGB(30,30,40)
    titulo.Text = "🔥 KILL AURA BF | UI EMERGÊNCIA"
    titulo.TextColor3 = Color3.new(1,1,1)
    titulo.Font = Enum.Font.GothamBold
    titulo.TextSize = 16
    titulo.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.9,0,0,55)
    toggle.Position = UDim2.new(0.05,0,0.12,0)
    toggle.BackgroundColor3 = Color3.fromRGB(40,120,40)
    toggle.Text = "▶️ LIGAR KILL AURA"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 17
    toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,10)

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(0.9,0,0.5,0)
    info.Position = UDim2.new(0.05,0,0.3,0)
    info.BackgroundTransparency = 1
    info.Text = "CONFIG PADRÃO:\n✅ Apenas alvo da missão\n✅ Ataca boss de missão\n✅ Nível 1 até 2800\n✅ Hitbox 3x\n✅ Raio 20 studs\n✅ Delay 120ms\n✅ Auto Haki + Coletar"
    info.TextColor3 = Color3.new(0.9,0.9,0.9)
    info.Font = Enum.Font.Gotham
    info.TextSize = 14
    info.TextWrapped = true
    info.Parent = frame

    -- Arrastar janela
    local arrastando, inicio, posInicio = false
    titulo.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            arrastando = true inicio = i.Position posInicio = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if arrastando and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = i.Position - inicio
            frame.Position = UDim2.new(posInicio.X.Scale, posInicio.X.Offset + delta.X, posInicio.Y.Scale, posInicio.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then arrastando = false end end)

    return {
        ToggleAura = function(cb)
            local ligado = false
            toggle.MouseButton1Click:Connect(function()
                ligado = not ligado
                if ligado then
                    toggle.BackgroundColor3 = Color3.fromRGB(160,40,40)
                    toggle.Text = "⏹️ DESLIGAR KILL AURA"
                else
                    toggle.BackgroundColor3 = Color3.fromRGB(40,120,40)
                    toggle.Text = "▶️ LIGAR KILL AURA"
                end
                cb(ligado)
            end)
        end,
        Notify = function(t,c) warn("["..t.."] "..c) end
    }
end

-- ============================================================
-- 🚀 AGORA SIM: CARREGA O RESTO DO SCRIPT SEM ERRO SILENCIOSO
-- ============================================================
local sucesso, erro = xpcall(function()

-- ESPERA O JOGO CARREGAR TUDO (OUTRO PROBLEMA COMUM NO CELULAR)
repeat task.wait(0.5) until game:IsLoaded()
task.wait(2) -- Espera mais 2s pra carregar scripts do Blox Fruits

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
repeat task.wait() until lp.Character
local char, hrp, hum = lp.Character, lp.Character:WaitForChild("HumanoidRootPart"), lp.Character:WaitForChild("Humanoid")
local ultimoAtaque = 0
local hitboxOriginal = {}
local loopConexao = nil
local questAtual = {nome = nil, ehBoss = false}

lp.CharacterAdded:Connect(function(c)
    char = c hrp = c:WaitForChild("HumanoidRootPart") hum = c:WaitForChild("Humanoid")
end)

-- ============================================================
-- BUSCA REMOTES ATUALIZADOS
-- ============================================================
local Remotes = RS:WaitForChild("Remotes", 15) or Instance.new("Folder")
local RigEvent = RS:FindFirstChild("RigControllerEvent")

local function pegarRemote(parcial)
    for _, r in ipairs(Remotes:GetDescendants()) do
        if r:IsA("RemoteEvent") and string.find(string.lower(r.Name), string.lower(parcial)) then return r end
    end
    return nil
end

local RemoteClick = pegarRemote("LeftClick") or pegarRemote("Click") or pegarRemote("Hit")
local RemoteDano = pegarRemote("RegisterHit") or pegarRemote("Damage") or pegarRemote("DealDamage")
local RemoteHaki = pegarRemote("Haki") or pegarRemote("Busoshoku") or pegarRemote("Armament") or pegarRemote("Aura")

-- ============================================================
-- 🔥 DETECTA NÍVEL NPC 1-2800 (3 MÉTODOS)
-- ============================================================
local function pegarNivelNPC(npc)
    if not npc then return 0 end
    local nome = npc.Name or ""
    local nv = string.match(nome, "%[?Lv%.?%s*(%d+)%]?") or string.match(nome, "N[íi]vel%s*(%d+)")
    if nv then return tonumber(nv) end
    for _, v in ipairs(npc:GetDescendants()) do
        if (v:IsA("NumberValue") or v:IsA("IntValue")) and string.find(string.lower(v.Name), "lev") or string.find(string.lower(v.Name), "lv") then
            if v.Value >=1 and v.Value <=3000 then return v.Value end
        end
    end
    local h = npc:FindFirstChild("Humanoid") and npc.Humanoid.MaxHealth or 100
    if h <= 200 then return math.max(1, math.floor(h/20)) end
    if h <= 5000 then return math.max(1, math.floor(h/7)) end
    if h <= 50000 then return math.max(500, math.floor(h/18)) end
    return math.min(2800, math.floor(h/40))
end

-- ============================================================
-- 📜 DETECTA QUALQUER MISSÃO AUTOMÁTICO
-- ============================================================
local function atualizarQuest()
    pcall(function()
        local gui = lp.PlayerGui
        local texto = nil
        for _, d in ipairs(gui:GetDescendants()) do
            if d:IsA("TextLabel") and d.Visible and string.len(d.Text) > 3 then
                local t = string.lower(d.Text)
                if string.find(t, "matar") or string.find(t, "derrotar") or string.find(t, "eliminar") then
                    texto = d.Text break
                end
            end
        end
        if texto then
            local mob = string.match(string.lower(texto), "matar%s*%d*%s*(.+)$") or string.match(string.lower(texto), "derrotar%s*%d*%s*(.+)$") or string.lower(texto)
            mob = string.gsub(mob, "%s*x%s*%d+", ""):gsub("^%s+",""):gsub("%s+$","")
            questAtual = {
                nome = mob,
                ehBoss = string.find(string.lower(texto), "boss") or string.find(mob, "admiral") or string.find(mob, "king") or string.find(mob, "queen") or string.find(mob, "lord")
            }
        end
    end)
end
task.spawn(function() while task.wait(2) do atualizarQuest() end end)

local function ehAlvoQuest(npc, nv)
    if not questAtual.nome or not npc then return false end
    local n = string.lower(npc.Name or "")
    local q = questAtual.nome
    if string.find(n, q) or string.find(q, n) then return true end
    local qs = string.gsub(q,"s$","") local ns = string.gsub(n,"s$","")
    if string.find(ns, qs) or string.find(qs, ns) then return true end
    if questAtual.ehBoss and nv >= 100 and npc:FindFirstChild("Humanoid") and npc.Humanoid.MaxHealth > 5000 then return true end
    return false
end

-- ============================================================
-- FUNÇÕES AUXILIARES
-- ============================================================
local function vivo(v) return v and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0 and v:FindFirstChild("HumanoidRootPart") end
local function distancia(a,b) return (a.Position-b.Position).Magnitude end
local function restaurarHB(a) if a and hitboxOriginal[a] then pcall(function() a.HumanoidRootPart.Size = hitboxOriginal[a] end) hitboxOriginal[a]=nil end end

-- CONFIG PADRÃO (OTIMIZADA JÁ — NÃO PRECISA MEXER SE NÃO QUISER)
local cfg = {
    ligado=false, delay=0.12, raio=20, hitbox=true, tamHitbox=3,
    puxar=false, distPuxar=3, autoHaki=true, autoColetar=true,
    apenasQuest=true, atacarBossQuest=true, nivelMin=1, nivelMax=2800,
    atacarForaQuest=false, soNPC=true, soPlayer=false, ignoraTime=true,
    prioridade="Mais Próximo", modoEco=true, antiAFK=true, noClip=false
}

-- ============================================================
-- 🎯 BUSCA MELHOR ALVO
-- ============================================================
local function pegarAlvo()
    if not hrp then return nil end
    local l = {}
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v~=char and vivo(v) and not v:FindFirstChild("ForceField") then
            local raiz = v.HumanoidRootPart
            local d = distancia(hrp, raiz) if d>cfg.raio then continue end
            local pl = Players:GetPlayerFromCharacter(v)
            local ehNpc = not pl
            local nv = ehNpc and pegarNivelNPC(v) or 0
            local ehBoss = (v.Humanoid.MaxHealth>5000 or nv>=700)
            local ehQ = ehNpc and ehAlvoQuest(v,nv) or false

            -- FILTRO NÍVEL 1-2800
            if ehNpc and (nv<cfg.nivelMin or nv>cfg.nivelMax) then
                if not (cfg.atacarBossQuest and ehQ and ehBoss) then continue end
            end
            -- FILTRO MISSÃO
            if cfg.apenasQuest and ehNpc and not ehQ and not cfg.atacarForaQuest then continue end
            -- FILTRO PLAYER/NPC
            if cfg.soNPC and not ehNpc then continue end
            if cfg.soPlayer and not pl then continue end

            table.insert(l, {i=v, d=d, vd=v.Humanoid.Health, nv=nv, b=ehBoss, q=ehQ})
        end
    end
    if #l==0 then return nil end
    table.sort(l, function(a,b)
        if a.q and not b.q then return true end
        if not a.q and b.q then return false end
        if a.b and not b.b then return true end
        if not a.b and b.b then return false end
        return a.d < b.d
    end)
    return l[1].i
end

-- ============================================================
-- ⚔️ ATAQUE
-- ============================================================
local function atacar(a)
    if not vivo(a) or not hrp then return end
    local agora = os.clock()
    if agora-ultimoAtaque < cfg.delay then return end
    ultimoAtaque = agora
    local r = a.HumanoidRootPart

    if cfg.autoHaki and RemoteHaki then pcall(function() RemoteHaki:FireServer(true) end) end
    if cfg.puxar then pcall(function() r.CFrame = CFrame.new(hrp.Position + ((hrp.Position-r.Position).Unit*cfg.distPuxar)) end) end
    if cfg.hitbox then pcall(function()
        if not hitboxOriginal[a] then hitboxOriginal[a]=r.Size end
        r.Size = hitboxOriginal[a]*cfg.tamHitbox
        task.delay(0.15, function() restaurarHB(a) end)
    end) end

    -- Tenta todos os métodos de ataque até um funcionar
    local foi = false
    if RigEvent then pcall(function() RigEvent:FireServer("hit", {{Instance=a,Normal=Vector3.new(0,1,0),Position=r.Position,Type="Slice"}},1,"") foi=true end) end
    if not foi and RemoteDano then pcall(function() RemoteDano:FireServer(a, r.Position, 1) foi=true end) end
    if not foi and RemoteClick then pcall(function() RemoteClick:FireServer(true, r.Position) foi=true end) end
    if not foi then pcall(function()
        local cf = workspace.CurrentCamera.CFrame
        workspace.CurrentCamera.CFrame = CFrame.new(hrp.Position, r.Position)
        UIS:MouseButton1Down(Vector2.new()) task.wait(0.02) UIS:MouseButton1Up(Vector2.new())
        workspace.CurrentCamera.CFrame = cf
    end) end

    -- AUTO COLETAR
    if cfg.autoColetar then task.spawn(function()
        task.wait(0.3)
        for _, it in ipairs(Workspace:GetChildren()) do
            if (it:IsA("Tool") and it:FindFirstChild("Handle")) or (it:IsA("Part") and string.find(string.lower(it.Name), "mone") or string.find(string.lower(it.Name), "beli") or string.find(string.lower(it.Name), "xp")) then
                pcall(function() (it:FindFirstChild("Handle") or it).CFrame = hrp.CFrame end)
            end
        end
    end) end
end

-- ============================================================
-- 🔁 LOOP PRINCIPAL
-- ============================================================
local function loop()
    if loopConexao then loopConexao:Disconnect() end
    local c=0
    loopConexao = RunService.Heartbeat:Connect(function()
        if not cfg.ligado or not hrp then return end
        c+=1 if cfg.modoEco and c%2~=0 then return end
        local a = pegarAlvo() if a then atacar(a) end
    end)
end

-- ANTI AFK
if cfg.antiAFK then
    lp.Idled:Connect(function() game:GetService("VirtualUser"):Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame) task.wait(1) game:GetService("VirtualUser"):Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame) end)
end

-- ============================================================
-- 📱 CRIA A UI — RAYFIELD SE CARREGOU, SENÃO UI EMERGÊNCIA
-- ============================================================
local UI
if Rayfield then
    UI = Rayfield:CreateWindow({
        Name = "🔥 KILL AURA BF | LVL 1-2800",
        LoadingTitle = "Carregando...",
        LoadingSubtitle = "Script corrigido pra mobile",
        ShowText = "🎮 ABRIR MENU",
        Theme = "Dark",
        ConfigurationSaving = {Enabled=true, FolderName="KillAuraBFv2", FileName="config"}
    })

    local A1 = UI:CreateTab("🗡️ Kill Aura")
    A1:CreateSection("PRINCIPAL")
    A1:CreateToggle({Name="✅ LIGAR KILL AURA", CurrentValue=false, Callback=function(v)
        cfg.ligado = v if v then loop() elseif loopConexao then loopConexao:Disconnect() end
    end})
    A1:CreateSlider({Name="⏱️ Delay (ms)", Range={80,1000}, Increment=10, Suffix="ms", CurrentValue=120, Callback=function(v) cfg.delay=v/1000 end})
    A1:CreateSlider({Name="📏 Raio", Range={5,50}, Increment=1, Suffix="studs", CurrentValue=20, Callback=function(v) cfg.raio=v end})
    A1:CreateSection("ATAQUE")
    A1:CreateToggle({Name="🎯 Hitbox Gigante", CurrentValue=true, Callback=function(v) cfg.hitbox=v end})
    A1:CreateSlider({Name="📐 Tamanho Hitbox", Range={1,10}, Increment=1, Suffix="x", CurrentValue=3, Callback=function(v) cfg.tamHitbox=v end})
    A1:CreateToggle({Name="🛡️ Auto Haki", CurrentValue=true, Callback=function(v) cfg.autoHaki=v end})
    A1:CreateToggle({Name="💰 Auto Coletar", CurrentValue=true, Callback=function(v) cfg.autoColetar=v end})
    A1:CreateToggle({Name="🌀 Puxar Alvo", CurrentValue=false, Callback=function(v) cfg.puxar=v end})

    local A2 = UI:CreateTab("📜 Missão & Nível")
    A2:CreateSection("MISSÃO AUTOMÁTICA")
    A2:CreateToggle({Name="✅ SÓ ATACAR MISSÃO ATUAL", CurrentValue=true, Callback=function(v) cfg.apenasQuest=v end})
    A2:CreateToggle({Name="👑 ATACAR BOSS DE MISSÃO", CurrentValue=true, Callback=function(v) cfg.atacarBossQuest=v end})
    A2:CreateSection("NÍVEL NPC 1-2800")
    A2:CreateSlider({Name="⬇️ Nível Mínimo", Range={1,2799}, Increment=1, Suffix="lv", CurrentValue=1, Callback=function(v) cfg.nivelMin=v end})
    A2:CreateSlider({Name="⬆️ Nível Máximo (2800)", Range={10,2800}, Increment=1, Suffix="lv", CurrentValue=2800, Callback=function(v) cfg.nivelMax=v end})
    A2:CreateDropdown({Name="Prioridade Alvo", Options={"Mais Próximo","Menos Vida","Mais Nível"}, CurrentValue="Mais Próximo", Callback=function(v) cfg.prioridade=v end})

    local A3 = UI:CreateTab("⚙️ Extras")
    A3:CreateToggle({Name="🔋 Modo Econômico", CurrentValue=true, Callback=function(v) cfg.modoEco=v end})
    A3:CreateToggle({Name="😴 Anti AFK", CurrentValue=true, Callback=function(v) cfg.antiAFK=v end})

    Rayfield:LoadConfiguration()
    UI:Notify({Title="✅ PRONTO", Content="Script carregado! Liga o Kill Aura na primeira aba.", Duration=5})
else
    -- 🔥 SE RAYFIELD FALHOU — USA UI DE EMERGÊNCIA (FUNCIONA SEMPRE)
    warn("⚠️ Rayfield não carregou — abrindo UI de emergência")
    UI = criarUIFallback()
    UI.ToggleAura(function(v)
        cfg.ligado = v if v then loop() elseif loopConexao then loopConexao:Disconnect() end
    end)
    task.wait(1)
    game.StarterGui:SetCore("SendNotification", {Title="✅ PRONTO", Text="UI de emergência aberta! Clica no botão verde pra ligar.", Duration=5})
end

end, debug.traceback)

-- ============================================================
-- ❌ SE QUALQUER COISA DER ERRADO — MOSTRA EXATAMENTE O QUE FOI
-- ============================================================
if not sucesso then
    warn("❌ ERRO NO SCRIPT: "..erro)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "❌ DEU ERRO",
            Text = string.sub(erro, 1, 80),
            Duration = 10
        })
        -- Cria UI de emergência mesmo com erro
        local UI = criarUIFallback()
        UI.ToggleAura(function(v) game.StarterGui:SetCore("SendNotification",{Title="Aviso",Text="Reexecute o script por favor"}) end)
    end)
end
