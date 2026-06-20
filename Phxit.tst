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

    local sliderHandle = Instance.new("TextButton", frame) -- Usamos TextButton para InputBegan/Ended
    sliderHandle.Size = UDim2.new(0, 20, 0, 20) -- Tamanho do handle
    sliderHandle.Position = UDim2.new(0, 5, 0, 25) -- Posição inicial
    sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Cor do handle
    sliderHandle.BorderSizePixel = 0
    Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(0, 5)
    sliderHandle.ZIndex = 5

    local draggingSlider = false

    -- Função para atualizar a posição do slider e o valor
    local function UpdateSlider(mouseX)
        local sliderBgAbsPos = sliderBg.AbsolutePosition.X
        local sliderBgAbsSize = sliderBg.AbsoluteSize.X
        local handleSize = sliderHandle.AbsoluteSize.X

        -- Calcula a posição X do mouse relativa ao sliderBg
        local relativeMouseX = mouseX - sliderBgAbsPos - handleSize / 2
        relativeMouseX = math.clamp(relativeMouseX, 0, sliderBgAbsSize - handleSize)

        -- Calcula a porcentagem e o novo valor
        local percentage = relativeMouseX / (sliderBgAbsSize - handleSize)
        local newValue = math.floor(minVal + (maxVal - minVal) * percentage / step + 0.5) * step
        Config[propName] = math.clamp(newValue, minVal, maxVal)

        -- Atualiza a posição visual do handle e os labels
        sliderHandle.Position = UDim2.new(0, relativeMouseX, 0, 25)
        label.Text = text .. ": " .. string.format("%.2f", Config[propName])
        valueLabel.Text = tostring(Config[propName])
        if callback then callback(Config[propName]) end
    end

    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            UpdateSlider(input.Position.X)
            randomDelay(0.02, 0.08, true) -- Delay ao iniciar drag do slider
        end
    end)

    sliderHandle.InputEnded:Connect(function()
        if draggingSlider then
            draggingSlider = false
            randomDelay(0.05, 0.15, true) -- Delay ao terminar drag do slider
        end
    end)

UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.MouseMovement or input.UserInputType == Enum.Touch) then
            UpdateSlider(input.Position.X)
        end
    end)

    -- Define a posição inicial do slider com base no valor configurado
    local initialPercentage = math.clamp((Config[propName] - minVal) / (maxVal - minVal), 0, 1)
    sliderHandle.Position = UDim2.new(initialPercentage, 0, 0, 25)

    table.insert(GUI_ELEMENTS, {Y = yOffset + 55 + 10, Frame = frame}) -- Adiciona Y e o frame para cálculo de posição
    return frame, label, valueLabel, sliderHandle
end

-- Criação dos Elementos da GUI Principal
local currentYOffset = 60 -- Posição inicial Y

-- Toggles
local AimbotBtn = CreateToggleBtn(Main, "AIMBOT", currentYOffset, "Aimbot")
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y
local AimLockBtn = CreateToggleBtn(Main, "AIMLOCK", currentYOffset, "AimLock")
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y
local ESPBtn = CreateToggleBtn(Main, "ESP", currentYOffset, "ESP", function(state)
    if not state then
        -- Desliga o ESP e remove todos os highlights quando desativado
        for plr, _ in pairs(ESPHighlights) do
            RemoveESP(plr)
        end
    end
end)
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y
local PredictionBtn = CreateToggleBtn(Main, "PREDICTION", currentYOffset, "Prediction")
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y
local RCSBtn = CreateToggleBtn(Main, "RCS", currentYOffset, "RCS")
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y
local TeamCheckBtn = CreateToggleBtn(Main, "TEAM CHECK", currentYOffset, "TeamCheck")
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y

-- Sliders
local FOVSlider, FOVLabel, _, _ = CreateSliderBtn(Main, "FOV", currentYOffset, "FOV", 20, 180, 5)
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y
local SmoothSlider, SmoothLabel, _, _ = CreateSliderBtn(Main, "SMOOTHNESS", currentYOffset, "Smoothness", 0.01, 0.5, 0.01)
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y
local PredictionSlider, PredictionLabel, _, _ = CreateSliderBtn(Main, "PREDICT FACTOR", currentYOffset, "PredictionFactor", 0.1, 1, 0.1)
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y
local RCSSlider, RCSLabel, _, _ = CreateSliderBtn(Main, "RCS STRENGTH", currentYOffset, "RCSStrength", 0, 1, 0.1)
currentYOffset = GUI_ELEMENTS[#GUI_ELEMENTS].Y

-- Botão para mostrar/esconder GUI
Hide.MouseButton1Click:Connect(function()
    randomDelay(0.1, 0.3, true)
    Main.Visible = false
    Mini.Visible = true
end)

-- ===============================
-- FOV CIRCLE VISUAL (Usando Drawing)
-- ===============================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Transparency = 0.3
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 100 -- Mais lados para um círculo mais suave
FOVCircle.Filled = false

-- ===============================
-- LOOP PRINCIPAL (RenderStepped Otimizado com Delays e Controle de Estado)
-- ===============================
local lastAimDirection = Vector3.new(0,0,0) -- Para RCS
local lastTargetAimPos = nil -- Posição que o aimbot tentou mirar no frame anterior

RunService.RenderStepped:Connect(function(deltaTime)
    -- Verifica se o script está liberado e o jogador/personagem está válido
    if not ScriptLiberado or not lpCharacter or not lpHumanoid or lpHumanoid.Health <= 0 then
        isAiming = false
        LockedTarget = nil
        FOVCircle.Visible = false
        return
    end

    -- Delay aleatório no início para discrição
    randomDelay(0.001, 0.005, true)

    -- Atualiza o ESP para todos os jogadores válidos
    if Cheats.ESP then
        for _, plr in ipairs(Players:GetPlayers()) do
            if IsValidTarget(plr) then
                ApplyESP(plr)
            else
                RemoveESP(plr) -- Remove ESP de alvos inválidos
            end
        end
    else
        -- Se o ESP for desativado, remove todos os highlights
        for plr, _ in pairs(ESPHighlights) do
            RemoveESP(plr)
        end
    end

    -- Atualiza o círculo do FOV
    FOVCircle.Visible = (Cheats.Aimbot or Cheats.AimLock) and Camera
    if FOVCircle.Visible then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Config.FOV
    end

    -- Lógica de controle do Aimbot e AimLock
    local bestTarget = nil
    local aimKeyPressed = UserInputService:IsKeyDown(Config.AimKey) or UserInputService:IsGamepadButtonDown(Config.AimKey)

    if aimKeyPressed then
        -- Se AimLock está ativo, tenta manter o alvo travado
        if Cheats.AimLock then
            if LockedTarget and IsValidTarget(LockedTarget.Player) then
                -- Reavalia se o alvo travado ainda é o melhor dentro do FOV
                local currentTargetScreenDist = (LockedTarget.ScreenPosition - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if currentTargetScreenDist > Config.FOV then
                    LockedTarget = nil -- Alvo saiu do FOV, busca novo
                else
                    bestTarget = LockedTarget -- Mantém o alvo travado
                end
            end
            -- Se não há alvo travado ou ele se tornou inválido, busca um novo
            if not bestTarget then
                bestTarget = FindBestTarget()
                if bestTarget then
                    LockedTarget = bestTarget -- Trava no novo alvo
                end
            end
-- Se Aimbot está ativo (e AimLock não), busca o melhor alvo a cada frame
        elseif Cheats.Aimbot then
            bestTarget = FindBestTarget()
        end
    else
        -- Se a tecla de mira não está pressionada, reseta o alvo travado
        LockedTarget = nil
        isAiming = false
    end

    -- Aplica a mira se um alvo válido foi encontrado e a tecla está pressionada
    if bestTarget and aimKeyPressed then
        isAiming = true
        local targetPos = bestTarget.PredictedPosition or bestTarget.Head.Position -- Usa posição prevista se disponível
        local characterAimOrigin = lpCharacter.Head.Position -- Ponto de origem da mira

        -- Calcula o vetor de mira
        local aimVector = (targetPos - characterAimOrigin).Unit
        local currentCameraCFrame = Camera.CFrame
        local lookVector = currentCameraCFrame.LookVector

        -- Calcula a diferença angular (em graus)
        local angleDifference = math.deg(math.acos(math.clamp(lookVector:Dot(aimVector), -1, 1)))

        -- Verifica se o alvo está dentro do FOV e tem linha de visão
        if angleDifference < Config.FOV and HasLineOfSight(currentCameraCFrame, targetPos, {lpCharacter}) then

            -- Interpolação suave (Aim Smoothing)
            local targetCFrame = CFrame.lookAt(characterAimOrigin, targetPos)
            local interpFactor = Config.Smoothness
            local newLookVector = lookVector:Lerp(targetCFrame.LookVector, interpFactor)
            local newCFrame = CFrame.new(characterAimOrigin, characterAimOrigin + newLookVector)

            -- Aplica o RCS (Recoil Control System)
            if Cheats.RCS then
                local currentAimDir = newCFrame.LookVector
                local aimDelta = targetPos - (characterAimOrigin + currentAimDir * 1000) -- Vetor da mira atual para o alvo
                local rcsOffset = aimDelta * Config.RCSStrength -- Força base do RCS

                -- Adiciona um pequeno movimento aleatório ao RCS para discrição
                local randomRCS = Vector3.new(math.random(-1,1), math.random(-1,1), math.random(-1,1)) * 0.05
                rcsOffset = rcsOffset + randomRCS:Clamp(1) -- Limita o offset aleatório

                -- Aplica o movimento do RCS de forma suave
                local rcsMove = rcsOffset * Config.Smoothness * 10 -- Escala o movimento do RCS pela suavidade
                local finalLookVector = (currentAimDir - rcsMove).Unit -- Subtrai o movimento do RCS

newCFrame = CFrame.new(characterAimOrigin, characterAimOrigin + finalLookVector)
            end

            -- Aplica a nova CFrame da câmera
            Camera.CFrame = newCFrame
            lastAimDirection = newCFrame.LookVector -- Salva para RCS no próximo frame
            lastTargetAimPos = targetPos -- Salva para referência
        else
            isAiming = false -- Alvo fora do FOV ou sem linha de visão
        end
    else
        -- Se a mira não está ativa, reseta variáveis
        isAiming = false
        LockedTarget = nil
        lastAimDirection = Vector3.new(0,0,0)
        lastTargetAimPos = nil
    end

    -- Atualiza os dados de predição de alvo para todos os jogadores
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character.Head then
            local data = TargetPredictionData[plr.Character]
            if not data then
                data = { LastPos = plr.Character.Head.Position, LastTime = tick(), Velocity = Vector3.new() }
                TargetPredictionData[plr.Character] = data
            end
            local currentTime = tick()
            local deltaTimePred = currentTime - data.LastTime
            if deltaTimePred > 0.1 then
                data.Velocity = (plr.Character.Head.Position - data.LastPos) / deltaTimePred
                data.LastPos = plr.Character.Head.Position
                data.LastTime = currentTime
            end
        end
    end

end)

- ===============================
-- LÓGICA DE INICIALIZAÇÃO E CONTROLE
-- ===============================

-- Função para verificar a chave e liberar o script
local function CheckKey()
    local keyInput = Box.Text
    if keyInput == VALID_KEY then
        ScriptLiberado = true
        KeyFrame:Destroy() -- Destroi a GUI de chave
        Main.Visible = true -- Mostra a GUI principal
        Mini.Visible = false -- Garante que o Mini PH está escondido
        -- Adiciona um pequeno delay antes de habilitar o loop principal
        randomDelay(0.5, 1.0, true)
        print("PHXIT v3.1 - Script liberado com sucesso!")
    else
        Box.PlaceholderText = "Key Incorreta!"
        Box.Text = "" -- Limpa a caixa
        Box.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        randomDelay(2, 3, true)
        Box.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Volta à cor normal
        Box.PlaceholderText = "Cole sua Key aqui"
    end
end

Confirm.MouseButton1Click:Connect(CheckKey)

-- Permite pressionar Enter para confirmar a chave
Box.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        CheckKey()
    end
end)

-- ===============================
-- LIMPEZA AO FECHAR O JOGO OU MORRER
-- ===============================
lp.CharacterRemoving:Connect(function()
    -- Reseta variáveis de estado
    LockedTarget = nil
    isAiming = false
    -- Remove todos os highlights de ESP quando o personagem é removido
    for _, highlight in pairs(ESPHighlights) do
        highlight:Destroy()
    end
    ESPHighlights = {}
    TargetPredictionData = {}

    -- Oculta a GUI principal e mostra o Mini PH
    if Main and Main.Parent then
        Main.Visible = false
    end
    if Mini and Mini.Parent then
        Mini.Visible = true
    end
end)

-- Conexão para garantir que o Mini PH apareça se o jogador renascer
lp.CharacterAdded:Connect(function(character)
    lpCharacter = character
    lpHumanoid = character:WaitForChild("Humanoid")
    -- Adiciona um pequeno delay para garantir que tudo carregou
    task.wait(0.5)
    if Mini and Mini.Parent then
        Mini.Visible = true
    end
end)

-- Garante que a GUI principal seja destruída se o script for descarregado de outra forma
ScreenGui.Destroying:Connect(function()
    if FOVCircle then FOVCircle:Destroy() end
    for _, highlight in pairs(ESPHighlights) do
        highlight:Destroy()
    end
    -- Limpa quaisquer outros objetos criados pelo script
end)

print("PHXIT v3.1 - Loader inicializado. Aguardando chave...")
