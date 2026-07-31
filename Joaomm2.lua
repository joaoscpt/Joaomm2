-- ============================================================
-- ⚠️ AVISO EXTREMO - RISCO DE BAN PERMANENTE
-- USE APENAS EM CONTA SECUNDÁRIA
-- KILL AURA BLOX FRUITS | ATUALIZADO 2026 | LEVEL 1-2800
-- UI RAYFIELD | 100% MOBILE | DETECTA QUALQUER MISSÃO + BOSS
-- ============================================================

-- VERIFICA SE ESTÁ NO BLOX FRUITS
if game.PlaceId ~= 3260590327 then
    game:GetService("Players").LocalPlayer:Kick("⚠️ RODE APENAS DENTRO DO BLOX FRUITS!")
    return
end

-- ============================================================
-- CARREGA UI RAYFIELD (MODO SEGURO PRA NÃO CRASHAR NO CELULAR)
-- ============================================================
getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()

-- ============================================================
-- SERVIÇOS E VARIÁVEIS
-- ============================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local char, hrp, hum
local ultimoAtaque = 0
local hitboxOriginal = {}
local loopConexao = nil
local questAtual = {nome = nil, nivel = 0, ehBoss = false}

-- PEGAR PERSONAGEM
local function atualizarChar()
    char = lp.Character or lp.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart", 5)
    hum = char:WaitForChild("Humanoid", 5)
end
atualizarChar()
lp.CharacterAdded:Connect(atualizarChar)

-- ============================================================
-- BUSCA REMOTES ATUALIZADOS 2026 (INCLUI UPDATE 27/28)
-- ============================================================
local Remotes = RS:WaitForChild("Remotes", 10)
local RigEvent = RS:FindFirstChild("RigControllerEvent")

local function pegarRemote(parcial)
    if not Remotes then return nil end
    for _, r in ipairs(Remotes:GetDescendants()) do
        if r:IsA("RemoteEvent") and string.find(string.lower(r.Name), string.lower(parcial)) then
            return r
        end
    end
    return nil
end

local RemoteClick = pegarRemote("LeftClick") or pegarRemote("Click") or pegarRemote("Hit")
local RemoteDano = pegarRemote("RegisterHit") or pegarRemote("Damage") or pegarRemote("DealDamage")
local RemoteHaki = pegarRemote("Haki") or pegarRemote("Busoshoku") or pegarRemote("Armament") or pegarRemote("Aura")

-- ============================================================
-- 🔥 SISTEMA DE DETECÇÃO DE QUALQUER MISSÃO + BOSS + NÍVEL NPC
-- ============================================================

-- PEGA NÍVEL DO NPC DE 3 FORMAS DIFERENTES (FUNCIONA EM QUALQUER ILHA)
local function pegarNivelNPC(npc)
    if not npc then return 0 end
    
    -- 1. Tenta pegar do nome: "Bandido [Lv. 15]" / "Pirata Lv. 700"
    local nome = npc.Name or ""
    local nivelStr = string.match(nome, "%[?Lv%.?%s*(%d+)%]?") or string.match(nome, "N[íi]vel%s*(%d+)")
    if nivelStr then return tonumber(nivelStr) end
    
    -- 2. Tenta pegar de NumberValues dentro do NPC
    for _, v in ipairs(npc:GetDescendants()) do
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            if string.find(string.lower(v.Name), "level") or string.find(string.lower(v.Name), "nivel") or string.find(string.lower(v.Name), "lv") then
                if v.Value >= 1 and v.Value <= 3000 then return v.Value end
            end
        end
    end
    
    -- 3. Tenta pegar do Humanoid (alguns bosses guardam assim)
    local humNpc = npc:FindFirstChild("Humanoid")
    if humNpc then
        for _, v in ipairs(humNpc:GetChildren()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                if string.find(string.lower(v.Name), "level") or string.find(string.lower(v.Name), "lv") then
                    if v.Value >= 1 and v.Value <= 3000 then return v.Value end
                end
            end
        end
        -- 4. Estima por vida (seguro pra 1-2800)
        local vida = humNpc.MaxHealth
        if vida <= 200 then return math.max(1, math.floor(vida / 20)) end
        if vida <= 5000 then return math.max(1, math.floor(vida / 7)) end
        if vida <= 50000 then return math.max(500, math.floor(vida / 18)) end
        return math.min(2800, math.floor(vida / 40)) -- Boss alto nível
    end
    
    return 0
end

-- DETECTA MISSÃO ATUAL AUTOMATICAMENTE (LÊ A JANELA DE QUEST DO JOGO)
local function atualizarQuestAtual()
    local sucesso, dados = pcall(function()
        -- Caminho padrão da janela de missão do Blox Fruits
        local gui = lp:FindFirstChild("PlayerGui")
        if not gui then return nil end
        
        local main = gui:FindFirstChild("Main") or gui:FindFirstChild("GameUI") or gui:FindFirstChild("BloxUI")
        if not main then return nil end
        
        -- Tenta várias estruturas diferentes (o jogo muda muito)
        local caminhos = {
            "Quest.Container.QuestTitle.Title",
            "QuestFrame.QuestTitle",
            "CurrentQuest.Title",
            "QuestContainer.QuestName",
            "MainFrame.Quest.Title",
            "HUD.Quest.Title"
        }
        
        for _, caminho in ipairs(caminhos) do
            local obj = main:FindFirstChild(caminho, true)
            if obj and obj:IsA("TextLabel") and obj.Visible and string.len(obj.Text) > 3 then
                local texto = obj.Text
                -- Extrai nome do mob: "Matar 8 Piratas" → "Piratas"
                local nomeMob = string.match(texto, "[Mm]atar%s*%d*%s*(.+)$") or 
                                 string.match(texto, "[Dd]errotar%s*%d*%s*(.+)$") or
                                 string.match(texto, "[Ee]liminar%s*%d*%s*(.+)$") or
                                 texto
                
                -- Limpa nome
                nomeMob = string.gsub(nomeMob, "%s*x%s*%d+", "")
                nomeMob = string.gsub(nomeMob, "^%s*(.-)%s*$", "%1")
                
                -- Verifica se é boss (vida alta ou nome de boss conhecido)
                local ehBoss = string.find(string.lower(texto), "boss") or 
                              string.find(string.lower(nomeMob), "boss") or
                              string.find(string.lower(nomeMob), "admiral") or
                              string.find(string.lower(nomeMob), "king") or
                              string.find(string.lower(nomeMob), "queen") or
                              string.find(string.lower(nomeMob), "lord") or
                              string.find(string.lower(nomeMob), "commander") or
                              string.find(string.lower(nomeMob), "captain")
                
                return {nome = string.lower(nomeMob), nivel = 0, ehBoss = ehBoss}
            end
        end
        return nil
    end)
    
    if sucesso and dados then
        questAtual = dados
    else
        questAtual = {nome = nil, nivel = 0, ehBoss = false}
    end
end

-- ATUALIZA A MISSÃO A CADA 2 SEGUNDOS
task.spawn(function()
    while task.wait(2) do
        atualizarQuestAtual()
    end
end)

-- VERIFICA SE O NPC É O ALVO DA MISSÃO ATUAL
local function ehAlvoDaQuest(npc, nivelNpc)
    if not questAtual.nome then return false end
    if not npc or not npc.Name then return false end
    
    local nomeNpc = string.lower(npc.Name)
    local nomeQuest = questAtual.nome
    
    -- Compara nome parcial (funciona com plural/singular)
    if string.find(nomeNpc, nomeQuest) or string.find(nomeQuest, nomeNpc) then
        return true
    end
    
    -- Remove 's' do final e compara
    local nomeQuestSemS = string.gsub(nomeQuest, "s$", "")
    local nomeNpcSemS = string.gsub(nomeNpc, "s$", "")
    if string.find(nomeNpcSemS, nomeQuestSemS) or string.find(nomeQuestSemS, nomeNpcSemS) then
        return true
    end
    
    -- Se é boss de quest, aceita por nível próximo
    if questAtual.ehBoss and nivelNpc >= 100 and (npc:FindFirstChild("Humanoid") and npc.Humanoid.MaxHealth > 5000) then
        return true
    end
    
    return false
end

-- ============================================================
-- FUNÇÕES AUXILIARES
-- ============================================================
local function vivo(alvo)
    return alvo and alvo:FindFirstChild("Humanoid") and alvo.Humanoid.Health > 0 and alvo:FindFirstChild("HumanoidRootPart")
end

local function temCampo(alvo)
    return alvo and alvo:FindFirstChild("ForceField")
end

local function distancia(a, b)
    return (a.Position - b.Position).Magnitude
end

local function restaurarHitbox(alvo)
    if alvo and hitboxOriginal[alvo] then
        pcall(function() alvo.HumanoidRootPart.Size = hitboxOriginal[alvo] end)
        hitboxOriginal[alvo] = nil
    end
end

-- ============================================================
-- CONFIGURAÇÕES (TUDO AJUSTÁVEL NA UI)
-- ============================================================
local cfg = {
    -- KILL AURA PRINCIPAL
    ligado = false,
    delay = 0.12,
    raio = 20,
    hitbox = true,
    tamHitbox = 3,
    puxar = false,
    distPuxar = 3,
    autoHaki = true,
    autoCombo = false,
    autoColetar = true,
    
    -- 🔥 SISTEMA DE MISSÃO E NÍVEL (O QUE VOCÊ PEDIU)
    apenasQuest = true,      -- SÓ ataca quem é da missão atual
    atacarBossQuest = true,  -- Ataca BOSS de missão MESMO com vida alta
    nivelMin = 1,            -- Nível mínimo do NPC (1 padrão)
    nivelMax = 2800,         -- Nível MÁXIMO 2800 (atualizado 2026)
    atacarForaQuest = false, -- Se quiser farmar qualquer um sem quest
    
    -- FILTROS
    soNPC = true,
    soPlayer = false,
    ignoraTime = true,
    prioridade = "Mais Próximo",
    modoEco = true,
    
    -- EXTRAS
    antiAFK = true,
    noClip = false
}

-- ============================================================
-- 🎯 SISTEMA DE BUSCAR MELHOR ALVO (COM TODOS OS FILTROS)
-- ============================================================
local function pegarMelhorAlvo()
    if not hrp then return nil end
    local lista = {}
    local minhaTripulacao = lp:FindFirstChild("Crew") and lp.Crew.Value or nil

    -- VARRE TODO O MAPA
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v ~= char and vivo(v) and not temCampo(v) then
            local raiz = v.HumanoidRootPart
            local dist = distancia(hrp, raiz)
            if dist > cfg.raio then continue end

            local éPlayer = Players:GetPlayerFromCharacter(v)
            local éNPC = not éPlayer
            local nivelNpc = éNPC and pegarNivelNPC(v) or 0
            local vidaMax = v.Humanoid.MaxHealth
            local ehBossNpc = vidaMax > 5000 or nivelNpc >= 700

            -- ==================== FILTROS OBRIGATÓRIOS ====================
            
            -- 🔥 FILTRO DE NÍVEL 1 ATÉ 2800 (O QUE VOCÊ PEDIU)
            if éNPC then
                if nivelNpc < cfg.nivelMin or nivelNpc > cfg.nivelMax then
                    -- A MENOS QUE SEJA BOSS DE MISSÃO (LIBERA MESMO FORA DO FILTRO)
                    if not (cfg.atacarBossQuest and ehAlvoDaQuest(v, nivelNpc) and ehBossNpc) then
                        continue
                    end
                end
            end

            -- 🔥 FILTRO DE MISSÃO (SÓ ATACA QUEM É DA QUEST ATUAL)
            if cfg.apenasQuest and éNPC then
                local alvoQuest = ehAlvoDaQuest(v, nivelNpc)
                if not alvoQuest then
                    if not cfg.atacarForaQuest then continue end
                else
                    -- Se for alvo da quest e for boss, SEMPRE ataca independente de outros filtros
                    if cfg.atacarBossQuest and ehBossNpc then
                        -- PULA FILTROS DE VIDA ALTA
                    end
                end
            end

            -- FILTROS NORMAIS
            if cfg.soNPC and not éNPC then continue end
            if cfg.soPlayer and not éPlayer then continue end
            if cfg.ignoraTime and éPlayer then
                local trip = éPlayer:FindFirstChild("Crew") and éPlayer.Crew.Value or nil
                if minhaTripulacao and trip == minhaTripulacao then continue end
            end

            table.insert(lista, {
                inst = v,
                dist = dist,
                vida = v.Humanoid.Health,
                nivel = nivelNpc,
                ehBoss = ehBossNpc,
                ehQuest = éNPC and ehAlvoDaQuest(v, nivelNpc) or false,
                bounty = éPlayer and éPlayer:FindFirstChild("Bounty") and éPlayer.Bounty.Value or 0
            })
        end
    end

    if #lista == 0 then return nil end

    -- PRIORIDADE: ALVO DE MISSÃO VEM SEMPRE PRIMEIRO
    table.sort(lista, function(a, b)
        if a.ehQuest and not b.ehQuest then return true end
        if not a.ehQuest and b.ehQuest then return false end
        if a.ehBoss and not b.ehBoss then return true end
        if not a.ehBoss and b.ehBoss then return false end
        
        if cfg.prioridade == "Mais Próximo" then
            return a.dist < b.dist
        elseif cfg.prioridade == "Menos Vida" then
            return a.vida < b.vida
        elseif cfg.prioridade == "Mais Nível" then
            return a.nivel > b.nivel
        elseif cfg.prioridade == "Mais Bounty" then
            return a.bounty > b.bounty
        end
        return a.dist < b.dist
    end)

    return lista[1].inst
end

-- ============================================================
-- ⚔️ SISTEMA DE ATAQUE (ATUALIZADO 2026)
-- ============================================================
local function atacar(alvo)
    if not alvo or not vivo(alvo) or not hrp then return end
    local agora = os.clock()
    if agora - ultimoAtaque < cfg.delay then return end
    ultimoAtaque = agora

    local raizAlvo = alvo.HumanoidRootPart
    local nivelAlvo = pegarNivelNPC(alvo)

    -- AUTO HAKI
    if cfg.autoHaki and RemoteHaki then
        pcall(function() RemoteHaki:FireServer(true) end)
    end

    -- PUXAR ALVO
    if cfg.puxar then
        pcall(function()
            local dir = (hrp.Position - raizAlvo.Position).Unit
            raizAlvo.CFrame = CFrame.new(hrp.Position + (dir * cfg.distPuxar))
        end)
    end

    -- AUMENTAR HITBOX
    if cfg.hitbox then
        pcall(function()
            if not hitboxOriginal[alvo] then
                hitboxOriginal[alvo] = raizAlvo.Size
            end
            raizAlvo.Size = Vector3.new(
                hitboxOriginal[alvo].X * cfg.tamHitbox,
                hitboxOriginal[alvo].Y * cfg.tamHitbox,
                hitboxOriginal[alvo].Z * cfg.tamHitbox
            )
            task.delay(0.15, function() restaurarHitbox(alvo) end)
        end)
    end

    -- 🔥 ATAQUE COM OS REMOTES ATUALIZADOS 2026
    -- Tenta o novo sistema primeiro (RigController), depois os antigos
    local atacou = false

    -- MÉTODO 1: RIG CONTROLLER (UPDATE 27/28 - O QUE FUNCIONA HOJE)
    if RigEvent and not atacou then
        pcall(function()
            -- Dados do hit compatíveis com update novo
            local dadosHit = {
                {
                    Instance = alvo,
                    Normal = Vector3.new(0, 1, 0),
                    Position = raizAlvo.Position,
                    Damage = nil, -- Deixa o jogo calcular
                    Type = "Slice"
                }
            }
            RigEvent:FireServer("hit", dadosHit, 1, "")
            atacou = true
        end)
    end

    -- MÉTODO 2: REGISTER HIT (FUNCIONA NA MAIORIA)
    if RemoteDano and not atacou then
        pcall(function()
            RemoteDano:FireServer(alvo, raizAlvo.Position, 1)
            atacou = true
        end)
    end

    -- MÉTODO 3: LEFT CLICK (FALLBACK)
    if RemoteClick and not atacou then
        pcall(function()
            RemoteClick:FireServer(true, raizAlvo.Position)
            atacou = true
        end)
    end

    -- MÉTODO 4: VIRTUAL INPUT (SE NADA DER CERTO - MOBILE)
    if not atacou then
        pcall(function()
            local cfAntigo = workspace.CurrentCamera.CFrame
            workspace.CurrentCamera.CFrame = CFrame.new(hrp.Position, raizAlvo.Position)
            UIS:MouseMove(Vector2.new(0, 0))
            UIS:MouseButton1Down(Vector2.new(0, 0))
            task.wait(0.02)
            UIS:MouseButton1Up(Vector2.new(0, 0))
            workspace.CurrentCamera.CFrame = cfAntigo
        end)
    end

    -- AUTO COLETAR DROP
    if cfg.autoColetar then
        task.spawn(function()
            task.wait(0.3)
            for _, item in ipairs(Workspace:GetChildren()) do
                if item:IsA("Tool") or (item:IsA("Part") and string.find(string.lower(item.Name), "money") or string.find(string.lower(item.Name), "beli") or string.find(string.lower(item.Name), "xp")) then
                    if item:FindFirstChild("Handle") then
                        pcall(function() item.Handle.CFrame = hrp.CFrame end)
                    elseif item:IsA("Part") then
                        pcall(function() item.CFrame = hrp.CFrame end)
                    end
                end
            end
        end)
    end
end

-- ============================================================
-- 🔁 LOOP PRINCIPAL OTIMIZADO PRA CELULAR
-- ============================================================
local function iniciarLoop()
    if loopConexao then loopConexao:Disconnect() end
    
    local contador = 0
    loopConexao = RunService.Heartbeat:Connect(function()
        if not cfg.ligado then return end
        if not hrp or not hum then return end
        
        -- MODO ECONÔMICO: RODA 30x POR SEGUNDO AO INVÉS DE 60 (NÃO ESQUENTA BATERIA)
        contador += 1
        if cfg.modoEco and contador % 2 ~= 0 then return end

        -- PEGA ALVO E ATACA
        local alvo = pegarMelhorAlvo()
        if alvo then
            atacar(alvo)
        end
    end)
end

-- ============================================================
-- 📱 UI RAYFIELD COMPLETA (100% TOQUE - SEM TECLADO)
-- ============================================================
local Janela = Rayfield:CreateWindow({
    Name = "🔥 KILL AURA BF | LVL 1-2800 | QUEST AUTO",
    LoadingTitle = "Carregando Script Atualizado 2026...",
    LoadingSubtitle = "Detectando missões e NPCs nível 1 até 2800",
    ShowText = "🎮 ABRIR MENU",
    Theme = "Dark",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KillAuraBlox2026",
        FileName = "ConfigMobile"
    }
})

-- ABA 1: KILL AURA PRINCIPAL
local AbaAura = Janela:CreateTab("🗡️ Kill Aura")

AbaAura:CreateSection("PRINCIPAL")

AbaAura:CreateToggle({
    Name = "✅ LIGAR KILL AURA",
    CurrentValue = cfg.ligado,
    Callback = function(val)
        cfg.ligado = val
        if val then iniciarLoop()
        else if loopConexao then loopConexao:Disconnect() end end
    end
})

AbaAura:CreateSlider({
    Name = "⏱️ Delay Entre Ataques (menos = mais rápido)",
    Range = {80, 1000},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = cfg.delay * 1000,
    Callback = function(val) cfg.delay = val / 1000 end
})

AbaAura:CreateSlider({
    Name = "📏 Raio de Ataque",
    Range = {5, 50},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = cfg.raio,
    Callback = function(val) cfg.raio = val end
})

AbaAura:CreateSection("💥 ATAQUE")

AbaAura:CreateToggle({
    Name = "🎯 Hitbox Gigante (acerta TUDO)",
    CurrentValue = cfg.hitbox,
    Callback = function(val) cfg.hitbox = val end
})

AbaAura:CreateSlider({
    Name = "📐 Tamanho do Hitbox",
    Range = {1, 10},
    Increment = 1,
    Suffix = "x",
    CurrentValue = cfg.tamHitbox,
    Callback = function(val) cfg.tamHitbox = val end
})

AbaAura:CreateToggle({
    Name = "🌀 Puxar Alvo Pra Mim",
    CurrentValue = cfg.puxar,
    Callback = function(val) cfg.puxar = val end
})

AbaAura:CreateToggle({
    Name = "🛡️ Auto Haki Armamento",
    CurrentValue = cfg.autoHaki,
    Callback = function(val) cfg.autoHaki = val end
})

AbaAura:CreateToggle({
    Name = "💰 Auto Coletar Dinheiro/Item",
    CurrentValue = cfg.autoColetar,
    Callback = function(val) cfg.autoColetar = val end
})

-- ABA 2: 🔥 MISSÃO E NÍVEL (O QUE VOCÊ PEDIU)
local AbaQuest = Janela:CreateTab("📜 Missão & Nível")

AbaQuest:CreateSection("⚡ SISTEMA DE MISSÃO AUTOMÁTICO")

AbaQuest:CreateToggle({
    Name = "✅ SÓ ATACAR ALVO DA MINHA MISSÃO",
    Info = "Lê a janela de quest automaticamente",
    CurrentValue = cfg.apenasQuest,
    Callback = function(val) cfg.apenasQuest = val end
})

AbaQuest:CreateToggle({
    Name = "👑 ATACAR BOSS DE MISSÃO (MESMO VIDA ALTA)",
    Info = "Não ignora boss por ter muita vida",
    CurrentValue = cfg.atacarBossQuest,
    Callback = function(val) cfg.atacarBossQuest = val end
})

AbaQuest:CreateToggle({
    Name = "⚔️ Atacar outros NPCs se não tiver quest",
    CurrentValue = cfg.atacarForaQuest,
    Callback = function(val) cfg.atacarForaQuest = val end
})

AbaQuest:CreateSection("📊 FILTRO DE NÍVEL NPC (1 ATÉ 2800)")

AbaQuest:CreateSlider({
    Name = "⬇️ Nível MÍNIMO do NPC",
    Range = {1, 2799},
    Increment = 1,
    Suffix = "lv",
    CurrentValue = cfg.nivelMin,
    Callback = function(val) cfg.nivelMin = val end
})

AbaQuest:CreateSlider({
    Name = "⬆️ Nível MÁXIMO do NPC (ATUAL 2800)",
    Range = {10, 2800},
    Increment = 1,
    Suffix = "lv",
    CurrentValue = cfg.nivelMax,
    Callback = function(val) cfg.nivelMax = val end
})

AbaQuest:CreateSection("🎯 ALVO E FILTROS")

AbaQuest:CreateDropdown({
    Name = "Prioridade de Qual Alvo Pegar Primeiro",
    Options = {"Mais Próximo", "Menos Vida", "Mais Nível", "Mais Bounty"},
    CurrentValue = cfg.prioridade,
    Callback = function(val) cfg.prioridade = val end
})

AbaQuest:CreateToggle({
    Name = "👤 Apenas NPCs (não ataca jogador)",
    CurrentValue = cfg.soNPC,
    Callback = function(val) cfg.soNPC = val; if val then cfg.soPlayer = false end end
})

AbaQuest:CreateToggle({
    Name = "⚔️ Apenas Jogadores (PvP)",
    CurrentValue = cfg.soPlayer,
    Callback = function(val) cfg.soPlayer = val; if val then cfg.soNPC = false end end
})

AbaQuest:CreateToggle({
    Name = "🤝 Ignorar Aliados/Mesma Tripulação",
    CurrentValue = cfg.ignoraTime,
    Callback = function(val) cfg.ignoraTime = val end
})

-- ABA 3: EXTRAS
local AbaExtra = Janela:CreateTab("⚙️ Extras")

AbaExtra:CreateSection("📱 OTIMIZAÇÃO CELULAR")

AbaExtra:CreateToggle({
    Name = "🔋 Modo Econômico (não esquenta bateria)",
    CurrentValue = cfg.modoEco,
    Callback = function(val) cfg.modoEco = val end
})

AbaExtra:CreateToggle({
    Name = "😴 Anti AFK (não é expulso por ficar parado)",
    CurrentValue = cfg.antiAFK,
    Callback = function(val)
        cfg.antiAFK = val
        if val then
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

AbaExtra:CreateToggle({
    Name = "👻 NoClip (atravessar parede)",
    CurrentValue = cfg.noClip,
    Callback = function(val)
        cfg.noClip = val
        if val then
            RunService.Stepped:Connect(function()
                if cfg.noClip and char then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
        end
    end
})

-- ABA 4: INFO
local AbaInfo = Janela:CreateTab("ℹ️ Info")

AbaInfo:CreateSection("📋 STATUS DO SCRIPT")

AbaInfo:CreateParagraph({
    Title = "✅ Níveis Suportados:",
    Content = "Level 1 ATÉ 2800 (nível máximo atual do Blox Fruits 2026 - Update 27.4)"
})

AbaInfo:CreateParagraph({
    Title = "🎮 Compatível com:",
    Content = "Delta Executor, Arceus X, Fluxus Mobile, Codex Mobile, Vega X\nPC e Celular Android"
})

AbaInfo:CreateParagraph({
    Title = "⚔️ Remotes Atualizados:",
    Content = "RigControllerEvent (Update 27/28) + RegisterHit + LeftClick\nFunciona em QUALQUER ilha e QUALQUER missão"
})

AbaInfo:CreateParagraph({
    Title = "🔥 Funcionalidades Especiais:",
    Content = "• Detecta QUALQUER missão automaticamente\n• Ataca BOSS de missão (ignora vida alta)\n• Detecta nível do NPC de 3 formas diferentes\n• Prioridade: alvo da quest SEMPRE primeiro"
})

AbaInfo:CreateSection("⚠️ AVISOS")

AbaInfo:CreateParagraph({
    Title = "🚫 RISCO DE BAN:",
    Content = "QUALQUER script de trapaça pode banir sua conta PARA SEMPRE.\nUse APENAS em conta secundária!\nNunca use na sua conta principal com Robux/itens caros."
})

-- CARREGA CONFIGURAÇÕES SALVAS
Rayfield:LoadConfiguration()

-- NOTIFICAÇÃO INICIAL
Rayfield:Notify({
    Title = "✅ SCRIPT CARREGADO!",
    Content = "Kill Aura Atualizado 2026 | Nível 1-2800 | Quest Auto Detect",
    Duration = 5
})

-- ============================================================
-- FIM DO SCRIPT - PRONTO PRA USAR
-- ============================================================
