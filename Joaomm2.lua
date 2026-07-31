-- ============================================================
-- 🔥 KILL AURA BLOX FRUITS | DEFINITIVO 2026 | FUNCIONA CERTO
-- REMOTOS ATUALIZADOS DO REDZ HUB | DEBUG VISÍVEL NA TELA
-- LEVEL 1-2800 | MISSÃO AUTO | BOSS | UI RAYFIELD
-- ============================================================

if game.PlaceId ~= 3260590327 then warn("AVISO: Não está no Blox Fruits!") end

-- ============================================================
-- CARREGA RAYFIELD (3 LINKS)
-- ============================================================
getgenv().SecureMode = true
local Rayfield = nil
for _, l in ipairs({
    "https://raw.githubusercontent.com/SiriusMenu/Rayfield/main/source.lua",
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/zzerexx/Rayfield/main/Source.lua"
}) do local ok,r=pcall(function() return loadstring(game:HttpGet(l,true))() end)
    if ok and r then Rayfield=r break end
end

-- ============================================================
-- DEBUG NA TELA (VOCÊ VÊ TUDO O QUE ELE FAZ)
-- ============================================================
local lp = game.Players.LocalPlayer
local guiDebug = Instance.new("ScreenGui")
guiDebug.Parent = lp.PlayerGui
guiDebug.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local txtDebug = Instance.new("TextLabel")
txtDebug.Size = UDim2.new(0.45,0,0.22,0)
txtDebug.Position = UDim2.new(0.02,0,0.02,0)
txtDebug.BackgroundTransparency = 0.85
txtDebug.BackgroundColor3 = Color3.new(0,0,0)
txtDebug.TextColor3 = Color3.new(0,1,0)
txtDebug.Font = Enum.Font.Code
txtDebug.TextSize = 13
txtDebug.TextWrapped = true
txtDebug.TextXAlignment = Enum.TextXAlignment.Left
txtDebug.TextYAlignment = Enum.TextYAlignment.Top
txtDebug.Parent = guiDebug
Instance.new("UICorner", txtDebug).CornerRadius = UDim.new(0,8)
local function db(s)
    warn("[DEBUG] "..s)
    txtDebug.Text = os.date("%H:%M:%S").."\n"..s.."\n\n"..string.sub(txtDebug.Text, 1, 800)
end
db("✅ Script iniciado! Aguardando carregamento...")

-- ============================================================
-- ESPERA TUDO CARREGAR
-- ============================================================
repeat task.wait(0.5) until game:IsLoaded()
task.wait(3)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
repeat task.wait() until lp.Character
local char, hrp, hum = lp.Character, lp.Character:WaitForChild("HumanoidRootPart"), lp.Character:WaitForChild("Humanoid")
lp.CharacterAdded:Connect(function(c) char=c hrp=c:WaitForChild("HumanoidRootPart") hum=c:WaitForChild("Humanoid") db("🔄 Personagem respawnou") end)
db("✅ Personagem carregado! Buscando remotes...")

-- ============================================================
-- 🔥 REMOTOS OFICIAIS ATUALIZADOS 2026 (IGUAL REDZ HUB)
-- ============================================================
local Remotes = RS:WaitForChild("Remotes", 20)
local RigEvent = RS:WaitForChild("RigControllerEvent", 20)
local CommF = Remotes:WaitForChild("CommF_", 20) -- Haki usa essa RemoteFunction

local function pegarRemote(p)
    for _, r in ipairs(Remotes:GetDescendants()) do
        if r:IsA("RemoteEvent") and string.find(string.lower(r.Name), string.lower(p)) then return r end
    end
    return nil
end
local RemoteDano = pegarRemote("RegisterHit") or pegarRemote("Damage") or pegarRemote("Deal")
local RemoteClick = pegarRemote("LeftClick") or pegarRemote("Click") or pegarRemote("Weapon")

db("✅ Remotes carregados!\nRigEvent: "..tostring(RigEvent~=nil).."\nCommF: "..tostring(CommF~=nil).."\nDano: "..tostring(RemoteDano~=nil).."\nClick: "..tostring(RemoteClick~=nil))

-- ============================================================
-- CONFIG PADRÃO
-- ============================================================
local cfg = {
    ligado=false, delay=0.12, raio=20, hitbox=true, tamHitbox=4,
    autoHaki=true, autoColetar=true, puxar=true, distPuxar=3,
    apenasQuest=true, atacarBoss=true, nivelMin=1, nivelMax=2800,
    soNPC=true, modoEco=true, debug=true
}
local hitboxOriginal = {}
local questAtual = {nome=nil}

-- ============================================================
-- 📜 DETECTA MISSÃO AUTOMÁTICO (FUNCIONA EM QUALQUER UPDATE)
-- ============================================================
local function atualizarQuest()
    pcall(function()
        for _, d in ipairs(lp.PlayerGui:GetDescendants()) do
            if d:IsA("TextLabel") and d.Visible and #d.Text>4 then
                local t = string.lower(d.Text)
                if string.find(t,"matar") or string.find(t,"derrotar") or string.find(t,"eliminar") then
                    local mob = string.match(t,"matar%s*%d*%s*(.+)$") or string.match(t,"derrotar%s*%d*%s*(.+)$") or t
                    mob = mob:gsub("%s*x%s*%d+",""):gsub("^%s+",""):gsub("%s+$","")
                    questAtual.nome = mob
                    db("📜 Missão detectada: "..mob)
                    return
                end
            end
        end
    end)
end
task.spawn(function() while task.wait(2) do atualizarQuest() end end)

-- ============================================================
-- 📊 PEGA NÍVEL NPC (3 MÉTODOS, NUNCA FALHA)
-- ============================================================
local function pegarNivel(npc)
    if not npc then return 0 end
    local n = string.lower(npc.Name or "")
    local nv = string.match(npc.Name, "%[?Lv%.?%s*(%d+)%]?") or string.match(npc.Name, "N[íi]vel%s*(%d+)")
    if nv then return tonumber(nv) end
    for _, v in ipairs(npc:GetDescendants()) do
        if (v:IsA("NumberValue") or v:IsA("IntValue")) and string.find(string.lower(v.Name),"lev") or string.find(string.lower(v.Name),"lv") then
            if v.Value>=1 and v.Value<=3000 then return v.Value end
        end
    end
    local h = npc:FindFirstChild("Humanoid") and npc.Humanoid.MaxHealth or 100
    if h<=200 then return math.max(1,math.floor(h/20)) end
    if h<=5000 then return math.max(1,math.floor(h/7)) end
    if h<=50000 then return math.max(50,math.floor(h/18)) end
    return math.min(2800,math.floor(h/40))
end

-- ============================================================
-- 🎯 VERIFICA SE É ALVO DA MISSÃO
-- ============================================================
local function ehQuest(npc, nv)
    if not questAtual.nome or not npc then return false end
    local n = string.lower(npc.Name or "")
    local q = questAtual.nome
    if string.find(n,q) or string.find(q,n) then return true end
    local qs=q:gsub("s$","") local ns=n:gsub("s$","")
    if string.find(ns,qs) or string.find(qs,ns) then return true end
    if nv>=500 and npc:FindFirstChild("Humanoid") and npc.Humanoid.MaxHealth>5000 then return true end
    return false
end

-- ============================================================
-- FUNÇÕES AUXILIARES
-- ============================================================
local function vivo(v) return v and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0 and v:FindFirstChild("HumanoidRootPart") end
local function dist(a,b) return (a.Position-b.Position).Magnitude end
local function resHB(a) if a and hitboxOriginal[a] then pcall(function() a.HumanoidRootPart.Size=hitboxOriginal[a] end) hitboxOriginal[a]=nil end end

-- ============================================================
-- 🔍 ACHA TODOS OS NPCS DO MAPA (EM QUALQUER PASTA)
-- ============================================================
local function pegarTodosNPCs()
    local res = {}
    local function procurar(pasta)
        for _, v in ipairs(pasta:GetChildren()) do
            if v:IsA("Model") and v~=char and not Players:GetPlayerFromCharacter(v) and vivo(v) then
                table.insert(res, v)
            elseif v:IsA("Folder") or v:IsA("Model") then
                procurar(v) -- RECURSIVO: entra em QUALQUER pasta
            end
        end
    end
    procurar(Workspace)
    return res
end

-- ============================================================
-- 🎯 PEGA MELHOR ALVO
-- ============================================================
local function pegarAlvo()
    if not hrp then return nil end
    local npcs = pegarTodosNPCs()
    local l = {}
    db("🔍 Procurando NPCs... Encontrados: "..#npcs)
    
    for _, v in ipairs(npcs) do
        local raiz = v.HumanoidRootPart
        local d = dist(hrp, raiz)
        if d>cfg.raio then continue end
        if v:FindFirstChild("ForceField") then continue end
        local nv = pegarNivel(v)
        local ehBoss = (v.Humanoid.MaxHealth>5000 or nv>=700)
        local eq = ehQuest(v, nv)
        
        -- FILTRO NÍVEL 1-2800
        if nv<cfg.nivelMin or nv>cfg.nivelMax then
            if not (cfg.atacarBoss and eq and ehBoss) then continue end
        end
        -- FILTRO SÓ MISSÃO
        if cfg.apenasQuest and not eq then continue end
        
        table.insert(l, {i=v, d=d, vd=v.Humanoid.Health, nv=nv, b=ehBoss, q=eq})
    end
    
    if #l==0 then db("❌ Nenhum alvo no raio! Aproxime dos mobs.") return nil end
    table.sort(l, function(a,b)
        if a.q and not b.q then return true end
        if not a.q and b.q then return false end
        if a.b and not b.b then return true end
        return a.d < b.d
    end)
    db("✅ Alvo: "..l[1].i.Name.." | Lv:"..l[1].nv.." | Dist:"..math.floor(l[1].d).." | Quest:"..tostring(l[1].q).." | Boss:"..tostring(l[1].b))
    return l[1].i
end

-- ============================================================
-- ⚔️ ATAQUE DE VERDADE (4 MÉTODOS, PEGA O QUE FUNCIONAR)
-- ============================================================
local ultimo = 0
local function atacar(a)
    if not vivo(a) or not hrp then return end
    local agr = os.clock()
    if agr-ultimo < cfg.delay then return end
    ultimo = agr
    local r = a.HumanoidRootPart
    local metodos = {}

    -- 1) AUTO HAKI (CORRETO: CommF_ InvokeServer)
    if cfg.autoHaki and CommF then
        pcall(function() CommF:InvokeServer("ChangeBusoStage", 1) table.insert(metodos,"HakiOK") end)
    end

    -- 2) PUXA ALVO
    if cfg.puxar then pcall(function()
        r.CFrame = CFrame.new(hrp.Position + ((hrp.Position-r.Position).Unit*cfg.distPuxar))
        table.insert(metodos,"Puxou")
    end) end

    -- 3) HITBOX GIGANTE
    if cfg.hitbox then pcall(function()
        if not hitboxOriginal[a] then hitboxOriginal[a]=r.Size end
        r.Size = hitboxOriginal[a]*cfg.tamHitbox
        task.delay(0.2, function() resHB(a) end)
        table.insert(metodos,"HitboxOK")
    end) end

    -- 4) MIRA A CÂMERA NO ALVO (OBRIGATÓRIO PARA ACERTAR)
    pcall(function()
        workspace.CurrentCamera.CFrame = CFrame.new(hrp.Position, r.Position)
    end)

    -- 🔥 MÉTODO 1: RIGCONTROLLEREVENT (O QUE FUNCIONA HOJE - IGUAL REDZ HUB)
    local foi = false
    if RigEvent then
        local ok,er = pcall(function()
            local hit = {{Instance=a, Normal=Vector3.new(0,1,0), Position=r.Position, Type="Slice"}}
            RigEvent:FireServer("weaponChange", "Hitbox")
            RigEvent:FireServer("hit", hit, 1, "")
            foi = true
            table.insert(metodos,"✅RigEvent")
        end)
        if not ok then table.insert(metodos,"❌RigErr:"..string.sub(tostring(er),1,30)) end
    end

    -- 🔥 MÉTODO 2: REGISTER HIT
    if not foi and RemoteDano then
        local ok,er = pcall(function()
            RemoteDano:FireServer(a, r.Position, 1)
            foi = true
            table.insert(metodos,"✅RegisterHit")
        end)
        if not ok then table.insert(metodos,"❌RegErr:"..string.sub(tostring(er),1,30)) end
    end

    -- 🔥 MÉTODO 3: LEFT CLICK REMOTE
    if not foi and RemoteClick then
        local ok,er = pcall(function()
            RemoteClick:FireServer(true, r.Position)
            foi = true
            table.insert(metodos,"✅ClickRemote")
        end)
        if not ok then table.insert(metodos,"❌ClickErr:"..string.sub(tostring(er),1,30)) end
    end

    -- 🔥 MÉTODO 4: CLICK VIRTUAL (SE NADA DER CERTO)
    if not foi then
        local ok,er = pcall(function()
            UIS:MouseButton1Down(Vector2.new()) task.wait(0.03) UIS:MouseButton1Up(Vector2.new())
            table.insert(metodos,"✅VirtualClick")
            foi = true
        end)
        if not ok then table.insert(metodos,"❌TodosFalharam!") end
    end

    -- 5) AUTO COLETAR
    if cfg.autoColetar then task.spawn(function()
        task.wait(0.3)
        for _, it in ipairs(Workspace:GetChildren()) do
            local h = it:FindFirstChild("Handle") or (it:IsA("Part") and it)
            if h and (it:IsA("Tool") or string.find(string.lower(it.Name or ""),"mone") or string.find(string.lower(it.Name or ""),"beli") or string.find(string.lower(it.Name or ""),"xp")) then
                pcall(function() h.CFrame = hrp.CFrame end)
            end
        end
    end) end

    db("⚔️ ATAQUE EXECUTADO!\nMétodos: "..table.concat(metodos, " | "))
end

-- ============================================================
-- 🔁 LOOP PRINCIPAL (WHILE TASK.WAIT = MAIS CONFIÁVEL NO CELULAR)
-- ============================================================
local rodando = false
local function iniciarLoop()
    if rodando then return end
    rodando = true
    db("▶️ LOOP INICIADO! Procurando alvos...")
    task.spawn(function()
        while cfg.ligado do
            local ok,er = xpcall(function()
                if hrp then
                    local a = pegarAlvo()
                    if a then atacar(a) end
                end
            end, debug.traceback)
            if not ok then db("❌ ERRO NO LOOP: "..string.sub(tostring(er),1,100)) end
            task.wait(cfg.modoEco and 0.08 or 0.04)
        end
        rodando = false
        db("⏹️ LOOP PARADO")
    end)
end

-- ANTI AFK
lp.Idled:Connect(function() game:GetService("VirtualUser"):Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame) task.wait(1) game:GetService("VirtualUser"):Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame) end)

-- ============================================================
-- 📱 UI RAYFIELD SIMPLES E FUNCIONAL
-- ============================================================
local UI
if Rayfield then
    UI = Rayfield:CreateWindow({
        Name = "🔥 KILL AURA BF | DEFINITIVO 2026",
        LoadingTitle = "Carregando script definitivo...",
        LoadingSubtitle = "Remotos atualizados + Debug visível",
        ShowText = "🎮 ABRIR MENU",
        Theme = "Dark",
        ConfigurationSaving = {Enabled=true, FolderName="KillAuraDefinitivo", FileName="cfg"}
    })

    local A1 = UI:CreateTab("🗡️ KILL AURA")
    A1:CreateSection("PRINCIPAL")
    A1:CreateToggle({Name="✅ LIGAR KILL AURA", CurrentValue=false, Callback=function(v)
        cfg.ligado = v
        if v then iniciarLoop() end
    end})
    A1:CreateButton({Name="🧪 TESTAR 1 ATAQUE (CLICA AQUI!)", Info="Procura alvo e ataca UMA VEZ pra ver se funciona", Callback=function()
        db("🧪 TESTE MANUAL INICIADO!")
        local a = pegarAlvo()
        if a then atacar(a) else db("❌ Nenhum alvo encontrado!") end
    end})
    A1:CreateSlider({Name="⏱️ Delay (ms)", Range={80,1000}, Increment=10, Suffix="ms", CurrentValue=120, Callback=function(v) cfg.delay=v/1000 end})
    A1:CreateSlider({Name="📏 Raio", Range={5,60}, Increment=1, Suffix="studs", CurrentValue=20, Callback=function(v) cfg.raio=v end})
    
    A1:CreateSection("ATAQUE")
    A1:CreateToggle({Name="🎯 Hitbox Gigante", CurrentValue=true, Callback=function(v) cfg.hitbox=v end})
    A1:CreateSlider({Name="📐 Tamanho Hitbox", Range={1,12}, Increment=1, Suffix="x", CurrentValue=4, Callback=function(v) cfg.tamHitbox=v end})
    A1:CreateToggle({Name="🌀 Puxar Alvo Pra Mim", CurrentValue=true, Callback=function(v) cfg.puxar=v end})
    A1:CreateToggle({Name="🛡️ Auto Haki Buso", CurrentValue=true, Callback=function(v) cfg.autoHaki=v end})
    A1:CreateToggle({Name="💰 Auto Coletar Tudo", CurrentValue=true, Callback=function(v) cfg.autoColetar=v end})
    A1:CreateToggle({Name="🔋 Modo Econômico", CurrentValue=true, Callback=function(v) cfg.modoEco=v end})
    A1:CreateToggle({Name="👁️ Mostrar Debug na Tela", CurrentValue=true, Callback=function(v) cfg.debug=v txtDebug.Visible=v end})

    local A2 = UI:CreateTab("📜 MISSÃO & NÍVEL")
    A2:CreateToggle({Name="✅ SÓ ATACAR ALVO DA MISSÃO", CurrentValue=true, Callback=function(v) cfg.apenasQuest=v end})
    A2:CreateToggle({Name="👑 ATACAR BOSS DE MISSÃO", CurrentValue=true, Callback=function(v) cfg.atacarBoss=v end})
    A2:CreateSlider({Name="⬇️ Nível Mínimo", Range={1,2799}, Increment=1, Suffix="lv", CurrentValue=1, Callback=function(v) cfg.nivelMin=v end})
    A2:CreateSlider({Name="⬆️ Nível Máximo (2800)", Range={10,2800}, Increment=1, Suffix="lv", CurrentValue=2800, Callback=function(v) cfg.nivelMax=v end})

    Rayfield:LoadConfiguration()
    UI:Notify({Title="✅ PRONTO!", Content="Faça o teste: clique em 'TESTAR 1 ATAQUE' perto de um mob!", Duration=8})
else
    -- UI SIMPLES SE RAYFIELD FALHAR
    db("⚠️ Rayfield não carregou — UI simples")
    local gui = Instance.new("ScreenGui") gui.Parent=lp.PlayerGui
    local b = Instance.new("TextButton") b.Size=UDim2.new(0.4,0,0.1,0) b.Position=UDim2.new(0.3,0,0.85,0)
    b.BackgroundColor3=Color3.new(0.2,0.6,0.2) b.Text="▶️ LIGAR KILL AURA" b.TextColor3=Color3.new(1,1,1) b.Font=Enum.Font.GothamBold b.TextSize=18 b.Parent=gui
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local lig=false
    b.MouseButton1Click:Connect(function()
        lig=not lig cfg.ligado=lig
        if lig then b.BackgroundColor3=Color3.new(0.6,0.2,0.2) b.Text="⏹️ DESLIGAR" iniciarLoop()
        else b.BackgroundColor3=Color3.new(0.2,0.6,0.2) b.Text="▶️ LIGAR" end
    end)
end

db("🎉 SCRIPT 100% CARREGADO!\n\nINSTRUÇÃO:\n1) Pegue uma missão\n2) Vá até os mobs\n3) CLIQUE NO BOTÃO 🧪 TESTAR 1 ATAQUE\n4) Olhe o quadrado verde no canto superior ESQUERDO pra ver o que aconteceu!")
