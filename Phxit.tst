--[[ PHXIT - GUI NOVA (CHEAT) | v3.1 - Max Performance & Discrição ]]

-- ===============================
-- SERVIÇOS
-- ===============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local lpCharacter = lp:WaitForChild("Character")
local lpHumanoid = lpCharacter:WaitForChild("Humanoid")

-- ===============================
-- CONFIGURAÇÕES GERAIS E ANTI-BAN (Simulado)
-- ===============================
local VALID_KEY = "PH.DS25567" -- Mantenha a sua chave
local ScriptLiberado = false
local DISCORD_LINK = "https://discord.gg/xE3xxzAcH3" -- Mantenha o link do seu Discord

-- Funções de ofuscação (básicas, mais para estética e evitar detecção simples)
local function _G(data) return HttpService:JSONEncode(data) end
local function _D(data) return HttpService:JSONDecode(data) end

-- Simulação de delay humano mais robusta e integrada
local function randomDelay(min, max, useTaskWait)
    local delayTime = math.random() * (max - min) + min
    if useTaskWait then
        task.wait(delayTime)
    else
        wait(delayTime)
    end
end

-- Variação de espera para tarefas, com base em um tempo base
local function randomizeWait(baseWait)
    local variation = baseWait * math.random(80, 120) / 100
    task.wait(variation)
end

-- ===============================
-- SCREEN GUI
-- ===============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PHXIT_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1000 -- Garante que fique no topo
ScreenGui.Parent = lp:WaitForChild("PlayerGui")

-- ===============================
-- FUNÇÕES DE UTILIDADE DA GUI (Otimizadas)
-- ===============================
local function RGBStroke(ui, thickness)
    thickness = thickness or 1.5
    local stroke = Instance.new("UIStroke", ui)
    stroke.Thickness = thickness
    stroke.Color = Color3.fromRGB(255,255,255) -- Cor inicial
    stroke.LineJoinMode = Enum.LineJoinMode.Round -- Mais suave

    -- Conexão para destruir o stroke quando o pai for destruído
    ui:GetPropertyChangedSignal("Parent"):Connect(function()
        if not ui.Parent then stroke:Destroy() end
    end)

    -- Efeito RGB dinâmico
    local hue = 0
    task.spawn(function()
        while ui.Parent and stroke.Parent do
            hue = (hue + 0.02) % 1 -- Garante que hue fique entre 0 e 1
            stroke.Color = Color3.fromHSV(hue, 0.9, 1)
            randomDelay(0.02, 0.05, true) -- Delay curto para suavidade
        end
    end)
    return stroke
end

local function MakeDraggable(frame, parentFrame)
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = Vector2.new()
    local frameRect = Rect.new(0, 0, frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
    local parentRect = parentFrame and Rect.new(0,0,parentFrame.AbsoluteSize.X, parentFrame.AbsoluteSize.Y) or Rect.new(0,0,Camera.ViewportSize.X, Camera.ViewportSize.Y)
    local zIndexBase = frame.ZIndex -- Guarda o ZIndex original

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.AbsolutePosition
            frame.ZIndex = 100 -- Traz para frente ao arrastar
            randomDelay(0.05, 0.15, true) -- Pequeno delay ao iniciar drag
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then -- Somente se estava arrastando
                dragging = false
                frame.ZIndex = zIndexBase -- Volta ao ZIndex original
                randomDelay(0.05, 0.15, true) -- Pequeno delay ao terminar drag
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.MouseMovement or input.UserInputType == Enum.Touch) then
            local delta = input.Position - dragStart
            local newAbsolutePos = startPos + delta
            -- Garante que o frame fique dentro dos limites do pai
            local clampedAbsolutePos = Vector2.new(
                math.clamp(newAbsolutePos.X, 0, parentRect.Width - frameRect.Width),
                math.clamp(newAbsolutePos.Y, 0, parentRect.Height - frameRect.Height)
            )
            frame.AbsolutePosition = clampedAbsolutePos
        end
    end)
end

-- ===============================
-- KEY GUI (Otimizada)
-- ===============================
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.fromOffset(350, 250)
KeyFrame.Position = UDim2.fromScale(0.35, 0.3)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyFrame.BorderSizePixel = 0
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 14)
RGBStroke(KeyFrame, 2)
MakeDraggable(KeyFrame)

local TitleLabel = Instance.new("TextLabel", KeyFrame)
TitleLabel.Size = UDim2.fromScale(1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 10)
TitleLabel.Text = "PHXIT LOADER"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundTransparency = 1

local Box = Instance.new("TextBox", KeyFrame)
Box.Size = UDim2.fromOffset(280, 40)
Box.Position = UDim2.fromOffset(35, 70)
Box.PlaceholderText = "Cole sua Key aqui"
Box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Box.TextColor3 = Color3.new(1, 1, 1)
Box.Font = Enum.Font.Gotham
Box.TextSize = 14
Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 10)
Box.TextStrokeTransparency = 1
Box.ZIndex = 5
Box.ClearTextOnFocus = false -- Não limpar o texto ao focar

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.fromOffset(280, 40)
Confirm.Position = UDim2.fromOffset(35, 130)
Confirm.Text = "VALIDAR KEY"
Confirm.Font = Enum.Font.GothamBold
Confirm.TextSize = 16
Confirm.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
Confirm.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0, 10)
Confirm.ZIndex = 5

local DiscordBtn = Instance.new("TextButton", KeyFrame)
DiscordBtn.Size = UDim2.fromOffset(280, 35)
DiscordBtn.Position = UDim2.fromOffset(35, 190)
DiscordBtn.Text = "DISCORD"
DiscordBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
DiscordBtn.TextColor3 = Color3.new(1, 1, 1)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 14
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 10)
DiscordBtn.ZIndex = 5

DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_LINK)
        DiscordBtn.Text = "COPIADO ✅"
        randomDelay(1, 1.5, true)
        DiscordBtn.Text = "DISCORD"
    else
        DiscordBtn.Text = "ERRO"
        randomDelay(1, 1.5, true)
        DiscordBtn.Text = "DISCORD"
    end
end)

-- ===============================
-- GUI PRINCIPAL (Refatorada e Expandida)
-- ===============================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(350, 550) -- Tamanho maior para mais opções
Main.Position = UDim2.fromScale(0.05, 0.35)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Visible = false
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
RGBStroke(Main, 2)
MakeDraggable(Main)

local MainTitle = Instance.new("TextLabel", Main)
MainTitle.Size = UDim2.fromScale(1, 0)
MainTitle.Position = UDim2.new(0, 0, 0, 10)
MainTitle.Text = "PHXIT MENU v3.1"
MainTitle.Font = Enum.Font.GothamBold
MainTitle.TextSize = 20
MainTitle.TextColor3 = Color3.new(1, 1, 1)
MainTitle.BackgroundTransparency = 1

local Hide = Instance.new("TextButton", Main)
Hide.Size = UDim2.fromOffset(30, 30)
Hide.Position = UDim2.fromOffset(315, 5) -- Posição ajustada
Hide.Text = "-"
Hide.Font = Enum.Font.GothamBold
Hide.TextSize = 18
Hide.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Hide.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Hide).CornerRadius = UDim.new(0, 8)
Hide.ZIndex = 5

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.fromOffset(280, 5) -- Posição ajustada
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)
Close.ZIndex = 5

Close.MouseButton1Click:Connect(function()
    randomDelay(0.1, 0.3, true) -- Delay ao fechar
    ScreenGui:Destroy()
    -- Adicionar qualquer cleanup necessário aqui
end)

-- ===============================
-- MINI PH (Para minimizar GUI)
-- ===============================
local Mini = Instance.new("Frame", ScreenGui)
Mini.Size = UDim2.fromOffset(60, 60)
Mini.Position = UDim2.fromScale(0.05, 0.5)
Mini.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Mini.Visible = false
Mini.BorderSizePixel = 0
Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 14)
RGBStroke(Mini, 2)
MakeDraggable(Mini)

local PH = Instance.new("TextButton", Mini)
PH.Size = UDim2.new(1, 0, 1, 0)
PH.Text = "PH"
PH.BackgroundTransparency = 1
PH.TextColor3 = Color3.new(1, 1, 1)
PH.Font = Enum.Font.GothamBold
PH.TextSize = 25
PH.ZIndex = 5

PH.MouseButton1Click:Connect(function()
    randomDelay(0.1, 0.3, true)
    Main.Visible = true
    Mini.Visible = false
end)

-- ===============================
-- CHEAT ESTADOS E CONFIGURAÇÕES (Estrutura mais organizada)
-- ===============================
local Cheats = {
    Aimbot = false,
    AimLock = false,
    ESP = false,
    Prediction = false,
    RCS = false,
    TeamCheck = true, -- Novo: Habilitar/Desabilitar Teamcheck
}
local Config = {
    FOV = 100,
    Smoothness = 0.08,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPTransparency = 0.4,
    ESPOutlineColor = Color3.fromRGB(255, 255, 255),
    ESPOutlineTransparency = 0,
    RCSStrength = 0.5,
    PredictionFactor = 0.2, -- Fator de interpolação para predição
    AimKey = Enum.KeyCode.ButtonR1, -- Gamepad Right Bumper (pode ser mudado)
    ESPDrawMode = "Box", -- "Box", "Outline"
}

-- Variáveis de estado do cheat
local LockedTarget = nil -- Armazena o alvo travado pelo AimLock
local ESPHighlights = {} -- Armazena instâncias de Highlight para ESP
local TargetPredictionData = {} -- Armazena dados para cálculo de predição de alvo
local lastCameraCFrame = Camera.CFrame -- Para cálculo de movimento da câmera
local isAiming = false -- Indica se o aimbot está ativo no frame atual

-- ===============================
-- FUNÇÕES DE UTILIDADE DO CHEAT (Otimizadas)
-- ===============================

local function IsValidTarget(targetPlayer)
    -- Verifica se o jogador alvo é válido
    if not targetPlayer or targetPlayer == lp then return false end
    local targetChar = targetPlayer.Character
    if not targetChar or not targetChar:FindFirstChildOfClass("Humanoid") then return false end
    local targetHumanoid = targetChar.Humanoid
    if targetHumanoid.Health <= 0 then return false end
    -- Evita alvos com ForceField (comum em alguns jogos)
    if targetChar:FindFirstChildOfClass("ForceField") then return false end
    -- Team Check: Se ativado, não mira em aliados
    if Cheats.TeamCheck and lp.Team and targetPlayer.Team and lp.Team == targetPlayer.Team then return false end
    return true
end

local function HasLineOfSight(originCFrame, targetPosition, ignoreInstances)
    -- Otimizado: Usa CFrame para origin e verifica distância máxima
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = ignoreInstances or {}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.IgnoreWater = true -- Ignora água para raycasts

    local direction = targetPosition - originCFrame.Position
    local distance = direction.Magnitude

    -- Limita a distância máxima do raycast para performance
    if distance > 600 then return false end

    local ray = workspace:Raycast(originCFrame.Position, direction, params)

    -- Retorna true se não houver hit ou se o hit for o próprio alvo (indicando linha de visão clara)
    return not ray or ray.Instance:IsDescendantOf(targetPosition.Parent) -- Assumindo que targetPosition é a posição da cabeça
end

local function GetPredictedTargetPosition(targetChar, headPart)
    -- Calcula a posição futura do alvo com base em sua velocidade e direção
    local currentTime = tick()
    local data = TargetPredictionData[targetChar]

    if not data then
        data = { LastPos = headPart.Position, LastTime = currentTime, Velocity = Vector3.new() }
        TargetPredictionData[targetChar] = data
    end

    local deltaTime = currentTime - data.LastTime
    if deltaTime > 0.1 then -- Atualiza a velocidade se passou tempo suficiente
        data.Velocity = (headPart.Position - data.LastPos) / deltaTime
        data.LastPos = headPart.Position
        data.LastTime = currentTime
    end

    -- Calcula a posição prevista
    local predictedPos = headPart.Position + data.Velocity * Config.PredictionFactor
    return predictedPos
end

local function FindBestTarget()
    local bestTarget = nil
    local minDistSqToScreenCenter = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Adiciona um pequeno delay aleatório na busca de alvos para discrição
    randomDelay(0.01, 0.05, true)

    -- Itera sobre os jogadores de forma eficiente
    for _, plr in ipairs(Players:GetPlayers()) do
        if IsValidTarget(plr) then
            local targetChar = plr.Character
            local targetHead = targetChar and targetChar.Head
            if targetHead then
                local predictedPos = targetHead.Position -- Posição padrão
                if Cheats.Prediction then
                    predictedPos = GetPredictedTargetPosition(targetChar, targetHead) or targetHead.Position
                end

                local success, screenPos = pcall(Camera.WorldToViewportPoint, Camera, predictedPos)
                if success and screenPos.Z > 0 then -- Verifica se está na frente da câmera
                    local screenVec = Vector2.new(screenPos.X, screenPos.Y)
                    local distToScreenCenter = (screenVec - screenCenter).Magnitude

                    -- Filtro de FOV
                    if distToScreenCenter < Config.FOV then
                        -- Verifica linha de visão com base na posição prevista
                        if HasLineOfSight(Camera.CFrame, predictedPos, {lpCharacter}) then
                            -- Se for o melhor alvo até agora, atualiza
                            if distToScreenCenter < minDistSqToScreenCenter then
                                minDistSqToScreenCenter = distToScreenCenter
                                bestTarget = {
                                    Player = plr,
                                    Character = targetChar,
                                    Head = targetHead,
                                    PredictedPosition = predictedPos,
                                    ScreenPosition = screenVec
                                }
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- ===============================
-- ESP FUNCIONAL MELHORADO (Usando Highlight)
-- ===============================
local function ApplyESP(targetPlayer)
    if not Cheats.ESP or not IsValidTarget(targetPlayer) then
        RemoveESP(targetPlayer)
        return
    end

    local highlight = ESPHighlights[targetPlayer]
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "PHXIT_ESP"
        highlight.Adornee = targetPlayer.Character -- Aplica o highlight ao personagem
        highlight.FillColor = Config.ESPColor
        highlight.FillTransparency = Config.ESPTransparency
        highlight.OutlineColor = Config.ESPOutlineColor
        highlight.OutlineTransparency = Config.ESPOutlineTransparency
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Sempre visível
        highlight.Parent = workspace
        ESPHighlights[targetPlayer] = highlight
    else
        -- Atualiza o Adornee caso o personagem tenha sido recriado
        highlight.Adornee = targetPlayer.Character
    end
end

function RemoveESP(targetPlayer)
    if ESPHighlights[targetPlayer] then
        ESPHighlights[targetPlayer]:Destroy()
        ESPHighlights[targetPlayer] = nil
    end
end

-- ===============================
-- BOTÕES E SLIDERS DA GUI (Otimizados e Refatorados)
-- ===============================
local GUI_ELEMENTS = {} -- Para gerenciar a posição dos elementos

local function CreateToggleBtn(parent, text, yOffset, stateVarName, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.fromOffset(280, 35)
    btn.Position = UDim2.fromOffset(20, yOffset)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.ZIndex = 5

    local currentState = Cheats[stateVarName]
    btn.Text = text .. (currentState and ": ON" or ": OFF")
    btn.BackgroundColor3 = currentState and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 50, 50) -- Cor baseada no estado

    btn.MouseButton1Click:Connect(function()
        randomDelay(0.1, 0.3, true) -- Delay ao clicar
        local newState = not Cheats[stateVarName]
        Cheats[stateVarName] = newState
        btn.Text = text .. (newState and ": ON" or ": OFF")
        btn.BackgroundColor3 = newState and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 50, 50)
        if callback then callback(newState) end
    end)
    table.insert(GUI_ELEMENTS, {Y = yOffset + 35 + 10, Frame = btn}) -- Adiciona Y e o elemento para cálculo de posição
    return btn
end

local function CreateSliderBtn(parent, text, yOffset, propName, minVal, maxVal, step, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.fromOffset(280, 55) -- Aumentado para acomodar label e slider
    frame.Position = UDim2.fromOffset(20, yOffset)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    frame.ZIndex = 5

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.Text = text .. ": " .. string.format("%.2f", Config[propName]) -- Formata para 2 casas decimais
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(0, 225, 0, 5)
    valueLabel.Text = tostring(Config[propName])
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local sliderBg = Instance.new("Frame", frame) -- Fundo do slider
    sliderBg.Size = UDim2.new(1, -10, 0, 20)
    sliderBg.Position = UDim2.new(0, 5, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 5)
    sliderBg.ZIndex = 4 -- Fica atrás do handle

    local sliderHandle = Instance.new("TextButton", frame) -- Usamos TextButton pa
