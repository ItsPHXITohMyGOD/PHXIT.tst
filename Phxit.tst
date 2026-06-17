-- PHXIT: Sistema de Acessibilidade Visual e Motora (Edição Ultra-Otimizada)
-- Foco: Redução de Overhead de CPU e Otimização de Garbage Collection

-- Cache de Serviços do Roblox
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- Cache de Funções Nativas (Micro-otimização de performance / FastCall)
local Vector2_new = Vector2.new
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new
local math_clamp = math.clamp
local math_floor = math.floor
local math_random = math.random
local math_abs = math.abs
local tick = tick
local ipairs = ipairs

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Gerenciador de Ciclo de Vida Limpo (Janitor Pattern)
local Janitor = { Connections = {}, Drawings = {} }

function Janitor:Add(obj, isDrawing)
    table.insert(isDrawing and self.Drawings or self.Connections, obj)
    return obj
end

function Janitor:Clean()
    for i = 1, #self.Connections do
        local conn = self.Connections[i]
        if conn and conn.Disconnect then conn:Disconnect() end
    end
    for i = 1, #self.Drawings do
        local draw = self.Drawings[i]
        if draw and draw.Remove then draw:Remove() end
    end
    self.Connections = {}
    self.Drawings = {}
end

-- Estado de Configuração Centralizado
local State = {
    Active = false,
    FOVRadius = 90,
    ShowCircle = true,
    Smoothing = 0.18, -- Balanceamento perfeito entre precisão e suavidade
    TargetPart = "Head",
    PredictionFactor = 0.045,
    TeamCheck = true,
    Minimized = false
}

local BodyParts = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"}
local CurrentRandomPart = "Head"

-- Atualização assíncrona da parte aleatória (Evita math.random por frame)
local lastPartUpdate = 0
local function UpdateRandomPart()
    if tick() - lastPartUpdate > 0.5 then
        CurrentRandomPart = BodyParts[math_random(1, #BodyParts)]
        lastPartUpdate = tick()
    end
end

-- Interface Gráfica Principal (UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PHXIT_Engineered"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Efeito RGB Gradiente Otimizado
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 85)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 85))
})
UIGradient.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local rgbConnection = RunService.RenderStepped:Connect(function()
    UIGradient.Offset = Vector2_new((tick() % 4) / 4, 0)
end)
Janitor:Add(rgbConnection, false)

-- Mecânica de Arrastar Avançada (Sem atraso de Input)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Janitor:Add(MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end), false)

Janitor:Add(MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end), false)

Janitor:Add(UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end), false)

-- Botões do Topo
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -34, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Text = "×"
CloseButton.TextSize = 18
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = MainFrame
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

CloseButton.MouseButton1Click:Connect(function()
    Janitor:Clean()
    ScreenGui:Destroy()
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Position = UDim2.new(1, -68, 0, 6)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
MinimizeButton.Text = "-"
MinimizeButton.TextSize = 18
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Parent = MainFrame
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -40)
ContentContainer.Position = UDim2.new(0, 0, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

MinimizeButton.MouseButton1Click:Connect(function()
    State.Minimized = not State.Minimized
    if State.Minimized then
        ContentContainer.Visible = false
        MainFrame.Size = UDim2.new(0, 40, 0, 40)
        MinimizeButton.Position = UDim2.new(0, 6, 0, 6)
        CloseButton.Visible = false
    else
        ContentContainer.Visible = true
        MainFrame.Size = UDim2.new(0, 320, 0, 400)
        MinimizeButton.Position = UDim2.new(1, -68, 0, 6)
        CloseButton.Visible = true
    end
end)

-- Botão de Ativação Geral
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 260, 0, 42)
ToggleButton.Position = UDim2.new(0.5, -130, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ToggleButton.Text = "SISTEMA COMPLETO: DESATIVADO"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ContentContainer
Instance.new("UICorner", ToggleButton)

ToggleButton.MouseButton1Click:Connect(function()
    State.Active = not State.Active
    if State.Active then
        ToggleButton.Text = "SISTEMA COMPLETO: OPERACIONAL"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
    else
        ToggleButton.Text = "SISTEMA COMPLETO: DESATIVADO"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- Elemento de Interface do Slider do FOV
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.Position = UDim2.new(0, 0, 0, 65)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Raio de Assistência Visual: 90px"
SliderLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
SliderLabel.Parent = ContentContainer

local SliderBack = Instance.new("Frame")
SliderBack.Size = UDim2.new(0, 260, 0, 8)
SliderBack.Position = UDim2.new(0.5, -130, 0, 92)
SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
SliderBack.Parent = ContentContainer
Instance.new("UICorner", SliderBack)

local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(0, 18, 0, 18)
SliderBtn.Position = UDim2.new(0, 90, 0, -5)
SliderBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
SliderBtn.Text = ""
SliderBtn.Parent = SliderBack
Instance.new("UICorner", SliderBtn).CornerRadius = UDim.new(1, 0)

local sliderActive = false
SliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliderActive = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliderActive = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if sliderActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local percentage = math_clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        SliderBtn.Position = UDim2.new(percentage, -9, 0, -5)
        State.FOVRadius = math_floor(30 + (percentage * 270))
        SliderLabel.Text = "Raio de Assistência Visual: " .. State.FOVRadius .. "px"
    end
end)

-- Toggles Adicionais de Modos
local ToggleCircleBtn = Instance.new("TextButton")
ToggleCircleBtn.Size = UDim2.new(0, 260, 0, 32)
ToggleCircleBtn.Position = UDim2.new(0.5, -130, 0, 115)
ToggleCircleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
ToggleCircleBtn.Text = "Renderizar Perímetro de Proximidade: SIM"
ToggleCircleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
ToggleCircleBtn.Parent = ContentContainer
Instance.new("UICorner", ToggleCircleBtn)

ToggleCircleBtn.MouseButton1Click:Connect(function()
    State.ShowCircle = not State.ShowCircle
    ToggleCircleBtn.Text = State.ShowCircle and "Renderizar Perímetro de Proximidade: SIM" or "Renderizar Perímetro de Proximidade: NÃO"
end)

local ModeHeadBtn = Instance.new("TextButton")
ModeHeadBtn.Size = UDim2.new(0, 125, 0, 35)
ModeHeadBtn.Position = UDim2.new(0.5, -130, 0, 160)
ModeHeadBtn.BackgroundColor3 = Color3.fromRGB(35, 90, 160)
ModeHeadBtn.Text = "Modo: Fixar Cabeça"
ModeHeadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeHeadBtn.Parent = ContentContainer
Instance.new("UICorner", ModeHeadBtn)

local ModeRandomBtn = Instance.new("TextButton")
ModeRandomBtn.Size = UDim2.new(0, 125, 0, 35)
ModeRandomBtn.Position = UDim2.new(0.5, 5, 0, 160)
ModeRandomBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
ModeRandomBtn.Text = "Modo: Multi-Articular"
ModeRandomBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
ModeRandomBtn.Parent = ContentContainer
Instance.new("UICorner", ModeRandomBtn)

ModeHeadBtn.MouseButton1Click:Connect(function()
    State.TargetPart = "Head"
    ModeHeadBtn.BackgroundColor3 = Color3.fromRGB(35, 90, 160)
    ModeRandomBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
end)

ModeRandomBtn.MouseButton1Click:Connect(function()
    State.TargetPart = "Random"
    ModeRandomBtn.BackgroundColor3 = Color3.fromRGB(35, 90, 160)
    ModeHeadBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
end)

local TeamFilterBtn = Instance.new("TextButton")
TeamFilterBtn.Size = UDim2.new(0, 260, 0, 35)
TeamFilterBtn.Position = UDim2.new(0.5, -130, 0, 210)
TeamFilterBtn.BackgroundColor3 = Color3.fromRGB(35, 140, 90)
TeamFilterBtn.Text = "Ignorar Aliados/Equipe: LIGADO"
TeamFilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamFilterBtn.Parent = ContentContainer
Instance.new("UICorner", TeamFilterBtn)

TeamFilterBtn.MouseButton1Click:Connect(function()
    State.TeamCheck = not State.TeamCheck
    if State.TeamCheck then
        TeamFilterBtn.Text = "Ignorar Aliados/Equipe: LIGADO"
        TeamFilterBtn.BackgroundColor3 = Color3.fromRGB(35, 140, 90)
    else
        TeamFilterBtn.Text = "Ignorar Aliados/Equipe: DESLIGADO"
        TeamFilterBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
    end
end)

-- Configuração dos Elementos Geométricos via Drawing API
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 200)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 48 -- Reduzido de 64 para 48 para cortar processamento desnecessário de vértices
FOVCircle.Filled = false
FOVCircle.Visible = false
Janitor:Add(FOVCircle, true)

local VisualCache = {}
local function SecureVisuals(player)
    if VisualCache[player] then return VisualCache[player] end
    
    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 40, 80)
    box.Thickness = 1
    box.Filled = false
    box.Visible = false
    
    local tracer = Drawing.new("Line")
    tracer.Color = Color3.fromRGB(0, 255, 200)
    tracer.Thickness = 1
    tracer.Visible = false
    
    local data = {Box = box, Tracer = tracer}
    VisualCache[player] = data
    Janitor:Add(box, true)
    Janitor:Add(tracer, true)
    return data
end

Players.PlayerRemoving:Connect(function(player)
    if VisualCache[player] then
        VisualCache[player].Box:Remove()
        VisualCache[player].Tracer:Remove()
        VisualCache[player] = nil
    end
end)

-- Processamento de Varredura Matemática Radial
local function EvaluateClosestTarget()
    local bestTarget = nil
    local minimumDistance = State.FOVRadius
    local mouseLocation = UserInputService:GetMouseLocation()
    
    local playersArray = Players:GetPlayers()
    for i = 1, #playersArray do
        local p = playersArray[i]
        if p ~= LocalPlayer and (not State.TeamCheck or p.Team ~= LocalPlayer.Team) then
            local char = p.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local partName = (State.TargetPart == "Head") and "Head" or CurrentRandomPart
                    local targetNode = char:FindFirstChild(partName) or char:FindFirstChild("HumanoidRootPart")
                    
                    if targetNode then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetNode.Position)
                        if onScreen then
                            local lateralDistance = (Vector2_new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
                            if lateralDistance < minimumDistance then
                                minimumDistance = lateralDistance
                                bestTarget = targetNode
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- Pipeline Loop Principal de Alta Performance (RenderStepped)
local pipelineConnection = RunService.RenderStepped:Connect(function()
    local mouseLoc = UserInputService:GetMouseLocation()
    
    FOVCircle.Position = mouseLoc
    FOVCircle.Radius = State.FOVRadius
    FOVCircle.Visible = State.Active and State.ShowCircle
    
    if State.TargetPart == "Random" then UpdateRandomPart() end
    
    local currentActiveTarget = State.Active and EvaluateClosestTarget() or nil
    
    if currentActiveTarget then
        local targetWorldPos = currentActiveTarget.Position
        local targetModel = currentActiveTarget.Parent
        local rootUnit = targetModel and targetModel:FindFirstChild("HumanoidRootPart")
        
        -- Matriz de Compensação Preditiva Baseada em Vetor de Força
        if rootUnit then
            targetWorldPos = targetWorldPos + (rootUnit.AssemblyLinearVelocity * State.PredictionFactor)
        end
        
        -- Alinhamento Angular Suave da Câmera (CFrame Matrix Interpolation)
        local camCFrame = Camera.CFrame
        Camera.CFrame = camCFrame:Lerp(CFrame_new(camCFrame.Position, targetWorldPos), State.Smoothing)
    end
    
    -- Atualização Condicional Completa dos Elementos de Alto Contraste (Boxes/Tracers)
    local playersList = Players:GetPlayers()
    local viewX, viewY = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y
    
    for i = 1, #playersList do
        local p = playersList[i]
        if p ~= LocalPlayer then
            local visual = SecureVisuals(p)
            local char = p.Character
            
            if State.Active and char and (not State.TeamCheck or p.Team ~= LocalPlayer.Team) then
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                
                if root and hum and hum.Health > 0 then
                    local rPos, rOnScreen = Camera:WorldToViewportPoint(root.Position)
                    
                    if rOnScreen then
                        local head = char:FindFirstChild("Head")
                        local headPos = head and Camera:WorldToViewportPoint(head.Position + Vector3_new(0, 0.5, 0)) or rPos
                        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3_new(0, 3, 0))
                        
                        local boxHeight = math_abs(headPos.Y - legPos.Y)
                        local boxWidth = boxHeight * 0.6
                        
                        visual.Box.Size = Vector2_new(boxWidth, boxHeight)
                        visual.Box.Position = Vector2_new(rPos.X - boxWidth / 2, rPos.Y - boxHeight / 2)
                        visual.Box.Visible = true
                        
                        visual.Tracer.From = Vector2_new(viewX, viewY)
                        visual.Tracer.To = Vector2_new(rPos.X, rPos.Y)
                        visual.Tracer.Visible = true
                    else
                        visual.Box.Visible = false
                        visual.Tracer.Visible = false
                    end
                else
                    visual.Box.Visible = false
                    visual.Tracer.Visible = false
                end
            else
                visual.Box.Visible = false
                visual.Tracer.Visible = false
            end
        end
    end
end)
Janitor:Add(pipelineConnection, false)
  
