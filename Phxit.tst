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

-- ===============================
-- CONFIGURAÇÕES GERAIS E ANTI-BAN (Simulado)
-- ===============================
local VALID_KEY = "PH.DS25567" -- Mantenha a sua chave
local ScriptLiberado = false
local DISCORD_LINK = "https://discord.gg/xE3xxzAcH3" -- Mantenha o link do seu Discord

-- Funções de ofuscação (básicas, mais para estética)
local function _G(data) return HttpService:JSONEncode(data) end
local function _D(data) return HttpService:JSONDecode(data) end

-- Simulação de delay humano
local function randomDelay(min, max)
    local delayTime = math.random() * (max - min) + min
    task.wait(delayTime)
end

-- Variação de espera para tarefas
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
ScreenGui.DisplayOrder = 1000
ScreenGui.Parent = lp:WaitForChild("PlayerGui")

-- ===============================
-- FUNÇÕES DE UTILIDADE DA GUI
-- ===============================
local function RGBStroke(ui, thickness)
    thickness = thickness or 1.5
    local stroke = Instance.new("UIStroke", ui)
    stroke.Thickness = thickness
    stroke.Color = Color3.fromRGB(255,255,255)
    ui:GetPropertyChangedSignal("Parent"):Connect(function()
        if not ui.Parent then stroke:Destroy() end
    end)

    task.spawn(function()
        local h = 0
        while ui.Parent and stroke.Parent do
            h = (h + 0.02) % 1
            stroke.Color = Color3.fromHSV(h, 0.9, 1)
            task.wait(0.03)
        end
    end)
    return stroke
end

local function MakeDraggable(frame, parentFrame)
    local dragging, dragStart, startPos
    local frameRect = Rect.new(0, 0, frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
    local parentRect = parentFrame and Rect.new(0,0,parentFrame.AbsoluteSize.X, parentFrame.AbsoluteSize.Y) or Rect.new(0,0,Camera.ViewportSize.X, Camera.ViewportSize.Y)

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.AbsolutePosition
            frame.ZIndex = 100
            randomDelay(0.05, 0.15) -- Pequeno delay ao iniciar drag
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            frame.ZIndex = 1
            randomDelay(0.05, 0.15) -- Pequeno delay ao terminar drag
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.MouseMovement or input.UserInputType == Enum.Touch) then
            local delta = input.Position - dragStart
            local newAbsolutePos = startPos + delta
            local clampedAbsolutePos = Vector2.new(math.clamp(newAbsolutePos.X, 0, parentRect.Width - frameRect.Width),
                                                   math.clamp(newAbsolutePos.Y, 0, parentRect.Height - frameRect.Height))
            frame.AbsolutePosition = clampedAbsolutePos
        end
    end)
end

-- ===============================
-- KEY GUI
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
        randomDelay(1, 1.5)
        DiscordBtn.Text = "DISCORD"
    else
        DiscordBtn.Text = "ERRO"
        randomDelay(1, 1.5)
        DiscordBtn.Text = "DISCORD"
    end
end)

-- ===============================
-- GUI PRINCIPAL
-- ===============================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(320, 480) -- Aumentado para mais opções e sliders
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
Hide.Position = UDim2.fromOffset(285, 5)
Hide.Text = "-"
Hide.Font = Enum.Font.GothamBold
Hide.TextSize = 18
Hide.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Hide.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Hide).CornerRadius = UDim.new(0, 8)
Hide.ZIndex = 5

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.fromOffset(250, 5)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)
Close.ZIndex = 5

Close.MouseButton1Click:Connect(function()
    randomDelay(0.1, 0.3) -- Delay ao fechar
    ScreenGui:Destroy()
end)

-- ===============================
-- MINI PH
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

-- ===============================
-- CHEAT ESTADOS E CONFIGURAÇÕES
-- ===============================
local Cheats = {
    Aimbot = false,
    AimLock = false,
    ESP = false,
    Prediction = false,
    RCS = false
}
local Config = {
    FOV = 100,
    Smoothness = 0.08, -- Valor padrão mais rápido
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPTransparency = 0.4,
    ESPOutlineColor = Color3.fromRGB(255, 255, 255),
    ESPOutlineTransparency = 0,
    RCSStrength = 0.5,
    PredictionFactor = 0.2
}
local LockedTarget = nil
local ESPs = {}
local lastTargetPos = {}
local lastTargetTime = {}
local lastCameraCFrame = Camera.CFrame -- Para calcular movimento da câmera

-- ===============================
-- FUNÇÕES DE UTILIDADE DO CHEAT
-- ===============================

local function IsValidTarget(plr)
    if not plr or not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid") then return false end
    local hum = plr.Character.Humanoid
    if hum.Health <= 0 then return false end
    if plr.Character:FindFirstChildOfClass("ForceField") then return false end
    if lp.Team and plr.Team and lp.Team == plr.Team then return false end
    return true
end

local function HasLineOfSight(origin, targetPos, ignoreList)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = ignoreList or {}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local direction = targetPos - origin
    local distance = direction.Magnitude
    if distance > 500 then return false end
    local ray = workspace:Raycast(origin, direction, params)
    return not ray
end

local function GetPredictedTargetPosition(targetChar)
    if not targetChar or not targetChar.Head then return nil end

    local currentTime = tick()
    local lastPos = lastTargetPos[targetChar]
    local lastT = lastTargetTime[targetChar]

    if lastPos and lastT and currentTime - lastT < 0.5 then
        local velocity = (targetChar.Head.Position - lastPos) / (currentTime - lastT)
        local predictedPos = targetChar.Head.Position + velocity * Config.PredictionFactor
        return predictedPos
    else
        return targetChar.Head.Position
    end
end

local function FindBestTarget()
    local bestTarget = nil
    local minDistSq = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Adiciona um pequeno delay aleatório na busca de alvos
    randomDelay(0.01, 0.05)

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsValidTarget(plr) and plr.Character.Head then
            local targetHeadPos = plr.Character.Head.Position
            local screenPos, isVisible = Camera:WorldToViewportPoint(targetHeadPos)

            if isVisible then
                local distToScreenCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

                if distToScreenCenter < Config.FOV then
                    local predictedPos = targetHeadPos
                    if Cheats.Prediction then
                        predictedPos = GetPredictedTargetPosition(plr.Character) or targetHeadPos
                    end

                    if HasLineOfSight(Camera.CFrame.Position, predictedPos, {lp.Character}) then
                        local distWorldSq = (Camera.CFrame.Position - predictedPos).Magnitude^2
                        if distWorldSq < minDistSq then
                            minDistSq = distWorldSq
                            bestTarget = {
                                Player = plr,
                                Position = predictedPos,
                                Head = plr.Character.Head
                            }
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- ===============================
-- ESP FUNCIONAL MELHORADO
-- ===============================
local function ApplyESP(plr)
    if not Cheats.ESP or not plr or not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    if not IsValidTarget(plr) then RemoveESP(plr); return end

    local highlight = ESPs[plr]
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "PHXIT_ESP"
        highlight.Adornee = plr.Character
        highlight.FillColor = Config.ESPColor
        highlight.FillTransparency = Config.ESPTransparency
        highlight.OutlineColor = Config.ESPOutlineColor
        highlight.OutlineTransparency = Config.ESPOutlineTransparency
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = workspace
        ESPs[plr] = highlight
    else
        highlight.Adornee = plr.Character
    end
end

function RemoveESP(plr)
    if ESPs[plr] then
        ESPs[plr]:Destroy()
        ESPs[plr] = nil
    end
end

-- ===============================
-- BOTÕES E SLIDERS DA GUI
-- ===============================
local function CreateToggleBtn(text, y, stateVarName, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.fromOffset(280, 35)
    btn.Position = UDim2.fromOffset(20, y)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.ZIndex = 5

    local currentState = Cheats[stateVarName]
    btn.Text = text .. (currentState and ": ON" or ": OFF")

    btn.MouseButton1Click:Connect(function()
        randomDelay(0.1, 0.3) -- Delay ao clicar
        Cheats[stateVarName] = not Cheats[stateVarName]
        btn.Text = text .. (Cheats[stateVarName] and ": ON" or ": OFF")
        if callback then callback(Cheats[stateVarName]) end
    end)
    return btn
end

local function CreateSliderBtn(text, y, propName, minVal, maxVal, step)
    local frame = Instance.new("Frame", Main)
    frame.Size = UDim2.fromOffset(280, 50) -- Aumentado para acomodar o label
    frame.Position = UDim2.fromOffset(20, y)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    frame.ZIndex = 5

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -10, 0, 20) -- Ocupa quase toda a largura, 20 de altura
    label.Position = UDim2.new(0, 5, 0, 5)
    label.Text = text .. ": " .. tostring(Config[propName])
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(0, 225, 0, 5) -- Posição ajustada
    valueLabel.Text = tostring(Config[propName])
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local slider = Instance.new("TextButton", frame)
    slider.Size = UDim2.new(1, -10, 0, 20) -- Ocupa a largura disponível menos margem
    slider.Position = UDim2.new(0, 5, 0, 25) -- Abaixo do label
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 5)
    slider.ZIndex = 6

    local draggingSlider = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            local relativeX = input.Position.X - slider.AbsolutePosition.X
            local percentage = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            local newValue = math.floor(minVal + (maxVal - minVal) * percentage / step + 0.5) * step
            Config[propName] = math.clamp(newValue, minVal, maxVal)
            label.Text = text .. ": " .. Config[propName]
            valueLabel.Text = tostring(Config[propName])
            randomDelay(0.02, 0.08) -- Delay ao iniciar drag do slider
        end
    end)

    slider.InputEnded:Connect(function()
        draggingSlider = false
        randomDelay(0.05, 0.15) -- Delay ao terminar drag do slider
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.MouseMovement or input.UserInputType == Enum.Touch) then
            local relativeX = input.Position.X - slider.AbsolutePosition.X
            local percentage = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
            local newValue = math.floor(minVal + (maxVal - minVal) * percentage / step + 0.5) * step
            Config[propName] = math.clamp(newValue, minVal, maxVal)
            label.Text = text .. ": " .. Config[propName]
            valueLabel.Text = tostring(Config[propName])
        end
    end)

    local initialPercentage = (Config[propName] - minVal) / (maxVal - minVal)
    slider.Size = UDim2.new(initialPercentage, 0, 0, 20)

    return frame, label, valueLabel, slider
end

-- Botões e Sliders
local AimbotBtn = CreateToggleBtn("AIMBOT", 60, "Aimbot")
local AimLockBtn = CreateToggleBtn("AIMLOCK", 110, "AimLock")
local ESPBtn = CreateToggleBtn("ESP", 160, "ESP")
local PredictionBtn = CreateToggleBtn("PREDICTION", 210, "Prediction")
local RCSBtn = CreateToggleBtn("RCS", 260, "RCS")

local FOVSlider, FOVLabel, _, FOVThumb = CreateSliderBtn("FOV", 310, "FOV", 20, 180, 5)
local SmoothSlider, SmoothLabel, _, SmoothThumb = CreateSliderBtn("SMOOTHNESS", 370, "Smoothness", 0.01, 0.5, 0.01)
local PredictionSlider, PredictionLabel, _, PredictionThumb = CreateSliderBtn("PREDICT FACTOR", 430, "PredictionFactor", 0.1, 1, 0.1)
local RCSSlider, RCSLabel, _, RCSThumb = CreateSliderBtn("RCS STRENGTH", 490, "RCSStrength", 0, 1, 0.1)

-- ===============================
-- FOV CIRCLE VISUAL
-- ===============================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Transparency = 0.3
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 100
FOVCircle.Filled = false

-- ===============================
-- LOOP PRINCIPAL (RenderStepped Otimizado com Delays)
-- ===============================
local lastTargetData = nil -- Para manter o alvo se não houver um novo
local cameraMoveDelta = CFrame.new() -- Para cálculo de movimento da câmera

RunService.RenderStepped:Connect(function(deltaTime) -- deltaTime pode ser útil para aprimorar a interpolação
    if not ScriptLiberado then return end

    -- Pequeno delay aleatório no início de cada frame RenderStepped
    randomDelay(0.001, 0.005)

    -- Atualiza ESP
    if Cheats.ESP then
        for _, plr in ipairs(Players:GetPlayers()) do
            ApplyESP(plr)
        end
    else
        for plr, highlight in pairs(ESPs) do
            if not IsValidTarget(plr) then highlight:Destroy(); ESPs[plr] = nil end
        end
    end

    -- Atualiza círculo do FOV
    FOVCircle.Visible = Cheats.Aimbot or Cheats.AimLock
    if FOVCircle.Visible then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Config.FOV
    end

    local targetData = nil
    local targetHeadPos = nil
    local currentCameraCFrame = Camera.CFrame

    -- Lógica de Seleção de Alvo
    if Cheats.AimLock then
        -- Se o alvo travado atual não é mais válido, busca um novo
        if not LockedTarget or not IsVali
